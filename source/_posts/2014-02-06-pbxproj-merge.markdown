---
layout: post
title: "Xcodeのプロジェクトファイル（pbxproj）がコンフリクトしまくるのをなんとかしたい！"
date: 2014-02-06 14:02
comments: true
external-url: 
categories: [xcode,ios]
---

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
$ ./build.py mergepbx MANIFEST
```

すると、同ディレクトリに `mergepbx` というファイルができる。それをPATHの通った場所に設置する。

`~/.gitconfig` に以下の設定を追加する

```
[merge "mergepbx"]
  name = XCode project files merger
  driver = LANG=ja_JP.UTF-8 mergepbx %O %A %B
```

なお、`LANG=` ってところはREADMEには書かれていないのですが、ぼくの手元だと

```
merging failed: 'ascii' codec can't decode byte 0xe2 in position 356821: ordinal not in range(128)
Auto-merging XXX.xcodeproj/project.pbxproj
CONFLICT (content): Merge conflict in XXX.xcodeproj/project.pbxproj
Automatic merge failed; fix conflicts and then commit the result.
```

と日本語まわりでfailedになったので加えました。

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

として、pbxprojが自動マージされるかどうかという確認をしたのですが、その結果、

```
Automatic merge failed; fix conflicts and then commit the result.
```

と残念ながらうまく自動マージされませんでした。。。

どういうパターンで成功するのかは分かりませんがまだ実用的ではないかんじです。

ただ、READMEの次の項に、 `*.pbxproj merge=union` が使えるんだったらそれもいいかもよという記述が...

## merge=union を試してみる

`uinon`を指定すると、両方で変更が発生した場合、その順番を気にせず両方の変更内容を適用するとのこと。

実際に`.gitattributes`に

```
*.pbxproj merge=union
```

を追加して`git merge test2`を実行したところ、無事に自動マージされて`test1`ブランチと`test2`ブランチでの追加が両方とも反映されました！

## unionでどこまでできる？

ではunionが実用レベルに耐えられるか軽く検証してみました。

### 両方でプロジェクトに対するファイル追加を行った場合

実際のプロジェクトではこのパターンが大半になると思います。
このパターンは前述のとおり問題なし。

### 片方でプロジェクトからのファイル削除、ファイル名変更を行った場合

問題なし。

### 両方でプロジェクトからのファイル削除を行った場合

プロジェクトにファイルが残ってしまうケースがある。  
ただ、プロジェクトにファイルが残っても実ファイルが消えていればビルドエラーで検知可能。

### 両方でファイル名変更を行った場合

それぞれでの変更後のファイル名のファイルがプロジェクトに追加されるというおかしな状態になる。
実ファイルのほうでコンフリクトが起きるような状態だし検知も可能で発生率も低いので無視しても良さそう。

## まとめ

ということで、今のところ `merge=union` を使うのが良さそう。

100%うまくいくわけではないけど、一番多く発生する両方で追加するパターンは自動マージされるようになるため、対応コストは確実に低くなると予想しています。

（まだ少し検証した程度なのでしばらく使ってみます）


