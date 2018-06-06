---
title: "Lottieでアプリにアニメーションを組み込む話（iOSプログラマー編）"
date: 2018-06-06T14:09:34+09:00
draft: false
authors: [tokorom]
tags: [ios,lottie,ui]
cover: "https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/yes.png"
---

## この記事について

この記事は [Lottieでアプリにアニメーションを組み込む話（デザイナー編）](http://kudakurage.hatenadiary.com/entry/2018/06/02/180828) を受けての **iOSプログラマー編** になります。
デザイナー編では実際にアニメーションを作る具体的な方法を含め解説されていますので是非ご参照ください。

## Lottieとは

LottieとはAdobe After Effectsで作ったアニメーションをそのままクライアントアプリで表示するためのライブラリです。
iOSやAndroidのネイティブアプリの他、React Nativeでも利用できます。

iOS用のライブラリは、

[https://github.com/airbnb/lottie-ios](https://github.com/airbnb/lottie-ios)

です。

### なにができるの？

- 作成されたアニメーション用JSONファイルをアプリに埋め込んでわずかなコードで再生することができます
- インターネット上に設置したJSONファイルを読み込んでアニメーションを再生することもできます
- アニメーションはリピート再生のほか、リバース再生やアニメーションスピードの調整もできます
- プログラムで任意のフレームまで、もしくは任意のフレームから再生することもできます
- 動的にアニメーション内の要素の色や位置を変更することができます
- UIViewControllerのトランジッションでも利用できます

### iOSのコードで作るよりもいいの？

もちろん、同じことをiOSアプリ内でプログラムでやっても良いとは思います。しかし、

- これまでアプリプログラマーが実装していた部分をデザイナーさんにお任せできるという選択肢ができる
- Androidや他のプラットフォーム上での同じアニメーションが利用できる
- プログラム内のアニメーション（View）のための複雑なコードを省略できる

ことは、多くの場合でメリットになりそうです。

## 事前準備

CarthageやCocoPodsでlottie-iosをプロジェクトに追加します（方法については省略します）。

## アニメーションを表示してみる

![yes](https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/yes.gif)

### JSONファイルの埋め込み

再生したいアニメーションJSONをアプリに埋め込むには、単純にXcodeのプロジェクトにドラッグ＆ドロップなどして追加するだけでOKです。[^xcassets]

### 再生するコード

```swift
import Lottie
```

```swift
let animationView = LOTAnimationView(name: "yes")
animationView.frame = view.bounds
view.addSubview(animationView)

animationView.play()
```

再生するのは本当に簡単で、Lottieをimprotし、`LOTAnimationView`をJSONファイル名指定で作成し、`addSubview`して`play()`するだけです。

なお、`LOTAnimationView`の`frame`は適切な大きさに設定する必要があり、デフォルトでは設定した`frame`の大きさでアニメーションが拡縮されて再生されます。これはこれで便利で、アニメーションの大きさを変えたい場合には利用できます。

上のサンプルはサイズを考えずに`addSubview`しており、

![yes-stretch](https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/yes-stretch.png)

のように意図しない大きさで再生されてしまいます。

### アニメーションのサイズを知る

アニメーションのサイズを知るには、

- 作成したデザイナーさんに聞く
- アニメーションのJSONファイルを覗いて調べる

他、プログラムで取得することもできます。

```swift
animationView.frame = animationView.sceneModel?.compBounds ?? view.bounds
```

`LOTAnimationView`には`sceneModel`プロパティがあり、このプロパティからアニメーションに関する情報を取得できます。
サイズに関しては`compBounds`プロパティで`CGRect`形式で参照できます。

## Asset CatalogにJSONを入れる

なお、普段からAsset Catalog（xcassets）を使われているかたは、このアニメーションJSONをAsset Catalogで管理したいと感じるかと思います。`LOTAnimationView`はfilePathでのアニメーション指定もサポートしていますので、

```swift
guard let path = Bundle.main.path(forResource: "yes", ofType: "json") else {
    return
}

let animationView = LOTAnimationView(filePath: path)
```

などでAsset Catalogに追加したアニメーションJSONを読み込むことができます。

## インターネット上にJSONを設置する

必要なら、アプリに埋め込まずにインターネット上のアニメーションJSONを参照し、後からアプリのバージョンアップなしでアニメーションを変更することもできます。

```swift
let animationJSON = "https://raw.githubusercontent.com/tokorom/lottie-ios-sample/master/app/resource/animations/yes.json"

guard let url = URL(string: animationJSON) else {
    return
}

downloadAnimationJSON(from: url) { [weak self] filePath in
    self?.setupAnimation(with: filePath)
    self?.animationView?.play()
}
```

```swift
private func downloadAnimationJSON(from url: URL, completion: @escaping (String) -> Void) {
    let task = URLSession.shared.downloadTask(with: url) { url, _, error in
        guard let filePath = url?.path else {
            print("handle error: \(String(describing: error))")
            return
        }

        DispatchQueue.main.async {
            completion(filePath)
        }
    }

    task.resume()
}

private func setupAnimation(with filePath: String) {
    guard let view = animationArea else {
        return
    }

    let animationView = LOTAnimationView(filePath: filePath)
    animationView.frame = animationView.sceneModel?.compBounds ?? view.bounds

    view.addSubview(animationView)
    self.animationView = animationView
}
```

こちらも特に難しいことはなく、`URLSession`の`downloadTask`などでダウンローどしたファイルを`LOTAnimationView(filePath: foo)`で利用するだけです。


[^xcassets]: Asset Catalogを利用する方法は後述します
