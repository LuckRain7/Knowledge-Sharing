# 在 Array.some 中正确使用 async

![封面](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0424/封面.png)



>  使用 `Promise` 检查集合 
>
> 本文译自：[How to use async functions with Array.some and every in Javascript - ]( https://advancedweb.hu/how-to-use-async-functions-with-array-some-and-every-in-javascript/ )

在[第一篇文章中](https://advancedweb.hu/asynchronous-array-functions-in-javascript/)， 我们介绍了async / await 如何帮助执行异步命令 ，但是在异步处理集合时却无济于事。在这篇文章中，当结果为布尔值时，我们将研究 `some` 和 `every` 函数用于更有效的 `reduce `

## 1.  some 和 every 函数

这些函数与`filter`一样，获得递归函数，但是它们根据断言函数是否返回特定值而返回单个 `true / false`。对于`some`，如果任何断言函数返回 `true`，则结果为true。对于该`every`函数，如果返回任何`false`，则结果将为`false`。

```javascript
const arr = [1, 2, 3];

const someRes = arr.some((i) => {
	return i % 2 === 0;
});

console.log(someRes);
// true

const everyRes = arr.every((i) => {
	return i < 2;
});

console.log(everyRes);
// false
```

## 2.  异步 some/every

### 2.1  使用异步  filter

仅考虑结果，可以使用 `async` 来模拟这些函数`filter`，在上一篇文章中已经介绍了如何将其转换为`async`。

```javascript
// sync
const some = (arr, predicate) => arr.filter(predicate).length > 0;
const every = (arr, predicate) => arr.filter(predicate).length === arr.length;

// async
const asyncSome =
	async (arr, predicate) => (await asyncFilter(arr, predicate)).length > 0;
const asyncEvery =
	async (arr, predicate) => (await asyncFilter(arr, predicate)).length === arr.length;
```

![Filter-based-async-some](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0424/Filter-based-async-some.png)



#### 短路（Short-circuiting）

但是，内置的`some`/ `every`函数和`filter`的实现之间存在重要的区别。当有一个元素为时返回true时，`some`将短路并且不处理其余元素：

```javascript
const arr = [1, 2, 3];

const res = arr.some((i) => {
	console.log(`Checking ${i}`);
	return i % 2 === 0;
});

// Checking 1
// Checking 2

console.log(res);
// true
```

![Synchronous-some](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0424/Synchronous-some.png)



同样，`every`在第一个错误结果之后停止：

```javascript
const arr = [1, 2, 3];

const res = arr.every((i) => {
	console.log(`Checking ${i}`);
	return i < 2;
});

// Checking 1
// Checking 2

console.log(res);
// false
```

让我们看看如何编写一个异步版本，该版本以类似的方式工作并且工作量最少！



### 2.2  异步 some

最好的解决方案是使用异步**进行迭代**，并在找到结果为 `true` 后立即返回：

```javascript
const arr = [1, 2, 3];

const asyncSome = async (arr, predicate) => {
	for (let e of arr) {
		if (await predicate(e)) return true;
	}
	return false;
};
const res = await asyncSome(arr, async (i) => {
	console.log(`Checking ${i}`);
	await sleep(10);
	return i % 2 === 0;
});

// Checking 1
// Checking 2

console.log(res);
// true
```

![For-based-async-some](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0424/For-based-async-some.png)



对于第一个元素`predicate(e)`返回结果为 `true`，它结束了for循环。

### 2.3  异步 every

类似的结构适用于`every`，这只是对条件求反的问题：

```javascript
const arr = [1, 2, 3];

const asyncEvery = async (arr, predicate) => {
	for (let e of arr) {
		if (!await predicate(e)) return false;
	}
	return true;
};
const res = await asyncEvery(arr, async (i) => {
	console.log(`Checking ${i}`);
	await sleep(10);
	return i < 2;
});

// Checking 1
// Checking 2

console.log(res);
// false
```

只要`predicate(e)`返回false，函数便会终止而不检查其他元素。

### 2.4  并行处理

短路（ short-circuiting ）实现顺序地处理元素，这在资源使用方面很有效，但可能导致执行时间更长。

例如，如果通过递归发送网络请求，则一次发送一个请求可能会花费一些时间。另一方面，虽然这可能导致发送更多的请求，但同时发送所有请求会更快。

## 3.  结论

`some`和`every`功能很接近异步`filter`，但要严格遵循同步规范，异步`for`循环是一个更好的选择。

#### 推荐阅读

  - [一道关于JavaScript 代码执行顺序的面试题解析](https://mp.weixin.qq.com/s/fJO-7OnSE82t6Gqqt8n0Fg)

  - [如何在 Array.forEach 中正确使用 async](https://mp.weixin.qq.com/s/39J2KO8h_cBKg3MWB63L7w)

  - [如何在 Array.filter 中正确使用 async](https://mp.weixin.qq.com/s/OtFsaLb2a26D0Uz4aFaoAw)

  - [如何在 Array.reduce 中正确使用 async](https://mp.weixin.qq.com/s/9wl8-SYspr3s358Tf0CmSg)

  - [如何在 Array.map 中正确使用 async](https://mp.weixin.qq.com/s/PdghejWyUjfWLBdOagPkkA)

  - [一道“简单”的This题解析](https://mp.weixin.qq.com/s/QLabNBOChsKmrpvEXJrpNg)

如果对你有所帮助，可以点赞、收藏。

![wx](https://luckrain7.github.io/Knowledge-Sharing/resource/images/wx.png)