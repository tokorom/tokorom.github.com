---
layout: post
title: "Objective-Cのテストクラスからプライベートメソッド/プロパティを参照したい"
date: 2012-09-12 14:10
comments: true
external-url: 
categories: ios objc
---

dkfjさんが [Objective-Cで、プライベートメソッド・プロパティにアクセスし、ユニットテストを実行する方法](http://d.hatena.ne.jp/dkfj/20120909/1347176787) という記事を書かれていました。

せっかくなので私がやっている方法も書かせていただきます。

## テスト対象のクラス

以下のようにプライベートメソッドとプロパティを持ったExampleClassをテストするとします。
``` objc
#import "ExampleClass.h"

@interface ExampleClass()
- (BOOL)privateMethod;
@property (assign) BOOL flag;
@end

@implementation ExampleClass

- (BOOL)privateMethod
{
  return self.flag;
}

@end
```

## テストクラス

自分の場合は、こんなかんじでテストクラスでテスト対象のプライベートメソッドやプロパティを宣言し直して使ってます。

<!-- more -->

``` objc
#import <GHUnitIOS/GHUnit.h> 
#import "ExampleClass.h"

@interface ExampleClass (Private)
- (BOOL)privateMethod;
@property (assign) BOOL flag;
@end

@interface ExsampleClassTest : GHTestCase
@end

@implementation ExsampleClassTest

- (void)testPrivateMethod
{
  ExampleClass* example = [ExampleClass new];
  GHAssertFalse([example privateMethod], nil);
  example.flag = YES;
  GHAssertTrue([example privateMethod], nil);
}

@end
```

## メリットとデメリット

### メリット

* プライベートメソッドを（テストクラス以外からは）プライベートなまま保てる

### デメリット

* 本体のほうのメソッドが変わったらテストクラスのほうの宣言も書き直す必要がある

