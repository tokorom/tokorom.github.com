---
layout: post
title: "Objective-Cで独自クラスに[]でアクセスする"
date: 2012-08-12
comments: true
external-url: 
categories: ios objc xcode
aliases: [/2012/08/12/objc-subscripting/]
---

まず、Xcode4.4から使えるObjective-Cの新しい書き方については [前の記事](/2012/08/12/objc-new-statements/) をご参照ください。

## Xcode4.4からMacアプリ開発で使える新しいリテラル

上記記事には書いていないのですがMac向けのアプリではこの他にも、

* **array[1]** でNSArrayの要素にアクセスできる
* **dictionary[key]** でNSDictionaryの要素にアクセスできる
* **@YES**/**@NO** でもNSNumberのインスタンスを作れる

といった変更があります。  
こちらについては残念ながらiOSアプリ開発ではまだ利用できません。

※ これらがターゲットがMacの場合には利用できてiOSの場合には利用できないということは、 [@k_katsumi](https://twitter.com/k_katsumi) さんに教えてもらいました。

## でも[]でアクセスする仕組み自体はiOSでも使えます!

<!-- more -->

ところで、[]でインスタンスにアクセスするコードを書いたとき、これらはコンパイル時に、
``` objc
// id obj = array[0]; のときはこれになります
- (id)objectAtIndexedSubscript:(NSUInteger)index;
// array[0] = obj; のときはこれになります
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;

// id obj = array[key]; のときはこれになります
- (id)objectForKeyedSubscript:(id)key;
// array[key] = obj; のときはこれになります
- (void)setObject:(id)object forKeyedSubscript:(id)key;
```
に変換されるそうです。

これらの変換自体はiOSがターゲットの場合でも行われているようです。

## 例えば独自クラスに上記メソッドを実装すると...

例えば、以下のように適当なクラスに上記４つのメソッドを実装してみました。

``` objc Wrapper.h
@interface Wrapper : NSObject

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)object forKeyedSubscript:(id)key;

@end
```
``` objc Wrapper.m
#import "Wrapper.h"

@interface Wrapper ()
@property (strong) NSMutableDictionary* dictionary;
@end 

@implementation Wrapper

- (id)init
{
  if ( (self = [super init]) ) {
    self.dictionary = [NSMutableDictionary dictionary];
  }
  return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)index
{
  return [self.dictionary objectForKey:@(index)];
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index
{
  return [self.dictionary setObject:object forKey:@(index)];
}

- (id)objectForKeyedSubscript:(id)key
{
  return [self.dictionary objectForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id)key
{
  return [self.dictionary setObject:object forKey:key];
}

@end
```

ただ単純に４つのメソッドを実装し、そのメソッドが呼ばれたときには、中で持っているNSMutableDictionaryにアクセスするようにしているだけです。

このクラスを使って、以下のようなコードをビルド＆実行してみると、
``` objc
Wrapper* w = [Wrapper new];

w[0] = @0;
w[1] = @100;
w[@2] = @200;
NSLog( @"%@, %@, %@", w[0], w[@1], w[2] ); //< 0, 100, 200
```
普通にビルドが通り、ログも `0, 100, 200` と想定どおりのものが出力されました。

## どうしても今すぐ使いたければNSArrayやNSDictionaryでも

iOSではまだ残念ながらNSArrayやNSDictionaryの要素に[]でアクセスすることは出来ないということなのですが、じつは上記メソッドを各クラスに宣言さえしてやればiOSアプリ開発でも利用できるとのことです（こちらは [@saryou_ssk](https://twitter.com/saryou_ssk) さんにリンクを教えていただきました)。

例えば、NSArrayにカテゴリで
``` objc
@interface NSArray (Subscripting)
- (id)objectAtIndexedSubscript:(NSUInteger)index;
@end 
```
と宣言してやれば、
``` objc
NSArray* array = @[@0, @1, @2];
NSLog( @"array[1] = %@", array[1] ); //< 1
```
と、NSArrayの要素を[]で取得することができるようになります。

どうしても今すぐ使いたいということであれば、同様に、NSMutableArray、NSDictionary、NSMutableDictionaryのカテゴリで上記４メソッドの必要なものを宣言してやればそれぞれ[]での値の読み書きが可能になります。

