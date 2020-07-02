---
title: "Human Interface GuidelinesのWidgetsの章の日本語訳"
date: 2020-07-02T17:32:57+09:00
draft: false
authors: [tokorom]
tags: [iOS,WWDC,Widgets,Swift,HIG]
images: [/images/hig-widgets/top.png]
canonical: https://spinners.work
---

![image](/images/hig-widgets/top.png)

WWDC20でiOS 14の新機能として発表されたWidgetsについて勉強するため、Human Interface Guidelines (HIG) の [Widgetsの章](https://developer.apple.com/design/human-interface-guidelines/ios/system-capabilities/widgets) を日本語訳します。

日本語で理解しやすいよう、ぼくの感性で意訳しちゃう部分もありますのでご了承ください。

2020年7月2日時点のものです。

# Widgets

Widgetにより、アプリの重要なコンテンツをiPhone、iPad、Mac上の一目で分かる場所に表示できます。
Widgetは便利で楽しく、iPhoneのホーム画面をユーザーごとにパーソナライズするのにも役立ちます。

![image](/images/hig-widgets/screen1.png)

Widgetは、iOS 14以降と macOS 11以降で利用できます。
[Widget Extensionを作成する](https://developer.apple.com/documentation/widgetkit/creating-a-widget-extension) という開発者向けのガイド記事があります。

# Widgetsの詳細

Widgetには小、中、大の３つのサイズがあります。
iPhone、iPad、Macのどのプラットフォームでも、ユーザーはWidgetギャラリーからWidgetを見つけ、お好みのサイズを選べます。
また、ユーザーは後からWidgetを好きな場所に移動させたり、WidgetごとにWidgetが用意したパラメータを設定することができます。
例えば、ホーム画面に小さなお天気Widgetをいくつか設置して、それぞれのWidgetに別々の場所の天気を表示する、など。
Widgetは、iPhoneならホーム画面やTodayビュー、iPadならTodayビュー、macOSなら通知センターに設置できます。


iPhoneとiPadではWidgetギャラリーの中にスマートスタックがあります。
スマートスタックにはユーザーがよく使うアプリのWidgetがデフォルトで含まれています（後から変更もできます）。
スマートスタックはiPhoneのホーム画面と、iPhone/iPadのTodayビューに設置できます。
スマートスタックは時間とともにだんだんと賢くなり、Siriが自動で現在の状況に適したWidgetを一番上に表示してくれます。
また、ユーザーが自分でWidgetをスタックした場合でも、スマート回転（Smart Rotate）という設定をOnにすればSiriによる最適なWidgetの自動表示が使えます。


- NOTE

```
iOS 13以前のiOS用に作られた古いWidgetはホーム画面では利用できませんが、Todayビューの下部やmacOSの通知センターでは引き続き利用できます。
```



