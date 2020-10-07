---
title: "Openwrt/LEDE中监控并重启V2ray"
slug: "Openwrt-V2ray"
date:    2018-09-23T09:49:58+08:00
lastmod: 2018-09-23T09:49:58+08:00
tags: [
    "openwrt",
    "LEDE",
    "v2ray",
]
categories: [
    "IT",
    "软件",
]

# contentCopyright: false
# reward: false
# mathjax: false
---

## 问题

我的路由器系统是 openwrt/LEDE 。里面安装了 v2ray 作为游戏加速工具。

之前工作得好好的，最近遭遇的问题是 v2ray 进程异常退出，且不再自己启动。

因为我的加速方案是对所有的境外服务器加速，因此，一旦 v2ray 异常退出，我就无法访问境外的网站了。体验很糟糕。

## 思路

我对 openwrt/LEDE 不熟。不知道如何在 openwrt/LEDE 中像普通的 Linux 那样安装 supervisor 之类的进程监控、重启工具，只好想一个凑合的解决方案：<!--more-->

1. 检测 v2ray 进程是否存在；
2. 如果 v2ray 不存在，就启动 v2ray 进程；
3. 定期执行上面的步骤 1 和步骤 2 。

其中：

第 1 个小目标，可通过 `ps | grep v2ray` 实现。

第 2 个小目标，可通过 `if` 语句判断。

第3个小目标，可通过 `crontab -e` 来实现。

## 实现步骤1和步骤2的脚本

先看看 `ps | grep v2ray` 的结果：

```bash
10395 root      111m S    v2ray --config=/koolshare/v2ray/v2ray.json
10666 root      3092 S    grep v2ray
```

如果 v2ray 进程异常退出， `ps | grep v2ray` 的结果就只有`grep v2ray`的那一行。判断行数的工具是`wc -l`。因此，如果 `ps | grep v2ray | wc -l` 的结果是1，就说明 `v2ray` 进程异常退出了。

脚本 `check_v2ray.sh` 内容如下：

```bash
#! /bin/bash
# author: itLaws
# time: 2018-09-23 
# program: 如果不存在 v2ray 进程，就启动 v2ray 进程

function check_v2ray(){
  v2ray_count=`ps | grep v2ray | wc -l`
  if [ 1 == $v2ray_count ]; then
    /koolshare/init.d/S99v2ray.sh start  ## 注意脚注1
  fi
}

check_v2ray

# 脚注1：S99v2ray.sh 是 koolshare 的 openwrt/LEDE 的运行 v2ray 的命令。

```

## 

**update**: 上面的脚本有个小坑。

因为我的脚本名称是 `check_v2ray.sh`，且通过 `cron` 定期运行 `check_v2ray.sh`，导致`ps | grep v2ray` 有时候会得到如下的运行结果：

```bash
18995 root      113m S    v2ray --config=/koolshare/v2ray/v2ray.json
22910 root         0 Z    [check_v2ray.sh]
22994 root      3092 S    grep v2ray
```

这时候，总行数为 3 ，即使 `v2ray` 异常退出了，总行数依然是 2 ，不是 1。

所以，干脆把检测命令改为`ps | grep /koolshare/v2ray/v2ray.json | wc -l` 了。

脚本 `check_v2ray.sh` 内容如下：

```bash
#! /bin/bash
# author: itLaws
# time: 2018-09-23 
# program: 如果不存在 v2ray 进程，就启动 v2ray 进程

function check_v2ray(){
  v2ray_count=`ps | grep /koolshare/v2ray/v2ray.json | wc -l`
  if [ 1 == $v2ray_count ]; then
    /koolshare/init.d/S99v2ray.sh start  ## 注意脚注1
  fi
}

check_v2ray

# 脚注1：S99v2ray.sh 是 koolshare 的 openwrt/LEDE 的运行 v2ray 的命令。

```

## 实现步骤3的方法

上面的脚本 `check_v2ray.sh` 保存为 `/koolshare/scripts/check_v2ray.sh`。

运行下面的语句赋予其可执行权限。

```
sudo chmod +x /koolshare/scripts/check_v2ray.sh
```

然后 `crontab -e` 或者 `nano /etc/crontabs/root` ，增加一行：

```bash
* * * * * /koolshare/scripts/check_v2ray.sh
```

表示每分钟运行一次 `/koolshare/scripts/check_v2ray.sh` 。如果是每两分钟运行一次，就改为：

```bash
*/2 * * * * /koolshare/scripts/check_v2ray.sh
```