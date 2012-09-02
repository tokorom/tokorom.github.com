---
layout: post
title: "GHUnitのテストカバレッジをJenkinsで表示する"
date: 2012-09-02 22:54
comments: true
external-url: 
categories: ios jenkins
---

## 概要

設定が完了すると、JenkinsでGHUnitのテストが実行された後に以下のようにテストカバレッジが参照できます。

{% img center http://dl.dropbox.com/u/10351676/images/ghunit-coverage.png %}

設定がちょっとだけ面倒ですが、一度やって慣れてしまえばなんてことありません。

実際に動かしてみたサンプルプロジェクトは [Github](https://github.com/tokorom/CodeCoverageWithGHUnit) に置いてあります。  
うまく動かない場合の設定の比較などにご参照ください。

なお、ここではiOSアプリ開発用としての紹介をさせていただきます。

<!-- more -->

## 事前準備

### Jenkinsの導入

* [さくらVPSにJenkinsさんをインストールする](/2012/07/24/install-jenkins-to-sakura/)

### GHUnitの導入

* [Jenkins を iOS アプリ開発に導入してみた (GHUnit編)](http://akisute.com/2012/01/jenkins-ios-ghunit.html)

GHUnitのiOS用frameworkをビルドするのが面倒な場合は、[Github](https://github.com/tokorom/ghunit-ios-framework) にビルド済みのものを置いてあるのでこれを使っていただいても構いません(2012/9/2時点でXcode 4.4.1 では問題なく利用できました)。

## テストカバレッジを出力するためのプロジェクトの設定を変更する

GHUnitを使っている場合はテスト用のターゲットにのみ設定すればOKです。  
具体的には、以下のように

{% img center http://dl.dropbox.com/u/10351676/images/test-coverage-setting.png %}

* *Generate Test Coverage Files*
* *Instrument Program Flow*

の２つに **YES** を設定します。

本来であれば上記だけで完了とできるのですが、現状だとXcodeにバグがあるというこでこのままだとJenkinsでのジョブ実行時に
```
Detected an attempt to call a symbol in system libraries that is not present on the iPhone:
fopen$UNIX2003 called from function llvm_gcda_start_file in image Tests.
```
というエラーが出ることになります。

この対処として、 **main.m** に以下コードを追記しておく必要があります。
``` objc
FILE *fopen$UNIX2003(const char *filename, const char *mode)
{
  return fopen(filename, mode);
}
 
size_t fwrite$UNIX2003(const void *ptr, size_t size, size_t nitems, FILE *stream)
{
  return fwrite(ptr, size, nitems, stream);
}
```

最後に、テスト用のターゲットの **info.plist** に *Application does not run in background* を加え、ここに **YES** を設定します。

ここまででXcode側の設定は完了なので、GHUnitのテストを実行するとbuildディレクトリ以下（自分の場合は *build/CodeCoverageWithGHUnit.build/Debug-iphonesimulator/Tests.build/Objects-normal/i386*）に 

* \*.gcda
* \*.gcno

といったテストカバレッジの結果を出力したファイルが確認できるはずです。  
Jenkinsを使わずローカルでこの結果を確認したい場合は、 [CoverStory](http://code.google.com/p/coverstory/) などでこれらのファイルを開けばローカルで確認することも可能です。

## gcovrの設置

上記で出力したテストカバレッジの結果をJenkinsのCobertura pluginで読める形式に変換するために、 [gcovr](https://software.sandia.gov/trac/fast/wiki/gcovr) というPythonスクリプトを利用します。  
具体的には、[ココ](https://software.sandia.gov/svn/public/fast/gcovr/trunk/scripts/gcovr) からダウンロードしてPathの通った場所にこれを設置します。

## Jenkinsのジョブの設定

### 必要なPlugin

* Git plugin
* Cobertura plugin

をJenkinsにインストールしてください。

### ジョブの設定

* Source Code Management
  * Repositories: 対象となるGitリポジトリのURL

※ サンプルをそのまま利用したい場合は `git://github.com/tokorom/CodeCoverageWithGHUnit.git` をご利用ください

* BuildにGHUnit実行用の Execute Shell を追加

```
GHUNIT_CLI=1 WRITE_JUNIT_XML=YES xcodebuild -target Tests -configuration Debug -sdk iphonesimulator clean build
```

* Buildeにgcovr実行用の Excute Shell を追加

```
gcovr -r . --object-directory build/CodeCoverageWithGHUnit.build/Debug-iphonesimulator/Tests.build/Objects-normal/i386 --exclude '.*Tests.*' --exclude '.*ExternalFrameworks.*' --xml > build/coverage.xml
```
※ テストターゲットやプロジェクト名は適宜変更してください

* Post-build Actionsに Publish JUnit test result report を追加

```
build/test-results/*.xml
```

* Post-build Actionsに Publish Cobertura Coverage Report を追加
  * Consider only stable builds: **On**
  * Source Encoding: **UTF-8**
  * Cobertura xlm report pattern
```
build/coverage.xml
```
※ この他、Coverage Metrics Targets で特定のカバレッジを下回った場合にはジョブ失敗とみなすなどの設定ができるようです。

以上で設定は完了です。  

あとは実行するだけ！

テストカバレッジが複数回取られると、Jenkins上で

{% img center http://dl.dropbox.com/u/10351676/images/coverage-graph.png %}

のようにカバレッジの変化をグラフで確認することもできるようになります。

## 参照させていただいたブログ記事へのリンク

* [iOS dev: How to setup quality metrics on your Jenkins job?](http://blog.octo.com/en/jenkins-quality-dashboard-ios-development/)
* [Jenkinsでテストとカバレッジの結果をグラフ表示できるようにする](http://safx-dev.blogspot.jp/2012/03/jenkins.html)
* [Jenkins を iOS アプリ開発に導入してみた (GHUnit編)](http://akisute.com/2012/01/jenkins-ios-ghunit.html)
