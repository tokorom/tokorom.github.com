---
layout: post
title: "BlockInjectionをバージョンアップしました"
date: 2013-04-01
comments: true
external-url: 
tags: [ios, objc]
aliases: [/2013/04/01/blockinjection2/]
authors: [tokorom]
---

## BlockInjectionとはなんぞや

Objective-Cの特定のメソッドの前後に処理を追加できるライブラリです。  
クラスの外側からアスペクト指向的に振る舞いを追加できるのが特徴です。

[https://github.com/tokorom/BlockInjection](https://github.com/tokorom/BlockInjection) で公開しています。

## バージョンアップ内容

[前記事](/2013/03/07/block-injection/) からのバージョンアップ内容は以下です。

* リファクタリングしてメソッド名が一式変更になりました（これまでのものはDeprecatedですがまだ使えます）
* クラスメソッドにも対応しました
* 複数のクラスやメソッドを一度に追加できるようになりました
* 正規表現で指定できるようになりました(※1)
* 注入したBlockの中で注入先のメソッド名を取得できるようになりました(※2)
* オマケで単純なメソッド実装置き換え機能も追加しました

## UIViewの勝手に呼ばれているsetterでまとめて全てログ出力させる

<!-- more -->

既存のクラスライブラリの挙動がいまいち分からなくて、いったいどんなタイミングでなにが変更されているんだろうと気になったことはないでしょうか。  
例えば、上記バージョンアップの中の ※1 と ※2 の利用サンプルとして **UIViewのsetter全でまとめてログ出力をする** ようにしてみます。  
BlockInjectionを使えば、たった3行のコードでこれが実現できます。

``` objective-c
[BILib injectToClassWithNameRegex:BIRegex(@"^UIView$") methodNameRegex:BIRegex(@"^set.*$") preprocess:^{
  NSLog(@"%@", [BILib prettyFunction]);
}];
```

これを実行すると、UIViewを作っただけで勝手に呼ばれたsetter群が

```
 -[UIView setContentScaleFactor:]
 -[UIView setFrame:]
 -[UIView setNeedsDisplay]
```

のように全てログ出力されます。

`+ (BOOL)injectToClassWithNameRegex:(NSRegularExpression*)classNameRegex methodNameRegex:(NSRegularExpression*)methodNameRegex preprocess:(id)preprocess;` が正規表現でクラス名とメソッド名を指定して処理を注入するためのメソッドです。  
正規表現にマッチする全てのクラス/メソッドの直前に指定したBlockを埋め込みます。

また、`[BILib prettyFunction]` は注入先のメソッド名を`__PRETTY_FUNCTION__`と同じ形式で取得できる便利機能です。

ちなみに、`BIRegex`というのはただ`NSRegularExpression`を簡易的に作るための関数ですので、↑のコードは以下と同義です。

``` objective-c
NSError* error = nil;
NSRegularExpression* classNameRegex = [NSRegularExpression regularExpressionWithPattern:@"^UIView$" options:0 error:&error];
NSRegularExpression* methodNameRegex = [NSRegularExpression regularExpressionWithPattern:@"^set.*$" options:0 error:&error];

[BILib injectToClassWithNameRegex:classNameRegex methodNameRegex:methodNameRegex preprocess:^{
  NSLog(@"%@", [BILib prettyFunction]);
}];
```

※2013/04/05追記: ちなみに **特定Prefixのメソッド全てにまとめて振るまいを追加する** というのは [@7gano](https://twitter.com/7gano) さんのアイデアです。
