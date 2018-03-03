---
layout: post
title: "Objective-Cで非同期処理のテストをシンプルに書く方法"
date: 2014-04-21
comments: true
external-url: 
categories: [objc,ios,tdd]
---

{% img center http://dl.dropbox.com/u/10351676/images/TKRGuard_image.png %}

## 非同期処理のテストってどう書いてますか？

標準のXCTest自体がサポートしていれば良いのですがそうではないので、非同期処理のテストを書きたい場合には、その仕組みを自作するか出来合いのライブラリを利用する必要があります。現実的な選択肢としては、

- GHUnitやKiwiなど非同期処理をサポートしたテストフレームワークを利用する
- GHunitの非同期処理のテストの仕組みを真似て抜粋したライブラリを利用する（意外とこれが多いかも？）
- expectaなどのマッチャーライブラリに付属の非同期処理の仕組みを使う

となるかと思います。
ただ、私が調べた時点だとどれもしっくりきませんでした。

まず、GHUnitやKiwiなどを採択している場合には良いのですが、非同期処理のテストを書くという目的だけのためにそれらのフレームワークを使うというのは冗長すぎます。

また、GHUnitの非同期処理の仕組みだけを抜き出したライブラリもありますが、TestCaseの親クラスを決まったものにしないといけない（例えば`GHAsyncTestCase`を継承したTestCaseで場合のみ利用できるとか）という縛りができるのと、非同期処理を発火する前に`prepare`とかを呼ばないといけないのがちょっと鬱陶しい。

そういう意味だとexpectaなどのマッチャー系のライブラリの場合、親クラスも限定されないし、非同期でマッチさせたいところでその機能を使うだけなのでとてもシンプルではあります。ただ、これはこれでマッチャーで非同期処理の完了を待つ性質上、マッチするときはいいけどマッチしないときはタイムアウトまでそこで処理が待たされるという大きな課題があります。

## こうしたい！

ぼくとしては理想的にはこういうライブラリを使いたいと思いました。

1. テストフレームワークを使っていなくても非同期処理のテストだけが実現できるシンプルなもの
2. TestCaseの親クラスが限定されないほうがよい
2. 余分なコードを書かずにシンプルに書きたい
3. それを利用することでテストの実行が遅くなったりしない

しかし、当初探した限りではこの条件にマッチするものが見つかりませんでした。

<!-- more -->

## 他言語ではどういう書き方をしている？

なお、他言語ではどういう書き方が一般的なんだろうと調べてはみたのですが、なかなかしっくりくるものが見つからず、Objective-Cでこう書けたらいいなあと思ったのは RubyMotionで使われている書き方 でした。

http://mobiletou.ch/2013/10/第五回-rubymotionでhttpや非同期処理を含むユニットテスト

```ruby
some_method_with_block {|some_data|
  @data = some_data
  resume
}

wait_max 1.0 do
  @data.should.equal foo
end
```

- 待たせたい場所で `wait`
- 待たせている処理が終わったら `resume`

という本当にシンプルで分かりやすい書き方です。

ということで、Objective-Cで同じようにWait & Resume方式で親クラスを限定せずに使えるシンプルなライブラリを作ることにしました。

## TKRGuard

そして作ったのが [TKRGuard](https://github.com/tokorom/TKRGuard)  です。

[TKRGuard](https://github.com/tokorom/TKRGuard) をimportするだけで先のRubyMotionとほぼ同じ書き方ができます。

```objective-c
// #import "TKRGuard.h"

__block NSString *response = nil;
[self requestGetAsyncronous:^(id res, NSError *error) {
    response = res;
    RESUME;
}];

WAIT;
XCTAssertEqualObjects(response, @"OK!");
```

- 待たせたい場所で `WAIT`
- 待たせている処理が終わったら `RESUME`

とするだけです。決まった親クラスも必要ありませんし、事前の`prepare`とかも必要ありません。

## RESUMEが呼ばれなかったらどうなるの？

`RESUME`が呼ばれない場合は`WAIT`のところでタイムアウトエラーになります。GHUnitで同様のケースが発生すると（少なくともぼくが使ったことがあるバージョンでは）Xcode上でテストケース以外のどこかの場所でエラーが発生したことになりどのテストケースでそれが発生したのかよくわからない状態になってしまいました。

[TKRGuard](https://github.com/tokorom/TKRGuard) ではきちんとどの `WAIT` の部分でタイムアウトが発生したかを、Xcode上でもCUI上でも確認できるようにしてあります。

{% img center http://dl.dropbox.com/u/10351676/images/TKRGuard_timeout.png %}

## GHUnitみたいにSuccessとかFailedを通知したい

一方でGHUnitでは待たせる処理が終わったときに `kGHUnitWaitStatusSuccess` や `kGHUnitWaitStatusFailure` を通知して、待っているほうで期待した通知が来ているかを判断する仕組みがあって、それが便利なケースもありました。

そのため、 [TKRGuard](https://github.com/tokorom/TKRGuard) でもその仕組みを貰っています。具体的には、

```objective-c
[self requestGetAsyncronous:^(id res, NSError *error) {
    if (error) {
        RESUME_WITH(TKRGuardStatusFailure);
    } else {
        RESUME_WITH(TKRGuardStatusSuccess);
    }
}];

WAIT_FOR(TKRGuardStatusSuccess);
```

というようにGHUnitと同じことができます。

## タイムアウトの時間を変更したい

```objective-c
[TKRGuard setDefaultTimeoutInterval:2.0];
```

でデフォルトのタイムアウトの時間を変更することができます。

また、`WAIT_MAX(2.0)`で特定の箇所だけタイムアウト時間を指定することも可能です。

## WAITとかRESUMEとかいうマクロを使いたくない

デフォルトではより簡単に短いコードで書くために`WAIT`や`RESUME`といったマクロを有効にしていますが、人によっては変な短いマクロを定義しないで欲しいと思うことがあるかもしれません。その場合は、 `UNUSE_TKRGUARD_SHORTHAND` を定義することでそれらを無効にできます。その場合は、`TKRGuard`クラスのクラスメソッドを自分で使ってWait&Resumeを書きます。

```objective-c
#define UNUSE_TKRGUARD_SHORTHAND

__block id result = nil;
[self requestGetAsyncronous:^(id res, NSError *error) {
    result = res;
    [TKRGuard resumeForKey:@"xxx"];
}];

[TKRGuard waitWithTimeout:1.0 forKey:@"xxx"];
XCTAssertEqualObjects(response, @"OK!");
```

## その他便利機能

`WAIT_TIMES(2)`で１つのWAITでRESUMEを2回待たせるといったことも可能です。
なにかが複数回発火するのを待たせたい場合に便利です。

## Kiwiでも使えますか？

使えます。Kiwiの非同期処理のテストはマッチャータイプで時間がかかることがあるため、非同期処理を待たせたいところだけ [TKRGuard](https://github.com/tokorom/TKRGuard) を使うのも有用かもしれません。

Kiwiを使う場合はKiwiをimportした後に`TKRGUARD_USE_KIWI`を定義してください。

```objective-c
#import "Kiwi.h"
#define TKRGUARD_USE_KIWI
#import "TKRGuard.h"

SPEC_BEGIN(KiwiTests)

describe(@"Sample", ^{
    it(@"can test asynchronous functions", ^{
        __block id result = nil;
        [Sample asyncronousProsess:^(id res) {
            result = res;
            RESUME;
        }];

        WAIT;
        [[result should] equal:@"OK"];
    });
});

SPEC_END
```

## インストール

CocoaPodsを使っている場合は、

```ruby
target :YourTestsTarget do
  pod 'TKRGuard'
end
```

とテストのターゲットを指定してインストールするのが良さそうです。

CocoaPodsを使っていない場合は [TKRGuardディレクトリ以下](https://github.com/tokorom/TKRGuard/tree/master/TKRGuard) のファイルをプロジェクトに突っ込んでいただければ利用可能になります。

