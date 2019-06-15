---
title: "Kcptun 安装过程"
slug: "Kcptun-Installation"
date:    2019-06-15T20:31:26+08:00
lastmod: 2019-06-15T20:31:26+08:00
tags: [
    "kcptun",
    "网络加速",
    "2019年",
]
categories: [
    "IT",
    "软件",
]

# contentCopyright: false
# reward: false
# mathjax: false
---

#### kcptun简介

网络传输层，常用的传输协议包括TCP和UDP，前者是以连接为基础的可靠协议，后者是不可靠协议。

正因为不可靠，所以UDP的响应很迅速。很多游戏的通信传输都选择UDP，就是因为UDP响应快。可以想象，玩吃鸡游戏时，网络快0.1秒的人，肯定是占优势的：能先把对方打趴。

[kcptun](https://github.com/xtaci/kcptun/) 是一款加速UDP数据传输的工具。它的工作机制是：把两台机器之间的基于TCP传输转化为UDP传输，并通过适度的重复发包，来弥补UDP的不可靠，从而实现传输加速。

<!--more-->

#### kcptun server端的安装过程

1. 首先，到 `https://github.com/xtaci/kcptun/releases`官网下载对应的文件。

我是 ubuntu x64 的系统。解压缩之后，把`server_linux_amd64`复制到 `/usr/bin/`下面：

```bash
sudo copy server_linux_amd64 /usr/bin/
sudo chmod +x /usr/bin/server_linux_amd64
```



2. 其次，创建 kcptun 配置文件：

```bash
sudo mkdir /etc/kcptun
sudo nano /etc/kcptun/config.json
```

内容如下：

```json
{
    "listen": ":监听入站端口",
    "target": "127.0.0.1:需要加速数据端口",
    "key": "自定义密码",
    "crypt": "salsa20",
    "mode": "fast2",
    "nocomp": true,
    "keepalive": 10
}
```

参数的含义、更多的参数，见[官网](https://github.com/xtaci/kcptun)

3. 第三，创建 kcptun 的启动 service 文件

我使用的是 ubuntu 系统，支持 systemd 这个启动管理、守护工具。 

```bash
sudo nano /etc/systemd/system/kcptun.service
```

内容是：

```bash
[Unit] 
Description = Kcptun Client Service 
After=network.target
[Service] 
Type=simple 
User=nobody 
ExecStart=/usr/bin/server_linux_amd64 -c /etc/kcptun/config.json
Restart=always 
RestartSec=5
[Install] 
WantedBy = multi-user.target
```

4. 刷新并启用 kcptun 服务

```bash
sudo systemctl daemon-reload
sudo systemctl enable kcptun
sudo service kcptun start
sudo service kcptun status
```

#### kcptun client 端的安装过程

类似的，到 `https://github.com/xtaci/kcptun/releases`官网下载对应的文件。

我是windows系统，推荐 [kcptun_glient](https://github.com/dfdragon/kcptun_gclient) 这款GUI客户端。