---
layout: post
title: "Xcode 5: TDD/CIまわりに強力なアップデート(Appleがサイトで公開している範囲内で)"
date: 2013-06-12
comments: true
external-url: 
tags: [xcode,ios,objc]
aliases: [/2013/06/12/xcode5-preview/]
---

[tokorom@WWDC2013参加中](https://twitter.com/tokorom)です。  
WWDC2013で膨大なアップデートを学習中でしゃべりたいことが盛りだくさんなんですが、NDAのため我慢の日々。

で、キーノートの範囲の話は既に各所で情報が出ているわけですが、キーノートに出ていない項でも、Appleが非ログインで参照できるサイトで既に公表しているものがいくつかありました。

概要レベルでありますが、なかでも **TDD** とか **CI** まわりでiOSアプリ開発者にとって嬉しい情報がありましたので報告させていただきます。  
あくまでもAppleのサイトで公表されている範囲内のことしか書けませんのであしからず。

<!-- more -->

## ついにXcodeから任意のテストだけを簡単に実行できるようになる

{% img center http://dl.dropbox.com/u/10351676/images/icon-test-navigator.png %}

ついに、ついに...というかやっとかという話。

Xcode 5 で **Test Navigator** というやつが加わり、テスト駆動での開発を助けてくれますとのこと。具体的に、 **シングルクリックで特定の１つのテスト、もしくは選択した複数のテストを実行できる** という記載があります。

また、 **テストとソースコードを side by side で自動的に配置する** という記載もあります。

これでObjective-Cな人たちもまともにTDDできる日がやってくるかもしれないですね。

## CIの機能も入ります / その名は "Bots"

{% img center http://dl.dropbox.com/u/10351676/images/icon-bots.png %}

公表されている概要だけ並べてみると、

* ２、３回のクリックで新しいbotを作ることができる
* ネットワーク上のどのMacでも直ちにbotをスタートできる
* 別のMacでCIを回している間も、自分のMacでビルド結果やテストの結果を確認できる

とのこと。

Jenkinsで良い気もしますが、Xcodeから簡単にジョブを作成できるのは魅力的です。もしかするとBotsとJenkinsを連携させて使うという可能性もありそうです。

## その他

もっとしゃべりたいことがたくさんあるのですが、正式に公表されたタイミングでまた紹介させていただければと思います。。。

## 参照元

[What's New in Xcode 5](https://developer.apple.com/technologies/tools/whats-new.html)
