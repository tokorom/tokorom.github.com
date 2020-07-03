---
title: "Human Interface GuidelinesのWidgetsの章の日本語訳"
date: 2020-07-02T17:32:57+09:00
draft: false
authors: [tokorom]
tags: [iOS,WWDC,Widgets,Swift,HIG,iOS14]
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

## Widgetsの詳細

Widgetには小、中、大の３つのサイズがあります。
iPhone、iPad、Macのどのプラットフォームでも、ユーザーはWidgetギャラリーからWidgetを見つけ、お好みのサイズを選べます。
また、ユーザーは後からWidgetを好きな場所に移動させたり、WidgetごとにWidgetが用意したパラメータを設定することができます。
例えば、ホーム画面に小さなお天気Widgetをいくつか設置して、それぞれのWidgetに別々の場所の天気を表示する、など。
Widgetは、iPhoneならホーム画面やTodayビュー、iPadならTodayビュー、macOSなら通知センターに設置できます。


iPhoneとiPadではWidgetギャラリーの中にスマートスタックがあります。
スマートスタックにはユーザーがよく使うアプリのWidgetがデフォルトで含まれています（後から変更もできます）。
スマートスタックはiPhoneのホーム画面と、iPhone/iPadのTodayビューに設置できます。
スマートスタックは時間とともにだんだんと賢くなり、Siriが自動で現在の状況に適したWidgetを一番上に表示してくれます。
また、ユーザーが自分で作ったWidgetのスタックでも、スタックの設定からスマート回転（Smart Rotate）をOnにすれば、Siriによる最適なWidgetの自動表示が有効になります。

-----

**NOTE**

iOS 13以前のiOS用に作られた古いWidgetはホーム画面では利用できませんが、Todayビューの下部やmacOSの通知センターでは引き続き利用できます。

-----------

## 使いやすく焦点を絞ったWidgetの作成

Widgetをタップすることでアプリ本体を開きアプリ内でより多くのことをできますが、Widgetの主な目的はユーザーがアプリ本体を開かなくてもタイムリーにユーザーごとにパーソナライズされた少量の情報を表示することです。
Widgetで実現すべき1つのアイデアを特定し、表示する情報の焦点を絞ることが、Widgtetのデザインプロセスにおける重要な最初のステップです。

**Widgetで実現するアイデアは1つに集中させてください。**
ほとんどの場合はアプリのメインアイデアをWidgetに適用できるでしょう。
例えば、天気アプリでは特定の場所の天気を表示し、カロリートラッキングアプリではその日の消費カロリーを表示し、ニュースアプリではトレンドを表示するなどが考えられます。
また、ゲームアプリでキャラクターのステータスを表示したり、お絵かきアプリでお気に入りのスケッチを表示したりと、アプリのメインアイデアの1つの部分に焦点を当てるのも効果的です。

![image](/images/hig-widgets/focused-widget.png)

**どのサイズのWidgetでも、Widgetのアイデアに直接関係する情報のみを表示してください。**
大きなWidgetでは、より多くのデータを表示したり、より詳細な情報を表示することができますが、Widgetのアイデアに集中することが重要です。

例えば天気アプリの場合、小サイズのWidgetには現在の気温と天気、その日の最高気温と最低気温を表示します。

![image](/images/hig-widgets/weather-small.png)

中サイズのWidgetには小サイズと同じ情報に加えて6時間分の時間ごとの予報も表示します。

![image](/images/hig-widgets/weather-medium.png)

大サイズのWidgetには6時間分の予報に加え、5日後までの予報も表示します。

![image](/images/hig-widgets/weather-large.png)

**アプリ本体を起動するだけのWidgetは避けましょう。**
ユーザーがWidgetを評価するのは、意味のあるコンテンツにすぐにアクセスできるからであって、アプリを開くためのショートカットになるからではありません。

**Widgetを複数のサイズで提供することで付加価値が得られる場合は、複数のサイズを提供しましょう。**
小さいWidgetのコンテンツを拡大してエリアを埋めただけの大きなWidgetを作るのは避けましょう。すべてのサイズのWidgetを提供することよりも、あなたのアイデアを完璧に表現できる１つのサイズのWidgetを作成することのほうが重要です。

**1日を通してダイナミックに変化することが期待されます。**
Widgetの表示に変化がなければ、ユーザーはWidgetを目立つ位置に置き続けようとは思わないでしょう。
Widgetは分刻みで更新されるわけではありませんが、頻繁に見てもらうWidgetにするためにはコンテンツの鮮度を保つことが重要です。


**驚きと喜びを与えてください。**
例えばカレンダーWidgetなら、誕生日や祝日に特別な表示をすることができそうです。

![image](/images/hig-widgets/birthday-in-calendar.png)

## Widgetの設定とインタラクティブ性

**Widgetに設定すべき項目がある場合は設定可能なWidgetにしましょう。**
多くの場合、Widgetに有用なコンテンツを表示するためには、ユーザーが見たい情報をあらかじめ指定する必要があります。
例えば、天気Widgetでは場所を選択したり、株価Widgetでは表示する株価を選択したりする必要があります。
一方で、ポッドキャストWidgetなら、最近のコンテンツを表示するようにあらかじめ設定されているので、カスタマイズする必要はありません。
設定可能なWidgetを作成する場合は、あまり多くの設定を要求したり、複雑な情報を要求したりすることは避けてください。
Widgetの設定画面はOSが自動的に生成してくれるので設定画面を自分で作る必要はありません。
より詳細な開発者向けのガイドが欲しい場合は [設定可能なWidgetを作成する](https://developer.apple.com/documentation/widgetkit/making-a-configurable-widget) を参照してください。

**Widgetをタップしたときに、アプリの適切な画面を開くようにしましょう。**
ユーザーがWidgetをタップすると、Widgetはアプリ本体にDeep Linkし、Widgetのコンテンツに直接関連する詳細情報やアクションを提供することができます。
例えば、ユーザーが特定の株価を表示しているWidgetをタップすると、株価アプリのその株価の詳細な情報を表示する画面を開きます。
また、ウォッチリストの一部を表示しているWidgetをタップすると、アプリが開いて全てのウォッチリストを確認できます。

**タップ領域をたくさん作りすぎるのは避けましょう。**
小サイズのWidgetには１つのタップ領域しか持たせられませんが、中サイズと大サイズのWidgetには複数のタップ領域を作れます。
例えば、中サイズのノートWidgetに複数のノートを表示し、各ノートに別々のタップ領域を作り、タップしたほうのノートをアプリで開くなどできます。

![image](/images/hig-widgets/multiple-tap-targets.png)

複数のタップ領域を提供することはコンテンツにとって意味のあることかもしれませんが、ユーザーがタップしたいコンテンツをタップするのに苦労するほど細かく領域を分けることは避けましょう。

**ログインすることで付加価値が得られる場合は、それをユーザーに知らせましょう。**
アプリにログインするとWidgetにより良い情報が表示される場合は、ユーザーにそのことを知らせるようにします。
例えば、直近の予約を表示するアプリなら、ログインしていないユーザーに対して「直近の予約を表示するためにログインしてください」と表示するなど。



