#  JavaScript 的 Array  对象 

>  JavaScript 的 Array 对象是用于构造数组的全局对象，数组是类似于列表的高阶对象。 

<details>
<summary><p style="color:#1890FF">目录：</p></summary>

- [属性](#1--属性)
- [方法](https://github.com/LuckRain7/arcgis-api-for-javascript-vue)
  + [Array.prototype.filter()](#arrayprototypefilter)
  + [Array.prototype.some()](#arrayprototypesome)

</details>



## 1.  属性

Array.length
Array.prototype[@@unscopables]

## 2.  方法
Array.from()
Array.isArray()
Array.of()
Array.prototype.concat()
Array.prototype.copyWithin()
Array.prototype.entries()
Array.prototype.every()
Array.prototype.fill()



### Array.prototype.filter()

> 创建一个新数组, 其包含通过所提供函数实现的测试的所有元素。 
> 断言函数值为 true ，返回数组中的值。
> 常用于数组内容的过滤
> [MDN Web 文档](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array/filter)

```javascript
[1, 2, 3, 4, 5].filter(x => x > 2); // [3, 4, 5]
```



Array.prototype.find()
Array.prototype.findIndex()
Array.prototype.flat()
Array.prototype.flatMap()
Array.prototype.forEach()
Array.prototype.includes()
Array.prototype.indexOf()
Array.prototype.join()
Array.prototype.keys()
Array.prototype.lastIndexOf()
Array.prototype.map()
Array.prototype.pop()
Array.prototype.push()
Array.prototype.reduce()
Array.prototype.reduceRight()
Array.prototype.reverse()
Array.prototype.shift()
Array.prototype.slice()

### Array.prototype.some()

> 测试数组中是不是至少有一个元素通过了被提供的函数测试 。
>
> 断言函数为结果为 true，则返回 true。
>
> 常用于判断数组是否包含某个值。

```javascript
[].some(x => x > 0); // false

[1, 2, 3].some(x => x > 2); // true
```



Array.prototype.sort()
Array.prototype.splice()
Array.prototype.toLocaleString()
Array.prototype.toSource()
Array.prototype.toString()
Array.prototype.unshift()
Array.prototype.values()
Array.prototype[@@iterator]()
get Array[@@species]
