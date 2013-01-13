---
layout: post
title: "もっと簡単にVimでObjective-Cのコード補完を実行する"
date: 2013-01-14 05:23
comments: true
external-url: 
categories: [ios,vim,objc]
---

## 概要

先日、 [VimでObjective-Cのコード補完を実行する With Clang](http://www.tokoro.me/2013/01/02/clang-complete-for-vim/) でVimでclangを使ったコード補完をする方法について紹介させていただきましたが、今回はそのUpdate版になります。

というのも、`clang_complete`には`g:clang_auto_user_options`という素晴らしいオプションがあり、これによりiOS用のビルド設定を簡単に拡張することができることが分かったためです。  
具体的には、`clang_complete`に追加して、後述の拙作の [plugin](https://github.com/tokorom/clang_complete-getopts-ios) を１つインストールしていただき、

* after/ftplugin/objc.vim

```sh
let g:clang_auto_user_options = 'path, .clang_complete, clang, ios'
```

という設定をするだけで多くのプロジェクトが `.clang_complete` ファイルなしでコード補完できるようになる見込みです。  
このオプションの中の、

<!-- more -->

* path
* .clang_complete
* clang

の３つは`clang_complete`のデフォルト値で、最後の

* ios

が今回作成したpluginにより追加できるオプションです。

## clang_complete-getopts-ios

[clang_complete-getopts-ios](https://github.com/tokorom/clang_complete-getopts-ios) は、clang_complete の plugin です。  
これを入れることで、clang_completeでのコード補完実行の際に、

* `'-fblocks -fobjc-arc -D __IPHONE_OS_VERSION_MIN_REQUIRED=40300'`をオプションとして追加する
* カレントディレクトリ以下のディレクトリを全てIncludeファイル用の検索パスとして追加する
* カレントディレクトリ以下の **\*.pch** を全て `-include` オプションとして追加する
* `-F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/System/Library/Frameworks`をオプションとして追加する
* `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/usr/include`以下のディレクトリを全てIncludeファイル用の検索パスとして追加する

を自動で行ってくれます。  
要するに、[VimでObjective-Cのコード補完を実行する With Clang](http://www.tokoro.me/2013/01/02/clang-complete-for-vim/) で手動で `.clang_complete` ファイルに設定した項目+αのことを自動でやってくれるようになります。

## インストール方法

* .vimrc

```sh
# Vundleをご利用の場合
Bundle 'git@github.com:tokorom/clang_complete.git'
Bundle 'git://github.com/tokorom/clang_complete-getopts-ios.git'
```

* after/ftplugin/objc.vim

```sh
let g:clang_auto_user_options = 'path, .clang_complete, clang, ios'
```

この他、clang_complete 自体の設定などについては、 [VimでObjective-Cのコード補完を実行する With Clang](http://www.tokoro.me/2013/01/02/clang-complete-for-vim/) をご参照ください。

## 完了

以上の設定でたいていのケースではiOSアプリ開発時のコード補完ができるようになっているかと思います。

## オプション

### SDKを **5.1** にしたい

```objc
let g:clang_complete_getopts_ios_sdk_directory = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.1.sdk'
```

といった形で、SDKの場所を上書きしてください。

### ARC非対応にしたい、その他オプションを加えたい

```objc
let g:clang_complete_getopts_ios_default_options = '-fblocks -fobjc-arc -D __IPHONE_OS_VERSION_MIN_REQUIRED=40300'
```

をご自由にお書き換えください。

### Includeファイル用の検索パスとして加えたくないディレクトリがある

```objc
let g:clang_complete_getopts_ios_ignore_directories = ["^\.git", "\.xcodeproj"]
```

をご自由にお書き換えください。
