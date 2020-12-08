---
title: "[HomeKit対応仕様] デロンギ マルチダイナミックヒーター"
date: 2018-02-08
tags: [ios,homekit]
authors: [tokorom]
representativeImage: "https://qiita-image-store.s3.amazonaws.com/0/7883/e2d9ecaa-7f81-761e-46ac-ca1555bdab71.png"
images: [https://qiita-image-store.s3.amazonaws.com/0/7883/e2d9ecaa-7f81-761e-46ac-ca1555bdab71.png]
---

<a target="_blank" href="https://www.apple.com/jp/shop/product/HKQ82J/A?fnode=372449abf93d5d1d346f209827d9b3c1af755ac16305ed17d2753e881428bf9d2aba527efa4d11b2dbc6377f455dd2159410e6afb94fd7b77284f2c5eb712c38802e1b54bf4486f5c21b1b77b6cd8f00db52e458cdec8304131e3f7108cf4133bce4b23b33c10cc6de33d0c46152a51f">De'Longhi Multi Dynamic Heater WiFi Model</a>

## 主なサービス

|`HMServiceType`〜 | 説明 |
|--- | ---- |
|`Thermostat` | サーモスタット |

## 主なキャラクタ

|`HMCharacteristicType`〜 | 説明 | フォーマット | 書き込み |
|--- | ---- | ---- | ---- |
|`CurrentHeatingCooling` | 現在の冷暖房の状態 | uint8 | - |
|`TargetHeatingCooling` | 冷暖房の目標状態 | uint8 | 可 |
|`CurrentTemperature` | 現在の温度 | float | - |
|`TargetTemperature` | 目標温度 | float | 可 |
|`TemperatureUnits` | 温度表示装置 | uint8 | 可 |

## 概要

ちょっとお高くて（Apple Storeで￥84,800）試用レベルではなかなか買えないHomeKit製品の代表格かと思います。
私の知っている限りでは、一番高額なHomeKit対応製品です[^1]。

私はきちんと詳細把握していないのですが純粋にヒーターとしても高性能らしく、第３のヒーターとも言われているようです（[参考](http://the360.life/U1301.doit?id=103)）。

公開されている情報と、この機器を実際に利用している[UIデザイナーの元山さん](http://kudakurage.hatenadiary.com/entry/2018/01/02/094514)の感覚をもとにメリットを並べると、一般的なエアコン暖房と比較して

- 温度を一定に保つ能力が高い
- 静か
- 乾燥しない

といった特徴があります。
私もワークスペースで一緒に使わせていただいているわけですが、実際に稼働しているかどうかわからないくらい静かで、暖房が付いているという感覚がありません。

一方で、他の実際に利用している知り合いの感想として「あまり暖かくなっている感じがしないので、結局、石油ヒーターのほうを使っている」というものもありました。

自然に適温な空間を作りたいのか、もっと直接的に暖まりたいのかなどの好みによっても利用感が変わってくるのかもしれません。

なおHomeKitのサービスとしては主にはサーモスタットのみで、書き込み可能なキャラクタとして「暖房機能のOn/Off」「目標温度」「温度表示装置のOn/Off」などがあります。

また、隠し機能（というかHomeKitでは定義されていないカスタムキャラクタ）としてEco Modeなど14つのカスタムキャラクタもありますので、解析すればより細かい制御ができると思います。

## 暖房をOnにするには？

温度の設定はCurrentTemperature（目標温度）を上書きすれば良さそうですが、暖房をOnにするにはどうすれば良いでしょう？
この機器には他の機器によくあるPowerState（電源の状態）キャラクタがありません。

また、TargetHeatingCooling（冷暖房の目標状態）というキャラクタがありますが、この機器に冷房機能はないんですが？

といった時にはキャラクタの`metadata`プロパティを参照すれば明確になることが多いです。例えばこの機器のTargetHeatingCoolingキャラクタのmetadataは以下になっていました。

| プロパティ | 実際の値 |
| ---- | ---- |
|`format` | uint8 |
|`units` | |
|`minimumValue` | 0 |
|`maximumValue` | 1 |
|`stepValue` | 1 |
|`validValues` | |
|`maxLength` | |

このキャラクタのvalueには数値で`0` or `1`を指定できるようです。
実際に以下のコードで `1` を指定すると暖房がOnになりました。

```swift
let service = home.servicesWithTypes([HMServiceTypeThermostat])?.first
let candidates = service?.characteristics.filter { $0.characteristicType == HMCharacteristicTypeTargetHeatingCooling }

guard let targetHeatingCooling = candidates?.first else {
    return
}

targetHeatingCooling.writeValue(1) { error in
}
```

逆に`0`を指定すれば暖房はOffになります。

この機器ではvalueに指定できる最大値（maximumValue）が`1`になっていますが、冷房機能がサポートされていれば`2`も指定することができ、それにより冷房をOnにできるようです。

## TmperatureUnit（温度表示装置）とは？

温度表示装置ってなに？と思ったが、実際に以下コードでこのキャラクタのvalueを上書きするとはっきり分かりました（ちなみにこういった情報はHomeKit Accessory Protocol Specificationのドキュメントに明示されてるんですがブログなどに書いちゃいけない類のやつなので、実際にコードで叩いた結果を示します）。

```swift
let service = home.servicesWithTypes([HMServiceTypeThermostat])?.first
let candidates = service?.characteristics.filter { $0.characteristicType == HMCharacteristicTypeTemperatureUnits }

guard let temperatureUnit = candidates?.first else {
    return
}

temperatureUnit.writeValue(1) { error in
}
```

TmperatureUnitを`0`にするとディスプレイの温度の表示が摂氏になり、`1`を指定すると華氏になります[^2]。

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/dba5a934-0d4a-4d79-09fe-fa17cd997e07.jpeg" height=300 />
<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/98533207-f5f6-0673-c660-481e0911925e.jpeg" height=300 />


## まとめ

試しに使ってみるという金額ではありませんのでご購入は計画的に。この機器についてHomeKitで操作・参照できる項目は今のところどこにも公開されていないようですので、この記事の[主なキャラクタ](https://qiita.com/tokorom/items/2afd2a2222c58482a2d2#%E4%B8%BB%E3%81%AA%E3%82%AD%E3%83%A3%E3%83%A9%E3%82%AF%E3%82%BF)も是非ご参考にいただければと思います。

自宅の子供部屋用の暖房を新設するときはこれにしようかなあという気持ち。

## iOS 11 Programmingについて

この記事は「iOS 11 Programming」の **第12章 HomeKit入門とiOS 11における新機能** の中の **12.4.2 HomeKit 対応製品利用実例** への追加コンテンツ的位置付けにもなっています。
この製品がサポートするサービス（`HMService`）やキャラクタ（`HMCharacteristic`）の表など、全てこの書籍に合わせた形で掲載しております。

「iOS 11 Programming」にご興味のあるかたは是非、以下リンクからご参照ください。

<div class="peaks_widget" style="overflow:hidden; padding:20px; border:2px solid #ccc;"><div class="peaks_widget__image" style="float:left; margin-right:15px; line-height:0;"><a target="_blank" id="purchase" href="https://peaks.cc/tokorom/iOS11"><img alt="iOS 11 Programming" style="border:none; max-width:140px;" src="https://s3-ap-northeast-1.amazonaws.com/peaks-images/project002_cover.jpg"></a></div><div class="peaks_widget__info"><p style="margin:0 0 3px 0; font-size:110%; font-weight:bold;"><a target="_blank" id="purchase" href="http://peaks.cc/tokorom/iOS11">iOS 11 Programming</a></p><ul style="margin:0; padding:0;"><li style="font-size:90%; list-style:none;"><span>著者：</span><span>堤 修一,</span><span>吉田 悠一,</span><span>池田 翔,</span><span>坂田 晃一,</span><span>加藤 尋樹,</span><span>川邉 雄介,</span><span>岸川 克己,</span><span>所 友太,</span><span>永野 哲久,</span><span>加藤 寛人,</span></li><li style="font-size:90%; list-style:none;">製本版,電子版</li><li style="font-size:90%; list-style:none;"><a target="_blank" id="purchase" style="text-decoration:underline; color:#1DA1F2;" href="http://peaks.cc/tokorom/iOS11">PEAKSで購入する</a></li></ul></div></div>

[^1]: 少なくとも2018年2月8日時点で日本用に発売されているものとしては
[^2]: これはHomeアプリでも切り替えられます
