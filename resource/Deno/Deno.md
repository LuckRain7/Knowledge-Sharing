# Deno 1.0

> 原文地址：[ https://deno.land/v1 ]( https://deno.land/v1 )
>
> 2020-05-13
>
> Ryan Dahl, Bert Belder, and Bartek Iwańczuk

动态语言是有用的工具。 脚本编写使用户可以快速简洁地将复杂的系统连接在一起并表达想法，而不必担心诸如内存管理或构建系统之类的细节。 近年来，像Rust和Go这样的编程语言使生产复杂的本机代码变得更加容易。 这些项目是计算机基础架构中极为重要的发展。 但是，我们声称拥有一个能够解决各种问题领域的强大脚本环境仍然很重要。 

 JavaScript 是使用最广泛的动态语言，可通过Web浏览器在每台设备上运行。 大量的程序员精通JavaScript，并且已经在优化其执行方面投入了大量精力。 通过像 ECMA International 这样的标准组织，对语言进行了认真，不断的改进。 我们相信 JavaScript 是动态语言工具的自然选择； 无论是在浏览器环境中还是作为独立进程。 

 我们在该领域的原始事业 Node.js 被证明是一个非常成功的软件平台。 人们发现它对于构建Web开发工具，构建独立的Web服务器以及许多其他用例很有用。 但是，Node是在2009年设计的，当时 JavaScript 是一种非常不同的语言。 出于必要，Node必须发明概念，这些概念后来被标准组织采纳，并以不同的方式添加到语言中。 在“ [Design Mistakes in Node](https://www.youtube.com/watch?v=M3BM9TB-8yA) ”演示文稿中，对此进行了更详细的讨论。 由于 Node 拥有大量用户，因此发展该系统既困难又缓慢。 

 随着 JavaScript 语言的不断变化以及诸如 TypeScript 之类的新功能，构建 Node 项目可能会成为一项艰巨的工作，涉及管理构建系统和其他繁重的工具，这些工具剥夺了动态语言脚本的乐趣。  此外，链接到外部库的机制基本上是通过 NPM 存储库集中的， 这不符合Web的理想。 

 我们认为JavaScript和周围的软件基础架构已经发生了足够的变化，值得进行简化。 我们寻求一种有趣且高效的脚本环境，可胜任多种任务。 

## 1.  一个用于命令行脚本的Web浏览器 (A Web Browser for Command-Line Scripts)

Deno 是一个新的运行时，用于在Web浏览器之外执行JavaScript和TypeScript。 

Deno 试图提供一个独立的工具来快速编写复杂功能的脚本。 Deno 是（并将始终是）单个可执行文件。 就像网络浏览器一样，它知道如何获取外部代码。 在 Deno 中，单个文件可以定义任意复杂的行为，而无需任何其他工具。 

```typescript
import { serve } from "https://deno.land/std@0.50.0/http/server.ts";
for await (const req of serve({ port: 8000 })) {
  req.respond({ body: "Hello World\n" });
}
```

Here a complete HTTP server module is added as a dependency in a single line. There are no additional configuration files, there is no install to do beforehand, just **`deno run example.js`**.

在这里，一个完整的 HTTP 服务器模块作为依赖项添加到一行中。没有额外的配置文件，没有安装，只有 **`deno run example.js`**.

与浏览器一样，默认情况下，代码在安全的沙箱中执行。 未经允许，脚本无法访问硬盘驱动器，打开网络连接或进行任何其他潜在的恶意操作。 浏览器提供了用于访问相机和麦克风的 API，但用户必须首先授予权限。  Deno 在终端中提供类似的行为。 除非提供 `--allow-net` 命令行标志，否则以上示例将失败。 

Deno 很注意不偏离标准的浏览器JavaScript api。当然，并不是每个浏览器 API 都与 Deno 相关，但是无论它们在哪里，Deno 都不会偏离标准。 

## 2.   第一个TypeScript支持 (First Class TypeScript Support)

我们希望 Deno 适用于广泛的问题领域：从小型单行脚本到复杂的服务器端业务逻辑。 随着程序变得越来越复杂，具有某种形式的类型检查变得越来越重要。 TypeScript 是 JavaScript 语言的扩展，允许用户选择提供类型信息。 

Deno 无需其他工具即可支持 TypeScript。 运行时在设计时考虑了 TypeScript。 `deno types` 命令为 Deno 提供的所有内容提供类型声明。 Deno 的标准模块全部使用TypeScript编写。 

## 3.  贯穿始终的 Promise(Promises All The Way Down)

 Node 是在 JavaScript 具有 `Promises`和 `async / await` 概念之前设计的。  与Node对应的 `Promises `是`EventEmitter `，它基于重要的 API，即 sockets 和 HTTP。 除了 `async / await`的工程学优势外，`EventEmitter` 模式还存在背压问题。 以TCP sockets为例。sockets 在收到传入数据包时将发出“数据”事件。 这些“数据”回调将以不受限制的方式发出，从而使事件充满整个过程。 由于Node继续接收新的数据事件，因此基础TCP sockets 没有适当的背压，因此远程发送方不知道服务器已超负荷并继续发送数据。 为了缓解此问题，添加了`pause()`方法。 这可以解决问题，但是需要额外的代码； 而且由于泛洪问题仅在进程非常繁忙时才会出现，因此许多Node程序都可能被数据淹没了。 结果是系统的尾部延迟时间很长。 

在 Deno 中，sockets 仍然是异步的，但是接收新数据需要用户明确`rean()`。 正确构造接收 sockets  不需要额外的暂停语义。 这不是TCP sockets 独有的。 系统的最低绑定层从根本上与 `promise`相关联-我们称这些绑定为“ ops”。 Deno 中以某种形式出现的所有回调均来自 promise。 

Rust 有其自己的类似于 `promise `的抽象功能，称为`Futures`。 通过“ op” 抽象，Deno 使将 Rust Futures 的 API 绑定到 JavaScript promise 中变得容易。 

## 4.  Rust APIs

我们提供的主要组件是 Deno 命令行界面（CLI）。 CLI是今天的1.0版本。 但是 Deno 并不是一个整体的程序，而是设计为 Rust 板条箱的集合，以允许在不同的层进行集成。 

deno_core 是 Deno 的一个非常简单的版本。 它不依赖于 TypeScript 或  Tokio。 它只是提供了我们的运营和资源基础架构。 也就是说，它提供了一种将 Rust  futures 绑定到 JavaScript promise 的方式。 CLI当然完全建立在 deno_core 之上。 

rusty_v8  crates可为 V8 的 C ++ API 提供高质量的 Rust 绑定。 该 API 尝试尽可能与原始 C ++ API 匹配。 这是零成本的绑定 Rust 中公开的对象与您在 C ++ 中操作的对象完全相同。 （例如，先前对 Rust V8 绑定的尝试强制使用了持久控制。）板条箱提供了在 Github Actions CI 中内置的二进制文件，但它还允许用户从头开始编译V8 并调整其许多构建配置。 所有 V8 源代码均在包装箱中分发。 最后，rusty_v8 尝试成为一个安全的接口。 它还不是100％安全的，但我们正在接近。 能够以安全的方式与像 V8 这样复杂的 VM 进行交互非常令人惊讶，并且使我们能够发现 Deno 本身中的许多困难错误。 

## 5.  稳定 （Stability）

我们保证在 Deno 中保持稳定的 API。 Deno 有很多接口和组件，因此透明地了解我们所说的“稳定”是很重要的。 我们发明的与操作系统交互的 JavaScript API 都可以在“ Deno”命名空间（例如Deno.open()）中找到。 这些已经过仔细检查，我们不会对它们进行向后不兼容的更改。 

尚未准备稳定的所有功能都隐藏在`--unstable`命令行标志后面。 您可以在此处查看不稳定接口的文档。 在后续版本中，其中一些 API 也将被稳定。 

在全局名称空间中，您会找到各种其他对象（例如 setTimeout() 和 fetch())）。 我们已经尽力使这些界面与浏览器中的界面相同。 但是如果发现意外的不兼容性，我们将进行修改。 浏览器标准定义了这些接口，而不是我们。 我们发布的所有更正均是错误修复，而不是界面更改。 如果与浏览器标准 API 不兼容，则可以在主要版本之前更正该不兼容。 

Deno 也有许多 Rust API，即 deno_core 和 rusty_v8 crates。 这些 API 都不是1.0。 我们将继续对它们进行迭代。 

## 6. 限制  (Limitations)

重要的是要了解Deno不是Node的分支-它是一个全新的实现。 Deno 的开发仅两年时间，而 Node 的开发已超过十年。 考虑到对 Deno 的兴趣，我们希望它会继续发展和成熟。 

对于某些应用程序而言，Deno可能是当今的不错选择，对于其他应用程序而言则尚未。 这将取决于要求。 我们希望对这些限制保持透明，以帮助人们在考虑使用Deno时做出明智的决定。 

### 6.1. 兼容性 (Compatibility)

不幸的是，许多用户会发现与现有 JavaScript 工具的兼容性令人沮丧。 通常，Deno 与 Node（NPM）软件包不兼容。 在https://deno.land/std/node/上建立了一个新生的兼容性层，但还远未完成。 

尽管Deno采用强硬方法简化了模块系统，但最终 Deno 和 Node是具有相似目标且非常类似的系统 。 随着时间的推移，我们希望 Deno 能够开箱即用地运行越来越多的Node程序。 

### 6.2  HTTP服务器性能 (HTTP Server Performance)

我们不断跟踪Deno的HTTP服务器的性能。  `hello-world` 的Deno HTTP服务器每秒处理约25,000个请求，最大延迟为1.3毫秒。 一个可比的Node程序每秒处理34,000个请求，最大延迟介于2到300毫秒之间。 

Deno的HTTP服务器是在本机TCP sockets 的 TypeScript 中实现的。 Node的HTTP服务器使用C语言编写，并作为对JavaScript的高级绑定公开。 我们一直拒绝将本地HTTP服务器绑定添加到Deno的冲动，因为我们要优化TCP sockets  层，更常见的是优化op接口。 

### 6.3  TSC瓶颈 (TSC Bottleneck)

在内部，Deno 使用 Microsoft 的 TypeScript 编译器检查类型并生成 JavaScript。 与 V8 解析 JavaScript 所花费的时间相比，它非常慢。 在项目的早期，我们曾希望“ V8快照”在此能够带来重大改进。 快照肯定有帮助，但是它仍然缓慢。 我们当然认为可以在现有 TypeScript 编译器的基础上进行一些改进，但是对我们来说很显然，最终需要在 Rust 中实现类型检查。 这将是一项艰巨的任务，不会很快发生。 但它可以在开发人员经历的关键路径上提供数量级的性能改进。 TSC必须移植到Rust。 如果您有兴趣合作解决此问题，请与我们联系。 

### 6.4  扩展/插件(Plugins / Extensions)

我们有一个新生的插件系统，用于通过自定义操作扩展 Deno 运行时。 但是，此接口仍在开发中，并已标记为不稳定。 因此，访问 Deno 提供的系统以外的本机系统很困难。 

### 6.5  致谢 (Acknowledgements)

 非常感谢帮助实现此版本的许多贡献者。 特别是：@kitsonk，他在系统的许多部分都起了很大的作用，包括（但不限于）TypeScript编译器主机，deno_typescript，deno软件包，deno安装，deno类型，流实现。 @kevinkassimo在项目的整个历史中贡献了无数的错误修复。 他的贡献包括计时器系统，TTY集成，wasm支持。 Deno.makeTempFile，Deno.kill，Deno.hostname，Deno.realPath，std / node的require，window.queueMircotask和REPL历史记录。 他还创建了徽标。 @ kt3k实现了连续基准系统（几乎在每个主要重构中都发挥了作用），信号处理程序，权限API和许多重要的错误修复。 @nayeemrmn在Deno的许多部分中提供了错误修复程序，最著名的是，他极大地改善了堆栈跟踪和错误报告，并为稳定1.0版的API提供了有力的帮助。 @justjavac贡献了许多小而重要的修复程序，以使deno API与Web标准保持一致，最著名的是他编写了VS Code deno插件。 @zekth为std贡献了很多模块，其中包括std / encoding / csv，std / encoding / toml，std / http / cookies以及许多其他错误修复。 @axetroy帮助解决了所有与漂亮有关的问题，修复了许多错误，并维护了VS Code插件。 @ afinch7实现了插件系统。 @keroxp实现了websocket服务器并提供了许多错误修复。 @cknight提供了很多文档和std / node polyfills。 @lucacasonato建立了几乎整个deno.land网站。 @hashrock已经完成了许多惊人的艺术作品，例如doc.deno.land的加载页面以及该页面顶部的可爱图片！ 