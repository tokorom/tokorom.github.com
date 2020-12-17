---
title: "Gitのcommitメッセージをその場で英訳したい！"
date: 2020-12-17T11:22:39+09:00
draft: false
authors: [tokorom]
tags: [Git,English]
images: [/images/commit-message-inline-translation/top.png]
canonical: https://spinners.work
---

## 完成後に収録した画面

![image](/images/commit-message-inline-translation/screen.gif)

## 対象者

- Vimでコーディングしている人
- Vim以外でコーディングしてるが`git commit`のときだけVimが起動する人（macOSだとデフォルトでそうなります）

## ぼくの課題

`git commit`でcommitメッセージを書く時、英語で書くことが多いと思います（プロジェクトによるとは思いますが）。

ぼくは英語でcommitメッセージを書くのが得意ではなく「あの不具合をこんな感じに修正したんだよなあ、それを英語で書くと...」と考えつつ面倒になって`Fix a problem`とか意味のないcommitメッセージを残してしまうことがありました。いちばんひどいときは`.`とか...。ごめんなさい。

しかし昨今は[DeepL](https://www.deepl.com/)など優秀な翻訳サービスがあるわけですし、それを使えば良いだけじゃんは思うものの、実際に`git commit`した後に翻訳サービスを開いてそこに日本語を入力して、翻訳結果をコピーしてエディタに戻ってきてペーストする、というのが日々のコーディングの流れの中では面倒すぎてけっきょく`Fix a problem`としてしまうわけです...

## 解決案

それを解決するのは簡単で、`git commit`で開かれたエディタで入力した日本語がその場で英訳されれば良い、というだけです。

技術的にも英訳APIが使えればすぐにでもできる話ですので、先日、半日程度時間が作れるタイミングでやってしまおう、となったというお話です。

## 作る

### 翻訳API

愛用しているDeepLにAPIがあったのでそれを使います。

https://www.deepl.com/docs-api/translating-text/request/

APIの利用はとても簡単で、テキストの翻訳なら、

```sh
curl https://api.deepl.com/v2/translate \
  -X POST \
  --data 'auth_key=AUTH_KEY&target_lang=EN-US&text=おはよう'
```

とするだけでとても簡単です。

### 英訳コマンド

今時点ではDeepLにCUIコマンドがないため、上の翻訳APIを叩くコマンドを自分で作ります。

といっても上のPOSTリクエストを1つ叩くだけなのですぐできます。

エディタから使いやすいように、

- STDIN（標準入力）から翻訳したいテキストを受けて
- STDOUT（標準出力）に翻訳後のテキストを返す

のが良さそうです。

ぼくがSwiftで書いたのが、

https://github.com/tokorom/deepl-cui-swift

です。
ここは誰かが作ったのを使ってもいいし、自分で作ってもすぐできるかと思います。

### git commitから呼び出す

この記事では`git commit`で起動するエディタがVimであることが前提です（macOSではデフォルトです）。

Vimからツールを呼ぶということはpluginを入れる必要がある？と思いがちですが「選択したテキストを外部コマンドに渡して結果と置き換える」というのはVimが標準で備ている機能です。

具体的には`!ls`とコマンド実行すればVimに`ls`の結果が挿入されますし、JSON文字列を選択して`!jq .`で`jq`コマンドに選択範囲を渡して整形してもらった結果で置き換えるといったことが普通にできます。

今回は、STDINを英訳するコマンドを作ったので（`deepl-cui-swift`コマンドとする）、翻訳したいテキストを選択して

```
!deep-cui-swift
```

を実行するだけでこれが実現できます。

### ショートカット

必要なら`.vimrc`にショートカットキーを用意しましょう。ぼくは、

```vim
nnoremap ze <S-v>!deepl-cui-swift -s JA -w<CR>
```

と`ze`で現在行を英訳コマンドに渡す（ついでに翻訳前の言語を明示して、翻訳前のテキストも結果に含めるオプションを指定）ショートカットを用意して使っています。

## 動作確認

これで`git commit`後のエディタで日本語でメッセージを書き、`ze`するだけで英訳されるようになりました！

![image](/images/commit-message-inline-translation/screen.gif)

ワイワイ！

## オマケ

### DeepL APIの料金

なお、DeepL APIは無料で使えるわけではありません。

2020年12月時点では、月額630円のプランに入る必要があります。

https://www.deepl.com/pro?cta=header-prices/

また、APIで翻訳した文字数により従量課金されます。
従量課金というとどのくらいかかるんだろ？と不安になってしまいますが、1文字あたり0.0025円と安いです。実際にぼくが2日程度commitメッセージの英訳に使った程度（コマンドの作成やこのブログ記事を書く時も使ってます）では、

![image](/images/commit-message-inline-translation/price.png)

と１円にもなりません。

また、必要なら利用金額の制限もかけられるので安心です。

![image](/images/commit-message-inline-translation/limit.png)

ぼくはいったん500円（20万文字を翻訳）の制限をかけました。







