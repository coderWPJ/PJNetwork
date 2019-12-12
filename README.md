# PJNetwork

## What
PJNetwork 是一个基于 AFNetworking 实现的网络类库，目前版本更新到1.0版本，往后有时间会不定期更新，一步步完善准备中的功能。目前版本除进一步封装了 AFNetworking 基本的GET、POST请求外，增加了在视图控制器销毁时取消页面请求的功能（需要借助 PJNetworkShell 类加壳实现）。

## Why


## Features
* 在视图控制器销毁时取消未完成的请求（1.0.4版本后已集成）
* 请求结果依赖 （需要在多个接口请求结果结束后刷新页面）
* 链式请求 （下次请求在上一个请求结束后开始）

## Installation
pod 'PJNetwork'

