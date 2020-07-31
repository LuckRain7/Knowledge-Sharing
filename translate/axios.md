# axios 内部设计分析

![](https://imgkr2.cn-bj.ufileos.com/5f03eece-7eb3-47e4-84a6-ace58dbde41d.png?UCloudPublicKey=TOKEN_8d8b72be-579a-4e83-bfd0-5f6ce1546f13&Signature=s0yhYzGZXS1DEu7YJLb%252FndVK%252F90%253D&Expires=1596266102)


axios 是一个非常流行的 JavaScript 语言的 HTTP 请求库，本文分析它的内部设计。

> 原文作者：Alex
>
> 原文链接：https://www.tutorialdocs.com/article/axios-learn.html

## 概述

在前端开发过程中，我们经常遇到需要发送异步请求的情况。 功能齐全的 HTTP 请求库可以大大降低我们的开发成本并提高我们的开发效率。

Axios 是近几年来非常热门的 HTTP 请求库。 目前，它在 GitHub 上有超过4万颗星，并且被许多权威人士推荐。

因此，有必要了解 axios 的设计方式以及它如何帮助实现 HTTP 请求库。 在撰写本文时，axios的版本为0.18.0，所以让我们以此代码版本为例来阅读和分析特定的源代码。 当前axios的所有源文件都在lib文件夹中，因此以下所有路径均指lib文件夹的路径。

这里我们主要讨论

- 如何使用 axios

- axios 的核心模块（请求，拦截器，提取）如何设计和实现？

- axios 设计的优点是什么？



## 1、如何使用axios

要了解 axios 的设计，首先我们需要看一下如何使用 axios。 让我们用一个简单的例子说明以下 axios API。

### 发送一个请求：

```javascript
axios({
  method:'get',
  url:'http://bit.ly/2mTM3nY',
  responseType:'stream'
})
  .then(function(response) {
  response.data.pipe(fs.createWriteStream('ada_lovelace.jpg'))
});
```

这是一个官方的 API 示例。 从上面的代码中，我们可以看到 axios 的用法与 jQuery 的 ajax 非常相似，二者均返回Promise（它也可以在此处使用成功的回调，但建议使用 `Promise` 或 `await` ）来继续执行后续。

这个例子很简单，我不需要解释。 让我们看一下如何添加过滤器功能。

### 添加拦截器函数：

```javascript
// 添加一个请求拦截器. ps:注意，这里有两个函数:一个成功，一个失败
axios.interceptors.request.use(function (config) {
    // 发送请求前 对请求进行处理
    return config;
  }, function (error) {
    // Request error handling.
    return Promise.reject(error);
  });

// 添加一个响应拦截器
axios.interceptors.response.use(function (response) {
    // 对响应数据 进行处理
    return response;
  }, function (error) {
    // 对失败的响应 进行处理
    return Promise.reject(error);
  });
```

从上面的代码中我们可以看出 ：在发送请求之前，我们可以修改请求的配置参数。请求响应后，我们还可以对返回的数据执行特定的操作。 同时，当请求或响应失败时，我们可以进行特定的错误处理。

### 取消请求：

在开发与搜索相关的模块时，我们经常需要频繁发送数据查询请求。通常，在发送下一个请求时，我们需要取消上一个请求。

 axios的取消请求的示例代码如下：

```javascript
const CancelToken = axios.CancelToken;
const source = CancelToken.source();

axios.get('/user/12345', {
  cancelToken: source.token
}).catch(function(thrown) {
  if (axios.isCancel(thrown)) {
    console.log('Request canceled', thrown.message);
  } else {
    // handle error
  }
});

axios.post('/user/12345', {
  name: 'new name'
}, {
  cancelToken: source.token
})

// cancel the request (the message parameter is optional)
source.cancel('Operation canceled by the user.');
```

从上面的示例中可以看到，axios 中使用了基于 `CancelToken` 的提案撤回。但是，该建议现已撤回。具体的取消请求实现方法将在后面的源代码分析章节中解释。

## 2、axios的核心模块是如何设计和实现的？

通过上面的示例，我相信每个人都对 axios 的使用有一个大致的了解。 下面，我们将根据不同模块分析 axios 的设计和实现。 下图是我们将在此博客中介绍的相关 axios 文件。 如果您有兴趣，最好在阅读时克隆相关代码，这将加深对相关模块的理解。


![](https://imgkr2.cn-bj.ufileos.com/37285aea-657c-4473-a7e3-9713a974383a.png?UCloudPublicKey=TOKEN_8d8b72be-579a-4e83-bfd0-5f6ce1546f13&Signature=AGvERiZQzND2hhaH5XG11yODAwM%253D&Expires=1596266230)


### HTTP请求模块

与请求模块关联的代码位于 `core / dispatchReqeust.js` 文件中。 在这里，我仅选择一些关键源代码进行简要介绍：

```javascript
module.exports = function dispatchRequest(config) {
    throwIfCancellationRequested(config);

    // 其余代码.....

    // 默认适配器是一个模块，可以根据当前环境选择使用 Node 或 XHR 发送请求。
    var adapter = config.adapter || defaults.adapter; 

    return adapter(config).then(function onAdapterResolution(response) {
        throwIfCancellationRequested(config);

        // 其余代码.....

        return response;
    }, function onAdapterRejection(reason) {
        if (!isCancel(reason)) {
            throwIfCancellationRequested(config);

            // 其余代码.....

            return Promise.reject(reason);
        });
};
```

在上面的代码中，我们可以知道 `DispatchRequest` 方法是通过获取 `config.adapter` 来获取发送请求的模块。 我们还可以通过传递符合规范的适配器功能来替换原始模块（通常，我们不会这样做，但这是一个松散耦合的扩展点）。

在 `default.js` 相关文件中，我们可以看到相关 `adapter` 的选择逻辑，该逻辑将根据当前容器的某些唯一属性和构造函数进行确定。

```javascript
function getDefaultAdapter() {
    var adapter;
    // 只有Node.js具有变量类型为process的类。
    if (typeof process !== 'undefined' && Object.prototype.toString.call(process) === '[object process]') {
        // Node 请求模块
        adapter = require('./adapters/http');
    } else if (typeof XMLHttpRequest !== 'undefined') {
        // 浏览器请求模块
        adapter = require('./adapters/xhr');
    }
    return adapter;
}
```

axios 中的 `XHR` 模块相对简单，它是 `XMLHTTPRequest `对象的封装。 所以我在这里不再说明。 如果有兴趣，您可以自己阅读。 该代码位于`adapters/xhr.js`文件中。

### 拦截器模块 

现在，让我们看看 axios 如何实现请求和响应拦截器功能。 让我们看一下 axios 中的统一接口，下面的代码是请求功能。

```javascript
Axios.prototype.request = function request(config) {

    // 其余代码.....

    var chain = [dispatchRequest, undefined];
    var promise = Promise.resolve(config);

    this.interceptors.request.forEach(function unshiftRequestInterceptors(interceptor) {
        chain.unshift(interceptor.fulfilled, interceptor.rejected);
    });

    this.interceptors.response.forEach(function pushResponseInterceptors(interceptor) {
        chain.push(interceptor.fulfilled, interceptor.rejected);
    });

    while (chain.length) {
        promise = promise.then(chain.shift(), chain.shift());
    }

    return promise;
};
```

此功能是 axios 发送请求的接口。 由于函数的实现时间相对较长，因此我将简要讨论相关的设计思想：

1. 链是一个执行队列。 队列的初始值为具有配置参数的 `Promise`。
2. 在链执行队列中，插入用于发送请求的初始函数 `DispatchReqeust` 和对应于 `DispatchReqeust` 的未定义函数。 其中需要添加未定义的原因是`Promise` 中需要成功和失败的回调函数，这也可以从代码中看到 `promise = promise.then(chain.shift()，chain.shift());` 。 因此，`dispatchReqeust` 和 `undefined` 的功能可以视为一对功能。
3. 在链执行队列中，发送请求的函数 `DispatchReqeust` 位于中间。 它前面有一个请求拦截器，由 `unshift` 方法插入; 推送插入的响应拦截器将位于 `DispatchReqeust` 之后。 应当注意，这些功能是成对放置的，这意味着它们将一次放置两个。

通过上面的请求代码，我们大致知道如何使用拦截器。 接下来，让我们看看如何取消 `HTTP` 请求。

### 取消请求模块

与取消请求相关的模块在 `Cancel/` 文件中。 现在让我们看一下相关的关键代码。

首先，让我们看一下元数据 `Cancel` 类。 这是用于记录取消状态的类。 具体代码如下：

```javascript
function Cancel(message) {
  this.message = message;
}

Cancel.prototype.toString = function toString() {
  return 'Cancel' + (this.message ? ': ' + this.message : '');
};

Cancel.prototype.__CANCEL__ = true;
```

在 `CancelToken` 类中，它通过传递 `Promise` 方法来实现` HTTP` 请求取消，具体代码如下：

```javascript
function CancelToken(executor) {
    if (typeof executor !== 'function') {
        throw new TypeError('executor must be a function.');
    }

    var resolvePromise;
    this.promise = new Promise(function promiseExecutor(resolve) {
        resolvePromise = resolve;
    });

    var token = this;
    executor(function cancel(message) {
        if (token.reason) {
            // 已取消请求
            return;
        }

        token.reason = new Cancel(message);
        resolvePromise(token.reason);
    });
}

CancelToken.source = function source() {
    var cancel;
    var token = new CancelToken(function executor(c) {
        cancel = c;
    });
    return {
        token: token,
        cancel: cancel
    };
};
```

相应的取消请求代码在 `adapter/xhr.js` 文件中：

```javascript
if (config.cancelToken) {
    // 等待取消
    config.cancelToken.promise.then(function onCanceled(cancel) {
        if (!request) {
            return;
        }

        request.abort();
        reject(cancel);
        // 重置请求
        request = null;
    });
}
```

通过以上取消HTTP请求的示例，让我们简要讨论相关的实现逻辑：

1. 在可能需要取消的请求中，调用返回 `CancelToken` 类的实例A和`cancel`函数的 `source` 方法进行初始化。
2. 当`source`方法返回实例A时，将初始化一个处于待处理状态的 `Promise`。 将实例A传递到`axios`后，`Promise` 被用作一个触发器以取消请求。
3. 调用 `source` 方法返回的取消方法时，实例A中的 `Promise` 状态将从`pending` 修改为 `fulfilled`，然后立即触发回调函数。 因此触发了`axios`的取消逻辑 `request.abort()`。

## 3、axios设计的优点是什么？

### 发送请求功能的过程逻辑

如前几章所述，axios 并未将用于发送请求的 `DispatchRequest` 函数视为特殊功能。 实际上，`dispatchRequest` 函数将被放置在队列的中间，以确保队列的处理一致性并提高代码的可读性。

### 适配器的处理逻辑

在适配器的处理逻辑中，http 和 xhr 模块（一个用于Node.js发送请求，另一个用于浏览器发送请求）在`DispatchRequest` 中未直接用作其自己的模块， `default.js` 文件中介绍了默认配置的方法。 因此，它不仅确保了两个模块之间的低耦合，而且还为将来的用户定制请求发送模块留出了空间。

### 取消HTTP请求的过程逻辑

在取消`HTTP`请求的逻辑中，`axios`被设计为使用`Promise`作为触发器，将`resolve`函数作为外部参数传递给回调。 它不仅可以确保内部逻辑的一致性，而且可以确保在需要取消请求时，不必直接更改相关类的样本数据，从而可以最大程度地避免入侵其他模块。