---
title: "apple/swift-formatをVimで使う"
date: 2020-08-17T18:11:06+09:00
draft: false
authors: [tokorom]
tags: [Vim,Swift]
images: [/images/vim-swift-format/top.png]
canonical: https://spinners.work
---

![image](/images/vim-swift-format/top.png)

皆々様におかれましては [apple/swift-format](https://github.com/apple/swift-format) を快適にご利用いただいていますでしょうか？[^name]

swift-formatをXcodeのBuild Phasesに設定して利用したり、CIなどで利用されているかたも多いかと思います。

私もswift-formatを利用しはじめたのですが、私のメインエディタであるVimからswift-formatを利用するといった記事は今のところ見つかりません。
iOSアプリをVimでコーディングするプログラマーは希有ですのでそれもしかたがないことでしょう。

ということでVim+SwiftでiOSアプリを開発して6年（2020年8月現在）の私がこの記事を書くこととしました。

[^name]: swift-formatと書けば十分なのですが、過去にあったSwiftFormatなどと混同しないようappleというprefixをつけました

## swift-formatを扱うVim Pluginの存在

2020年8月現在、残念ながらswift-formatを扱うVim Pluginは見つかりませんでした。これまで利用されていたSwiftLintやSwiftFormatのPluginは見つかるのですが、新しめなapple/swift-format用のものはないようです。

そのため、Pluginといっても大した機能は必要ないこともあり、自分で作ることにしました。

https://github.com/tokorom/vim-swift-format

## 事前に必要なもの

### swift-format

とうぜん事前にswift-formatが必要です。

```sh
which swift-format
```

などで存在を確認してください[^path]。

[^path]: swift-formatがPATHの通った場所に設置されているほうが後が楽です

なければ現在ならbrewでもインストール可能です。

`SwiftFormat`というのは別のツールですので間違わないようご注意ください。

```sh
brew install swift-format
```

### aleというVimのPlugin

https://github.com/dense-analysis/ale

非同期にLintをかけるためのPluginです。

今回、swift-formatによるLintはこのaleを経由してかけるように作っています。

## vim-swift-formatのセットアップ

### Vimへのインストール

ご利用のプラグインマネージャなどでインストールの設定をしてください。例えばVim-Plugなら

```vim
Plug 'tokorom/vim-swift-format'
```

です。

### 必須の設定

swift-formatによるLintをかけるにあたって以下の設定項目が必須です。`.vimrc`など任意の場所に設定してください。

```vim
let g:ale_linters = {
\   'swift': ['swift-format'],
\}

let g:vim_swift_format_use_ale = 1
```

### 必要なら可能な設定

`swift-format`の場所をフルパスで指定したい場合などは必要に応じて、

```
let g:vim_swift_format_executable = 'swift-format'
let g:vim_swift_format_lint_command = 'swift-format lint %s'
let g:vim_swift_format_format_command = 'swift-format format --in-place %s'
```

これらの設定が可能です。

## 使ってみる！

設定が終わったら早速使ってみましょう。

試しに、

```swift
import Foundation

final class Sample{
  let hello : String
}
```

とわざと2つの間違いを含んだSwiftコードを書きました。

- `Sample`と`{`の間に空白がない
- `hello`と`:`の間に余分な空白がある

という２点がswift-formatに直して欲しい箇所です。

このコードをVimで書いたところ、

![image](/images/vim-swift-format/ng.png)

と見事にスピーディに指摘してくれました。

## 自動で直してもらう！

これらの指摘を自分で直しても良いですが、swift-formatには自動フォーマット機能もありますので使ってみます。

Vim上で`:SwiftFormatFormat`というコマンドを打ちます。

すると、

![image](/images/vim-swift-format/fixed.png)

ときちんと自動的に修正してくれました！

簡単便利！

## まとめ

（数少ない）VimでSwiftを書いている皆々様、ぜひご活用ください！

