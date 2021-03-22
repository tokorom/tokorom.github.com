---
title: "[Vim] ぼくのかんがえたさいきょうのFuzzy Finder"
date: 2021-03-22T21:35:20+09:00
draft: false
authors: [tokorom]
tags: [Vim]
images: [/images/vim-fuzzy-finder/top.png]
canonical: https://spinners.work
---

![image](/images/vim-fuzzy-finder/top.png)

## 導入

みなさんはVimでどんなFuzzy Finderを使っているでしょうか？
ぼくは先日まで`fzf` + [fzf.vim](https://github.com/junegunn/fzf.vim) を使っていました。

しかし少し調子が悪い部分が出てきたのをきっかけにそろそろ他にもっと良いFuzzy Finderが出てきてないかな？と探し始めました。
結果として「ぼくのかんがえたさいきょうのFuzzy Finder」に行き着いたのです！

## 着想

fzf.vimに代わるものを探している過程で [fzy](https://github.com/jhawthorn/fzy) を見つけました。

このREADMEを読んでいたら、なんと、

```vim
function! FzyCommand(choice_command, vim_command)
  try
    let output = system(a:choice_command . " | fzy ")
  catch /Vim:Interrupt/
    " Swallow errors from ^C, allow redraw! below
  endtry
  redraw!
  if v:shell_error == 0 && !empty(output)
    exec a:vim_command . ' ' . output
  endif
endfunction

nnoremap <leader>e :call FzyCommand("find . -type f", ":e")<cr>
```

のようにpluginもなしに10行程度のfunctionを定義して使うだけでVim上でfzyによるFuzzy Finderが実現できると書いてあります。

「そんなバカな！？」と疑いつつ試してみると、実際に実現できてしまいました。

pluginのメンテもいらずこんなにシンプルに実現できるなんて！これが最強のFuzzy Finderの実現方法では！と驚きこれをこのまま使おうと思ったのですが、`fzf`の気に入っていた部分が`fzy`では再現できず[^fzf]、それならばと上のfunction内の`fzy`部分を`fzf`に置き換えて利用しようとしました。

[^fzf]: 具体的にはスペース区切りで複数の条件で絞り込む機能です

しかし、これは`fzy`の設計だからこそなせる技で、この仕組みをそのまま`fzf`では使えないということがわかりました。

そしてなんとか`fzf`や他のコマンドでもVim上でシンプルなFuzzy Finderを実現する方法はないのか？と探ってみたのが「ぼくのかんがえたさいきょうのFuzzy Finder」につながりました。

## terminalコマンド

Vim上から外部コマンドを叩く方法はいくつかありますが、今回はVimの [terminal](https://vim-jp.org/vimdoc-ja/terminal.html) 機能に着目しました。

例えば、Vim上で

```
:terminal zsh -c "find . -type f \| fzf" 
```

というコマンドを打てば、Vimの上部に現在のディレクトリ以下のファイルを`fzf`で絞り込むwindowが表示できます。

![image](/images/vim-fuzzy-finder/terminal_sample.png)

見た目にはほぼこれでFuzzy Finderできてしまっています。

しかし、もちろんこれだけだとファイル名を絞り込んだ後にその絞り込んだ結果がwindowに残るだけでそのファイルの内容が表示されたりはしません。

逆に言えば、この状態から、

- terminalのwindowを閉じる
- windowに残っていた行からファイルを開いてVim上に表示する

とするだけで、terminal機能を使ったシンプルなFuzzy Finderが実現できそうです。本当にシンプルな仕組みですので、`fzf`でなくとも、

- shellコマンドで候補リストを表示して選択する
- 選択後に選択した候補だけがwindowに残る

という条件さえ揃っていれば他のどんなshellコマンドでもこの仕組みを使えそうです。
すごい！

## シンプルなコマンド作成

[terminalの日本語ドキュメント](https://vim-jp.org/vimdoc-ja/terminal.html) を読みながら、どうやったらこれを実現できるだろうと調べました。
結果、

- AAA
- BBB

...


## より高機能に

## 完成！

## おまけ

pluginなしでというコンセプトで進めましたが、`vimrc`に上のコマンドさえも定義せずにぱぱっとpluginをインストールして使いたいというかた向けに、上の100行のコマンドをそのままplugin化したものも用意しました。

必要でしたら是非お試しください！

