---
title: "[iOSDC Japan 2023] SharePlayの歴史と進化 - そしてvisionOSへ"
date: 2023-09-18T11:37:41+09:00
draft: false
author: "tokorom"
authors: [tokorom]
tags: []
images: [/images/iosdc2023-shareplay/top.jpg]
canonical: https://spinners.work
---

![image](/images/iosdc2023-shareplay/top.jpg)
<span style="color: lightgray;">Photo by <a href="https://twitter.com/huin/status/1700044357808877656" style="color: gray;">@huin</a></span>

去る2023年9月1日に [iOSDC Japan 2023](https://iosdc.jp/2023/) に参加し、 [SharePlayの歴史と進化 - そしてvisionOSへ](https://fortee.jp/iosdc-japan-2023/proposal/f304e4d7-b436-4f30-85eb-21721c465715) というセッションをもたせていただきました。

遅ればせながら **iwillblog** !

セッションスライドは [公開](https://speakerdeck.com/tokorom/shareplaynoli-shi-tojin-hua-sositevisionoshe-iosdc-2023) しているものの、スライドにはあまり内容書いておらず台本がメインのため、以下、スライドを添付しつつセッションの内容を簡単にまとめます。

## SharePlayってなに？

![image](/images/iosdc2023-shareplay/clip-1695006312.png)

2021年の発表時点ではFaceTime通話中に離れた場所の知り合いとアプリのコンテンツを共有するもの」と紹介していましたが、じつはこの2年でSharePlayの基本概念自体も大きく変わってきています。

![image](/images/iosdc2023-shareplay/clip-1695007176.png)


まず2022年に「FaceTime通話中」という制限が撤廃され、2023年のiOS17では「離れた場所の知り合い」という前提条件もなくなり、むしろ積極的に近くの誰かとアプリを共有することを推し出すものとなりました。

![image](/images/iosdc2023-shareplay/clip-1695007249.png)

SharePlayは、大きく3種に分けることができます。
Screen Sharing、Media playback、Custom UIです。

- Screen Sharingは表示されているアプリの画面をそのまま共有する機能です。
- Media playbackは動画や音楽を同期再生するものです。
- Custom UIは各アプリで自由にイベントを送受信するためのものです。
- Media playbackとCustom UIは各アプリに組み込が必要な機能で、この2つは同居できます。

## SharePlayの歴史と進化

![image](/images/iosdc2023-shareplay/clip-1695007393.png)

2021年にSharePlayが発表されました。しかしこの時点ではFaceTimeの通話中にしか発火できないという大きな制限がありました。

![image](/images/iosdc2023-shareplay/clip-1695007447.png)

翌年2022年には、FaceTime通話中でなくても、アプリ手動でSharePlayを開始したり、さらにはiMessageをトリガーとしてFaceTimeを介さずにSharePlayをすることも可能になりました。
ただ、この時点でもFaceTimeかiMessageのどちらかが必要なので「連絡先を知っている相手」とのみSharePlayができると言う制限がありました。

![image](/images/iosdc2023-shareplay/clip-1695007543.png)

そして2023年、SharePlayに革新的なバージョンアップがありました！

こちらはAppleのWebサイトのスクショですが「iPhone同士を近づけてAirDropできるようになった」という紹介とともに「iPhoneを近づけるだけでSharePlayが開始する」というSharePlayの新機能の紹介が押し出されています。

そうです！AirDropでSharePlayを開始できるようになったのです。

AirDropでSharePlayとだけ聞くと、ひょっとすると「AirDropでできるのちょっとだけ便利になったね」くらいの印象かもしれません。

しかし実際にはこれは **「連絡先を知らない相手」とも気軽にSharePlayが可能になった** というSharePlayの歴史においては革新的なバージョンアップなんです。

これでSharePlayを利用開始する敷居は格段に下がりました。

また、AirDropするということはAirDropする相手がすぐ近くにいるということですので、これまで特にコロナ禍でリモートで離れた場所にいる家族や友達とのSharePlayという押し出しかただったのと比較し、2023年には「近くにいる知り合い」とのSharePlay！というのも大きく推し出されるように変わりました！

もっというとAirDropの採用は、連絡先を登録しあうまでではない知り合いとの **インスタントなSharePlay** がユースケースに加わったということを示しています。

## その他のバージョンアップ

![image](/images/iosdc2023-shareplay/clip-1695007736.png)

まず、2022年 iOS15.4でSharePlayのカスタムUIで一度に送信できるメッセージのサイズが64KBから256KBに拡大されました。

![image](/images/iosdc2023-shareplay/clip-1695007759.png)

次にiOS15.4でメッセージ送信のレイテンシを改善する機能も入っています。具体的には優先度の低いメッセージをアプリで明示的に指定し、UDPで高速に送信できるようにする仕組みです。

たとえばお絵描きアプリであれば、線を描いている途中経過については低レイテンシで高速にメッセージを送信し、線を全て描き終わったタイミングで線の全ての情報を改めて信頼性の高いメッセージで送信しなおす、といったことが可能です。

![image](/images/iosdc2023-shareplay/clip-1695007782.png)

またiOS15.4ではアプリがSharePlayの開始を簡単に実現できるようにGroupActivitySharingControllerというクラスも追加されました。

これを利用することでアプリ手動でSharePlayを開始し、FaceTimeやMessageで友達をSharePlayに招待するUIをOS任せで簡単に実現できるようになりました。

![image](/images/iosdc2023-shareplay/clip-1695007801.png)

そして2023年、iOS17でSharePlayの仕組みの中でファイル送信も可能になります！

これまでは画像やPDFなどの重いファイルをSharePlayの仕組みの中だけで送受信することはできませんでした。

iOS17からは、たとえばお絵描きアプリの写真やPDF添付機能もSharePlayの仕組みの中だけで完結できます。

![image](/images/iosdc2023-shareplay/clip-1695007823.png)

さらに素晴らしいことにSharePlayのファイル転送の仕組みは、SharePlayに後から参加した人へのフォローもしてくれます。

通常SharePlayは後から参加した人に現在の状態を伝えるために、他の参加者がこれまでの経緯をまとめて送り直す必要があります。

しかしサイズの大きいファイルを送り直すのは大変です。SharePlayのファイル転送機能では、他の参加者が送り直さなくてもAppleのサーバから直接ファイルをダウンロードすることが可能とのことです。

![image](/images/iosdc2023-shareplay/clip-1695007843.png)

そして最後に、tvOS17からはApple TVでもFaceTimeが可能になりました！

これ自体はSharePlayに関するアップデートではありませんが、マルチプラットフォームでSharePlayを扱いやすくなったという点で非常に良いニュースかと思います。

## visionOSでのSharePlay

とここまでSharePlayの歴史と進化について紹介してきましたが、今年2023年にはApple Vision Proも発表されました。
SharePlayは、もちろんvisionOSにも対応します。

もっというとvisionOSでコミュニケーション・コラボレーションをするための根幹としてSharePlayが使われています。
もしかするとSharePlayはもともとvisionOSのために設計されたものだったのではないか、と思ってしまうほどです。

![image](/images/iosdc2023-shareplay/clip-1695007899.png)


まず、FaceTime通話中はアプリのウィンドウの上部に常にSharePlay用のボタンが表示され、いつでもすぐにSharePlayが可能な状態になっています。

iOSなどと比較するとSharePlayのプライオリティがかなり高く設定されているという印象です。

![image](/images/iosdc2023-shareplay/clip-1695007914.png)


また画面サイズの制限がないvisionOSでは、SharePlayでのコラボレーション中のアプリのウィンドウと、コラボレーション中のメンバーのペルソナが同時に表示され、iOSでのSharePlayと比較して格段に良い体験ができることが期待されます。

メンバーの視線やジェスチャーが見られる状態でアプリのコンテンツもフル表示にしてコラボレーションできるというのは素晴らしいです。

メンバー同士が視線を合わせるといった動作もvisionOSが良きように再現してくれるそうです。

![image](/images/iosdc2023-shareplay/clip-1695007930.png)

なお、SharePlay中のアプリのコンテンツに対して、参加者のペルソナがどう並ぶかも制御可能で、

- みんなが横並びになるSide-by-Side
- コンテンツをみんなで囲むSurround
- コンテンツの前で輪を作るようなConversational

という３種のスタイルを指定可能です。

![image](/images/iosdc2023-shareplay/clip-1695007973.png)

それでは、そんな素晴らしいvisionOSのSharePlayに自分たちのアプリを対応するには、どうしたら良いでしょうか？

基本的には、すべてのアプリがなにもしなくてもデフォルトでSharePlayに対応されます。

SharePlayの３種のうちScreen sharing、つまり画面共有はiOS同様デフォルトで有効になっているということです。

具体的には先ほど紹介したアプリのウィンドウ上部のSharePlayボタンなどからSharePlayの開始が可能です。

![image](/images/iosdc2023-shareplay/clip-1695007994.png)


ただ、 **なにもしなくても対応されるからといって、なにもしなくても良いとは限りません。**

アプリによってはShareされるシーンがどれになるかを制御することが推奨されます。シーンごとにCan（Share可能か）とPrefers（Share可能なシーンの中でもより推奨されるか）の２種のフラグを設定し、コンテキストに応じてShareされるシーンを制御することができます。

アプリによっては個人情報が表示される部分などShareされたくない画面をガードすることも、もちろん必要かと思います。

またもちろん、Screen sharingだけでなく、Media playbackやCustom UIに対応するにはアプリごとに実装が必要になります。

![image](/images/iosdc2023-shareplay/clip-1695008038.png)

もう1つvisionOSの特有のUIとして **Immersive Space（没入空間）** という概念があります。

没入空間は自分の周り全てがアプリのコンテンツに覆われた空間です。
この没入空間は基本的には自分一人で入り込む空間です。

SharePlay中ももちろん没入空間に入ることが可能です。

ただ前述のとおり没入空間には一人で入るため、他の参加者と見えるものが違い、混乱を招く可能性があります。

![image](/images/iosdc2023-shareplay/clip-1695008084.png)

SharePlayにはそれを解決するために没入スタイルを同期するための機能も備わっています。

そのため自分が没入空間に入ったら他のメンバーも同じ空間に連れていき、没入空間から出るときは一緒に出るといった制御も可能とのことです。

![image](/images/iosdc2023-shareplay/clip-1695008097.png)

また、visionOSでは自分が没入空間のどこにいるかを取得することも可能で、たとえば、自分の目の前、だけにコントロールパネルを設置するなども可能です。

### visionOS+SharePlay


visionOSでのSharePlayについての紹介、も以上です。

visionOSでのSharePlayの推し出され方に個人的にはとても感動しております！
Apple Vision ProでSharePlayできるようになるのが本当に楽しみですね！

## オマケ Q&A

![image](/images/iosdc2023-shareplay/clip-1695008167.png)

![image](/images/iosdc2023-shareplay/clip-1695008189.png)


相手が対象のアプリを持ってない場合は、スクショのように「AppStoreからのダウンロードを促す」表示になります。

これを押すだけでAppStoreのダウンロードページが表示されます。
アプリの提供者側からしても、ユーザーが友達同士でアプリを直接紹介してくれる導線になる、というメリットもありそうです。

![image](/images/iosdc2023-shareplay/clip-1695008215.png)

![image](/images/iosdc2023-shareplay/clip-1695008223.png)

この答えですが、どうするかは各アプリ・サービスに委ねられます。

例えば有料コンテンツであってもSharePlayの場合に限って無料で視聴できるようにすることも考えられます。

その他、例えばAppleTV+ではフリートライアルの開始を促すようにするようです。

フリートライアルへの誘導は「SharePlayの体験を阻害せず」「有料サービスへの導線にもなる」と、ユーザーにとってもサービス提供者にとってもメリットがあるという意味で最適かもしれません。


----


以上です。
**ididblog** !!

## 留意点とMore Information

本資料に掲載しているスクリーンショットは以下WWDCセッションビデオより抜粋したものです。

- [What's new in SharePlay](https://developer.apple.com/videos/play/wwdc2022/10140/)
- [Add SharePlay to your app](https://developer.apple.com/videos/play/wwdc2023/10239/)
- [Design spatial SharePlay experiences](https://developer.apple.com/videos/play/wwdc2023/10075/)
- [Build spatial SharePlay experiences](https://developer.apple.com/videos/play/wwdc2023/10087/)
- [Share files with SharePlay](https://developer.apple.com/videos/play/wwdc2023/10241/)


