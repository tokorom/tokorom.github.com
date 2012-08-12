---
layout: post
title: "いまさらですがXcode4.4からiOS開発で使えるようになった新しいObjective-Cの書き方をまとめます"
date: 2012-08-12 12:50
comments: true
external-url: 
categories: ios objc xcode
---

もうほとんどのかたが既知の内容と思いますが、まとめさせていただきます。  
これらは全てコンパイル時に事が済む類のものなので、iOS5だけでなくiOS4でも当然使えるというのが嬉しいですね!

## Xcode4.4適用前

Xcode4.3までのこのコードを...
``` objc
#pragma mark - Private Category

@interface Sample ()

@property (strong) NSNumber* i;
@property (strong) NSNumber* c;
@property (strong) NSNumber* f;
@property (strong) NSArray* array;
@property (strong) NSDictionary* dictionary;

- (void)privateMethods1;
- (void)privateMethods2;
- (void)privateMethods3;

@end 

#pragma mark - Main Implementation

@implementation Sample

@synthesize i = i_;
@synthesize c = c_;
@synthesize f = f_;
@synthesize array = array_;
@synthesize dictionary = dictionary_;

- (void)privateMethods1
{
  [self privateMethods2];
  [self privateMethods3];
}

- (void)privateMethods2
{
  self.i = [NSNumber numberWithInt:100];
  self.c = [NSNumber numberWithChar:'a'];
  self.f = [NSNumber numberWithFloat:3.14f];
}

- (void)privateMethods3
{
  self.array = [NSArray arrayWithObjects:@"1", @"2", [NSNumber numberWithBool:YES], nil];
  self.dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"val1", @"key1", @"val2", @"key2", nil];
}

@end
```

## Xcode4.4適用後

Xcode4.4からはこうできます！
``` objc
#pragma mark - Private Category

@interface Sample ()

@property (strong) NSNumber* i;
@property (strong) NSNumber* c;
@property (strong) NSNumber* f;
@property (strong) NSArray* array;
@property (strong) NSDictionary* dictionary;

@end 

#pragma mark - Main Implementation

@implementation Sample

- (void)privateMethods1
{
  [self privateMethods2];
  [self privateMethods3];
}

- (void)privateMethods2
{
  self.i = @100;
  self.c = @'a';
  self.f = @3.14f;
}

- (void)privateMethods3
{
  self.array = @[@"1", @"2", @(YES)];
  self.dictionary = @{@"key1": @"val1", @"key2": @"val2"};
}

@end
```

以下、具体的な内容を説明します。

<!-- more -->

## @synthesizeを省略できます

``` diff 上記コードにおけるdiff
-@synthesize i = i_;
-@synthesize c = c_;
-@synthesize f = f_;
-@synthesize array = array_;
-@synthesize dictionary = dictionary_;
```

これまでは、`@property`を定義した場合には、`@synthesize`で自動でgetter/setterを付加するか、`@dynamic`で自分で実装するかのどちらかが必須でした。

Xcode4.4からは **@synthesizeも@dynamicも書かなかった場合には@synthesizeを付けたのと同じ扱いとなる** ようになりました。

## NSNumber, NSArray, NSDictionary も短いコードで作れます

``` diff 上記コードにおけるdiff
 - (void)privateMethods2
 {
-  self.i = [NSNumber numberWithInt:100];
-  self.c = [NSNumber numberWithChar:'a'];
-  self.f = [NSNumber numberWithFloat:3.14f];
+  self.i = @100;
+  self.c = @'a';
+  self.f = @3.14f;
 }
 
 - (void)privateMethods3
 {
-  self.array = [NSArray arrayWithObjects:@"1", @"2", [NSNumber numberWithBool:YES], nil];
-  self.dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"val1", @"key1", @"val2", @"key2", nil];
+  self.array = @[@"1", @"2", @(YES)];
+  self.dictionary = @{@"key1": @"val1", @"key2": @"val2"};
 }
```

NSStringについては **@"hoge"** と **@** を文字列の前に付けることでNSStringのインスタンスを作れるというのが周知の事実です。  
Xcode4.4ではさらに、

* NSNumber
* NSArray
* NSDictionary

についても同様の省略形の書き方が追加されました。  
具体的には、それぞれ

* NSNumber `@100` `@3.14` `@'a'` `@0xff` `@(YES)`
* NSArray `@[val1, val2, val3]`
* NSDictionary `@{key1: val1, key2: val2}`

といった書き方ができるようになります。

ずいぶん楽になりますね！  
この他、`@(1 + 2 + 3)` といったかんじで括弧内の演算結果でNSNumberのインスタンスを作ることもできます。

上記のとおり、Xcode4.4からは **NSNumber, NSArray, NSDictionaryでも @ を使った省略形が使える** ようになりました。

## privateメソッドの定義を省略できます

``` diff 上記コードにおけるdiff
-- (void)privateMethods1;
-- (void)privateMethods2;
-- (void)privateMethods3;
```

これまではprivateメソッドについては無名カテゴリで宣言しておく必要がありました（正確にはそのメソッドを利用するコードの前に宣言しておく必要がありました）。

Xcode4.4からは **あらかじめ宣言されていないメソッドでも同じコード内に実装されていれば使える** ようになりました。

**※ なお、このメソッドの宣言の省略はXcode4.3+LLVMでもできるということを、[@ClimbAppDev](https://twitter.com/ClimbAppDev)さんからご指摘いただきました。ありがとうございます!**

[次の記事](/2012/08/12/objc-subscripting/) では、[]でNSArrayやNSDictionaryや独自クラスにアクセスできる件について書きます。

