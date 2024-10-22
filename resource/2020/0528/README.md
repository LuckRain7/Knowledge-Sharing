# 🔑 最佳密码长度是多少？

![cover](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0528/cover.png)

> 原文地址： https://advancedweb.hu/what-is-the-optimal-password-length/ 
>
> 原文作者： **Tamás Sallai** 

## 1.  引言

 如何选择一个密码，最好的保护您，防止数据泄漏。 

## 2.  密码强度

密码强度当然是越多越好，使用现有的密码管理软件，可以快速自动生成和填充任意长度的密码。但是，密码应该是多少位是最佳的，有没有一个合理的下限作为经验法则 

下面是一个典型的密码生成器界面: 

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0528/password-generator.png)

> 注意：它的密码长度可以设置8-100位字符



##  3.  数据泄露前，一个好的密码是你所拥有的一切 

但要理解什么是安全密码，让我们看看另一边发生了什么! 

当您创建帐户时，您正在注册的服务将以多种现有密码加密形式之一存储密码。密码直接将其放入数据库，或者使用现有算法对其进行散列。

一些最常用的哈希算法包括 ：

- MD5
- SHA-1
- Bcrypt
- Scrypt
- Argon2

存储散列数据而不是密码本身的好处是，密码不在数据库中。你只需要知道哪些散列数据是你的，而不必知道它具体的值是多少。当您登录时，提供的密码用相同的算法进行散列，如果结果与存储的值匹配，那么您就已经证明了您知道密码。而在数据库被攻破的情况下，密码是不可恢复的。 

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0528/Storing-hashes.png)

### 3.1   密码破解 

密码破解是攻击者试图逆转哈希函数并从哈希恢复密码。使用一个好的哈希算法，不可能恢复密码，但是尝试各种输入以查看它们是否产生相同的结果是不可能的。如果要找到这样的匹配，则需要从散列中恢复密码。 

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0528/Password-cracking.png)

选择一个好的算法在这里很重要。SHA-1 是为速度而设计的，速度有助于裂解过程。Bcrypt、Scrypt 和 Argon2被设计为以各种方式使裂化尽可能慢的高成本，特别是在专用硬件上，差异是巨大的。 

仅考虑速度，无法破解的 SHA-1 散列密码是这样的： `0OVTrv62y2dLJahXjd4FVg81`。 

使用正确配置的 Argon2 散列的安全密码： `Pa$$w0Rd1992`。 

正如您所看到的，选择正确的哈希算法可以使一个弱密码成为不可破解的密码。 

请记住，这仅取决于您要注册的服务的实现方式。 而且，您无法知道实现在哪一部分算法上。 您可以问，但是他们甚至可能不会回应或说他们“认真对待安全性”等类似话术。 

您是否相信公司会认真对待密码的安全性，使用良好的哈希算法而不是很糟糕的算法。查看被破坏的数据库列表，尤其是所使用的哈希。 他们中的许多人仍然使用MD5，大多数使用SHA-1，还有一些使用bcrypt。 有些甚至以纯文本形式存储密码。

这里存在一种偏见，因为我们只知道被攻破的数据库使用了什么哈希，而且使用弱算法的公司很可能也未能保护它们的基础设施。但是看看这个列表，我敢肯定您会发现一些您不会想到的熟悉的名称。仅仅因为一家公司看起来规模大、声誉好，并不意味着他们会做正确的事情。 

### 3.2  选择密码 

作为一个用户，下面的操作对您可能产生多大的影响? 

使用纯文本密码，您什么也做不了。如果数据库消失了，您的密码强度并不重要。 

使用正确配置的算法，您的密码的安全性也没有多大关系，不考虑 `12345` 和` asdf `这样的小情况。  

但在这两者之间，尤其是SHA-1，你的选择很重要。哈希函数通常不适合密码，但如果使用安全密码，就可以弥补算法的不足。 

| Hash algo | `asdf` | `AJnseykp` | `8VjB2qwD7eN3eG4Fjkfeks` |
| --------- | :----: | :--------: | :----------------------: |
| None      |   -    |     -      |            -             |
| MD5       |   -    |     -      |            ✓             |
| SHA-1     |   -    |     -      |            ✓             |
| Bcrypt    |   -    |     ✓*     |            ✓             |
| Scrypt    |   -    |     ✓*     |            ✓             |
| Argon2    |   -    |     ✓*     |            ✓             |

这取决于配置。这些散列有不同的移动部分，影响它们的强度，但当正确配置时，它们可以阻止试图破解。 

底线：如果你使用的是强密码，那么你比弱密码受到更多的攻击保护。由于您不知道密码存储的安全性如何，所以您无法确定对于给定的服务什么是足够安全的。所以，假设最坏的情况，设置高强度的密码。 

###  3.3  一个密码是不够的 

我们需要考虑是否使用密码管理器并为每个站点生成唯一的密码。在实际情况中，当一个站点服务被攻破，使用您的已知电子邮箱和密码在其他站点尝试攻击时， 多个密码会使您不会受到密码重用的攻击。  密码重用是非常常见的问题之一，同时也是一个巨大的威胁。 

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0528/Credential-stuffing.png)

为每个站点生成一个新密码可以避免这种情况。一个数据库被盗，黑客知道数据库内一切内容，为什么还要保护密码？

原因是，当您不知道数据库已被攻破，而继续使用该服务时。在这种情况下，黑客可以访问您未来在该站点上的所有活动。你可能以后再加一张信用卡，他们还是知道的。强密码意味着他们无法登录您的凭证，并且不能影响您未来的活动。 

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0528/Usage-after-breach.png)

## 4.   如何用熵来度量密码强度 

密码强度都与熵有关，熵是一种表示密码随机性的数值。因为我们处理的是大数，所以与其说有1,099,511,627,776(2的40次方)个不同的变量，倒不如说它有40位的熵。而密码破解的关键在于密码变体的数量，因为密码变体越多，尝试所有可能性所需的时间就越多。 

对于由密码管理器生成的随机字符，熵很容易计算：log2（<不同字符数> ^ <长度>）。 

长度是微不足道的，但是不同字符的数量是多少?这取决于密码的字符类型。 

| 字符类型     | 例子  | 字符数 |
| ------------ | :---: | :----: |
| 只有小写字母 |  abc  |   26   |
| + 大写字母   |  aBc  |   52   |
| + 数字       | aBc1  |   62   |
| + 特殊字符   | aB?c1 |   84   |

例如，长度为10的密码（包含大小写字母的随机混合）具有`log2（52 ^ 10）= 57`位熵。 

上面的数学表达式可以简化为使用 `log2(n ^ m) = m * log2(n) `表达式来查看给定类的单个字符对总体强度的影响。这样就得到了:`<长度> * log2(<不同字符的数量>)`，其中第二部分是每个字符的熵。上表，使用这个公式 

| 字符类型     |  例子   | 熵/字符(位) |
| ------------ | :-----: | :---------: |
| 只有小写字母 | 例子abc |  字符数4.7  |
| + 大写字母   |   aBc   |     5.7     |
| + 数字       |  aBc1   |    5.95     |
| + 特殊字符   |  aB?c1  |     6.4     |

要计算密码的强度，请考虑其组成的字符类型，从表中获取熵数并乘以长度。 上面的示例（长度为10的小写字母和大写字母）产生5.7 * 10 = 57位。 但是，如果将长度增加到14，则熵会跳到79.8位。 但是，如果将长度保持为10，但添加数字和特殊字符，则总熵将为64位。 

上面的表达式提供了一种快速计算密码熵的方法，但是有一个警告。它只适用于字符彼此独立的情况，这只适用于生成的密码。 

密码 `H8QavhV2gu `满足此条件，因此具有57位的熵。 

但是像`Pa$$word11`这样更容易记住的字符，虽然长度相同，字符类更多，但是熵却少得多。 破解者仅对字典中的单词进行一些转换就可以尝试所有组合。  

因此，任何基于字符类型的熵与长度相乘的计算都只对生成的密码有效。 

## 5.   熵的准则 

密码的熵越大，破解就越困难，但熵为多少才足够呢？一般的看法是，~16个字符对于密码来说应该足够了，根据是否包含特殊字符，密码的输出在95 - 102位之间。但是门槛是什么呢？80位？60位？或者即使使用102位也太低了 ？

还有一种算法在速度上类似于糟糕的密码散列算法，但研究得更好:AES加密。 

它用于加密各种政府和军事机构中的所有秘密，因此，其强度得到了充分考虑。 而且它的速度很快，因此，如果无法破解具有特定熵的密钥，那么AES对于具有错误（但不会破损）哈希值的密码将非常有用。 

NIST(国家标准和技术协会)是一个实体，它定义了在可预见的未来长度多少是合适的。2019 - 2030年及以后的AES-128，他们的建议是128位。 

![](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0528/AES-128.png)

 另一个专门针对关键密码长度的建议是至少使用112位的熵 。

>  对于联邦政府来说，此时应用加密保护(例如加密或签名数据)需要至少112位的安全强度。 

 要使用小写字母和大写字母以及数字来获得128位的熵，需要长度为22(5.95 * 22 = 131位)的熵。 #

##  6.  其他的考虑 

###  6.1  为什么没有特殊字符? 

我倾向于不使用特殊字符，因为它们打破了单词的边界。这意味着选择密码需要单击3次而不是2次，如果我不小心没有将部分密码粘贴到输入字段，就会产生错误。 

只用字符和数字，双击总是会选择整个密码。 

###  6.2  如果有一个最大长度呢? 

有些网站规定了密码的最大长度，以防止您使用22个字符。在某些情况下，它会达到极端的长度，比如需要恰好5位数字。 

在这种情况下，使用最大可用长度，您可以做的事情很少。 

还有一些关于该服务如何处理密码和限制密码长度的建议，显然是针对他们的。NIST的说 : 至少要有64个字符的长度以支持密码短语的使用。 鼓励用户使用自己喜欢的任何字符（包括空格）尽可能长地存储所记住的秘密，从而有助于记忆。 

记住，该服务可以存储密码的方式从糟糕到超级，他们不会告诉你他们是如何做到的？较短的密码长度给人的印象是，他们的强度会很差。 

## 结论

强大的密码是需要的，即使你不重用它们。强度是用熵来衡量的，你应该以128 bits  为目标。长度为22的小写+大写+数字密码组合可以查过128 bits  。这种密码将在数据泄漏时保护您。

#### 推荐阅读

- [如何在 Array.forEach 中正确使用 async](https://mp.weixin.qq.com/s/39J2KO8h_cBKg3MWB63L7w)

- [如何在 Array.filter 中正确使用 async](https://mp.weixin.qq.com/s/OtFsaLb2a26D0Uz4aFaoAw)

- [如何在 Array.reduce 中正确使用 async](https://mp.weixin.qq.com/s/9wl8-SYspr3s358Tf0CmSg)

- [如何在 Array.map 中正确使用 async](https://mp.weixin.qq.com/s/PdghejWyUjfWLBdOagPkkA)

- [如何在 Array.some 中正确使用 async](https://mp.weixin.qq.com/s/-kBwis0MhRNgVEtDF7wPYA)
