---
title: "iOSDC Japan 2020でHomeKitについてのセッションで登壇しました #iwillblog"
date: 2020-10-06T14:57:02+09:00
draft: false
authors: [tokorom]
tags: [iOS,HomeKit]
images: [/images/iosdc2020/top.png]
canonical: https://spinners.work
---

![image](/images/iosdc2020/top.png)

2020年9月に開催された [iOSDC Japan 2020](https://iosdc.jp/2020/) 今年も盛り上がりましたね！
2020年は初のオンライン開催でオフラインにはない良さも再認識することができました。

私も [HomeKit 2020](https://fortee.jp/iosdc-japan-2020/proposal/5c2600f9-b27b-4deb-abd4-85cb7062553e) というセッションで発表者として参加しました。

## 概要

セッションの概要はこんな感じです。ご興味がある題材がありましたら是非セッションビデオをご覧ください！

### HomeKit Frameworkざっくり入門

- HomeKit Frameworkでどんなことができるのか
- HomeKitの構成
- 具体的に電球を点灯させるコードの紹介
- 隠しキャラクター（HomeKitがサポートしていない気圧）を参照するテクニック
- HomeKitだからこそできる具体例
    - 時間指定でなく「日の入」「日の出」をトリガーに
    - 家に「誰もいなくなったら」をトリガーに
    - 自動点灯したライトをN秒後に消灯する
    - 「部屋が明るければ」自動点灯させない

### HomeKitのBridgeについて

- Hueには電球、人感センサー、スイッチなどあるが直接HomeKit対応しているのはじつは...
- オープンソースのソフトウェアBridge「Homebridge」

### HomebridgeでHomeKit未対応製品をHomeKit対応

- ルンバ、スマートロック、赤外線リモコンなどもHomeKit対応できる！
- Homebridgeを利用する具体的な方法　
- プラグインの自作

### HomeKit ADKで作る自作アクセサリ

- HomeKit ADK概要
- Homebridgeとの違い
- ソフトウェアでHomeKit対応アクセサリーを作る！

## セッションビデオ

<iframe width="560" height="315" src="https://www.youtube.com/embed/h2agS2kMEwA" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## スライド

<script async class="speakerdeck-embed" data-id="35d004e5b73341faab12559ce54791f1" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>

## HomeKit入門の無料公開

iOSDC 2020とほぼ同時に、ちょうど良いタイミングでZennというサービスが始まり、Web上で簡単に書籍を執筆・公開できるようになりました。

そのため、かねてよりどこかで公開しようと思っていた『[HomeKit入門](https://zenn.dev/tokorom/books/homekit-framework)』[^peaks] をZennで無料公開しました。

[^peaks]: iOS 11 Programmingの第12章に掲載したものです https://peaks.cc/books/iOS11

<a href="https://zenn.dev/tokorom/books/homekit-framework">
<img src="/images/books/homekit.png" width="200" />
<p>https://zenn.dev/tokorom/books/homekit-framework</p>
</a>

　

iOS 11リリース当時に執筆したものですが、HomeKit FrameworkにはiOS 12以降大きな変更は入っていませんので、現在でも十分有効な内容かと思います。

ご興味ありましたら是非ご参照ください！


