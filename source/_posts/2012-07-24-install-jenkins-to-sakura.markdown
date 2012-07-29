---
layout: post
title: "さくらVPSにJenkinsさんをインストールする"
date: 2012-07-24 02:57
comments: true
external-url: 
categories: [sakura, jenkins]
---

## JDKのインストール

Javaが未インストールならこちらから。
```
$ sudo yum install java-1.6.0-openjdk java-1.6.0-openjdk-devel
```

## Jenkinsのインストール

基本的に [公式ページ](http://pkg.jenkins-ci.org/redhat/) に書いてあるとおりにするだけ。
```
$ sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
$ sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
$ sudo yum install jenkins
```

<!-- more -->

## Jenkinsの起動
```
$ sudo service jenkins start
```
これでインストールと起動が完了。簡単すぎる！

試しに
```
$ curl http://localhost:8080/
```
とすると、 
``` html
<!DOCTYPE html><html><head> <title>Dashboard [Jenkins]</title>...
```
みたいなHTMLが出力されてJenkinsさんが動いているのを確認できるはず。

ついでにサーバ再起動時にJenkinsさんが自動で起動するようにしておく。
```
$ sudo chkconfig jenkins on 
```

## nginxの設定

まず、nginxが未インストールなら
```
$ sudo yum install nginx
```
でインストールしておく。

Jenkinsにnginx経由でアクセスするために、自分の場合は **/etc/nginx/conf.d/virtual.conf** に以下リバースプロキシの設定を加えた。
```
server {
    listen 80;
    server_name jenkins.自分の.ドメイン
    location / {
        proxy_pass http://localhost:8080;
    }
}
```
ここでは、 *http://jenkins.自分の.ドメイン/* でアクセスされたら、 *http://localhost:8080/* に内部的に転送するよう設定している。
もし、独自ドメインを使えない場合には、
```
server {
    listen 80;
    server_name 自分のVPSのドメイン
    location /jenkins {
        proxy_pass http://localhost:8080;
    }
}
```
のように設定して、 *http://自分のVPSのドメイン/jenkins/* でアクセスされたときにJenkinsさんに繋がるようにしたりするよう。

設定し終わり、nginxを再起動してブラウザで **http://jenkins.自分の.ドメイン/* を表示すれば、晴れて

![install-jenkins](http://dl.dropbox.com/u/10351676/images/install-jenkins.jpg)

のようにJenkinsさんが使えるようになっているはず。

## Jenkinsへのアクセス制限

ちなみにこのままだと誰からでもジョブなどが作成できてしまう状態のため、

[Standard Securiy Setup](https://wiki.jenkins-ci.org/display/JA/Standard+Security+Setup)

を参照してアクセス制限をかけておくことを推奨。

