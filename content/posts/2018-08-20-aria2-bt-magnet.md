---
title: "解决 Aria2 无法下载 Bt 和磁力链接的问题"
slug: "Aria2-Bt-Magnet"
date:    2018-08-20T22:11:25+08:00
lastmod: 2018-08-20T22:11:25+08:00
tags: [
    "aria2",
    "magnet",
    "bitorrent",
    "BT"
]
categories: [
    "IT",
    "软件",
]

# contentCopyright: false
# reward: false
# mathjax: false
---
之前在一台 [3215U 的小主机上安装了 openwrt 和 aria2](/post/openwrt-guide/) ，后来发现 aria2 下载 BT 时速度很普通，且下载磁力链接时，速度基本上为0。后来，在网友的提示下，终于搞定了。特在这里记录一下。
<!--more-->

## 启用 DHT

aria2 默认没有启用 DHT 。如果启用了 DHT ，则会明显改善。

```bash
enable-dht=true
```



还可以自定义 dht 的监听端口：

```bash
dht-listen-port=60002
```

## 其他参数

我安装的 aria2 有些参数需要手工写，各参数之间以 `,`隔开：

```bash
dht-listen-port=60002,dht-file-path=/koolshare/aria2/aria2.dht,dht-file-path6=/koolshare/aria2/aria2.dht6,user-agent=uTorrent/2210(25130),peer-id-prefix=-UT2210-,save-session-interval=60,bt-remove-unselected-file=true,bt-enable-lpd=true,enable-peer-exchange=true,bt-request-peer-speed-limit=5M
```

