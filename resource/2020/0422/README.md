# 如何正确的在 Array.map 使用 async

>  在 `map` 中返回Promises，然后等待结果 
>
>   本文译自[How to use async functions with Array.map in Javascript - **Tamás Sallai** ](https://advancedweb.hu/how-to-use-async-functions-with-array-map-in-javascript/)。 

在前面的文章中，我们介绍了 async / await如何帮助执行异步命令 ，但在异步处理集合时却无济于事。在本文中，我们将研究该`map`函数，该函数是最常用的函数，它将数据从一种形式转换为另一种形式（这里可以理解为 `map`具有返回值）。 

## 1.  Array.map

该`map`是最简单和最常见的采集功能。它通过迭代函数运行每个元素，并返回包含结果的数组。

向每个元素添加一的同步版本：

```javascript
const arr = [1, 2, 3];

const syncRes = arr.map((i) => {
	return i + 1;
});

console.log(syncRes);
// 2,3,4
```

异步版本需要做两件事。首先，它需要将每个项目映射到具有新值的 `Promise`，这是`async`在函数执行之前添加的内容。

其次，它需要等待所有`Promises`，然后将结果收集到Array中。幸运的是，`Promise.all`内置调用正是我们执行步骤2所需的。

这使得一个异步的一般模式`map`是`Promise.all(arr.map(async (...) => ...))`。

异步实现与同步实现相同：

```javascript
const arr = [1, 2, 3];

const asyncRes = await Promise.all(arr.map(async (i) => {
	await sleep(10);
	return i + 1;
}));

console.log(asyncRes);
// 2,3,4
```

![Async map](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0422/Async-map.png)



## 2.  并发

上面的实现为数组的每个元素并行运行迭代函数。通常这很好，但是在某些情况下，它可能会消耗过多的资源。当异步函数访问 `API` 或消耗过多的RAM以至于无法一次运行太多RAM时，可能会发生这种情况。

尽管异步`map`易于编写，但要增加并发控件。在接下来的几个示例中，我们将研究不同的解决方案。

### 2.1  批量处理

最简单的方法是对元素进行分组并逐个处理。这使您可以控制一次可以运行的最大并行任务数。但是由于一组必须在下一组开始之前完成，因此每组中最慢的元素成为限制因素。

![Mapping in groups](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0422/Mapping-in-groups.png)

为了进行分组，下面的示例使用`Underscore.js`的`groupBy`实现。许多库提供了一种实现，并且它们大多数都是可互换的。`Lodash`是个例外，因为其 `groupBy` 不传递 `item `的索引。

如果您不熟悉`groupBy`，它将通过迭代函数运行每个元素，并返回一个对象，其键为结果，值为产生该值的元素的列表。

为了使群体最多`n`的元素，一个迭代器 `Math.floor(i / n)`，其中 `i` 是元素的索引。例如，一组大小为3的元素将映射以下元素：

```
0 => 0
1 => 0
2 => 0
3 => 1
4 => 1
5 => 1
6 => 2
...
```

Javascript实现：

```Javascript
const arr = [30, 10, 20, 20, 15, 20, 10];

console.log(
	_.groupBy(arr, (_v, i) => Math.floor(i / 3))
);
// {
// 	0: [30, 10, 20],
// 	1: [20, 15, 20],
// 	2: [10]
// }
```

最后一组可能比其他组小，但是保证所有组都不会超过最大组大小。

要映射一组，通常的`Promise.all(group.map(...))`构造是很好。

要按顺序映射组，我们需要一个reduce，它将先前的结果（`memo`）与当前组的结果连接起来：

```javascript
return Object.values(groups)
	.reduce(async (memo, group) => [
		...(await memo),
		...(await Promise.all(group.map(iteratee)))
	], []);
```

此实现基于以下事实：`await memo`等待上一个结果的完成才进行下一个任务。

实现批处理的完整实现：

```javascript
const arr = [30, 10, 20, 20, 15, 20, 10];

const mapInGroups = (arr, iteratee, groupSize) => {
	const groups = _.groupBy(arr, (_v, i) => Math.floor(i / groupSize));

	return Object.values(groups)
		.reduce(async (memo, group) => [
			...(await memo),
			...(await Promise.all(group.map(iteratee)))
		], []);
};

const res = await mapInGroups(arr, async (v) => {
	console.log(`S ${v}`);
	await sleep(v);
	console.log(`F ${v}`);
	return v + 1;
}, 3);

// -- first batch --
// S 30
// S 10
// S 20
// F 10
// F 20
// F 30
// -- second batch --
// S 20
// S 15
// S 20
// F 15
// F 20
// F 20
// -- third batch --
// S 10
// F 10

console.log(res);
// 31,11,21,21,16,21,11
```

### 2.2  并行处理

并发控制的另一种类型是并行执行大多数`n`任务，并在完成一项任务时启动一个新任务。

![ Controlled concurrency ](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0422/Controlled-concurrency.png)

我无法为此提供一个简单的实现，但是幸运的是，Bluebird提供了一个开箱即用的库。这很简单，只需导入库并使用`Promise.map`支持该`concurrency`选项的功能即可。

在下面的示例中，并发限制为`2`，这意味着立即启动2个任务，然后每完成一个任务，就开始一个新任务，直到没有剩余：

```javascript
const arr = [30, 10, 20, 20, 15, 20, 10];

// Bluebird promise
const res = await Promise.map(arr, async (v) => {
	console.log(`S ${v}`)
	await sleep(v);
	console.log(`F ${v}`);
	return v + 1;
}, {concurrency: 2});

// S 30
// S 10
// F 10
// S 10
// F 30
// S 20
// F 10
// S 15
// F 20
// S 20
// F 15
// S 20
// F 20
// F 20

console.log(res);
// 31,11,21,21,16,21,11
```

### 2.3  顺序处理

有时，并发太多，因此应该一个接一个地处理元素。

![Mapping-sequentially](https://luckrain7.github.io/Knowledge-Sharing/resource/2020/0422/Mapping-sequentially.png)

一个简单的实现是使用并发性为 1 的 `Bluebird` 的 `Promise`。但是在这种情况下，它不保证包括一个库，因为`reduce`这样做很简单：

```javascript
const arr = [1, 2, 3];

const res = await arr.reduce(async (memo, v) => {
	const results = await memo;
	console.log(`S ${v}`)
	await sleep(10);
	console.log(`F ${v}`);
	return [...results, v + 1];
}, []);

// S 1
// F 1
// S 2
// F 2
// S 3
// F 3

console.log(res);
// 2,3,4
```

确保在执行任何其他操作之前 `await memo`，因为如果没有 `await`，它仍然会并发运行！

## 3.  结论

该`map`功能很容易转换为异步，因为`Promise.all`内置功能繁重。但是控制并发需要一些计划。

### 推荐阅读

- [如何在 Vue 中优雅的使用防抖节流](https://mp.weixin.qq.com/s/mFmqyicyfaAOdxmhlPmSRQ) 

- [如何在 Array.forEach 中正确使用 async](https://mp.weixin.qq.com/s/39J2KO8h_cBKg3MWB63L7w)

- [如何在 Array.filter 中正确使用 async](https://mp.weixin.qq.com/s/OtFsaLb2a26D0Uz4aFaoAw)

- [如何在 Array.reduce 中正确使用 async](https://mp.weixin.qq.com/s/9wl8-SYspr3s358Tf0CmSg)

如果对你有所帮助，可以点赞、收藏。

![wx](https://luckrain7.github.io/Knowledge-Sharing/resource/images/wx.png)