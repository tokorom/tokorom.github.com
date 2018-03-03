---
layout: post
title: "Swiftで部分適用（カリー化）"
date: 2014-07-30
comments: true
external-url: 
tags: [swift, ios]
aliases: [/2014/07/30/swift-partial-application/]
authors: [tokorom]
---

## Swiftオフィシャルの部分適用

まず、Swiftオフィシャルな構文として

```
func addTwoNumbers(a: Int)(b: Int) -> Int {
  return a + b
}
```

というように引数を１つ１つ別の括弧で囲ってfunctionを定義すると

```
let add1 = addTwoNumbers(1)
add1(b: 2) //< 3
```

というかんじに、

- まず、１つめの引数だけ部分適用（ここでは `a`）
- 部分適用したものに後から次の引数を適用（ここでは `b`）

というのができる。

## 専用の書き方じゃなくてふつうのfunctionに部分適用できないの？

使うかどうかは別としてHaskellみたいに全ての関数に部分適用できたら面白いなーと。

また、上のような専用の定義にしちゃうと `addTwoNumbers(1, 2)` みたいな普通の呼び方ができなくなっちゃうし。

そんなとき、 [Swiftの関数の引数は、常に一つ](http://qiita.com/dankogai/items/46fedc447dd93d1e0fbc) という記事に出会い、勉強になるなーと眺めていたら、あれ？ふつうのfunctionに部分適用するための関数作れるかもなーと思い立った。

## 実装

[https://github.com/tokorom/partial-swift](https://github.com/tokorom/partial-swift)

```
func partial<A, B, R>(function: (A, B) -> R, a: @auto_closure () -> A) -> (B) -> R {
    return { function(a(), $0) }
}
```

<!-- more -->

## 利用サンプル

```
func add(a: Int, b: Int) -> Int {
    return a + b
}

let add1 = partial(add, 1)
add1(2) //< 3
```

とこんなかんじで普通の `add()` というfunctionに `partial(add, 1)` といった形で部分適用できるようになります。  

`add()`自体は普通のfunctionなので、もちろん`add(1, 2)`という普通の呼び方もそのままできます。

## 遅延評価

ミソは `@auto_closure` を使った遅延評価です。これをやらないと

```
let add100 = partial(add, someting(100)) //< この時点で someting(100) が実行されちゃう

add100(10) //< ここでは実行済みの someting(100) の結果が使われる
```

といったかんじで、`partial` で部分適用した時点で適用した引数の内容が評価されちゃいます。しかし `@auto_closure` を活用することで、

```
let add100 = partial(add, someting(100)) //< この時点で someting(100) は実行されない！

add100(10) //< ここではじめて someting(100) が実行されてその結果が使われる
```

というように、本当に必要になるまで部分適用した引数の内容が評価されない形になりました。

## 参考

ちなみに、既に他の人もやってるかもなと思いGoogleで `swift partial` で検索したらこんな[Gists](https://gist.github.com/kristopherjohnson/4ee565cfcdf912deacf6)が...

ぼくがイメージしてたのと同じような実装で、かつ、こっちのGistsのほうが良さそうなところもあったので上の実装はそれを取り込んだものです。  
結果としては、このGistsに遅延評価の機能を加えたものが上の実装というかんじになりました。


