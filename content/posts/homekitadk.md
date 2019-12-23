---
title: "HomeKit ADKでSlackにメッセージ送信するアクセサリを作ってみる"
date: 2019-12-23T11:47:15+09:00
draft: false
tags: [ios,homekit]
authors: [tokorom]
cover: "https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/homekitadk/homekit_logo.png"
---

## HomeKitADKのオープンソース化

つい先日（2019/12/18）、AppleがAmazon、Google、Zigbee Allianceと、スマートホームデバイスに関するワーキンググループを結成したとのビッグニュースが発表されましたね！

https://www.apple.com/jp/newsroom/2019/12/amazon-apple-google-and-the-zigbee-alliance-to-develop-connectivity-standard/

これに伴い、HomeKitに対応したアクセサリを開発するためのHomeKit ADKがオープンソース化されました。

https://github.com/apple/HomeKitADK

## HomeKit対応アクセサリ作ってみよう！？

ちなみにHomeKitの世界ではHomeKitに対応した機器のことを[アクセサリ](https://www.apple.com/jp/shop/accessories/all-accessories/homekit)と呼びます。

ということで早速HomeKit対応アクセサリを作ってみましょう！
といってもハードウェアを作るわけではなく、手元のMac上で動き、Homeアプリから`On`するとSlackになにか投稿するというアクセサリを作る実験をしてみようと思います。

と考えたわけですが、12/23現在ですとまだドキュメント等も優しくはないので、リポジトリを覗いてもなにがなんやらの状態です。

ひとまず、READMEに書かれているとおりに、必要なものを`brew install`して、`make all`すれば、なにやらビルドは成功します。そして、ビルドされた

```
Output/Darwin-x86_64-apple-darwin19.0.0/Debug/IP/Applications/Lightbulb.OpenSSL
```

を実行したらなにやら動きます[^environment]。

[^environment]: Darwin-x86_64-apple-darwin19.0.0部分は環境に合わせて変更してください

こちらですが、

- まず、HomeKit対応したアクセサリは`HomeKit Accessory Protocol（HAP）`により操作される
- HomeKit対応するアクセサリでは`HAP Accessory Server`が動いている必要があり、これによりHomeアプリへの追加だったり、「ライトを点灯して」といった命令を受け入れる
- 上で動かしている`Lightbulb.OpenSSL`は、ライト用の`HAP Accessory`のサンプル

という理解で良さそうです。

## LightbulbのサンプルをiPhoneのHomeアプリに追加してみよう

上の`Lightbulb.OpenSSL`を動かしている状態で、iPhoneのHomeアプリを起動し、以下のようにすると、このサンプルのアクセサリを実際に追加できます。

![add_accessory](https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/homekitadk/add_homekitadk_accessory.jpeg)

1. アクセサリの追加から「コードがないか、スキャンできません」を選ぶ
2. 近くのアクセサリに「Acme Light Bulb」というのが表示されるので追加する
3. 設定コードの入力を求められるので`11122333`を入力する

なお、設定コードは https://github.com/tokorom/HomeKitADK/blob/lightbulb_slack/PAL/Mock/HAPPlatformAccessorySetup.c#L12 に書かれていたものを使ってみました。将来、このサンプル用の設定コードは変わるかもしれません。

これでサンプルの`Lightbulb`がHomeアプリに追加されましたので、Homeアプリ上でこのサンプルのライトを点灯/消灯することができるようになりました。

といっても実際に電球があるわけではないので、点灯したよ、消灯したよ、というのはログ上で確認できるのみです。ライトの点灯/消灯を切り替えると、

```sh
Info    HandleLightBulbOnWrite: true
Info    HandleLightBulbOnWrite: false
```

といったログが確認できるかと思います。

## サンプルを改造してSlackにメッセージを送信させよう

HomeKit対応したライトを作る場合は、上の`HandleLightBulbOnWrite`のところで実際にライトを点灯させるコードを書くことになりそうです（Raspberry Piなどでそれをやってみるのも簡単と思います）。

今回はSlackにメッセージを送信するアクセサリを作るというのが目的なので、

https://github.com/tokorom/HomeKitADK/blob/lightbulb_slack/Applications/Lightbulb/App.c#L165-L184

このあたりに、SlackにメッセージをPOSTする機能を追加しましょう。

ただ、今回は実験なので（正直、C言語で書いてビルドし直して...というのが面倒なので）、

```c
#include <stdlib.h>
```

して、

```c
if (value) {
    system("./handleLightBulbOn");
}
```

ライトがOnになったら外部のShellスクリプトを叩くという実装だけして、あとはShellスクリプトで書く...という形に逃げちゃいます。。。

## Slackにメッセージ送信するスクリプトの追加

ここからは慣れ親しんだSwiftなどでSlackにメッセージ送信するコード書くだけなので、ここで紹介するまでもないです。

例えば、こんなかんじのものです。

この例ではSlackのIncoming Webhooksを使っています。

```sh
touch handleLightBulbOn
chmod +x handleLightBulbOn
vim handleLightBulbOn
```

```swift
#!/usr/bin/swift

import Foundation

let slackURL = URL(string: "https://hooks.slack.com/services/foo/bar/baz") //< Incoming Webhooks
var request = URLRequest(url: slackURL!)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-type")

let message = "ライトが点灯💡"

let postData = "{\"text\": \"\(message)\"}".data(using: .utf8)
request.httpBody = postData

let semaphore = DispatchSemaphore(value: 0)

let session = URLSession(configuration: URLSessionConfiguration.default)
let task = session.dataTask(with: request) { _, _, _ in
    semaphore.signal()
}

task.resume()

semaphore.wait()
```

## 実験成功！

これをビルドし直して[^rebuild]Homeアプリに追加して、点灯命令を出したら、

![foo](https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/homekitadk/incoming_webhook.png)

とSlackにメッセージが投稿されるのを確認できました！

これにて実験終了。


[^rebuild]: Shellスクリプト部分をいじるだけならAccessory自体のリビルドの必要はありません
