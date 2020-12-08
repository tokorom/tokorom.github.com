---
title: "Vimにスクショを直接Markdownで貼り付ける"
date: 2020-04-30T18:01:01+09:00
draft: false
authors: [tokorom]
tags: [vim,markdown,hugo]
images: [/images/vim-markdown-paste-from-clipboard/cover.png]
---

![top](/images/vim-markdown-paste-from-clipboard/cover.png)
*Photo by Jae Park on Unsplash*

## 前回

[前回の記事](/posts/vim-markdown-image-tool/)では、画像ファイルをVimにドラッグ＆ドロップして、それをコマンド一発で、

- ImageOptimで画像を最適化
- 記事ごとの画像ディレクトリを自動作成してそこに画像をコピー
- Vimに `![image](/images/記事名/画像名)` とMarkdown方式で埋め込む

という便利環境を作りました。

そのときの課題として「どうせなら既存画像だけじゃなくてスクショもコマンド一発でVimにMarkdown形式で貼り付けたいなあ」というのがありました。

今回はそこを解決します！

## pbpasteはダメだった

なんとなく`pbpaste`コマンドでゴニョゴニョするんだろうな思っていたのですが、`pbpaste`はテキストしか扱えないということがわかりました...

## screencaptureコマンドを使う

しかしMacには`screencapture`というコマンドがあり、

```sh
screencapture -i 出力ファイル名
```

とすると、`shift` + `command` + `4` で起動するインタラクティブなスクショモードを開始し、撮影後のスクショを指定したファイル名で保存してくれる、ということがわかりました。

## vim pluginを拡張

前回、特定のコマンドを実行して、Vimの現在行を置き換えるpluginを作って使ったのですが、今回から、

- 現在行の画像ファイル名を使って画像を適切に埋め込むコマンド
- スクショを撮影して現在行に埋め込むコマンド

の２つを使い分ける必要が出てきました。

そのため、前回のpluginを少し拡張して、

```
command! -nargs=0 MarkdownImageFromLine :call vim_replace_current_line#execute("./.vim-replace-current-line/markdown-image-from-line")
command! -nargs=0 MarkdownImageWithScreenshot :call vim_replace_current_line#execute("./.vim-replace-current-line/markdown-image-with-screenshot")
```

とvimrcで好きなコマンド名でそれぞれ別のコマンドを叩けるようにしました。

今回のものは`:MarkdownImageWithScreenshot`というコマンドをVim上で叩くと、`markdown-image-with-screenshot`というシェルコマンドを実行し、そのレスポンスを現在行に埋め込む、という形です。

仕組み自体は前回と変わりません。

このpluginは [GitHub](https://github.com/tokorom/vim-replace-current-line/releases/tag/2.0.0) に置いてあります。

## スクショを撮影して...のコマンド

`markdown-image-with-screenshot`コマンドの具体的な中身は、

```sh
#! /bin/sh

IMAGEDIR="content/images/$2"
CURRENTTIME=`date +%s`
IMAGEFILENAME="ss-${CURRENTTIME}.png"
TARGET="${IMAGEDIR}/${IMAGEFILENAME}"
IMAGETAG="![image](/images/$2/${IMAGEFILENAME})"

mkdir -p ${IMAGEDIR}

screencapture -i "${TARGET}"

echo "${IMAGETAG}"

IMAGEOPTIM="open -a ImageOptim"
`${IMAGEOPTIM} ${TARGET}`
```

です。

ほぼ前回と変わりませんが、指定された画像をcopyする代わりに`screencapture -i "${TARGET}"`でインタラクティブなスクショ撮影を開始しています。

最後にImageOptimで画像を最適化しているのも同じです。

## 完成

これで、Vim上で

```
:MarkdownImageWithScreenshot
```

とコマンドを実行すると、

- インタラクティブなスクショ撮影が開始
- 撮影が終わったら、記事ごとのディレクトリを作って、スクショを保存
- 保存したスクショはImageOptimで最適化
- 保存したスクショをMarkdown形式でVimの現在行に埋め込み

という一連の作業を自動でやってくれるようになりました！

試しに執筆中のこの記事にもスクショを埋め込んでみます。

![image](/images/vim-markdown-paste-from-clipboard/ss-1588238897.png)

できた！

超絶便利！！！

## 次のステップ

iPhoneで撮影したスクショを貼り付け、となるとクリップボードから貼り付ける必要があるが、なんとかなるかな？



