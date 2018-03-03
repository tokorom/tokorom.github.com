---
layout: post
title: "Storyboardでの画面遷移をスマートにやる方法"
date: 2014-04-12
comments: true
external-url: 
tags: [ios, objc]
aliases: [/2014/04/12/improve-storyboard-segue/]
---

これは [potatotips第６回め](http://connpass.com/event/5803/) で発表した [この話](https://speakerdeck.com/tokorom/e-storyboardshi-tuterufalsenisonnahua-mian-qian-yi-falsesikatasiterufalsedesuka) のまとめと後書きです。

{% img center http://dl.dropbox.com/u/10351676/images/storyboard_sample.png %}

## Storyboardいいですよね！

Storyboardを使うことで、

- 画面と画面が疎結合になる
- 簡単な画面遷移ならノンコーディングで実現できてソースコードを汚さない

といったメリットがあります。

Storyboard登場以前だと、次の画面に遷移させるだけでも

```objective-c
#import "NextViewController.h"

NextViewController *nextViewController = [NextViewController new];
[self.navigationController pushViewController:nextViewController animated:YES];
```

といったコーディングをし、遷移元のViewControlelrは遷移先のViewControllerに依存する（`import`しないといけない）形でした。

しかし、Storyboardを活用することで画面遷移のために画面同士が密結合になることを避けることができるようになりました。

## ただしStoryboardを使って今まで以上に悪くなるパターンがある

とはいえ、Storyboardも完璧ではなく、画面遷移時に次の画面になにか値を渡したいときにはこんな実装をする必要があります。

<!-- more -->

```objective-c
#import "NextViewController.h"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NextViewController *nextViewController = (NextViewController *)segue.destinationViewController;
    nextViewController.number = @1;
    [self.navigationController pushViewController:nextViewController animated:YES];
}
```

要するにStoryboard登場以前のコードに逆戻りです。  
そして、この画面遷移時に値を渡すだけのためにpublicメソッドを公開しないといけない場合もあります。

もっとひどいのは１つの画面から複数の画面に遷移させたい場合で、もはやぐちゃぐちゃになりStoryboard使ってむしろ複雑になってるとも思えてしまうほどです。

```objective-c
#import "NextViewController.h"
#import "ModalViewController.h"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"Next" isEqualToString:segue.identifier]) {
        NextViewController *nextViewController = (NextViewController *)segue.destinationViewController;
        nextViewController.number = @1;
        [self.navigationController pushViewController:nextViewController animated:YES];
    } else if ([@"Modal" isEqualToString:segue.identifier]) {
        ModalViewController *modalViewController = (ModalViewController *)segue.destinationViewController;
        modalViewController.number = @2;
        [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
    }
}
```

## ほんとうはこんな感じに書きたい！！

せっかくStoryboard使っているのにこんな形で画面遷移先のViewControllerに依存してコードがぐちゃぐちゃになるのは耐えられません。

ほんとうはこんな感じに書きたいのです！！

-  遷移先に渡したい値を渡すだけ

```objective-c
[self performSegueWithIdentifier:@"Modal" options:@1];
```

-  遷移先で値を受け取るときも簡単に

```objective-c
self.label.text = self.segueOptions.stringValue; //< 遷移元で渡した @"1" が取得できる
```

## これを実現できるライブラリがあります

ということで本題ですが、 [TKRSegueOptions](https://github.com/tokorom/TKRSegueOptions) でこれが実現できます。

これをインストールして `#import "TKRSegueOptions.h"` とするだけで上の書き方が実現できちゃいます。

他にも、

- 複数の値をDictionary形式で渡したい

```objective-c
// 遷移元
NSDictionary *options = @{
    @"url": self.url,
    @"shop": self.shop,
};
[self performSegueWithIdentifier:@"Modal" options:options];

// 遷移先
NSURL *url = self.segueOptions[@"url"];
```

- もっとかっちりしたクラスで値を渡したい

```objective-c
// 遷移元
CustomSegueOption *option = [CustomSegueOption new];
option.number = @888;
option.string = @"hello";
[self performSegueWithIdentifier:@"Modal" options:option];

// 遷移先
CustomSegueOption *option = (CustomSegueOption *)presentedViewController.segueOptions;
NSLog(@"number: %@, string: %@", option.number, option.string);
```

といったことも柔軟にできてしまいます。

## その他、地味に便利なところ

また、ふつうにやると遷移先がナビゲーションコントローラだったりタブバーコントローラだったりすると、その子要素に値を渡すのが意外と面倒だったりしませんか？

{% img center http://dl.dropbox.com/u/10351676/images/storyboard_navigation.png %}

遷移先がナビゲーションバーコントローラかどうか調べて、そうならその配下のViewControllerを取得して、それが想定するViewControllerならこの値を渡す、といった面倒な手順があります。

そんなケースでも `TKRSegueOptions` は気にすることはありません。いつもどおり、

```objective-c
[self performSegueWithIdentifier:@"Navigation" options:@"hello"];
```

と書けば、遷移先がナビゲーションコントローラなら自動的にrootViewControllerまで値を渡してくれますし、タブバーコントローラなら配下の子ViewController全てに値を配布してくれます。地味に便利です。

## `performSegue` できないところはどうするの？

なお、ここまでは `performSegue` をするときに一緒に値を渡すやりかただけ紹介しましたので、performSegueが使えないパターン、例えばContainer Viewを使ってViewControllerに子ViewControllerを埋め込むときはどうするの？という疑問がでてきます。

{% img center http://dl.dropbox.com/u/10351676/images/storyboard_embed.png %}

じつは `TKRSegueOptions` はperformSegue方式の他に「事前設定方式」を備えています。

具体的には、`- (TKRSegueOptionSetting \*)segueOptionSetting` という決まったメソッドをオーバーライドして設定を返すだけです。

```objective-c
- (TKRSegueOptionSetting *)segueOptionSetting
{
    __weak typeof(self) wself = self;
    return [TKRSegueOptionSetting settingWithDictionary:@{
        @"Embed1": ^{
            return wself.leftLabel.text;
        },
        @"Embed2": ^{
            return wself.rightLabel.text;
        },
    }];
}
```

この設定はDictionary形式でkeyにSegueのidentifierを指定し、valueに遷移先の画面に渡したい値を返すBlockを指定します。
このBlockは実際に画面遷移が行われるときに実行されますので、指定した画面遷移が発生するまで無駄にこれらの処理が実行されることはありませんし、その瞬間の最新の値が返るので安心して利用できます。

場合によっては performSegue方式を使わずにこちらで全て統一するという運用も良いかもしれません。

## まとめ

- Storyboardはすごく便利!
- しかし画面遷移先に値を渡すときに汚くなりがち
- `TKRSegueOptions` を使うと値を渡したいときもスマートにできる
