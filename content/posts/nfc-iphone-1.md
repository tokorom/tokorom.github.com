---
title: "NFCタグ で鍵を開けよう（1） NFCタグにURIを書き込む"
date: 2019-04-01T12:43:04+09:00
draft: false
tags: [nfc,sesame,ios]
authors: [tokorom]
cover: "https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/sesame.png"
---

この記事は「NFCタグ で鍵を開けよう」シリーズの第1弾です。
以下、5つの記事に分けて投稿していく予定です。

1. NFCタグにURIを書き込む（この記事）
2. [iPhoneを鍵とし、ドアにNFCタグを設置するパターン](https://www.tokoro.me/posts/nfc-iphone-2/)
3. <s>iOSアプリを経由してセキュリティレベルをあげる</s>
4. <s>NFCタグを鍵とし、ドアにNFCリーダーを設置するパターン</s>（まだ書いてないけど気が向いたら書くかも）
5. <s>より実用的にしていくために</s>
6. [iOS13時代の最終形](https://www.tokoro.me/posts/nfc-iphone-6/)

## 導入

我が家にスマートロックの[Sesame](https://jp.candyhouse.co/)を採用しました。

私一人ならSesameだけでものすごく便利になったわけですが、我が家には小さい子供が３人います。子供たちにスマホを持たせるにはまだ早く、このままではスマートロックの恩恵を十分に受けることができません。

なお、Sesameは個人が触れる便利なAPIを公開してくれています。NFC＋Sesame APIでこの状況を改善できるものではないか、と思い立ったのがこの記事を書くきっかけです。まだ現在進行形で実験中ですが、実験した結果を随時記事にしていければと考えています。

## この記事でやること

私がNFCタグを取り扱ったことがないところからスタートしましたので、まずこの記事では「NFCタグに情報を書き込む」ところまでだけが範囲になります。

実際にSesameをアンロックするところなどは次の記事で書かせていただきます。

## 準備した機器

### スマートロック

導入に書いたとおりですが、Sesameを購入しました。

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=tokorom-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B076WXCRZ4&linkId=412068f7a24b1980a6b3e8a2ad59d716&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr">
    </iframe>

APIでのロックやアンロックが可能で自由度が高そうだったのがSesameを選んだ理由です。

### 利用するNFCタグ

サンワサプライ NFCタグ(10枚入り)をAmazonで購入しました。

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=tokorom-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B00GXSGL5G&linkId=e34d60fe2a09548458913c1b2027e8b0&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr">
    </iframe>

### NFCリーダー/ライター

NFCリーダー/ライターとしてはPaSoRiを購入しました。

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=tokorom-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B00948CGAG&linkId=9474fb352a79353d7c3493e5e9ead8fe&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr">
    </iframe>

これも使えればどれでも良いと思いますが、ネット上で利用実績が多く安全そうなものを選んだだけです。

## nfcpyでNFCタグの情報を扱う

まずはMacにNFCリーダーを接続してNFCタグから情報を読み取るところからはじめます。

調べたところ[nfcpy](https://github.com/nfcpy/nfcpy)というツールがよく使われているようです。
実際に使ってみたところ確かに簡単に利用でき、読み取りから書き込みまでこれで全て完結できそうです。

このツールの`examples`フォルダにそのまま使える便利なサンプルがたくさん入っていました。

### 情報の読み取り


NFCタグに書き込まれた情報を読み取るにはexsamplesの中の`tagtool.py`を使って

```
python tagtool.py show 
```

とするだけです。

### フォーマット

NFCタグをフォーマットしたいときも`tagtool.py`を使って

```
python tagtool.py format 
```

とするだけです。

## URI書き込み

NFCタグにURIを書き込みたい場合のみ少し工夫が必要でした。
とはいえ、exsamplesの中にあるものだけで改造なしで可能です。

例えば`https://tag.exsample.com/lock`というURIを書き込むこととします。

まず、うまくいくパターンからですが、

```
echo -n \\0x04tag.exsample.com/lock | python ndeftool.py pack -t urn:nfc:wkt:U - | python tagtool.py load -
```

でURIを書き込み可能です。
まず、NFCタグに書き込む情報はNDEF（NFC Data Exchange Format）でないといけないようです。NDEFでは`Text`、`URI`、`SmartPoster`などのRecord Typeを扱えます。

上記コマンドでは、

- `python ndeftool.py pack -t urn:nfc:wkt:U -` で、標準入力の内容をRecord Type == URI（`urn:nfc:wkt:U`）のNDEFに変換しています
- 次に`python tagtool.py load -`でそのNDEFをNFCタグに書き込む

ことをしています。

流れはこれでわかると思いますが、一点だけ、echoの部分が

```
echo -n https://tag.exsample.com/lock
```

ではなく

```
echo -n \\0x04tag.exsample.com/lock
```

と意味不明な`\0x04`という文字列が含まれているのが気にかかるかと思います。

### URIの書き方

これは、NDEFにおけるURIは「1バイトのIdentifier code」とそれ以降のURI fieldの組み合わせで記述するというルールがあるためです。

具体的なIdentifier codeは以下です。

Identifier code | プロトコル |
--- | --- |
0x00 | N/A |
0x01 | http://www. |
0x02 | https://www. |
0x03 | http:// |
0x04 | https:// |
0x05 | tel: |
0x06 | mailto: |

今回の場合はこのルールに従って、 `https://` を `\0x04` に置き換えています。

## 実際に書き込んだNFCタグをiPhoneで読み取る

それでは、このURIを書き込んだ情報をiPhoneで読み込んでみましょう。

iPhone XR/XSであればBackground Tag Readingをサポートしますのでアプリなど入れずにNFCタグにタッチするだけでこの情報を読み取れます（Background Tag Reading未対応機では別途アプリが必要です）。

うまく読み取れるとiPhoneの上部に通知ポップアップとしてそのURIが表示されます。そのポップアップをタップするとそのURIが実行されますので、これから、そのURIをトリガーとして動くプログラムを実装すれば、あらゆることがNFCタグをトリガーとして実現できるということになります。

今回の記事はここまでです。

## 記事一覧

1. NFCタグにURIを書き込む（この記事）
2. [iPhoneを鍵とし、ドアにNFCタグを設置するパターン](https://www.tokoro.me/posts/nfc-iphone-2/)
3. <s>iOSアプリを経由してセキュリティレベルをあげる</s>
4. <s>NFCタグを鍵とし、ドアにNFCリーダーを設置するパターン</s>（まだ書いてないけど気が向いたら書くかも）
5. <s>より実用的にしていくために</s>
6. [iOS13時代の最終形](https://www.tokoro.me/posts/nfc-iphone-6/)

## 参考にさせていただいた記事

- [【NFC】NDEFについて理解する](https://qiita.com/shimosyan/items/ed21fb6984240baa7397)



