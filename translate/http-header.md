#  有趣的 HTTP 头信息 

> 原文地址： https://frenxi.com/http-headers-you-dont-expect/ 
>
> 原文作者： Francesco Carlucci 

 几天前，我在Creditkarma的博客中闲逛，发现了这个HTTP标头： 

```http
X-hacker: If you're reading this, you should visit wpvip.com/careers and apply to join the fun, mention this header.
```

我的第一个想法是：“哇，在过去，我们利用 Millennium Bug 来保存一些数据，现在公司在HTTP标头中提供了完整的工作机会！” 

这让我很好奇，所以我做了一些研究！ 

如果您将站点托管在由 Automattic 管理的企业 WordPress 托管解决方案 WordPress VIP 上，则该特定标头似乎是“默认”标题。您可以在许多著名的网站上找到相同的标题，例如： 

- https://nypost.com/
- https://techcrunch.com/
- https://www.nbcolympics.com/
- https://www.thesun.co.uk/

开发人员和网站所有者可以禁用它，但老实说，我怀疑他们甚至不知道在每个网站HTTP响应中都包含该标头。当然，我的第二个想法是检查其他公司是否有任何形式的广告标头。 

 **结果令人惊讶！** 

### 您可以在HTTP标头中找到多个职位空缺

 是的 ! 世界上最酷的公司似乎在以下HTTP标头中提供了工作机会：`x-recruiting`。 

 一些例子是： 

Paypal.me

```
x-recruiting: If you are reading this, maybe you should be working at PayPal instead! Check out www.paypal.com/us/webapps/mpp/paypal-jobs
```


Booking.com

```
x-recruiting: Like HTTP headers? Come write ours: careers.booking.com
```


Etsy.com

```
x-recruiting: Is code your craft? www.etsy.com/careers
```


 Otto.de 

```
x-recruiting: Seems you like http headers. To write ours, apply at job.otto.de and mention this header.
```


需要完整的清单吗？我为此创建了一个GitHub存储库：[https](https://github.com/francescocarlucci/job-offers-http-headers) : [//github.com/francescocarlucci/job-offers-http-headers](https://github.com/francescocarlucci/job-offers-http-headers)

乔布斯提供了很多东西，在我的研究中，我还发现了更多有创造力的东西，因为我很高兴我是一个神秘的胡说八道的狂热者。

### 神秘的HTTP标头

 9kw.eu，一个似乎分发验证码系统的网站，告诉我们42是秘密信息： 

```
X-Secret-Message: 42
```

Istreetview.com 不再维护，但是它们的标题中隐藏了一个Web表单。

```
X-Secret-URL: https://appio.link/secret
```

我提交了...

Thetradersdomain.com 的标题中隐藏了一个调味酱，但它是机密的：

```
x-secret-sauce: Confidential
```

Images-dnxlive.com 在他的HTTP标头之一中还有一些“秘密”链接：

```
X-Secret-Message: camscv.dnxnetwork.lu
```

jaguar.ro 有一个标头可以检测机器人：

```
X-Bot: false
```

但是它不能很好地工作，如果您欺骗了用户代理，它就会失败（对不起，Jaguar）。

但是...您见过**带有昵称**的**服务器吗？**这里有几个：

X-men.com

```
X-ServerNickName: clint
```

------

Howgoodisyourseo.com

```
X-ServerNickName: The Internet
```

有很多期待我们去探索，我们在 m.bidorbuy.co.ke 上的朋友向我们展示了他们对HTTP标头的全部热情：

```
x-powered-by: Passion and tiny cute kittens
x-servernickname: The Beast
x-hacker: If you are reading this, maybe you should be working at bidorbuy instead
```

### 意外收获 

似乎很多令人着迷的 IT 公司都有额外的 HTTP 标头，其中大多数包含工作机会。

因此，我认为向网站添加额外的标题也很酷！

#### 致谢

文章了解于 [科技爱好者周刊：第 108 期 - 阮一峰]( http://www.ruanyifeng.com/blog/2020/05/weekly-issue-108.html )