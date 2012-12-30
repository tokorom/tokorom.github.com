---
layout: post
title: "Mac + Terminal + tmux + vim でクリップボードを快適に使う"
date: 2012-12-31 04:47
comments: true
external-url: 
categories: [mac, vim, cui]
---

Macの初期設定のたびに混乱してるので再整理しておきます。

* Mac
* Terminal
* tmux
* vim

で開発をする人向けです。

## まずはMacVim KaoriYa

MacでVimを使うならひとまず [MacVim KaoriYa](http://code.google.com/p/macvim-kaoriya/) は外せません。  
日本語を扱う上で便利な設定がデフォルトで入ってます。

当然、Terminalでも **Macvim KaoriYa** を使いたいので、 **.zshenv** などに以下のaliasを設定してCUIで **vi** や **vim** を叩いたときにも **MacVim KaoriYa** が使われるようにします。

```sh
if [ -f /Applications/MacVim.app/Contents/MacOS/Vim ]; then
  alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
  alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
fi
```

## tmux でも pbcopy/pbpaste が使えるようにする

<!-- more -->

Macの **tmux** では **pbcopy/pbpaste** コマンドが正常に動作しないということなので、

* [こせきの技術日記](http://d.hatena.ne.jp/koseki2/20110816/TmuxCopy)

に従って対処しておきます。

この中の、

```sh
date | pbcopy
```

までが成功すればOKです。


## .vimrc にクリップボード利用の設定追加

**.vimrc** に

```sh
set clipboard=unnamed
```

を追加しておきます。

## fakeclip の導入

* [fakeclip](https://github.com/kana/vim-fakeclip)

をVimに追加することで、 **tmux** や **screen** を使っていてもVimのヤンク(y)やペースト(p)のときにクリップボード(正確には **pbcopy/pbpaste** )が使われるようになります。

Vundlerを使っているなら .vimrc に

```sh
Bundle 'git://github.com/kana/vim-fakeclip.git'
```

を追加するだけです。

## 完了!

これで晴れて、

* ブラウザからコピーしてきた文章をVimに **p** でペースト!
* Vimで **yy** でコピーした行をメールにペースト!

などが気軽にできるようになります。

