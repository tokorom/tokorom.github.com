---
layout: post
title: "もっと簡単にVimでObjective-Cのコード補完を実行する"
date: 2013-01-14
comments: true
external-url: 
categories: [ios,vim,objc]
aliases: [/2013/01/14/easy-objc-complement/]
---

## 概要

先日、 [VimでObjective-Cのコード補完を実行する With Clang](/2013/01/02/clang-complete-for-vim/) でVimでclangを使ったコード補完をする方法について紹介させていただきましたが、今回はそのUpdate版になります。

というのも、`clang_complete`には`g:clang_auto_user_options`という素晴らしいオプションがあり、これにより`clang_complete`本体をいじらなくてもiOS用の設定を簡単に拡張できることが分かったためです。  
具体的には、`clang_complete`ともう１つ、後述の拙作の [plugin](https://github.com/tokorom/clang_complete-getopts-ios) を１つインストールいただき、

* after/ftplugin/objc.vim

```sh
let g:clang_auto_user_options = 'path, .clang_complete, ios'
```

という設定をするだけで多くのプロジェクトが `.clang_complete` ファイルなしでコード補完できるようになる見込みです（手元のプロジェクトは全て追加設定いらずでした）。
このオプションの中の、

<!-- more -->

* path
* .clang_complete
* <del>clang</del>


**※2013/1/20 追記 clangの項はclang_completeのバージョンアップでなくなりました**

の<del>３つ</del>２つは`clang_complete`にデフォルト値で設定される値で、最後の

* ios

が今回作成した[plugin](https://github.com/tokorom/clang_complete-getopts-ios)により追加できるオプションです。

## clang_complete-getopts-ios

[clang_complete-getopts-ios](https://github.com/tokorom/clang_complete-getopts-ios)が新しく作成した clang_complete の plugin です。  
これを入れることで、clang_completeでのコード補完実行の際に、

* `'-fblocks -fobjc-arc -D __IPHONE_OS_VERSION_MIN_REQUIRED=40300'`をオプションとして追加する
* カレントディレクトリ以下のディレクトリを全てIncludeファイル用の検索パスとして追加する
* カレントディレクトリ以下の **\*.pch** を全て `-include` オプションとして追加する
* `-F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/System/Library/Frameworks`をオプションとして追加する
* `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/usr/include`以下のディレクトリを全てIncludeファイル用の検索パスとして追加する

という５つのことを自動で行ってくれるようになり、`.clang_complete`ファイルいらずになります。
要するに、[前の記事](/2013/01/02/clang-complete-for-vim/) で手動で `.clang_complete` ファイルに設定した項目+αのことを自動でやってくれるようになります。

## インストール方法

* pluginをVundleなどでインストール

```sh
# Vundleをご利用の場合
Bundle 'git://github.com/tokorom/clang_complete.git'
Bundle 'git://github.com/tokorom/clang_complete-getopts-ios.git'
```

* after/ftplugin/objc.vim に以下のようにiosアプリ開発用の設定を加える

```sh
let g:clang_auto_user_options = 'path, .clang_complete, ios'
```

この他、clang_complete 自体の設定などについては、 [VimでObjective-Cのコード補完を実行する With Clang](/2013/01/02/clang-complete-for-vim/) をご参照ください。

<s>* .vimrc clang_completeがPythonのライブラリを使うように設定する（どうもこっちのほうが安定してるっぽい）</s>
* .vimrc clang_completeがPythonのライブラリを使わないよう設定する（2012/2/11現在、Pythonライブラリだとうまく補完できないケースがあった。ただしclang_complete自体はこのオプションをdeprecatedとしている）

```sh
let g:clang_use_library = 0
```

## 設定完了！

以上の設定でたいていのケースではiOSアプリ開発時のコード補完ができるようになっているかと思います。  
あとは使うだけ！

## オプション事項

### SDKを **5.1** にしたい

```objc
let g:clang_complete_getopts_ios_sdk_directory = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.1.sdk'
```

といった形で、SDKの場所を設定してあげてください。

### ARC非対応にしたい、その他オプションを加えたい

```objc
let g:clang_complete_getopts_ios_default_options = '-w -fblocks -fobjc-arc -D __IPHONE_OS_VERSION_MIN_REQUIRED=40300'
```

をご自由にお書き換えください。  
もちろん、これまでどおり `.clang_complete` ファイルにオプションを加えることもできます。

### Includeファイル用の検索パスとして加えたくないディレクトリがある

```objc
let g:clang_complete_getopts_ios_ignore_directories = ["^\.git", "\.xcodeproj"]
```

をご自由にお書き換えください。
