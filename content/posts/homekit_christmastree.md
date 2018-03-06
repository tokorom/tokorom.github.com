---
title: "クリスマスツリーをHomeKitに対応させよう"
date: 2017-12-14
tags: [ios,homekit]
authors: [tokorom]
---

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/e647692a-13a4-e5b3-14bd-2257ba61915b.jpeg" width=500 />

## やりたいこと

### 必須要件

- 日の入りあたりで自動的にクリスマスツリーのライトを自動点灯する
- 24:00など時間がきたらクリスマスツリーのライトを自動消灯する

### あったらいいね

- Siriでクリスマスツリーを点灯/消灯する
- 屋外のクリスマスツリー用に防雨対応する

## これまで

HomeKitなど使わなくても実利用的には <a target="_blank" href="https://www.amazon.co.jp/gp/product/B001JUA14K/ref=as_li_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B001JUA14K&linkCode=as2&tag=tokorom-22&linkId=49cf53217aaafabd4c2f766772135799">オーム電機(OHM) S-OCDSTM7A [防雨型 光センサータイマーコンセント 700W]</a><img src="//ir-jp.amazon-adsystem.com/e/ir?t=tokorom-22&l=am2&o=9&a=B001JUA14K" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" /> などの光センサーを利用するので十分かと思います。

今のところHomeKit化しなければいけない理由は大きくないですが、せっかくなので...ということで。

## 実現方法


<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/fbf046d1-39a3-ed3a-d7a7-d67c76a60690.png" width=300 />

クリスマスツリーをHomeKit対応する、といっても実際にはクリスマスツリーのライトのコンセントを <a target="_blank" href="https://www.amazon.co.jp/gp/product/B01N9MMEWH/ref=as_li_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B01N9MMEWH&linkCode=as2&tag=tokorom-22&linkId=b4f840d6789ef659e726c607316b5b13">Koogeek スマートコンセント</a><img src="//ir-jp.amazon-adsystem.com/e/ir?t=tokorom-22&l=am2&o=9&a=B01N9MMEWH" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" /> などのHomeKit対応スマートコンセントに繋ぐだけです。

これを利用することでHomeKitの設定により、

- 日の入りの前後でクリスマスツリーを点灯（スマートコンセントの電源をOn）する
- 設定時間でクリスマスツリーを消灯（スマートコンセントの電源をOff）する
- Siriでクリスマスツリーを点灯/消灯（スマートコンセントの電源をOn/Off）する

などが実現できます。

なお、Koogeekのスマートコンセントの利用実例は <a target="_blank" id="purchase" style="text-decoration:underline; color:#1DA1F2;" href="http://peaks.cc/tokorom/iOS11">
iOS 11 Programming
<img src="https://s3-ap-northeast-1.amazonaws.com/peaks-images/project002_cover.jpg" height=200 />
</a> でも詳細に紹介しています。

## オートメーションの設定

これらオートメーションの設定は自分でプログラミングして追加することももちろん可能ですが、この程度のものならHomeアプリを使って設定可能です。

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/ce7fc2a8-10ab-b4b5-1ade-c39f0f010755.png" height=500 />

このレベルなら設定も本当に簡単で、オートメーションタブから追加ボタンを押して上のスクショのような設定を２つ追加するだけです。


## 防雨対応

クリスマスツリーを室内で運用するならこれでおしまいですが、屋外に設置する場合は防雨対策をしなければなりません。

はじめは <a target="_blank" href="https://www.amazon.co.jp/gp/product/B004IRCT3W/ref=as_li_tl?ie=UTF8&camp=247&creative=1211&creativeASIN=B004IRCT3W&linkCode=as2&tag=tokorom-22&linkId=e232846593aa7324d9653509ea1dcf7d">防雨型コンセントボックス</a><img src="//ir-jp.amazon-adsystem.com/e/ir?t=tokorom-22&l=am2&o=9&a=B004IRCT3W" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" /> など専用のコンセントボックスを利用しようと思っていましたが、UIデザイナーの元山くんから「そんなのバケツをひっくり返してのせとけばいいんじゃないですか？」と指摘され、まあ、それもそうかなと思い、もうちょっと安く済ませる方針としました。

さすがにバケツはあれなので、100円均一のお店で適当な大きさのプラスチックのケースとビニールテープを買ってきました。

プラスチックケースはそのままだとコンセントのケーブルが通りませんので、ノコギリで少し切り込みを入れて、そこにケーブルを通すようにしました。

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/531b6ef7-9f70-74bb-1c55-65565666219b.jpeg" width=300 />

あとは蓋を閉めて、ビニールテープで先ほどの切り込みを含めて巻いておしまい、という簡便なものです。

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/4c26cf27-aad5-8a74-fae7-43355bc701e9.jpeg" width=300 />

実際、普通の雨ならこれで十分な感じです。

（なお、水滴がケース内に発生して云々...など深くは確認していないので同じ方法を採用するかたは自己責任で...）

## まとめ

前述のとおりHomeKitでなくても実用的には十分なのですが、HomeKit対応することで（強いて言えば）以下のメリットがあります。

- 「日の入り」というトリガーが使え、光センサーによるトリガーよりも精度が高い
- 例えばSiriで「メリークリスマス！」と言うことでクリスマスツリーを点灯させるなど、子どもたちの喜びそうなイベントに使えそう
- 自宅に不在時は点灯させないなどプレゼンス関係の条件付けも可能
- 他の点灯条件が揃ってなくても自分が帰宅してきたときには点灯させるなど自己満足な設定も可能
- HomeKit対応させてiOSプログラマー的には気分が上がる

iOSプログラマーのお父さん、お母さん、ぜひお子さんたちの喜ぶクリスマスツリーをHomeKitで作りましょう！

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=tokorom-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B077BFX57M&linkId=d386cac2ae06049aa13b07dbb8c34e7e&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr">
</iframe>
