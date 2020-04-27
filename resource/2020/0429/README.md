# 玩转 GitHub 的几个小技巧

## 1.  GitHub 搜索技巧

在项目名称搜索 in:name xxx

![in:name xxx](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/inname.png)

在项目描述搜索 in:description xxx

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/indescription.png)

在项目 README 搜索 in:readme xxx

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/inreadme.png)

利用 star 搜索 stars:>3000 xxx 

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/instars.png)

利用 fork 搜索 forks:>300 xxx

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/inforks.png)

也可以直接使用 GitHub 高级搜索页面 [ https://github.com/search/advanced ]( https://github.com/search/advanced )

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/github-self-advanced-search.png)

## 2.  轻松浏览文件和目录

Octotree 浏览器插件，可以帮助您浏览目录，并使用熟悉的树状结构打开文件。

地址：[谷歌商店网址(需要稳定的网络环境)]( https://chrome.google.com/webstore/detail/octotree/bkhaagjahfmjljalopjnoealnfndnagc ) | [GitHub]( https://github.com/ovity/octotree )

下方图片来源  `https://github.com/ovity/octotree (Octotree 官方文档)`

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/78818701-ee142700-7989-11ea-9297-c3cf4e88f891.gif)





## 3.  Markdown技巧

### 3.1 键盘标签

> 可以使用  `<kbd> ` 标签进行包裹，会使文本看起来像按钮
> 

```
<kbd>Q</kbd> |  <kbd>W</kbd>  | <kbd>E</kbd> |  <kbd>R</kbd> 
```

效果如下：

<kbd>Q</kbd> |  <kbd>W</kbd>  | <kbd>E</kbd> |  <kbd>R</kbd> 

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/kbd.png)



### 3.2 差异可视化

 可以使用反引号可视化差异，并`diff`根据需要突出显示红色或绿色的线。 

```
​```diff
- box.onclick = fn.bind(obj, 200);
+ box.onclick = fn.call(obj, 200);
​```
```

效果如下

```diff
- box.onclick = fn.bind(obj, 200);
+ box.onclick = fn.call(obj, 200);
```

###  3.3 折叠效果

添加冗长的错误日志或冗长程序输出的问题可以解决的错误有帮助的，但如果它占用页的垂直空间，可以考虑使用`  <details>  `和` <summary> `标签。 

```
Having some problems firing up the laser.

<details>
<summary>Click here to see terminal history + debug info</summary>
<pre>
488 cd /opt/LLL/controller/laser/
489 vi LLLSDLaserControl.c
490 make
491 make install
492 https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/sanity_check
493 https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/configure -o test.cfg
494 vi test.cfg
495 vi ~/last_will_and_testament.txt
496 cat /proc/meminfo
497 ps -a -x -u
498 kill -9 2207
499 kill 2208
500 ps -a -x -u
501 touch /opt/LLL/run/ok
502 LLLSDLaserControl -ok1
</pre>
</pre<details>
```

效果如下：

<details>
<summary>Click here to see terminal history + debug info</summary>
<pre>
488 cd /opt/LLL/controller/laser/
489 vi LLLSDLaserControl.c
490 make
491 make install
492 https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/sanity_check
493 https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/configure -o test.cfg
494 vi test.cfg
495 vi ~/last_will_and_testament.txt
496 cat /proc/meminfo
497 ps -a -x -u
498 kill -9 2207
499 kill 2208
500 ps -a -x -u
501 touch /opt/LLL/run/ok
502 LLLSDLaserControl -ok1
</pre>
</details>



### 3.4  使文字和图像居中

在 MarkDown 中直接是使用居中DIV

```
<div align="center">
<img src="https://rain7.top/luckrain7.png" width="350">
<p>This is RainCode</p>
</div>
```

效果如下：

<div align="center">
<img src="https://rain7.top/luckrain7.png" width="350">
<p>This is RainCode</p>
</div>

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/img-center.png)

### 3.5 较小的文字

 在`<sup>`或`<sub>`标记中换行以使其变小。非常适合在图像下添加“图1：描述”之类的内容，或者使表中的文本变小以使其不会水平滚动。 

```
<div align="center">
<img src="https://rain7.top/luckrain7.png" width="350"><br>
<sup><strong>Fig 1:</strong> luckrain7's logo</sup>
</div>
```

效果如下：

<div align="center">
<img src="https://rain7.top/luckrain7.png" width="350"><br>
<sup><strong>Fig 1:</strong> luckrain7's logo</sup>
</div>

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/little-word.png)

## 4.徽标制作

下面教程是简单的常规用法

1.首先登陆网站： [https://shields.io/]( https://shields.io/ )

2.向下滑动，找到 `Static` 功能标题，如图进行制作

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/shieldsio.png)

3.页面会跳转到制作好的徽标页面，右击点击徽标(SVG格式)保存到本地

4.使用

```
将图片上传到自己的图床中或仅本地使用
使用图片嵌套格式使用
[![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/RainCode.svg)](https://mp.weixin.qq.com/s/-kBwis0MhRNgVEtDF7wPYA)
```

[![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0427/RainCode.svg)](https://mp.weixin.qq.com/s/-kBwis0MhRNgVEtDF7wPYA)



## 5.  修改仓库语言

项目仓库是根据根目录下的文件类型进行判断，哪种类型多，仓库就在仓库列表界面显示哪种语言类型

修改步骤：

1.在项目中添加文件 ` .gitattributes `

2.输入以下内容（重置识别类型）：

```
 *.[扩展名] linguist-language=[将此文件识别为哪种语言]
 
 # 我这以vue为例
 *.js linguist-language=vue
 *.css linguist-language=vue
 *.html linguist-language=vue
 *.sh linguist-language=vue
```

这样项目仓库语言会被修改为 vue