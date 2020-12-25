# NPM包分析工具推荐

![header](https://raw.githubusercontent.com/LuckRain7/Knowledge-Sharing/master/resource/2020/1215-npm-analysis-tool-recommendations/header.png)

## 1. uiwjs / npm-unpkg

> 一个在线工具，可以查看 JS 软件包里面包含哪些文件，每个文件的源码。

协议：MIT License

GitHub地址：https://github.com/uiwjs/npm-unpkg

网站地址：https://uiwjs.github.io/npm-unpkg/

![npm-unpkg](https://raw.githubusercontent.com/LuckRain7/Knowledge-Sharing/master/resource/2020/1215-npm-analysis-tool-recommendations/npm-unpkg.png)

**example：vue@2.6.12**

![npm-unpkg-vue](https://raw.githubusercontent.com/LuckRain7/Knowledge-Sharing/master/resource/2020/1215-npm-analysis-tool-recommendations/npm-unpkg-vue.png)

可以清晰的查看包文件目录及源码文件，解决了在node_modules中找半天找不到包，文件目录拖很长的问题。

## 2. pastelsky / bundlephobia 

> 一个在线工具，分析 npm 软件包的体积和加载性能，找出在项目中添加新的前端依赖项的成本。

协议：MIT License

GitHub地址：https://github.com/pastelsky/bundlephobia

网站地址：https://bundlephobia.com/

![bundlephobia](https://raw.githubusercontent.com/LuckRain7/Knowledge-Sharing/master/resource/2020/1215-npm-analysis-tool-recommendations/bundlephobia.png)

**example：vue@2.6.12**

![bundlephobia-vue](https://raw.githubusercontent.com/LuckRain7/Knowledge-Sharing/master/resource/2020/1215-npm-analysis-tool-recommendations/bundlephobia-vue.png)

以 vue@2.6.12 为例，

- BUNDLE SIZE(打包体积)：压缩后体积为 63.7KB；压缩+gzip为22.9KB。
- 右侧柱状图：历史版本体积对比。
- DOWNLOAD TIME(包下载时间)：2G：0.76s；3G：455ms
- Composition(包成分)：包私有成分99.9%，表示外部包依赖为0.01%

