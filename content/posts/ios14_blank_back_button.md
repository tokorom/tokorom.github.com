---
title: "iOS14で戻るボタンのタイトルを空欄にするきちんとした方法"
date: 2020-10-26T17:02:15+09:00
draft: false
authors: [tokorom]
tags: [iOS,Swift]
images: [/images/ios14_blank_back_button/top.png]
canonical: https://spinners.work
---

## 先にまとめ

```swift
if #available(iOS 14.0, *) {
  navigationItem.backButtonDisplayMode = .minimal
} else {
  navigationItem.backButtonTitle = " "
}
```

でOK！

## 概要

iOS14のアップデートの1つに、

- ナビゲーションバーの戻るボタンを長押しすると、画面遷移のヒストリーが表示され、いくつか前の画面までいっきに戻ることができる

というのがありますよね。

![image](/images/ios14_blank_back_button/top.png)

ユーザー目線ではたいへん便利な機能ですが、例えば、デザイン的に「戻るのタイトルを空欄」にしていたりすると、

![image](/images/ios14_blank_back_button/95280082-24762480-088f-11eb-9b13-96952266528a.png)

と、この長押し時の戻り先リストも空欄になってしまうなどの問題が出てきます。

## iOS13以前の方法

iOS13以前では、例えば、

![image](/images/ios14_blank_back_button/xcode.png)

Xcodeで該当画面（戻り先の画面）の`Navigation Item`の`Back Button`に空白を1つ入れるなどして、戻るのタイトルを消すワークアラウンドがありました。

しかし、これをすると、iOS 14以降では長押し時の戻り先リストがおかしくなってしまうわけです。

## iOS14でのきちんとした方法

そのため、まずiOS14では`Back Button`の設定はいじらないようにしましょう[^override]。

[^override]: 戻るボタンのタイトルを別のものに差し替えたいときだけ変更する

そうすると当然、

![image](/images/ios14_blank_back_button/ss-1603700597.png)

このように戻るボタンのところに画面名が表示されてしまいます。

そのうえで、iOS14から追加された`UINavigationItem`の`backButtonDisplayMode`を設定します。

https://developer.apple.com/documentation/uikit/uinavigationitem/3656350-backbuttondisplaymode

戻り先の`UIViewController`で、

```swift
if #available(iOS 14.0, *) {
  navigationItem.backButtonDisplayMode = .minimal
} else {
  navigationItem.backButtonTitle = " "
}
```

と `navigationItem.backButtonDisplayMode` に `.minimal` を設定することで、戻るボタンのタイトルが非表示になります。

![image](/images/ios14_blank_back_button/ss-1603700885.png)

また、`Back Button`などもいじっていないため、戻るボタン長押し時の戻り先のリストも、

![image](/images/ios14_blank_back_button/ss-1603700963.png)

のようにきちんと表示されます。

## UINavigationItem.BackButtonDisplayMode

なお、`backButtonDisplayMode` には以下の３種の値を設定できます。

| BackButtonDisplayMode | 挙動 |
| ----- | ----- |
| `default` | デフォルト値はこれで従来の挙動。具体的には画面のスペースに応じて「前画面の`navigationItem.backButtonTitle`」「前画面の`title`」「Back（戻る）」「空欄」の優先順位でいずれかが表示される |
| `generic` | スペースがあれば「Back（戻る）」を表示、なければ空欄 |
| `minimal` | 常に空欄 |

例えば、先ほどの画面に`generic`を設定した時のサンプルはこちらです。

![image](/images/ios14_blank_back_button/ss-1603701094.png)



