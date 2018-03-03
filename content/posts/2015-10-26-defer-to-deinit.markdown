---
layout: post
title: "Swiftでdeinitまで処理をdeferする"
date: 2015-10-26
comments: true
external-url: 
tags: [swift,ios]
aliases: [/2015/10/26/defer-to-deinit/]
authors: [tokorom]
---

## deferしてますか？

Swift2でみんな大好き`defer`さんが導入されましたね！

`guard`と違いそんなに使う機会は訪れていないのですが、昨日、こんな感じで使いたい！という場面に遭遇しました。

[CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)を使ってデバッグ用にUITextViewにログを吐くCustom Loggerを設定していたのですが、とあるViewControllerだけでそれを使いたく、ViewControllerがdeinitされたらそのCustom Loggerも当然外したい。

そんなコードを書く場合、`defer`大好きっ子ならCustom Loggerを登録した後にこんな感じで解除したくなりますよね（実際は僕はこのとき初めて実験でないところで`defer`を使ったので、本当の`defer`大好きっ子はこんな間違いはしないだろう）。

```
let logger = TextViewLogger(textView: textView)
DDLog.addLogger(logger)

defer {
    DDLog.removeLogger(logger)
}
```

`defer`使って、必要なくなったら漏れなくCustom Loggerを解放する俺様は超カッコいいぜ！と言いたかったのだが、当然のごとくこのコードは間違っていて、これを実行し終わるときにはdeferした処理も実行されて登録したCustom Loggerが即解除されるというお馬鹿な状況になるわけです。

## でもdeferしたいよね？

とお馬鹿な前置きは置いておいても、上のような雰囲気で終処理書けたら便利な気はする。
普通に`deinit`でやれば済む話なんだけど、今回のケースだとpropertyに`logger`をもたせて、`deinit`で`logger`があれば`removeLogger`する的なことを書かないといけない。まあ普通のことではあるんだけど、できたら、

```
let logger = TextViewLogger(textView: textView)
DDLog.addLogger(logger)

deferToDeinit {
    DDLog.removeLogger(logger)
}
```

と、deinitまで処理を遅延させる的な書き方できたら面白いよね、ということで...

<!-- more -->

## deinitまでdeferさせてみよう！その1

まず、超smellな秘伝のBaseViewControllerを使ってベタにやってみると、

```
typealias DeferredClosure = () -> Void

class BaseViewController: UIViewController {
    var deferreds: [DeferredClosure] = []

    deinit {
        for deferred in deferreds {
            deferred()
        }
    }

    func deferToDeinit(closure: DeferredClosure) {
        deferreds.append(closure)
    }
}
```

てな感じでBaseViewController君を作っておけば、このsubclassではみんな`deferToDeinit`が使えるようになって、ひとまず目的は果たせる（はず）。

ぼく的にはこれでも良かったのですが、これだとみんなから超smellだ！○ね！と怒られる場合があるかもしれないので要注意です。

## deinitまでdeferさせてみよう！その2

なので、今をときめくProtocol Extensionsでなんとかできないかも考えてみます。

まず、`deinit`まで処理を遅延させるのが目的なのにSwiftのExtensionでは`deinit`を拡張はできないのでどうしたものか、と。
`deinit`代わりにStored Propertyを使う方法も考えられるが（Stored Propertyの親がdeinitされたらそのPropertyもdeinitされる）、ExtensionでStored Propertyを追加することはできない。

Stored Propertyがダメなら、Computed Property + Associated Objectsでなんとかなるかも？と試してみました。

```
typealias DeferredClosure = () -> Void

protocol Deferrable {
    func deferToDeinit(closure: DeferredClosure)
}

var PropertyDeferreds: UInt8 = 0

extension UIViewController: Deferrable {
    class Deferreds {
        var deferreds: [DeferredClosure] = []

        deinit {
            for deferred in deferreds {
                deferred()
            }
        }

        func append(closure: DeferredClosure) {
            deferreds.append(closure)
        }
    }

    var deferreds: Deferreds {
        get {
            guard let deferreds = objc_getAssociatedObject(self, &PropertyDeferreds) as? Deferreds else {
                let deferreds = Deferreds()
                objc_setAssociatedObject(self, &PropertyDeferreds, deferreds, .OBJC_ASSOCIATION_RETAIN)
                return deferreds
            }
            return deferreds
        }
    }

    func deferToDeinit(closure: DeferredClosure) {
        deferreds.append(closure)
    }
}
```

もともと`deinit`で何をやりたかったかと言えば、遅延実行用に渡したclosureの実行なので、上では、

- Deferredsという適当なClassにclosureを保持させる
- DeferredsをAssociated ObjectsとしてUIViewControllerに保持させる
- UIViewControllerがdeinitされるとそれが保持しているDeferredsもあわせてdeinitされる
- Deferredsのdeinitで遅延実行用closureをまとめて実行する

という流れでそれを実現しています。

キーポイントは`UIViewControllerがdeinitされるとそれが保持しているDeferredsもあわせてdeinitされる`のところで、Associated Objectsでもdeinitが自動で呼ばれるのかが心配だったのですが試してみたところきちんと呼ばれてました。

BaseViewController君さようなら！

## まとめ

- これは昨日思いつきで試してみただけなので、deferToDeinitが本当に便利なのかはまだわかりません
- deferToDeinitの実装方法はどっちのやりかたが偉いってこともないと思いますのでケースバイケースで
- もっとこんなスマートなやりかたあるよ！というコメントを是非お願いします！
