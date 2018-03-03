---
layout: post
title: "Objective-Cで\"@dynamic\"の使いどころを考える"
date: 2013-01-05
comments: true
external-url: 
categories: [objc,ios]
---

## Objective-Cの @dynamic はお好きですか？

ぼくはけっこう好きです。

`@synthesize`のほうは昔はほぼ必須で書かないといけなかったり [Xcode4.4で省略できるようになった](/2012/08/12/objc-new-statements/) ことで有名ですが、いっぽうで`@dynamic`のほうはあまり日の目を浴びていない気がします。

そこで、今日は`@dynamic`について再考してみることにしました。  
以下、ぼくが思い返してみて`@dynamic`がこんなときに便利だったと感じたところを２点挙げさせていただきます。  
みなさまのほうでも「こんなとき便利だよ」というのがありましたら是非ご教示ください。

## クラスの内部実装が適当なのを隠すときに

そもそもこの実装自体がどうかという話もあるのですが、リファクタリング前にひとまず雑な実装をしてしまうことはままあります。  
例えば、ゲームスコアを管理する`GameScore`クラスを作ったとして、その中で **ハイスコア** とかいくつかのスコアを管理する際、`scores`というNSDictionaryインスタンスにささっと入れていたとします（ほんとは普通にプロパティにしたほうが良いですが例として）。

<!-- more -->

* GameScore.m

```objc
#import "GameScore.h"

@interface GameScore ()
@property (strong) NSMutableDictionary* scores;
@end 

@implementation GameScore

- (id)init
{
  if ((self = [super init])) {
    self.scores = [@{
      @"highScore": @1000,
      @"currentScore": @530,
      @"friendScore": @890,
    } mutableCopy];
  }
  return self;
}
```

この **ハイスコア** を外（他のクラス）から参照させたい場合、どう実装しますか？

### ダメそうな例 : NSDictionaryのインスタンスをそのまま公開してしまう

* GameScore.h

```objc
@interface GameScore : NSObject
@property (strong) NSMutableDictionary* scores;
@end
```

手っ取り早いのは`scores`プロパティをそのままPublicなプロパティとしてアクセス可能にしてしまう方法でしょうか。  
たしかに簡単ですが、外部から内部データ（NSDictionary）を好きなようにいじられたり見られたりするのは避けたいところです。このままだとかなり密結合なかんじです。  
Privateな範囲だったらまだ雑でも（後からリファクタリングすれば）良いかもしれませんが、外部から使われる部分はきちんとして疎結合にしておきたいところです。

### 本当に必要な部分だけ公開する

だったら本当に必要な部分だけ公開すべきということで、こういうのはどうでしょう？

* GameScore.h

```objc
@interface GameScore : NSObject
- (NSUInteger)highScore;
@end
```

* GameScore.m

```objc
- (NSUInteger)highScore
{
  return [self.scores[@"highScore"] unsignedIntegerValue];
}
```

`highScore`というハイスコアだけを参照するPublicメソッドを追加してみました。  
こっちのほうが筋が良さそうです。  
これでNSDictionaryで管理している適当な実装を後から修正しても外のクラスには影響しない形になりました。

### さらに @dynamic がお好きな人向けに

ただ、ぼくは`@dynamic`を愛しているのでここに`@dynamic`を突っ込んでいきます。

* GameScore.h

```objc
@interface GameScore : NSObject
@property (assign, readonly) NSUInteger highScore;
@end
```

* GameScore.m

```objc
@dynamic highScore;
- (NSUInteger)highScore
{
  return [self.scores[@"highScore"] unsignedIntegerValue];
}
```

やってることは１個前のサンプルと全く同じですが、`@property`で公開したほうがなんかかっこいい（自己満足）気がします。  
強いて言うなら、こっちの場合、ハイスコアを`@property (assign) NSUInteger highScore;`というPrivateプロパティで管理するようにリファクタリングした後もPublicな`@property (assign, readonly) NSUInteger highScore;`とそのまま連携できるというメリットはあります（本当に強いて言うならですが）。

## 重いクラスの初期化を簡便に書きたいときに

例えば、先ほどの`GameScore`クラス内で`HeavyFunction`というとっても重い（初期化に時間がかかるとかメモリをたくさん消費するとか）クラスを使う必要があったとします。  
とっても重いので、

* 実際に使うことが確定してから`new`をしたい
* 一度newしたらプロパティに持たせて再利用したい

ところです。  
ということで、以下のように実装してみました。

### 普通に実装してみた例

* GameScore.m

```objc
@interface GameScore ()
@property (strong) HeavyFunction* heavyFunction;
@end 

- (void)doSomething1
{
  if (!self.heavyFunction) {
    self.heavyFunction = [HeavyFunction new];
  }
  [self.heavyFunction execute];
}

- (void)doSomething2
{
  if (!self.heavyFunction) {
    self.heavyFunction = [HeavyFunction new];
  }
  [self.heavyFunction execute];
}
```

まず、`HeavyFunction`のインスタンスをPrivateなプロパティとして保持するようにしています。  
`doSomething1`と`doSomething2`が`HeavyFunction`を利用したメソッドとすると、それが呼ばれたタイミングではじめて`HeavyFunciton`が`new`されるよう留意してあります。具体的には、各メソッド内で`self.heavyFunction`が`nil`かどうかをチェックして、`nil`なら`HeavyFunction`を`new`するという実装にしています。  
どうやらこれで事足りそうです。

### さらに @dynamic がお好きな人向けに

ただ、ぼくは`@dynamic`を愛しているのでここに`@dynamic`を突っ込んでいきます。

* GameScore.m

```objc
@interface GameScore ()
@property (strong) HeavyFunction* heavyFunctionInstance;
@property (readonly) HeavyFunction* heavyFunction;
@end 

@dynamic heavyFunction;
- (HeavyFunction*)heavyFunction
{
  if (!self.heavyFunctionInstance) {
    self.heavyFunctionInstance = [HeavyFunction new];
  }
  return self.heavyFunctionInstance;
}

- (void)doSomething1
{
  [self.heavyFunction execute];
}

- (void)doSomething2
{
  [self.heavyFunction execute];
}
```

まず、`heavyFunction`プロパティとは別に`heavyFunctionInstance`というプロパティを設け、インスタンスはそのプロパティに持たせるようにしてしまいました。  
そして`heavyFunction`プロパティのほうは`readonly`にし、かつ、`@dynamic`でgetterを自分で書きます。  
そのgetterの中で`heavyFunctionInstance`プロパティの`nil`チェック & インスタンス作成をするようにしています。

こうすることで、実際にHeavyFunctionを使う`doSomething1`と`doSomething2`の中では、インスタンスが既に存在するかどうかを気にせずに`heavyFunction`プロパティを使うだけですむようになりました。  
`heavyFunciton`を使う箇所が増えれば増えるほどこのメリットは大きくなると思います。

## @dynamic は省略できます...

最後になりますが、じつは上記２つのサンプルのどちらでも`@dynamic`の行が省略可能です。  
ぼくは`@dynamic`を愛していますが、実際のところこの`@dynamic`を省略してしまっています。  
それでもぼくは`@dynamic`を愛しています。  目に見える愛だけが全てではないということなのだと思います。。。

