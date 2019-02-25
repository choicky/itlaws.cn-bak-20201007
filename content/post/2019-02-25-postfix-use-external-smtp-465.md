---
title: "Postfix使用外部SMTP服务器发送邮件"
slug: "Postfix-Use-External-SMTP"
date:    2019-02-24T14:33:34+08:00
lastmod: 2019-02-24T14:33:34+08:00
tags: [
    "Postfix",
    "SMTP",
    "阿里云",
    "轻量应用服务器"
]
categories: [
    "IT",
    "软件",
]

# contentCopyright: false
# reward: false
# mathjax: false
---

#### 背景

[Postfix](http://www.postfix.org/) 是一个成熟的邮件服务器，可用于发送邮件。默认的发信端口是25。

为了避免用户滥发邮件，很多机房都关闭了25端口。有些机房允许用户申请解封某台服务器的25端口，但有些机房连申请解封的渠道都不提供了。阿里云的轻量应用服务器就不给用户解封25端口。

所以，只能配置 Postfix 作为邮件客户端，调用外部的SMTP服务器发信。

我在 Ubuntu 18.04 LTS 上折腾了很久才成功。特地记录一下，备用。本文参考了[Configure Postfix to Send Mail Using an External SMTP Server](https://www.linode.com/docs/email/postfix/postfix-smtp-debian7/) 以及 [配置Postfix使用腾讯企业邮箱发送邮件，支持PHP的mail()函数](https://blog.kuoruan.com/106.html)。

<!--more-->

#### 安装 Postfix

```bash
sudo apt-get update
sudo apt install mailutils
```

安装过程中，会提示选择**General type of mail configuration**，选择**Internet Site**即可。

#### 配置 Postfix

1.配置外部smtp的地址、端口、用户名与密码

```nginx
sudo nano /etc/postfix/sasl_passwd
```

内容格式为：

```bash
[smtp.exmail.qq.com]:465 myEmail:password
```

我使用的是腾讯云的企业邮。如果是其他smtp，要替换对应的地址，甚至端口号。`myEmail`是登陆smtp服务器的email，password为密码。

内容加密：

```bash
sudo postmap /etc/postfix/sasl_passwd
```



2.配置发件人的映射

先运行`hostname`获知本机的名称。假设本机名称为`myserver`，那么，Postfix默认的发件人就是`username@myserver`或者`root@myserver`。这个发件人显然与上述的`myEmail地址`不同，所以需要映射。
```bash
sudo nano /etc/postfix/generic
```

内容格式为：

```bash
username@myserver myEmail
root@myserver myEmail
```

记得替换username 和 myEmail。

内容加密：

```bash
sudo postmap /etc/postfix/generic
```



3.告知postfix使用外部smtp

```bash
sudo nano /etc/postfix/main.cf
```

首先指定 smtp 服务器

```bash
relayhost = [smtp.exmail.qq.com]:465
```

这个`relayhost`的值，要与之前`/etc/postfix/sasl_passwd`写的相同。

然后，文件末端加上：

```bash
# enable SASL authentication
smtp_sasl_auth_enable = yes

# disallow methods that allow anonymous authentication.
smtp_sasl_security_options = noanonymous

# where to find sasl_passwd
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd

# where to find generic
smtp_generic_maps = hash:/etc/postfix/generic

# Enable STARTTLS encryption
smtp_use_tls = yes

# where to find CA certificates
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt

# Enable tls encryption
smtp_tls_wrappermode = yes
smtp_tls_security_level = encrypt
```

#### 重启 Postfix 与测试

```bash
sudo service postfix restart

echo "body of your email" | mail -s "This is a Subject" -a "From: myEmail" recipient@elsewhere.com
```

其中，myEmail 是之前设定的smtp邮箱，·recipient@elsewhere.com· 是收件人信箱。

如果未收到，可查看log看看。

```bash
cat /var/log/mail.log 
```



