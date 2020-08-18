# [新手向] Promise课程笔记整理

[MDN Promise 文档](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Promise)

- Promise 及其作用
  - ES6 内置类
  - 回调地狱：AJAX 的串行和并行
- Promise 的 executor 函数和状态
  - executor
  - Promise 状态
    - pending 初始状态
    - fulfilled 操作成功完成
    - rejected 操作失败
- Promise 中的 then 和 catch
  - then(func1,func2) / then(func)
  - catch(func)
  - then 链机制
- Promise 中其它常用方法
  - Promise.all
  - Promise.race
  - Promise.reject （选）
  - Promise.resolve （选）

## 1、Promise 及其作用

### 1-1、ES6 内置类

Promise 的诞生就是为了解决异步请求中的回调地狱问题：它是一种设计模式，ES6 中提供了一个 JS 内置类 Promise，来实现这种设计模式

```javascript
function ajax1() {
  return new Promise((resolve) => {
    $.ajax({
      url: "/url1",
      // ...
      success: resolve,
    });
  });
}

function ajax2() {
  return new Promise((resolve) => {
    $.ajax({
      url: "/url2",
      // ...
      success: resolve,
    });
  });
}

function ajax3() {
  return new Promise((resolve) => {
    $.ajax({
      url: "/url3",
      // ...
      success: resolve,
    });
  });
}

ajax1()
  .then((result) => {
    return ajax2(result.map((item) => item.id));
  })
  .then((result) => {
    return ajax3();
  })
  .then((result) => {});
```

### 1-2、回调地狱：AJAX 的串行和并行

回调地狱：上一个回调函数中继续做事情，而且继续回调（在真实项目的 AJAX 请求中经常出现回调地狱）=> 异步请求、不方便代码的维护

## 2、Promise 的 executor 函数和状态

### 2-1、executor

new Promise([executor]) ，[executor]执行函数是必须传递的

Promise 是用来管理异步编程的，它本身不是异步的。

new Promise 的时候会立即把 executor 函数执行（只不过我们一般会在 executor 函数中处理一个异步操作）

```javascript
// new Promise 的时候会立即把 executor 函数执行
let p1 = new Promise(() => {
  setTimeout((_) => {
    console.log(1);
  }, 1000);
  console.log(2);
});
console.log(3);

// 2.3.1
```

### 2-2、Promise 状态

```javascript
Promise {<pending>}
	__propt__:Promise
	[[PromiseStatus]]:"pending"
	[[PromiseValue]]:"undefined"

// Promise 本身有一个 Value 值，用来记录成功的结果（或者是失败的原因的） =>[[PromiseValue]]
```

Promise 本身有三个状态 => [[PromiseStatus]]

- pending 初始状态
- fulfilled 操作成功完成
- rejected 操作失败

```javascript
let p1 = new Promise((resolve, reject) => {
  setTimeout((_) => {
    // 一般会在异步操作结束后，执行resolve/reject函数，执行这两个函数中的一个，都可以修改Promise的[[PromiseStatus]]/[[PromiseValue]]
    // 一旦状态被改变，在执行resolve、reject就没有用了
    resolve("ok");
    reject("no");
  }, 1000);
});
```

## 3、Promise 中的 then 和 catch

### 3-1、then(func1,func2) / then(func)

new Promise 的时候先执行 executor 函数，在这里开启了一个异步操作的任务（此时不等：把其放入到 EventQuque 任务队列中），继续执行

p1.then 基于 then 方法，存储起来两个函数（此时这两个函数还没有执行）；当 executor 函数中的异步操作结束了，基于 resolve/reject 控制 Promise 状态，从而决定执行 then 存储的函数中的某一个

```javascript
let p1 = new Promise((resolve, reject) => {
  setTimeout((_) => {
    let ran = Math.random();
    console.log(ran);
    if (ran < 0.5) {
      reject("NO!");
      return;
    }
    resolve("OK!");
  }, 1000);
});
// then：设置成功或者失败后处理的方法
// Promise.prototype.then([resolvedFn],[rejectedFn])
p1.then(
  // 成功函数
  (result) => {
    console.log(`成功：` + result);
  },
  // 失败函数
  (reason) => {
    console.log(`失败：` + reason);
  }
);
```

resolve/reject 的执行，不论是否放到一个异步操作中，都需要等待 then 先执行完，把方法存储好，才会在更改状态后执行 then 中对应的方法 => 此处是一个异步操作（所以很多人说 Promise 是异步的），而且是微任务操作

```javascript
let p1 = new Promise((resolve, reject) => {
  resolve(100);
});
p1.then(
  (result) => {
    console.log(`成功：` + result);
  },
  (reason) => {
    console.log(`失败：` + reason);
  }
);
console.log(3);

// 3
// 成功：100
```

创建一个状态为成功/失败的 PROMISE 实例

这样的写法也可以被这种写法代替

Promise.resolve(100) | Promise.reject(0)

then 中也可以只写一个或者不写函数 （ .then(fn) | .then(null,fn) ）

### 3-2、catch(func)

Promise.prototype.catch(fn)

===> .then(null,fn)

```javascript
Promise.resolve(10)
  .then((result) => {
    console(a); //=>报错了
  })
  .catch((reason) => {
    console.log(`失败：${reason}`);
  });
```

### 3-3、then 链机制

then 方法结束都会返回一个新的 Promise 实例（then 链）

- [[PromiseStatus]]:'pending'

- [[PromiseValue]]:undefined

p1 这个 new Promise 出来的实例，成功或者失败，取决于 executor 函数执行的时候，执行的是 resolve 还是 reject 决定的，再或者 executor 函数执行发生异常错误，也是会把实例状态改为失败的

p2/p3 这种每一次执行 then 返回的新实例的状态，由 then 中存储的方法执行的结果来决定最后的状态（上一个 THEN 中某个方法执行的结果，决定下一个 then 中哪一个方法会被执行）

=> 不论是成功的方法执行，还是失败的方法执行（then 中的两个方法），凡是执行抛出了异常，则都会把实例的状态改为失败

=> 方法中如果返回一个新的 Promise 实例，返回这个实例的结果是成功还是失败，也决定了当前实例是成功还是失败

=> 剩下的情况基本上都是让实例变为成功的状态 （方法返回的结果是当前实例的 value 值：上一个 then 中方法返回的结果会传递到下一个 then 的方法中）

```javascript
let p1 = new Promise((resolve, reject) => {
  resolve(100);
});
let p2 = p1.then(
  (result) => {
    console.log("成功：" + result);
    return result + 100;
  },
  (reason) => {
    console.log("失败：" + reason);
    return reason - 100;
  }
);
let p3 = p2.then(
  (result) => {
    console.log("成功：" + result);
  },
  (reason) => {
    console.log("失败：" + reason);
  }
);
```

then 链式调用：

```javascript
Promise.resolve(10)
  .then(
    (result) => {
      console.log(`成功：${result}`);
      return Promise.reject(result * 10);
    },
    (reason) => {
      console.log(`失败：${reason}`);
    }
  )
  .then(
    (result) => {
      console.log(`成功：${result}`);
    },
    (reason) => {
      console.log(`失败：${reason}`);
    }
  );
```

遇到一个 then，要执行成功或者失败的方法，如果此方法并没有在当前 then 中被定义，则顺延到下一个对应的函数

```javascript
Promise.reject(10)
  .then((result) => {
    console.log(`成功：${result}`);
    return result * 10;
  })
  .then(null, (reason) => {
    console.log(`失败：${reason}`);
  });

// 失败：10
```

## 4、Promise 中其它常用方法

### 4.1、Promise.all

Promise.all(arr)：返回的结果是一个 Promise 实例（all 实例），要求 arr 数组中的每一项都是一个新的 Promise 实例，Promise.all 是等待所有数组中的实例状态都为成功才会让“all 实例”状态为成功，Value 是一个集合，存储着 arr 中每一个实例返回的结果；凡是 arr 中有一个实例状态为失败，“all 实例”的状态也是失败

```javascript
let p1 = Promise.resolve(1);
let p2 = new Promise((resolve) => {
  setTimeout((_) => {
    resolve(2);
  }, 1000);
});
let p3 = Promise.reject(3);

Promise.all([p2, p1])
  .then((result) => {
    // 返回的结果是按照 arr 中编写实例的顺序组合在一起的
    // [2,1]
    console.log(`成功：${result}`);
  })
  .catch((reason) => {
    console.log(`失败：${reason}`);
  });
```

### 4.2、Promise.race

Promise.race(arr)：和 all 不同的地方，race 是赛跑，也就是 arr 中不管哪一个先处理完，处理完的结果作为“race 实例”的结果

### 4.3、Promise.reject （选）

### 4.4、Promise.resolve （选）

```javascript
let p1 = Promise.resolve(100);
let p2 = new Promise((resolve) => {
  setTimeout((_) => {
    resolve(200);
  }, 1000);
});
let p3 = Promise.reject(3);

// 1 2 100
```

## 5、async/await

ES7 中提供了 Promise 操作的语法糖：async / await

```javascript
async function handle() {
  let result = await ajax1();
  result = await ajax2(result.map((item) => item.id));
  result = await ajax3();
  // 此处的result就是三次异步请求后获取的信息
}
handle();
```

async 是让一个普通函数返回的结果变为 status=resolved 并且 value=return 结构的 Promise 实例

async 最主要的作用是配合 await 使用的，因为一旦在函数中使用 await，那么当前的函数必须用 async 修饰

await 会等待当前 Promise 的返回结果，只有返回的状态是 resolved 情况，才会把返回结果赋值给 result

await 不是同步编程，是异步编程（微任务）:当代码执行到此行（先把此行），构建一个异步的微任务（等待 Promise 返回结果，并且 Promise 下面的代码也都被列到任务队列中），

```javascript
const p1 = () => new Promise();
const p2 = () => new Promise();

async function fn() {
  console.log(1);
  let result = await p2;
  console.log(result);

  let AA = await p1;
  console.log(AA);
}
fn();
console.log(2);

// 2
// 1
// p2 result
// p1 AA
```

如果 Promise 是失败状态，则 await 不会接收其返回结果，await 下面的代码也不会在继续执行（ await 只能处理 Promise 为成功状态的时候）

```javascript
const p3 = Promise.reject(10);
async function fn() {
  let reason = await p3;
  console.log(reason);
}
fn();

//
```

---

编辑时间：2020-08-18 21:15

