---
title: "iOSアプリの本番環境でのテストをプロモーションコードを使って行うマニュアル"
date: 2020-07-21T11:48:23+09:00
draft: false
authors: [tokorom]
tags: [Test,AppStore,iOS]
images: [/images/ios-promocode/top.jpg]
canonical: https://spinners.work
---

![image](/images/ios-promocode/top.jpg)

<small>Photo by <a href="https://unsplash.com/@jjying?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">JJ Ying</a> on <a href="https://unsplash.com/s/photos/promotion?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></small>

-----

これは、プログラマー向けではなく、社内や社外のテスト担当者さん向けのマニュアルとして作成したものです。

2020年7月現在のApp Store Connectを使って、スクショ多めで具体的な操作方法をまとめます。

## プロモーションコードの用途

### 公式な用途

プロモーションコードの用途ですがAppleのドキュメントでは、

> 報道関係者やインフルエンサーがAppのApp内課金をいち早く利用できるようにするため

とプロモーション用であることが説明されています。

### リリース前のテスト用途

この他、アプリ開発者の間では、リリース前に

- App Storeに公開されるアプリと全く同じものをテスト

するためにも使われています。

プロモーションコードを使わなくても[Testflight](https://developer.apple.com/jp/testflight/)によりほとんどのテストは可能ですが、場合によっては、

- Testflightでのテスト時にはテストの効率化のためのデバッグ機能を入れていて、App Storeで公開するアプリのみデバッグ機能を除外している
- Testflightでのテストだと購入のテストにAppleのSandbox環境が使われてしまうが、どうしてもProduction環境での購入テストをやっておきたい

などの理由により **アプリをApp Storeで公開する前の最終テスト** として利用できます。

## プロモーションコードを発行できる条件

プロモーションコードは **審査が通って公開が可能な状態** のアプリに対してのみ発行できます。

そのため、App Storeで公開する前にプロモーションコードでのテストをしたい場合、

- アプリを審査に出す際に「このバージョンを手動でリリースする」を選択しておく
- 審査に通ったらプロモーションコードを発行してテストする
- テストが完了したら「このバージョンをリリースする」ボタンでアプリをApp Storeに公開する

という手順を踏む必要があります。

## プロモーションコードの発行手順

### App Store Connectにログインする

https://appstoreconnect.apple.com/ にログインします。

<div class='box box-info'>
<p><b>Q.</b> アカウントがないのでログインできません</p>
<p><b>A.</b> 担当のかた or アプリの開発者に問い合わせてアカウントをもらってください</p>
</div>

ログインしたら **マイApp** をクリックして **プロモーションコードを発行する対象のアプリ** を開きます。

### プロモーションコードのページを開く

![image](/images/ios-promocode/step1.png)

アプリのページを開いたら画面上側の **機能** を選択し、画面左側の **プロモーションコード** を選択してプロモーションコードのページを開きます。

このページでプロモーションコードの発行や、過去に発行したコードの履歴を確認できます。

### プロモーションコードを発行する

![image](/images/ios-promocode/step2.png)

プロモーションコードのページの **Appプロモーションコード** セクションがアプリのプロモーションコードを発行するためのセクションです。

ここの一番右の数量のフィールドに `1` を入力します。もし複数のプロモーションコードを一度に発行したい場合はその数を入力してください。

数量を入力したら右上の **コードを生成** ボタンを押します。

![image](/images/ios-promocode/step3.png)

確認ダイアログが表示されたら **上記のルールを読み、理解しました。** にチェックをつけ、 **コードを生成** ボタンを押します。

![image](/images/ios-promocode/step4.png)

これでプロモーションコードの発行を完了です。

### プロモーションコードを確認してテスターに連絡する

![image](/images/ios-promocode/step5.png)

プロモーションコードの **履歴** タブから発行済みのプロモーションコードが確認できます。

確認したいコードを探して **コードを表示** を押してください。

![image](/images/ios-promocode/step6.png)

すると画面にプロモーションコード（ランダムな文字列）が表示されるのでこれをコピーするなどしてテスターさんにプロモーションコードを連絡します。

## プロモーションコードによるアプリのインストール

### App Storeアプリを開く

![image](/images/ios-promocode/appstore.png)

アプリのインストールに使うのは **App Storeアプリ** です。

![image](/images/ios-promocode/account.png)

App Storeアプリを開いたら右上の **アカウントアイコンをタップ** します。

### プロモーションコードを入力する

![image](/images/ios-promocode/usecode.png)

アカウント画面の中の **ギフトカードまたはコードを使う** をタップします。

![image](/images/ios-promocode/input.png)

**コードはキーボードでも入力できます。** の部分をタップし、発行されたプロモーションコードを入力します。

入力が終わったら右上の **コードを使う** ボタンをタップします。

![image](/images/ios-promocode/success.png)

コードが正しければ **コードが適用されました。** とダイアログが表示され、ホーム画面に対象のアプリがインストールされます。

-----

マニュアルは以上で終わりです。

その他わからない部分が出てきましたら開発担当者にお問い合わせください。

## その他のマニュアル

- [iOSアプリの購入テストでSandboxアカウントを作って使うマニュアル](/posts/ios-sandbox/)
