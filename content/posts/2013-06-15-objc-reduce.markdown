---
layout: post
title: "Objective-Cのコードを削れるだけ削る7のTips"
date: 2013-06-15
comments: true
external-url: 
tags: [objc,ios]
aliases: [/2013/06/15/objc-reduce/]
---

既存記事のまとめのため新しい要素があるわけではないのですが、Appleから発表されたXcode 5が正式にリリースされる前の復習ということで。

## Tipsを適用する前のコード

``` objc
#pragma mark - Private Category

@interface Sample ()

@property (strong) NSNumber* i;
@property (strong) NSNumber* c;
@property (strong) NSNumber* f;
@property (strong) NSArray* array;
@property (strong) NSDictionary* dictionary;
@property (strong) Sample* child;
@property (strong) UIColor* color;
@property (assign) NSUInteger index;
@property (assign) CGRect rect;

- (void)privateMethod1;
- (void)privateMethod2;
- (void)privateMethod3;

@end 

#pragma mark - Main Implementation

@implementation Sample

@synthesize i = i_;
@synthesize c = c_;
@synthesize f = f_;
@synthesize array = array_;
@synthesize dictionary = dictionary_;
@synthesize child = child_;
@synthesize color = color_;
@synthesize index = index_;
@synthesize rect = rect_;

- (void)privateMethod1
{
  [self privateMethod2];
  [self privateMethod3];
}

- (void)privateMethod2
{
  self.i = [NSNumber numberWithInt:100];
  self.c = [NSNumber numberWithChar:'a'];
  self.f = [NSNumber numberWithFloat:3.14f];
}

- (void)privateMethod3
{
  self.array = [NSArray arrayWithObjects:@"1", [NSNumber numberWithInt:1 + 2], [NSNumber numberWithBool:YES], nil];
  self.dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"val1", @"key1", @"val2", @"key2", nil];

  self.child = [[Sample alloc] init];
  self.color = [UIColor redColor];
  self.index = 7;

  self.rect = CGRectMake(0.0, 10.0, self.bounds.size.width, self.bounds.size.height);
}

@end
```

これを以下の7のTipsで削れるだけ削っていきます。

<!-- more -->

## Tip 1: プライベートメソッドの宣言を削る

Xcode 4.4 以降ではプライベートメソッドの宣言を削ることができます。  
そのため、上記の

``` diff
@interface Sample ()

@property (strong) NSNumber* i;
@property (strong) NSNumber* c;
@property (strong) NSNumber* f;
@property (strong) NSArray* array;
@property (strong) NSDictionary* dictionary;
@property (strong) Sample* child;
@property (strong) UIColor* color;
@property (assign) NSUInteger index;
@property (assign) CGRect rect;

-- (void)privateMethod1;
-- (void)privateMethod2;
-- (void)privateMethod3;

@end 
```

の部分はごっそり削ることができます。

## Tip 2: @synthesizeを削る

Xcode 4.4 以降では `@synthesize` を書かなくてもコンパイラが自動的にこれを補完してくれます。
そのため、上記の

``` diff
-@synthesize i = i_;
-@synthesize c = c_;
-@synthesize f = f_;
-@synthesize array = array_;
-@synthesize dictionary = dictionary_;
-@synthesize child = child_;
-@synthesize color = color_;
-@synthesize index = index_;
-@synthesize rect = rect_;
```

の部分もごっそり削ることができます。

## Tip 3: strong / assign は省略できる

propetyはオブジェクト型の場合は `strong` 、それ以外の場合は `assign` がデフォルトになっています。  
そのため、`strong` と `assign` については省略が可能です。

``` diff
@interface Sample ()

- @property (strong) NSNumber* i;
- @property (strong) NSNumber* c;
- @property (strong) NSNumber* f;
- @property (strong) NSArray* array;
- @property (strong) NSDictionary* dictionary;
- @property (strong) Sample* child;
- @property (strong) UIColor* color;
- @property (assign) NSUInteger index;
- @property (assign) CGRect rect;
+ @property NSNumber* i;
+ @property NSNumber* c;
+ @property NSNumber* f;
+ @property NSArray* array;
+ @property NSDictionary* dictionary;
+ @property Sample* child;
+ @property UIColor* color;
+ @property NSUInteger index;
+ @property CGRect rect;

@end 
```

※`nonatomic` にしたい場合は明示的に付加してください

## Tip 4: NSNumber, NSArray, NSDictionary を新しい書き方に変える

NSStringを `@"hoge"` で作れるように、Xcode 4.4からはNSNumber, NSArray, NSDictionaryについても@からはじまる短い書き方ができるようになりました。

``` diff
- (void)privateMethod2
{
- self.i = [NSNumber numberWithInt:100];
- self.c = [NSNumber numberWithChar:'a'];
- self.f = [NSNumber numberWithFloat:3.14f];
+ self.i = @100;
+ self.c = @'a';
+ self.f = @3.14f;
}

- (void)privateMethod3
{
- self.array = [NSArray arrayWithObjects:@"1", [NSNumber numberWithInt:1 + 2], [NSNumber numberWithBool:YES], nil];
- self.dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"val1", @"key1", @"val2", @"key2", nil];
+ self.array = @[@"1", @(1 + 2), @YES];
+ self.dictionary = @{@"key1": @"val1", @"key2": @"val2"};
```

## Tip 5: alloc/init は new に置き換える

`alloc` / `init` の組み合わせは `new` に置き換えることが可能です。

``` diff
- self.child = [[Sample alloc] init];
+ self.child = [Sample new];
```

## Tip 6: 一部のメソッドの呼び出しを .（ドット）アクセスで行う

引数のないメソッドは `.` （ドット）によるアクセスに置き換えることが可能です。

``` diff
- self.child = [Sample new];
- self.color = [UIColor redColor];
+ self.child = Sample.new;
+ self.color = UIColor.redColor;
```

## Tip 7: CGRectはC言語の構造体として作成することができる

CGRectは `CGRectMake` で作成するのが一般的ですが、CGRectの実態はC言語の構造体のため、構造体を作る書き方で代替することもできます。

``` diff
- self.rect = CGRectMake(0.0, 10.0, self.bounds.size.width, self.bounds.size.height);
+ self.rect = (CGRect){.origin.y = 10.0, .size = self.bounds.size};
```

## Tips適用後のコード

これらのTipsを適用することで、

* コード行数が **62行** -> **49行** 
* バイト数が **1,434 bytes** -> **816 bytes**

となりました。タイプ数も57%以下に削減されています。

見た目もすっきりです。

``` objc
#import "Sample.h"

#pragma mark - Private Category

@interface Sample ()

@property NSNumber* i;
@property NSNumber* c;
@property NSNumber* f;
@property NSArray* array;
@property NSDictionary* dictionary;
@property Sample* child;
@property UIColor* color;
@property NSUInteger index;
@property CGRect rect;

@end 

#pragma mark - Main Implementation

@implementation Sample

- (void)privateMethod1
{
  [self privateMethod2];
  [self privateMethod3];
}

- (void)privateMethod2
{
  self.i = @100;
  self.c = @'a';
  self.f = @3.14f;
}

- (void)privateMethod3
{
  self.array = @[@"1", @(1 + 2), @YES];
  self.dictionary = @{@"key1": @"val1", @"key2": @"val2"};


  self.child = Sample.new;
  self.color = UIColor.redColor;
  self.index = 7;

  self.rect = (CGRect){.origin.y = 10.0, .size = self.bounds.size};
}

@end
```

## まとめ

もちろん、これら全てを適用するのが正しいというわけではありませんので、チームや個人でお好みのものを利用するのが良いのではと思います。

## 参照

* [いまさらですがXcode4.4からiOS開発で使えるようになった新しいObjective-Cの書き方をまとめます](http://www.tokoro.me/2012/08/12/objc-new-statements/)
* [ObjCがサクっと書けるコーディングTips](http://cocoadays.blogspot.com/2013/04/objctips.html)
* [C99 Initializer Syntax in Objective C](http://www.jacopretorius.net/2013/05/c99-initializer-syntax-in-objective-c.html)
