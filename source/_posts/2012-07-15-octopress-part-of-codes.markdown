---
layout: post
title: "Octopressでソースコードの一部分だけを参照する"
date: 2012-07-15 16:55
comments: true
external-url: 
categories: [mac,octopress]
---

<!-- more -->

## おさらい：Octopressでソースコードを表示する

まずはおさらいでOctopressでソースコードを表示する方法は以下のとおり。

### 1. 指定のディレクトリにファイルを置く

置き場所は *source/downloads/code* 。  
例えば、ここに *sample/test.rb* というファイルを置いておく。
```
$ mkdir -p source/downloads/code/sample
$ cp test.rb source/downloads/code/sample/
```

### 2. include_code でそのファイルを指定する

```
{% include_code sample/test.rb %}
```
これで↓のようにそのコードが表示できる。
{% include_code sample/test.rb %}

## コードの全てでなく、指定した箇所だけ表示したい

それでは、この *test.rb* の中の *to_fraction* というコードだけを表示したい場合はどうしたら良いだろう？  
じつは現行のOctopressのデフォルトの状態ではそれができない(**\*1**)。

ただ、この機能は **v2.1** では既に実装済みのようで、Octopressを master ではなく **2.1** ブランチから取ってこればこのコードの一部分だけを表示する機能が使えるようになる。

この経緯については、 [OctopressのPull request](https://github.com/imathis/octopress/pull/478) に記録がある。


### 2.1 ブランチをpullしてOctopressをアップデート

```
$ git pull octopress 2.1
$ bundle install
$ rake update_source
$ rake update_style
```
以上で取り込み完了です。  
masterでなく **2.1** からpullしていることに注意が必要。

### include_code にstartとendを指定する

あとは、↓のように *include_code* で *start* と *end* を指定するだけで、
```
{% include_code sample/test.rb start:5 end:11 %}
```
コードの一部分だけを表示することが可能になる。

{% include_code sample/test.rb start:5 end:11 %}

---
**\*1**: 2012/7/15現在の話。後述のとおり2.1では実装済みなのでじきに普通にできるようになるはず。
