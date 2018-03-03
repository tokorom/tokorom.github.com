---
layout: post
title: "Xcodeのプロジェクトファイル（pbxproj）がコンフリクトしまくるのをなんとかしたい！"
date: 2014-02-06
comments: true
external-url: 
tags: [xcode,ios]
aliases: [/2014/02/06/pbxproj-merge/]
---

**2014/02/09 追記**  
コメントのところでやり取りしているようにmergepbxの作者さんから連絡があって、この記事で書いた問題が修正されました！  
今現在は `merge=mergepbx` がいい感じになってきているのでそっちがオススメです。


## 複数人でプログラミングしているとpbxprojがやたらとコンフリクトする

例えば、

- Aさんが `AALabel.m` をプロジェクトに追加して
- Bさんが `BBLabel.m` をプロジェクトに追加して

とただそれだけなのにマージのときにコンフリクトする`pbxproj`さん。。。

{% img center http://dl.dropbox.com/u/10351676/images/pbxproj_status.png %}

ただそれぞれファイルを追加だけのことでコンフリクトするなんて...  
どうにかならんもんかいとTwitterでつぶやいたところ、 [@azu_re](https://twitter.com/azu_re) さんから有り難い教えが！

<!-- more -->

<blockquote class="twitter-tweet" lang="en"><p><a href="https://twitter.com/tokorom">@tokorom</a> gitはファイル別にマージ方法を指定できるので、mergepbxみたいなのをpbxprojのマージに使うようにするぐらいですかねー(まだαですが)&#10;<a href="https://t.co/VxXm0fcJMb">https://t.co/VxXm0fcJMb</a></p>&mdash; azu (@azu_re) <a href="https://twitter.com/azu_re/statuses/430521149861031936">February 4, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## mergepbxを試してみる

まだα版ということだがせっかくなので試してみた。基本的には

[https://github.com/simonwagner/mergepbx](https://github.com/simonwagner/mergepbx)

のREADMEどおりにインストール＆設定するだけ。

cloneして

```
$ ./build.py
```

すると、同ディレクトリに `mergepbx` というファイルができる。それをPATHの通った場所に設置する。

**2014/02/09 追記**  
（もしくは自分でビルドしなくても [https://github.com/simonwagner/mergepbx/releases](https://github.com/simonwagner/mergepbx/releases) から最新版をダウンロードすることも可能）

`~/.gitconfig` に以下の設定を追加する

```
[merge "mergepbx"]
  name = XCode project files merger
  driver = mergepbx %O %A %B
```

<s>なお、`LANG=` ってところはREADMEには書かれていないのですが、ぼくの手元だと</s>
<s>...</s>
<s>と日本語まわりでfailedになったので加えました。</s>

**2014/02/09 追記**  
mergepbxの最新版ではLANG=を指定しなくても問題が発生しなくなりました。

次に、`.gitattributes` で

```
*.pbxproj merge=mergepbx
```

と `pbxproj`のときはマージに `mergepbx` を使うように設定を追加という手順です。

## mergepbxの結果

ストーリーとしては、

- `test1`ブランチで 適当なファイルを１つ追加してコミット
- `test2`ブランチで 別の適当なファイルを１つ追加してコミット
- `test1`ブランチで`git merge test2`

<s>として、pbxprojが自動マージされるかどうかという確認をしたのですが、その結果、</s>
<s>...</s>
<s>と残念ながらうまく自動マージされませんでした。。。</s>

<s>どういうパターンで成功するのかは分かりませんがまだ実用的ではないかんじです。</s>

<s>ただ、READMEの次の項に、 `*.pbxproj merge=union` が使えるんだったらそれもいいかもよという記述が...</s>

**2014/02/09 追記**  
mergepbxの最新版ではこのケースがうまく自動マージされるようになりました。cool :)

## まとめ

<s>ということで、今のところ `merge=union` を使うのが良さそう。</s>

<s>100%うまくいくわけではないけど、一番多く発生する両方で追加するパターンは自動マージされるようになるため、対応コストは確実に低くなると予想しています。</s>

**2014/02/09 追記**  
mergepbxの最新版（0.5以降）を使いましょう！

（まだ少し検証した程度なのでしばらく使ってみます）


