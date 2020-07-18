# 图片优化如何让网站减重60%

![截屏2020-07-18 11.05.15](https://luckrain7.github.io/Knowledge-Sharing/translate/images/images-optimization-header.png)

> 文章作者：Ayo
>
> 原文链接：https://freshman.tech/image-optimisation/

图片是web上提供的最基本的内容类型之一。他们说一张图片值一千个字，但如果你不小心的话，它也可以值几兆大小。

因此，尽管Web图像需要清晰明快，但也必须以可管理的大小进行展示，以使加载时间保持较小，数据使用率保持在可接受的水平。

  在我的网站上，我注意到我的主页页面重量超过1.1 MB，图片占了其中的88%。我也意识到我所提供的图片比它们需要的尺寸要大(就分辨率而言)。显然，还有很大的优化空间。

![截屏2020-07-18 11.05.15](https://luckrain7.github.io/Knowledge-Sharing/translate/images/images-optimization-1.png)

我阅读了Addy Osmani出色的Essential Image Optimization电子书之后，在我的网站上实施了他的建议。 然后，我对响应图像进行了一些研究，并将其应用在了我的网站。

这使得页面重量减少到445 KB。页面重量减少62%

![截屏2020-07-18 11.07.14](https://luckrain7.github.io/Knowledge-Sharing/translate/images/images-optimization-2.png)

这篇文章是关于描述我采取的步骤，使我的主页页面重量达到更易于管理的水平。

## 什么是图像压缩？

压缩图像就是要减小文件体积，同时保持可接受的视觉质量水平。为了压缩我网站上的图像，`imagemin `是我选择的工具。

要使用 `imagemin`，请确保安装了 `Node.js` ，然后打开一个终端窗口，`cd` 到您的项目文件夹中，并运行以下命令

```bash
npm install imagemin
```

然后新建文件`imagmin .js`，并粘贴以下内容

```javascript
const imagemin = require('imagemin');
const PNGImages = 'assets/images/*.png';
const JPEGImages = 'assets/images/*.jpg';
const output = 'build/images';
```

您可以随意更改`PNGImages`、`JPEGImages`和输出的值，以匹配您的项目结构。

要执行任何压缩，都需要根据要压缩的图像类型引入几个插件。

## 用 MozJPEG 压缩 jpeg

为了压缩 `JPEG` 图像，我使用了`Mozilla` 的 `MozJPEG` 工具，它可以通过`imagemin- MozJPEG` 作为`imagemin` 插件使用，您可以通过运行以下命令安装它

```bash
npm install imagemin-mozjpeg
```

然后将以下内容添加到 `imagmin .js` 文件中

```javascript
const imageminMozjpeg = require('imagemin-mozjpeg');

const optimiseJPEGImages = () =>
  imagemin([JPEGImages], output, {
    plugins: [
      imageminMozjpeg({
        quality: 70,
      }),
    ]
  });

optimiseJPEGImages()
  .catch(error => console.log(error));
```

您可以通过在终端中运行 `node imagemin.js`来运行脚本。 这将处理所有 `JPEG` 图像，并将优化的版本放置在 `build / images` 文件夹中。

我发现，在大多数情况下，将质量设置为70可以产生足够好的图像，但效果可能会有所不同。你可以根据自己的实际情况进行实验。

`MozJPEG` 默认情况下会生成逐行`JPEG`，这会导致图像从低分辨率逐渐加载到高分辨率，直到图片完全加载为止。 由于它们的编码方式，它们也往往比基线 `JPEG` 略小。

您可以使用 `Sindre Sorhus` 的这个漂亮的命令行工具来检查 `JPEG` 图像是否是渐进式的。

Addy Osmani 已经详细说明了使用渐进 `jpeg` 的优缺点。对我来说，我觉得利大于弊，所以我坚持使用默认设置。

如果您更喜欢使用基线 `JPEG`，则可以在` options` 对象中将 `progressive` 设置为`false`。 另外，请确保访问 `imagemin-mozjpeg` 页面，以查看其他可用的设置。

## 用pngquant优化PNG图像

`pngquant` 是我优化 `PNG` 图像的首选工具。您可以通过` imagemin-pngquant` 使用它

```bash
npm install imagemin-pngquant
```

添加以下内容到 `imagemin.js` 中：

```javascript
const imageminPngquant = require('imagemin-pngquant');

const optimisePNGImages = () =>
  imagemin([PNGImages], output, {
    plugins: [
      imageminPngquant({ quality: '65-80' })
    ],
  });

optimiseJPEGImages()
  .then(() => optimisePNGImages())
  .catch(error => console.log(error));
```

我发现`quality`参数为65-80，可以在文件大小和图像质量之间取得良好的平衡。

通过这些设置，我可以得到一个从913 KB到187kb的网站截图，并且没有任何明显的视觉质量损失。79%的降幅！

下面是同一个文件。看一看，自己判断

- [Original Image](https://freshman.tech/assets/dist/images/articles/freshman-1600-original.png) (913 KB)
- [Optimised Image](https://freshman.tech/assets/dist/images/articles/freshman-1600.png) (187 KB)

## 为支持WebP图像的浏览器提供服务

`WebP` 是 `Google` 推出的一种相对较新的格式，旨在通过以无损和有损格式对图像进行编码来提供较小的文件大小，使其成为 `JPEG` 和 `PNG` 的理想替代品。

`WebP` 图像可以与 `JPEG` 和` PNG` 的视觉质量媲美，但可以大大减小文件大小。 例如，当我从上方将屏幕截图转换为 `WebP` 时，我得到了一个88 KB的文件，其质量与原始图像的913 KB相当。 减少90％！

看以下所有三个图像。 你能说出区别吗？

- [Original PNG image](https://freshman.tech/assets/dist/images/articles/freshman-1600-original.png) (913 KB)
- [Optimised PNG image](https://freshman.tech/assets/dist/images/articles/freshman-1600.png) (187 KB)
- [WebP image](https://freshman.tech/assets/dist/images/articles/freshman-1600.webp) (88 KB, can be viewed in Chrome or Opera)

就个人而言，我认为视觉质量是可比的，而且您所节省的成本也难以忽视。

既然我们已经确定了尽可能使用 `WebP` 格式的价值，则需要注意的是，由于大部分浏览器对 `WebP`的支持并不好，因此它目前不能完全替代 `JPEG` 和 `PNG`。

但是，根据 `caniuse.com` 的数据，全球有70％以上的用户使用支持 `WebP` 的浏览器。 这意味着，通过提供WebP图像，您可以使大约70％的客户的网页浏览速度更快。

让我们看看在网络上投放 `WebP` 图像的具体步骤。

### 将您的JPEG和PNG转换为WebP

使用 `imagemin-webp` 插件，将 `JPEG` 和` PNG` 图像转换为 `WebP` 非常容易。

在终端中运行以下命令来安装它

```bash
npm install imagemin-webp
```

在 `imagemin.js` 中添加一下内容：

```javascript
const imageminWebp = require('imagemin-webp');

const convertPNGToWebp = () =>
  imagemin([PNGImages], output, {
    use: [
      imageminWebp({
        quality: 85,
      }),
    ]
  });

const convertJPGToWebp = () =>
  imagemin([JPGImages], output, {
    use: [
      imageminWebp({
        quality: 75,
      }),
    ]
  });

optimiseJPEGImages()
  .then(() => optimisePNGImages())
  .then(() => convertPNGToWebp())
  .then(() => convertJPGToWebp())
  .catch(error => console.log(error));
```

我发现，将`quality`参数设置为85时，产生的`WebP`图像，在质量上与PNG图像相似，但会大大缩小。对于 `jpeg` ，我发现将`quality`参数设置为75时，可以让我在视觉质量和文件大小之间找到一个很好的平衡。

老实说，我仍在尝试这些值，因此请勿将其作为建议。 并确保您检查 `imagemin-webp` 页面以查看其他可用选项。

### 在HTML中使用WebP图像

一旦你有了 `WebP` 图像，你可以使用下面的标记将它们提供给那些可以使用它们的浏览器，同时为那些不支持 `WebP` 的浏览器提供等价的(优化的) `JPEG` 或 `PNG` 回退。

```html
<picture>
    <source srcset="sample_image.webp" type="image/webp">
    <source srcset="sample_image.jpg" type="image/jpg">
    <img src="sample_image.jpg" alt="">
</picture>
```

使用此标记，支持 `webp` 媒体类型的浏览器将下载 `WebP` 进行转换并显示它，而其他浏览器将改为下载 `JPEG` 变体。

任何不理解 `<picture>` 的浏览器都会跳过所有`<source>`，并加载底部 `img` 标记的src属性中定义的内容。 因此，我们为所有类型的浏览器提供了支持，从而逐步增强了我们的页面。

请注意，在所有情况下，`img` 标签都是页面上实际呈现的内容，因此它确实是语法的必需部分。 如果省略 `img` 标签，则不会渲染任何图像。

`<picture>` 标签和其中定义的所有源均位于此处，以便浏览器可以选择要使用的图像变体。 选择来源图片后，其网址就会馈送到 `img` 标签，这就是显示的内容。

这意味着您无需设置 `<picture>` 或`<source>`标签的样式，因为它们不是由浏览器呈现的。 因此，您可以像以前一样仅对 `img` 标签进行样式设置。

## 总结

如您所见，优化图像以在 `Web` 上使用的过程并不那么复杂，并且可以通过减少页面加载时间来为客户带来更好的用户体验。