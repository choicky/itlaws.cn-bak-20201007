---
title: "Ubuntu安装Caddy V2"
slug: "Ubuntu-Caddy-V2-installation"
date:    2020-06-14T00:19:01+08:00
lastmod: 2020-06-14T00:19:01+08:00
tags: [
    "caddy",
    "ubuntu",
    "2020年",
]
categories: [
    "IT",
    "软件",
]

# contentCopyright: false
# reward: false
# mathjax: false
---

### 序

caddy官方目前在主推v2系列。v2系列与之前的v1系列差异很大，之前写的[在 Ubuntu 中安装 Caddy Server](/post/caddy-installation-ubuntu/)已经不适用了。

所以重写一篇，记录caddy v2.0 的安装与配置。<!--more-->

如果是从caddy v1.0 升级到 v2.0，可直接看官方的 [upgrade guide](https://caddyserver.com/docs/v2-upgrade)。

### 安装

```bash
echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" \
    | sudo tee -a /etc/apt/sources.list.d/caddy-fury.list
sudo apt update
sudo apt install caddy
```

上面的命令安装完之后，caddy会安装到`/usr/bin/caddy`，而之前v1.0系列默认安装到`/usr/local/bin/caddy`，这里也会导致很多坑。默认使用的配置文件依然是`/etc/caddy/Caddyfile`，但语法已经改变了，所以依然很多坑。

此外，https/ssl的证书的存放路径，也由之前的`/etc/ssl/caddy`变到了`/var/lib/caddy`。

### 配置

#### caddy.service

早期的 caddy v1.0脚本，默认以 `www-data`用户运行 caddy；但是，caddy v2.0默认以`caddy`用户运行caddy，这会导致很多坑，例如与`PHP`配合时会提示`permission denied`等。

所以，还是以`www-data` 运行caddy比较好。需要修改配置文件`caddy.service`：

```bash
sudo nano /lib/systemd/system/caddy.service
```

将其中的

```bash
[Service]
User=caddy
Group=caddy
```

改为

```bash
[Service]
User=www-data
Group=www-data
```

修改之后，`caddy.service`内容为：

```bash
[Unit]
Description=Caddy
Documentation=https://caddyserver.com/docs/
After=network.target

[Service]
User=www-data
Group=www-data
ExecStart=/usr/bin/caddy run --environ --config /etc/caddy/Caddyfile
ExecReload=/usr/bin/caddy reload --config /etc/caddy/Caddyfile
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
```

修改之后，需要重载，并需要修正文件/文件夹的权限。

```bash
sudo groupadd -g 33 www-data
sudo useradd \
  -g www-data --no-user-group \
  --home-dir /var/www --no-create-home \
  --shell /usr/sbin/nologin \
  --system --uid 33 www-data
sudo mkdir /var/log/caddy
sudo touch /var/log/caddy/access.log
sudo touch /var/log/caddy/common_log  
sudo chown -R www-data:www-data /var/lib/caddy/
sudo chown -R www-data:www-data /etc/caddy/
sudo chown -R www-data:www-data /var/log/caddy/
sudo systemctl daemon-reload
sudo systemctl restart caddy
sudo systemctl enable caddy
```

#### Caddyfile

caddy v2系列的配置文件与v1有了较大的变化，常见的变化可参考官方的 [upgrade guide](https://caddyserver.com/docs/v2-upgrade)。

目前，我使用的是：

```bash
example.com {

    ## log
    log {
	output file         /var/log/caddy/access.log
	format single_field /var/log/caddy/common_log
    }

    # encode
    encode zstd gzip

    # web root.
    root * /var/www/example.com

    # Enable the static file server.
    file_server

    # websocket proxy to backend 45232
    @example_websocket_proxy {
        path /example_ws_path
        header Connection Upgrade
        header Upgrade websocket
    }
    reverse_proxy @example_websocket_proxy localhost:45232

    # serve a PHP site through php-fpm:
    #  php_fastcgi localhost:9000
    php_fastcgi unix//run/php/php-fpm.sock
}
# Refer to the Caddy docs for more information:
# https://caddyserver.com/docs/caddyfile

```



caddy v1.0 系列支持`http/2`代理（也称`h2c`或`h2`），但v2.0目前却缺乏这方面的支持。不知何时才能支持。

