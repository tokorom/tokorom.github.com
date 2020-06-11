---
title: "Swift AWS Lambda Runtimeのサンプルをデプロイしてみた"
date: 2020-06-11T14:57:28+09:00
draft: false
authors: [tokorom]
tags: [Swift,AWS,Lambda]
images: [/images/swift-aws-lambda-runtime/top.jpg]
---

![image](/images/swift-aws-lambda-runtime/top.png)

## 導入

先日（2020/5/29）、Swift AWS Lambda Runtimeが発表されましたね！

https://swift.org/blog/aws-lambda-runtime/

以前から [Custom AWS Lambda runtimes](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-custom.html) を使い、自分でも実現することができましたが、このオフィシャルなライブラリを使い、よりシンプルに安全にSwift製AWS Lambda関数を構築できるようになります。

swift.orgの説明には、

> The library is an implementation of the AWS Lambda Runtime API and uses an embedded asynchronous HTTP Client that is fine-tuned for performance in the AWS Runtime context. The library provides a multi-tier API that allows building a range of Lambda functions: From quick and simple closures to complex, performance-sensitive event handlers.

- AWS Lambda runtime用にパフォーマンスを調整した非同期HTTPクライアントが組み込まれている
- さまざまな種類のLambda関数を作るのに便利なAPIを提供している

とあります。

それでは早速、Swift AWS Lambda Runtimeを使ったLambda関数をデプロイしてみましょう。

## 事前準備

- AWS Lambdaを作る権限のあるAWSアカウントが必要です
- [Docker Desktop on Mac](https://docs.docker.com/docker-for-mac/install/) などをインストールしdockerコマンドが使える環境が必要です

## サンプルを試す

今回は [Swift AWS Lambda Runtimeのリポジトリ](https://github.com/swift-server/swift-aws-lambda-runtime) に含まれているサンプルの`HelloWorld`を試してみます。

具体的には、 https://github.com/swift-server/swift-aws-lambda-runtime/tree/master/Examples/LambdaFunctions です。

READMEでは`scripts/deploy.sh`を試すように指示されていますが、この記事ではAWS CLIやS3周りの説明を省略したいため、Swiftで書かれたLamda関数をビルドしてパッケージングするところまでをやってくれる`scripts/build-and-package.sh`を使います[^aws]。

[^aws]: AWSに慣れていてスクリプト一発でAWS Lambdaのデプロイまでやってしまいたい人はdeploy.shをお試しください

```sh
git clone https://github.com/swift-server/swift-aws-lambda-runtime.git
cd swift-aws-lambda-runtime/Examples/LambdaFunctions

./scripts/build-and-package.sh HelloWorld
```

dockerコマンドが実行できる状態であれば、自動でSwiftで書いたLambda関数をビルドするためのDockerイメージが取得され、Lambda関数がビルドされ、成果物として

```
.build/lambda/HelloWorld/lambda.zip
```

が得られます。


## AWS Lambdaにアップロードして実行

それでは、AWSのコンソールに入って作成したHelloWorldを動かしてみましょう。

### AWS Lambdaの作成

適当な名前で関数を作成します。

![image](/images/swift-aws-lambda-runtime/create-lambda.png)

- ラインタイムは **ユーザー独自のブートストラップを提供する** にします
- アクセス権限など他の項目はデフォルトのままでOKです

### lamda.zipのアップロード

関数コードセクションで **アクション** の **.zipファイルをアップロード** を選びます。

![image](/images/swift-aws-lambda-runtime/upload-zip.png)

ここで先ほどビルドした`lambda.zip`を選んでアップロードします。
これだけでSwift製Lambda関数のデプロイは完了です！

### 実行してみる

右上のメニューの中の **テスト** を選びます。

![image](/images/swift-aws-lambda-runtime/create-test.png)

テストイベントの設定は、デフォルトのまま適当な名前で保存、でOKです。

今回は特にインプットを使わないためです。今後インプットのあるLambda関数を作った場合は、ここでテスト用のインプットを指定できます。

テストイベントの設定が終わったら、改めて **テスト** ボタンを押します。

すると、スクショのように実行結果のログのところに

```
"hello, world!"
```

と表示されるのが確認できるはずです。

![image](/images/swift-aws-lambda-runtime/result.png)

これで初めてのSwift製Lambda関数の作成、デプロイ、実行まで終わりました！

## 次の記事

これでSwift AWS Lambda Runtimeを使ったSwift製Lambda関数のビルドとデプロイの流れを確認できました。

ただ、このままだと流れがわかっただけですので、次の記事ではなにか適当な関数を作ってAPI化し、curlなどで叩くところまでやってみたいと思います。




