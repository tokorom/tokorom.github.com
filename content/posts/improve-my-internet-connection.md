---
title: "自宅のインターネット接続環境を改善して通信速度を30Mbpsから400Mbpsにした経緯"
date: 2020-09-07T16:56:36+09:00
draft: false
authors: [tokorom]
tags: [Internet,Wi-Fi]
images: [/images/improve-my-internet-connection/top.jpg]
canonical: https://spinners.work
---

![image](/images/improve-my-internet-connection/top.jpg)

<small>Photo by <a href="https://unsplash.com/@franckinjapan?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Franck V.</a> on <a href="https://unsplash.com/s/photos/cable?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></small>

## 改善のきっかけ

自宅のインターネット接続環境は、改善前は通信速度が **10Mbps〜40Mbps** 程度でした。

これで特に不満もなく使っていたのですが、同じプロバイダーを使っている同僚の [@kudakurage](https://twitter.com/kudakurage) が

「IPv6にしてWi-Fiルーターをいいやつに変えたら500Mbps以上出るようになったよ」

と教えてくれたので、 ~~絶対に負けてられない！~~ せっかくなので自分も改善してみよう！ と思ったのがきっかけです。

## 前置き

私はネットワークに関する専門的な知識を持ち合わせていないため、おかしなことを書いたりしているかもしれません。

間違いなどありましたらよろしければ [Twitter](https://twitter.com/tokorom) までご連絡ください。

- 以下、速度計測は全て [Fast.com](https://fast.com/ja/) で実施しています
- 以下、速度計測は全て無線接続で実施しています
    - 有線接続では計測していません
    - Wi-Fi 6での計測はiPhone 11 Proを利用しています

## 改善前の状態

![image](/images/improve-my-internet-connection/before_speed.png)

| Key | Value |
|----|----|
| 通信速度 | 10〜40Mbps |
| プロバイダー | Interlink ZOOT NEXT |
| IP | IPv4 |
| 接続方式 | PPPoE |
| LANケーブル | CAT6のフラットケーブル |
| Wi-Fiルーター | Apple AirMac Time Capsule |
| Wi-Fi規格 | Wi-Fi 5 (11ac) |

上で同僚と同じプロバイダーと書きましたが、正確には「IIJmioひかり」と固定IP用に「Interlink ZOOT NEXT」の2つのプロバイダーを契約しており、同僚は「IIJmioひかり」を常用していて私は「Interlink ZOOT NEXT」を常用していました。というのに後から気づいたため、はじめはInterlinkのほうで計測しています。IIJmioのほうに切り替えても速度はそれほど変わらなかった記憶があります。

## LANケーブルだけ変えた後

せっかくなのでいっきに全部変えてしまうのでなく、１要素ずつ変更して速度計測することにしました。

まず一発目に「これは効果はないだろうなあ」と思いつつも、LANケーブルだけ新調しました。
光回線の終端装置（ONU）とWi-FiルーターをつなぐLANケーブルです。

LANケーブルを新しいものに変えて計測したところ...

いきなり最大 **130Mbps** まで速度が跳ね上がってしまいました。

![image](/images/improve-my-internet-connection/lancable.png)

| Key | Value |
|----|----|
| 通信速度 | 70〜130Mbps |
| プロバイダー | Interlink ZOOT NEXT |
| IP | IPv4 |
| 接続方式 | PPPoE |
| LANケーブル | CAT7 UGREEN LANケーブル |
| Wi-Fiルーター | Apple AirMac Time Capsule |
| Wi-Fi規格 | Wi-Fi 5 (11ac) |

この時すでに新しいWi-Fiルーターを購入済みだったのですが、こうなることを知っていたらLANケーブルの変更だけで終わらせていたかもしれません。。。

なお、変更前のLANケーブルはCAT6だったのでスペックとしては必要十分だったはずなのです。

- フラットケーブルでノイズの影響が大きかった？
- たまたまこのケーブルが悪くなっていた?

などでしょうか。
いずれにせよ私の自宅ではこのLANケーブルが大きなボトルネックになっていたようです。

新しいLANケーブルはCAT7で太くてノイズに強そうなものにしました。

Amazonで適当に検索した UGREEN LANケーブル カテゴリー7... というやつです。

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=tokorom-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B00QV1F0RU&linkId=e41b13b3ba22ffcb2886ad1781a0da12&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr">
    </iframe>

## Wi-Fiルーターを変更した後

そしてその後、**Wi-Fi 6 (11ax)** に対応した新しいWi-Fiルーターに差し替えをしました。

はじめはYAMAHAのルーターとか格好いいからYAMAHAがいいなあと考えていたのですが、

- Wi-Fi 6対応
- IPoE対応
- 接続デバイス台数30台以上
- 予算2万円以下

という条件で探していたところマッチするものが見つけられず、結局、BuffaloのWSR-5400AX6/NCGというWi-Fiルーターを購入しました。

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=tokorom-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B089GKTRDT&linkId=9f7e1ac088875c62e86f02863b70a755&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr">
    </iframe>

なお、同僚はというとこれよりも高価な、

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=tokorom-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B07Y1GWNK5&linkId=1eb24124b2b5b14eecab9972b7f54ae0&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr">
    </iframe>

WXR-5950AX12というフラグシップ機を使っています。
私は予算の関係もあり半額程度の機種を選択しました。

ということで、Wi-Fiルーターを差し替えて速度計測すると...

最大 **180Mbps** を記録しました！

![image](/images/improve-my-internet-connection/router.png)

| Key | Value |
|----|----|
| 通信速度 | 120〜180Mbps |
| プロバイダー | Interlink ZOOT NEXT |
| IP | IPv4 |
| 接続方式 | PPPoE |
| LANケーブル | CAT7 UGREEN LANケーブル |
| Wi-Fiルーター | Buffalo WSR-5400AX6/NCG |
| Wi-Fi規格 | Wi-Fi 6 (11ax) |

## IPv6 IPoE接続での最終形！

そして最後にやっと、速いと噂のIPv6 IPoE接続に変更です。

IIJmioひかりはオプション申請さえすれば無料でIPoE接続させてくれます。

先ほどまで使っていたInterlink ZOOT NEXTもIPv6には対応していますがPPPoE接続のみです[^zootnative]。

[^zootnative]: ZOOT NEXTよりも高いZOOT NATIVEならIPoE接続できます

Wi-Fiルータの設定を変更してIPoE接続したところ、なんと、最大 **400Mbps** overを記録しました！

よかったよかった、これで無線LANルーターを新調した甲斐があったというものです（コスパ的にはやはりLANケーブルの新調だけで良かったかもですが）。

![image](/images/improve-my-internet-connection/ipoe.png)

| Key | Value |
|----|----|
| 通信速度 | 200〜400Mbps |
| プロバイダー | IIJmioひかり |
| IP | IPv6 |
| 接続方式 | IPoE |
| LANケーブル | CAT7 UGREEN LANケーブル |
| Wi-Fiルーター | Buffalo WSR-5400AX6/NCG |
| Wi-Fi規格 | Wi-Fi 6 (11ax) |

## ほかの計測サービスでの結果

参考までに他の計測サービスでの計測結果も添付します。

IPv6とIPv4の同時測定ができると謳っている [みんなのネット回線速度](https://minsoku.net/speeds/contents/new) というサービスで計測してみました。

![image](/images/improve-my-internet-connection/minsoku.png)

こちらでは、

- IPv4で **600Mbps**
- IPv6で **300Mbps**

となっており、私は知識がなさすぎてIPv4とIPv6でなぜ差異が出ているのか、など分かっていません。
どなたか優しいかた、教えてください。

