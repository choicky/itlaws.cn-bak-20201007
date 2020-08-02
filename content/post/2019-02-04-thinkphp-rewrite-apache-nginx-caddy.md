---
title: "Thinkphp在Apache、Nginx和Caddy的伪静态重写规则"
slug: "Thinkphp-Rewrite-Apache-Nginx-Caddy"
date:    2019-02-04T14:33:34+08:00
lastmod: 2019-02-04T14:33:34+08:00
tags: [
    "thinkPHP",
    "apache",
    "nginx",
    "caddy"
]
categories: [
    "IT",
    "软件",
]

# contentCopyright: false
# reward: false
# mathjax: false
---

#### 背景

我最近在寻找、尝试 [thinkphp](thinkphp.cn) 在 [nginx](nginx.org) 或者 caddy 下面的rewrite 重写规则。

我寻找了很久，一直没找到。只好自己读文档，解决了。

答案来之不易。特记在此，拿走不谢。<!--more-->

#### 起因

[thinkPHP](http://thinkphp.cn/) 是一个国产的PHP框架。

因为是PHP框架，所以其定义了一个统一的网站入口，导致页面的链接地址格式很复杂。

thinkPHP 提供了 `URL_MODEL`供用户设置URL格式，取值为0至3：

> 0 (普通模式); 1 (PATHINFO 模式); 2 (REWRITE  模式); 3 (兼容模式)  默认为PATHINFO 模式

如果设置了`URL_MODEL => 2`，在web服务器的配合下，网页的链接地址是最美观的。但是，这个过程，需要在 web 服务器上设置对应的 rewrite 重写规则。

#### Apache 的rewrite规则

apache 是老牌的web 服务器。我首次使用 apache 的时候，深圳的房价才一两千元/平方米。

在网站目录下放置 `.htaccess`文件，内容为：

```nginx
<IfModule mod_rewrite.c>
  Options +FollowSymlinks
  RewriteEngine On

  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteRule ^(.*)$ index.php/$1 [QSA,PT,L]
</IfModule>
```

其中：

第一行`RewriteCond %{REQUEST_FILENAME} !-d`表示针对于不是文件夹的情况，

第二行`RewriteCond %{REQUEST_FILENAME} !-f`表示不是文件的情况；

满足这两种情况的链接，就适用`RewriteRule`这条重写规则，`QSA`表示把参数自动附加到后面。

#### Nginx 的rewrite重写规则

Nginx 是后起之秀，我使用ngxin的时候，深圳的房价已经三四万一平方米了。

其配置方式吸取了 apache 的精华并做了一些简化。例如，nginx不需要指定`QSA`，因为nginx 本身就默认如此了。

nginx的重写规则就简单多了：

```nginx
    location / {
        try_files $uri $uri/ /index.php?s=$1;
    }
```



这规则的意思是：对于用户访问的链接地址，首先作为文件地址`uri`访问，如果文件不存在就作为目录`uri/`访问，如果还不满足就适配到`/index.php?s=$1`。

在这里，`$1`等效于`$uri`，所以，thinkphp在nginx 的重写规则也可以写为：

```nginx
    location / {
        try_files $uri $uri/ /index.php?s=$uri;
    }
```



#### caddy v1.0 系列的重写规则

caddy 是更年轻的web服务器。我使用caddy v1系列的时候，深圳房价已经五六万一平方米了。

caddy 的优点在于，能够自动申请ssl证书，从而使网站能启动https。

thinkphp在caddy的重写规则是：

```nginx
    rewrite {
        to {path} {path}/ /index.php?s={uri}
    }
```



#### caddy v2.0 系列的重写规则

caddy v2 系列的语法规则与 v1 系列有很大的差异。是更年轻的web服务器。我使用caddy v2系列的时候，深圳房价已经七八万一平方米了；昔日鸟不拉屎的西乡、福永、沙井成为了网红区域，房价代表了深圳的最高价。世事无常啊。

thinkphp在caddy的重写规则是：

```nginx
try_files {path} {path}/ /index.php?s={uri}
```

