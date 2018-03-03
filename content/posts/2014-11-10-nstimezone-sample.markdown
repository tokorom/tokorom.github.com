---
layout: post
title: "NSTimeZoneから取得できる表示用文字列のサンプル"
date: 2014-11-10
comments: true
external-url: 
categories: [ios,swift]
aliases: [/2014/11/10/nstimezone-sample/]
---

さっき、画面上に現在設定されているTime Zoneを表示するって機能を実装していたのですが、NSTimeZoneからどういう文字列が取れるかのサンプルが意外と見つからなかったのでメモします。

## abbreviation

```
GMT+9
```

## name

```
Asia/Tokyo
```

## description

```
Asia/Tokyo (GMT+9) offset 32400
```

## localizedName(_:locale:)

| NSLocale | NSTimeZoneNameStyle  | 出力結果
|:-|:-|:-|
| en_US | Standard  | **Japan Standard Time**
| en_US | ShortStandard  | **GMT+9**
| en_US | DaylightSaving  | **Japan Daylight Time**
| en_US | ShortDaylightSaving  | **GMT+9**
| en_US | Generic  | **Japan Standard Time**
| en_US | ShortGeneric  | **Japan Time**
| ja_JP | Standard  | **日本標準時**
| ja_JP | ShortStandard  | **JST**
| ja_JP | DaylightSaving  | **日本夏時間**
| ja_JP | ShortDaylightSaving  | **JDT**
| ja_JP | Generic  | **日本標準時**
| ja_JP | ShortGeneric  | **JST**

## 上記を試したコード

```
let timeZone = NSTimeZone.systemTimeZone()

println("#### abbreviation, \(timeZone.abbreviation)")
println("#### name, \(timeZone.name)")
println("#### description, \(timeZone.description)")

let en = NSLocale(localeIdentifier: "en_US")
println("#### Standard, \(timeZone.localizedName(.Standard, locale: en))")
println("#### ShortStandard, \(timeZone.localizedName(.ShortStandard, locale: en))")
println("#### DaylightSaving, \(timeZone.localizedName(.DaylightSaving, locale: en))")
println("#### ShortDaylightSaving, \(timeZone.localizedName(.ShortDaylightSaving, locale: en))")
println("#### Generic, \(timeZone.localizedName(.Generic, locale: en))")
println("#### ShortGeneric, \(timeZone.localizedName(.ShortGeneric, locale: en))")

let ja = NSLocale(localeIdentifier: "ja_JP")
println("#### Standard, \(timeZone.localizedName(.Standard, locale: ja))")
println("#### ShortStandard, \(timeZone.localizedName(.ShortStandard, locale: ja))")
println("#### DaylightSaving, \(timeZone.localizedName(.DaylightSaving, locale: ja))")
println("#### ShortDaylightSaving, \(timeZone.localizedName(.ShortDaylightSaving, locale: ja))")
println("#### Generic, \(timeZone.localizedName(.Generic, locale: ja))")
println("#### ShortGeneric, \(timeZone.localizedName(.ShortGeneric, locale: ja))")
```
