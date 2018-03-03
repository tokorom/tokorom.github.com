---
layout: post
title: "提供するXXXViewControllerの親クラスを差し替え可能にしたい!"
date: 2014-01-23
comments: true
external-url: 
categories: [objc,ios]
aliases: [/2014/01/23/super-viewcontroller-for-a-library/]
---

## XXXViewControllerの親クラスを差し替えたいときありますよね？

UIKit内で言えば`UITableViewController`とかはその代表格。  
外部ライブラリで言うと、Google Analytics SDKの`GAITrackedViewController`とか。  

要するに、XXXViewControllerの継承して実現したい機能があるのに、既にYYYViewControllerのサブクラスなので使えないよーとなってしまうケース。

で、既存のものは置いておくとしても、自分が作るライブラリのXXXViewControllerについては、なんとかその親クラス差し替えの需要に応えられないものかなあと。

## runtime使う?

いちおう `class_setSuperclass`という関数があるのですがDeprecated...
なんか良い方法ないかな？と考えた結果、今のところ以下のかんじに落ち着きました。

<!-- more -->

## define!

後から動的に差し替えるってのは `class_setSuperclass` がDeprecatedな時点で諦めるとして、だとするとコンパイル前に差し替えるしかないよねと。

例えば、こんなかんじでどうでしょう？

```objective-c
#ifdef XXXLIB_VIEW_CONTROLLER_IMPORT
#import XXXLIB_VIEW_CONTROLLER_IMPORT
#endif

#ifdef XXXLIB_VIEW_CONTROLLER_SUPER_CLASS
@interface TKRContainerTableViewController : XXXLIB_VIEW_CONTROLLER_SUPER_CLASS
#else
@interface TKRContainerTableViewController : UIViewController
#endif

// ...

@end
```

ふつうに使うぶんには `XXXLIB_VIEW_CONTROLLER_IMPORT` も `XXXLIB_VIEW_CONTROLLER_SUPER_CLASS` も定義されていないので普通に`UIViewController`がsuperclassになります。

もしsuperclass変えたいよ！って人は、

```objective-c
#define XXXLIB_VIEW_CONTROLLER_IMPORT "YourSuperViewController.h"
#define XXXLIB_VIEW_CONTROLLER_SUPER_CLASS YourSuperViewController
```

とどこかで定義してやればsuperclassが`YourSuperViewController`になるイメージです。  
ひとまずこれでなんとかなりそう。

他に良い方法があればご教示を！

