---
title: "VimでMarkdown形式でブログ記事を書くときに簡単に画像を埋め込む方法"
date: 2020-03-31T16:38:32+09:00
draft: false
tags: [vim,markdown,hugo]
cover: "/images/posts/vim-markdown-image-tool/dog.jpg"
---

*Photo by Victor Grabarczyk on Unsplash*

## ブログ記事書くとき画像を埋め込むのが面倒

こういったブログ記事は、皆さんどういう執筆環境で書いているでしょうか？

最近だと**Hugoなどの静的サイトジェネレータ**を利用することも多いのではないでしょうか。
この記事もHugoで運用しています。

記事を投稿するときは、いつも**VimでさらっとMarkdown形式で**書き上げ、ぱぱっとデプロイコマンドを打つだけで簡単便利な環境なのですが、唯一、**記事に画像を埋め込むのだけが面倒**だと感じてます。

特に、いわゆるブログサービスを利用している場合には、記事作成ページに埋め込みたい画像をドラッグ＆ドロップするだけで画像をアップロード＆埋め込みできてしまうので、それとの比較で面倒さが際立ちます。

## 手動での画像埋め込み手順

これまで手動で画像を埋め込む際には、このブログ記事の場合だと、

- 各記事用の画像ディレクトリとして `content/images/記事名` ディレクトリを作成
- 埋め込みたい画像を `content/images/記事名` 以下にコピー
- 記事内に `![image](/images/記事名/画像名)` を埋め込む
- 必要に応じてImageOptimなどで画像の最適化

をしていました。

決して難しいことはありませんが地味に面倒でした。

## ドラッグ＆ドロップでなんとかならない？

結論として、私の執筆環境である「Terminal + Vim」ではドラッグ＆ドロップをうまくハンドリングする方法がわからず、ドラッグ＆ドロップだけでなんとかはなっていません。

ただ、TerminalのVim上に画像ファイルをドラッグ＆ドロップすると、その画像ファイルの絶対パスがVimに埋め込まれますので、その行でワンコマンドかますだけでなんとかなりそうだなと思い、Vim用のpluginを作りました。

具体的には、デスクトップ上の`dog.jpg`をドラッグ＆ドロップすると、Vim上に

```
/Users/tokorom/Desktop/dog.jpg 
```

が埋め込まれますので、この行でコマンドを打ち、あとは必要なことを自動でやってくれる、という方式です。

## 現在行のファイルパスに対してなにかをするplugin

このファイルパスに対してなにをしたいかは執筆環境により異なりますので、pluginに追加したのは、

```vim
function vim_replace_current_line#execute()
  let line = getline('.')
  let result = system(g:vim_replace_current_line#command . ' ' . expand('%') . ' ' . expand('%:t:r') . ' ' . trim(line))
  call setline('.', trim(result))
endfunction
```

という３行のシンプルなfunction１つだけです。

ここでやっているのは、 

- **特定のコマンド**を実行し
- その引数として「編集中のファイル名」「ファイル名の拡張子を抜いた部分（記事名を想定）」「現在行（画像ファイルのパスを想定）」の３つを渡す
- コマンドの実行結果で現在行を置き換え

ということだけです。

つまり、あとはその**特定のコマンド**で、執筆環境ごとに必要な処理を実行し、最終的に画像を埋め込むための文字列を出力してやるだけです。

ごくごく簡単なpluginですが、必要でしたら[Githubに置いてあるもの](https://github.com/tokorom/vim-replace-current-line)をご利用ください。

## コマンドの実装

今回の執筆環境で行いたいのは、

- 各記事用の画像ディレクトリとして `content/images/記事名` ディレクトリを作成
- 埋め込みたい画像を `content/images/記事名` 以下にコピー
- 記事内に `![image](/images/記事名/画像名)` を埋め込む

という手順なので、以下のコマンドを書きました。

```sh
#! /bin/sh

SOURCE="$3"
IMAGEDIR="content/images/$2"
IMAGEFILENAME=`basename ${SOURCE}`
TARGET="${IMAGEDIR}/${IMAGEFILENAME}"
IMAGETAG="![image](/images/$2/${IMAGEFILENAME})"

mkdir -p ${IMAGEDIR}
cp "${SOURCE}" "${TARGET}"

echo "${IMAGETAG}"
```

とても簡単なコマンドです。

このコマンドが実行されることで、画像が決められたディレクトリにコピーされ、Vim上の画像パスの行が

```
![image](/images/vim-markdown-image-tool/dog.jpg)
```

といったMarkdown用の画像埋め込み構文に自動的に変換されます。

## ついでに画像の最適化も

ImageOptimをご利用なら上のコマンドの最後に

```sh
IMAGEOPTIM="open -a ImageOptim"
`${IMAGEOPTIM} ${TARGET}`
```

を加えるだけで、画像の最適化も非同期に行ってくれます。

## 完成

この環境を一度作れば、あとは、

- Vim上に画像をドラッグ＆ドロップ
- コマンドを１つ実行

という２ステップだけで、記事内への画像の埋め込みが簡単便利にできるようになります！

## 次のステップ

これですでにある画像をドラッグ＆ドロップで埋め込むことは簡単になりました。

あとは、例えばiPhoneでスクショを撮影し、MacのVim上で１コマンド打ったらそのスクショが埋め込まれる、といったこともできればなあ（やればできそう）。

