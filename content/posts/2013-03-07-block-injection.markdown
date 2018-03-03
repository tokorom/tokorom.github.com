---
layout: post
title: "BlockInjectionで元のソースコードを汚さないで振る舞い追加"
date: 2013-03-07
comments: true
external-url: 
categories: [ios, objc]
---

## 例えばこんなコードに違和感はありませんか？

自分の場合よくあることなのですが、例えばiOSアプリを開発していて、Google Analytics のトラッキングのためのコードを加えるとき、

``` objective-c
- (IBAction)sendButtonDidPush:(id)sender
{
  // トラッキングのためのコード
  [tracker sendEventWithCategory:@"uiAction"
                      withAction:@"sendButtonDidPush"
                       withLabel:nil
                       withValue:0];

  // ...
  // 以降、送信ボタンを押したときの処理
  // ...
}
```

こんなかんじにボタンが押されたときの処理のところにトラッキングのためのコードを埋め込んだりすると思います。

これはこれで問題はないのですが、プログラムのあちらこちらにトラッキングのためのコードを埋め込んで、本来の処理のコードを汚してしまっているのに違和感がありました。

どうにかしてトラッキングのためのコードを外出しに（また、理想的にはどこかにひとまとめに）できないものでしょうか？  
いわゆるアスペクト指向的なかんじで。

## そんなときに BlockInjection

ということで本題に入りますが、それを解決するために [BlockInjection](https://github.com/tokorom/BlockInjection) というライブラリを作りました。  
古くは AspectCocoa だったりいくつかそれっぽいのはあったのですが、いずれも古い、大きすぎるなどの理由で適切なものが見つからなかったため、この目的に特化したライトなやつとして作っています。

例えば、上記のコードの場合、こんなかんじで外側から処理を埋め込めます。

<!-- more -->

``` objective-c
#import "BILib.h"

[BILib injectToClass:[XXXViewController class] selector:@selector(sendButtonDidPush:) preprocess:^{

  // sendButtonDidPush: が実行される直前にこのコードが実行されます
  [tracker sendEventWithCategory:@"uiAction"
                      withAction:@"sendButtonDidPush"
                       withLabel:nil
                       withValue:0];

}];
```

これで元のソースコードをいじらずにトラッキングの処理を埋め込むことができるようになりました！

以下、Q&A方式でライブラリの機能を簡単に紹介させていただきます。

## 対象となるクラスをimportしないと使えないとかダサくない？

確かに、トラッキングのコードをまとめたいときなど、各クラスに処理を埋め込むためにimportがずらっっと並ぶのも不恰好です。  
そんなときのために、クラス名もメソッド名も文字列で指定できるインターフェスが用意されています。

``` objective-c
[BILib injectToClassWithName:@"XXXViewController" methodName:@"sendButtonDidPush:" preprocess:^{
  // 埋め込みたい処理
}];
```

## 対象となるクラスインスタンスのpropertyを参照できないと意味ないよ

確かに、ただ処理を埋め込むだけでなく、対象となるインスタンスによって処理が変わるようなことは多々ありますよね。  
そんなときは埋め込むブロックの第1引数に対象となるインスタンスが渡ってくるのでそれを利用できます。

``` objective-c
[BILib injectToClass:[XXXViewController class] selector:@selector(sendButtonDidPush:) preprocess:^(XXXViewController* vc){

  // ここでXXXViewControllerの中身が好きなように参照可能
  NSLog(@"State: %d", vc.state);

}];
```

## 実行したメソッドの引数が使えないと意味ないよ

確かに、引数が参照できないと困ることがありますよね。
そんなときは埋め込むブロックの第2引数以降で全ての引数が参照できます。

``` objective-c
[BILib injectToClass:[Sample class] selector:@selector(sayMessage:) preprocess:^(Sample* sample, NSString* message){

  // 例えば、[[Sample new] sayMessage:@"Hello!"]; の引数もここで参照できます
  NSLog(@"sayMessage: %@", message);

}];
```

## ほんとうにどんなメソッドのどんな引数にでも対応できてるの？

鋭いご指摘ですね。。。  
たしかにいろいろな引数に対応するのはライブラリの実装的に厄介でした。  
現に似たようなライブラリは渡す引数のtypeのsizeが4byte以下の引数にしか対応できていなかったりします（例えばCGRectなどが引数に渡ってきても参照できないとか）。  
BlockInjectionは、現状（v0.3.0）、1096byte以下のtypeには対応しているので現実的に困ることはないと思います。  

そのため、例えば特定の画面を表示したときに、UIKitが内部的にどんなViewを持っていてどこに配置しているかを調査するために、

``` objective-c
[BILib injectToClass:[UIView class] selector:@selector(setFrame:) preprocess:^(UIView* view, CGRect frame){

  NSLog(@"%@ setFrame:(%f, %f, %f, %f)", NSStringFromClass([view class]), frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);

}];
```

といったコードを埋め込むこともできます。  
これで目には見えないViewも丸わかりです。

## インストール方法

[https://github.com/tokorom/BlockInjection](https://github.com/tokorom/BlockInjection)
の`BlockInjection`ディレクトリだけをプロジェクトに追加してもらえれば利用できます。


CocoaPodsをご利用のかたは、`Podfile`に、

``` ruby
platform :ios, '5.0'

pod 'BlockInjection', :git => 'https://github.com/tokorom/BlockInjection.git'
```

を指定していただければOKです。
