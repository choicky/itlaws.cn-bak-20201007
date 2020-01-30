---
title: "如何自动删除重复的邮件"
slug: "How-to-Remove-Duplicate-Emails"
date:    2020-01-30T09:48:24+08:00
lastmod: 2020-01-30T09:48:24+08:00
tags: [
    "邮件管理",
    "2020年",
    "IMAP",
]
categories: [
    "IT",
    "软件",
]

# contentCopyright: false
# reward: false
# mathjax: false
---

### 缘起 Gmail

因为依赖Gmail的邮件搜索功能，所以我一直使用Gmail管理我的邮件：在Gmail中，使用pop协议收取其他邮箱的信件，并在Gmail中调用smtp协议去回复邮件。

是的，你收到的、看起来是我QQ邮箱、126邮箱、办公邮箱等各种邮箱发过去的邮件，实际上都是我在Gmail上发送过去的。

### 重复导入的邮件

有一段时间，我曾经将我的域名`zhoucaiqi.com`托管到Google的企业邮局并给自己开设了`email@zhoucaiqi.com`，并将我积累了多年的 `zhoucaiqi@gmail.com`的邮件导入到`email@zhoucaiqi.com`。但是，Google企业邮局有各种各样的问题，导致我被迫回归 `zhoucaiqi@gmail.com`，导来导去之后，就出现了很多重复的邮件。<!--more-->

### 需求与困难

我购买的200G空间，已经快被Gmail用满，所以需要删除重复的邮件了。

因为重复的邮件有数千或数万封，靠人工去筛选、删除，是不现实的。而Gmail官方又没有提供自动筛选、删除的功能。因此，只能自己想办法。

### 思路与方案

`imap`是邮件同步协议，能让本地客户端的邮件内容与邮件服务器端的内容同步。因此，可以考虑使用`imap`协议将邮件下载到本地，然后在本地进行重复邮件的筛查、过滤、删除。

说干就干。

先在Gmail的设置中启用`imap`协议，然后安装邮件客户端[thunderbird](https://www.thunderbird.net/zh-CN/)，然后把Gmail账号信息设置到`thunderbird`。`thunderbird`默认就采用`imap`协议。`thunderbird`默认只同步邮件头信息，但即使如此，我十几万封的邮件，依然同步了一个晚上，可能是受限于Gmail。

接着，给`thunderbird`安装`Remove Duplicates`扩展（[Link](https://addons.thunderbird.net/en-US/thunderbird/addon/remove-duplicates/)），这扩展是一款自动筛查重复邮件的插件，可通过很多参数去判断两封邮件是否属于重复邮件，例如 `message ID`、`date in seconds`、`subject`、`from`等。在邮件的文件夹中，鼠标右键可以选择通过哪些参数判断邮件是否属于重复的邮件。

我觉得默认的参数就OK了。

我先在某个子文件夹做了测试，这子文件夹有5万封邮件，在文件夹鼠标右键选择`Remove Duplicate Messages`之后，两三分钟就筛选完了，筛选出来5千封重复的邮件。看筛选结果，是正确的。

我的Gmail总共有14.1万封邮件，我根文件夹选择`Remove Duplicate Messages`之后，大概十分钟后，过滤出7万封重复的邮件：

![过滤结果](/img/202001/thunderbird-remove-duplicates.png)

重复的邮件中，其中一封邮件标记为`Keep`，其他邮件标记为`Del`。点击右下角的`Delete Selected`就可以删除重复的邮件了。

`imap`的同步特性，会把这个删除操作同步到服务器端。

done。





