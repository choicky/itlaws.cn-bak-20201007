---
title: "从 Onedrive 切换到 Dropbox"
slug: "From-Onedrive-to-Dropbox"
date:    2018-08-21T18:48:41+08:00
lastmod: 2018-08-21T18:48:41+08:00
tags: [
    "Dropbox",
    "Onedrive",
    "Gdrive",
]
categories: [
    "IT",
    "软件",
]

# contentCopyright: false
# reward: false
# mathjax: false
---

##  我的需求与方案

我需要在不同的电脑办公，所以需要把与工作相关的材料放到可靠的网盘中。

目前我的主打网盘是 Google Drive 。但这个方案有一个缺点：我的文件太多了，切换电脑之后，Google Drive 需要比较长的时间才能找出文件的差异、同步。

于是，我想出来的方案就是：<!--more-->

1. 最近使用的文档放在另一个网盘，这个网盘同步的文件不多，以实现瞬间同步。

2. 定期把一些不常用的文件放到 Google Drive 。

于是，我的初步方案就是 Google Drive （偏存档） + Onedrive （偏同步）。

## Onedrive 的问题

Onedrive 在我家里表现不错，上传和下载都有几M的速度。这个速度满足我的需求了。但我今天在办公室，就被 Onedrive 的网速折磨疯了。总的来说，Onedrive 的问题在两方面：

* 不同的网络环境下，网速差异很大。
* 空间统计非常混乱。

今天在办公室，Onedrive 显示有1.6G的文件要下载，但是下载速度只有10K~200K的范围。好不容易下载完了，windows 10 要重启更新。重启之后，Onedrive 提示需要重头开始下载文件，且要下载的文件变为2.2G左右了！

然后，网速越来越差。不管是修改 hosts ，还是通过加速梯子，同步速度就是起不来。

更要命的事，再后来，Onedrive 提示要下载的文件是4.3G了！ 而Onedrive web上显示我的文件不要2G。

于是，我彻底懵掉了：我究竟有多少文件要同步啊？

## Dropbox 如丝顺滑

后来决定使用 Dropbox 替代 Onedrive 。 Dropbox 实在太好用了，速度快，且可靠性好。

与 Google Drive 相比， Dropbox 的优点包括几方面：

* 文件的同步很可靠，这是多年的口碑证实了的。Google Drive 直至目前还有各种小问题，例如会若干重复的文件、甚至有同名的文件。

* 大文件的快速同步。Dropbox 有独家的块同步技术，大文件修改时，只会上传被修改的一小部分内容，不需要把整个文件上传，从而加快了速度。
* 网络很可靠。Google Drive 有一个恼火的问题就是经常连不上，因为无法设置网络加速渠道；而 Dropbox 可以设置网络加速渠道，只要加速渠道没问题，Dropbox 的网速就一定没问题。

Onedrive 不知搞什么鬼，不管加不加速，有时候甚至速度为0。

## 我的Dropbox 推广链接

Dropbox 有一个推广策略：通过我的推广链接下载安装 Dropbox 之后，我能得到 500M的空间奖励。

我的推广链接是： https://db.tt/jjYcd07IsJ 欢迎点击下载。



