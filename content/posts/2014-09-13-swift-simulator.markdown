---
layout: post
title: "SwiftでiOSシミュレータのときだけAFNetworkActivityLoggerを使う"
date: 2014-09-13
comments: true
external-url: 
categories: [swift, ios]
aliases: [/2014/09/13/swift-simulator/]
---

だいぶ小ネタ。

## コード

```
#if (arch(i386) || arch(x86_64)) && os(iOS)
    AFNetworkActivityLogger.sharedLogger().level = .AFLoggerLevelDebug
    AFNetworkActivityLogger.sharedLogger().startLogging()
#endif
```

`UIDevice`を使う方法もあるが、そちらは実際に動いたときに判別することになる。  
こちらだとそもそもiPhone用のアプリからはこのコード自体省かれる形になる。

## 意味

- `arc(i386)`
    - 32bitのMac（シミュレータ）用のビルド
- `arc(x86_64)`
    - 64bitのMac（シミュレータ）用のビルド
- `os(iOS)`
    - ターゲットがMacじゃなくてiOS

## オマケ

ぼくの手元では、デバッグ実行時に

```
#if DEBUG
    println("DEBUG")
#endif
```

で `DEBUG` が出力されない。普通は出力されるはず？？
