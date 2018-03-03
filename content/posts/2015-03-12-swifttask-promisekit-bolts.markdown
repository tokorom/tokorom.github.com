---
layout: post
title: "SwiftTask、PromiseKit、Boltsを比較する（2015年3月版）"
date: 2015-03-12
comments: true
external-url: 
categories: [ios,swift]
aliases: [/2015/03/12/swifttask-promisekit-bolts/]
---

- ※2015/3/11時点での比較結果ですので、今後、各ライブラリともにパワーアップしていくと思われます
- ※いまはできないことでも各ライブラリのIssuesでは実装の検討が進んでいるものも多くあるようです

次の案件で（Swiftで）Promiseライクなフロー制御を実現するために利用するライブラリを選定するため、2015/3/11時点の

- [SwiftTask](https://github.com/ReactKit/SwiftTask)
- [PromiseKit](https://github.com/mxcl/PromiseKit)
- [Bolts-iOS](https://github.com/BoltsFramework/Bolts-iOS)

を（表面だけ）使って比較してみました。

なお、昨年の７月時点では（Swiftで使うぶんには）PromiseKitが将来性があると判断し、しばらくはPromiseKitを使っていました。

その後、SwiftTaskも登場して気になっていたので、今回改めて新案件で採用するライブラリを選定したという経緯になります。

以下にそれぞれ使ってみた結果を紹介させていただきます。

<!-- more -->

## 更新頻度

この３つのライブラリはどれも更新頻度が多く、現在betaのSwift 1.2でも（別ブランチで）きちんと動く形になっています。

## 試すネタ

[AlamofireでGenericにModelオブジェクトを取得する](http://www.tokoro.me/2015/03/11/almofire/) で試したAlamofireを使うコードをネタとしてそれぞれ３つのライブラリを適用してみました。

## Taskを使うほうのコード

### SwiftTask

```
request(.GET, urlString).success { [unowned self] (users: [User]) in
    self.textView?.text = "\(users)"
}.failure { [unowned self] error, _ in
    self.textView?.text = "\(error)"
}
```

- すっきり直感的に書けます
- Genericsで欲しいModelオブジェクトを直感的に指定するようなインターフェースにできます

### PromiseKit

```
request(.GET, urlString).then { [unowned self] (users: [User]) -> Void in
    self.textView?.text = "\(users)"
    return
}.catch { [unowned self] error -> Void in
    self.textView?.text = "\(error)"
    return
}.finally {
}
```

- おおむねすっきりと書けます
- Genericsで欲しいModelオブジェクトを直感的に指定するようなインターフェースにできます
- そのままだとSwiftの型推論がうまくいかなくて一見不要そうな`return`とか`finally`を加えて型推論を助けてあげる必要があるケースがあり、ちょっと癖があるかんじです

### Bolts

```
request(Alamofire.Method.GET, urlString, User.self).continueWithBlock { (task: BFTask!) -> AnyObject! in
    if let error = task.error {
        self.textView?.text = "\(error)"
    } else if let users = task.result as? [User] {
        self.textView?.text = "\(users)"
    }
    return nil
}
```

- すっきり直感的に書けます
- Swift専用のインターフェースがないため、Genericsを使うには工夫が必要になります
    - 上の例だと引数にModelクラスのTypeを指定するようにしていますが、素直にGenericsを使えないのはちょっと残念です
    - TaskのResultは`AnyObject`になってしまうので個別にダウンキャストなどが必要です

## Taskを作るほうのコード

- `responseCollection`といったAlamofireの拡張は事前に済ませている前提です（[参考](http://www.tokoro.me/2015/03/11/almofire/)）
- validationの個別カスタマイズなどには今回のサンプルでは対応していません

こちらについてはどのライブラリも分かりやすく大差はないかなと思います。

### SwiftTask

```
// SwiftTaskのみprogress取得に対応したサンプルになっています
public func request<T: ResponseCollectionSerializable>(method: Alamofire.Method, URLString: Alamofire.URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: Alamofire.ParameterEncoding = .URL) -> Task<Progress, [T], NSError> {
    let task = Task<Progress, [T], NSError> { progress, fulfill, reject, configure in
        Alamofire.request(method, URLString, parameters: parameters, encoding: encoding)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                progress((bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) as Progress)
            }
            .validate()
            .responseCollection { (request, response, collection: [T]?, error) in
                if let error = error {
                    reject(error)
                    return
                }
                if let collection = collection {
                    fulfill(collection)
                    return
                }
                reject(NSError()) //< TODO: unexpected error
            }
    }
    return task
}
```

### PromiseKit

```
public func request<T: ResponseCollectionSerializable>(method: Alamofire.Method, URLString: Alamofire.URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: Alamofire.ParameterEncoding = .URL) -> Promise<[T]> {
    let promise = Promise<[T]>({ fulfiller, rejecter in
        Alamofire.request(method, URLString, parameters: parameters, encoding: encoding)
            .validate()
            .responseCollection { (request, response, collection: [T]?, error) in
                if let error = error {
                    rejecter(error)
                    return
                }
                if let collection = collection {
                    fulfiller(collection)
                    return
                }
                rejecter(NSError()) //< TODO: unexpected error
            }
    })
    return promise
}
```

### Bolts

```
public func request<T: ResponseCollectionSerializable>(method: Alamofire.Method, URLString: Alamofire.URLStringConvertible, type: T.Type, parameters: [String: AnyObject]? = nil, encoding: Alamofire.ParameterEncoding = .URL) -> BFTask {
    var task = BFTaskCompletionSource()
    Alamofire.request(method, URLString, parameters: parameters, encoding: encoding)
        .validate()
        .responseCollection { (request, response, collection: [T]?, error) in
            if let error = error {
                task.setError(error)
                return
            }
            if let object = collection {
                task.setResult(object as? AnyObject)
                return
            }
            task.setError(NSError()) //< TODO: unexpected error
        }
    return task.task
}
```

## 機能差分

| - | Genericなインターフェース | progress用インターフェース | cancel用インターフェース |
|:-----------|:-----------:|:------------:|:------------:|
| SwiftTask  | ⚪︎ | ⚪︎ | ⚪︎
| PromiseKit | ⚪︎ |   | 
| Bolts      |   |   | ⚪︎

この表はぼくが気にした点を抽出して書いたものですのでちょっと贔屓目に見えてしまうかも。。。

この他 [inamiyさんのこちらの記事](http://qiita.com/inamiy/items/0756339aee35849384c3) などにも機能差分がまとめられてます。

## まとめ

- どのライブラリも頻繁に更新されパワーアップしているので、どれを使っても大丈夫そうではある
- 個人的にはタスクを使うほうのインターフェースを一番すっきり書けるSwiftTaskが気に入った
- また、SwiftTaskには現時点でもprogressやcancel用のインターフェースが用意されているのでこれらが必要になっても困らない
- SwiftTask++

特にBoltsは本当に表面しか触ってみていませんので、Boltsのほうがココがすげーぞ！といったご指摘は大歓迎です！
