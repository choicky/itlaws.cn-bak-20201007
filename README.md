# itlaws.cn
A website based on [hugo](https://gohugo.io/) plus [jane](https://github.com/xianmin/hugo-theme-jane) theme.

这是基于 [hugo](https://gohugo.io/) 及其   [jane](https://github.com/xianmin/hugo-theme-jane) 主题构建的网站的源代码。Demo 见 [itlaws.cn](https://itlaws.cn)。

### 安装 hugo
去 hugo 的 [releases](https://github.com/gohugoio/hugo/releases) 下载 hugo ，如 theme 支持，就尽量下载最新的。

如果是 Linux ，将解压缩后的 `hugo` 放到 `/usr/local/bin/` 目录下：
```
sudo cp -v hugo /usr/local/bin/
```

如果是 Windows ，将解压缩后的 `hugo` 放到 `C:\Windows\` 目录下.

### 创建 hugo 网站
打开命令行终端，`cd` 到想要的位置，然后：
```bash
hugo new site itlaws.cn
```

该命令会再当前目录生成`itlaws.cn`，里面有hugo生成的基础文件。hugo 比较坑的地方在于，这批基础文件没有 theme ，并且，没有 theme 就不会显示任何内容。

### 将创建的 hugo 网站初始化为 git repository

```bash
cd itlaws.cn
git init
```
参考 github 的 [gitignore](https://github.com/github/gitignore/tree/master/Global) 范例，在 `itlaws.cn` 根目录增加 `.gitignore`，具体内容见[这里](https://github.com/choicky/itlaws.cn/blob/master/.gitignore)。

参考 github 的 [gitattributes](https://github.com/alexkaratarakis/gitattributes) 范例，在 `itlaws.cn` 创建 `.gitattributes` 文件，详细内容见[这里](https://github.com/choicky/itlaws.cn/blob/master/.gitattributes)。

后续步骤运行命令时，都在 `itlaws.cn` 目录下运行。

### 下载 jane 主题
建议先把 [jane](https://github.com/xianmin/hugo-theme-jane) 主题fork一份到自己的github下面，例如 https://github.com/choicky/hugo-theme-jane，方便在官方文件的基础上做些小调整。

因为 `itlaws.cn` 已经是一个 `git repository` ，里面再有一个主题的 `git repository` 不太好。所以使用 `git submodule`，将主题文件作为一个子模块（submodule），并以更新子模块的方式下载 jane 主题。

```bash
git submodule add git@github.com:choicky/hugo-theme-jane.git themes/jane
 git submodule update --init --recursive
```
复制 jane 主题自带的示范性内容到 hugo 网站的根目录：
```bash
cp -r themes/jane/exampleSite/content ./
```
复制jane的默认设置：

```bash
cp themes/jane/exampleSite/config.toml ./
```

 本地测试：

```
hugo server
```
正常情况下，`hugo server`之后，就可以在浏览器访问`localhost:1313`来浏览文件内容了。

正式生成 HTML 文件：

```bash
hugo
```

此时，静态html会存放在`itlaws.cn/public`里面。

### 将 hugo 网站上传到 github

我已经在 github 开了一个空的名为 `itlaws.cn` 的 repository，地址为 `git@github.com:choicky/itlaws.cn.git`。
```bash
git remote add origin git@github.com:choicky/itlaws.cn.git
git push -u -f origin master
```

以后再push的话，就只需要`git push`了。

### 服务器下载 hugo 网站

```bash
git clone --recurse-submodules git@github.com:choicky/itlaws.cn.git ./itlaws.cn
hugo
```
`itlaws.cn/public` 才是对外的网站根目录。
