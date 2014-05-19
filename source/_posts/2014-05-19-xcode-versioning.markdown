---
layout: post
title: "これがXcodeでのバージョニングの決定版になるかも"
date: 2014-05-19 14:16
comments: true
external-url: 
categories: [xcode,ios]
---

{% img center http://dl.dropbox.com/u/10351676/images/xcode_versioning.png %}

## 概要

### この記事でできるようになること

- 安定してInfo.plistの内容（ここではBuild番号）を変更できる
- ふつうにRun Scriptで編集するとタイミングによってすぐにアプリに反映されないことがあったりしたがそれが解消される
- Info.plistに差分がでないのでcommitのときに邪魔にならない

### 必要な設定

- `Preprocess Info.plist file` でInfo.plistをビルド前に確定させる
- Run Scriptで`${TEMP_DIR}"/Preprocessed-Info.plist`を編集する

以下、具体的な話をします。

<!-- more -->

## 経緯

これまで、

- デバッグ用やArchive用のアプリのバージョンにだけgitのcommit番号とか最終更新日付を付ける

といったことをする場合に、Run ScriptでInfo.plistを（PlistBuddyなどで）編集してやるのが常だったと思うのですが、その場合、

- Compile Sourcesより前にRun Scriptを設定してもScriptで編集した内容がアプリに反映されない場合がある
    - そのため、確実に内容を反映させるために２回ビルドを走らせたりとか...
- 変更したInfo.plistに差分が出てソース管理上差分が出てしまう
    - 差分を元に戻せばいいのだけど、毎回それをやるのが面倒

といった課題があったりしました（少なくともぼくの手元では）。

そういったことを踏まえて、

[potatotips 第７回](http://connpass.com/event/6199/) で「agvtoolで超かっこよくバージョニングできますか？」という発表をしたのですが、

<script async class="speakerdeck-embed" data-id="af691300be580131ba2f16b66683ddab" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>

その後のTwitterの議論（議論というかぼくは教えてもらっただけですが...）で、これぞというバージョニングの方法が生み出されました。

<blockquote class="twitter-tweet" data-conversation="none" data-cards="hidden" lang="en"><p><a href="https://twitter.com/tokorom">@tokorom</a> ちょっと準備がややこしいですが、こういう手もあるということで <a href="https://t.co/EQYS2gVrwm">https://t.co/EQYS2gVrwm</a> こんなのどうでしょうか。正直準備がめんどうなので僕はたぶん使わないですけど。</p>&mdash; kishikawa katsumi (@k_katsumi) <a href="https://twitter.com/k_katsumi/statuses/466987671080804352">May 15, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-conversation="none" lang="en"><p><a href="https://twitter.com/k_katsumi">@k_katsumi</a> <a href="https://twitter.com/tokorom">@tokorom</a> おはようございます。Preprocess Info.plist という設定なんてあるんですね。感動しました。これを Yes にしたら、他の設定は触らなくても Build Phases の何より先に Info.plist がプリプロセスされて</p>&mdash; 熊谷 友宏 (@es_kumagai) <a href="https://twitter.com/es_kumagai/statuses/467134816194789376">May 16, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-conversation="none" lang="en"><p><a href="https://twitter.com/k_katsumi">@k_katsumi</a> <a href="https://twitter.com/tokorom">@tokorom</a> 元の Info.plist と同じ ${TEMP_DIR}/Preprocessed-Info.plist が出来上がるみたいでした。これ自体も PlistBuddy で編集できたので「Info.plist に差分が出る」という点については</p>&mdash; 熊谷 友宏 (@es_kumagai) <a href="https://twitter.com/es_kumagai/statuses/467135329401438208">May 16, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-conversation="none" lang="en"><p><a href="https://twitter.com/k_katsumi">@k_katsumi</a> <a href="https://twitter.com/tokorom">@tokorom</a> これでも回避できるかもしれません。Copy Bundle Resources より前に Run Script を実行すれば Preprocessed-Info.plist が更新されるからなのか、最新のものがバンドルに含まれる様子でした。</p>&mdash; 熊谷 友宏 (@es_kumagai) <a href="https://twitter.com/es_kumagai/statuses/467135680657633281">May 16, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## Preprocess Info.plist file

{% img center http://dl.dropbox.com/u/10351676/images/preprocess_info_plist.png %}

ぼくは今回初めて知ったのですが、`Builde Settings` -> `Packaging` の中に `Preprocess Info.plist file` という設定項目があり、これに`YES`を設定することでInfo.plistがBuild Phasesの他の何よりも先にInfo.plistが作成されることになります。

そのため、これまで困っていた「変更したInfo.plistの内容が即反映されない場合がある」といった課題は、じつはこの設定で解消されるものでした。

## ${TEMP_DIR}/Preprocessed-Info.plist

そして、`Preprocess Info.plist file`を`YES`にした場合、通常のInfo.plistと別に `${TEMP_DIR}/Preprocessed-Info.plist` という名前で別のInfo.plistが作成されるようになります。あとは、Run Scriptでその`Preprocessed-Info.plist`のほうを編集してあげれば、それがアプリに即反映される形になります。

素晴らしいのは、この後、元のInfo.plistが変更されることはなく、しかも、`${TEMP_DIR}/Preprocessed-Info.plist`が別のディレクトリにあるためInfo.plistに差分が出ることはありません（もし、Preprocessed-Info.plistがプロジェクトディレクトリ内にできてしまう場合にはそれを.gitignoreに入れれば良い）。

また、良い副作用として、編集するInfo.plist名が`${TEMP_DIR}/Preprocessed-Info.plist`に固定できるというのもあります。ふつうにInfo.plistを編集する場合には、プロジェクトによってInfo.plistのファイル名が変わるため、プロジェクトごとにRun Scriptを変更する必要がありました。しかし、このファイル名が固定になるため、同じ挙動をさせるのでよければRun Scriptを変更することなくどのプロジェクトでも流用できるようになります。

Run Scriptのサンプルを以下に示します。

```sh
if [ ${CONFIGURATION} = "Debug" ]; then

  plistBuddy="/usr/libexec/PlistBuddy"
  infoPlist=${TEMP_DIR}"/Preprocessed-Info.plist"
  marketVersion=$($plistBuddy -c "Print CFBundleShortVersionString" $infoPlist)

  versionPrefix="dev-"
  lastCommitDate=$(git log -1 --format='%ci')
  versionSuffix=" ($lastCommitDate)"

  versionString=$versionPrefix$marketVersion$versionSuffix

  $plistBuddy -c "Set :CFBundleVersion $versionString" $infoPlist

fi
```

スクリプトの中身は、

- Configurationが`Debug`のときだけ実行する
- `PlistBuddy`でエンドユーザ向けのバージョン番号（`CFBundleShortVersionString`）を取得
- バージョンのPrefixとして`dev-`を設定
- gitの最後のcommitの日付を抽出してそれをバージョンのSuffixとする
- 最終的に `dev-` + バージョン番号 + `最後のcommit日付` をビルド番号（`CFBundleVersion`）に設定する

となっています。

## 実行結果

これらの設定をすることで、例えばアプリ内でビルド番号を表示したときに、`Debug`モードであれば、

{% img center http://dl.dropbox.com/u/10351676/images/versioning_sample_debug.png %}

と表示され、`Release`モードであれば、

{% img center http://dl.dropbox.com/u/10351676/images/versioning_sample_release.png %}

と表示されるようになり、開発中のアプリにのみどのcommitまでが入っているかを自動的に埋め込むことができるようになります。

## まとめ

- `Preprocess Info.plist file`に`YES`を設定する
- Run Scriptで`${TEMP_DIR}"/Preprocessed-Info.plist`を編集する

の２ステップでこういったバージョニングが安定して実現できるようになります。バージョニング以外でもInfo.plistを可変にしたい場合には等しくこの方法が有効かと思います。

教えていただいた [きしかわさん](https://twitter.com/k_katsumi) さんと [熊谷さん](https://twitter.com/es_kumagai) のご両名に感謝です！

この設定を埋め込んだサンプルは [ここ](https://github.com/tokorom/XcodeVersioningSample) に置いてあります。
