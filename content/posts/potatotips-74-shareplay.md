---
title: "potatotips #74 で「5分でSharePlay入門」のLTをしました"
date: 2021-06-28T13:29:12+09:00
draft: false
author: "tokorom"
authors: [tokorom]
tags: [iOS,SharePlay,potatotips]
images: [/images/potatotips-74-shareplay/top.png]
canonical: https://spinners.work
---

![image](/images/potatotips-74-shareplay/top.png)

## potatotips #74

2021年6月23日（水）にWantedlyさんご主催のオンラインpotatotips（iOS/Android開発Tips共有会）が開催されました。

- [イベントページ](https://potatotips.connpass.com/event/214754/)
- [当日のLT一覧](https://github.com/potatotips/potatotips/wiki/potatotips-74)

私はpotatotipsの運営窓口を担当しているのですが、今回はひさびさにLTもさせていただきました。

LTの内容は「5分でSharePlay」です！
スライドは [コチラ](https://speakerdeck.com/tokorom/5fen-deshareplayru-men)。

今回は、このLTの内容をこちらにブログ記事としてまとめさせていただきます。

## SharePlayとは？

![image](/images/potatotips-74-shareplay/ss-1624855130.png)

SharePlayとは、FaceTime通話中に離れた場所の友達とアプリのコンテンツを共有する機能です。
このスクショは離れた場所にいる2人が不動産アプリを一緒に見ながら新しい家の候補を決めている様子です。

## 利用シーン

![image](/images/potatotips-74-shareplay/ss-1624855201.png)

SharePlayの利用シーンは様々です。
WWDC21の各セッションの中でも様々なシーンが紹介されています。

- 一緒に映画やスポーツを視聴する
- ゲームのスーパープレイを自慢する
- 旅行のときの写真を友人や家族と一緒に見る
- グループでお絵描きする
- Swift Playgroundsで一緒にSwiftを学ぶ
- 不動産アプリで新しい家の候補をふたりで探す
- 実家の両親がアプリの使い方がわからないのをサポートする

## 3種のSharePlay

![image](/images/potatotips-74-shareplay/ss-1624855290.png)

SharePlayには大きく3種あります。

- Screen sharing: 画面共有
- Media playback: 動画や音楽の共有
- Custom UI: カスタム

※カスタムについてはこの記事では紹介しませんが、デバイス間でカスタムなコマンドを自由に送受信できる柔軟な仕組みがあります

## 画面共有への対応

SharePlayの画面共有に対応するには各アプリでどの程度の実装が必要でしょうか？

じつは各アプリでの対応は必要なく、なにもしなくても画面共有に対応できます。
正確には画面共有はホーム画面ごと共有され、その時開いているアプリの画面もそのまま共有されます。

### 自動的に隠される要素

画面共有は自動的にされる（されてしまう）のですが、一部、共有されない要素があります。

- パスワードなどセキュアな入力フィールド
- DRM（FairPlay）で保護されたコンテンツ

です。
その他、必要なら各アプリで隠したい要素（View）をカスタムすることもできます。

## 動画の共有への対応

最後に動画の共有への対応についてです。

### AppleのTVアプリの例

AppleオフィシャルのTVアプリでは次の手順で動画のSharePlayを開始できます。

![image](/images/potatotips-74-shareplay/ss-1624857105.png)

まず、FaceTime中にTVアプリを起動すると、コンテンツ表示部分に **SharePlayが可能であることを示すアイコン** が表示されます。

![image](/images/potatotips-74-shareplay/ss-1624857199.png)

このとき動画を再生しようとすると、 **SharePlayするかどうかを確認するダイアログ** が表示されます。
ここで **SharePlay** を選べば動画のSharePlayの開始です。

### 動画のSharePlayでできること

動画のSharePlayをすると、

- DRMで保護されたコンテンツの共有
- 再生・停止・シークなどによる再生位置の同期

などがデフォルトでサポートされます。

### 動画のSharePlay対応に必要なコード

実際に動画のSharePlayに対応してみた `ViewController` のコードが以下です。

```swift
import AVKit
import GroupActivities
import UIKit

class ViewController: AVPlayerViewController {
    private var groupSession: GroupSession<MovieWatchingActivity>?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlayer()
        prepareSharePlay()
        listenForGroupSession()
    }

    private func setupPlayer() {
        guard player == nil, let movieURL = MovieWatchingActivity.movieURL else {
            return
        }

        let player = AVPlayer(url: movieURL)
        self.player = player
        player.play()
    }
    
    private func prepareSharePlay() {
        let activity = MovieWatchingActivity()
        
        async {
            switch await activity.prepareForActivation() {
            case .activationDisabled:
                break
            case .activationPreferred:
                activity.activate()
            case .cancelled:
                break
            default: ()
            }
        }
    }

    private func listenForGroupSession() {
        async {
            for await session in MovieWatchingActivity.sessions() {
                groupSession = session
                player?.playbackCoordinator.coordinateWithSession(session)
                session.join()
            }
        }
    }
}

struct MovieWatchingActivity: GroupActivity {
    static let movieURL: URL? = URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2019/408bmshwds7eoqow1ud/408/hls_vod_mvp.m3u8")

    static let activityIdentifier = "work.spinners.SharePlaySample.GroupWatching"
    
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.fallbackURL = Self.movieURL
        metadata.previewImage = UIImage(named: "wwdc19")?.cgImage
        metadata.title = "Sample"
        metadata.subtitle = "WWDC19 Session Video"
        return metadata
    }
}
```

このわずか50行程度（空行などを省いて）で、

- 動画の再生
- 動画の共有
- 再生位置の同期

までひととおり実装できました。

もう少し重要なところを抜粋して紹介します。

### GroupActivityの用意

まず、必要なのが `GroupActivity` を実装したものです。

```Swift
struct MovieWatchingActivity: GroupActivity {
    static let movieURL: URL? = URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2019/408bmshwds7eoqow1ud/408/hls_vod_mvp.m3u8")

    static let activityIdentifier = "work.spinners.SharePlaySample.GroupWatching"
    
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.fallbackURL = Self.movieURL
        metadata.previewImage = UIImage(named: "wwdc19")?.cgImage
        metadata.title = "Sample"
        metadata.subtitle = "WWDC19 Session Video"
        return metadata
    }
}
```

といっても、共有するコンテンツのメタデータを返すだけの簡単なものです。

### GroupActivityのアクティベート

そしてその `GroupActivity` をインスタンス化して `prepareForActivation` を呼びます。すると、さきほど紹介した **SharePlayをするかどうかの確認ダイアログ** が画面に表示されます。

ここでユーザが **SharePlay** を選ぶと `.activationPreferred` が返るので、そこで `GroupActivity` を `activate` してあげるだけです。

```swift
let activity = MovieWatchingActivity()

async {
    switch await activity.prepareForActivation() {
    case .activationDisabled:
        break
    case .activationPreferred:
        activity.activate()
    case .cancelled:
        break
    default: ()
    }
}
```

これだけで動画の共有が可能です。

### 再生位置の同期をサポート

最後に再生位置の同期です。

これも簡単で、`GroupActivity` のセッションが開始されたら、そのセッションと動画再生に利用している `AVPlayer` バインドして、セッションに `join` するだけです。

```swift
async {
    for await session in MovieWatchingActivity.sessions() {
        groupSession = session
        player?.playbackCoordinator.coordinateWithSession(session)
        session.join()
    }
}
```

これだけで再生位置の同期がサポートできてしまいます。

## まとめ

- SharePlayの画面共有はなにもしなくてもサポートできる
- SharePlayの動画共有も50行程度でサポートできる
- SharePlayはカスタムして自由にコマンドを送受信することもできる

