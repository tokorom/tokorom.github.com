---
title: "[HomeKit対応仕様] Koogeek Wi-Fiスマート LED"
date: 2018-01-02
tags: [ios,homekit]
authors: [tokorom]
cover: "https://qiita-image-store.s3.amazonaws.com/0/7883/77fdcc8d-0c7a-b9d5-960d-9cb55319049f.jpeg"
---

<a target="_blank" href="https://www.amazon.co.jp/gp/product/B0721QN7YT/ref=as_li_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B0721QN7YT&linkCode=as2&tag=tokorom-22&linkId=2d02e58e189b9fe7b31069cab2f5c71a">Koogeek Wi-Fiスマート LED HomeKit 電球 E26 8W 1600万色変色可能 調光調色</a><img src="//ir-jp.amazon-adsystem.com/e/ir?t=tokorom-22&l=am2&o=9&a=B0721QN7YT" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

## 主なサービス

|`HMServiceType`〜 | 説明 |
|--- | ---- |
|`Lightbulb` | 電球 |

## 主なキャラクタ

|`HMCharacteristicType`〜 | 説明 | フォーマット | 書き込み |
|--- | ---- | ---- | ---- |
|`PowerState` | 電源の状態 | bool | 可 |
|`Hue` | 色相 | float | 可 |
|`Saturation` | 彩度 | float | 可 |
|`Brightness` | 明るさ | int | 可 |

## 概要

HomeKitのサービス/キャラクタ的には [iOS 11 Programming](http://peaks.cc/tokorom/iOS11) で紹介されているPhilips Hueのランプ（カラー版）と同じです。
そのためHomeKitで操作できる事項もHueと全く同じで、電源のOn/Off、色（色相、彩度、明るさ）が変更可能です。

## Hueどっちが良い？

まず、カラー版の値段はKoogeekのランプのほうがだいぶ安いです。またHueのようにブリッジが必要なく単体で動作するところもメリットになり得ます。
そのため、HomeKitをちょっと試したいくらいであればKoogeekのほうが圧倒的に優位かもしれません。

一方で、Hueのほうが [各種APIが充実している](https://www.developers.meethue.com/) など一日の長があります。
既にHueのブリッジを所持している、追加のランプはカラー版でなく安いホワイトグラデーションのほうで良いなどあればHueが優位になってきます。
また、計測情報などもなくどのくらいの差があるかはわかりませんが、単体で動作しWi-Fi通信を行うKoogeekのランプに比べ、ZigBeeで通信するHueのランプのほうが日々の電気代は安くなるかもしれません。

まずは試してみたいという感覚なのか、本格的に長期で使っていきたいのかなどによって選択は変わってくるかと思います。

参考: [スマートホーム×DIY 実践と展望 〜 2. 実践Homekitの暮らし](http://kudakurage.hatenadiary.com/entry/2018/01/02/094514)（実際に自宅でHueとKoogeekを一緒に利用しての所感が書かれた記事）

## ライトの電源をOnにするサンプルコード

ライトを点けたり消したりする程度の設定はホームアプリ上でGUIで設定できるわけですが、参考までに敢えてこれをプログラムで実現する場合は以下のようにします。

```swift
// Koogeek LightBulbのpowerStateを取得
let powerState = //< HMCharacteristicTypePowerState

// 電源をOnにする
powerState.writeValue(true) { error in
}
```

なお、ホームアプリからライトをOnにするシーンを作成しようとすると、じつはPowerStateの他にBrightness（明るさ）のキャラクタの設定も一緒に引っついてきます。
これは「好みのライトの状態でOnにする」ためには便利な一方、「前回点いていたライトの状態そのままで電源をOnにしたい」という用途には向きません。

上記コードだとシンプルに電源のOn/Offのみを操作しているため、前回のライトの色や明るさの状態そのままでOn/Offの切り替えだけが可能です。
こんなかんじにホームアプリではやりづらい、もしくはできない設定もプログラムからなら可能な場合があります。[HomeKit対応仕様 Philips Hue Dimmer スイッチ](https://qiita.com/tokorom/items/b1839b216d52141215c1)で紹介しているOn/Offのトグル設定もその１つです。

## まとめ

[iOS 11 Programming](http://peaks.cc/tokorom/iOS11) ではPhilips Hueを

> HomeKitプログラミングにトライするうえで最初に購入するものとして、おすすめしやすい製品の１つです

と紹介していますが、このKoogeekのランプは初期費用が圧倒的に安く、HomeKitプログラミングを試すという用途に絞れば、さらにおすすめしやすい製品と言えそうです。

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=tokorom-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B0721QN7YT&linkId=b9b5f916f2915ccadb329cf459109d30&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr">
</iframe>

## iOS 11 Programmingについて

この記事は「iOS 11 Programming」の**第12章 HomeKit入門とiOS 11における新機能**の中の**12.4.2 HomeKit 対応製品利用実例**への追加コンテンツ的位置付けにもなっています。
この製品がサポートするサービス（'HMService'）やキャラクタ（'HMCharacteristic'）の表など、全てこの書籍に合わせた形で掲載しております。

「iOS 11 Programming」にご興味のあるかたは是非、以下リンクからご参照ください。

<div class="peaks_widget" style="overflow:hidden; padding:20px; border:2px solid #ccc;"><div class="peaks_widget__image" style="float:left; margin-right:15px; line-height:0;"><a target="_blank" id="purchase" href="https://peaks.cc/tokorom/iOS11"><img alt="iOS 11 Programming" style="border:none; max-width:140px;" src="https://s3-ap-northeast-1.amazonaws.com/peaks-images/project002_cover.jpg"></a></div><div class="peaks_widget__info"><p style="margin:0 0 3px 0; font-size:110%; font-weight:bold;"><a target="_blank" id="purchase" href="http://peaks.cc/tokorom/iOS11">iOS 11 Programming</a></p><ul style="margin:0; padding:0;"><li style="font-size:90%; list-style:none;"><span>著者：</span><span>堤 修一,</span><span>吉田 悠一,</span><span>池田 翔,</span><span>坂田 晃一,</span><span>加藤 尋樹,</span><span>川邉 雄介,</span><span>岸川 克己,</span><span>所 友太,</span><span>永野 哲久,</span><span>加藤 寛人,</span></li><li style="font-size:90%; list-style:none;">製本版,電子版</li><li style="font-size:90%; list-style:none;"><a target="_blank" id="purchase" style="text-decoration:underline; color:#1DA1F2;" href="http://peaks.cc/tokorom/iOS11">PEAKSで購入する</a></li></ul></div></div>
