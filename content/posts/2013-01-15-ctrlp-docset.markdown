---
layout: post
title: "VimでiOSのリファレンスを直接参照したい → CtrlPの拡張でできるようになりました"
date: 2013-01-15
comments: true
external-url: 
categories: [vim, ios, objc]
aliases: [/2013/01/15/ctrlp-docset/]
---

## Vimでリファレンス読む必要ありますか？

正直微妙なところでしょうか。  
自分の場合、 **Dash** があればVimで直接にリファレンスAPIドキュメントとか)を見れなくてもそんなには困ってないです。

ただ、せっかく[前の記事](/2013/01/15/ctrlp-docset/)でVimでObjective-Cのコード補完をできるようにしたので、リファレンスもVimで参照できるようにしてみたいと思います。

* Vimでさらっと検索してリファレンスから関数をコピー
* そのままプログラミングにペースト

というのをキーボードから手を離さずに手早くできるというメリットはありそうです。

※ ただ、がっつりドキュメント読むときはやはりDashとか使ったほうが良いと思います

## Docsetを検索するCtrlPのエクステンションを作りました

[ctrlp-docset](https://github.com/tokorom/ctrlp-docset) というpluginを作りました。  
オフィシャルのiOSのドキュメント(iOS 6.0 Library)は **Docset** 形式になっているので、そのDocsetをVimから参照するイメージです。  
なのでiOS専用というわけではなく、Docsetならなんでも参照可能です。

vim-refと迷いましたが、[CtrlP](https://github.com/kien/ctrlp.vim) を使ってみたかったのでCtrlPのエクステンションとして作成しました。

CtrlPについては、

* [意外と知られていない便利なvimプラグイン「ctrlp.vim」](http://mattn.kaoriya.net/software/vim/20111228013428.htm)
* [Vimプラグインの拡張機能プラグインを作ってVimをさらに使いやすくしよう](http://kaneshin.hateblo.jp/entry/vim-advent-calendar-2012) 

あたりがわかりやすかったです。

インストールして動かすと、

![ctrlp_docset.jpg](http://dl.dropbox.com/u/10351676/images/ctrlp_docset.jpg)

といったかんじで、クラスやメソッドをインクリメンタル検索できるようになります。  

<!-- more -->

参照したい項目を選択するとデフォルトだとブラウザでドキュメントが参照できます。  
自分はVim内で完結したいので [w3m.vim](https://github.com/yuratomo/w3m.vim) を使ってVim内で表示するように設定しました。

## インストール

### まずはDocsetがインストールされているか確認

これがないとはじまりません。  
あるかどうか心配なかたは、Xcodeを起動し、 **Preferences...** の **Downloads** を確認してみてください。  
ここの **Documentation** タブのほうで **iOS 6.0 Library** かそれに相当するものが **Installed** とインストール済みになっていれば問題ありません。  
なければここからインストールをしてみてください。

![xcode_docset.jpg](http://dl.dropbox.com/u/10351676/images/xcode_docset.jpg)

なお、ここでインストールしたDocsetは、たぶん

```sh
~/Library/Developer/Shared/Documentation/DocSets/com.apple.adc.documentation.AppleiOS6.0.iOSLibrary.docset
```

に配置されると思います。

### CtrlP と ctrlp-docset をインストール

Vundleを使ってらっしゃるなら、

* .vimrc

```sh
Bundle 'git://github.com/kien/ctrlp.vim.git'
Bundle 'git://github.com/tokorom/ctrlp-docset.git'
```

で、その他のかたは各自の環境に合わせて読み替えてください。

### ctrlp-docset の設定

設定なしでも動く人がいるかもしれませんが、以下２つをご確認ください。

* .vimrc

```sh
# docsetutilコマンドの場所を指定する（docsetutilにPATHが通っていれば設定必要なし）
let g:ctrlp_docset_docsetutil_command = '/Applications/Xcode.app/Contents/Developer/usr/bin/docsetutil'

# iOS用のDocsetの場所を指定する（下記と同じ場所なら設定必要なし）
# objc は filetype です / 他の filetype をご利用の場合はそれを設定してください
let g:ctrlp_docset_filepaths = {'objc': '~/Library/Developer/Shared/Documentation/DocSets/com.apple.adc.documentation.AppleiOS6.0.iOSLibrary.docset'}
```

## 実行!

これらの設定が全部終わったらVimでObjective-Cのファイルを開いた後に、

```sh
:CtrlPDocset
```

を実行してみてください。  
設定がうまくいっていればiOSのクラス/メソッドがインクリメンタル検索できるはずです。  

また、参照したいクラス/メソッドを選択（Enter）すればドキュメントがブラウザで開かれます。

Vimを起動して１回目の実行はだいぶん遅いと思います。  
２回目以降はデータがキャッシュされているのでストレスなく利用できると思います。

## キーバインドの変更

* .vimrc

```sh
nnoremap お好みのキー :<C-u>CtrlPDocset<CR>
```

## ドキュメントをw3mで開きたい

w3mコマンドが利用できる環境ならもちろん可能です。
Macなら `brew install w3m` などであらかじめインストールしておいてください。

* .vimrc

```sh
# w3m.vim が必要です
Bundle 'git://github.com/yuratomo/w3m.vim.git'

# ドキュメントを開くときのコマンドを変える場合にはこのオプション（%sにURLが渡される）
let g:ctrlp_docset_accept_command = ':W3mSplit local %s'
```

これらの設定をしておけば、ブラウザで開く代わりにVim内でドキュメント参照が完結できるようになるはずです。
