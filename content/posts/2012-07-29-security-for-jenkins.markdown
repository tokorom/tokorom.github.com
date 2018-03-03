---
layout: post
title: "JenkinsにBitbucketからビルド命令を出す際にIDとPasswordを埋め込まないようにする"
date: 2012-07-29
comments: true
external-url: 
categories: [sakura, octopress, jenkins]
---

[前の記事](/2012/07/29/jenkins-octopress/)でBitbucketにpushしたのをトリガーにJenkinsでOctopressをデプロイするというのをやったのだが、このときは認証なしでJobの実行できるようになってしまっていた。  
つまりこのままだと自分のJenkinsは認証なしで全てのJobが実行できてしまうという状態でよろしくない。  
ひとつの解決索としてビルド命令用のユーザを作り、そのIDとPasswordをURLに直接埋め込んでしまうという方法も考えられるが、今回はそれを極力しない方向でがんばりたいと思う。

## JenkinsにBitbucketからアクセスするためのユーザを追加 

まずはBitbucketからJenkinsにアクセスする専用のユーザを作る。

※ ユーザの追加方法については [このあたり](https://wiki.jenkins-ci.org/display/JA/Standard+Security+Setup) を参照

今回は、**bitbucket** というユーザを追加した。

また、 **Manage Jenkins** -> **Configure System** で、

* Access Control
  * Authorization
    * Matrix-based security
      * bitbucketユーザに **Job** の **Read** だけチェック

<!-- more -->

としておいて、bitbucketユーザが最低限のことのみ可能なように設定しておく。

このとき、Anonymousユーザの **Job** の **Read** にチェックがついていれば外しておく。

## Jenkinsへのビルド命令専用のドメインを追加

これまでは `jenkins.yourdomain` というドメインでJenkinsにアクセスさせていたとして、ビルド命令専用の `push-to-jenkins.yourdomain` を追加した。  
これはnginxが外部からのビルド命令だと分かるようにするための目印としての意味合いなので、ドメインを追加する以外の方法でも良い。

## nginxに設定追加

nginxのconfに、以下のように`push-to-jenkins.yourdomain`へのアクセスをBasic認証つきでローカルのJenkinsのURLに委譲するよう設定を追加する。
```
server {
    listen 80;
    server_name push-to-jenkins.yourdomain;
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Authorization "Basic XXXXXX";
    }
}
```
**XXXXXX** の部分には実際には **bitbucket:yourpassword** というBasic認証のIDとPasswordの文字列をBase64エンコードした文字列を入れる必要がある。  
Base64エンコードの方法が分からない場合は [このあたり](http://www.ahref.org/app/base64/base64.cgi) のサイトでエンコードした文字列をGETするのが手っ取り早い。

設定後にnginxを再起動しておくこと。

## Bitbucketのほうの設定

該当リポジトリの **Admin** タブの **Services** を選択。

POSTの設定項目を
```
http://push-to-jenkins.yourdomain/job/deploy-octopress/build?token=a-word-you-like
```
に変更しておく。

## おしまい

以上の設定がうまく言っていれば、Bitbucketへの`git push origin source`でOctopressのデプロイが自動的にできるはず。  
また、このときベーシック認証のIDとPasswordがインターネット上にさらされることもない。

## 2012/08/19 追記

なお、Twitterで**@croquette0212**さんから
<blockquote class="twitter-tweet tw-align-center"><p><a href="https://twitter.com/tokorom"><s>@</s><b>tokorom</b></a> BitBucketとJenkinsの連携ですが、tokenつかうよりもGit PluginのnotifyCommit使う方がセキュリティの設定とかも楽なのでおすすめです! <a href="http://t.co/uBvrf0vL" title="http://kohsuke.org/2011/12/01/polling-must-die-triggering-jenkins-builds-from-a-git-hook/">kohsuke.org/2011/12/01/pol…</a></p>&mdash; Sousai (@croquette0212) <a href="https://twitter.com/croquette0212/status/236403188574613505" data-datetime="2012-08-17T10:04:46+00:00">August 17, 2012</a></blockquote>
<script src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
と教えていただきました。  
この方法だと外部（ここではBitbucket）から叩くURLになんとジョブ名さえ指定する必要がありません。このNotifyを受けたJenkinsのほうで自動でジョブをさらってスケジューリングしてくれるとのことです。  
また、このNotifyそのものがジョブを実行するわけではなくあくまでもJenkinsに対する通知だけなので、ジョブの実行権限のあるユーザでURLを叩くにはどうしたらよいだろう？とかセキュリティのことをごたごた考えずに済みます。Jenkinsを運用しているサーバが該当のGitリポジトリをcloneできる状態ならOKなようでとても楽そうです。  
詳しくは [GitHubとJenkinsの連携](http://nantekottai.com/2012/07/13/git-hook-and-access-controlled-jenkins/) をご参照ください。
