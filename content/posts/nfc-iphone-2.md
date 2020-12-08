---
title: "NFCタグ で鍵を開けよう（2） iPhoneを鍵とし、ドアにNFCタグを設置するパターン"
date: 2019-04-01T15:11:25+09:00
draft: false
tags: [nfc,sesame,ios]
authors: [tokorom]
images: [https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/sesame.png]
---

この記事は「NFCタグ で鍵を開けよう」シリーズの第2弾です。
このシリーズは以下５つの記事に分けられて投稿予定です。

1. [NFCタグにURIを書き込む](https://www.tokoro.me/posts/nfc-iphone-1/)
2. iPhoneを鍵とし、ドアにNFCタグを設置するパターン（この記事）
3. <s>iOSアプリを経由してセキュリティレベルをあげる</s>
4. <s>NFCタグを鍵とし、ドアにNFCリーダーを設置するパターン</s>（まだ書いてないけど気が向いたら書くかも）
5. <s>より実用的にしていくために</s>
6. [iOS13時代の最終形](https://www.tokoro.me/posts/nfc-iphone-6/)

## この記事でやること

[前回](https://www.tokoro.me/posts/nfc-iphone-1/)は、NFCタグに`https://tag.exsample.com/lock`というURIを書き込むことに成功し、それをiPhone XR/XSで読み込めることを確認しました。

今回は、このURIで動作するAPIをAWS Lambda[^lambda]などで作成し、そこからSesame APIを叩いて鍵のアンロックを実現します。

それさえできれば、NFCタグを自宅のドアなどに貼っておけば、iPhoneをそのNFCタグにタッチして鍵をロック/アンロックできるようになるはずです。

<div class='alert alert-danger'><span class="fa fa-warning"></span>
この記事は実験レベルでセキュリティを考慮していません。例えばこの記事で作ったURLを誰かに知られてしまうと、誰でも鍵を開けることができてしまうため、絶対にこのまま実用しないでください！
</div>

[^lambda]: AWS LambdaでなくともこのURIで実行されるプログラムを書ければ別のものでかまいません

## Sesame APIの利用

### APIキーの取得

Sesame APIを叩くうえで必要なAPIキーやSesame ID（device_id）の取得方法についてはCANDY HOUSEのオフィシャルブログ

https://ameblo.jp/candyhouse-inc/entry-12416936959.html

をご参照ください。

### API仕様

Sesame APIの仕様については https://docs.candyhouse.co/ にきちんとしたドキュメントがあります。

### curlで叩いてみる

``` 
curl -H "Authorization: YOUR_AUTH_TOKEN" \
  https://api.candyhouse.co/public/sesames
```

で、管理しているデバイスのリストが取得できます。
YOUR_AUTH_TOKENはAPIキーに置き換えてください。

- レスポンス例

```
[{"device_id": "aaaaaaaa-aaaa-aaaa-1111-111111111111", "serial": "ABCDEFG", "nickname": "\u30c9\u30a2"}]
```

### 鍵をロック

上で取得したdevice_idを利用し、

```
curl -H "Authorization: YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST -d '{"command":"lock"}' \
  https://api.candyhouse.co/public/sesame/YOUR_DEVICE_ID
``` 

とするだけです。

### 鍵をアンロック

同じく、

```
curl -H "Authorization: YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -X POST -d '{"command":"unlock"}' \
  https://api.candyhouse.co/public/sesame/YOUR_DEVICE_ID
``` 

でアンロックもできます。

## AWS Lambdaでの実装

※この記事ではAWS Lambdaの使い方については説明しません

それではこのSesame APIをAWS Lambda上で実行すよう実装してみましょう。

以下、Node.jsでの実装サンプルです。
長々書いていますが、やっているのは上で紹介したアンロックAPIを叩くことだけです。

```js
exports.handler = (event, context, callback) => {
  console.log('start')

  main(callback)
}

async function main(callback) {
  const response = await requestUnlock()

  callbackResponse(200, response, callback)

  return true
}

const url = require('url')
const fetch = require('node-fetch')

function callbackResponse(statusCode, message, callback) {
  let response = {
    "statusCode": statusCode,
    "body": JSON.stringify(message)
  }
  callback(null, response)
}

async function requestUnlock() {
  try {
    const urlObject = {
      protocol: 'https',
      hostname: 'api.candyhouse.co',
      pathname: '/public/sesame/YOUR_DEVICE_ID'
    }
    const headers = {
      'Content-Type': 'application/json',
      'Authorization': 'YOUR_AUTH_TOKEN'
    }
    const request = url.format(urlObject)

    const params = {
      command: 'unlock'
    }
    const body = JSON.stringify(params)

    console.log('request to ' + request)
    console.log('body: ' + body)

    const response = await fetch(request, {method: 'POST', headers: headers, body: body})
    const json = await response.json()
    return json
  } catch (error) {
    console.log(error)
  }
}
```

## まとめ

あとは実装したものをAWS Lambdaにデプロイし、NFCタグに書き込んだURIでこのLambdaが動作するようにするだけです。

これで、iPhoneを鍵代わりにし、NFCタグをタッチして鍵をアンロックする仕組みができました。

くどいようですが、

<div class='alert alert-danger'><span class="fa fa-warning"></span>
この記事は実験レベルでセキュリティを考慮していません。例えばこの記事で作ったURLを誰かに知られてしまうと、誰でも鍵を開けることができてしまうため、絶対にこのまま実用しないでください！
</div>

こちらは絶対に守ってください。

## 記事一覧

1. [NFCタグにURIを書き込む](https://www.tokoro.me/posts/nfc-iphone-1/)
2. iPhoneを鍵とし、ドアにNFCタグを設置するパターン（この記事）
3. <s>iOSアプリを経由してセキュリティレベルをあげる</s>
4. <s>NFCタグを鍵とし、ドアにNFCリーダーを設置するパターン</s>（まだ書いてないけど気が向いたら書くかも）
5. <s>より実用的にしていくために</s>
6. [iOS13時代の最終形](https://www.tokoro.me/posts/nfc-iphone-6/)
