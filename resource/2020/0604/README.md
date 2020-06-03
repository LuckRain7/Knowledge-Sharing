# 正确的将 Promise 链重构为 async 函数

![2020-06-03-cover](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0603/2020-06-03-cover.png)

> 原文地址：advancedweb.hu/how-to-refactor-a-promise-chain-to-async-functions/#refactoring-to-asyncawait
>
> 原文作者：Tamás Sallai

## 0.引言

将一系列 then() 函数转换为 async/await，而不会丢失函数作用域

## 1. 重构成 async/await

现在，async/await 已经得到了广泛的支持、应用 ，Promises 已经是一种老的解决方案了，但是它们仍然是驱动所有异步操作的引擎。 但是构造一个并使用`.then()` 函数进行异步链式操作的情况越来越少。 这提醒我们从基于 Promise 的链重构为 async/await。

例如，这个异步代码使用`.then()` 进行链式操作：

```javascript
doSomething().then(doSomethingElse).then(finishWithSomething);
```

使用 async/await 进行重构：

```javascript
const sth = await doSomething();
const sthElse = await doSomethingElse(sth);
const fin = await finishWithSomething(sthElse);
```

重构的代码不仅简短且更加容易识别，因为它看起来像是一个同步代码。 所有复杂性高都可以由 async / await 构造处理。

但是，当我将基于`.then()`结构转换为 async / await 时，我总是有一种感觉，即原始代码在确定步骤中的变量方面做的更好，而 async / await 版本则泄漏了它们。

## 2. Promise 链

让我们看一个假设的多步骤处理过程，该过程获取并调整用户 ID 的头像：

```javascript
const width = 200;
const res = (result) => console.log(`Sending ${result}`);

Promise.resolve(15)
  .then((id) => {
    // get user
    return `[user object ${id}]`;
  })
  .then((user) => {
    // get avatar image
    return `[image blob for ${user}]`;
  })
  .then((image) => {
    // resize image
    return `[${image} resized to width:${width}]`;
  })
  .then((resizedImage) => {
    // send the resized image
    res(resizedImage);
  });

// Sending [[image blob for [user object 15]] resized to width:200]
```

![image-20200603140035407](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0603/image-20200603140035407.png)

每个步骤都可以使用异步操作，例如连接到数据库或使用远程 API。

通过使用`.then()`，在函数内部声明的变量是该函数的局部变量，无法从其他步骤访问。 由于范围内变量的数量受到限制，因此使代码更易于理解。

例如，如果使用 fetch 获取图像并将结果存储在一个值中，则在下一步中将看不到它：

```javascript
...
	.then((user) => {
		const imageRequest = ...;
		// ...
	}).then((image) => {
		// imageRequest is not accessible
	})
```

对于参数也是如此：

```javascript
...
	.then((user) => {
		// ...
	}).then((image) => {
		// user is not accessible
	})
```

## 3. 转换成 async/await

将上面的代码转换为 async / await 很简单，只需在步骤之前添加 awaits 并将结果分配给变量：

```javascript
const width = 200;
const res = (result) => console.log(`Sending ${result}`);
const id = 15;

// get user
const user = await `[user object ${id}]`;

// get avatar image
const image = await `[image blob for ${user}]`;

// resize image
const resizedImage = await `[${image} resized to width:${width}]`;

// send the resized image
res(resizedImage);
```

代码更短，看起来一点也不异步。

但是现在每个变量都在整个函数的范围内。 如果一个步骤需要存储某些内容，则没有什么可以阻止下一步访问它。 同样，可以访问上一步的每个结果：

```javascript
// get avatar image
const imageRequest = ...;
const image = await `[image blob for ${user}]`;

// resize image
// imageRequest is in scope
// user is also in scope
const resizedImage = await `[${image} resized to width:${width}]`;
```

转换后的代码相比之前代码，没有了异步操作的边界性和清晰变量定义的特征。

## 4. Async IIFEs

由于较大的问题之一是可变作用域，因此可以通过为每个步骤重新引入一个函数来解决。 这样可以防止在内部声明的变量泄漏到下一步。

一个 async IIFE 结构：

```javascript
const result = await (async () => {
  // ...
})();
```

上面使用这种方法的示例如下所示：

```javascript
const width = 200;
const res = (result) => console.log(`Sending ${result}`);
const id = 15;

// get user
const user = await (async () => {
  return await `[user object ${id}]`;
})();

// get avatar image
const image = await (async () => {
  return await `[image blob for ${user}]`;
})();

// resize image
const resizedImage = await (async () => {
  return await `[${image} resized to width:${width}]`;
})();

// send the resized image
res(resizedImage);
```

这可以进行可变作用域，但是前面的结果仍然可用。

但是这种方法最大的问题是它看起来很难看。虽然是同步代码形式，但看起来根本不熟悉。

## 5. 异步递归

另一种方法是使用类似于功能收集管道的结构。 它需要为每个步骤使用单独的函数，然后进行异步化简，按顺序调用每个函数。 这种结构不仅使所有功能分离，因为每个函数只能访问其参数，而且还可以促进代码重用。

### 5.1 处理步骤

第一步是将每一个中间步骤移到单独的异步函数上：

```javascript
const getUser = async (id) => {
  // get user
  return `[user object ${id}]`;
};

const getImage = async (user) => {
  // get avatar image
  return `[image blob for ${user}]`;
};

// see below
// const resizeImage = ...

const sendImage = async (image) => {
  // send the resized image
  console.log(`Sending ${image}`);
};
```

当一个函数不仅需要先前的结果而且还需要一些其他参数时，请使用一个高阶函数，该函数首先获取这些额外的参数，然后再获取先前的结果：

```javascript
const resizeImage = (width) => async (image) => {
  // resize image
  return `[${image} resized to width:${width}]`;
};
```

请注意，上述所有函数均符合 `async（prevResult）=> ... nextResult`或`（parameters）=> async（prevResult）=> ... nextResult`的结构。 通过使用参数调用后者，可以将后者转换为前者。

### 5.2 异步递归结构

通过获得前一个结果并与下一个产生 Promise 的函数，reduce 可以调用它们，同时还可以处理等待的结果：

```javascript
[getUser, getImage, resizeImage(200), sendImage].reduce(
  async (memo, fn) => fn(await memo),
  15
);
```

在此示例中，函数定义了步骤，值流经它们。 15 是初始值（前面示例中的 userId），reduce 的结果是最后一个函数的结果。

这种结构保留了基于 Promise 链的原始实现中明确定义的步骤，同时还利用了异步功能。

## 6. 结论

不赞成使用 Promises，因为使用 async / await 代替它们会产生易于理解的代码。 但是，通过用 awaits 替换`thens`来重写所有使用 Promises 的东西，通常会产生一个长期难以维护的结构。 使用异步缩减有助于保留原始结构。

#### 推荐阅读

- [如何在 Array.forEach 中正确使用 async](https://mp.weixin.qq.com/s/39J2KO8h_cBKg3MWB63L7w)
- [如何在 Array.filter 中正确使用 async](https://mp.weixin.qq.com/s/OtFsaLb2a26D0Uz4aFaoAw)
- [如何在 Array.reduce 中正确使用 async](https://mp.weixin.qq.com/s/9wl8-SYspr3s358Tf0CmSg)
- [如何在 Array.map 中正确使用 async](https://mp.weixin.qq.com/s/PdghejWyUjfWLBdOagPkkA)
- [如何在 Array.some 中正确使用 async](https://mp.weixin.qq.com/s/-kBwis0MhRNgVEtDF7wPYA)

#### 关注我不迷路

![wx](https://luckrain7.github.io/Knowledge-Sharing/resource/images/wx.png)
