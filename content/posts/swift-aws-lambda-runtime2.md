---
title: "Swift AWS Lambda Runtimeで犬の写真を毎朝Slackに送ってみる"
date: 2020-06-15T14:25:23+09:00
draft: false
authors: [tokorom]
tags: [Swift,AWS,Lambda]
images: [/images/swift-aws-lambda-runtime/top.png]
canonical: https://spinners.work
---

![image](/images/swift-aws-lambda-runtime/top.png)

## 導入

前回の [Swift AWS Lambda Runtimeのサンプルをデプロイしてみた](/posts/swift-aws-lambda-runtime) の続きです。

特に犬の写真を毎朝送ってほしいというわけではないですが、Swift AWS Lambda Runtimeを試すにあたっての題材として、

- AWS Lambdaのスケジュール式トリガーで毎朝自動で実行する
- 画像検索APIで犬の写真をランダムに取ってくる
- それをSlackに送る

というのをやってみます。

## 画像検索API

画像検索APIは手っ取り早く使えそうなAzureの [Image Search API](https://docs.microsoft.com/ja-jp/rest/api/cognitiveservices-bingsearch/bing-images-api-v7-reference) を使ってみます。
Azureのアカウントさえ作れば、月1000回までは無料で叩けるようです。

curlで叩くとすると、

```sh
curl 'https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=dog' \
  -H 'Ocp-Apim-Subscription-Key: YOUR_KEY'
```

となります。

- リクエストパラメータに `q=検索ワード`
- リクエストヘッダーに `Ocp-Apim-Subscription-Key: YOUR_KEY`

を渡します[^key]。

[^key]: 説明不要と思いますが、試す場合はYOUR_KEY部分はあなたのサブスクリプションキーに差し替えてください

## Slackへの通知

Slackの [Incoming Webhook](https://slack.com/intl/ja-jp/help/articles/115005265063-Slack-%E3%81%A7%E3%81%AE-Incoming-Webhook-%E3%81%AE%E5%88%A9%E7%94%A8)用のURLを取得します。

URLを取得したら、curlで叩くとすると、

```sh
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"犬の画像のURL"}' \
  https://hooks.slack.com/services/your/incoming/webhook
```

とするだけです。

- POSTデータで`{"text":"犬の画像のURL"}`

を送ってあげるだけですね。

## Lambda関数を作る

これで画像検索APIとSlackへの通知部分は準備できたので、あとはメインディッシュのLambda関数を作るだけです。

### Packageの作成

まずは、

```sh
swift package init --type executable --name DogImage 
```

とPackageを作り、 [GitHub上のサンプル](https://github.com/swift-server/swift-aws-lambda-runtime/blob/master/Examples/LambdaFunctions/Package.swift) をベースに`Package.swift`を書き換えます。

```swift
import PackageDescription

let package = Package(
    name: "DogImage",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .executable(name: "DogImage", targets: ["DogImage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .upToNextMajor(from: "0.1.0")),
    ],
    targets: [
        .target(name: "DogImage", dependencies: [
            .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
        ]),
    ]
)
```

### main関数を書き始める

main関数ですが、まずは [HelloWorldのサンプル](https://github.com/swift-server/swift-aws-lambda-runtime/blob/master/Examples/LambdaFunctions/Sources/HelloWorld/main.swift) をそのままコピーしてみます。

```swift
import AWSLambdaRuntime

Lambda.run { (_: Lambda.Context, _: String, callback: (Result<String, Error>) -> Void) in
    callback(.success("hello, world!"))
}
```

まずはこの状態で`swift build`してビルドが成功することを確認してみます。
ビルドに成功したら`hello, world!`するLambda関数はこれで完成ですが、ここから犬の画像を取得するように改造します。

ぱぱっと関数を作ってみましたが、

```swift
import Foundation

func requestDogImageURL(callback: @escaping (Result<URL, Error>) -> Void) {
    let searchURL = URL(string: "https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=dog")!
    var request = URLRequest(url: searchURL)
    request.setValue("YOUR_KEY", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        if let error = error {
            callback(.failure(error))
            return
        }

        guard let data = data else {
            callback(.failure(AppError.unexpected))
            return
        }

        // TODO: あとはdataからURLを取得してcallback
    }
    task.resume()
}

enum AppError: Error {
    case unexpected
}
```

こんなかんじでしょうか。

### 画像検索APIの結果をparseしてURLを得る

画像検索APIの結果はJSONで、

```js
{
  "_type": "Images",
  "instrumentation": {
    "_type": "ResponseInstrumentation"
  },
  "readLink": "https://api.cognitive.microsoft.com/api/v7/images/search?q=dog",
  "webSearchUrl": "https://www.bing.com/images/search?q=dog&FORM=OIIARP",
  "queryContext": {
    "originalQuery": "dog",
    "alterationDisplayQuery": "dog",
    "alterationOverrideQuery": "+dog",
    "alterationMethod": "AM_JustChangeIt",
    "alterationType": "CombinedAlterationsChained"
  },
  "totalEstimatedMatches": 435,
  "nextOffset": 36,
  "currentOffset": 0,
  "value": [
    {
      "webSearchUrl": "https://www.bing.com/images/search?view=detailv2&FORM=OIIRPO&q=dog&id=156E9CA96765D785E38C421EEE00D9E08D508443&simid=608049334633696147",
      "name": "Puppies and adult dogs react differently to your 'dog voice' - Chicago Tribune",
      "thumbnailUrl": "https://tse1.mm.bing.net/th?id=OIP.ODBmghmnhttjtstiwEM1GgHaE8&pid=Api",
      "datePublished": "2017-01-13T12:00:00.0000000Z",
      "isFamilyFriendly": true,
      "contentUrl": "http://www.trbimg.com/img-58796856/turbine/ct-puppies-react-to-dog-directed-speech-research-shows-20170113",
      "hostPageUrl": "http://www.chicagotribune.com/lifestyles/pets/ct-puppies-react-to-dog-directed-speech-research-shows-20170113-story.html",
      "contentSize": "674477 B",
      "encodingFormat": "jpeg",
      "hostPageDisplayUrl": "www.chicagotribune.com/lifestyles/pets/ct-puppies-react...",
      "width": 2048,
      "height": 1367,
      "hostPageFavIconUrl": "https://www.bing.com/th?id=ODF.g4nkrAVSzVCp8H-G4jRi5w&pid=Api",
      "hostPageDomainFriendlyName": "Chicago Tribune",
      "thumbnail": {
        "width": 474,
        "height": 316
      },
// 以下省略
```

こんな感じでした。

今回必要なのは `value` の中の `contentUrl` だけですので、

```swift
struct ImageContent: Decodable {
    let value: [Item]

    struct Item: Decodable {
        let contentUrl: URL
    }
}
```

と`Decodable`なstructを用意して、

```swift
let content = try JSONDecoder().decode(ImageContent.self, from: data)
```

とレスポンスデータをデコードしてあげるだけで良さそうです。

検索結果のどの画像を返すかは、簡易的にランダムにしておきます。

```swift
let randomURL = content.value.randomElement()!.contentUrl
callback(.success(randomURL))
```

### 画像URLをSlackに送る

あとは、そのURLをSlackに送るだけです。
これも`URLSession`でやれば十分でしょう。

```swift
func postToSlack(url: URL, callback: @escaping (Result<Void, Error>) -> Void) {
    let searchURL = URL(string: "https://hooks.slack.com/services/your/incoming/webhook")!
    var request = URLRequest(url: searchURL)
    request.httpMethod = "POST"
    request.httpBody = "{\"text\":\"\(url.absoluteString)\"}".data(using: .utf8)!
    let task = URLSession.shared.dataTask(with: request) { _, _, error in
        if let error = error {
            callback(.failure(error))
            return
        }
        callback(.success(()))
    }
    task.resume()
}
```

こちらも10行程度で簡単に書けますね。

## AWS Lambda用にビルド

- 犬の画像を検索して
- Slackへ通知する

というLambda関数が70行程度のコードでパパッとできてしまいましたね！
あとはビルドしてデプロイするだけです。

[前回の記事](/posts/swift-aws-lambda-runtime) でデプロイの流れはだいたい掴んでいただいていると思います。

### ビルドスクリプトを作る

ビルドスクリプトは前回使った [サンプル](https://github.com/swift-server/swift-aws-lambda-runtime/blob/master/Examples/LambdaFunctions/scripts/build-and-package.sh) をベースにすればすぐできそうです。


```sh
#!/bin/bash

set -eu

executable=DogImage
workspace="$(pwd)"

echo "-------------------------------------------------------------------------"
echo "building \"$executable\" lambda"
echo "-------------------------------------------------------------------------"
docker run --rm -v "$workspace":/workspace -w /workspace builder bash -cl "swift build --product $executable -c release -Xswiftc -g"
echo "done"

echo "-------------------------------------------------------------------------"
echo "packaging \"$executable\" lambda"
echo "-------------------------------------------------------------------------"
docker run --rm -v "$workspace":/workspace -w /workspace builder bash -cl "./scripts/package.sh $executable"
```

このスクリプトの中で叩いている`package.sh`は、 [GitHubのもの](https://github.com/swift-server/swift-aws-lambda-runtime/blob/master/Examples/LambdaFunctions/scripts/package.sh) をそのまま使わせてもらいます。

同じく`Dockerfile`も [GitHubのもの](https://github.com/swift-server/swift-aws-lambda-runtime/blob/master/Examples/LambdaFunctions/Dockerfile) をそのまま使わせてもらいます。

- scripts/build-and-package.sh
- scripts/package.sh
- Dockerfile

の３点の準備が終わったら[^chmod]、前回同様、

```sh
./scripts/build-and-package.sh
```

で`lambda.zip`を得られます。

[^chmod]: `chmod +x`での権限付与も忘れずに

と思ったのですが、

```sh
error: 'URLSession' is unavailable: This type has moved to the FoundationNetworking module. Import that module to use it
```

と怒られてしまったので、

```swift
import FoundationNetworking
```

を`main.swift`に加えてリトライです。

うまくいけば、

```
.build/lambda/DogImage/lambda.zip 
```

が出力されているはずです。

### 今回のコードの全容

だいぶ雑ですが、全容はこんなんです。

```swift
import AWSLambdaRuntime
import Foundation
import FoundationNetworking

Lambda.run { (_: Lambda.Context, _: String, callback: @escaping (Result<String, Error>) -> Void) in
    requestDogImageURL { result in
        switch result {
        case .success(let url):
            postToSlack(url: url) { result in
                switch result {
                case .success:
                    callback(.success("\(url) sent successfully"))
                case .failure(let error):
                    callback(.failure(error))
                }
            }
        case .failure(let error):
            callback(.failure(error))
        }
    }
}

func requestDogImageURL(callback: @escaping (Result<URL, Error>) -> Void) {
    let searchURL = URL(string: "https://api.cognitive.microsoft.com/bing/v7.0/images/search?q=dog")!
    var request = URLRequest(url: searchURL)
    request.setValue("YOUR_KEY", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        if let error = error {
            callback(.failure(error))
            return
        }

        guard let data = data else {
            callback(.failure(AppError.unexpected))
            return
        }

        do {
            let content = try JSONDecoder().decode(ImageContent.self, from: data)
            let randomURL = content.value.randomElement()!.contentUrl
            callback(.success(randomURL))
        } catch {
            callback(.failure(error))
            return
        }
    }
    task.resume()
}

func postToSlack(url: URL, callback: @escaping (Result<Void, Error>) -> Void) {
    let searchURL = URL(string: "https://hooks.slack.com/services/your/incoming/webhook")!
    var request = URLRequest(url: searchURL)
    request.httpMethod = "POST"
    request.httpBody = "{\"text\":\"\(url.absoluteString)\"}".data(using: .utf8)!
    let task = URLSession.shared.dataTask(with: request) { _, _, error in
        if let error = error {
            callback(.failure(error))
            return
        }
        callback(.success(()))
    }
    task.resume()
}

struct ImageContent: Decodable {
    let value: [Item]

    struct Item: Decodable {
        let contentUrl: URL
    }
}

enum AppError: Error {
    case unexpected
}
```

## AWS Lambdaへデプロイと定期実行の設定

AWS Lambdaへのデプロイの方法は [前回の記事](/posts/swift-aws-lambda-runtime) をご参照ください。

### テスト実行

前回同様、適当なテストイベントを設定して「テスト」ボタンでテスト実行してみます。今回は簡単な関数ということもあり、

![image](/images/swift-aws-lambda-runtime2/sample.png)

と一発でSlackに犬の画像を投稿するのに成功しました！

### 定期実行の設定

あとはせっかくAWS Lambdaですので、これを毎朝定期実行するようにしてみます。

これも少し設定するだけで簡単に実現できます。

まず、設定の中に「トリガーを追加」ボタンがあるのでこれを押します。

![image](/images/swift-aws-lambda-runtime2/trigger.png)

トリガーとして「CloudWatch Events」を選び、スケジュール式のところにcron形式で毎朝10時に発火する設定をしてみました。

![image](/images/swift-aws-lambda-runtime2/cron.png)

これで毎朝10時に犬の画像がSlackに投稿されるはず！

※2020/6/16 AM10:10 追記
きちんと朝10時に可愛い犬の写真が投稿されることを確認できました。

![image](/images/swift-aws-lambda-runtime2/ebi.png)

### まとめ

使い慣れたSwiftで簡単にLambda関数が作れるようになり、とても快適になったと思います。

ビルドスクリプトとかDockerfileあたりをテンプレート化しておけば、より手早く作れるようになるでしょう。

また今回の記事では（AWS周りの説明を最小限にするために）手動でzipファイルをアップロードしたりしていますが、このあたりもよりスマートにやる方法がたくさんあります。
