---
layout: post
title: "iOSのライブラリだってTravis CIとかCoverallsとか使うべき"
date: 2013-07-09
comments: true
external-url: 
tags: [objc, ci]
aliases: [/2013/07/09/objc-travis-coveralls/]
authors: [tokorom]
---

{% img center http://dl.dropbox.com/u/10351676/images/ci_coverage_badges.png %}

今日はGithubに公開したiOS用のライブラリを **Travis CI** と **Coveralls** に対応した手順を紹介したいと思います。  

なお、実際にこれらを適用して運用しているリポジトリのサンプルは、

[https://github.com/tokorom/BlockInjection](https://github.com/tokorom/BlockInjection)

になります。

<!-- more -->

## 前提条件

- GitHubを使っていること
- GitHubでなんらかiOS/Mac用のライブラリを公開していること

## Travis CI

[https://travis-ci.org/](https://travis-ci.org/)

### 目的

公開しているライブラリの最新コードがきちんとビルドが通るものか、テストが通る状態かを明示できます。  
iOS用のCI環境を用意するのは通常すごく敷居が高い（物理的にMacが必要）のですが、Travis CIはiOS/Mac用のライブラリのCIを無料で請け負ってくれるかなり太っ腹なサービスです。

### 事前準備

- Travis CIのアカウントを作っておく(GitHubのアカウントで）

### Travis CI上で該当のリポジトリをONにする

{% img center http://dl.dropbox.com/u/10351676/images/travis_on.png %}

Travis CI に行って、このスクリーンショットのように該当リポジトリを `ON` にするだけです。簡単！

### Makefile を用意する（必須ではない）

必須ではないですが、Makefileを作っておくほうがいろいろとメリットある気がします。

自分の場合は、

```sh
PROJECT = BlockInjectionTest/BlockInjectionTest.xcodeproj
TEST_TARGET = Tests

clean:
	xcodebuild \
		-project $(PROJECT) \
		clean

test:
	xcodebuild \
		-project $(PROJECT) \
		-target $(TEST_TARGET) \
		-sdk iphonesimulator \
		-configuration Debug \
		TEST_AFTER_BUILD=YES \
		TEST_HOST=
```

こんなかんじで、 `make test` とすると `xcodebuild` で `Tests` がビルドされるようにしています。
`TEST_AFTER_BUILD=YES` と `TEST_HOST=` は重要です。

このMakefileを設置したら、まずはローカル環境で `make test` が成功するかを確認するのが良いと思います。

### .travis.yml を用意する

次に、Travis CI用の設定ファイル .travis.yml を設置します。

```sh
language: objective-c

script:
  - make clean test
```

これだけです。
`language` でobjective-cを指定し、`script`で`make clean`と`make test`を叩くことを記述しています。  
なお、`script` がなくてもデフォルトでObjective-C用のビルドが走るようです。

必要な設定はこれだけです。簡単すぎる！  
概ね１５分程度でTravis CI対応は終わってしまうくらいです。

### commit & push

これらの設定が終わったら、GitHubにpushします。  
すると、自動的にTravis CIで設定した内容が動き始めるはずです。

### 確認

{% img center http://dl.dropbox.com/u/10351676/images/travis_success.png %}

うまくいけば、 [こんなかんじ](https://travis-ci.org/tokorom/BlockInjection) でビルド/テスト結果が確認できるはずです。

また、

```
https://travis-ci.org/[YOUR_ACCOUNT]/[YOUR_REPOSITORY].png?branch=master
```

を画像として表示することで、こんなかんじのバッヂも表示できます。せっかくなのでこいつをReadmeに埋め込みましょう。

{% img center https://travis-ci.org/tokorom/BlockInjection.png?branch=master %}

## Coveralls

[https://coveralls.io/](https://coveralls.io/)

### 目的

公開しているライブラリに対してどれくらいテストがきちんと書かれているかを明示できます。  
例えば、ソースコードの全行を網羅するテストコードを書いてあるなら `coverage: 100%` という表示になります。  
100%を目指す必要はないと思いますが、これがあることで、

- 新しい機能を加えたときなどにきちんとテストを書く後押しになる
- pull reqを送ってもらうときにもテストを意識してもらえるようになる
- 利用者に対して安心感を持ってもらえる

といった効果がありそうです。

### 事前準備

- テストコードを書いておく
- Coverallsのアカウントを作っておく(GitHubのアカウントで）

### Coveralls上で該当のリポジトリをONにする

{% img center http://dl.dropbox.com/u/10351676/images/coveralls_on.png %}

やりかたもUIもTravis CI と同じです。CoverallsのADD REPOページに入って該当リポジトリを `ON` にするだけです。

### gcovを吐き出す設定を加える

Makefileにgcovを吐き出す用の設定を追加します。

```sh
test-with-coverage:
	xcodebuild \
		-project $(PROJECT) \
		-target $(TEST_TARGET) \
		-sdk iphonesimulator \
		-configuration Debug \
		TEST_AFTER_BUILD=YES \
		TEST_HOST= \
		GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
		GCC_GENERATE_TEST_COVERAGE_FILES=YES
```

最後の２つ `GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES` と `GCC_GENERATE_TEST_COVERAGE_FILES=YES` がキーポイントです。

### カバレッジをCoverallsに送る設定を加える

さらにMakefileにカバレッジをCoverallsに送信するための設定を追加します。  
`coveralls` というコマンドが使われていますが、これについてはこの後説明します。

```sh
send-coverage:
	coveralls \
		-e BlockInjectionTest/Tests 
```

### .travis.yml を更新

最後に、.travis.yml にCoveralls対応のための設定を追加します。

```sh
language: objective-c

before_install:
  - sudo easy_install cpp-coveralls
script:
  - make clean test-with-coverage
after_success:
  - make send-coverage
```

変更点は以下のとおりです。

* `before_install` で Objective-C（正確にはC++）用の `coveralls` コマンドをインストール
* `script` で `make test` でなくgcovを吐き出す `make test-with-coverage` を使うようにする
* `after_success` で `make send-coverage` を呼び出し、Coverallsにカバレッジ情報を送るようにする

### commit & push

すべての設定が終わったら、GitHubにpushすれば、GitHub -> Travis CI -> Coveralls と自動的に連携していきます。

### 確認

うまく動いていれば、Coverallsで

{% img center http://dl.dropbox.com/u/10351676/images/coveralls_list.png %}

こんなかんじでカバレッジの確認ができるはずです。

{% img center http://dl.dropbox.com/u/10351676/images/coveralls_source.png %}

また、こんなかんじでソースコードのどの行がカバーされていないかなども確認できます。

なお、Coverallsも

```
https://coveralls.io/repos/[YOUR_ACCOUNT]/[YOUR_REPOSITORY]/badge.png
```

でバッヂの表示ができます。

{% img center https://coveralls.io/repos/tokorom/BlockInjection/badge.png %}

### カバレッジ計測対象から除外する指定

なお、coverallsをそのまま使うとテストコードもカバレッジの計測対象に含まれてしまいます。  
そういった計測対象から除外したいファイルがある場合、`-e BlockInjectionTest/Tests` のように除外したいファイルのあるディレクトリを指定します。  
この場合だと `-e BlockInjectionTest` とか `-e Tests` のようにディレクトリ構造の一部分だけ指定してもうまくいきません。

## 課題

* <s>`cpp-coveralls` で特定のクラスを除外するのがうまくいかない</s>
    * <s>今は `make send-coverage` で `find ./ -name "*Test.gcno" | xargs rm` とかやって特定のgcovのファイルを直接消すという苦肉の策</s>
* カバレッジはCoverallsに送る前にも開発中にXcode上で簡単に確認できたら最高なんだが

