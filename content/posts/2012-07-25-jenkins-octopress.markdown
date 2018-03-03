---
layout: post
title: "Jenkins@さくらVPSにOctopressのデプロイを任せてみる"
date: 2012-07-29
comments: true
external-url: 
tags: [sakura, octopress, jenkins]
aliases: [/2012/07/25/jenkins-octopress/]
---

## 目的

Octopressで記事を書いたあと、 **Bitbucket** に `git push origin source` とするだけで **Github Pages** に勝手にデプロイされるようにする。

## イメージ

{% img center http://dl.dropbox.com/u/10351676/images/octopress_deploy.png %}

1. 自分はブログ記事を書き終わったら、Bitbucketに git push だけしてあとは放っておく
1. Bitbucketは該当リポジトリが更新されると、さくらVPSのJenkinsのURLを叩く
1. Jenkinsはそれを契機にBitbucketからファイル一式をcloneしてOctopresで記事を作成する
1. Jenkinsは作成した記事をGithub Pagesにデプロイする

<!-- more -->

## 事前準備

* Github PagesにOctopressでブログを投稿できるようにしておく => まだなら [このあたりを参照](http://blog.glidenote.com/blog/2011/11/07/install-octopress-on-github/)
* さくらVPSを使えるようにしておく
* さくらVPSにJenkinsをインストールしておく => まだなら [こちらを参照](http://www.tokoro.me/2012/07/24/install-jenkins-to-sakura/)
* さくらVPSでGitを使えるようにしておく => まだなら [こちらを参照](http://blog.araishi.com/sakura-vps-git-yum-install/)
* Githubを使えるようにしておく
* Bitbucketを使えるようにしておく

## Jenkinsに入れておく必要のあるPlugin

* RVM Plugin

## JenkinsからBitbucketとGithubにアクセスできるようにする

```
$ cd /var/lib/jenkins
$ sudo -u jenkins -H /usr/local/bin/git config --global user.email "jenkins@your.domain"
$ sudo -u jenkins -H /usr/local/bin/git config --global user.name "jenkins"
$ sudo -u jenkins -H ssh-keygen -t rsa -C jenkins@your.domain
```
でJenkins用の秘密鍵と公開鍵を作る。
このとき、パスフレーズを設定しないように注意。

これで */var/lib/jenkins/.ssh/id_rsa.pub* という公開鍵ができているはずなので、この公開鍵を **Github** と **Bitbucket** に登録しておく。

ちなみに公開鍵の中身を
```
$ sudo -u jenkins -H more .ssh/id_rsa.pub
```
などで表示し、表示された文字列をそのまま **Github** や **Bitbucket** にコピペすればOK。


```
$ sudo -u jenkins mkdir tmp 
$ cd tmp
$ sudo -u jenkins /usr/local/bin/git clone git@bitbucket.org:yourname/yourname.github.com.git
$ sudo -u jenkins /usr/local/bin/git clone git@github.com:yourname/yourname.github.com.git
```
で実際に **Bitbucket** と **Github** からcloneをすると、それぞれ一度目に限り yes/no が問われるのでそこでyesとしておく必要がある（そうしないとJenkinsから使えない）。

## JenkinsからRVMを使えるようにする

```
$ cd /var/lib/jenkins
$ sudo -u jenkins -H -s bash -c 'bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )'
$ sudo -u jenkins -H -s bash -c 'source ~/.rvm/scripts/rvm; rvm pkg install readline zlib openssl' 
$ sudo -u jenkins -H -s bash -c 'source ~/.rvm/scripts/rvm; rvm install 1.9.2 -C --with-openssl-dir=~/.rvm/usr --with-readline-dir=~/.rvm/usr --with-zlib-dir=~/.rvm/usr'
```
で、jenkinsユーザでRVMでインストールしたRubyが使えるようになる。

実際にRubyが使えるかどうかは
```
$ sudo -u jenkins -H -s bash -c 'source ~/.rvm/scripts/rvm; ruby -v'
```
などで確認できる。

## gemsetを作成して必要なgemのインストール

```
$ sudo -u jenkins -H -s bash -c 'source ~/.rvm/scripts/rvm; rvm gemset create octopress'
$ sudo -u jenkins -H -s bash -c 'source ~/.rvm/scripts/rvm; rvm use 1.9.2@octopress; gem install bundle'
```
octopress用のoctopressというgemsetを作って、そこに **bundle** をインストールしておく。

## JenkinsのJobの設定

*Build a free-style software project* をベースに設定した項目は以下のとおり。

* Project name
  * **deploy-octopress** (お好みのジョブ名を設定)
* Source Code Management
  * **None** (Gitからソースを取得するところを含めてコマンドでやってしまうため)
* Build Triggers
  * **Trigger builds remotely**
    * Authentication Token: **a-word-you-like** (適当なワードを指定する)
* Build Environment
  * Run the build in a RVM-managed environment
    * Implementation: **1.9.2@octopress** (利用するRubyバージョンとgemset名を設定)
* Executable shell
  * Command
```
export PATH=$PATH:/usr/local/bin

rm -rf octopress
mkdir octopress
cd octopress

git init
git remote add -t source origin git@bitbucket.org:yourname/yourname.github.com.git
git fetch
git checkout source

bundle install

rake setup_github_pages\[git@github.com:yourname/yourname.github.com.git\]
rake generate
rake deploy
```
最後の *Command* のところでは、

* 作業ディレクトリを作り直す
* Bitbucketのリポジトリからsourceブランチを取得
* bundleで必要なgemなどをインストール
* generate & デプロイ!

をしている。

## BitbucketからJobの実行ができるように権限の設定を変更をする

BitbucketからJenkinsにアクセスする際に、 *http://jenkins.yourdomain/job/deploy-octopress/build?token=a-word-you-like* といったURLを叩いてJobを実行することになるので、それが可能なように権限の設定を変更しておく（**この方法は簡易的なものでセキュリティの面では良くないので、これを解消するには[次の記事](/2012/07/29/security-for-jenkins/)を参照して別の設定とするのが良い**）。

また、 **Manage Jenkins** -> *Configure System* で、

* Access Control
  * Authorization
    * Matrix-based security
      * Anonymousユーザの **Job** の **Read** だけチェック

## Bitbucketのほうの設定

作成したリポジトリの **Admin** タブの **Services** を選択。

*Select a service...* の中に *Jenkins* があるのでそれを選択して、 **Add service**。

設定項目には、
```
http://jenkins.yourdomain/job/deploy-octopress/build?token=a-word-you-like
```
と叩くべきURLをそのまま設定する (※ yourdomainなどは各自の環境に合わせて変更すること)。

## 完成!

これでひととおりの設定は完了。  
うまくいっていればいつもどおり記事を書いてコミットした後に `git push origin source` とBitbucketにpushするだけで、あとは勝手にデプロイしてくれる。  
このとき、Bitbucketのプライベートリポジトリにファイル一式がバックアップされることにもなる。

なお、sourceブランチがデプロイの対象となっているので、書き途中の記事をBitbucketに保存しておきたい場合には、 **draft** など別のブランチにコミットしておけば書き途中のものが勝手にデプロイされる心配はない。

## 課題

このままだと、認証なしで全てのJobが参照できる形になってしまっている。  
[次の記事](/2012/07/29/security-for-jenkins/)ではこれを解消することにトライしたい。

## じつは途中ではいろいろと引っかかった

以上、うまくいった手順をまとめたが実際にはいろいろとひっかかったところがあったので、そこも言及しておく。

### .rvmrc の実行許可の確認が越えられない

はじめて *.rvmrc* が設置されたディレクトリに入る際、 *.rvmrc* の内容を実行して良いか? といった問い合わせが入り、自分で操作しているときは単純に **yes** と応えるだけなのですが、それをJenkinsさんにやってもらう方法がわからなかった。  
`rvmrc trust ディレクトリ名`とすれば以降その確認がいらなくなるというのは既知なのだが、Git Plugin を使ってソースを取得すると、その時点でcloneしたディレクトリに入ってしまうのでタイミング的にそれも無理。  
けっきょくGit Pluginを使うのをあきらめ、ソースのcloneからブランチの切り替えまでコマンドで直接やることとした。

### RVMがうまく扱えない

ビルド時のコマンドの中で **rvm** を使っているわけですが、やたらとこのコマンドがないといったエラーが出まくり「うぎゃー」となった。
これは **RVM Plugin** を使えば簡単に解決できた。

### gemがインストールできない

**bundler** を使うため、`gem install bundle`をビルド時のコマンド中に入れたのだが、
```
ERROR:  Loading command: install (LoadError)
    no such file to load -- zlib
```
というエラーで先に進めない。

これはRubyのほうの話で、
```
$ sudo -u jenkins -H -s bash -c 'source ~/.rvm/scripts/rvm; rvm pkg install readline zlib openssl' 
$ sudo -u jenkins -H -s bash -c 'source ~/.rvm/scripts/rvm; rvm reinstall 1.9.2'
```
とzlibなどをRVMでインストールした後に、Rubyをreinstallすることで解決。  
本記事のほうの手順ではきちんと先に `rvm pkg install` を済ませておくようにしてある。

### rake installに失敗する

Jenkinsでの`rake install`時に
```
A theme is already installed, proceeding will overwrite existing files. Are you sure? [y/n]
```
という確認が出てきたそこでこけていた模様。  
よくよく考えてみると、`rake install`はこのリポジトリには適用済みの状態でpushしてあるので不要だった。

### rake generateでエラー

`rake generate`時に
```
Building site: source -> public
/var/lib/jenkins/.rvm/gems/ruby-1.9.2-p320@octopress/gems/ffi-1.0.11/lib/ffi/library.rb:121:in `block in ffi_lib': Could not open library 'lib.so': lib.so: cannot open shared object file: No such file or directory (LoadError)
```
といったエラーが発生。
これは **python-devel** が入っていない場合のエラーということだったので、さくらVPSのほうで `sudo yum install python-devel` しておくことで解消。

### rake deployでエラー

`rake deploy`時に
```
## Pushing generated _deploy website

Host key verification failed.
fatal: The remote end hung up unexpectedly
```
といったエラーが発生。

公開鍵はきっちり登録してあるはずなのにおかしいなと思ったら、一度めのアクセスの際にアクセス確認の問い合わせが入り、ここでyesとしないと先に進まないという状態で止まっていたというオチ。  
これはあらかじめさくらVPSのほうで、
```
$ sudo -u jenkins /usr/local/bin/git clone git@github.com:yourname/yourname.github.com.git
```
と一度Githubにアクセスしておけば解消される。

### おしまい

じつにJenkinsで自動デプロイするまでにかかったビルド試行回数は25回。  

