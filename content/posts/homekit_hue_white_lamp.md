---
title: "[HomeKit対応仕様] Philips Hue ホワイトグラデーション シングルランプ"
date: 2017-11-22
tags: [ios,homekit]
authors: [tokorom]
images: [https://qiita-image-store.s3.amazonaws.com/0/7883/ddd409f2-d2b4-a9de-c1c2-b2c11ec53d39.png]
---

<a target="_blank" href="https://www.amazon.co.jp/gp/product/B01MSITPT1/ref=as_li_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B01MSITPT1&linkCode=as2&tag=tokorom-22&linkId=a335872d8b17c6b4c0ddb7cb4ce3c4c1">[Amazon] Philips Hue(ヒュー) ホワイトグラデーション シングルランプ</a><img src="//ir-jp.amazon-adsystem.com/e/ir?t=tokorom-22&l=am2&o=9&a=B01MSITPT1" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

## 主なサービス

|`HMServiceType`〜 | 説明 |
|--- | ---- |
|`Lightbulb` | 電球 |

## 主なキャラクタ

|`HMCharacteristicType`〜 | 説明 | フォーマット | 書き込み |
|--- | ---- | ---- | ---- |
|`PowerState` | 電源の状態 | bool | 可 |
|`ColorTemperature` | 色温度 | int | 可 |
|`Brightness` | 明るさ | int | 可 |

## 概要

スマートIoT照明のパイオニアであるPhilips Hueのランプの非カラー版です。
非カラーといっても、蛍光灯のような白色から白熱電球のようなオレンジ色の温かみのある色まで調整できます。

カラー版では`Hue`、`Saturation`、`Brightness`の３つのキャラクタを変更することでランプの色を変えますが、この非カラー版では`ColorTemperature`という１つのキャラクタを変更することで色味を調整します。

なお`HMCharacteristicTypeColorTemperature`はiOS 11で新規追加されたキャラクタです。

もちろん`PowerState`キャラクタで点灯/消灯を操作することもできます。

## ColorTemperatureのmetadata

| プロパティ | 実際の値 |
| ---- | ---- |
|`format` | int |
|`units` | |
|`minimumValue` | 153 |
|`maximumValue` | 454 |
|`stepValue` | 1 |
|`validValues` | |
|`maxLength` | |
|`manufacturerDescription` | Color Temperature |

## ColorTemperatureのvalue

`value`プロパティは153から454の範囲で設定できます。
この写真の左側のランプが153を、右側のランプが454を設定した時の実際の色味です。

## ColorTemperatureを更新するサンプルコード

```swift
let service = home.servicesWithTypes([HMServiceTypeLightbulb])?.first
let candidates = service?.characteristics.filter { $0.characteristicType == HMCharacteristicTypeColorTemperature }

guard let colorTemperature = candidates?.first else {
    return
}

colorTemperature.writeValue(454) { error in
}
```

## まとめ

キャラクタの`value`の更新が視覚的にわかりやすく、また、`true`/`false`だけでなく数値の`value`を書き込み可能な製品としてPhilips Hueをオススメしていますが、実用的にはカラー版でなくこちらのホワイトグラデーション シングルランプで必要十分ではないでしょうか。

値段的にはカラー版の半額程度になりますので、すでにPhilips Hueのブリッジをお持ちのかたの追加ランプとしては順当かと思います。

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=tokorom-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B01MSITPT1&linkId=7c229f303ba71da4d599dfec54156115&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr">
</iframe>

## iOS 11 Programmingについて

この記事は「iOS 11 Programming」の**第12章 HomeKit入門とiOS 11における新機能**の中の**12.4.2 HomeKit 対応製品利用実例**への追加コンテンツ的位置付けにもなっています。
この製品がサポートするサービス（'HMService'）やキャラクタ（'HMCharacteristic'）の表など、全てこの書籍に合わせた形で掲載しております。

「iOS 11 Programming」にご興味のあるかたは是非、以下リンクからご参照ください。

<div class="peaks_widget" style="overflow:hidden; padding:20px; border:2px solid #ccc;"><div class="peaks_widget__image" style="float:left; margin-right:15px; line-height:0;"><a target="_blank" id="purchase" href="https://peaks.cc/tokorom/iOS11"><img alt="iOS 11 Programming" style="border:none; max-width:140px;" src="https://s3-ap-northeast-1.amazonaws.com/peaks-images/project002_cover.jpg"></a></div><div class="peaks_widget__info"><p style="margin:0 0 3px 0; font-size:110%; font-weight:bold;"><a target="_blank" id="purchase" href="http://peaks.cc/tokorom/iOS11">iOS 11 Programming</a></p><ul style="margin:0; padding:0;"><li style="font-size:90%; list-style:none;"><span>著者：</span><span>堤 修一,</span><span>吉田 悠一,</span><span>池田 翔,</span><span>坂田 晃一,</span><span>加藤 尋樹,</span><span>川邉 雄介,</span><span>岸川 克己,</span><span>所 友太,</span><span>永野 哲久,</span><span>加藤 寛人,</span></li><li style="font-size:90%; list-style:none;">製本版,電子版</li><li style="font-size:90%; list-style:none;"><a target="_blank" id="purchase" style="text-decoration:underline; color:#1DA1F2;" href="http://peaks.cc/tokorom/iOS11">PEAKSで購入する</a></li></ul></div></div>
