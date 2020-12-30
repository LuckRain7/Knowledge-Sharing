# 五个 JavaScript 小技巧

![Header](https://raw.githubusercontent.com/LuckRain7/Knowledge-Sharing/master/translate/content/five-javascript-patterns-i-like/header.png)

在这篇文章中，我将介绍一些我在编程时尝试使用的小技巧。这些技巧是我最近在工作中总结的，以及多年来从同事那里偷来的一些小技巧。

以下小技巧没没有特定的顺序。

## 1. 提早退出（Early exits）

```javascript
function transformData(rawData) {
  // 无效用例
  if (!rawData) {
    return [];
  }

  // 检查个别个案
  if (rawData.length == 1) {
    return [];
  }

  // 实际执行函数
  return rawData.map((item) => item);
}
```

我将这种模式称为“early exits”，但也有人将其称为“Bouncer 模式”或“guard clauses”。除了命名之外，该模式采用首先检查无效用例并从该函数返回的方法，否则它将继续执行函数的预期用例。

我非常喜欢这个方法的以下几点：

- 鼓励思考无效/边缘案例以及应如何处理这些案例
- 避免针对意外用例和不必要的代码处理
- 可以使我能够更清楚地处理每个用例
- 一旦被采用，你可以快速地浏览并理解流程是如何执行的，这通常遵循一种自上而下的方法，从-无效案例->小案例->预期案例

More info:

- [The bouncer pattern by Rik Schennink](http://rikschennink.nl/thoughts/the-bouncer-pattern/)

## 2. 从 Switch 切换到 Object（Switch to object literal）

```javascript
// Switch
let createType = null;
switch (contentType) {
  case "post":
    createType = () => console.log("creating a post...");
    break;
  case "video":
    createType = () => console.log("creating a video...");
    break;
  default:
    createType = () => console.log("unrecognized content type");
}

createType();

// Object literal
const contentTypes = {
  post: () => console.log("creating a post..."),
  video: () => console.log("creatinga  video..."),
  default: () => console.log("unrecognized content type"),
};

const createType = contentTypes[contentType] || contentTypes["default"];
createType();
```

下一步是去除 `switch`。 在编写每个`case`时，我经常会犯错误，而且常常会忘记`break`。 这会导致各种有趣的问题。 当我编写代码时，`switch`语句并没有给我带来便利，反而会带来一些困扰。

我更喜欢使用 Object，因为：

- 不用担心 `case` 和 `break`
- 非常便于理解
- 容易编写
- 代码更精简

More info:

- [Switch case, if else or a loopup map by May Shavin](https://medium.com/front-end-weekly/switch-case-if-else-or-a-lookup-map-a-study-case-de1c801d944)
- [Replacing switch statements with object literals by Todd Motto](https://ultimatecourses.com/blog/deprecating-the-switch-statement-for-object-literals)
- [Rewriting Javascript: Replacing the Switch Statement by Chris Burgin](https://medium.com/chrisburgin/rewriting-javascript-replacing-the-switch-statement-cfff707cf045)

## 3. 一次循环生成多数组（One loop two arrays）

```javascript
const exampleValues = [2, 15, 8, 23, 1, 32];
const [truthyValues, falseyValues] = exampleValues.reduce(
  (arrays, exampleValue) => {
    if (exampleValue > 10) {
      arrays[0].push(exampleValue);
      return arrays;
    }

    arrays[1].push(exampleValue);
    return arrays;
  },
  [[], []]
);
```

这种小技巧没有什么特别之处，但是我发现自己过滤了一组项目以获取符合特定条件的内容，然后针对不同的条件再次进行此操作。 那意味着要遍历一个数组两次，但是我可以只做一次。

我从 30secondsofcode.org 网站上 get 到的技巧。建议你去逛一逛这个网站，上面有很对非常有用的信息和代码。

我知道 reduce 可能有点令人生畏，而且不太清楚发生了什么，但如果你能适应它，你就能真正利用它来构建任何你需要的数据结构，同时循环一个集合。他们真的应该叫它 builder 而不是 reduce。

More info:

- [30secondsofcode.org](https://30secondsofcode.org/)

## 4. 不要使用 foo 变量（No 'foo' variables）

```javascript
// bad
const foo = y && z;

// good
const isPostEnabled = isPost && postDateValid;
```

多 花一些时间，尽力为自己的变量取个合适的名字。

这对于在职专业人员和教学人员尤其重要。 应该使用变量命名来帮助解释代码并为代码逻辑提供上下文。

别人能够阅读明白您的代码，了解要解决的问题。

More info:

- [The art of naming variables by Richard Tan](https://hackernoon.com/the-art-of-naming-variables-52f44de00aad)

## 5. 嵌套三元表达式（Nested ternaries）

```javascript
let result = null;
if (conditionA) {
  if (conditionB) {
    result = "A & B";
  } else {
    result = "A";
  }
} else {
  result = "Not A";
}

const result = !conditionA ? "Not A" : conditionB ? "A & B" : "A";
```

我承认，嵌套三元表达式的做法很令人反感。 这似乎是编写条件语句的一种炫技的方法。 在编写业务逻辑时，我认为 if 和 else 更容易读懂，因为它们是真实的单词，但是当这些单词嵌套时，我会开始很难跟上其中的嵌套并梳理清楚逻辑。

我开始学习去使用三元表达式和嵌套三元表达式，发现一眼就能快速了解发生了什么。我认为这种技巧取决于您和您的团队的编程偏好。

我在代码中使用的很好，嵌套的三元表达式的确可以提升自己的代码。

More info:

- [Nested Ternaries are Great by Eric Elliot](https://medium.com/javascript-scene/nested-ternaries-are-great-361bddd0f340)

---

原文作者：[John Stewart](https://www.johnstewart.dev/)

原文地址：[https://www.johnstewart.dev/five-programming-patterns-i-like/](https://www.johnstewart.dev/five-programming-patterns-i-like/)
