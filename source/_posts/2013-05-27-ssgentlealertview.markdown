---
layout: post
title: "UIAlertViewよりもおとなしいメッセージダイアログを利用する"
date: 2013-05-27 23:30
comments: true
external-url: 
categories: [ios, objc]
---

## UIAlertViewは警告目的のダイアログ

そもそもUIAlertViewはエンドユーザになんらかの警告をするときに利用するもので、iOSヒューマンインターフェースガイドラインにも、

```
一般にアラートは、次のような場合には不要です。
* なんらかの情報、特にアプリケーションの標準機能に関する情報を目に付かせるためだけの場合。
  代わりに、アプリケーションのスタイルに調和し、目を引く情報表示の方法を設計すべきです。
```

と記載されています。

その一方で、UIAlertViewは簡単に利用でき、なんらかの情報を表示するのにどうしても使いたくなってしまいます。  
それならばUIAlertViewの外観を変えて使えば、というのも考えられますが、ところがどっこいUIAlertViewはAppearanceの変更を一切サポートしていません。  

警告目的のアラートダイアログの外観がアプリによって変更されると、エンドユーザからすればそれがなんらかの警告であると認知しづらくなってしまうからだと思われます（アラートダイアログについては全アプリで共通であるべきという思想）。

## 警告目的ではない普通のメッセージダイアログ

それでは、警告目的でない汎用的に使える普通のメッセージダイアログがあったほうが良いねという話になり、作ってみました。

[https://github.com/tokorom/SSGentleAlertView](https://github.com/tokorom/SSGentleAlertView)

このSSGentleAlertViewは、

* UIAlertViewと同じコードで利用できる
* UIAlertViewとは違い、外観を変更できる
* デフォルトではUIAlertViewよりもおとなしめなダイアログ表示になる

という３点に留意して作っています。

<!-- more -->

画像パーツやカラーリングなどはUIデザイナの [Atsushi Morino](https://twitter.com/limonomori) さんに作ってもらってるのでちゃんとしてます。

## 外観

自分でカスタマイズしない場合でも、次の3種のスタイルが選べます。

### Default

![SSGentleAlertViewDefault](http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewDefault.png)

### Black

![SSGentleAlertViewBlack](http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewBlack.png)

### Native

![SSGentleAlertViewNative](http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewNative.png)


## サンプルコード

UIAlertViewを使うときのコードのUIAlertViewの部分をSSGentleAlertViewに変更するだけです。

``` objc
// #import "SSGentleAlertView.h"

SSGentleAlertView* alert = [SSGentleAlertView new];
alert.delegate = self;
alert.title = @"SSGentleAlertView";
alert.message = @"This is GentleAlertView!\nUIAlertView is too strong to use for ordinary messages.";
[alert addButtonWithTitle:@"Cancel"];
[alert addButtonWithTitle:@"OK"];
alert.cancelButtonIndex = 0;
[alert show];
```

なお、インスタンスを作る際に`[[SSGentleAlertView alloc] initWithStyle:SSGentleAlertViewStyleBlack]` のようにすることで、３種のスタイルを選択できます。

## 外観の変更

また、外観を変更することも簡単にできます。例えば、

``` objc
// #import "SSGentleAlertView.h"
// #import "SSDialogView.h"

// 背景画像を別のものに差し替え
alert.backgroundImageView.image = [UIImage imageNamed:@"dialog_bg"];
// ダイアログ部分の画像はなしにする
alert.dialogImageView.image = nil;

// タイトルラベルとメッセージラベルの色を変更
alert.titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
alert.titleLabel.shadowColor = UIColor.clearColor;
alert.messageLabel.textColor = [UIColor colorWithRed:0.4 green:0.2 blue:0.0 alpha:1.0];
alert.messageLabel.shadowColor = UIColor.clearColor;

// ボタンの背景画像とフォント色を変更
UIButton* button = [alert buttonBase];
[button setBackgroundImage:[SSDialogView resizableImage:[UIImage imageNamed:@"dialog_btn_normal"]] forState:UIControlStateNormal];
[button setBackgroundImage:[SSDialogView resizableImage:[UIImage imageNamed:@"dialog_btn_pressed"]] forState:UIControlStateHighlighted];
[button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
[button setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
[alert setButtonBase:button];
[alert setDefaultButtonBase:button];
```

のようにすると、いつものUIAlertViewとは全く別もののダイアログに変更することも可能です。

![SSGentleAlertViewCustomize](http://dl.dropbox.com/u/10351676/images/SSGentleAlertViewCustomize.png)

## インストール方法

### CocoaPodsを使う場合

```
// Podfile
pod 'SSGentleAlertView'
```
Podファイルに上記を追記して
```
pod install
```
を実行するだけです。

### Gitやその他の方法でインストールする場合

```
git clone git://github.com/tokorom/SSGentleAlertView.git
// git submodule add git://github.com/tokorom/SSGentleAlertView.git Externals/SSGentleAlertView
```

や、その他の方法でSSGentleAlertViewをダウンロードしてください。
ダウンロードしたら、SSGentleAlertViewというサブディレクトリをXcodeのプロジェクトに追加してください。
