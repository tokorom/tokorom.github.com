---
layout: post
title: "VimでObjective-Cのコード補完を実行する with clang"
date: 2013-01-02 02:09
comments: true
external-url: 
categories: [objc,vim,ios]
---

## 概要

VimやEmacsでiOSアプリ開発をするときに「Snippetとかちゃんと設定してればXcodeほどのコード補完は必要ない」と強がりを言ってはみるものの「本当はちょっとコード補完使いたいときあるんだよね」と思ってました。

そこで、重い腰をあげてVimでもObjective-Cのコード補完ができるよう設定してみました。

具体的には、

1. **clangコマンドでのコード補完を試してみる**
1. **その結果をもってVimの `clang_complete` プラグインを導入する**

という手順で実施しました。

結果として満足いく補完環境が整いましたので紹介させていただきます。

<!-- more -->

## clangコマンドでのコード補完を試してみる

`clang`コマンドはXcodeを使っていればはじめっから入っているコマンドです。  
じつはこの`clang`コマンドを使うことでObjective-Cのコード補完が普通にできるとのこと。

具体的には、

```sh
// clang -cc1 -code-completion-at=ソースコード.m:行数:列数 ソースコード.m
clang -cc1 -code-completion-at=Sample.m:20:5 Sample.m
```

というコマンドになります。  
例えば、

- Classes/Controllers/MainViewController.m

```objc
#import "MainViewController.h"

@implementation MainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSArray* numbers = @[@1, @2, @3];
  [numbers o
}

@end
```

の `[numbers o` のところで補完をしたいとして、

```sh
clang -cc1 -code-completion-at=Classes/Controllers/MainViewController.m:16:12 Classes/Controllers/MainViewController.m 
```

というコマンドを実行してみます。  
すると `COMPLETION:` ではじまる行が幾つか表示され、なんらか補完結果が出ているのが分かります。

同時に、`xxx warnings and xxx errors generated.` とエラーが発生しているのも確認できるかと思います。

## clangによる補完時のオプション

このエラーは、clangに対するオプションの不足によるものです。
そこでclangに対して以下のオプションを設定してあげます（※環境依存なので適宜読み替えてください）

* **-fblocks**  
  => ブロック構文を利用している場合は必須のオプション   
* **-fobjc-arc**  
  => ARCを使用している場合は必須のオプション   
* **-D __IPHONE_OS_VERSION_MIN_REQUIRED=40300**  
  => ターゲットがiOS 4.3 以上であることを示す  
* **-include ./\*\*/\*-Prefix.pch**  
  => プロジェクト内のpch（プリコンパイルヘッダ）のinclude   
* **-F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/System/Library/Frameworks**  
  => iOS標準のフレームワークがあるディレクトリ指定   
* **-I /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/usr/include**  
  => iOS標準クラスのヘッダーがあるディレクトリ指定   

この他、独自のヘッダーファイルがある場合は `-I` の設定を加える必要があります。

これらのオプションを指定してclangを実行してみると、

```
clang -cc1 -code-completion-at=Classes/Controllers/MainViewController.m:16:12 Classes/Controllers/MainViewController.m -fblocks -fobjc-arc -D __IPHONE_OS_VERSION_MIN_REQUIRED=40300 -include ./**/*-Prefix.pch -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/System/Library/Frameworks -I /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/usr/include 
```

無事にerrorなしで補完候補を引き出すことが出来ました。

## clang_completeプラグインの導入

あとは `clang_complete`プラグイン を導入して、上記で試したオプションを設定してあげれば、無事にVim上でObjective-Cのコード補完が出来るようになります。

なお、自分の場合は `neocomplcache` と共用する設定をしています。

- .vimrc (Vundleによるプラグインの設定)

```vim
Bundle 'git://github.com/Shougo/neocomplcache.git'
Bundle 'git://github.com/Rip-Rip/clang_complete.git'
```

- .vimrc (neocomplcacheのドキュメントからコピペしたneocomplcacheとclang_completeを共用するための設定)

```vim
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_overwrite_completefunc = 1
let g:neocomplcache_force_omni_patterns.c =
  \ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp =
  \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_force_omni_patterns.objc =
  \ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.objcpp =
  \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
```

- .clang_complete (実行するディレクトリに配置するclang実行時の追加オプション指定用ファイル)

```
-fblocks
-fobjc-arc
-D __IPHONE_OS_VERSION_MIN_REQUIRED=40300
-include ./**/*-Prefix.pch
-F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/System/Library/Frameworks
-I /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/usr/include
```

特に最後の `.clang_complete` ファイルが重要です。  
clangのオプションは `.vimrc` でも指定できるのですが、こいつを利用することでプロジェクトごとに違うオプションを設定できるようになります（実用時にかなり有用）。

## 実際にコード補完の実行

すべての設定が完了したら、実際に先ほどの

```objc
#import "MainViewController.h"

@implementation MainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSArray* numbers = @[@1, @2, @3];
  [numbers o
}

@end
```

の `[numbers o` の直後で補完を実行してみます。  
上記と全く同じ設定をしているならInsertモード時に `Ctrl+x Ctrl+o` or `Ctrl+x Ctrl+u` で実行できるはずです。

{% img center http://dl.dropbox.com/u/10351676/images/clang_completion.png %}

ぼくの手元では、きっちり「oからはじまるNSArrayのインスタンスメソッドが一覧表示」されました！  

## より便利に使うためのオプションを追加

なお、実際に使ってみると`.clang_complete`に全てのディレクトリを追加するのが面倒臭くなってきます。  
例えば、`Classes/XXX/XXX/Views/`というディレクトリにあるヘッダーファイルを使っている場合、

```
-I Classes/XXX/XXX/Views
```

をわざわざ`.clang_complete`に加えなければいけません。  
１つなら良いのですがこれがどんどん増えていくようなら`.clang_complete`のメンテナンスのせいでコーディングリズムが崩れることになりかねません。

例えば、 **カレントディレクトリ以下を再帰的に全て -I に追加してくれるオプション** があればいいのに！  
と思ったのですが少なくとも自分が調べて限りでは見つかりませんでした。

ということで`clang_complete`をForkして自分で作りました。  
ひとまず今は、 [tokorom/clang_complete](https://github.com/tokorom/clang_complete) を使っていただければこのオプションが使えます。

以下、具体的な設定値です。

- .vimrc (Vundleによるプラグインの設定)

```vim
#Bundle 'git://github.com/Rip-Rip/clang_complete.git'
Bundle 'git://github.com/tokorom/clang_complete.git'
```

- .vimrc (カレントディレクトリ以下を再帰的に -I で加える)

```vim
let g:clang_complete_include_current_directory_recursively = 1
```

これでカレントディレクトリ以下のヘッダーファイルであれば買ってにインクルードされるようになります！
