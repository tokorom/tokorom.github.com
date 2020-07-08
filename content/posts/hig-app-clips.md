---
title: "Human Interface GuidelinesのApp Clipsの章の日本語訳"
date: 2020-07-07T15:27:31+09:00
draft: false
authors: [tokorom]
tags: [iOS,WWDC,AppClips,Swift,HIG,iOS14]
images: [/images/hig-app-clips/top.png]
canonical: https://spinners.work
---

前回、[HIGのWidgetsの章を日本語訳した記事](/posts/hig-widgets/)が好評だったので、今回はWidgesと同じくiOS 14の目玉機能の「App Clips」についても日本語訳しました。
Human Interface Guidelines (HIG) の [App Clips](https://developer.apple.com/design/human-interface-guidelines/app-clips/) がソースです。

2020年7月8日時点のものを訳します。

前回同様、訳しながらドキュメントの意図が正確に分からなかった部分や主観で大きく意訳した箇所は注釈に明記します。

# App Clips

App Clipはアプリの軽量版で、ユーザーにアプリをダウンロード・インストールさせずに、日常のタスクを素早く実行させることができます。
ユーザーは様々な状況や目的でApp Clipを見つけ、利用できます。
物理的な場所では、NFCタグや視覚的なコードをスキャンしてApp Clipを起動します。
デバイス上では、位置情報に基づくSiriからの提案、地図アプリ、ウェブサイトのSmart App Banners、メッセージアプリで友達が共有してくれたリンクをタップする、などからApp Clipsを起動します。

![image](/images/hig-app-clips/image1.png)

あなたのアプリが、限られた時間の中でタスクを実行するのに役立つ体験（in-the-moment experience）を提供しているなら、App Clipを導入することを考えてみましょう。
例えば、

- レンタル自転車にNFCタグを付け、それをスキャンしてApp Clipを起動し、その自転車をレンタルしてもらうことができます。
- コーヒーショップでは、ウェブサイトにSmart App Bannerを設置して、そこからすぐに注文できる事前注文用のApp Clipを提供することができます。ユーザーはメッセージアプリでそのウェブサイトへのリンクを友達[^friends]に共有し、共有された友達もそのリンクをタップするだけでApp Clipから注文できます。
- レストランでは、ユーザーが地図アプリやSiriからの提案からApp Clipを起動できるようにしたり、テーブルでNFCタグをスキャンしてもらいApp Clipで食事の支払いをするようにできます。
- 美術館では、来館者に展示品の名札の横にあるQRコード[^qr]をスキャンしてもらい、App ClipでARコンテンツを表示したり、音声解説を提供したりできます。

App Clipは、アプリをインストールしていないユーザーにアプリの機能の一部をシェアできる強力な方法です。
開発者向けのガイドは [App Clips](https://developer.apple.com/documentation/app_clips) を参照してください。

[^friends]: 正確には友達とは書かれておらず単に受信者（recipients）と書かれている。が、受信者だと固すぎるので友達とした。
[^qr]: このvisual codeのことをHIGの中ではQRコードとは読んでいない。しかしWWDC20のExplore app clipsというセッションの中ではQRと明確に言っているのでQRコード、とした。実際には一般的なQRコードとは違うApple独自のもの。

## 優れたApp Clipのデザイン

**本質的な機能にフォーカスしましょう。**
App Clipのインタラクションは素早く、集中して行われるべきです。
目の前のタスクを達成するために必要な機能に限定してください。
高度な機能や複雑な機能はアプリのために取っておきましょう。

**App Clipをマーケティング目的だけに使用してはいけません。**
App Clipは真の価値を提供し、人々がタスクを達成するのに役立つものでなければなりません。
サービスや製品を宣伝するための手段として使用しないでください。

**直線的で使いやすく、焦点を絞ったユーザーインターフェースをデザインしましょう。**
App Clipには、タブバーや複雑なナビゲーション、設定があってはいけません。
画面の数や入力フォームの数も最小限に抑えましょう。
余分な情報を削り、できる限りシンプルなユーザーインターフェースにしてください。

**起動時には、最適な画面を表示しましょう。**
不要なステップをスキップして、ユーザーの現在の状況に最も適した画面をすぐに表示するようにしてください。

**ユーザーがすぐに利用できるようにしましょう。**
App Clipには本当に必要なアセットのみ含めてください。
スプラッシュ画面を入れるなどしてユーザーに起動を待たせるようなことをしてはいけません。

**App Clipの容量を小さくしましょう。**
App Clipの容量が小さければ小さいほど起動が速くなります。
App Clipを小さくすることは、通信環境が悪い場所では特に重要です。
できる限り不要なコードを減らし、使用していないアセットを削除してください。
即時性が失われてしまので、追加でデータをダウンロードすることも避けてください。

**App Clipを共有できるようにしましょう。**
ユーザーがメッセージアプリでApp Clipのリンクを共有すると、共有された友達はメッセージアプリからそのままApp Clipを開くことができます。
App Clipの特定のポイントへのリンクを共有する機能を提供し、友達にApp Clipを共有しやすいようにしましょう。

**サービスや商品への支払いを簡単にできるようにしましょう。**
支払い情報を入力するのは時間がかかるし入力間違もよくあります。
[Apple Pay](https://developer.apple.com/design/human-interface-guidelines/apple-pay/) をサポートして、支払い情報や配送情報の入力なしで即時購入[^express]できるようにしましょう。

[^express]: express checkoutをどう訳したら良いか分からず即時購入とした。

![image](/images/hig-app-clips/coffee.png)

**App Clipの恩恵を受ける前にアカウントの作成を要求しないようにしましょう。**
アカウントの作成には時間と労力がかかります。
アカウントの作成を要求しないことを検討するか、タスクを完了した後にアカウントの作成を求めることを検討してください。
App Clipの恩恵を受けるためにアカウントが必要な場合は、[Sign in with Apple](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/) を提供するなど、ユーザーに求める情報の量を最低限にします。

**アプリ本体にスムーズに移行できるようにしましょう。** [^familiar]
アプリ本体をインストールすると、デバイス上のApp Clipが置き換えられます。
この瞬間から、これまでApp Clipが起動されたタイミングで、代わりにアプリ本体が起動します。
以前にApp Clipを使用していた人がスムーズにアプリを利用できるようにしてください。
例えば、App Clipからアプリに移行する際、再度ログインを求めないようにします。

[^familiar]: 元の文が `Provide a familiar, focused experience in your app` なのだが、その下の内容を踏まえてだいぶ意訳してしまっている。

## プライバシーの保護

ユーザーのプライバシーを確保するためApp Clipには制限があります。
たとえば、App Clipはバックグラウンド処理を行うことができません。
開発者向けのガイドは [Developing a Great App Clip](https://developer.apple.com/documentation/app_clips/developing_a_great_app_clip/) を参照してください。

**保存するデータ量を制限し、デバイスにデータが保存されていなくても処理できるようにしましょう。[^handleyourself]**
ログイン情報など、ユーザーのデータを保存する必要がある場合は、セキュリティに配慮してください。
また、以前保存したデータが残っている前提で処理しないでください。
OSがApp Clipをデバイスから削除し、以前保存したデータが失われている場合があります。
ログイン情報を保存する場合はデバイス外[^offthedevice]に安全に保存してください。

[^handleyourself]: `handle yourself`は直訳だと「自分で処理する」だと思うがこれだと意味がよくわからなかったので、その下の内容を鑑みて意訳している。
[^offthedevice]: `off the device`は具体的にはサーバ上に保存しろということと理解。

**Sign in with Appleの提供を検討しましょう。**
Sign in with Appleは、ログイン情報をデバイス外に安全に保管し、ユーザーのプライバシーを保護します。
[こちら](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/) にガイドがあります。

**サービスや商品の代金を安全に支払う方法を提供し、ユーザーのプライバシーを尊重しましょう。**
たとえば、[Apple Pay](https://developer.apple.com/design/human-interface-guidelines/apple-pay/) の提供を検討しましょう。

## アプリ本体への導線

ユーザーがApp Clipを自分で管理したり、ホーム画面にApp Clipが表示さたりすることはありません。
代わりに、App Clipが一定期間利用されないとOSにより自動的に削除されます。

アプリは長期間に渡ってユーザーに役立つ最良の方法であるため、OSはユーザーがアプリ本体を発見してインストールするのを支援します。

- App Clip Cardには、App Clipを起動するか、アプリのApp Storeページにアクセスするかの選択肢が表示されます。
- App Clipを初めて起動すると、画面の目立つ部分にアプリ本体のインストールを促すバナーが表示されます。バナーをタップするとアプリ本体のApp Storeページにアクセスできます。

さらに、App Clip内にアプリ本体のインストールを促す導線をオーバーレイを表示することもできます。ただし、この表示は慎重に行いましょう[^mindful]。

[^mindful]: `However, be mindful of when you recommend your app to people.` が意図することが正確に分かっていない。ここでは、オーバーレイ表示は強いUIなので慎重に使ってね、と言っている捉えた。その後の項目を読む限り、これであっていると思う。

![image](/images/hig-app-clips/getfullapp.png)

**アプリ本体のインストールを求めることで、ユーザーエクスペリエンスを犠牲にしてはいけません。**
App Clip CardやOSが表示するバナーだけでもアプリ本体をダウンロードしてもらう導線として十分でないか考えてみてください。
App Clipでのタスクを完了するのにアプリ本体のインストールが必要であってはいけません。

**アプリ本体のインストール導線は適切なタイミングで表示しましょう。**
ユーザーにApp Clipを試してもらうことで、アプリ本体をインストールする価値を知ってもらうようにします。
App Clipを繰り返し使用したユーザーや、タスクを完了した後にのみ、アプリ本体のインストール導線を表示することを推奨します。

開発者向けのガイドは [Recommending an App Clip’s Corresponding App](https://developer.apple.com/documentation/app_clips/recommending_an_app_clip_s_corresponding_app) を参照してください。

## 通知の制限

App Clipには起動後最大8時間まで通知をスケジュール/受信するオプションがあります。
ユーザーへのフォローアップやほとんどの一般的なタスクを完了させるのに十分な時間です。

**長期間有効な通知を利用する許可を求めるのは、本当に必要な場合のみにしましょう。**
App Clipのタスクが1日以上に及ぶ場合は、ユーザーに通知の利用の許可を明示的に行います。
例えば、レンタカー会社のApp Clipでは、レンタカーの返却期限を通知する許可を求めるのが適切です[^notification]。

**通知は重要なものだけにしましょう。**
App Clipはユーザーに長期間利用されるものではないため、ユーザーにとって重要な通知のみを送信することが特に重要です。
プロモーションの目的のためだけに通知を送ってはいけません。
ユーザーの明確なアクションに対応する通知のみ送りましょう。
ユーザーがApp Clipから離れることなくタスクを完了した場合、通知は全く必要ないかもしれません。

[^notification]: レンタカーのレンタル期間は多くの場合は8時間以上のため。

**タスクを完了させるために通知を利用しましょう。**
App Clipの通知は、直接的にタスクの完了を支援するものでなければいけません。
たとえば、食品を注文するApp Clipでは配達に関連した通知を送信してもよいでしょう。

開発者向けのガイドは [Enabling Notifications in App Clips](https://developer.apple.com/documentation/app_clips/enabling_notifications_in_app_clips) を参照してください。

## App Clip Cardのアートワークとコピーの作成

App Clip CardはユーザーがApp Clipと最初に触れ合う部分です。
そのため、App Clip Cardに使う画像やコピーには十分は配慮が必要です。

**情報を明確に伝えましょう。**
App Clip Cardの画像は、App Clipの機能、提供されるタスク・コンテンツを明確に伝えるものである必要があります。

**写真やグラフィックを用いましょう。**
アプリそのもののスクリーンショットを使用するのは、App Clipの目的を伝えるのに不十分なため避けてください。
代わりに、App Clipの価値を理解してもらうための画像や、関連するビジネスや場所の写真を使用しましょう。

**ヘッダー画像にテキストを使うのは避けましょう。**
ヘッダー画像内のテキストはローカライズできず、読みづらく、Cardの美観を損ねる可能性があります。

**ヘッダー画像の要件に従いましょう。**
3000px ×2000pxの非透過なPNGまたはJPEG画像を使用してください。

**簡潔なコピーを使いましょう。**
App Clip Cardにはタイトルとサブタイトルが必要です。
限られたスペースでApp Clipの目的を明確に表現することで、ユーザーが一目でApp Clipの目的を理解できるようになります。

**App Clipに最適なアクションボタンの動詞を選びましょう。**
選択できる動詞は、`View`、`Play`、`Open`です。
App Clipが情報や教育コンテンツを提供する場合は`View`、メディアやゲームの場合は`Play`、その他のApp Clipの場合は`Open`を選択します。

![image](/images/hig-app-clips/app-clips-card.png)

## 企業向けのApp Clipの作成

対企業[^business]にサービスを提供するプラットフォームプロバイダであれば、App Store Connectに複数のApp Clip Experience[^experience]を作成し、１つのApp Clipでそれら全てを利用できます[^power]。
各企業のApp Clipには各々の企業や場所のブランディングを表示できます（アプリ本体のプロバイダのブランディングではなく）。

[^business]: `business`を「企業」と訳しているが、これは例えば、ぐるなびに掲載される「店舗」に相当する。ぐるなびで考えるほうがわかりやすそう。アプリプロバイダーがぐるなびで、各企業が店舗。
[^experience]: `App Clip Experience`はApp Store Connectの設定項目の名称と思うがまだApp Store Connectにこの項目がないため、いったん原文そのままで記載する。
[^power]: この部分だいぶ意訳しないと意味がわからなかったため意訳。直訳だと「1つのApp Clipでそれらすべてをパワーアップさせることができます」とか。

**一貫性のあるブランディングにしましょう。**
各企業のApp Clip Cardでは、その企業のブランドを前面に出します。
アプリのプロバイダ[^provider]自体のブランディングは控えめにして、各企業のブランディングを前面に出し、App Clipを利用するユーザーを混乱させないようにしましょう。

[^provider]: 要するにアプリを開発/提供している自分の会社。

**複数の企業を考慮しましょう。**
App Clipは、多くの企業や複数の場所を扱う企業[^locations]を扱う可能性があります。
ユーザーがどの企業や場所でApp Clipで終了するかはわかりません。
App Clipはこのユースケースに対応し、適切にユーザーインターフェースを更新する必要があります。
たとえば、App Clip起動時にユーザーの現在地を確認し、企業や場所を切り替えることを検討してみてください。

[^locations]: ぐるなびで言うと複数の支店を持つレストラン的な。

開発者向けのガイドは [Configuring Your App Clip’s Launch Experience](https://developer.apple.com/documentation/app_clips/configuring_your_app_clip_s_launch_experience) を参照してください。


