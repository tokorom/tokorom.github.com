---
layout: post
title: "AlamofireでGenericにModelオブジェクトを取得する"
date: 2015-03-11
comments: true
external-url: 
tags: [ios,swift]
aliases: [/2015/03/11/almofire/]
authors: [tokorom]
---

※この記事のコードはXcode 6.3 beta（Swift 1.2）で試しています

Swiftいいですね！

これまでSwiftの案件を２つほどやってきたのですが、どちらも開発スタートが2014年7月だったため新しめのSwiftライブラリもリスクが高そうで、利用できるライブラリはある程度限定されてしまいました。
例えば、[Alamofire](https://github.com/Alamofire/Alamofire) のInitial Commitも2014/7/31だったりと。。。

今となっては（2015年3月）Swift公開から早９ヶ月が経過しており、ライブラリの選択肢もだいぶ広がりました。
また、まだSwiftのライブラリを管理する環境もだいぶ整ってきました（ちょうど本日3/11にCocoaPodsのDynamic Framework対応版が公開されました！）。

ということで、３月からはじめる新案件では`Alamofire`の採用を決め、APIアクセスまわりのインターフェースをいろいろと検討してみました。
やはりSwiftを使うからには、Genericsを使ってModelオブジェクトに変換された状態のレスポンスを受け取れるインターフェースになっていて欲しいですよね！

※基本的にはAlamofireのREADMEに書かれている話です

<!-- more -->

## ふつうにJSONを取得するインターフェース

まず、普通にJSONを取得するインターフェースですが、

```swift
Alamofire.request(.GET, "https://api.github.com/users")
    .validate()
    .responseJSON { [unowned self] (_, _, JSON, error) in
        if let error = error {
            self.textView?.text = "\(error)"
        } else if let JSON = JSON {
            // ここでJSONをパースしてModelに変換する
            // これは擬似的なコードです
            if let dicts = JSON as? NSArray {
                var users = [User]()
                for dict = dicts {
                    if let user = User(dict: dict) {
                        users.append(user)
                    }
                }
                self.textView?.text = "\(users)"
            }
        }
    }
```

といったかんじで`responseJSON`で`NSArray` or `NSDictionary`にシリアライズ後の情報をModelオブジェクトに変換して利用するというのがよくある使い方ではないかと思います。

## Genericなインターフェース

ただ、せっかくSwiftを使っているので（正確にはObjective-Cでもこうしたいですが...）Modelオブジェクトへの変換までを裏（APIクライアント側）でやってしまいたいところです。

例えば、こんなかんじで。

```swift
Alamofire.request(.GET, "https://api.github.com/users")
    .validate()
    .responseCollection { [unowned self] (_, _, users: [User]?, error) in
        if let error = error {
            self.textView?.text = "\(error)"
        } else if let users = users {
            self.textView?.text = "\(users)"
        }
    }
```

あら素敵！

Objective-C時代にもAPIクライアントにParserを渡してModelオブジェクトの状態で返してもらうようなことはやっていましたが、ここまですっきりしたインターフェースでこれが実現できるのはSwiftならではですね！

## Alamofireの拡張部分

（AlamofireのREADMEどおりですが）Alamofireを拡張して`responseCollection`というModelオブジェクトへの変換までやってくれる用のメソッドの実装はこんなかんじです。

新しく作る`ResponseCollectionSerializable`というJSON->Modelオブジェクトのシリアライズ用のprotocolに対応したクラスであれば、全てこのインターフェースで取得できるようになります。Generics偉い！

```swift
import SwiftyJSON

extension Alamofire.Request {
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [T]?, NSError?) -> Void) -> Self {
        let serializer: Serializer = { (request, response, data) in
            if let response = response, data = data {
                let json = JSON(data: data)
                if let objects: [T] = T.collection(response: response, json: json) {
                    return (objects as? AnyObject, nil)
                }
            }
            return (nil, NSError()) //< TODO: 期待されないレスポンスだった場合のエラーをここで返す
        }

        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
            completionHandler(request, response, object as? [T], error)
        })
    }
}
```

`Serializer`はAlamofireが具備しているシリアライズ部分のカスタマイズ用の型です。これを`response`メソッドに渡すことでシリアライズ部分を柔軟に拡張可能です。

## Model側の実装

（これもほぼREADMEどおりですが）最後に、JSONからのシリアライズにModelを対応させるための実装(`ResponseCollectionSerializable`)です。

※ [SwifthJSON](https://github.com/SwiftyJSON/SwiftyJSON) を使ってます

```swift
import SwiftyJSON

public protocol ResponseCollectionSerializable {
    init?(json: JSON)
    static func collection<T: ResponseCollectionSerializable>(#response: NSHTTPURLResponse, json: JSON) -> [T]?
}

class Model: ResponseCollectionSerializable {
    var identifier: String!

    required init?(json: JSON) {
        if let identifier = json["id"].int {
            self.identifier = String(identifier)
        } else {
            return nil
        }
    }

    class func collection<T: ResponseCollectionSerializable>(#response: NSHTTPURLResponse, json: JSON) -> [T]? {
        var items = [T]()
        for (k, j) in json {
            if let item = T(json: j) {
                items.append(item)
            }
        }
        return items
    }
}

class User: Model {
    var name: String!

    required init?(json: JSON) {
        super.init(json: json)
        if let name = json["login"].string {
            self.name = name
        } else {
            return nil
        }
    }
}
```

## このあと

[SwiftTask](https://github.com/ReactKit/SwiftTask)も使いつつ、このあたりの実装をAPIクライアントとしてまとめておきたい。
