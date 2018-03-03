---
layout: post
title: "Objective-Cでカリー化とか部分適用してみる"
date: 2013-11-04
comments: true
external-url: 
categories: [objc,ios,haskell]
---

## 導入

[会社](https://info.cookpad.com/)でHaskell勉強会に参加して、カリー化とか部分適用のパートの輪読当番になったのだが、正直、輪読時点でもそれがなんなのかよくわかっていませんでした。
しかし、勉強会で参加者のみなさまに教えてもらった結果、カリー化とかがやっと理解できました！

ということで嬉しくなって先日寝るときに布団の中で「Objective-Cでもできるかなー」と脳内コーディングしてみた結果を実装してみました。

もう他の人がやってるかもとか、こんなん実装しても実際のところ使わないよねとか、そんなことはまったく気にせずです。

実際やってみたソースコードは [こちら](https://github.com/tokorom/ObjcHaskell) に置いてあります。

## ひとまずのゴール

カリー化して部分適用ができる状態までということで、Haskellの`map`が実現できるところまでを目標にしました。

```
map (+3) [1, 2, 3]
```

これです。  
Objective-Cでは当然、空白区切りで引数を渡していくような構文はないわけなので、関数ポインタ的なやつを使って、

```
map (+3) ([1, 2, 3])
```

みたいな形で`()`で区切り、関数の実行結果として取得した関数ポインタ（実際に関数が返すのはBlock）を使って次の引数を渡す（要するにカリー化）することでこれを実現することにしました。

しかし、Objective-Cには演算子を()で囲ってセクション化するとかないし、リストのリテラルも違うので、やるとしたらこうなります。

```
map (OP('+') (@3)) (@[@1, @2, @3])
```

セクションに関しては、演算子を関数化するマクロを作り、その関数に引数を１つ部分適用するイメージとします。  

ということで、Objective-Cで上の`map`が実現できたらはじめのゴールとしては十分かなと思いました。

<!-- more -->

## カリー化の実現方法

実際にカリー化した関数の実装はこんなかんじになりました。これは２つの引数を加算して返す `add` の実装です。  

```
#define add [ObjcHaskell hsAdd]

+ (curryingBlock)hsAdd
{
    CURRYING2(
        x, y,
        return @([x intValue] + [y intValue]);
    );
}
```

`CURRYING2`という変なマクロを使ってObjective-Cらしからぬ見た目になってますが、マクロを展開すると実際はこうなります。

```
#define add [ObjcHaskell hsAdd]

+ (curryingBlock)hsAdd
{
    return (curryingBlock)^(id x) {
        return (unaryBlock)^(id y) {
          return @([x intValue] + [y intValue]);
        }
    }:
}
```

Blockを返すBlockを返す関数というかんじになってます。
外側のBlockは`x`という引数を取り、中側のBlockを返す。
中側のBlockは`y`という引数を取り、外側のBlockでキャプチャされた`x`と自分でキャプチャした`y`を加算した結果を返す。  
という実装です。

この関数の戻り値に引数を1つ（`x`にあたるもの）渡すと、中側のBlockが返されてそのBlockは最後の引数（`y`にあたるもの）を期待し、`x`はBlockの仕組みできちんとキャプチャ（保存）された状態になります。
これで部分適用もばっちりということです！

例えば、

```
curryingBlock add3 = add (@3);
```

とすれば、`add`に対して`@3`を部分適用した関数（正確にはBlock）が取得でき、

```
id result = add3 (@4);
```

で、`3 + 4` の結果、`7` を計算できます。

論理的には引数の数だけBlockを入れ子にしていくことで引数がいくつであっても対応可能なはず。

## 演算子の関数化

Objective-Cでは`+`とか`-`といった演算子は関数ではないのでそのままでは使えません。
ということで `OP('+')` みたいにマクロでなんとかすると説明したのですが、そのマクロはこんなかんじになってます。

```
#define OP(op) ([ObjcHaskell hsSectionWithOperator:op])
```

単に、charをObjective-Cのメソッドに渡してその演算子に適した関数を得ているだけです。  
このメソッドの実装は、

```
+ (curryingBlock)hsSectionWithOperator:(int)op
{
    switch (op) {
        case '+': return add;
        case '-': return sub;
        case '*': return mul;
        case '/': return div;
        case ':': return cons;
        case '<': return lessThan;
        case '>': return greaterThan;
        default: return [ObjcHaskell hsReturnNil];
    }
}
```

こんなかんじで、演算子に対応するカリー化した関数をそのまま返しています。

## 畳み込み

ではこの仕組みを使って畳み込み関数 `foldr` を作ってみましょう。

```
#define foldr [ObjcHaskell hsFoldr]

+ (curryingBlock)hsFoldr
{
    CURRYING3(
        binary, ini, list,

        id acc = ini;
        curryingBlock fnc = binary;
        for (id elem in [list reverseObjectEnumerator]) {
            acc = fnc (elem) (acc);
        }
        return acc;
    );
}
```

`CURRYING2`が`CURRYING3`になっただけで、あとの考え方はさっきと同じです。
`foldr`の１つめの引数は２つの引数を持つ関数です。ここでは`binary`がそれに相当します。  
最終的には`binary`にリストの要素を１つずつ渡して計算していくわけで、

```
id acc = ini;
curryingBlock fnc = binary;
for (id elem in [list reverseObjectEnumerator]) {
    acc = fnc (elem) (acc);
}
```

の部分がそれに相当します。  
リストの要素を１つずつ取り出して、初期値（もしくは前の計算結果）と一緒に `binary` に渡していくだけです。

あとは最後の計算結果（`acc`）をreturnすれば`foldr`の完成です！

## ちょっとHaskellっぽく関数実装

では、この畳み込みを使ってさらに新しい関数 `sum` を作ってみましょう。
`sum` は引数に渡したリストの要素を足し合わせたものを返す関数です。

```
#define sum [ObjcHaskell hsSum]

+ (curryingBlock)hsSum
{
    return ((id)
        foldr OP('+') (@0)
    );
}
```

こんなかんじで、さきほど作った`foldr`を使って簡単に実装できました。

## 最後にmapの実装

`map`ですが本来は畳み込みで実現したかったのですが、今のところはラムダ式に対応していないためできませんでした。
今回はベタに普通のObjective-C的に中身を実装してます。

```
+ (curryingBlock)hsMap
{
    CURRYING2(
        unary, list,
        curryingBlock fnc = unary;
        NSMutableArray* ret = [NSMutableArray array];
        for (id elem in list) {
            [ret addObject:(fnc (elem))];
        }
        return ret;
    );
}
```

引数を１つ持つ関数とリストの２つをもらって、そのリストの要素１つ１つにその関数を適用しているだけです。

## mapを実行

ということで、

```
map (OP('+') (@3)) (@[@1, @2, @3])
```

を実現する仕組みが出そろいました。

早速テストを実行してみると...

```
- (void)testMap
{
    id result = map (OP('+') (@3)) (@[@1, @2, @3]);
    XCTAssertEqualObjects(result, (@[@4, @5, @6]), @"result is invalid");
}
```

無事に `@[@4, @5, @6]` が返るのを確認できました。

やったー！

まあこれをiOSアプリ開発で使うことはないでしょうが、楽しかった。。。

　
