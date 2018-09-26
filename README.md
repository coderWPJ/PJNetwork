# PJNetwork

## What
PJNetwork 是一个基于 AFNetworking 实现的网络类库，目前版本更新到1.0版本，往后有时间会不定期更新，一步步完善准备中的功能。目前版本除进一步封装了 AFNetworking 基本的GET、POST请求外，增加了在视图控制器销毁时取消页面请求的功能（需要借助 PJNetworkSheel 类加壳实现）。

## Why
从事开发数年来，在处理网络请求时基本一直只用到 AFNetworking 来简单封装实现网络请求，but，在遇到如下情况时：请求结果依赖、链式请求等其他复杂情况时则需要用到如 GCD 等其他方式辅助实现，于是有了个想法将自己一直以来的解决方案封装一层后放入 Pod 中，免去代码冗余同时便于多个工程复用，当然还有一部分原因是自己有时候太懒了找点事做，顺便总结下东西，不为开源。

## Features
* 在视图控制器销毁时取消未完成的请求（1.0.4版本后已集成）
* 请求结果依赖 （需要在多个接口请求结果结束后刷新页面）
* 链式请求 （下次请求在上一个请求结束后开始）

## Installation
pod 'PJNetwork'

