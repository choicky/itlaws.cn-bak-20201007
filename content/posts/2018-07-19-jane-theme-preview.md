---
title: "Jane 主题预览"
slug: "jame-theme-preview"
date: 2018-07-19
lastmod: 2018-07-20
tags: ["hugo", "theme", "Jane"]
categories: ["IT", "软件"]
mathjax: true
---

**Markdown** 语言是 [Daring Fireball](http://daringfireball.net/) 创设的。最初的使用指南在 [这里](http://daringfireball.net/projects/markdown/syntax)。不过，**Markdown** 的语法在不同的编辑器或解析器上有差异。

<!--more-->

## 段落与换行

一个或多个空行可以另起一个段落。在 Typora 中，按一次换行键就能新建一个段落。

很多 Markdown 解析器会忽略单独的换行。如需要换行，需要在换行后附加至少两个空格，或者插入 `<br />`。

## 标题

用 `#` 表示标题，1~6个连续的`#` 可以表示 1~6 级标题。例如：

``` markdown
# 这是一级标题 H1

## 这是二级标题 H2

###### 这是六级标题 H6
```

## 区块引用

Markdown 使用邮件风格的 `>` 来实现区块引用。


> 本引用区块有三个段落，这是第一个段落。
>
> 这是第二段。
>
> 这是第三段。
>
> 

## 列表

`* 项目1` 创建无序列表，可用 `+` 或 `-` 代替 `*`。

`1 项目1` 创建有序列表。

* 红
* 绿
* 蓝

1. 红
2. 绿
3. 蓝


## 任务列表

`[ ]` 表示待完成，`[x]` 表示已完成。例如：

- [x] 修身
- [x] 齐家
- [ ] 治国
- [ ] 平天下

## 语法高亮

这是码农才需要的功能。

```js
function helloWorld () {
  alert("Hello, World!")
}
```

```java
public class HelloWorld {
  public static void main(String[] args) {
    System.out.println("Hello, World!");
  }
}
```

## 数学表达式

可使用 **MathJax** 渲染 *LaTeX* 数学表达式。

数学表达式的前后需要使用 `$$` 标记出来，`$$` 独占一行。例如

``` markdown
$$
\mathbf{V}_1 \times \mathbf{V}_2 =  \begin{vmatrix}
\mathbf{i} & \mathbf{j} & \mathbf{k} \\
\frac{\partial X}{\partial u} &  \frac{\partial Y}{\partial u} & 0 \\
\frac{\partial X}{\partial v} &  \frac{\partial Y}{\partial v} & 0 \\
\end{vmatrix}
$$
```

将被渲染成：
$$
\mathbf{V}_1 \times \mathbf{V}_2 =  \begin{vmatrix}
\mathbf{i} & \mathbf{j} & \mathbf{k} \\
\frac{\partial X}{\partial u} &  \frac{\partial Y}{\partial u} & 0 \\
\frac{\partial X}{\partial v} &  \frac{\partial Y}{\partial v} & 0 \\
\end{vmatrix}
$$

## 表格

首先需要创建表格的第一行。

首先通过 `| 第一列标题  | 第一列标题 |` 的方式创建第一行，接着，通过另起一行的 `| ----------------- | ------------------- |` 来确立标题行。例如：

``` markdown
| Name              | Markdown            | HTML tag             |
| ----------------- | ------------------- | -------------------- |
| *Emphasis*        | `*Emphasis*`        | `<em></em>`          |
| **Strong**        | `**Strong**`        | `<strong></strong>` |
| `code`            | ``code``            | `<code></code>`      |
| ~~Strikethrough~~ | `~~Strikethrough~~` | `<del></del`         |
| <u>Underline</u>  | `<u>underline</u>`  | `<u></u>`            |
```

| Name              | Markdown            | HTML tag             |
| ----------------- | ------------------- | -------------------- |
| *Emphasis*        | `*Emphasis*`        | `<em></em>`          |
| **Strong**        | `**Strong**`        | ` <strong></strong>` |
| `code`            | ``code``            | `<code></code>`      |
| ~~Strikethrough~~ | `~~Strikethrough~~` | `<del></del`         |
| <u>Underline</u>  | `<u>underline</u>`  | `<u></u>`            |


## 脚注

``` markdown
通过 [^footnote] 的方式创建脚注。

[^footnote]: Here is the *text* of the **footnote**.
```

渲染结果是：

通过 [^footnote] 的方式创建脚注。

[^footnote]: Here is the *text* of the **footnote**.

正常情况下，鼠标放到 ‘footnote’ 会显示脚注的内容。

## 水平线

 单行的 `***` 或 `---` 会形成一条水平线，例如：

------

## 链接

Markdown 支持两种链接方式：（1）行内链接，（2）参考链接。

这两种方式中，被链接的文字都放到中括号内。

行内链接中，链接地址（URL）放到中括号后面的小括号内。例如：

``` markdown
行内链接 [范例1](http://example.com/ "标题")。

行内链接 [范例2](http://example.net/) 没有标题属性。
```

渲染结果：

行内链接 [范例1](http://example.com/ "标题")。 (`<p>行内链接 <a href="http://example.com/" title="标题"> 范例1 </a>`)

行内链接 [范例2](http://example.net/) 没有标题属性 (`<p>行内链接 <a href="http://example.net/">范例2</a> 没有标题属性`)

### 页内链接

** 可设置跳转到页面内的标题的链接**。例如：

通过 `[链接文字](#标题文字) 的方式创建页内链接。

### 参考链接

Reference-style links use a second set of square brackets, inside which you place a label of your choosing to identify the link:

``` markdown
参考链接 [范例1][id] 。

接着，在文档的其他地方，使用一行定义该 id 表示的链接地址和可选的 title 属性：

[id]: http://example.com/  "Optional Title Here"
```

参考链接 [范例1][id] 。

接着，在文档的其他地方，使用一行定义该 id 表示的链接地址和可选的 title 属性：

[id]: http://example.com/  "Optional Title Here"

如果 id 为空，则可使用中括号内的链接文字代替 id 的内容。例如：

``` markdown
[Google][]
[Google]: http://google.com/
```

[Google][]
[Google]: http://google.com/

## URLs

可通过`<`尖括号`>`插入 URL 。

`<i@typora.io>` 被渲染成 <i@typora.io>.

## 图像


图像与行内链接类似，只是在前面多了 `!`。

``` markdown
![Alt text](/path/to/img.jpg)

![Alt text](/path/to/img.jpg "Optional title")
```

## 强调

Markdown 使用星号(`*`) 或下划线 (`_`) 实现强调。例如：

``` markdown
*单个星号*

_单个下划线_
```

渲染结果:

*单个星号*

_单个下划线_

推荐使用星号 `*` 表示强调。

## 加粗

两个星号 `*` 或者 `_` 形成 HTML 标记的 `<strong>` 标签，例如：

``` markdown
**两个星号**

__两个下划线__
```

渲染结果：

**两个星号**

__两个下划线__

推荐使用两个星号 `**` 表示强调。

## 代码引用

使用一个 ``` 进行行内代码引用。

使用三个 ``` 进行代码区块引用。


``` markdown
Use the `printf()` function.
```

渲染结果：

Use the `printf()` function.

## 删除线

三个波浪线表示删除。标准 Markdown 不支持该语法。

`~~Mistaken text.~~` 显示为 ~~Mistaken text.~~

## 下划线

用原生 HTML 标签。

`<u>Underline</u>` 显示为 <u>Underline</u>。

## Emoji 表情

使用语法 `:smile:` 插入 Emoji 表情。

## 行内数学表达式

使用 `$` 包围 Tex 命令。例如：`$\lim_{x \to \infty} \exp(-x) = 0$` 会渲染成 LaTeX 命令。

行内数学表达式的预览效果：

<img src="http://typora.io/img/inline-math.gif" style="zoom:50%;" />
