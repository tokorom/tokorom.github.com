---
title: "[WWDC21] [SharePlay] Meet Group Activitiesのまとめ"
date: 2021-06-10T12:56:44+09:00
draft: false
author: "tokorom"
authors: [tokorom]
tags: [WWDC21,SharePlay,iOS]
images: [/images/wwdc21-meet-group-activities/top.png]
canonical: https://spinners.work
---

![image](/images/wwdc21-meet-group-activities/top.png)

[Meet Group Activities](https://developer.apple.com/videos/play/wwdc2021/10183/#) を視聴して内容をまとめたものです。

## 先に簡単にまとめ

- SharePlayはiOS、iPadOS、tvOS、macOSの全てで利用できる
- ビデオや音楽のShareはmacOSのブラウザでも利用できる
- SharePlayは大きくは「ビデオや音楽のShare」「その他のカスタム体験のShare」の2つに分けられる
    - ビデオや音楽のShareは、再生、一時停止、シークなどによる再生位置の変化が同期される
    - カスタム体験のほうは一緒にお絵描きさせるなどだいぶ柔軟性がありそう
- ビデオや音楽のShareはAVPlayerを使えば簡単に実現できるが、独自のプレイヤーを実装していても実現するすべがある
- イベント送信についてはまだよくわかっておらず...

## 導入

離れた場所にいる人たちと同じ部屋にいるような感覚でアクティビティを楽しめる新しい方法として `SharePlay` は開発されました。

SharePlayは、`GroupActivities` フレームワークによって実現されています。

このセッションでは、サードパーティアプリにSharePlayを採用する方法が紹介されています。

## Communication

![image](/images/wwdc21-meet-group-activities/ss-1623297704.png)

Appleは、スムーズに自然なコミュニケーションができることが最重要であると考え、FaceTimeとMessagesにSharePlayを組み込んでいます。

ユーザーは、自分にとって最も身近な人たち、友人や家族とのコミュニケーションにかなりの時間を費やしています。
それらは、映画を見るためにリビングルームに招待する対象となるような人たちです。

SharePlayで促進したいのは、まさにそのような人たちとの体験の共有です。

### Session

![image](/images/wwdc21-meet-group-activities/ss-1623298419.png)

SharePlayには、Sessionという概念があります。
Sessionを開始すると、ユーザーはいつものMessagesやFaceTimeで、テキスト、オーディオ、ビデオを使ったコミュニケーションができるようになります。
ユーザーはSessionの中でこれらを柔軟に切り替えられます。
開始済みのSessionに新しい人を招待したり、Sessionの途中で離脱もできます。

SessionをOSが管理してくれるため、ユーザーはSession中でもあらゆるアプリを利用することができます。

各アプリの開発者は、Group Activitiesを使えば、これらの機能を全て利用できます。

## Platform

![image](/images/wwdc21-meet-group-activities/ss-1623305725.png)

Group ActivitiesはiOS、iPadOS、macOSの全てに同じ体験を提供できます。
それだけでなくWebサイト（WebKitブラウザ）でも利用できます（後からmacOSではという言及もあったので要調査）。
Apple TVでも動作するので、大画面のテレビでも楽しめます。

Sessionにはどのデバイスからも参加できますし、複数のデバイスをシームレスに使うこともできます。
AirPodsをはじめとするBluetoothデバイスにも素晴らしいオーディオを提供できるように設計されています。

### Playback

共視聴体験のトリガーになるのは、再生ボタンです。
ユーザーがどのコンテンツに時間を費やすかを決める瞬間です。

Appleは、すべての再生ボタンがSharePlayと連動することを目標としています。
ユーザーが友達とFaceTimeで話しているときに、アプリ内のメディアをいつでもSharePlayできるようにしたいと考えています。

各アプリが簡単にSharePlayできるよう、既存のコードそのままで使えように設計したAPIを提供しています。
グループで会話をしているときにいつでも、各アプリの再生ボタンからSharePlayを開始できるようになります。

### Time-Synced Playback

SharePlayでは、再生の同期が可能です。
誰かが再生ボタンを押すと、グループ全員のデバイスで同時に再生が開始します。
お気に入りのシーンにジャンプすれば、他の全員にもそのシーンが表示され、まるで同じ部屋にいるかのように体験することができます。

この同期は、手元のメディアを再送信することで実現しているわけではありません。
各々のデバイスに直接ストリーミングされ、各デバイスでの最高品質のメディアを再生できます。

### スマートボリューム

再生中に誰かが発言すると、コンテンツの音量が自動的に下げられ、同じ部屋にいるようにコミュニケーションをとることができます。

### Picture in Picture

Picture in Pictureとの相性も抜群で、PiPによりコンテンツを視聴しながら他の様々なアプリを利用することができます。


## Content

FaceTimeで通話中のユーザーは、各アプリを起動したとき、そのアプリのコンテンツを共有できることを期待するようになります。

SharePlayにより、各アプリのタッチポイントを拡大し、アプリにかかわる時間を増やすことができます。
既存ユーザーが友達とSharePlayをすることで、自然にあなたのアプリを広めてくれることでしょう。

## Group Activities

Group Activitiesはフレームワークのコアコンセプトです。
Group Activitiesは、FaceTimeでSharePlayをして楽しむ対象（オブジェクト）です。

FaceTimeでの通話中、ユーザーがGroup Activitiesを採用しているアプリを起動すると、そのアプリにその旨が通知されます。

GroupActivity protocolに準拠することで、Activityを共有する設定ができます。
設定が完了したら `prepareForActivation` APIによりActivityの共有を開始します。

このAPIを契機に、ActivityをFaceTime通話中の全員と共有するかしないかの選択をユーザーに提示します。

![image](/images/wwdc21-meet-group-activities/ss-1623313023.png)

ユーザーが共有することを決めると、フレームワークから通知があり、`GroupSession` オブジェクトに参加します。
GroupSessionに参加後は、再生、一時停止、シークなどの操作がグループ内で同期されます。

ユーザーがグループセッションに参加すると、再生、一時停止、シークなどの操作をしても、ビデオはグループと同期したままになります。

また、再生を終了する場合、ユーザーは自分だけが終了するのか、グループの全員の視聴を終了するのかを選択できます。

## アーキテクチャ

![image](/images/wwdc21-meet-group-activities/ss-1623313958.png)

GroupActivitiesは、Swiftネイティブのフレームワークです。
このフレームワークは、AVFoundationと密に連携され、ビデオやオーディオの共視聴を簡単に実現できます。

### GroupActivity

GroupActivityは、アプリがなにを共有するかを定義するためのものです。

例えば、オーディオやビデオを共視聴する場合は、再生されるコンテンツのURLを保持します。

オーディオやビデオの共視聴だけでなく、アプリ独自の体験の共有（ソースでは custom experience と記載されているが、この記事では以後 カスタム体験 とする）を提供することもできます。
例えば、グループでお絵描きをする体験など。
その場合は、ユーザーが何を描くかを保持します。

### GroupSession

GroupSessionは、基本的には、体験を共有するグループのことです。
グループへの参加者などを管理できます。

GroupSessionに参加しているデバイス間でデータを送受信するためのAPIもあります。
なお、GroupSessionは大量のデータをやり取りするためのものではないことに留意してください。

たとえば音楽を共有する場合、GroupSessionは曲のデータ自体をやりとりするためには使用されません。
再生、一時停止、シークのコマンドのみやりとりします。

また、GroupSessionの通信は、エンドツーエンドで暗号化されています。

### Activity開始の実装

![image](/images/wwdc21-meet-group-activities/ss-1623315208.png)

ふたりがiPhoneのFaceTimeで通話しているとします。
ふたりは「Awesome App」というアプリを使っていて、ふたりで一緒にこのアプリを体験しようとしています。

まず、左のiPhoneにあるアプリがActivityを開始するとします。

アプリが最初にすべきは、GroupActivity protocolに準拠したオブジェクトを作ることです。
この例では、GroupActivityに準拠したAwesomeActivityオブジェクトを作成しています。

このGroupActivity protocolに準拠したオブジェクトには、共有されるActivityの情報を保持しています。
例えば、動画を一緒に視聴する場合は動画のURLを持ちますし、カスタム体験で一緒にお絵描きをする場合は何を描くかについての情報です。

Activityを作成した後にすべきことは、そのActivityの `prepareForActivation` を呼び出すことです。
これにより、ユーザーにActivityを開始するかどうかの許可を求めるプロンプトが表示されます。

いきなりActivityが開始されユーザーが驚かないよう、ユーザーに同意を得るこのステップは必要です。

最後に、ユーザーがActivityの開始を許可したら、アプリはActivityの `activate` を呼びます。
こうすることで、アプリが体験の共有を開始しようとしていることがOSに伝えられます。

### Session監視の実装

次に、Sessionの監視についてです。
先ほどActivityをactivateした続きからです。

![image](/images/wwdc21-meet-group-activities/ss-1623316672.png)

アプリはGroupSession classの `AsyncSequence` から受け取ったSessionを繰り返し処理する必要があります。
Sessionからは体験を共有するためのGroupSessionオブジェクトを取得できます。

この手順はSessionを開始した側のデバイスでも、共有された側のデバイスでも同じです。

GroupSessionの開始と監視についての詳細は、 [Coordinate media experiences with Group Activities](https://developer.apple.com/videos/play/wwdc2021/10225/) を参照してください。 

### Sessionへの参加の実装

![image](/images/wwdc21-meet-group-activities/ss-1623317080.png)

アプリがSessionを取得したら、そのSessionに参加する前にセットアップが必要です。
セットアップの内容はアプリのユースケースによって異なります。

例えば、一緒にお絵描きをするカスタム体験なら、必要なアセット（画像など）をロードします。

アプリが動画や音楽などのメディアの共視聴を提供する場合は、`AVPlayer` の `AVPlaybackCoordinator` を `GroupSession` にフックして、AVPlayerがコンテンツを同期できるようにします。

この同期のサポートはAVPlayerを利用していなくても可能です。
独自のプレイヤーを実装している場合でも `AVDelegating PlaybackCoordinator` により実現できます。

アプリの設定が完了したらGroupSessionの `join` を呼びます。
joinが呼ばれると、システムは参加したデバイスのアプリ間にエンドツーエンドの暗号化されたチャンネルを作ります。

これで、アプリはデータを同期し、ユーザーは体験の共有をできるようになりました。

カスタム体験の場合、アプリはこのチャンネルでデータをやりとりし、独自にユーザー同志を同期させることができます。
このチャンネルは、AVFoundationでも使用されており、ユーザーが再生、一時停止、スキップなどを行った際に再生状態をやりとりすることで、メディアの再生を同期しています。

繰り返しになりますが、このチャンネルは大量のデータをやり取りするためのものではありません。ユーザー同士を同期させるための情報のみをやり取りします。

これで、アプリはSessionに入り、ユーザーは体験を共有して楽しめるようになりました。

### イベント送信の実装

![image](/images/wwdc21-meet-group-activities/ss-1623318866.png)

ユーザーの体験を豊かにするために、もう一つできることがあります。
イベントの送信です。

イベントを送信することで、ユーザーは体験中に何が起こっているのかを知ることができます。

例えば、誰かがトラックを再生したり、一時停止したり、スキップしたりしたことをユーザーに知らせるために使います。
イベントを送信すると、システムはそのイベントについてユーザーに通知します。

------

**※ このあたり何を言っているのか正直理解できておらず。次の詳細なセッションの内容を確認してから書き直します**

現在のAPIでは、メディア再生の体験のためのイベントを送信することしかできません。

AVPlayerやAVDelegating PlaybackCoordinatorを使用している場合は、無料でイベントを送信できます。

しかし、これらを使用していなくても、フレームワークを使用してイベントを送信することができます。

-----

独自のカスタム体験の提供やイベントの送信について詳しく知りたい場合は [Build custom experience with Group Activities](https://developer.apple.com/videos/play/wwdc2021/10187/) を参照してください。

