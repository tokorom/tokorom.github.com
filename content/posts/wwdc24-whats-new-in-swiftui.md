---
title: "[WWDC24] SwiftUIの新機能のまとめ"
date: 2024-06-25T10:56:06+09:00
draft: false
author: "tokorom"
authors: [tokorom]
tags: [WWDC,Swift,iOS,visionOS,SwiftUI]
images: [/images/wwdc24-whats-new-in-swiftui/top.jpg]
canonical: https://spinners.work
---

![image](/images/wwdc24-whats-new-in-swiftui/top.jpg)

WWDC24の [What’s new in SwiftUI](https://developer.apple.com/videos/play/wwdc2024/10144/) のまとめです。

今回、このセッションで紹介される項目の数が例年以上に多すぎてびっくりでした。
セッションでは短い間隔でポンポンとたくさんの機能が流れるように紹介されていきます。

このまとめでは、セッションでは軽く触れられた程度の内容も、APIリファレンスへのリンクをつけるなどしてもう少しだけ補足します。

このセッションを視聴する/この記事を参照する目的は、WWDC24で発表されたSwiftUIの新機能をさらっと把握し頭の中にインデックスを貼ることだと思います。

## サイドバー/タブバー

- サイドバー/タブバーがより柔軟に
- フローティングタブバーをサポート
- 項目の並び替えや使用頻度の低いオプションの非表示など、ユーザーが自分好みにカスタマイズすることもできる

![sidebar-customize](/images/wwdc24-whats-new-in-swiftui/sidebar-customize.png)

- TabViewに内包する要素も新しいタイプセーフな書き方に

```swift
struct KaraokeTabView: View {
    @State var customization = TabViewCustomization()
    
    var body: some View {
        TabView {
            Tab("Parties", image: "party.popper") {
                PartiesView(parties: Party.all)
            }
            .customizationID("karaoke.tab.parties")
            
            Tab("Planning", image: "pencil.and.list.clipboard") {
                PlanningView()
            }
            .customizationID("karaoke.tab.planning")

            Tab("Attendance", image: "person.3") {
                AttendanceView()
            }
            .customizationID("karaoke.tab.attendance")

            Tab("Song List", image: "music.note.list") {
                SongListView()
            }
            .customizationID("karaoke.tab.songlist")
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($customization)
    }
}
```

- tabViewStyleに [sidebarAdaptable](https://developer.apple.com/documentation/swiftui/tabviewstyle/sidebaradaptable) を指定することで、プラットフォームごとに柔軟にサイドバー OR タブバーが適用される
    - iOSでは常にボトムタブバー
    - iPadOSではフローティングタブバーとサイドバーが自動で切り替わる
    - macOS/tvOSでは常にサイドバー
    - visionOSではオーナメント/TabSectionが使われている場合はサイドバーも

- [tabViewCustomization](https://developer.apple.com/documentation/swiftui/tabviewcustomization) により、ユーザーがカスタマイズできる要素を調整できる（並び替え、非表示など）

- tvOSのサイドバーはフローティング表示に

![tvos-sidebar](/images/wwdc24-whats-new-in-swiftui/tvos-sidebar.png)

- macOSではセグメンティッドコントロールスタイルに切り替えることもできる

![macos-segmented](/images/wwdc24-whats-new-in-swiftui/macos-segmented.png)

## sheet

- UIKitでいうpresentViewController
- 従来はsheetが半モーダル表示という位置付けだったが、iOS18からはsheetで表示するViewに対してどのような表示にするかを指定できるようになる
- [presentationSizing](https://developer.apple.com/documentation/swiftui/presentationsizing)
  - `automatic`: プラットフォームごとに適切な表示に
  - `fitted`: コンテンツにフィットするサイズに
  - `form`: `page`よりも一回り小さい
  - `page`: おそらく従来のsheetのデフォルトサイズ
- また、presentationSizingは追加で`fitted`、`sticky`、`proposedSize`を追記できる
  - `fitted`: コンテンツにフィットさせる
  - `sticky`: コンテンツに合わせて大きくはなるが小さくはなならない
  - `proposedSize`: 詳細不明
  

```swift
.presentationSizing(
    .page
        .fitted(horizontal: false, vertical: true)
        .sticky(horizontal: false, vertical: true)
)
```

## Zoom Navigation Transition

- 写真アプリにある写真セルを選択すると拡大しながらその写真の画面に遷移するトランジション
- [navigationTransition](https://developer.apple.com/documentation/swiftui/view/navigationtransition(_:)) が新設され、そこに　`.zoom` を指定することで実現できる
- あわせて [matchedTransitionSource](https://developer.apple.com/documentation/swiftui/view/matchedtransitionsource(id:in:configuration:)) で設定をする必要がある
  - 逆にいうとこれでトランジションをカスタマイズできる

```swift
struct PartyView: View {
    var party: Party
    @Namespace() var namespace
    
    var body: some View {
        NavigationLink {
            PartyDetailView(party: party)
                .navigationTransition(.zoom(
                    sourceID: party.id, in: namespace))
        } label: {
            Text("Party!")
        }
        .matchedTransitionSource(id: party.id, in: namespace)
    }
}

struct PartyDetailView: View {
    var party: Party
    
    var body: some View {
        Text("PartyDetailView")
    }
}

struct Party: Identifiable {
    var id = UUID()
    static var all: [Party] = []
}
```

## Controls

![controls](/images/wwdc24-whats-new-in-swiftui/controls.png)

- コントロールセンターに表示するボタンやスイッチをアプリが作成できるように
- ロック画面のカメラボタンやライトボタンも置き換えられる
- ControlはWidgetの一種でApp Intentsを使って作成できる

```swift
import WidgetKit
import SwiftUI

struct StartPartyControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.apple.karaoke_start_party"
        ) {
            ControlWidgetButton(action: StartPartyIntent()) {
                Label("Start the Party!", systemImage: "music.mic")
                Text(PartyManager.shared.nextParty.name)
            }
        }
    }
}

// Model code

class PartyManager {
    static let shared = PartyManager()
    var nextParty: Party = Party(name: "WWDC Karaoke")
}

struct Party {
    var name: String
}

// AppIntent

import AppIntents

struct StartPartyIntent: AppIntent {
    static let title: LocalizedStringResource = "Start the Party"
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
```

## Swift Charts

- Vectorized plotsという新しいチャートが加わった
  - [AreaPlot](https://developer.apple.com/documentation/charts/AreaPlot)
  - [LinePlot](https://developer.apple.com/documentation/charts/LinePlot)
  - [PointPlot](https://developer.apple.com/documentation/charts/PointPlot)
  - [RectanglePlot](https://developer.apple.com/documentation/charts/RectanglePlot)
  - [RulePlot](https://developer.apple.com/documentation/charts/RulePlot)
  - [BarPlot](https://developer.apple.com/documentation/charts/BarPlot)
  - [SectorPlot](https://developer.apple.com/documentation/charts/SectorPlot)
  - [AreaPlot](https://developer.apple.com/documentation/charts/AreaPlot)

![lineplot](/images/wwdc24-whats-new-in-swiftui/lineplot.png)

```swift
import SwiftUI
import Charts

struct AttendanceView: View {
    var body: some View {
        Chart {
          LinePlot(x: "Parties", y: "Guests") { x in
            pow(x, 2)
          }
          .foregroundStyle(.purple)
        }
        .chartXScale(domain: 1...10)
        .chartYScale(domain: 1...100)
    }
}
```

## TableColumnForEach

![tablecolumnforeach](/images/wwdc24-whats-new-in-swiftui/tablecolumnforeach.png)

- [TableColumnForEach](https://developer.apple.com/documentation/swiftui/tablecolumnforeach) を使うことで、動的な数のカラムを持ったテーブルを作ることができる

```swift
Table(guestData) {
    // A static column for the name
    TableColumn("Name", value: \.name)
    
    TableColumnForEach(partyData) { party in
        TableColumn(party.name) { guest in
            Text(guest.songsSung[party.id] ?? 0, format: .number)
        }
    }
}
```

## MeshGradient

![meshgradient](/images/wwdc24-whats-new-in-swiftui/meshgradient.png)

- [MeshGradient](https://developer.apple.com/documentation/swiftui/meshgradient) で、複雑なメッシュグラデーションを表現できるように

```swift
MeshGradient(
    width: 3,
    height: 3,
    points: [
        .init(0, 0), .init(0.5, 0), .init(1, 0),
        .init(0, 0.5), .init(0.3, 0.5), .init(1, 0.5),
        .init(0, 1), .init(0.5, 1), .init(1, 1)
    ],
    colors: [
        .red, .purple, .indigo,
        .orange, .cyan, .blue,
        .yellow, .green, .mint
    ]
)
```

##  Document Launch Scene

![DocumentGroupLaunchScene](/images/wwdc24-whats-new-in-swiftui/DocumentGroupLaunchScene.png)

- [DocumentGroupLaunchScene](https://developer.apple.com/documentation/SwiftUI/DocumentGroupLaunchScene) を使い、ドキュメントベースのアプリのリッチな起動画面を作りやすく
- 大きな文字のタイトル
- 操作可能なボタン類の追加
- 背景のカスタマイズ
- 装飾をタイトルのViewの前面と背面に追加

```swift
DocumentGroupLaunchScene("Your Lyrics") {
    NewDocumentButton()
    Button("New Parody from Existing Song") {
        // Do something!
    }
} background: {
    PinkPurpleGradient()
} backgroundAccessoryView: { geometry in
    MusicNotesAccessoryView(geometry: geometry)
         .symbolEffect(.wiggle(.rotational.continuous()))
} overlayAccessoryView: { geometry in
    MicrophoneAccessoryView(geometry: geometry)
}
```

## SF Symbols

- [SymbolEffect](https://developer.apple.com/documentation/symbols/symboleffect) に3つのアニメーションが追加された
  - `breathe`: シンボルを滑らかに上下にスケール
  - `rotate`: 回転エフェクト、指定したアンカーポイントを中心にシンボルの一部を回転させる
  - `wiggle`: くねくねエフェクト、シンボルを好きな方向や角度に揺らす
- `replace` など既存のアニメーションにも新しい機能が追加された
  - [MagicReplace](https://developer.apple.com/documentation/symbols/replacesymboleffect/magicreplace/) により、バッジやスラッシュをスムーズにアニメーションできるように
    
## macOS

### Window

- [windowStyle](https://developer.apple.com/documentation/swiftui/windowstyle) に `plain` を追加
    - デフォルトのウィンドウ背景やバーのないスタイル
- [windowLevel](https://developer.apple.com/documentation/swiftui/windowlevel) を追加
    - 'normal', 'desktop', 'floating' の３階層のどの層で表示するかを指定

![window-plain](/images/wwdc24-whats-new-in-swiftui/window-plain.png)

```swift
Window("Lyric Preview", id: "lyricPreview") { ... }
    .windowStyle(.plain)
    .windowLevel(.floating)
```

- [defaultWindowPlacement](https://developer.apple.com/documentation/swiftui/scene/defaultwindowplacement(_:)) でWindowのデフォルト位置を任意に調整することもできる

```swift
.defaultWindowPlacement { content, context in
    let displayBounds = context.defaultDisplay.visibleRect
    let contentSize = content.sizeThatFits(.unspecified)
    return topPreviewPlacement(size: contentSize, bounds: displayBounds)
}
```

- [WindowDragGesture](https://developer.apple.com/documentation/swiftui/windowdraggesture) でコンテンツ部分をドラッグしてウィンドウを動かせるようにできる

- [UtilityWindow](https://developer.apple.com/documentation/swiftui/utilitywindow) のような新しいタイプのWindowもある
  - アプリのメインコンテンツに関連するコントロール、設定、情報を表示するWindow

![UtilityWindow](/images/wwdc24-whats-new-in-swiftui/UtilityWindow.png)

### modifierKeyAlternate

![modifierKeyAlternate](/images/wwdc24-whats-new-in-swiftui/modifierKeyAlternate.png)

- [modifierKeyAlternate](https://developer.apple.com/documentation/swiftui/view/modifierkeyalternate(_:_:)) でショートカットキーに対する修飾キーを付与できるように
  - その修飾キーを押している間、修飾後のショートカットメニューがUIに自動的に明示される

```swift
Button("Preview Lyrics in Window") {
    // show preview in window
}
.modifierKeyAlternate(.option) {
    Button("Preview Lyrics in Full Screen") {
        // show preview in full screen
    }
}
.keyboardShortcut("p", modifiers: [.shift, .command])
```

### onModifierKeysChanged

- また [onModifierKeysChanged](https://developer.apple.com/documentation/mapkit/mapscaleview/4365411-onmodifierkeyschanged) により修飾キーを押している間にViewを変化させるのを実装しやすくなった

```swift
LyricLine()
    .overlay(alignment: .top) {
        if showBouncingBallAlignment {
            // Show bouncing ball alignment guide
        }
    }
    .onModifierKeysChanged(mask: .option) {
        showBouncingBallAlignment = !$1.isEmpty
    }
```

### pointerStyle

![pointerStyle](/images/wwdc24-whats-new-in-swiftui/pointerStyle.png)

- [pointerStyle](https://developer.apple.com/documentation/swiftui/view/pointerstyle(_:)) でマウスポインタの外観や可視性をカスタマイズできるように

```swift
ForEach(resizeAnchors) { anchor in
    ResizeHandle(anchor: anchor)
         .pointerStyle(.frameResize(position: anchor.position))
}
```

## visionOS

### pushWindow

- 新しい [PushWindowAction](https://developer.apple.com/documentation/swiftui/pushwindowaction) により現在のWindowをバックグラウンドにして新しいWindowで覆うことができる
  - 覆ったWindowは既存の `DismissWindowAction` で閉じる


```swift
struct EditorView: View {
    @Environment(\.pushWindow) private var pushWindow
    
    var body: some View {
        Button("Play", systemImage: "play.fill") {
            pushWindow(id: "lyric-preview")
        }
    }
}
```

### hoverEffect

![hoverEffect](/images/wwdc24-whats-new-in-swiftui/hoverEffect.png)

- これまでvisionOSのホバーエフェクト（視線を合わせた時の挙動）はカスタマイズしづらかったが、 [hoverEffect](https://developer.apple.com/documentation/swiftui/view/hovereffect(_:in:isenabled:)) でカスタムできるようになった
    - ただしプライバシーを守るためユーザーが視線を合わせたタイミングをトラッキングできないのはこれまでどおり

```swift
.hoverEffect { effect, isActive, _ in
    effect.scaleEffect(isActive ? 1.05 : 1.0)
}
```

## iPadOS

### スクイーズ

- [onPencilSqueeze](https://developer.apple.com/documentation/SwiftUI/View/onPencilSqueeze(perform:)) でApple Pencilのスクイーズをハンドリングできる
  - このときユーザーがシステムに設定した期待される動作を [preferredPencilSqueezeAction](https://developer.apple.com/documentation/swiftui/environmentvalues/preferredpencilsqueezeaction) で参照することができる

```swift
@Environment(\.preferredPencilSqueezeAction) var preferredAction
    
var body: some View {
    LyricsEditorView()
        .onPencilSqueeze { phase in
            if preferredAction == .showContextualPalette, case let .ended(value) = phase {
                if let anchorPoint = value.hoverPose?.anchor {
                    lyricDoodlePaletteAnchor = .point(anchorPoint)
                }
                lyricDoodlePalettePresented = true
            }
       }
}
```

## watchOS

### Live Activity

- iOS用のLive Activityは何もしなくてもwatchOSでそのまま動作するように
- [supplementalActivityFamilies](https://developer.apple.com/documentation/SwiftUI/WidgetConfiguration/supplementalActivityFamilies(_:)) でどのサイズのLive Activityをサポートするかを指定できる

### ダブルタップジェスチャー

- [handGestureShortcut](https://developer.apple.com/documentation/SwiftUI/View/handGestureShortcut(_:isEnabled:)) を使うことで、watchOSのダブルタップジェスチャーに対応することができるように
  - 具体的には `.handGestureShortcut(.primaryAction)` を付与する

### 時間や日付の表示形式

![textFormat](/images/wwdc24-whats-new-in-swiftui/textFormat.png)

- [Textの新しいイニシアライザ](https://developer.apple.com/documentation/swiftui/text/init(_:format:)-9d2x4) により、時間や日付の表示がしやすく
  - 具体的には `Text(.currentDate, format: .reference(to: xxx))` などで「あと何分」といった表示がしやすいように
  - その他「-0:58」といった表記や、「00:06.78」のようなタイマー的な表記も指定できる
  - なお、これはLive Activityと相性が良いと紹介されたが、watchOSだけでなくiOS/visionOSなど全てのOSで利用できる機能

### ウィジェットの表示示唆

- [WidgetRelevances](https://developer.apple.com/documentation/widgetkit/widgetrelevances) により、システムがスマートスタックなどにウィジェットを表示することを判断する材料を与えやすくなった

## SwiftUI Framework foundations

### カスタムコンテナ

![customContainer](/images/wwdc24-whats-new-in-swiftui/customContainer.png)

- たとえばコルクボードにメモをランダムに並べるようなカスタムなコンテナを定義できるように
  - 組み込みのListのようなコンテナと同様にForEachで複数の要素を渡す
  - Sectionにも対応
  - カスタムなmodifierも付与できる

### Entryマクロ

- Entryマクロにより、EnvironmentValues、FocusValues、Transaction、ContainerValuesを拡張しやすく


```swift
extension EnvironmentValues {
  @Entry var karaokePartyColor: Color = .purple
}

extension FocusValues {
  @Entry var lyricNote: String? = nil
}

extension Transaction {
  @Entry var animatePartyIcons: Bool = false
}

extension ContainerValues {
  @Entry var displayBoardCardStyle: DisplayBoardCardStyle = .bordered
}
```

### アクセシビリティ

- SwiftUIに組み込まれたアクセシビリティラベルに追加情報を付与できるように

### Xcode Preview

- リビルドせずにPreviewt実行を切り替えられるように
- また `@Previewable` マクロでPreview用のStateを簡単に追加できるようになった

```swift
#Preview {
   @Previewable @State var showAllSongs = true
   Toggle("Show All songs", isOn: $showAllSongs)
}
```

### テキストの選択範囲

- TextFieldのイニシアライザに `selection` が加わり、テキストの選択範囲を取得できるように

```swift
struct LyricView: View {
  @State private var selection: TextSelection?
  
  var body: some View {
    TextField("Line \(line.number)", text: $line.text, selection: $selection)
    // ...
  }
}
```

### searchFocused

- [searchFocused](https://developer.apple.com/documentation/swiftui/view/searchfocused(_:)) により、検索フィールドへのフォーカス移動ができるように

### textInputSuggestions

![textSuggestions](/images/wwdc24-whats-new-in-swiftui/textSuggestions.png)

- macOS専用だが、 [textInputSuggestions](https://developer.apple.com/documentation/swiftui/view/textinputsuggestions(_:)) でテキストフィールドにテキスト補完の候補を出せるように

### 色の混合

![colorMix](/images/wwdc24-whats-new-in-swiftui/colorMix.png)

- Colorに [mix](https://developer.apple.com/documentation/swiftui/color/mix(with:by:in:)) が新設され、色の混合がしやすく


### カスタムシェーダー

- シェーダーをプリコンパイルできるように

```swift
ContentView()
  .task {
    let slimShader = ShaderLibrary.slim()
    try! await slimShader.compile(as: .layerEffect)
  }
```

### ScrollView

- [onScrollGeometryChange](https://developer.apple.com/documentation/swiftui/view/onscrollgeometrychange(for:of:action:)) でスクロール位置による任意のアクションを実装できるように
  - 例えばここまでスクロールしたときだけこのViewが表示されるなど

```swift
ScrollView {
    // ...
  }
  .onScrollGeometryChange(for: Bool.self) { geometry in
    geometry.contentOffset.y < geometry.contentInsets.top
  } action: { wasScrolledToTop, isScrolledToTop in
    withAnimation {
      showBackButton = !isScrolledToTop
    }
  }
```

- [onScrollVisibilityChange](https://developer.apple.com/documentation/mapkit/mapscaleview/4354767-onscrollvisibilitychange) で特定のViewが画面にスクロールイン・スクロールアウトした時のアクションを実装できるように
  - 例えば動画プレイヤーがスクロールインしたら再生を開始し、スクロールアウトしたら停止するなど

```swift
VideoPlayer(player: player)
  .onScrollVisibilityChange(threshold: 0.2) { visible in
    if visible {
      player.play()
    } else {
      player.pause()
    }
  }
```

- [ScrollPosition](https://developer.apple.com/documentation/swiftui/scrollposition) が新しくなり、従来通りの特定のIDを持つViewの指定だけでなく、具体的なオフセットや端なども指定できるように

```swift
struct ContentView: View {
  @State private var position: ScrollPosition =
    .init(idType: Int.self)

  var body: some View {
    ScrollView {
      // ... 
    }
    .scrollPosition($position)
    .overlay {
      FloatingButton("Back to Invitation") {
        position.scrollTo(edge: .top)
      }
    }
  }
}
```

### Swift 6

- Swift 6サポートのためのAPI改善
  - Viewはデフォルトで `@MainActor` に

### UIKit/AppKit連携

- UIGestureRecognizerをSwiftUIで直接利用できるように
- UIKit/AppKitのアニメーションをSwiftUIで直接利用できるように

## visionOS 2

### Volumeベースプレート

- visionOS 2ではVolumeの境界を明示するベースプレートを表示できる
- ベースプレートは `volumeBaseplateVisibility(.hidden)` で隠すことができる

```swift
WindowGroup {
  ContentView()
}
.windowStyle(.volumetric)
.defaultWorldScaling(.trueScale)
.volumeBaseplateVisibility(.hidden)
```

### onVolumeViewpointChange

- [onVolumeViewpointChange](https://developer.apple.com/documentation/swiftui/view/onvolumeviewpointchange(updatestrategy:initial:_:)) でユーザーがどの方向から見ているかを検知して、常にユーザーの方向に向けるなどのアクションをすることができる

```swift
 Model3D(named: "microphone")
  .onVolumeViewpointChange { _, new in
    micRotation = rotateToFace(new)
  }
  .rotation3DEffect(micRotation)
  .animation(.easeInOut, value: micRotation)
```

### 没入度の範囲指定

![immersiveProgerssive](/images/wwdc24-whats-new-in-swiftui/immersiveProgerssive.png)

- ImmersiveStyleに [progressive](https://developer.apple.com/documentation/swiftui/immersionstyle/progressive(_:initialamount:)-7gp0e) が加わり、没入度の範囲指定ができるようになりました

### 新しいSurroundingsEffect

- [preferredSurroundingsEffect](https://developer.apple.com/documentation/swiftui/view/preferredsurroundingseffect(_:)) に [semiDakrやcolorMultiplyやdim](https://developer.apple.com/documentation/swiftui/surroundingseffect) など新しい効果を指定できるようになりました
  - これによりパススルーを好みの暗さにしたりムーディーな雰囲気にできるようになりました
  - これまでは `systemDark` しか指定できませんでした

```swift
struct LoungeView: View {
  var body: some View {
    StageView()
      .preferredSurroundingsEffect(.colorMultiply(.purple))
  }
}
```

### オーナメント

- その他オーナメントにもアップデートがあるよう

### テキストViewの拡張

![textRender](/images/wwdc24-whats-new-in-swiftui/textRender.png)

- [TextRenderer](https://developer.apple.com/documentation/swiftui/textrenderer) でテキストにブラーや色合いの変更など様々なエフェクトがかけられるように


```swift
struct KaraokeRenderer: TextRenderer {
  func draw(
    layout: Text.Layout,
    in context: inout GraphicsContext
  ) {
    for line in layout {
      for run in line {
        var glow = context

        glow.addFilter(.blur(radius: 8))
        glow.addFilter(purpleColorFilter)

        glow.draw(run)
        context.draw(run)
      }
    }
  }
}

struct LyricsView: View {
  var body: some View {
    Text("A Whole View World")
      .textRenderer(KaraokeRenderer())
  }
}
```

-----

まとめは以上です。
盛りだくさんすぎてびっくりでした。

