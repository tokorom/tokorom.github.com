---
title: "[HomeKit対応仕様] Philips Hue モーションセンサー"
date: 2018-02-01
tags: [ios,homekit]
authors: [tokorom]
---

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/3953d9ee-b01b-4fdd-a869-2215bbe5a33d.png" height=300 />

<a target="_blank" href="https://www.amazon.co.jp/gp/product/B076ZFF1KR/ref=as_li_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B076ZFF1KR&linkCode=as2&tag=tokorom-22&linkId=d39e14ef523d34df26d1c8357919e03f">Philips Hue モーションセンサー</a><img src="//ir-jp.amazon-adsystem.com/e/ir?t=tokorom-22&l=am2&o=9&a=B076ZFF1KR" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

## 主なサービス

|`HMServiceType`〜 | 説明 |
|--- | ---- |
|`MotionSensor` | モーションセンサー |
|`LightSensor` | 光センサー |
|`TemperatureSensor` | 温度センサー |

## 主なキャラクタ

|`HMCharacteristicType`〜 | 説明 | フォーマット | 書き込み |
|--- | ---- | ---- | ---- |
|`MotionDetected` | 動きを検知 | bool | - |
|`CurrentLightLevel` | 現在の光量 | float | - |
|`BatteryLevel` | 電池残量 | uint8 | - |
|`CurrentTemperature` | 現在の温度 | float | - |
|`ChargingState` | 充電の状態 | uint8 | - |
|`StatusLowBattery` | 状況（電池残量低下） | uint8 | - |

## 概要

日本で普通に購入できるモーションセンサーとしては [Elgato Eve Motion](https://www.apple.com/jp/shop/product/HKVZ2PA/A/elgato-eve-motion-wireless-motion-sensor) に次ぐ待望の２つめです。

しかも、Eve Motionが6000円だったのと比較するとこちらは4000円台で購入可能で、しかも光センサーや温度センサーまで付いているという豪華仕様です。
また、（HomeKitとは直接関係ありませんが）Hueのライトとの相性はとにかくよく、

- モーションを検知して点灯してから何分後に消灯するか設定でき、かつ、完全消灯の前にうっすら暗くなるフェーズが入る
- 光センサーによりどのくらいの暗さなら点灯するかを設定できる

といったことが可能で、この２点によりライトの自動点灯用としてはEve Motionよりも圧倒的に優れています。
特に「完全消灯の前にうっすら暗くなるフェーズが入る」のが地味に大切で、トイレなどで使っているときにいきなり真っ暗になるのを防ぎ、少し暗くなったらちょっと動いてライトを復活させるといった猶予が作れます。

ということでEve Motionと比較すると機能的には圧倒的に優れているわけですが、唯一のネックはHueのブリッジが必要というところです。
逆にHueのブリッジを導入済みならこちら一択かと。。。

もちろん電池残量関連のキャラクタも参照可能です。

## 現在の光量を条件に加えるサンプルコード

このセンサーの設定はHueアプリで完結できるのですが、せっかくなので光センサーを使って「現在の光量がNより下の場合」だけ「モーションを検知したらライトを点灯する」というサンプルコードを紹介します。

```swift
let home: HMHome = //< 任意のHome
let lightLevel: HMCharacteristic = //< HMCharacteristicTypeCurrentLightLevel
let motionDetected: HMCharacteristic = //< HMCharacteristicTypeMotionDetected

// 現在が15ルクスより暗い場合という条件
let predicate = HMEventTrigger.predicateForEvaluatingTrigger(
    lightLevel,
    relatedBy: .lessThan,
    toValue: 15
)

// 動きを検知した時のイベント
let event = HMCharacteristicEvent(
    characteristic: motionDetected,
    triggerValue: NSNumber(value: true)
)


// トリガの作成
let trigger = HMEventTrigger(
    name: "暗い時に動きを検知したら",
    events: [event],
    predicate: predicate
)

let lightOn: HMActionSet = //< ライトを点灯するシーン

// トリガの設定
home.addTrigger(trigger) { error in
    trigger.addActionSet(lightOn) { error in
        trigger.enable(true) { error in
            // エラー処理などは省略
        }
    }
}
```

## まとめ

Hueブリッジを導入済みならHueモーションセンサーは超オススメ！

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=tokorom-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B076ZFF1KR&linkId=8e54dfa5e1dd91c6acfd29b7b25af2ce&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr">
</iframe>

## iOS 11 Programmingについて

この記事は「iOS 11 Programming」の **第12章 HomeKit入門とiOS 11における新機能** の中の **12.4.2 HomeKit 対応製品利用実例** への追加コンテンツ的位置付けにもなっています。
この製品がサポートするサービス（`HMService`）やキャラクタ（`HMCharacteristic`）の表など、全てこの書籍に合わせた形で掲載しております。

「iOS 11 Programming」にご興味のあるかたは是非、以下リンクからご参照ください。

<div class="peaks_widget" style="overflow:hidden; padding:20px; border:2px solid #ccc;"><div class="peaks_widget__image" style="float:left; margin-right:15px; line-height:0;"><a target="_blank" id="purchase" href="https://peaks.cc/tokorom/iOS11"><img alt="iOS 11 Programming" style="border:none; max-width:140px;" src="https://s3-ap-northeast-1.amazonaws.com/peaks-images/project002_cover.jpg"></a></div><div class="peaks_widget__info"><p style="margin:0 0 3px 0; font-size:110%; font-weight:bold;"><a target="_blank" id="purchase" href="http://peaks.cc/tokorom/iOS11">iOS 11 Programming</a></p><ul style="margin:0; padding:0;"><li style="font-size:90%; list-style:none;"><span>著者：</span><span>堤 修一,</span><span>吉田 悠一,</span><span>池田 翔,</span><span>坂田 晃一,</span><span>加藤 尋樹,</span><span>川邉 雄介,</span><span>岸川 克己,</span><span>所 友太,</span><span>永野 哲久,</span><span>加藤 寛人,</span></li><li style="font-size:90%; list-style:none;">製本版,電子版</li><li style="font-size:90%; list-style:none;"><a target="_blank" id="purchase" style="text-decoration:underline; color:#1DA1F2;" href="http://peaks.cc/tokorom/iOS11">PEAKSで購入する</a></li></ul></div></div>
