---
title: "通过github和caddy实现hugo的自动部署"
slug: "Hugo-Caddy-Autodeplay"
date: 2018-07-27T09:25:30+08:00
lastmod: 2018-07-27T09:25:30+08:00
tags: [
    "hugo",
    "caddy",
    "github"]
categories: [
    "IT",
    "软件"]

# contentCopyright: false
# reward: false
# mathjax: false
---


[使用hugo搭建博客网站](/post/hugo-guide) 记录了如何使用hugo搭建静态化网站。

## 通过 webhook 机制实现 hugo 源文件更新后的自动部署

最基础的更新方式就是，在服务器端修改Markdown格式的网站源文件，然后重新运行`hugo`，以重新在`public`生成静态的Html网站文件。

稍geek一点的方式，就是在任何一个地方修改Markdown格式的网站源文件，然后通过`git push`把本地的文件推送到代码托管平台例如 [github](https://github.com) ，然后在服务器上通过`git pull`把文件拉下来，然后重新`hugo`。

更懒人的方式，应该是把`git push`之后的步骤自动化。<!--more-->

[codezh](https://github.com/coderzh) 之前写了一篇博文 [通过webhook将Hugo自动部署至GitHub Pages和GitCafe Pages](https://blog.coderzh.com/2015/09/13/use-webhook-automated-deploy-hugo/) ， 这方案的原理是：github 收到新的文件之后，通过 webhook 机制通知服务器；服务器收到webkook通知之后，执行 `git pull` 和 `hugo` 命令。

为了实现该种方案的自动化部署，需要做以下几件事：

1. 在github设置 webhook ；
2. 在服务器保持运行监听 webhook 的服务；
3. 在服务器设置脚本以运行`git pull`和`hugo`命令。

codezh 的博文 [通过webhook将Hugo自动部署至GitHub Pages和GitCafe Pages](https://blog.coderzh.com/2015/09/13/use-webhook-automated-deploy-hugo/) 介绍了步骤1和2，并在另一篇博文 [Hugo自动化部署脚本](https://blog.coderzh.com/2015/11/21/hugo-deploy-script/) 介绍了步骤3。

## 通过 caddy 及其 http.git 插件实现 hugo 的自动部署

如果网站使用 caddy 作为httpd服务器，还有更简单一点的方案。原理就是：既然caddy是保持运行的，就让 caddy 完成步骤2和步骤3好了。

### 安装caddy及其http.git 插件

```bash
curl https://getcaddy.com | sudo bash -s personal http.git
```

caddy 的配置，自行 google 或者按照官方的文档。默认的情况下，`/et/caddy/Caddyfile`是caddy的配置文件。

### 配置 caddy 使 caddy 能够执行上面的步骤2和步骤3

通过`nano /etc/caddy/Caddyfile`编辑 caddy 的配置文件

```bash
itlaws.cn  {
    tls zhoucaiqi@gmail.com
    gzip
    root /var/www/itlaws.cn/public
    log /var/log/caddy/access.log
    errors /var/log/caddy/errors.log

    # caddy 的 http.git 插件
    git {
        repo https://github.com/choicky/itlaws.cn.git
        path /var/www/itlaws.cn
        clone_args --recursive
        pull_args --recurse-submodules
        key /Path-t/id_rsa
        #then git submodule update --init --recursive
        hook /webhook hook密码
        then hugo --destination=/var/www/itlaws.cn/public
        hook_type github
    }
}
```

关键是`git{...}`的这一段，其中：

`repo`是存放网站源文件的repo地址，官方文档说 https 开头或者 git 开头都可以，但我测试时，只有 https 开头的能正常使用

path 是本地的 repo 地址

clone_args 是clone时的参数，--recursive 表示遍历所有的文件夹

pull_args  是 git pull 时的参数，--recurse-submodules 表示连子模块也一起pull 下来

key 是访问 github 的私钥。官方文档说，不需要，但我测试是，必须使用。[Adding a new SSH key to your GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/) 里面提到的 id_rsa

hook 有两个参数，第一个是路径，这个路径要与 github 设置的 webhook 路径相同（我设置了 https://itlaws.cn/webhook）；第二个参数是 密码。

then 后面写着要执行的命令。

hook_type 是托管markdown 源文件的平台，我是 github 。

<!--more-->