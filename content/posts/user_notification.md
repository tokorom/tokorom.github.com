---
title: "iOS 10でついに通知許可ダイアログの操作をハンドリングできるようになったよ"
date: 2016-06-28
tags: [ios,swift,wwdc]
authors: [tokorom]
---

## 概要

- エンドユーザーが通知（特にRemote Push Notification）を許可してくれたかどうかはサービスにとって死活問題
- <s>それなのに通知の許可ダイアログでの選択を素直にハンドリングする方法がこれまでなかった</s>
- iOS 10でそれを簡単にハンドリングできるようになったよ！

**2016/6/28 追記**

コメントで @mono0926 さんからいただいたとおり、じつはiOS 8/9でもdelegateでハンドリング可能ということが発覚しました。

http://qiita.com/tokorom/items/6c6864fa8e841e50e37b#comment-b07920917a7edfb87775

iOS 8/9 でのハンドリングについては別途まとめさせていただきますが、取り急ぎ、こちらで訂正させていただきます。

## iOS 9 以前

```swift
let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)

```

でiOSが必要なら

![notification_dialog.png](https://qiita-image-store.s3.amazonaws.com/0/7883/7fe075a1-eab0-6078-d04c-7ae9b2c1ea19.png "notification_dialog.png")


とエンドユーザにこのアプリが通知機能を使うことを許可するかどうかを確認するダイアログを表示していました。

しかしこのrequestは投げっぱなしのため、実際にそのダイアログが表示されたタイミングもプログラム的には検知できませんし、このダイアログに対してユーザーが実際に許可（Allow）をしたのかしなかったのかも、その瞬間にハンドリングすることが難しいという問題がありました。

（やるとすると少し間をおいて通知設定を確認するなどスマートでない方法...）

## iOS 10 でこうなる

しかしiOS 10で導入された`User Notifications Framework`により、これを正確にハンドリングすることができるようになったんです。
具体的には、

```swift
UNUserNotificationCenter.current().requestAuthorization([.alert, .badge, .sound]) { (granted, _) in
    // got granted :)
}
```

でこれまでと同じくiOSの判断で確認ダイアログが表示されます。

ただ素晴らしいことに（というかようやく）この`requestAuthorization`の第2引数のclosureは、この許可ダイアログでエンドユーザが`Allow`もしくは`Don't Allow`を選択したタイミングでコールバックされるんです！そしてその引数（上の例だと`granted`）に`Allow`と`Don't Allow`のどちらが選択されたかが渡されます。

## コールバックされるタイミングとgrantedの値のまとめ

なお、すでに許可の判断が済んでいて、この許可ダイアログが表示されない場合もコールバックされますので、正確にはユーザーの選択がコールバックされるというよりは、その時点での許可の状況がコールバックされるというのが正確な言い方かと思います。
（で、嬉しいのは、許可ダイアログが表示された場合は、許可の判断が終わるまでコールバックを待ってくれるところ）

| タイミング | granted |
|---|---|
| 許可ダイアログでAllowを選択 | true |
| 許可ダイアログでDon't Allowを選択 | false |
| request時に既にAllow済み（ダイアログは表示されない） | true |
| request時に既にDon't Allow済み（ダイアログは表示されない） | false |

ちなみに第2引数は `An object containing error information or nil if no error occurred. ` とのことだが今のところerrorが発生したことはない。

## ロギングや解析が捗る！

これにより、

```swift
UNUserNotificationCenter.current().requestAuthorization([.alert, .badge, .sound]) { (granted, _) in
    // Analyticsサービスにこのユーザーの状態を伝える
    amplitude.identify(AMPIdentify().set("notification_granted", value: granted))
}
```

とするなどし、適切なタイミングで正確な状態を把握できるようになりました。

ユーザーが通知を許可してくれるかどうかはサービス運営上の重要な課題のひとつですので、通知を許可してもらうための施策をうって、その効果を正確に測りたい場合などに助かりますね♪ （もっと早く欲しかった...）

## Ref: User Notifications Frameworkについて

- WWDC2016の[Introduction to Notifications](https://developer.apple.com/videos/play/wwdc2016/707/)
- koogawaさんの[iOS 10 時代の Notification](http://qiita.com/koogawa/items/0dff2f59096b292571db)
