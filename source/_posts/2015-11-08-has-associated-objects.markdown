---
layout: post
title: "Swiftのextensionでstored propertyを追加する？（黒魔術は閉じ込める）"
date: 2015-11-08 11:45
comments: true
external-url: 
categories: [swift,ios]
---

{% img center https://raw.githubusercontent.com/tokorom/tokorom.github.com/images/images/blackbook.jpg %}

## extensionでstored propertyを追加したくなることありますか？

少なくともSwift 2.1時点ではextensionでstored propertyを追加することはできず、computed propertyのみに限られます。

でも、ヤダヤダ！ぼくは絶対stored property追加したいんだい！ってことありますか？

そう思っちゃうあなた、他に解決方法ありますよね？なんでそのやりかたにこだわるんですか？そういう思考になっちゃう時点でまだSwift脳に至ってはいないのではないでしょうか（建前）。

なお、ぼくはどうしても追加したんだい！ってことがあります（本音）。

<!-- more -->

## 対象がAnyObjectならAssociated Objectsで代用できるよ

で、そんな時は [この記事](http://www.tokoro.me/2015/10/26/defer-to-deinit/) でやっているように `Associated Objects` で代用できることがあります。

対象にきちんとretainさせることも可能ですし、安心ですね！

以下、サンプルコードです。

```
var StoredPropertyKey: UInt8 = 0

extension UIViewController {
    var storedProperty: SomeObject? {
        get {
            guard let object = objc_getAssociatedObject(self, &StoredPropertyKey) as? SomeObject else {
                return nil
            }
            return object
        }
        set {
            objc_setAssociatedObject(self, &StoredPropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

}
```

でも、こんな黒魔術的コードをプロジェクトの各所に書いてしまうと、またみんなに怒られちゃうかもしれませんよ？

## 黒魔術（臭いもの）にフタを

なので、この `objc_xxxAssociatedObject` を二度と書かなくて良いようにライブラリ化できないものでしょうか？

例えば、こんな感じで気軽にextendできるように。

```
// UIViewControllerにstoredPropertyを追加！
extension UIViewController: HasAssociatedObjects {
    var storedProperty: String? {
        get {
            return self.associatedObjects["HOGE"] as? String
        }
        set {
            self.associatedObjects["HOGE"] = newValue
        }
    }
}
```

## Protocol Extension（デフォルト実装）最強！

それ、Protocol Extensionでできるよ！ということで、やってみました。

```
protocol HasAssociatedObjects {
    var associatedObjects: AssociatedObjects { get }
}

private var AssociatedObjectsKey: UInt8 = 0

extension HasAssociatedObjects where Self: AnyObject {

    var associatedObjects: AssociatedObjects {
        guard let associatedObjects = objc_getAssociatedObject(self, &AssociatedObjectsKey) as? AssociatedObjects else {
            let associatedObjects = AssociatedObjects()
            objc_setAssociatedObject(self, &AssociatedObjectsKey, associatedObjects, .OBJC_ASSOCIATION_RETAIN)
            return associatedObjects
        }
        return associatedObjects
    }

}

class AssociatedObjects: NSObject {

    var dictionary: [String: Any] = [:]

    subscript(key: String) -> Any? {
        get {
            return self.dictionary[key]
        }
        set {
            self.dictionary[key] = newValue
        }
    }

}
```

これで `objc_xxxAssociatedObject` って書かずにAssociated Objects使いまくれますね！（やってることは変わらないけど。。。）

## まとめ

- extensionにstored propertyは追加できないけど、Associated Objectsで代用できる場合があるよ
- Swift2のProtocol Extension（デフォルト実装）最高！
- この黒魔術を閉じ込めた `HasAssociatedObjects` protocol君はここに置きました -> [https://github.com/tokorom/HasAssociatedObjects](https://github.com/tokorom/HasAssociatedObjects)
