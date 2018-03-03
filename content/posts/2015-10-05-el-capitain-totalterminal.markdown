---
layout: post
title: "El CapitanでTotalTerminalが動かないならAppleScriptで代用すればいいじゃない?"
date: 2015-10-05
comments: true
external-url: 
tags: [mac,cui]
aliases: [/2015/10/05/el-capitain-totalterminal/]
---

## El CapitanにしたらTotalTerminalが動かない！

Twitter上でもよくこの話題が出ていて、多くの人はiTerm2に移管しているようです。

しかし、ぼくは長年愛した（普通の）Terminalちゃんをそう簡単に捨てることはできないのです！

もともとTotalTerminalはTerminalの表示をカッコよくトグルするために使っているわけで、TotalTerminalというよりはTerminalちゃんをそのまま使いたいわけです。
（実際のところiTerm2を試してないので、iTerm2の良さについては全くの無知です）

であれば、そんなトグルくらいならAppleScriptで軽やかにできるはず！ぼくのAppleScriptでTerminalちゃんを救ってみせる！
と思いたって試してみました。
（実際のところAppleScriptに無知すぎて全く軽やかにはできなかったわけですが、結果自体はシンプルです）

以下、試したことをまとめます。

<!-- more -->

## ぼくの最強なトグル用AppleScript

ひとまずこのスクリプトを実行することで、

- Terminalが動いていなければ起動して最前面に
- Terminalが裏にいるなら最前面に
- Terminalが最前面にいるなら裏に回す

ことはできるようになった。

```
tell application "System Events"
    set activeApp to first process where it is frontmost
    if activeApp's name = "Terminal" then
        # Command-Tab
        tell application "System Events"
            key down command
            keystroke tab
            key up command
        end tell
    else
        # Open Terminal
        tell application "Terminal" to activate
    end if
end tell
```

今のぼくにはこれが精一杯でした。
こんなぼくに、もっとこうしたほうが良いよ！と教えてくれるかたがいらっしゃったら、現在のスクリプトをGitHubに置きましたので是非ご指摘いただけると嬉しいです。

[https://github.com/tokorom/ToggleTerminalScript](https://github.com/tokorom/ToggleTerminalScript)

現在の課題としましては、

- Terminalが起動しているがウィンドウがないときはウィンドウがないままアクティブになる（困ってはないけど勝手にウィンドウ作ってくれればスマート）
- かっこよくない（冗長かもだが、TotalTerminalみたいにかっこよく動くとより良い）
- プロセスの名前が常に `Terminal` でよいのかがよくわからん
- Terminalが既にカレントのときにCommand+Tabキーを送って裏に回してるけど、もっとスマートな方法あるんじゃない？

などがありそうです。

## Automatorでこのスクリプトをサービスとして登録

次に、このスクリプトを利用するためにAutomatorでサービスとして新規登録する。

{% img center http://dl.dropbox.com/u/10351676/images/toggle_terminal_script1.png %}

- Automatorで`サービス`を新規作成
- 左ペインの`ライブラリ`->`AppleScriptを実行`を右ペインにドラッグ＆ドロップ
- 右上の設定は `入力なし` と `すべてのアプリケーション` とする

{% img center http://dl.dropbox.com/u/10351676/images/toggle_terminal_script2.png %}

- `{* Your script goes here *}` のところに上のスクリプトを挿入
- 適当な名前で保存

## キーボードショートカットの設定

次に、登録したサービスをお好みのショートカットキーで実行できるようにする。

{% img center http://dl.dropbox.com/u/10351676/images/toggle_terminal_keysetting.png %}

- `システム環境設定` -> `キーボード` -> `ショートカット` -> `サービス` の下の方に登録したサービスがある
- 他と被らなそうな適当なショートカットキーを設定する

で、設定したショートカットキーでTerminalの表示をトグルできるようになったはず！

ただ、TotalTerminalの時に `Ctrl, Ctrl` とかいったショートカットキーを使っていると、それがここで設定できずに、うーーーんという感じになるかも。
僕も `Ctrl + Tab` を愛用していたため、もれなく、うーーーんとなりました。

## Karabinerで特殊なショートカットキーを解決する

そんな時は、みんな大好き [Karabiner](https://pqrs.org/osx/karabiner/index.html.ja) 様で解決すれば良し。

ぼくの場合は、

```xml
<item>
  <name>Change Control_+Tab to Shift_Option_Command_T Keys</name>
  <identifier>remap.tokorom.control_tab</identifier>
  <not>VIRTUALMACHINE, REMOTEDESKTOPCONNECTION</not>
  <autogen>--KeyToKey-- KeyCode::TAB, VK_CONTROL,    KeyCode::T, VK_SHIFT | MODIFIERFLAG_EITHER_LEFT_OR_RIGHT_COMMAND | ModifierFlag::OPTION_L</autogen>
</item>
```

この設定を追加して`Ctrl + Tab`で先ほど設定したショートカットキーを押したことにする設定を加えました。

以上で、ひとまずこれまでと同じショートカットキーでTerminalの表示をToggleすることはできるようになりました。
せっかくなのでしばらく使ってみます。

## 2015/10/6 追記： Alfred!!!

と、しばらく使ってみますと書いた翌日に早速選手交代することになりました。

下のコメントで、r.izumitaさんからAflredのWorkflowを使う方法をご教示いただき、試してみたところ、上記でごちゃごちゃやったことが本当に一発で解決できて感涙ものでした。
AlfredのWorkflowの利用には有償のライセンス（17ユーロ、現在だと2300円くらい）が必要になりますが、超簡単便利なのでオススメです。

（ぼくもTerminalのトグルにはこれを使うことにしました）
