---
layout: post
title: "tmuxでC-t C-tでのサイクルをより便利にする : 同じキーでpaneでもwindowでも行き来できるようにしてみた"
date: 2013-01-17
comments: true
external-url: 
tags: [cui, mac]
aliases: [/2013/01/17/tmux-toggle/]
authors: [tokorom]
---

** ※tmuxのprefixキーが C-t 以外のかたはそのキーに読み替えをお願いします **

## 導入

[近頃の開発環境 : Mosh、z、tmux、Emacs、Perl について](http://d.hatena.ne.jp/naoya/20130108/1357630895) を読んで自分もC-t C-tでtmuxのペイン（pane）を行ったり来たりというのを真似してみた。

設定は以下のとおり。

* .tmux.conf

```sh
bind C-t last-pane
```

これでpaneが複数ある場合には C-t を連打するだけで２つのpaneを行ったり来たりでき確かに便利。

ただ、じつはこの真似をする前には C-t C-t には `last-window` を割り当てており、paneを使っていないケースではそれはそれで便利だった。

例えば、設定を変えたことによって、paneなしで２つのwindowで作業しているときに C-t C-t で２つのwindow行き来しようと思ったらエラーとなりけっこうストレスがあったりした（慣れれば大丈夫なんでしょうけど）。

## 改善

ということで、

* paneがあれば `last-pane`
* paneがなければ `last-window`
* ついでにwindowさえもなければ新しいwindowを作って移動

<!-- more -->

というのができれば最強なんじゃないかと思った。  
そんなんできるんかいな？と思ったけどごくごく普通にできた。

設定は以下のとおり。

* .tmux.conf

```sh
bind C-t run "tmux last-pane || tmux last-window || tmux new-window"
```

`run`はshを叩くことを意味し、`last-pane`と`last-window`と`new-window`を`||`で連結させている。  
これで、`last-pane`から順番に試していき、成功したところで終わるという挙動になる。

便利便利！
