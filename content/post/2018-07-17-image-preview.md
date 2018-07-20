---
title: "图像预览"
slug: "image-preview"
date: 2018-07-17
lastmod: 2018-07-17
draft: false
tags: ["hugo", "theme", "jane"]
categories: ["IT", "软件"]

menu:
  main:
    parent: "docs"
    weight: 3
---

感谢 [liwenyip/hugo-easy-gallery](https://github.com/liwenyip/hugo-easy-gallery) & [Zebradil · Pull Request #48](https://github.com/xianmin/hugo-theme-jane/pull/48) ，我们现在可以在 hugo-theme-jane 中使用 `{{</* gallery */>}}` 简码。

## 普通图像

这是存在 `static/image` 文件夹的图像。

```markdown
![This is an image in `static/image` folder.](/image/example.jpg)
```

<!--more-->

## `{{</* figure */>}}` 简码

### 具有 title 的图像

```
{{</* figure src="/image/example.jpg" title="figure image with title" */>}}
```

### 具有 caption 的图像

```
{{</* figure src="/image/example.jpg" caption="figure image with caption figure image with caption figure image with caption figure image with caption figure image with caption" */>}}
```

### `{{</* figure */>}}` 简码的更多用法

指定图像文件：

- `{{</* figure src="thumb.jpg" link="image.jpg" */>}}` 将使用 `thumb.jpg` 作为小示意图以及使用  `image.jpg` 作为灯箱图。
- `{{</* figure src="image.jpg" */>}}` or `{{</* figure link="image.jpg" */>}}` 将使用 `image.jpg` 作为小示意图和灯箱图。
- `{{</* figure link="image.jpg" thumb="-small" */>}}` 将使用 `image-small.jpg` 作为小示意图以及使用 `image.jpg` 作为灯箱图。

可选参数：

- Hugo 内置的 `figure` 简码的 [特征/参数](https://gohugo.io/extras/shortcodes) 都正常使用，例如 src, link, title, caption, class, attr (attribution), attrlink, alt
- `size` (e.g. `size="1024x768"`) 预定义图像的尺寸。
- `class` 用来预定义 `<figure>` 的标签。

Optional parameters for standalone `{{</* figure */>}}` shortcodes only (i.e. don't use on `{{</* figure */>}}` inside `{{</* gallery */>}}` - strange things may happen if you do):

- `caption-position` and `caption-effect` work the same as for the `{{</* gallery */>}}` shortcode (see below).
- `width` defines the [`max-width`](https://www.w3schools.com/cssref/pr_dim_max-width.asp) of the image displayed on the page. If using a thumbnail for a standalone figure, set this equal to your thumbnail's native width to make the captions behave properly (or feel free to come up with a better solution and submit a pull request :-)). Also use this option if you don't have a thumbnail and you don't want the hi-res image to take up the entire width of the screen/container.
- `class="no-photoswipe"` prevents a `<figure>` from being loaded into PhotoSwipe. If you click on the figure you'll instead a good ol' fashioned hyperlink to a bigger image (or - if you haven't specified a bigger image - the same one).


## `{{</* gallery */>}}` shortcode

### simple gallery

To specify a directory of image files:

```
{{</* gallery dir="/img/your-directory-of-images/" */>}}
```

- The images are automatically captioned with the file name.
- `[image].jpg` is used for the hi-res image, and `[image]-thumb.jpg` is used for the thumbnails.
- If `[image]-thumb.jpg` doesn't exist, then `[image].jpg` will be used for both hi-res and thumbnail images.
- The default thumbnail suffix is `-thumb`, but you can specify a different one e.g. `thumb="-small"` or `thumb="_150x150"`.


### To specify individual image files

```
{{</* gallery */>}}
  {{</* figure src="image1.jpg" */>}}
  {{</* figure src="image2.jpg" */>}}
  {{</* figure src="image3.jpg" */>}}
{{</* /gallery */>}}
```

**Optional parameters:**

- `caption-position` - determines the captions' position over the image. Options:
  - `bottom` (default)
  - `center`
  - `none` hides captions on the page (they will only show in PhotoSwipe)
- `caption-effect` - determines if/how captions appear upon hover. Options:
  - `slide` (default)
  - `fade`
  - `none` (captions always visible)
- `hover-effect` - determines if/how images change upon hover. Options:
  - `zoom` (default)
  - `grow`
  - `shrink`
  - `slideup`
  - `slidedown`
  - `none`
- `hover-transition` - determines if/how images change upon hover. Options:
  - not set - smooth transition (default)
  - `none` - hard transition
