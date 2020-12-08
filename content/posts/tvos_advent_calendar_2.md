---
title: "テレビのリモコンのことも忘れないで！"
date: 2017-12-24
tags: [tvos,ui]
authors: [tokorom]
images: [https://qiita-image-store.s3.amazonaws.com/0/7883/330f9bdc-86fe-97b5-2dca-a2259c525739.jpeg]
---

## AppleTVで使えるリモコンって？

### Siriリモート

tvOS/AppleTVのリモコンといえばSiriリモートですよね。
皆様におかれましても日々のAppleTV生活ではSiriリモートを使われているかと思います。

### テレビのリモコン

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/dfe71005-eb5e-bc17-b112-1e0ffdd150ad.jpeg" height=200>


そしてもちろん普通のテレビのリモコンもAppleTVの操作に使えます！

AppleTVを利用しているということは当然テレビを利用しているわけで、AppleTVを使っている人のほとんどがテレビのリモコンを所持している、かつ普段使いしていることでしょう（AppleTVの操作をするかどうかは置いておいて）。
そのため、AppleTVの操作という意味ではSiriリモートに次いで利用するチャンスが多くなるリモコンかと思います。

### ゲームコントローラ/ゲームパッド

Nimbusなどのゲームコントローラも利用できますが、今回の主役は普通のテレビのリモコンのため、省略させていただきます。

## テレビのリモコンでどこまで操作できる？

### Apple純正のアプリ

全て確認したわけではないですが、ホーム画面はもちろん、純正アプリならテレビのリモコンだけでも一通りの操作ができるようになっているようです。

### サードパーティのアプリ

ゲームアプリ以外なら操作できることが多いようです。
ただしTouchサーフェス前提で組まれているアプリは操作不能です。

### 自分が開発するアプリはどうすべき？

タイトルには「忘れないで！」と書いたものの、実際のところそんなに気にしなくても良いのでは。
また、UIKitをシンプルに使って作ったアプリなら何も処置しなくてもテレビのリモコンで操作できるようになっています（後述します）。

## テレビのリモコンのボタンに対応するUIPressType

うちのテレビ（REGZA）のリモコンではこんな感じになっていました。他のテレビのリモコンも概ね同じじゃないかと思います。

|REGZAのリモコン|UIPressType|
|---|---|
|決定|.select|
|戻る|.menu|
|再生|.playPause|
|停止|-|
|上|.upArrow|
|下|.downArrow |
|左|.leftArrow |
|右|.rightArrow |

## UIKitの各コントロールの挙動

### フォーカス移動

テレビのリモコンの上下左右キーが有効ですので、上下左右を押すことで普通にフォーカスが移動可能です。そのためシンプルにフォーカスが当たるコントロール（UIButtonなど）が配置されただけの画面なら何もしなくても操作可能になっています。

### UITableView/UICollectionView

UITableViewやUICollectionViewを使った画面もテレビのリモコンで操作可能です。
デフォルトで各Cellにフォーカスが当たるので、Cellのフォーカスを移動していくと自動的にスクロールしていく挙動になります。

### UIPageViewController

これは意外だったのですが、UIPageViewControllerもデフォルトでテレビのリモコンでの操作が可能でした。

ただし条件があり、transitionStyleプロパティに`UIPageViewControllerTransitionStyle.scroll`を設定している場合のみ操作可能です。`.pageCurl`だと（デフォルトでは）操作不能でした。

`.scroll`の場合には、`navigationOrientation`プロパティが`.horizontal`なら左右ボタンで、`.vertical`なら上下ボタンでそれぞれページ移動が可能です。

### UIScrollView

UIScrollViewも特に意識しないでも操作可能になっています。

上下左右で直接スクロール可能というわけではなく、UIScrollView上に配置された要素を上下左右ボタンでフォーカス移動することで、結果としてスクロールされるという挙動になります（フォーカスが当たった要素が画面内に収まるように）。

### UITextView

UITextViewはデフォルトでは上下左右ボタンでの操作ができませんでした。

## テレビのリモコンで操作できない画面をなんとかする

一例ですが、UIPanGestureRecognizerを使って独自のページ移動をさせるような実装をした画面でもテレビのリモコンで操作させたい場合には、`UITapGestureRecognizer`を使って対処するのが簡単そうです。

```swift
let leftTap = UITapGestureRecognizer(target: self, action: #selector(self.leftArrowDidPress(sender:)))
leftTap.allowedPressTypes = [NSNumber(value: UIPressType.leftArrow.rawValue)]
view.addGestureRecognizer(leftTap)

let rightTap = UITapGestureRecognizer(target: self, action: #selector(self.rightArrowDidPress(sender:)))
rightTap.allowedPressTypes = [NSNumber(value: UIPressType.rightArrow.rawValue)]
view.addGestureRecognizer(rightTap)

// func leftArrowDidPress(sender:) と func rightArrowDidPress(sender:) にそれぞれ左右への移動のための実装をする
```

単にUIGestureRecognizerの`allowedPressTypes`プロパティでハンドリングしたいUIPressTypeを指定してそれに応じたコードを書くだけです！

※ブログ用にコードで例示しましたが、普段UITapGestureRegognizerの追加はInterface Builderでやってます

## まとめ

- シンプルに作ればtvOSアプリはテレビのリモコンで操作できるようになっている
- 利用できるボタンは決定、戻る、再生、上下左右
- 凝った実装でデフォルトではテレビのリモコンで操作できない場合でも、各ボタンに対応したUIPressTypeをハンドリングしてあげれば対応可能
