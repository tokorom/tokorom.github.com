---
layout: post
title: "Macにpandocをインストール中にhs-httpで引っかかった"
date: 2012-07-15 03:13
comments: true
categories: [mac]
---

## hs-httpがインストールできない!

Macにpandocを入れようと気軽にMacPortsで

``` sh
$ sudo port install pandoc
```

したところ *hs-http* のインストールのところでなにやらエラー...

試しに *hs-http* だけインストールしてみたところ、

``` sh
$ sudo port -d install hs-http
  ...
  Configuring HTTP-4000.1.1...
  ghc: could not execute: /usr/bin/gcc-4.2
  Command failed:  cd "/opt/local/var/macports/build/_opt_local_var_macports_sources_rsync.macports.org_release_ports_devel_hs-HTTP/hs-http/work/HTTP-4000.1.1" && runhaskell Setup co
  nfigure --prefix=/opt/local --with-compiler=/opt/local/bin/ghc 
  Exit code: 1
  Error: org.macports.configure for port hs-http returned: configure failure: command execution failed
  DEBUG: Error code: NONE
  DEBUG: Backtrace: configure failure: command execution failed
      while executing
  "$procedure $targetname"
  Warning: targets not executed for hs-http: org.macports.activate org.macports.configure org.macports.build org.macports.destroot org.macports.install
  Please see the log file for port hs-http for details:
      /opt/local/var/macports/logs/_opt_local_var_macports_sources_rsync.macports.org_release_ports_devel_hs-HTTP/hs-http/main.log
  To report a bug, follow the instructions in the guide:    http://guide.macports.org/#project.tickets
  Error: Processing of port hs-http failed
```

と、*gcc-4.2* が実行できないというエラーが発生している。  

## gcc-4.2 を用意する

それではと gcc-4.2 が入っているか見てみたところ、

``` sh
$ ll /usr/bin/gcc*
  lrwxr-xr-x  1 root  wheel  12 12  4  2011 /usr/bin/gcc -> llvm-gcc-4.2
```

と *llvm-gcc-4.2* はあるものの *gcc-4.2* はない模様。  
それでは *gcc-4.2* を入れましょうと、

``` sh
$ sudo port install gcc42
```

としてみたものの、Snow Leopard以降にはインストールできないという冷たいお返事。
それならそれで、 *gcc-4.2* を *llvm-gcc-4.2* にリンクして使っちゃうことにします。

``` sh
$ sudo ln -s /usr/bin/llvm-gcc-4.2 /usr/bin/gcc-4.2
```

## pandocのインストール

これで晴れて *gcc-4.2* が存在することになりましたので、

``` sh
$ sudo port -d install hs-http
```

がばっちり成功しました!
もちろんそもそものpandocも、

``` sh
$ sudo port install pandoc
```

で普通にインストールできましたとさ。

