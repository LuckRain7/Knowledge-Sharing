#  **Object** 

> 参考网站：[ Object - JavaScript | MDN : https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object ]( https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object )

## 1.  属性

Object.prototype.__proto__
Object.prototype.constructor

## 2.  方法
Object.assign()
Object.create()
Object.defineProperties()
Object.defineProperty()
Object.entries()
Object.freeze()
Object.fromEntries()
Object.getOwnPropertyDescriptor()
Object.getOwnPropertyDescriptors()
Object.getOwnPropertyNames()
Object.getOwnPropertySymbols()
Object.getPrototypeOf()
Object.is()
Object.isExtensible()
Object.isFrozen()
Object.isSealed()

### Object.keys()

> 方法会返回一个由一个给定对象的自身可枚举属性组成的数组，数组中属性名的排列顺序和正常循环遍历该对象时返回的顺序一致 。 
>
> [Object.keys() - JavaScript | MDN]( https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/keys )

```javascript
var arr = ['a', 'b', 'c'];
console.log(Object.keys(arr)); // console: ['0', '1', '2']

// getFoo is a property which isn't enumerable
var myObj = Object.create({}, {
  getFoo: {
    value: function () { return this.foo; }
  } 
});
myObj.foo = 1;
console.log(Object.keys(myObj)); // console: ['foo']
```



Object.preventExtensions()
Object.prototype.__defineGetter__()
Object.prototype.__defineSetter__()
Object.prototype.__lookupGetter__()
Object.prototype.__lookupSetter__()
Object.prototype.hasOwnProperty()
Object.prototype.isPrototypeOf()
Object.prototype.propertyIsEnumerable()
Object.prototype.toLocaleString()
Object.prototype.toSource()
Object.prototype.toString()
Object.prototype.valueOf()
Object.seal()
Object.setPrototypeOf()
Object.values()

## 3.  继承

Function
属性
Function.arguments
Function.caller
Function.displayName
Function.length
Function.name
方法
Function.prototype.apply()
Function.prototype.bind()
Function.prototype.call()
Function.prototype.toSource()
Function.prototype.toString()