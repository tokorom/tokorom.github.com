---
title: "[visionOSアプリ練習] SwiftUIアプリで3Dモデルを表示する"
date: 2023-06-26T17:27:14+09:00
draft: false
author: "tokorom"
authors: [tokorom]
tags: [visionOS,SwiftUI]
images: [/images/visionos-volume-3dmodel/top.png]
canonical: https://spinners.work
---

visionOS SDK Betaがリリースされましたので少しずつ勉強していきます！
まずは第一歩目としてSwiftUIアプリの中で3Dモデルを表示してみました。

## どうやって表示する？

WWDCセッションの紹介としてはどうやらSwiftUIのViewで

```swift
Model3D(named: "xxx")
```

とするだけで表示できるようです。
簡単すごい！


## どんな3Dモデルを表示できる？

https://developer.apple.com/documentation/realitykit/model3d/init(named:bundle:) によると

> The name of the USD or Reality file to display.

- USDファイル
- Realityファイル

を読み込めるよう。

Realityファイルについてはよく知らないがApple独自のものっぽいです。

USDは [Universal Scene Description](https://ja.wikipedia.org/wiki/Universal_Scene_Description) といってピクサーの開発した3Dシーングラフ形式とのことらしい。

今回はどこかからUSDファイルをお借りして表示してみることにします。

## 使わせていただいたUSDファイル

[J CUBE Inc. - Maneki USDZ for AR](https://j-cube.jp/solutions/multiverse/assets/) / [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.ja)

![image](/images/visionos-volume-3dmodel/maneki.png)

## ベースとなるSwiftUIアプリ

マルチプラットフォーム対応のシンプルなSwiftUIアプリをベースとしました。

## App

```swift
import SwiftUI

@main
struct app: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.volumetric)
    }
}
```

SwiftUIアプリはデフォルトではWindowタイプ（平面）になるため、3D表示するためのVolumeタイプにするため、WindowGroupに `.windowStyle(.volumetric)` モディファイアを適用しました。
変更したのはその1行だけです。

## 実行時エラー

ただ、これを実行しようとすると以下の実行時エラーが出てしまいます。

> Thread 1: Fatal error: SwiftUI Scene with VolumetricWindowStyle requires a UISceneSessionRole of "UIWindowSceneSessionRoleVolumetricApplication" for key UIApplicationPreferredDefaultSceneSessionRole in the Application Scene Manifest.

デフォルトのSceneのWindowGroupをVolumeにするにはApplication Scene Manifestに設定をしなければならないようです。
エラーに書かれているとおりですが、アプリのInfo.plistを以下のように更新しました。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>UIApplicationSceneManifest</key>
	<dict>
		<key>UIApplicationPreferredDefaultSceneSessionRole</key>
		<string>UIWindowSceneSessionRoleVolumetricApplication</string>
	</dict>
</dict>
</plist>
```

## 3Dモデルファイルをアプリに追加

それでは、アプリに招き猫のUSDファイルを加えてみます。

`Model3D`のイニシアライザ的にプロジェクトにそのまま突っ込むのが簡単そうでしたので、今回はなにも考えずXcodeプロジェクトに `maneki.usdz` をドラッグ＆ドロップしました。

![maneki-drop](/images/visionos-volume-3dmodel/maneki-drop.png)

## SwiftUIのViewで3Dモデルを表示

ということでViewで3Dモデルを表示するコードを書くわけですが、本当にこれだけで終わりでした。

```swift
import RealityKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        Model3D(named: "maneki")
    }
}
```

## シミュレータで実行

これをApple Vision Proシミュレータで実行すると、こんな感じに見事に招き猫が出現！

![sample1](/images/visionos-volume-3dmodel/sample1.png)

そしてもちろん、Volumeで3D表示しているので場所を動かしたり、別の角度から眺めたりもできました。


![sample2](/images/visionos-volume-3dmodel/sample2.png)

## トラブルシューティング

と、簡単に3Dモデルを表示できるわけですが、実際に試した時には`Model3D`がうまくファイルを読み込んでくれないなどのトラブルもありました。そんな時にどんな理由でファイルを読めないかなどを知りたい場合には、 [こちらのイニシアライザ](https://developer.apple.com/documentation/realitykit/model3d/init(named:bundle:transaction:content:)) を使うことでデバッグが可能でした。


```swift
Model3D(named: "maneki") { phase in
    if let model = phase.model {
        model
    } else if let error = phase.error {
        Text(error.localizedDescription)
    } else {
        Text("other reasons...")
    }
}
```

## ソースコード

今回試したソースコードは [こちらのGitHubリポジトリ](https://github.com/tokorom/vision-os-samples) に含まれております。

