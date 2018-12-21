---
title: "Vimで技術書を執筆する環境 with Re:VIEW + RedPen + prh"
date: 2018-12-21T10:14:52+09:00
draft: false
tags: [vim,review]
authors: [tokorom]
---

本記事は [Vim その2 アドベントカレンダー](https://qiita.com/advent-calendar/2018/vim2) 21日目の記事です。

## 経緯

今年の8月頃から [PEAKS](https://peaks.cc/) の [iOS 12 Programming](https://peaks.cc/tokorom/iOS12) という技術書の執筆に参加しました。
このとき初めて [Re:VIEW](https://github.com/kmuto/review) による執筆をしました。

現在は技術書展も賑わっており、Re:VIEWで執筆する機会は以前より多くなっているかと思います。
一方で、VimでRe:VIEWを取り扱う環境が意外と整っておらず[^old]、2018年時点の情報を整理させていただきます。

以下、

- **シンタックス・ハイライト**
- **リアルタイムプレビュー**
- **校正サポート**
- **コード・スニペット**

の順に整理いたします。

## シンタックス・ハイライト

![syntax-highlight-sample](https://raw.githubusercontent.com/tokorom/vim-review/images/sample.png)

Re:VIEWのシンタックス・ハイライト用のpluginはいくつか見つかったものの、最新のRe:VIEW 2.0にきっちり対応されているものが見つかりませんでした。
Re:VIEW 2.0のフォーマットガイドはこちらです > https://github.com/kmuto/review/blob/v2-stable/doc/format.ja.md

そのため、Re:VIEW 2.0に一通り対応したものを作って利用しました。

- https://github.com/tokorom/vim-review

このついでに、Re:VIEW内に埋め込んだソースコードのハイライトにも対応させています。
例えば、私の今回の執筆ではSwiftコードを使っていますので、その場合は、

```vim
let g:vim_review#include_filetypes = ['swift']
```

と、既存のfiletypeである**swift**を**g:vim_review#include_filetypes**に指定してあげるだけです。
これで、

![inline-highlight](https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/vim-review/inline-highlight.png)

と、文章内に埋め込まれたソースコードもきっちりハイライトされます。

これが発火する条件は、

- Re:VIEWのブロック命令として`list`、`listnum`、`emlist`、`emlistnum`のいずれかを利用し、言語指定として設定済みの**filetype**を指定していること

です。

## リアリタイムプレビュー

![livereload](https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/vim-review/livereload.png)

[Re:Viewのリアルタイムプレビューをgulp/gruntのlivereloadを使わずにbrowser-syncとfswatchだけでやる](http://kazuph.hateblo.jp/entry/2016/05/15/142352) を真似させていただきました。

- **fswatch**
- **browser-sync**

を利用します。
こちらはVimで、というよりはシンプルにファイルの変更を監視してhtmlを出力＆プレビューするだけです。

- fswatchでreファイルの変更を監視して変更があればhtmlを出力
- そのhtmlをbrowser-syncでブラウザでライブリロード

という手順です。

### 事前準備

```sh
brew install fswatch
npm install -g browser-sync
```

### browser-syncの起動

```sh
cd articles
browser-sync start --server --files *.html 
```

で、Chromeなどデフォルトのブラウザが起動します。
起動したらブラウザのURLに `http://localhost:3000/10.html` などプレビューしたいhtmlのURLを入力して開きます。

### 変更監視の開始

以下は、PEAKSでの執筆環境におけるものです。

```sh
cd articles
fswatch 10.re | xargs -n1 -I{} bundle exec review-compile --target=html && browser-sync reload
```

執筆環境ごとにRe:VIEWのreファイルからhtmlを出力するコマンドがあると思いますので、reの変更を検知したらそのコマンドを叩き、最後に`browser-sync reload`を呼びます。

これで、リアリタイムプレビュー完成です！

## 校正サポート

執筆時に校正用のサポートツールを使うことも多くあるかと思います。
たとえばPEAKSのiOS 12 Programmingの執筆では、

- [RedPen](https://github.com/redpen-cc/redpen)
- [prh](https://github.com/prh/prh)

の２つが使われていました。
以下、その２つをVimで利用するための情報を整理します。

### RedPen

RedPenは元よりRe:VIEWフォーマットを考慮して校正をかけてくれるツールです。
そのためなにも考えずにそのまま利用できます。

具体的には、非同期にツールを走らせてくれる

- [ale](https://github.com/w0rp/ale)

pluginを入れれば、デフォルトでRedPenによる検査が走ります。

なお、2018年12月21日時点では、RedPenのリリース版に一部含まれていない修正があります。
具体的には [このPull Request](https://github.com/redpen-cc/redpen/pull/844) で、ラベル付きの見出しを使う場合の修正が入っています[^redpen-pull-req]。ラベル付きの見出しを利用する場合はこれがマージ済みのmasterなどを利用するほうが良さそうです。


### prh

prhはそのままでも検査は走らせられるものの、Re:VIEWフォーマットをふまえずに検査が走ってしまうため少し対処が必要でした。

具体的には、prhでのチェックが本文中だけでなく、コメントアウトした文中やソースコードブロック内にも及んでしまうため、それを回避する必要があります。

これに対処するための方法が見つからなかったため、aleで利用できるRe:VIEWフォーマットを考慮してprhを実行してくれるpluginを作成しました。

- [ale-prh-review](https://github.com/tokorom/ale-prh-review)

なお、現在、ale-prh-reviewで加味しているのは、

- `#@# ` から始まるコメント行は無視
- 以下のブロック命令の中身を無視
    - `list`
    - `listnum`
    - `emlist`
    - `emlistnum`
    - `image`
    - `cmd`
- 以下のインライン命令の中身を無視
    - `@<code>`
    - `@<fn>`
    - `@<img>`
    - `@<list>`

という部分です。

### 両方とも利用する設定

aleでRedPenとprhを両方とも走らせたい場合は、

- ale
- ale-prh-review

を入れたうえで、

```vim
let g:ale_fixers = {
\   'review': ['redpen', 'prhreview'],
\}
```

と、設定します。

これにより、執筆中にRedPenとprhによる検査が入り、例えば、

![prh](https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/vim-review/prh.png)

のように指摘してくれます。この例では「良い」を「よい」と平仮名表記にすることを示唆してくれています。

## コード・スニペット

これはなくてもよいと思いますが、お好みのコード・スニペットpluginをRe:VIEWにも対応させておくと便利です。
例えば、`emlist`によりソースコードを埋め込みたいときに、

![snippet1](https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/vim-review/snippet1.png)

と入力して展開すれば、

![snippet2](https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/vim-review/snippet2.png)

と`emlist`ブロック命令が展開される、など便利に利用できます。

多くの場合、これらのスニペットがコード補完pluginにも連携できるため、Re:VIEWのフォーマットや命令文を漠然としか覚えていなくても、これらのスニペット名が補完されることによって利用できるというメリットもあります。

コード・スニペット用pluginですが、私は

- [UltiSnips](https://github.com/SirVer/ultisnips)

を使っています。

ほとんどのRe:VIEW 2.0の命令をサポートしたUltiSnips用のsnippetsファイルを

- https://github.com/tokorom/dotfiles/blob/master/.vim/snippets/usnippets/review.snippets

に置いてありますので、UltiSnipsをご利用のかたは是非ご流用ください。

なおRe:VIEWで日本語文章を書いている時のsnippetsの展開は、

```
日本語を書いている途中tt<here!!>
```

と日本語文中で展開する必要があります。

UltiSnipsはsnippetを定義するときに `w` （word boundary）というオプション指定ができるため、これを付加して定義したsnippetなら問題なく展開できます（上のsnippetsファイルは対処済み）。

neosnippetはそのままだとこれに対処できませんので少し改造が必要です[^neosnippet]。

## 成果物

実際にこれらを利用してVimで執筆した技術書が、

<div class="peaks_widget" style="overflow:hidden; padding:20px; border:2px solid #ccc;"><div class="peaks_widget__image" style="float:left; margin-right:15px; line-height:0;"><a target="_blank" id="purchase" href="https://peaks.cc/tokorom/iOS12"><img alt="iOS 12 Programming" style="border:none; max-width:140px;" src="https://s3-ap-northeast-1.amazonaws.com/peaks-images/project007_cover.jpg"></a></div><div class="peaks_widget__info"><p style="margin:0 0 3px 0; font-size:110%; font-weight:bold;"><a target="_blank" id="purchase" href="http://peaks.cc/tokorom/iOS12">iOS 12 Programming</a></p><ul style="margin:0; padding:0;">
<li style="font-size:90%; list-style:none;"><span>著者：</span>
<span>加藤 尋樹,</span><span>佐藤 紘一,</span><span>石川 洋資,</span><span>堤 修一,</span><span>吉田 悠一,</span><span>池田 翔,</span><span>佐藤剛士,</span><span>大榎一司,</span><span>所 友太,</span></li>
<li style="font-size:90%; list-style:none;">製本版,電子版</li>
<li style="font-size:90%; list-style:none;"><a target="_blank" id="purchase" style="text-decoration:underline; color:#1DA1F2;" href="http://peaks.cc/tokorom/iOS12">PEAKSで購入する</a></li></ul></div></div>


です。私はこの中の10章「tvOS 12の新機能」の執筆を担当しました。

Vim + Re:VIEWで執筆をしている皆様、ぜひ、[Twitter](https://twitter.com/tokorom) などで情報交換お願い致します。

[^old]: 見つかったのは4年前くらいの情報やpluginでした
[^redpen-pull-req]: 私が執筆中に困り、Pull Requestしました
[^neosnippet]: 改造の例がこちらです https://github.com/tokorom/neosnippet.vim/tree/improve-cur-word

