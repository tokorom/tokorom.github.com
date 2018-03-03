---
layout: post
title: "Objective-Cで最近お気に入りのマクロ４つ"
date: 2013-01-09
comments: true
external-url: 
tags: [objc,ios]
aliases: [/2013/01/09/objc-macro/]
---

## マクロ

マクロの利用については賛否両論がありますが、ぼくはわりかし使います。

** ※2013/1/9 追記 **

上記のとおり独自のマクロを使うこと自体に賛否両論あります。  
例えば独自のマクロを定義して利用することで、  

* 他の人がコードを見たときに分かりづらくなる
* 思わぬ不具合が出るケースがある
* 名前の衝突リスクがある（マクロは名前空間が使えない）

などのデメリットがあります。
特にチームや会社でのご利用の際にはよくよくご留意をお願いします。

## 1. [NSString stringWithFormat:] を簡単に

```objc
NSString* message = [NSString stringWithFormat:@"HELLO %3.1d", 333.333];
```

`[NSString stringWithFormat:]`はよく使うのだが長くて面倒...とよく思ってしまう。  
ということで、

<!-- more -->

```objc
#define NSPRINTF(f, ...) [NSString stringWithFormat:f, __VA_ARGS__]
```
を定義して

```objc
NSString* message = NSPRINTF(@"HELLO %3.1d", 333.333);
```
としています。ちょっと楽！

** ※2013/1/9 追記 *

`NSSPRINTF`というネーミングは微妙。特に`NS`という冠詞を勝手に使うのがダメ。  
元々のイメージは`NSString`+`sprintf`だったが再考すべし。

## 2. NSLocalizedString を簡単に

```objc
NSString* message = NSLocalizedString(@"KEY", nil);
```

`NSLocalizedString`もよく使うのだが長いしあまり使わない引数がつきまとって面倒...とよく思ってしまう。  
ということで、

```objc
#define LSTR(s) NSLocalizedString((s), nil)
```
を定義して

```objc
NSString* message = LSTR(@"KEY");
```
としています。ちょっと楽！

## 3. クラスメソッドの利用を簡単に

```objc
[LongLongLongNameClass classMethod];
```

自クラスのクラスメソッドを使うときにクラス名が長いとインスタンスメソッドの`self`と比べて面倒だなと思ってしまう。
ということで、

```objc
#define ME [self class]
```
を定義して

```objc
[ME classMethod];
```
としています。ちょっと楽！

## 4. Blockのお伴の__weakなselfを簡単に

```objc
__weak MyClass* SELF = self;
[self doSomethingWithBlock:^{
  [SELF showAlert];
}];
```

Blockを使ってそこにselfをweakリファレンスで渡したいとき、そのコードの記述が面倒だなと思ってしまう。
ということで、

```objc
#define PREPARE_SELF __weak typeof(self) SELF = self
```
を定義して

```objc
PREPARE_SELF;
[self doSomethingWithBlock:^{
  [SELF showAlert];
}];
```
としています。ちょっと楽！

## 参考ページ

* [Objective-C の instancetype キーワードが面白い + typeof(self)の考察](http://www.zero4racer.com/blog/1014)
