# Fetch VS Axios

## Fetch

fetch与axios的定位认识。fetch是浏览器提供的api, axios是社区 封装的一个组件。

fetch是-一个低层次的API，你可以把它考虑成原生的XHR，所以使用起来并不是那么舒服，需要进行封装。多年来，`XMLHttpRequest` 一-直是web开发者的亲密助手。无论是直接的，还是间接的，当我们谈及Ajax技术的时候， 通常意思就是基于 `XMLHttpRequest` 的Ajax,它是一-种能够有效改进页面通信的技术。Ajax的兴起是由于`Google`的`Gmail`所带动的，随后被广泛的应用到众多的Web产品(应用)中，可以认为，开发者已经默认将
`XMLHttpRequest` 作为了当前Web应用与远程资源进行通信的基础。而本文将要介绍的内容则是`XMLHttpRequest` 的最新替代技术一一`Fetch API`，它是`W3C`的正式标准， 下面将会介绍Fetch API的相关知识，以及探讨它所能使用的场景和能解决的问题。

**一、fetch 优势:**

1.语法简洁，更加语义化

2.基于标准Promise实现，支持async/await

3.更加底层，提供的API丰富(request, response)

4.脱离了XHR，是ES规范里新的实现方式

**二、fetch 存在问题**

fetch是一个低层次的API，你可以把它考虑成原生的XHR，所以使用起来并不是那么舒服,需要进行封装。

1. fetch只对网络请求报错，对400, 500都当做成功的请求，服务器返回400, 500错误码时并不会reject，只有网络错误这些导致请求不能完成时，fetch 才会被reject。
2. fetch默认不会带cookie,需要添加配置项: fetch(url, {credentials: 'include'})
3. fetch不支持abort,不支持超时控制，使用setTimeout及 Promise.reject的实现的超时控制并不能阻止请求过程继续在后台运行，造成了流量的浪费
4. fetch没有办法原生监测请求的进度,而XHR可以(上传大文件的进度条)

```javascript
fetch('http://example.com/movies.json')
	.then(function(response){
  	return response.json()
	})
	.then(function(myJson){
  	conso.log(myJson)
	})
```

## axios

axios 是一个基于 Promise 用于浏览器和 nodejs 的 HTTP 客户端，本质上也是对原生XHR的封装，只不过它是Promise的实现版本,符合最新的ES规范,它本身具有以下特征:

1.从浏览器中创建 `XMLHttpRequest`(浏览器端与jq ajax 相似)

2.支持Promise API

3.客户端支持防止CSRF

4.提供了一-些并发请求的接口(重要, 方便了很多的操作 Promise.all() )

5.从node.js 创建http请求(node端，用的原生http模块)

6.拦截请求和响应

7.转换请求和响应数据

8.取消请求

9.自动转换 JSON 数据

```javascript
axios.get('/user',{
  params:{
    ID:12345
  }
})
.then(function(response){
  consle.log(response)
})
.catch(function(error){
  console.log(error)
})
```

总结：axios既提供了并发的封装，也没有fetch的各种问题，而且体积也比较小，也当之无愧在最应该选用的请求的方式。

## 明确考察点

1. fetch是规范底层api
2. axios是封装
3. fetch和axios的优缺点

## 回答思路

首先明确 fetch 和 axios 分别是个啥？然后阐述 fetch 和 axios 的优缺点



**fetch VS axios**

Fetch 是一个底层的 api 浏览器原生支持的。axios 是一个封装好的框架

**axios**

1、支持浏览器和nodejs发请求前后端发请求，

2、支持promise语法

3、支持自动解析json

4、支持中断请求

5、支持拦截请求

6、支持 请求进度监测

7、支持客户端防止csrf

一句话总结：封装的比较好

**fetch**

优点:

1、浏览器级别原生支持的api

2、原生支持promise api

3、语法简洁符合es标准规范

4、是由whatwg组织提出的现在 已经是w3c规范

缺点:

1、不支持文件上传进度监测

2、使用不完美需要封装

3、不支持请求中止

4、默认不带cookie

总之:缺点是需要封装优点底层原生支持