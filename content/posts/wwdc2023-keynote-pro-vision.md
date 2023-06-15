---
title: "WWDC2023 KeynoteのApple Pro Visionの紹介をとにかく細かく視聴してコメントしました"
date: 2023-06-15T15:11:44+09:00
draft: false
author: "tokorom"
authors: [tokorom]
tags: [ios,visionos,apple,wwdc]
images: [/images/wwdc2023-keynote-vision/top.png]
canonical: https://spinners.work
---

タイトルのとおりですが、KeynoteのApple Pro Visionの紹介部分を見直して、一場面一場面停止して詳細を眺めつつ、感じたことを１つ１つ細かくコメントしていきました（3時間以上かかりました...）。

## 留意事項

- ソフトウェア面に注視し、ハードウェアの説明の部分はスキップしています
- あくまでも所が思ったこと感じたことをコメントしていくだけでエビデンス等はありません
- Keynoteを視聴しながら都度思ったことを時系列に書き込んでいますので検討外れなことを言ったりもします
    - 視聴が進んでいく中で前半にコメントした疑問が後半で解決したり訂正されたりもしています

## イントロダクション

### ホーム画面

![01](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-01.png)

- 丸いアプリアイコンが並ぶ
- フォルダらしきものもある
- iPhoneのホーム画面のようにページをサポートしたりするのだろうか？
- Spotlightやウィジェットなどの扱いは？

![02](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-02.png)

- 左端に３つのモード？を切り替えるようなボタンがある
    - １つはアプリモード
    - １つは隣あった人のアイコン
        - SF Symbolsでいうと `person.2.fill` 
        - なんらか人とコミュニケーションをとるためのモードか？
        - コミュニケーションがトップレベルに位置しているのがそこを重要視しているあらわれか
    - １つは景色的なアイコン
        - SF Symbolsで言うと `mountain.2.fill` に似ているが同じものは見つからず（それに星的なものが付いている）
        - アプリ、コミュニケーションに並んでトップレベルに置かれるもの、なんだろう？
        - ARでなく全面を覆うVRモード的なものに入ったりする？
        - （と思ったが後にDigital Crownで現実と仮想の深度を調整できると紹介されていたので違いそう）

### 写真アプリ

![03](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-03.png)


- ウィンドウ内で写真のリストをスクロールするデモ

![04](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-04.png)

- ホーム画面にもあった左端のボタンリストが写真アプリに入って切り替わった
- おそらくこれがvisionOSにおけるタブバーだろう
    - タブバーがホーム画面にも存在するというのはiOSなどではなかった

![05](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-05.png)

- 画面下部にはコンテキストのスイッチャー的なUIがある
- これはiOSの写真アプリにもあるものだが写真アプリのウィンドウから少し外れて表示されているのが特徴
- おそらくiOS標準のUIコントローラを利用していればこのようにOSに合わせて良きように表示してくれるのだろう
    - 可能な場面では標準のUIコントローラを利用するのがより重要になりそう 
- さらにこの下に謎のドットとバーのUIがある
    - バーはiOSだとドラッグ可能であることを示すUI
    - これでウィンドウの場所を変更するなどできるのかもしれない
    - その隣にあるドットもウィンドウをなんらか変更するUIかも？たとえばウィンドウを最小化するとか

### UI

![06](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-06.png)

- 目、手、声で操作する
    - 重要視する操作方法の順番と思われる
    - 目（Eye Tracking）が一番はじめにくるのが特徴か
    
![07](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-07.png)

- 360度？好きな位置にウィンドウを配置できるとのこと
- 「好きな大きさで」アプリを使うというキーワードもあった
- iOS/iPadOSではなかった複数のアプリが同時にフォアグラウンドにあるという状態がありそう
    - もしくは注視している１アプリがフォアグラウンド扱いとか制御される？
- ディスプレイサイズの制限はもちろんないのでアプリのUIデザイン（レイアウト）のしかたは大きく変わってくるのか？
- アダプティブなレイアウト（ウィンドウサイズが柔軟に変わる）をサポートする知見は重要
- ウィンドウが並ぶのでドラッグ＆ドロップなどアプリ間の連携を意識することもより重要になるだろう
- このスクショの画面をみるかぎり、真正面にないアプリにもフォーカスがあたっている
    - 複数のアプリがフォアグランドになるか、視線があたっているアプリ１つがフォアグランドになるかのどちらかで確定っぽい

![08](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-08.png)
![09](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-09.png)


- この写真がグワっと拡大して没入モードになるところすごい
- いちおうウィンドウサイズのテンプレート的なもの（Normalサイズ、Expandサイズとか）はあるのかな？


![10](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-10.png)


- この部分のトップバー的な位置に目を向けると、iOSではナビゲーションバーのleftButtonItem、rightBarButtonItemに配置される要素がある
- これは透明なナビゲーションバーなのか、それとも別の概念なのか
- なおKeynote内で他にもナビゲーションバー的なものの他のバリエーションが散見される

![11](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-11.png)
![12](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-12.png)
![13](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-13.png)

- これらがMacアプリだとこうなる、visionOSアプリだとこうなるみたいなアプリ種別によるものなのか
- もしくはアプリの状態やモードによるものなのか

![14](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-14.png)


- この場面には利用者本人が映っているのでイメージだろうが、映画やゲームで背景をコンテンツに合わせたものに差し替えるというのはありそう
    - 映画視聴で背景を暗くするというのは後から具体的に説明があった

![15](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-15.png)


- これも利用者本人がいるのでイメージだろうが、FaceTimeなどでプレゼン資料と参加者の顔が空間内で横並びになっているのはリアルに近いミーティングができそうですごい

![16](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-16.png)

- Macがパーソナルコンピューティング
- iPhoneがモバイルコンピューティング
- そしてVision Proが空間コンピューティングを切り拓く！しびれる！

## Vision Proを実際に使う体験

![17](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-17.png)


- この画面は「ホームビュー」という名称で紹介されていた

![18](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-18.png)


- アプリの背景は透過されブラーがかかっていて角丸

![19](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-19.png)


- このタブバー？はフォーカスされることで拡がり、アイコンのみ表示からタイトル付き表示に切り替わった
- このフォーカスされることで領域も内容も拡大される挙動はタブバーだけでなくアプリ全体の共通のUIのよう

![20](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-20.png)


- アプリのウィンドウの影が現実世界に投影されるのがすごい

![21](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-21.png)

- ウィンドウの右下隅のカーブ状のノブでウィンドウサイズが変更可能とのこと
    - ふだんは表示されていないのでウィンドウの隅を注視すると表示されるのかもしれない

![22](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-22.png)

- ウィンドウ下のバー（ノブ）はウィンドウを動かすUIであることが確定
    - ここではZ方向に動かしているが、XY方向に動かせるかは不明

![23](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-23.png)


- アプリ（ウィンドウ）を複数開くと自分（の真正面？）を中心に自動的にスペースが割り当てられるとのこと
    - この場面では、アプリが２つの場合は真正面にどちらか一方がくるのではなく真正面の左右にそれぞれが配置されていた

![24](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-24.png)

- アプリ主動で背景（現実世界）部分を暗くしたりのカスタマイズができるというのも確定で良さそう

![25](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-25.png)

- 現実世界 OR 仮想世界の境界（深度）はデジタルクラウンで任意で調整できるとのこと
- ２択でなく曖昧にでき、ハードウェアでいつでも？調整できるというのが素敵

![26](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-26.png)

- 視線を向けた部分にフォーカスが当たるというので確定っぽい
- アプリアイコンはフォーカスが当たると分解されて一部が浮き上がっている！
    - ということはアプリアイコンをそういう作りにできる（することが推奨される）ということ
    - アプリアイコンのレイヤー分けはtvOSアプリ用のアイコンで既に採用されている
    
![27](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-27.png)

- フォーカスがあたっている要素を選択するのは「２つの指同士をタップ」
- スクロールは「２つの指を上下にずらす」

![28](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-28.png)

- 検索フィールドに視線を合わせたら「声で検索キーワードを入力できる」とのことだが、声を使うのは最後の手段だろうなという印象
- 複雑なURLやパスワードを打つのは大変そうだから基本的には文字入力はさせないことをベースに考えるのだろう
    - いっぽうで既にAppleTV+iPhoneの連携でtvOSの画面のパスワードをiPhoneで入力という機能は実現されているし、visionOSでも物理キーボードが使えることが明示されているので、複雑な文字入力が必要な場面があっても問題はないだろう

![29](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-29.png)

- EyeSight
    - 装着車の目がゴーグルの前面のディスプレイに表示されるとのこと（見た目はちょっと不気味の谷
    - ゴーグル装着者を周りから孤立させない（逆もまた然り）という考え方は素敵
    - EyeSightも「近くに人がいる時は」というトリガーなので良さそう
    - アプリを使っているとき、没入モードのときなど装着者の状態を周りの人が判断できるようになっているのもすごい

![30](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-30.png)

- 装着者目線だと没入モード時に近くに人が来たら自動的に背景が透けてその相手が見えるとのこと

## 実際の使用感

![31](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-31.png)

- Vision ProはiPhone/iPad/Macと常に同期
- iCloudで常に同期（これは既存にもあるので特別ではない）

![32](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-32.png)


- 真ん中にSafari、左右に別のアプリがある状態で「Safariを拡大」した時はこうなる
- 拡大（Expand）モード的なものがあり、そのモードになると他のウィンドウは見えなくなるっぽい
 
![33](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-33.png)


- visionOSのナビゲーションバー（トップバー）はこのコンテンツウィンドウから離れた場所に表示されるものが基本っぽい

![34](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-34.png)


- ここでアプリのウィンドウは「前後にも上下にも積み重ねられる」ことが明示された

![35](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-35.png)


- アプリ内の要素のドラッグ＆ドロップができることも明示
    - しかも他アプリだけでなく現実世界へのドロップ！

![36](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-36.png)

- メッセージで届いた3Dオブジェクトを現実世界の机の上におけるのすごい

![37](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-37.png)


- もちろんMagic TrackpadやMagic Keyboardも使える
    - Bluetoothアクセサリ...と紹介されていたので、ぼくのHHKBもきっと使えるはず

![38](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-38.png)

- あとはこれがすごすぎる
- 現実世界のMacを見つめるとMacのスクリーンがVision Proのほうに映るとのこと
    - もちろんVision Proのアプリと並列に並ぶ
- iPhoneやiPadもそうなるのかな？
- これはApple製品にどっぷりつかる理由になるな（もう既にどっぷりつかってるけど）

![39](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-39.png)


- リモートで同僚と同じ書類を使いながらの共同作業が...とあるが、これはvisionOSではじまったものではなく既存からあるもの
    - こういった共同作業サポートがスタンダードになったら嬉しいがアプリ開発の難易度は確実に上がる...
- この場面ではアプリが上下に並んでいる実例が

![40](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-40.png)

- このFaceTimeでのミーティングの風景
- プレゼン資料が投影されているがこれがSharePlayであることが明示された
- そのため、SharePlay対応していればサードパーティアプリでもこのような使い方ができるはず
    - そもそもiOSの画面共有もSharePlayなのでなにも対応してなくても自分のアプリをここに投影できる可能性が高い
    - 今考えるとSharePlayがFaceTimeと密結合なのはこのVision Proでの利用を見据えてだったのかもな、と

## 家での体験

![41](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-41.png)

- アプリ手動で背景（現実世界）をいじれることを再確認

![42](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-42.png)

- この場面はパノラマ写真をパノラマ表示したものだったようだ

![43](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-43.png)

- Vision Proでは3Dカメラによる空間再現写真・ビデオの撮影が可能

![44](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-44.png)

- もちろん空間再現写真・ビデオを視聴することもできる

![45](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-45.png)

- 映画視聴のときは、フッド山などの環境を開いて（おそらく背景に奥行きのある壮大なものを選ぶのが良いということかと）スクリーンを拡大するのがおすすめとのこと
- もちろん背景は自動的に暗くなる
- 空間オーディオの品質が高いのはお墨付きだし映画視聴良いかもな
- もし視聴中に家族がきて声をかけられても、自動でそれを検知して家族の姿が見えて声も聞こえるようになるのがvisionOSのすごいところ
- Apple TV+だけでなく他の動画視聴サービスにも対応しているとのこと
    - 標準のAVPlayer使っていれば対応してくれるのだと予想

![46](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-46.png)

- 3Dムービーにも対応
    - アバター２をこれで視聴してみたい

![47](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-47.png)

- 恐竜がウィンドウからXYZ全方向にもはみ出してるのもすごい

![48](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-48.png)

- Apple Arcaceのゲームを遊べるという件は...コンテンツ次第か
    - ウィンドウに収まらない３Dのゲームとか出たら体感的にはすごそう
- それよりもNintendo SwitchのゲームをVision Pro経由で遊びたいですね

## ウォルト・ディズニー

- Kyenoteでウォルト・ディズニーが登場して、コンテンツが揃っていることを（目標にしている）前面に押し出しているのを感じる

![49](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-49.png)

- コンテンツと一緒に背景も配布してくれるみたいのがあるのかも

![50](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-50.png)

- スポーツ観戦でさまざまな付加情報が表示されたり
- あとは複数のカメラの映像が同時に表示されていて、おそらく視線を向けたカメラに切り替わるだろうUIになっているのが興味深い

![51](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-51.png)

- ミッキーが自分の部屋に降臨！
- ディズニーでなくても、自分の好きなキャラクターが自分のそばにいて動いて喋ってくれるのは喜ぶ人たくさんいそう

![52](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-52.png)

- 現実世界の自分の腕にブレスレットが装備される場面
- こういう現実世界とかけあわせたコンテンツはVision Proならではの体験になりそうか
    - 後から出てくるがこういうアプリを「空間対応アプリ」と呼ぶよう

## ハードウェア

（ハードウェアの部分は基本スキップします。気になったところだけスポットで。）

![53](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-53.png)


- R1チップによりディスプレイには新しいイメージが12ミリ秒以内に送られるとのこと
    - つまり80fps以上
    - 現実世界部分が80fps以上で投影されるのなら、現実世界のテレビにスプラトゥーンを映して、それをVision Pro経由でプレイして付加情報を隣に出すみたいなのも問題なさそう

![54](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-54.png)

- ビデオ会議で自分の姿を相手にどう見せるかの解
- Vision Proの機能でデジタルペルソナを作って動かしてくれるとのこと（ちょっと気持ち悪いが）

## アプリの実例

![55](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-55.png)

- 人体の機能をインタラクティブに３D表示

![56](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-56.png)

- F1マシンのデザインコンセプトの検討

![57](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-57.png)

- 製造ラインの検討と承認


![58](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-58.png)


- 新しい空間インターフェースで曲をミックス

![59](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-59.png)


- プラネタリウム


## 実業務

![60](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-60.png)


- Microsoft OfficeやTeamsも対応

![61](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-61.png)

- FaceTimeだけでなくTeams、Webex、Zoomなどでのビデオ会議も利用でき、かつ、デジタルペルソナなどVision Pro特有の機能にも対応


## アプリの開発環境

![62](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-62.png)

- 使い慣れたXcodeやSwiftUI、RealityKitやARKitで開発できます

![63](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-63.png)


- 空間対応アプリを開発するためのReality Composer Pro

![64](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-64.png)

- iOS/iPadOSで使えるフレームワークはvisionOSにも含まれる
- iOS/iPadOS向けアプリがそのままvisionOSで動く？っぽい
    - おそらくそのままmacOSで動くのと同じイメージ

![65](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-65.png)

- Unityと連携し、UnityのアプリもvisionOSで動作するとのこと

## AppStore

![66](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-66.png)

- visionOSのAppStoreではvisionOS専用アプリだけでなくvisionOSで動作可能なiPhone/iPadアプリが並ぶ

## Optic ID

![67](/images/wwdc2023-keynote-vision/wwdc2023-keynote-pro-vision-67.png)


- 虹彩による生体認証
- 双子も識別できるとのこと
- ゴーグルをつけていれば常に識別できる状態だからユーザーからするとなんの面倒もなくサインインとか購入とかができるようになるのかな？


## プライバシー保護

- 画面のどこを注視したかの情報は保護されるとのこと
    - 視線でフォーカスされるのでアプリでViewへのフォーカスを検知できるならある程度類推できるような気もするが
    - もしかしたらフォーカス時に見た目が変わるのを宣言的に書くことはできても、そこで何らかの処理を書くことができない仕組みになっているのかも？
- 指でタップした情報は保護されない（これまでのiOSアプリも同じ） 
- もちろん（Vision Proに多種のカメラやセンサーがついていても）ユーザーの周辺の情報を各アプリが勝手に収集することはできない

## 見返しての感想

- 細かく見ていくとKeynoteの紹介の中だけでも見どころがたくさんあった
- 見れば見るほどApple Vision Proの今後が楽しみすぎる！
