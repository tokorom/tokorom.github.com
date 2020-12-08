---
title: "tvOSフォーカスクイズ！ ここでスワイプしたらどちらに動く？"
date: 2017-12-22
tags: [tvos,ui]
authors: [tokorom]
images: [https://qiita-image-store.s3.amazonaws.com/0/7883/c911b99d-9d09-08ea-8555-cb07e2d1ab21.jpeg]
---

## [問題]コンテンツのスワイプ

まずは、tvOSの特定の画面にて「右スワイプ」をした時に、コンテンツが左右どちらに動くでしょう？というクイズを３つ出させていただきます。
クイズの問題を３つ出した後に、それらの答えを実際の動きを撮影したGIFアニメとともに並べてありますので、答えのGIFアニメをできるだけ見ないように考えてみてください！

いずれもApple純正アプリ（ホーム画面含む）からの問題です。

### Q1. ホーム画面のTop Shelfでの左右スワイプ

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/c911b99d-9d09-08ea-8555-cb07e2d1ab21.jpeg" width=100 align=left>

![topshelf_swipe_1.jpg](https://qiita-image-store.s3.amazonaws.com/0/7883/ee64c245-370c-c097-2d64-eb832bd08989.jpeg "topshelf_swipe_1.jpg")

最初の問題はホーム画面からです。
このtvOSのホーム画面のTop Shelfで「右スワイプ」をした場合、Top Shelfは左に動いて右隣のコンテンツが表示されるでしょうか？それとも右に動いて左隣のコンテンツが表示されるでしょうか？

### Q2. 写真アプリのフルスクリーン画面での左右スワイプ

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/c911b99d-9d09-08ea-8555-cb07e2d1ab21.jpeg" width=100 align=left>

![photos_swipe_1.jpg](https://qiita-image-store.s3.amazonaws.com/0/7883/a9554067-3245-b19b-af33-d959812ae03a.jpeg "photos_swipe_1.jpg")

次の問題は写真アプリの写真をフルスクリーン表示した画面からです。
この **2** という画像が表示されている画面で「右スワイプ」した場合、画像が左に動いて右隣の **3** が表示されるでしょうか？それとも画像が右に動いて左隣の **1** が表示されるでしょうか？

### Q3. Appスイッチャーでの左右スワイプ

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/c911b99d-9d09-08ea-8555-cb07e2d1ab21.jpeg" width=100 align=left>

![appswitcher_swipe_1.jpg](https://qiita-image-store.s3.amazonaws.com/0/7883/60fc411d-b004-8ac4-a82b-c88345122628.jpeg "appswitcher_swipe_1.jpg")

次の問題はホーム画面のAppスイッチャー（TV/ホームボタンの2度押しで表示される画面）です。
この **ミュージック** がセンターに表示されているAppスイッチャーで「右スワイプ」した場合、 **ミュージック** は左に動くでしょうか？それとも右に動くでしょうか？


## [答え]コンテンツのスワイプ

### A1. ホーム画面のTop Shelfでの左右スワイプ

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/c911b99d-9d09-08ea-8555-cb07e2d1ab21.jpeg" width=100 align=left>

![topshelf_swipe.gif](https://qiita-image-store.s3.amazonaws.com/0/7883/9ae6f1b8-9c36-1636-c38b-be9d3903da47.gif "topshelf_swipe.gif")

まず、Top Shelfで「右スワイプ」した時の挙動ですが、

- Top Shelfが左に動き
- 右隣のコンテンツが表示される

というのが答えです。

tvOSには「フォーカス」の存在があり、「フォーカスが右スワイプにより右に移動する」わけなので右隣のものが表示されて当然ですよね。
そして右隣のコンテンツがセンターに表示されるようTop Shelfは左にスクロールします。

### A2. 写真アプリのフルスクリーン画面での左右スワイプ

さて、Q1の答えは「左に動いて右隣のものが表示される」という挙動でしたが、次の写真アプリの挙動はどうでしょう？

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/c911b99d-9d09-08ea-8555-cb07e2d1ab21.jpeg" width=100 align=left>

![photos_swipe.gif](https://qiita-image-store.s3.amazonaws.com/0/7883/492ba9e9-7a91-be0a-d5c0-e1f5512bf890.gif "photos_swipe.gif")

実際にこの写真アプリのフルスクリーン画面で「右スワイプ」を試した結果の挙動は、

- 表示されていた **2** が右に動き
- 左隣の **1** が表示される

でした！

あれ？Q1の答えと逆の動きだ...

### A3. Appスイッチャーでの左右スワイプ

続いてQ3のAppスイッチャーでの挙動はどうでしょう？

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/c911b99d-9d09-08ea-8555-cb07e2d1ab21.jpeg" width=100 align=left>

![appswitcher_swipe.gif](https://qiita-image-store.s3.amazonaws.com/0/7883/a4057ead-40b5-e5c1-d2d6-84d6466cf8e4.gif "appswitcher_swipe.gif")

Appスイッチャーで「右スワイプ」したときの挙動は、

- 表示されていた **ミュージック** が右に動き
- 左隣のアプリが表示される

こちらもQ1の答えの「フォーカスが右スワイプにより右に移動する」という挙動とは逆ですね。

フォーカスどこいった！？

## [問題]トップバーの表示

ここまでの３問の答えに「いや当然だろ」と思ったかたも、「あれ？」と思ったかたもいらっしゃるかと思います。
いったん細かいことを気にせずに、次の「トップバーを表示する方法」のクイズにいかせていただきます。

※基本的にはタブバーと思いますが、今回のサンプルの全てがタブばーかどうかの確証がなかったため、画面トップに表示されるトップバーという表現をさせていただきます

### Q4. 写真アプリの写真一覧画面でのトップバー表示

まずは写真アプリからの問題です。
写真アプリの写真一覧画面で、画面上部の１つの写真にフォーカスが当たっている状態とします。

![photolist_tabbar_1.jpg](https://qiita-image-store.s3.amazonaws.com/0/7883/7b9e9e46-a962-dcc9-c2cb-64bb5ccbe7e3.jpeg "photolist_tabbar_1.jpg")

さて、ここからトップバーを表示する操作は「上スワイプ」でしょうか？「下スワイプ」でしょうか？

![photolist_tabbar_2.jpg](https://qiita-image-store.s3.amazonaws.com/0/7883/94e708db-5090-4047-7b60-07b37457021a.jpeg "photolist_tabbar_2.jpg")


### Q5. 写真アプリの動画再生画面でのトップバー表示

次の問題も同じ写真アプリからです。
写真アプリで動画を再生している状態とします。

![movie_tabbar_1.jpg](https://qiita-image-store.s3.amazonaws.com/0/7883/6883f80e-ac74-f9b2-214b-9d7a00380249.jpeg "movie_tabbar_1.jpg")

さて、ここからトップバーを表示する操作は「上スワイプ」でしょうか？「下スワイプ」でしょうか？

![movie_tabbar_2.jpg](https://qiita-image-store.s3.amazonaws.com/0/7883/5d21680c-558e-719b-93f6-8e3ac6ed5f62.jpeg "movie_tabbar_2.jpg")

## [答え]トップバーの表示

### A4. 写真アプリの写真一覧画面でのトップバー表示

まずQ4の「写真アプリの写真一覧画面」でのトップバー表示の操作ですが「上スワイプ」が答えです。

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/7b9e9e46-a962-dcc9-c2cb-64bb5ccbe7e3.jpeg" width=300>

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/ea2a8828-400e-03d5-8bbb-0874b9a82d95.jpeg" width=100>

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/94e708db-5090-4047-7b60-07b37457021a.jpeg" width=300>

上部の写真にフォーカスがあたっている状態で「上スワイプ」でトップバーの要素にフォーカスを移動するわけですから、当然の結果ではありますよね。

### A5. 写真アプリの動画再生画面でのトップバー表示

次にQ5の「写真アプリの動画再生中画面」でのトップバー表示の操作方法の答えです。
Q4と同じく写真アプリですので、当然答えも同じ「上スワイプ」でしょうか？

と思いきや、こちらの答えは「下スワイプ」でした。

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/6883f80e-ac74-f9b2-214b-9d7a00380249.jpeg" width=300>

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/c791a8e2-b33f-9946-0beb-e5437224c114.jpeg" width=100>

<img src="https://qiita-image-store.s3.amazonaws.com/0/7883/5d21680c-558e-719b-93f6-8e3ac6ed5f62.jpeg" width=300>

Q4では「上スワイプ」でフォーカスを上に移動してトップバーを表示していたのに、こちらは「下スワイプ」したらトップバーが表示されてトップバーの要素にフォーカスがあたっている！あれ！？

## まとめ

このようにApple純正アプリの中でも不思議なことに同じ操作で違う挙動になります。

ただ、冷静に見ていくと全て統一したルールにて挙動が決定されているように見受けられます（と私は理解しました）。

### フォーカスがある場合の挙動

フォーカスがいずれかの要素にあたっている場合、スワイプ操作でその方向にフォーカスを移動するというのはtvOSアプリにおいては当たり前のUIです。

### フォーカスがない（ように見える）場合の挙動

一方、写真アプリのフルスクリーン画面や、Appスイッチャー、動画アプリの視聴中画面ではフォーカスが存在しない（正確には存在はするがエンドユーザー目線では存在しないように見える）という扱いのようです。

この場合、スワイプ操作でフォーカスが移動するのではなく、コンテンツそのものを引っ張るような挙動（iOSで慣れ親しんでいる挙動）になっています。

例えば、写真アプリのフルスクリーン画面で右スワイプした場合、表示している写真が右に引っ張られてずれていくイメージで、左隣の写真に移動します。

Appスイッチャーも同じような挙動になります。Appスイッチャーはエンドユーザー目線でもフォーカスがあるのかないのか微妙な感じがしてしまいますが、この挙動を見る限り、フォーカスが存在しないという扱いに分類されるようです。

### まとめのまとめ

これらはtvOSのHuman Interface Guidlinesに明記されている事項ではありません。
ただ、Apple純正アプリでは基本的にこの挙動で統一されているようですので、スタンダードなUIと考えても差し支えないでしょう（と私は主張していますが保証まではできません）。

これら標準の挙動を知った後に様々なtvOSアプリを触ると「このアプリはここがこうなっているから、このスワイプでこっちに移動する挙動にしたのかな？」と、これまでと違う視点を持つことができるようになりました。

tvOSアプリはプログラム的にはiOSとほぼ同じような作りができますが、UIデザイン面ではフォーカスの存在により全く違った考え方になる部分もありとても楽しい（難しい）ですよね！
tvOSアプリのUIにはこれからまだまだ新しい発見がありそうです。tvOS大好きな皆様、ぜひtvOSアプリのUIの今後につて語り合いましょう。

なお、これらをふまえたうえでまとめられているtvOSアプリのUIデザインについての教科書的記事がありますので、まだ未読のかたは、ぜひご参照ください。

http://kudakurage.hatenadiary.com/entry/2017/11/16/113657

### 注意点

以上のようにApple純正アプリでのスワイプによる挙動についてまとめましたが、全てのアプリがこれに従わなければならないとは考えていません。

各アプリ・サービスごとに様々な条件が絡むかと思いますので、各々で適切な挙動を決定するのが良いかと思います。
ただ、なにも考えずにUIを決定するのではなく、Apple純正アプリではこうなっているが、我々のアプリはこうしようという意志のある選択は必要かと思います。
