# 前端应该懂得初级Web分析指标

> UV、PV、跳出率（bounce rate）这些词到底是什么意思？怎么计算？
>
> 原文网址：https://hitmetrics.io/blog/starter-web-analytics-metrics-to-know

从事该行业足够长的时间的人们经常会忘记这些指标对于新人来说听起来很荒诞，所以您必须原谅他们。 要学习网络分析并了解它如何使您受益，最好先了解周围常见的术语，这是一个好主意。 

在本文中，我们将介绍基本的网络分析指标以及一些有关如何利用这些指标来推动洞察力的花絮。

![1](C:\Users\ZHCZ\Desktop\2020-06-13\1.jpg)

## 1. Unique Visitors

唯一身份访问者是推断访问您网站的人数。 之所以推断出此关键字，是因为其对经常访问某个网站的个人（您和我）的真实人数的准确性取决于您配置分析工具的方式。 Google Analytics（分析）和Adobe Analytics（分析）等工具的大多数现成配置都通过Cookie来标识唯一身份访问者。 这种 cookie 的用途与存储权限的 cookie完全不同。 通常，cookie用于在浏览器中存储少量数据，其中包括一种识别您是10天前访问此网站的同一个人的方法。

如果您从笔记本电脑和手机上浏览一个网站，会发生什么？ 尽管只有您，但报告的唯一身份访问者数量还是两个。 如果您要清除浏览器 Cookie 或以隐身模式访问网站，也是如此。 访问者在网站上进行身份验证后，更高级的分析配置将传递用户ID，以更准确地识别访问者。 此选项可能并不适用，也不适合所有人，因为它高度依赖于您所运行的网站的类型。

Bonus：考虑创建利用唯一身份访问者（例如回访者和单次访问者）的补充指标。 比较这两个指标可能会产生一些有趣的惊喜。

## 2.  **Visits/Sessions**

每个唯一的访问者在访问站点时都会进行浏览。 根据您使用的工具不同，此行程称为 **Visits 或 Sessions**。

![2](C:\Users\ZHCZ\Desktop\2020-06-13\2.jpeg)

在现实生活中，一次实际旅行可能只涉及一站或多站。 您可能只是在途中到当地咖啡馆短暂旅行，或者您可能正在下一次穿越落基山脉的大冒险。 同样，访问可以仅包含一个跟踪的整个访问活动，也可以包含许多活动，例如多个页面浏览量和转换事件。 拜访可能会很短，也可能会很长。 这完全取决于访问者在该访问中的行为。

在没有记录任何活动的持续时间之后，即结束访问。  尽管典型的超时持续时间为30分钟不活动，但实际时间会因分析工具或配置而异。 例如，如果我要早上访问此页面，一整天浏览这个页面和这个网站的其他页面，我将有两次访问关联到我的访问者配置文件。

Bonus：尝试对您的网站访问进行访问执行近期和频率分析。 这可以帮助您回答“转化者是否多次访问该网站？”这样的问题。 和“人们要等多久才能返回我的网站？”。

## 3. **Page Views**

页面浏览量是查看或加载特定页面的次数。 如果您尚未注意到趋势，那么我们一直在探索度量的概念，其中唯一访问者是活动的最高集合，访问与访问者绑定在一起，而页面浏览与特定访问者的访问绑定在一起。

我们将使用下面的示例来说明这三个相互连接的方式。

鲍勃在国庆日访问了Hitmetrics.io 登陆页面。 然后，Bob继续阅读该站点上的两篇博客文章，并离开了该站点。

在我们的网络分析工具中，鲍勃被视为1位唯一身份访问者，具有1次访问和3次页面浏览。

如果鲍勃决定第二天回来，尽管他还没有从前一天晚上的庆祝活动中清醒过来，会发生什么呢?在他的宿醉状态下，Bob决定重读他上次访问网站时标记为书签的一篇关于谷歌Analytics备选方案的文章。Bob只是想确保他在选择分析工具时做出了明智的选择。

现在，鲍勃将被视为1个唯一身份访问者，其中1次访问和1次页面浏览。 实际上，如果鲍勃在网站上没有做任何其他事情，那么他将被视为反弹！。 如果我们要报告包含这两天的时间范围，则我们的数据将显示我们有1个唯一身份访问者，2个访问和4个页面浏览量。

Bonus：“每次访问的页面浏览量”指标是确定网站内容的受欢迎程度的好方法，也可以指示用户的痛点。 比率越高，表示单次访问中浏览的页面越多。

## 4.  **Bounce Rate**

一些传统的营销人员非常喜欢或讨厌跳出率指标。跳出率由访问期间的行为决定。用一行字来描述它就是网站上单页访问的百分比。另一方面，跳出是只有一个页面视图的访问。

如果Bob只是访问过我们的主页而没有做任何其他事情，则Bob会被视为跳出，我们的网站跳出率将为100％。 从表面上看，这看起来真的很糟糕，有人可能会因为这种看似糟糕的表面现象而陷入困境。 但是，我要提醒任何使用此指标的人，但要知道跳出率根据网站及其结构而有所不同。 完全由一个页面组成的网站，即使您网站的每个访问者从头到尾都阅读页面内容，其跳出率也会达到100％。 只要符合您网站的目标以及它如何影响您的业务底线，高跳出率就不一定是一件坏事。

Bonus：将跳出率与您的流量来源报告相结合分析，以确定哪些流量来源真正享受您的内容。 如果您的目标是让用户留在您的网站上，那么您现在知道要关注的流量来源。