---
title: "[HomeKit対応仕様] Philips Hue Dimmer スイッチ"
date: 2017-12-01
tags: [ios,homekit]
authors: [tokorom]
---

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/3953d9ee-b01b-4fdd-a869-2215bbe5a33d.png" height=300 />

<a target="_blank" href="https://www.amazon.co.jp/gp/product/B01N3L04OW/ref=as_li_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B01N3L04OW&linkCode=as2&tag=tokorom-22&linkId=df2cceb28ec6b63bef5e55831de49fe0">[Amazon] Philips Hue(ヒュー) Dimmer スイッチ</a><img src="//ir-jp.amazon-adsystem.com/e/ir?t=tokorom-22&l=am2&o=9&a=B01N3L04OW" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

## 主なサービス

|`HMServiceType`〜 | 説明 |
|--- | ---- |
|`StatelessProgrammableSwitch` | ステートレス・プログラマブル・スイッチ |
|`Battery` | バッテリー |

## 主なキャラクタ

|`HMCharacteristicType`〜 | 説明 | フォーマット | 書き込み |
|--- | ---- | ---- | ---- |
|`InputEvent` | プログラマブル・スイッチ・イベント | uint8 | - |
|`BatteryLevel` | 電池残量 | uint8 | - |
|`ChargingState` | 充電の状態 | uint8 | - |
|`StatusLowBattery` | 状況（電池残量低下） | uint8 | - |

## 概要

スマートIoT照明のパイオニアであるPhilips Hueのランプのプログラマブルスイッチです。

Hueの公式ページにもAppleのHomeKit対応製品一覧にもこの製品がHomeKit対応しているとは書かれていなかったのですが、購入して利用してみたらHomeKit対応していて驚きました。
単体で買えば3000円程度とHomeKit対応したプログラマブルスイッチとしては格安です。

なお、この製品を動作させるにはHueのブリッジが必要であることに注意が必要です。
逆に、Hueのブリッジがあれば、Hue以外の（HomeKit対応した）ランプのコントロールにも利用できます。
HomeKit的には単なるプログラマブルスイッチですので、ランプの点灯/消灯以外のあらゆる操作にも対応可能です。

この製品は電池で動作しますので電池残量関連のキャラクタも参照可能です。

## InputEventをトリガーとするサンプルコード

`InputEvent`をトリガーとして特定のシーンを実行する、具体的には、ボタンを押したらランプを点灯/消灯するサンプルコードを紹介します。

なお、単にシーンを実行するだけならコードを書かなくともApple純正のHomeアプリで設定できますので、ここでは、

- ランプが消灯していれば点灯する
- ランプが点灯していれば消灯する

とトグルになるサンプルとします。

```swift
// 設定したいボタンのInputEventを探す
// このサンプルでは適当な１つのInputEventを取得
let service = home.servicesWithTypes([HMServiceTypeStatelessProgrammableSwitch])?.first
let candidates = service?.characteristics.filter { $0.characteristicType == HMCharacteristicTypeInputEvent }
guard let inputEvent = candidates?.first else {
    return
}

// InputEventが取り得る値は0のみ
let event = HMCharacteristicEvent(characteristic: inputEvent, triggerValue: NSNumber(value: 0))

let powerState = //< チェック対象のランプのPowerStateキャラクタ

// ランプが点灯中の場合という条件を作る
let onState = HMEventTrigger.predicateForEvaluatingTrigger(
    powerState,
    relatedBy: .equalTo,
    toValue: true
)

// ランプが点灯中なら消灯するというトリガを作る
let offTrigger = HMEventTrigger(name: "点灯->消灯", events: [event], predicate: onState)
let lightOff = //< ライトを消灯するシーン
home.addTrigger(offTrigger) { error in
    offTrigger.addActionSet(lightOff) { error in
        offTrigger.enable(true) { error in
            // エラー処理などは省略
        }
    }
}

// ランプが消灯中の場合という条件を作る
let offState = HMEventTrigger.predicateForEvaluatingTrigger(
    powerState,
    relatedBy: .equalTo,
    toValue: false
)

// ランプが消灯中なら点灯するというトリガを作る
let onTrigger = HMEventTrigger(name: "消灯->点灯", events: [event], predicate: offState)
let lightOn = //< ライトを点灯するシーン
home.addTrigger(onTrigger) { error in
    onTrigger.addActionSet(lightOn) { error in
        onTrigger.enable(true) { error in
            // エラー処理などは省略
        }
    }
}
```

## まとめ

なんやかんや物理スイッチが便利というのと、HomeKitでの遊び道具として、Hueをお持ちのかたにとっては安価で有用なプログラマブルスイッチです。
設定可能なボタンも４つありますので、遊びかたにも幅ができます。

もちろん、HomeKitなしでもHueのランプのコントローラとして普通に便利です。

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=tokorom-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B0769L5QG5&linkId=c89b4097b83fc50568316d58f59ed4f3&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr">
</iframe>

## iOS 11 Programmingについて

この記事は「iOS 11 Programming」の **第12章 HomeKit入門とiOS 11における新機能** の中の **12.4.2 HomeKit 対応製品利用実例** への追加コンテンツ的位置付けにもなっています。
この製品がサポートするサービス（`HMService`）やキャラクタ（`HMCharacteristic`）の表など、全てこの書籍に合わせた形で掲載しております。

「iOS 11 Programming」にご興味のあるかたは是非、以下リンクからご参照ください。

<div class="peaks_widget" style="overflow:hidden; padding:20px; border:2px solid #ccc;"><div class="peaks_widget__image" style="float:left; margin-right:15px; line-height:0;"><a target="_blank" id="purchase" href="https://peaks.cc/tokorom/iOS11"><img alt="iOS 11 Programming" style="border:none; max-width:140px;" src="https://s3-ap-northeast-1.amazonaws.com/peaks-images/project002_cover.jpg"></a></div><div class="peaks_widget__info"><p style="margin:0 0 3px 0; font-size:110%; font-weight:bold;"><a target="_blank" id="purchase" href="http://peaks.cc/tokorom/iOS11">iOS 11 Programming</a></p><ul style="margin:0; padding:0;"><li style="font-size:90%; list-style:none;"><span>著者：</span><span>堤 修一,</span><span>吉田 悠一,</span><span>池田 翔,</span><span>坂田 晃一,</span><span>加藤 尋樹,</span><span>川邉 雄介,</span><span>岸川 克己,</span><span>所 友太,</span><span>永野 哲久,</span><span>加藤 寛人,</span></li><li style="font-size:90%; list-style:none;">製本版,電子版</li><li style="font-size:90%; list-style:none;"><a target="_blank" id="purchase" style="text-decoration:underline; color:#1DA1F2;" href="http://peaks.cc/tokorom/iOS11">PEAKSで購入する</a></li></ul></div></div>
