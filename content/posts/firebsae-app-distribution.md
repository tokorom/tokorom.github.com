---
title: "５分で終わるFirebsae App Distribution（プロジェクト作成からテスターへの配信まで）"
date: 2020-02-10T10:43:31+09:00
draft: false
authors: [tokorom]
tags: [ios,firebase]
cover: "/images/posts/firebase-app-distribution/3-create-app.png"
---

## Firebase App Distiribution

先日BETA公開された[Firebase App Distribution](https://firebase.google.com/products/app-distribution)ですが[2020年3月終了のFabric](https://get.fabric.io/roadmap)からの移行先としてはもっとも有力ですよね[^1]。

先日「Firebaseを利用していない既存アプリを配信するためだけにFirebase App Distributionを使いたい！」と思い試してみたら、あまりにも簡単で「これは10分で設定から配信まで完了するんじゃない？」と思い、実際に、

- Firebase未導入のビルド可能なプロジェクトがある状態
- Firebaseのプロジェクトを作成するところから開始
- 配信用にアプリをビルドしてFirebase App Distributionでテスターに配信するところを終了

という条件で実際にストップウォッチで測ってやってみたところ、なんと「4分43秒」で終わりました！

![stoptime](/images/posts/firebase-app-distribution/stoptime.png)

この記事用にスクショを撮影しながらでもこのタイムだったので、本気でタイムアタックしたら3分切れると思います。

ということで「10分で終わるFirebase App Distribution」という記事を書く予定だったのを「5分で終わるFirebase App Distribution」に変更してお届けします。

[^1]: Fabricからのオフィシャルな移行先なので

## そもそも

アプリにFirebaseを導入するには基本的には[firebase-ios-sdk](https://github.com/firebase/firebase-ios-sdk)をアプリに組み込む必要があります。

しかし、App Distributionだけを利用したい場合にはこのSDKの組み込みは不要です。この記事ではSDK組み込みをスキップしていますので、AnalyticsなどFirebaseの他機能を利用したい場合には他のチュートリアルをご利用ください。

## 設定チュートリアル（実際の手順）

### Firebaseのプロジェクトを作成

- まずは[FirebaseのConsole](https://console.firebase.google.com/)にをブラウザで開いてプロジェクトを作成します

![create-project](/images/posts/firebase-app-distribution/1-create-project.png)

- 今回はApp Distributionのみ利用するので「Googleアナリティクス」はOffにしておきます

![off-analytics](/images/posts/firebase-app-distribution/2-off-analytics.png)

- プロジェクトを作成したらここにiOSアプリ（配信しようとしているもの）を追加します

![create-app](/images/posts/firebase-app-distribution/3-create-app.png)

- 設定が必要なのはバンドルIDだけです
- Xcodeのプロジェクトから`Bundle Identifier`をコピーしてペーストします

![register-app](/images/posts/firebase-app-distribution/4-register-app.png)

- 今回は「設定ファイルのダウンロード」「Firebase SDKの追加」「初期化コードの追加」はスキップしてしまいます
- そのまま「コンソールに進む」としてしまってOK

![go-to-console](/images/posts/firebase-app-distribution/5-go-to-console.png)

これでFirebaseのプロジェクトが作成され、配信するアプリを登録できました。

### 実際に配信する

それでは、実際にアプリをApp Distributionで配信してみましょう

- まず、アプリをArchiveして適当な場所にエクスポートします
- エクスポートしたアプリのipaをApp Distributionのページにドラッグ＆ドロップします

![drag-ipa](/images/posts/firebase-app-distribution/6-drag-ipa.png)

- アップロードが終わったらテスターのメールアドレスを追加します

![add-tester](/images/posts/firebase-app-distribution/7-add-tester.png)

これでテスターに配信完了です！

### おわり

これだけで終わりです。

あとはテスターにこんなメールが届いているはずですので、

![mail](/images/posts/firebase-app-distribution/mail.png)

「Get setup」からインストールしてもらうだけです。

### この記事で書いていないこと

- AdHoc or Enterprise?
- AdHoc配信の場合のUDID管理まわり
- fastlaneなどの設定

