---
title: "简码预览"
slug: "shortcodes-preview"
date: 2018-07-18
lastmod: 2018-07-18
draft: false
tags: ["hugo", "shortcodes", "Jane"]
categories: ["IT", "软件",]
---

## 简码是什么

Markdown 很精简，以至于用户有时候需要使用原生 HTML 标签实现某些内容，例如视频的 `<iframes>`。

Hugo 创建 **简码** 来克服 Markdown 过于精简的问题。

Hugo 在内容页面遇到简码（shortcodes）时会使用预设的模板去渲染。需要注意的是，模板文件使用简码是没有效果的。

更多内容，请见：https://gohugo.io/content-management/shortcodes/

<!--more-->

## 音乐

{{% music "3950552" %}}

## git 代码段（gist）

可将 URL 的 用户名和 gist ID 嵌入到页面，例如：

```
{{</* gist spf13 7896402 */>}}
```

显示为：

{{< gist spf13 7896402 >}}


## Youtube

{{< youtube w7Ft2ymGmfc >}}


## Vimeo

{{< vimeo 146022717 >}}

