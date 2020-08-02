---
title: "Caddy V2 Caddyfile 配置"
slug: "Caddy-V2-Caddyfile"
date:    2020-07-31T09:19:26+08:00
lastmod: 2020-07-31T09:19:26+08:00
tags: [
    "caddy",
    "2020年",
]
categories: [
    "IT",
    "软件"
]

# contentCopyright: false
# reward: false
# mathjax: false
---
Caddy web服务器曾经以自动启用https、配置简单为卖点，caddy v1 深受欢迎；官方顺势退出 v2 系列，v2系列成功地把“配置简单”这个优点给去掉了，v1系列的Caddyfile文件不能直接用到v2系列。

官方最近已经完全取缔了 v1，因此，只能硬着头皮在[ubuntu安装上 v2](/post/ubuntu-caddy-v2-installation/)，最近觉得 v2 能替代 v1了，特为此篇。

<!--more-->

### Caddyfile 的架构

参考官方教程[Caddyfile Concepts](https://caddyserver.com/docs/caddyfile/concepts#caddyfile-concepts)， Caddy v2.0 系列，Caddyfile的架构为：

```nginx
## 全局参数
{
    ...
}

## 站点1
example1.com {
    ...
}

## 站点2
example2.com {
    ...
}
```

其中，全局参数定义一些对各个站点都使用的参数，可用的参数详见官方教程[Global options](https://caddyserver.com/docs/caddyfile/options)。

### Caddyfile 的指令、匹配器、参数

caddy v2 系列中，支持PHP的Caddyfile内容如下：

```nginx
example1.com {

    # 压缩数据，可选
    encode zstd gzip

    # web
    root * /var/www/example1.com
    file_server

    # php
    php_fastcgi unix//run/php/php-fpm.sock
}
```

总体上，大括号`{}`里面的格式是`指令 匹配器 参数`的格式。

上面的`encode`、`root`、`file_server`和`php_fastcgi`都是指令，更多的指令详见官方的[Caddyfile Directives](https://caddyserver.com/docs/caddyfile/directives#caddyfile-directives)。

上面的`root * /var/www/example1.com`的`*`就是匹配器，表示一律适用。

通常情况下，`匹配器`是可用可不用的；如果匹配器为`*`或者省略了匹配器，则理解为一律适用，例如`php_fastcgi unix//run/php/php-fpm.sock`省略了匹配器，表示将一切交给`php-fpm.sock`处理。匹配器有三种，详见官方的[Matchers](https://caddyserver.com/docs/caddyfile/concepts#matchers)。

参数是指令的参数用于限定指令的具体执行。上面的`encode zstd gzip`中，`zstd`和`gzip`都是参数，表示两种可用的压缩算法。

### Thinkphp 3.2.3 的Caddyfile

我更新了[Thinkphp在Apache、Nginx和Caddy的伪静态重写规则](/post/thinkphp-rewrite-apache-nginx-caddy/)，把Caddy v2 系列的也写进去了。

caddy v2 系列中，支持PHP的Caddyfile内容如下：

```nginx
example.com {

    # encode
    encode zstd gzip

    # web
    root * /var/www/example.com
    try_files {path} {path}/ /index.php?s={uri}
    file_server

    # php
    php_fastcgi unix//run/php/php-fpm.sock
}
```



### Caddy v2 系列 php 、try_files与 reverse_proxy 共存

现在很多node程序都单独提供服务，例如博客程序 [ghost](https://ghost.org/) 以`localhost:port`的方式提供服务，这时候就需要caddy用`reverse_proxy`指令搭配，俗称`反代`或者`反向代理`。而同时，可能还存在需要caddy支持PHP的情况，例如，我使用 thinkphp 的程序需要用到   `php_fastcgi` 以及 `try_files`。  这时候就需要协调好该三个指令，以免发生冲突。这种协调一方面通过`匹配器`，另一方面通过调整指令的执行顺序。

调整指令的执行顺序，有两种办法，一种是将各种指令按照你想要的执行顺序放到`route`中，详见官网的[route](https://caddyserver.com/docs/caddyfile/directives/route)文档。另一种办法就是在`Caddyfile`的全局参数中用`order`指令定义。

我用到的主要是 `order`，用于定义`reverse_proxy`指令 与 `try_files`指令的执行顺序，以避免冲突，例如：

```nginx
# shift reverse_proxy before try_files
{
    order reverse_proxy first
}

## 站点1
example1.com {
    ...
}

## 站点2
example2.com {
    ...
}
```

之所以要定义这个顺序，是因为Caddy[默认的指令优先顺序https://caddyserver.com/docs/caddyfile/directives#directive-order](https://caddyserver.com/docs/caddyfile/directives#directive-order)与我想要的有点差异。

```nginx
# 将 reverse_proxy 的优先级提到 try_files 之前；或者提到最前
{
    order reverse_proxy first
}

example.com {

    # 压缩算法
    encode zstd gzip

    # 网站基本设置，其中的 try_files 是针对 thinkphp 3.2.3 的重写/rewrite 
    root * /var/www/example.com
    try_files {path} {path}/ /index.php?s={uri}
    file_server

    # 将 /blog 交给后端程序10000端口处理， 常规方式
    reverse_proxy /blog localhost:10086

    # 将 /h2c_matcher 交给后端程序10000端口处理， h2c 的方式
    reverse_proxy /h2c_matcher  http://localhost:10000 {
        transport http {
            versions h2c 2
        }
    }

    # 将 /websocket_matcher 交给后端程序10010端口处理， websocket 的方式
    @websocket_matcher {
        header Connection *Upgrade*
        header Upgrade    websocket
    }
    reverse_proxy @websocket_matcher localhost:10010

    # 将其他交给 php 处理
    php_fastcgi unix//run/php/php-fpm.sock
}
```

