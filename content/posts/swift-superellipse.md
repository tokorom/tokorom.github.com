---
title: "スーパー楕円UIをiOS+Swiftで実装する"
date: 2021-01-29T15:04:26+09:00
draft: false
authors: [tokorom]
tags: [Swift,iOS,UI]
images: [/images/swift-superellipse/top.png]
canonical: https://spinners.work
---

![image](/images/swift-superellipse/top.png)

弊社デザイナーの [@kudakuarge](https://twitter.com/kudakurage) が [スーパー楕円に関する良記事](https://www.spinners.work/posts/kudakurage-superellipse-desgin/) を投稿していました。

スーパー楕円は最近話題になっているClubhouseでも使われているとのこと。

![clubhouse](https://www.spinners.work/images/kudakurage-superellipse-desgin/image14.png)

そのため便乗してiOS+Swiftでスーパー楕円UIを実装してみます。

## どう実装する？

iOSアプリの上で上に`UIImageView`とか様々なViewをのせるような使い方をすることになりそうですので、基本的には`UIView`のサブクラスである必要がありそうです。

スーパー楕円を表示（描画）するだけなら`UIBezierPath`などでスーパー楕円を作って [UIViewのdrawメソッド](https://developer.apple.com/documentation/uikit/uiview/1622529-draw) をオーバーライドしてfillするなどで良さそうです。

しかし、上の`UIImageView`などをのせて、上にのせたViewも一緒にスーパー楕円でマスクされないといけないので、 [CALayerのmask](https://developer.apple.com/documentation/quartzcore/calayer/1410861-mask) でスーパー楕円の形にマスクすべきかもしれません。

## スーパー楕円はどう作る？

[上の記事](https://www.spinners.work/posts/kudakurage-superellipse-desgin/) にJavaScriptのサンプルコードがありますが、これはベジェ曲線での描画ではなく、スーパー楕円を構成するドットの配列を作る礼のため、今回の用途にはアンマッチです。

ただ、同じ記事の後半でFigmaやSketchなどのツールで円形からアンカーポイントを移動させてスーパー楕円を作る例が紹介されていて、おそらくこの例のように4つのベジェ曲線を使い、アンカーポイントを調整することでスーパー楕円が作れるだろうということが予想できました。

![sample](https://www.spinners.work/images/kudakurage-superellipse-desgin/image24.png)

## 実装例

ということで、まずは`UIBezierPath`でスーパー楕円を作ってみます。
引数で渡した四角形（`CGRect`）に沿って、4つのベジェ曲線を追加しているだけです。

引数`k`でアンカーポイントの位置（結果としてスーパー楕円の丸み）を調整できるようにしています。

```swift
import UIKit

open struct Superellipse {
  let bezierPath: UIBezierPath

  public init(in rect: CGRect, k: CGFloat) {
    let path = UIBezierPath(ovalIn: rect)

    let handleX: CGFloat = rect.size.width * k / 2
    let handleY: CGFloat = rect.size.height * k / 2

    let left = CGPoint(x: rect.minX, y: rect.midY)
    let top = CGPoint(x: rect.midX, y: rect.minY)
    let right = CGPoint(x: rect.maxX, y: rect.midY)
    let bottom = CGPoint(x: rect.midX, y: rect.maxY)

    path.move(to: left)
    path.addCurve(
      to: top,
      controlPoint1: CGPoint(x: left.x, y: left.y - handleY),
      controlPoint2: CGPoint(x: top.x - handleX, y: top.y)
    )
    path.addCurve(
      to: right,
      controlPoint1: CGPoint(x: top.x + handleX, y: top.y),
      controlPoint2: CGPoint(x: right.x, y: right.y - handleY)
    )
    path.addCurve(
      to: bottom,
      controlPoint1: CGPoint(x: right.x, y: right.y + handleY),
      controlPoint2: CGPoint(x: bottom.x + handleX, y: bottom.y)
    )
    path.addCurve(
      to: left,
      controlPoint1: CGPoint(x: bottom.x - handleX, y: bottom.y),
      controlPoint2: CGPoint(x: left.x, y: left.y + handleY)
    )

    self.bezierPath = path
  }
}
```

あとは、ここで作った`UIBezierPath`でマスクされる`UIView`サブクラスを作ってあげるだけです。

```swift
import UIKit

@IBDesignable
public final class SuperellipseView: UIView {
  @IBInspectable public var k: CGFloat = 0.75

  public override func draw(_ rect: CGRect) {
    backgroundColor?.setFill()
    Superellipse(in: rect, k: k).bezierPath.fill()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    let path = Superellipse(in: bounds, k: k).bezierPath
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
}
```

とても簡単ですね！

## 利用例

実際に利用するのは簡単です。
例えば、スーパー楕円形のサムネイル画像を表示するなら、

```swift
let superellipseView = SuperellipseView(frame: CGRect(x: 40, y: 40, width: 100, height: 100))
superellipseView.backgroundColor = .clear
view.addSubview(superellipseView)

let imageView = UIImageView(image: UIImage(named: "mayuge_dog_face"))
imageView.frame = superellipseView.bounds
superellipseView.addSubview(imageView)
```

こんな感じに`SuperellipseView`を`addSubview`して、その上にサムネイル画像を設定した`UIImageView`を`addSubview`するだけです。

![image](/images/swift-superellipse/ss-1611901779.png)

## 課題

本当は [上の記事](https://www.spinners.work/posts/kudakurage-superellipse-desgin/) で紹介されているような `n=2.5` とか `n=3.5` といった係数をそのまま反映させるものを作りたかったのですが、私の頭で短時間でこれを実現することはできませんでした...

この辺りわかるかた是非ご教示ください！

## 公開

上で実装してみた `SuperellipseView` をお手軽に使ってみたいというかたがいらっしゃったら、

https://github.com/tokorom/SwiftSuperellipse

にSwiftPackage化して公開していますのでお試しください！

