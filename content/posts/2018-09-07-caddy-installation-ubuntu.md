---
title: "在 Ubuntu 中安装 Caddy Server"
slug: "Caddy-Installation-Ubuntu"
date:    2018-09-07T21:28:14+08:00
lastmod: 2018-09-07T21:28:14+08:00
tags: [
    "caddy",
    "ubuntu",
    "https",
]
categories: [
    "IT",
    "软件",
]

# contentCopyright: false
# reward: false
# mathjax: false
---

[Caddy](https://caddyserver.com/) 是一个新兴的web服务器。它的优点有两个：

* 自动 https ；

* 配置简单。

下面记录一下在 Ubuntu （或者其他支持 systemd 的 Linux） 安装 caddy server 的过程。<!--more-->



## 安装 curl

```bash
sudo apt install curl
```

## 安装 caddy server

```bash
sudo curl https://getcaddy.com | bash -s personal http.forwardproxy
sudo chown root:root /usr/local/bin/caddy
sudo chmod 755 /usr/local/bin/caddy
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy
```

其中，`personal`表示个人使用，`http.forwardproxy`是可选的、附带安装的插件。

## 基本配置

```bash
sudo groupadd -g 33 www-data
sudo useradd \
  -g www-data --no-user-group \
  --home-dir /var/www --no-create-home \
  --shell /usr/sbin/nologin \
  --system --uid 33 www-data
sudo mkdir /etc/caddy
sudo chown -R root:www-data /etc/caddy
sudo mkdir /etc/ssl/caddy
sudo chown -R root:www-data /etc/ssl/caddy
sudo chmod 0770 /etc/ssl/caddy
sudo touch /etc/caddy/Caddyfile
sudo chown -R www-data:www-data /etc/caddy
sudo chmod 444 /etc/caddy/Caddyfile
sudo mkdir /var/www
sudo chown -R www-data:www-data /var/www
sudo chmod 555 /var/www
sudo mkdir /var/log/caddy
sudo touch /var/log/caddy/access.log
sudo touch /var/log/caddy/errors.log
sudo chown -R www-data:www-data /var/log/caddy
sudo mkdir /var/www/example.com
sudo chown -R www-data:www-data /var/www/example.com
sudo chmod -R 555 /var/www/example.com
```

其中，`/etc/caddy/Caddyfile`是配置文件，`/var/www/example.com`是某个示范网站的根目录。

## 将 caddy 安装为系统服务（systemd service）

```bash
sudo wget -P /etc/systemd/system/ \
https://raw.githubusercontent.com/mholt/caddy/master/dist/init/linux-systemd/caddy.service
sudo chown root:root /etc/systemd/system/caddy.service
sudo chmod 644 /etc/systemd/system/caddy.service
sudo systemctl daemon-reload
sudo systemctl start caddy.service
sudo systemctl enable caddy.service
```

## 定时更新 caddy

通过 `crond`服务定时更新。

```bash
sudo crontab -e
```

在文件的末尾加上：

```bash
34 4 * * * curl https://getcaddy.com | bash -s personal http.forwardproxy && service caddy restart
```

每天凌晨4点34检查更新。