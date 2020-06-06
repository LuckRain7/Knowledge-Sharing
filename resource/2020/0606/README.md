# MarkDown 让文档更高效

![markdown.png](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0606/markdown.png)

## 0. MarkDown 是什么？

Markdown 是一种纯文本格式的标记语言。通过简单的标记语法，它可以使普通文本内容具有一定的格式。

### 0.1 优点

- 纯文本编辑，结构清晰。
- 操作简单，学习成本低。
- 文档可以导出 HTML 、Word、图像、PDF、Epub 等多种格式的文档。

### 0.2 缺点

也没啥缺点。

## 1. 语法

### 1.1 标题

```markdown
# 一级标题名称

## 二级标题名称

### 三级标题名称

#### 四级标题名称

##### 五级标题名称

###### 六级标题名称

ps:使用 # 进行标识
```

效果：

### 1.2 表格

```markdown
| 左对齐  | 居中对齐   | 右对齐  |
| :----- | :------: | -----: |
| 1      |    2     |      3 |
| 1      |    2     |      3 |
| 1      |    2     |      3 |

表头与表格内容使用 | --- | 进行间隔
使用：进行标记对齐格式，
ps：中间 --- 的个数没有明确限制
```

效果：

| 左对齐 | 居中对齐 | 右对齐 |
| :----- | :------: | -----: |
| 1      |    2     |      3 |
| 1      |    2     |      3 |
| 1      |    2     |      3 |

### 1.3  代码块

使用 

```markdown
​```javascript
console.log('Hello MarkDown')
​```

ps:使用 ``` 进行标识
在顶部 ``` 标识后紧跟代码类型，代码块内会设置对应高亮显示
```

效果：

```javascript
console.log('Hello MarkDown')
```

### 1.4  公式块

```markdown
$$
\frac{d}{dx}e^{ax}=ae^{ax}\quad \sum_{i=1}^{n}{(X_i - \overline{X})^2}
$$

公式写法需要学习 数学公式的Latex编辑方式，笔者在这里不多赘述
```
效果：

$$
\frac{d}{dx}e^{ax}=ae^{ax}\quad \sum_{i=1}^{n}{(X_i - \overline{X})^2}
$$



### 1.5  引用

引用可以多级进行嵌套

```markdown
> 引用内容1：hello markdown
>
> > 引用内容2：hello markdown

ps: 使用 > 进行标识，与内容使用空间进行区分
```

效果：

> 引用内容1：hello markdown
>
> > 引用内容2：hello markdown



### 1.6  有序列表

```markdown
1. 内容1
2. 内容2
3. 内容3
	 1. 内容3-1
	    1. 内容3-1-1
	 2. 内容3-2
	
ps: 使用 1. 进行标识
层级使用三个空格的缩进进行控制或通过一个tab进行控制
```

效果：

1. 内容1
2. 内容2
3. 内容3
	 1. 内容3-1
	    1. 内容3-1-1
	 2. 内容3-2

 ### 1.7 无序列表

```markdown
- 内容1
- 内容2
   - 内容2-1
      - 内容2-1-1
   - 内容2-2
   
ps: 使用 - 进行标识
层级使用三个空格的缩进进行控制或通过一个tab进行控制
```

效果：

- 内容1
- 内容2
   - 内容2-1
      - 内容2-1-1
   - 内容2-2

### 1.8  任务列表

```markdown
- [ ] 任务1
	- [ ] 任务1
- [x] 任务2

ps: 使用 - [ ] 进行标识
- [ ] 表示未完成
- [x] 表示已完成
```

效果：

- [ ] 任务1
	- [ ] 任务1
- [x] 任务2



### 1.9  链接引用

```markdown
[https://github.com/LuckRain7](https://github.com/LuckRain7)

[github/LuckRain7](https://github.com/LuckRain7)

[] 中内容为显示标题
() 中填写链接地址
```

效果：

[https://github.com/LuckRain7](https://github.com/LuckRain7)

[github/LuckRain7](https://github.com/LuckRain7)

### 1.10 图片引用

```markdown
![wx](http://img.rain7.top/wx.png)

![图片名称](链接地址)
```

效果：

![wx](http://img.rain7.top/wx.png)

### 1.11  脚注

```markdown
内容1[^1]

内容2[^A]

[^x]: x为脚注内容
```

效果：

内容1[^1]

内容2[^A]

### 1.12 水平分割线

```markdown
---

---------

ps: - 数量超过3个就可以识别为分割线
```

效果：

---------

### 1.13 字体效果

#### 1.13.1 加粗

```
**加粗**字体
```

效果：

**加粗**字体

#### 1.13.1 斜体

```
*斜体*字体
```

效果：

*斜体*字体

#### 1.13.1 删除

```
~~删除~~字体
```

效果：

~~删除~~字体

#### 1.13.1 下划线

```
<u>下划线</u>
```

效果：

<u>下划线</u>





## 2.  编辑器推荐

Typora

![image-20200606103416840](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0606/image-20200606103416840.png)



我感觉是我用过最好用的 MarkDow 编辑器，简洁、优雅、功能强大。

![image-20200606103433138](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0606/image-20200606103433138.png)







