---
title: "iOSアプリの購入テストでSandboxアカウントを作って使うマニュアル"
date: 2020-07-08T15:41:47+09:00
draft: false
authors: [tokorom]
tags: [iOS,Test]
images: [/images/ios-sandbox/top.jpg]
canonical: https://spinners.work
---

![image](/images/ios-sandbox/top.jpg)

<small>Photo by [Markus Spiske](https://unsplash.com/@markusspiske?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/sandbox?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText)</small>

-----

これは、プログラマー向けではなく、社内や社外のテスト担当者さん向けのマニュアルとして作成したものです。

2020年7月現在のApp Store Connectを使って、スクショ多めで具体的な操作方法をまとめます。

## 1. App Store Connectにログインする

https://appstoreconnect.apple.com/ にログインします。

<div class='alert alert-info'>
<p><b>Q.</b> アカウントがないのでログインできません</p>
<p><b>A.</b> 担当のかた or アプリの開発者に問い合わせてアカウントをもらってください</p>
</div>

ログインしたら「ユーザとアクセス」をクリックして表示します。

![image](/images/ios-sandbox/menu.png)

## 2. Sandboxアカウント追加する

左のサイドメニューから「Sandbox テスター」を選んだあと、(+)マークの追加ボタンを押します。

![image](/images/ios-sandbox/new.png)

姓名やメールアドレスを適切に入力します。

このときのポイントとして **メールアドレスは実在するものでなくてもかまいません** [^mail]。
そのため、テスト用のアカウントはカジュアルに作成できます。
セキュリティ質問なども基本的には使いませんので適当でも大丈夫です[^serurityq]。

[^mail]: 2020年7月現在
[^serurityq]: 自社内でなんらかルールを決めて入力するのが良いかもしれません

![image](/images/ios-sandbox/form.png)


入力し終わったら[招待]ボタンを押します。

うまくいけば先程のテスター一覧に作成したSandboxアカウントが加わっているはずです。

![image](/images/ios-sandbox/confirm.png)

Sandboxアカウントの作成はこれでおしまいです。

<div class='alert alert-info'>
<p><b>Q.</b> 招待ボタンを押しても「エラーが発生しました。しばらくしてからもう一度お試しください。」となります。</p>
<p><b>A.</b> メールアドレスが雑すぎるとそうなる場合があります。@マーク以降は自社のドメインにするほうが安全です。</p>
</div>

## 3. Sandboxアカウントを利用するうえでの注意点

**Sandboxアカウントをプロダクション環境で使ってはいけません。**

以下、Appleのドキュメントからの引用です。

> Sandboxテスターアカウントを使用して、テスト環境ではなく、iTunesなどのプロダクション環境に誤ってサインインした場合は、Sandboxアカウントは無効になり、以降使用できなくなります。この場合、新しいEメールアドレスを使用して新しいSandboxテスターアカウントを作成してください。

プロダクション環境で使ってしまうと、そのSandboxアカウントは使えなくなってしまう、とのこと。

**Sandboxは調子が悪くなることが多々あります。**

Sandbox環境は調子が悪いことがよくあります。例えば購入テストの時に「iTunes Storeに接続できません」と出て購入に失敗することがよくあります。この場合、時間をおいて試していただくと問題なくなることもあります。

時間をおいても全く購入に成功しない場合、アプリのバグの場合もありますが、現在利用しているアカウントだとうまくいかない、というケースもあります。
その場合、別のSandboxアカウントに切り替えてトライするとうまくいくこともあります。

このあたりを踏まえたうえで、心配な場合はアプリ開発者に状況を報告して相談してみてください。

## 4. iPhone/iPadでSandboxアカウントを利用して購入テストをする

※iOS 13のスクショを撮っています。他のOSバージョンだと若干表示などが違うかもしれません。

iPhone/iPadの「設定」を開きます。

その中の「iTunes StoreとApp Store」を選びます。

![image](/images/ios-sandbox/setting.png)

その中の一番上に「Apple ID」があり、それが現在利用している本番用のApple IDです。

このApple IDが設定されている場合はここをタップして「サインアウト」をしておくとより安全にSandboxアカウントでの購入を試せます。

※この場所では絶対にSandboxアカウントを入れないでください

![image](/images/ios-sandbox/signout.png)

この画面の一番下に「SANDBOXアカウント」という項目があります。ここで「サインイン」を押し、作成したSandboxアカウントでログインしてください。

![image](/images/ios-sandbox/sandboxaccount.png)

## 5. アプリで購入テストをする

ログインに成功したらテスト対象のアプリでの購入テストをお試しください。

-----

マニュアルは以上で終わりです。

その他わからない部分が出てきましたら開発担当者にお問い合わせください。

## その他のマニュアル

- [iOSアプリの本番環境でのテストをプロモーションコードを使って行うマニュアル](/posts/ios-promocode/)
