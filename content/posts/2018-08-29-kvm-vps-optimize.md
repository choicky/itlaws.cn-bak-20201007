---
title: "kvm 架构的 vps 优化"
slug: "Kvm-Vps-Optimize"
date:    2018-08-29T17:29:41+08:00
lastmod: 2018-08-29T17:29:41+08:00
tags: [
    "kvm",
    "vps",
    "优化",
]
categories: [
    "IT",
    "软件",
]

# contentCopyright: false
# reward: false
# mathjax: false
---
vps （虚拟的私人服务器）的网络性能与其优化程度有关。经过优化的 vps ，网速可能会提高几倍。

根据不同的虚拟技术，vps 包括 ovz 、kvm 等多个架构。本篇记录一下 kvm 架构下安装 ubuntu 系统的 vps 使用的优化方案。



## 启用 bbr

bbr 是 Google 研发的一种网络传输算法。

秋水逸冰写了一个[开启 bbr 的脚本](https://teddysun.com/489.html)，使用方法如下：<!--more-->

```bash
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && sudo bash bbr.sh
```



如果一切正常，`/etc/sysctl.conf` 文件会存在如下两行内容：

```bash
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
```



## 内核参数优化

下面的优化参数，主要参考 [iMeiji 的优化文章](https://github.com/iMeiji/shadowsocks_install/wiki/shadowsocks-optimize)。

通过 `sudo nano /etc/sysctl.conf` 打开文件，写入如下内容：

```bash
# max open files
fs.file-max = 1024000
# max read buffer
net.core.rmem_max = 67108864
# max write buffer
net.core.wmem_max = 67108864
# default read buffer
net.core.rmem_default = 65536
# default write buffer
net.core.wmem_default = 65536
# max processor input queue
net.core.netdev_max_backlog = 4096
# max backlog
net.core.somaxconn = 4096

# resist SYN flood attacks
net.ipv4.tcp_syncookies = 1
# reuse timewait sockets when safe
net.ipv4.tcp_tw_reuse = 1
# turn off fast timewait sockets recycling
net.ipv4.tcp_tw_recycle = 0
# short FIN timeout
net.ipv4.tcp_fin_timeout = 30
# short keepalive time
net.ipv4.tcp_keepalive_time = 1200
# outbound port range
net.ipv4.ip_local_port_range = 10000 65000
# max SYN backlog
net.ipv4.tcp_max_syn_backlog = 4096
# max timewait sockets held by system simultaneously
net.ipv4.tcp_max_tw_buckets = 5000
# TCP receive buffer
net.ipv4.tcp_rmem = 4096 87380 67108864
# TCP write buffer
net.ipv4.tcp_wmem = 4096 65536 67108864
# turn on path MTU discovery
net.ipv4.tcp_mtu_probing = 1

# forward ipv4
net.ipv4.ip_forward = 1

# turn on TCP Fast Open on both client and server side
net.ipv4.tcp_fastopen = 3
```

## 文件句柄数量优化

通过 `sudo nano /etc/security/limits.conf` 加入如下内容：

```bash
* soft  nofile  512000
* hard  nofile  1024000
```

其中， hard 是系统总得打开的文件句柄数量，系统的默认值是内存大小（以K计算）的10%，该比例可上调。 soft 是某个进程打开的文件句柄数量。


运行 ``sysctl -p` ` 或者重启系统使其生效。