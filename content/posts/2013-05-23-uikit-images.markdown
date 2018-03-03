---
layout: post
title: "UIKitで使われている画像パーツをまとめて取得する"
date: 2013-05-23
comments: true
external-url: 
tags: [ios, objc]
aliases: [/2013/05/23/uikit-images/]
---

## UIKitで使われている画像はどこにある？

例えば、UIAlertViewのアラートの画像ってどういう構成になってる？とかUISegmentedControlのAppearance変えたいんだけど当てはめる画像はどう作る？などというときにUIKitが標準で使っている画像パーツを参照できると便利です。  

プログラマというか特にはデザイナさんにとって有用だと思います。  


その画像パーツですが、Xcode（iOSシミュレータ）の中に入っているのでそこから抜くのが手っ取り早いです。  
具体的には（これはiOS6.1の場合）、

``` sh
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.1.sdk/System/Library/Frameworks/UIKit.framework/Shared@2x.artwork
```

が画像パーツを含むファイルになります。

他にも、同じディレクトリに

* Shared.artwork
* Shared@2x~ipad.artwork
* Shared@2x~iphone.artwork
* Shared~ipad.artwork
* Shared~iphone.artwork

がありますので取りたいものに応じてお好みで。

ひとまず、

``` sh
cp /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.1.sdk/System/Library/Frameworks/UIKit.framework/Shared@2x.artwork ~/Desktop/
```

などでこのファイルをデスクトップにでもコピーしておきましょう。

## artworkから画像ファイルを抽出

で、artworkから肝心の画像ファイルを抽出するのに、 [iOS-artwork](git://github.com/davepeck/iOS-artwork.git) というやつを使わせてもらいます。

まずは、これを

<!-- more -->

``` sh
git clone git://github.com/davepeck/iOS-artwork.git
```

などでダウンロードします。

ただ、これを使うには`Python`と`PIL`というライブラリが必要です。  
たぶん`Python`は元から入っていると思うので、`PIL`のほうをbrewなどでインストールします。

``` sh
brew install pil
```

インストールし終わったら

``` sh
mkdir ~/Desktop/UIKitParts
./iOS-artwork.py export -a ~/Desktop/Shared@2x.artwork -d ~/Desktop/UIKitParts
```

と先ほどダウンロードしたiOS-artworkを実行するわけですが、おそらくここで、

``` sh
Traceback (most recent call last):
  File "./iOS-artwork.py", line 32, in <module>
    import PIL
ImportError: No module named PIL
```

と怒られると思います。インストールしたはずのPILが見つからないとのこと。そのため、

``` sh
export PYTHONPATH=/usr/local/Cellar/pil/1.1.7/lib/python2.7/site-packages 
```

としてPILの場所をPythonに教えてあげます（brew以外でインストールした人はディレクトリをその場所に置き換えてください）。

気を取り直して、

``` sh
./iOS-artwork.py export -a ~/Desktop/Shared@2x.artwork -d ~/Desktop/UIKitParts
```

を実行すれば、デスクトップの`UIKitParts`というディレクトリにUIKitの画像一式がもりもりと出力されていくはずです！

ぼくの手元では、

{% img center http://dl.dropbox.com/u/10351676/images/UIKitParts.png %}

こんなかんじで取得できました。


