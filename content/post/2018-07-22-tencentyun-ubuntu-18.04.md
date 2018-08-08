---
date: 2018-07-22
lastmod: 2018-07-22
title: "腾讯云安装Ubuntu 18.04"
slug: "tencentyun-ubuntu-18.04"
autoCollapseToc: true
tags: [
    "tencentyun",
    "CVM",
    "ubuntu",
    "18.04"
]
categories: [
    "IT",
    "VPS",
]
---

Ubuntu 18.04 已经出来几个月了，但腾讯云服务器CVM 依然使用Ubuntu 16.04，没有更新。

腾讯云支持VNC连接，从而为我们通过网络安装Ubuntu 18.04提供可能。

## VNC 连接

VNC 连接，相当于用户在坐在云服务器前面，通过键盘实际操作服务器。

VNC 连接的具体操作，见 [[经验分享] 介绍云服务器的VNC方式登录](http://bbs.qcloud.com/thread-47908-1-1.html)。

## 先安装Ubuntu 16.04并找到网卡配置信息和 nameserver 信息

在`/etc/network/interfaces`或者`/etc/network/interfaces.d`下面的文件中，找到IP address，netmask，gw三种信息。

在`/etc/resolv.conf`里面找到 nameserver 信息。

这几个信息，以后很可能会用到。

<!--more-->

## 安装 Ubuntu 18.04 的思路

主要思路是，下载能够网络安装Ubuntu 18.04的引导文件，修改现有Ubuntu的启动信息，进入该引导文件。详细的过程见[服务器安装全新 Ubuntu 18.04](https://i-meto.com/netboot-ubuntu-18-04/)。

### VNC 可能会断开连接

这种情况，不要慌，刷新网页之后，通常就会重新连接上了。

为了应对该种情况，修改` /etc/default/grub`文件时，要把`GRUB_TIMEOU`设为足够长，例如`GRUB_TIMEOUT=6000`，目的是使服务器重启之后，长时间停留在入口选择界面，从而有足够的时间重新连接上VNC。

### 安装过程中配置网络时DHCP失败

失败时很正常的，所以需要手工填写对应的信息，也就是上面找出来的 IP address，netmask，gateway（gw）和nameserver。

### mirror地址手动写入mirrors.tencentyun.com

腾讯云的服务器，当然是连接腾讯自己的Ubuntu镜像啦，可以跑到100M左右。

