---
title: "[visionOS] 最もシンプルな完全没入空間を試すサンプルコード"
date: 2023-09-28T11:00:50+09:00
draft: false
author: "tokorom"
authors: [tokorom]
tags: [visionOS, RealityKit]
images: [/images/visionos-simplest-full-immersion-space-app/top.png]
canonical: https://spinners.work
---

![image](/images/visionos-simplest-full-immersion-space-app/top.png)

ぼくがやりたかったのはシンプルに完全没入空間 `immersiveStyle = FullImmersionStyle` になにか表示するというだけなのですが、それなのに地味にはまったため記事にしています。

## 完全没入空間とは

日本語訳が正しいかわかりませんが、パススルー領域が全くない３６０度全面が1つのアプリで覆われた空間が完全没入空間です。

visionOSならではのUIであるため、なにかしら試してみたいかたも多いのではないでしょうか。

Appleのサンプルでは宇宙空間に没入するデモがあります。

![image](/images/visionos-simplest-full-immersion-space-app/clip-1695867505.png)

## 最もシンプルなサンプルがほしい！

このAppleのサンプルを動かせばことが済む話でもあるのですが、このサンプルでも地球や月などのコンテンツを読み出してRealityViewに設置するなどしなければならず、RealityKitに慣れていない僕にとってはこれでも冗長かなあという感覚でした。

僕からすると未知のファイルなどがなにもなく、単に目の前に四角形が1つ出る程度の最もシンプルなものが欲しかったんです。

それをベースにちょっとずつ自分で実験をしていければ、と。

## これが最低限の３ファイルだ！

### app.swift

アプリのエントリポイントです。

```swift
import SwiftUI

@main
struct SimplestFullImmersionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
        .immersionStyle(selection: .constant(.full), in: .full)
    }
}
```

- body内に初期表示される `WindowGroup` と `ImmersiveSpace` を置きます
- `ImmersiveSpace` は完全没入スタイルにするため `immersionStyle` に `full` を指定します

### ContentView.swift

初期表示されるWindowのViewです。


```swift
import SwiftUI

struct ContentView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {
        Button("Open Immersive Space") {
            Task {
                await openImmersiveSpace(id: "ImmersiveSpace")
            }
        }
    }
}
```

- Environmentの `openImmersiveSpace` を使えるようにします
- Buttonを1つ設置し押したら `openImmersiveSpace` で app.swift に定義した `ImmersiveSpace` を開くようにします

ここは本来はエラーハンドリングや `dismissImmersiveSpace` にも対応するほうが良いですが、最小限にするため削ってあります。

### ImmersiveView.swift

これが今回のメインコンテンツ。
完全没入空間で表示するViewです。

```swift
import SwiftUI
import RealityKit

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            let entity = Entity()
            content.add(entity)
            let box = ModelEntity(mesh: .generateBox(size: 0.5))
            box.position = .init(x: 0.5, y: 1.5, z: -0.5)
            entity.addChild(box)
        }
    }
}
```

- `RealityKit` をimportし、bodyから `RealityView` を返します
- `RealityView` のコンテンツとして `Entity` をaddします
- 没入空間に1つ箱を置くため `generateBox` で作った箱を `Entity` にaddします
- そしてここがポイントなのですが箱の `position` を設定しないと見える位置に表示されません

以上のコードが完全没入空間に箱を表示するための最低限のコードだと思います。

## positionについて

positionは自分の足元が `x: 0, y: 0, z: 0` になるとのことなので、

- `x: 0.5` で少し右にずらす
- `y: 1.5` で目線より高いくらいの位置にする
- `z: -0.5` で少し奥側に移動する

としてみています。

僕は初心者すぎてこの `position` がわかっておらず「addしたはずの箱が表示されない！」とずっとはまっていました...

## まとめ

この最低限の3つのコードをvisionOSシミュレータで動かすと、

![image](/images/visionos-simplest-full-immersion-space-app/top.png)

のようにピンクの縞の謎の箱が目の前に現れずはずです！


これをベースに完全没入空間でいろいろと遊んでいければと考えています。

このコードはBuild&Run可能なプロジェクトとして

https://github.com/tokorom/SimplestFullImmersion

に置いてあります。

