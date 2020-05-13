<p align="center">
  <a href="https://github.com/Fliggy-Mobile">
    <img width="200" src="https://gw.alicdn.com/tfs/TB1a288sxD1gK0jSZFKXXcJrVXa-360-360.png">
  </a>
</p>

<h1 align="center">frefresh</h1>


<div align="center">

<p>***。</p>

<p>***</p>

<p><strong>主理人：<a href="https://github.com/chenBingX">纽特</a>(<a href="coorchice.cb@alibaba-inc.com">coorchice.cb@alibaba-inc.com</a>)</strong></p>

<p>

<a href="https://pub.dev/packages/frefresh#-readme-tab-">
    <img height="20" src="https://img.shields.io/badge/Version-1.0.0-important.svg">
</a>


<a href="https://github.com/Fliggy-Mobile/frefresh">
    <img height="20" src="https://img.shields.io/badge/Build-passing-brightgreen.svg">
</a>


<a href="https://github.com/Fliggy-Mobile">
    <img height="20" src="https://img.shields.io/badge/Team-FAT-ffc900.svg">
</a>

<a href="https://www.dartcn.com/">
    <img height="20" src="https://img.shields.io/badge/Language-Dart-blue.svg">
</a>

<a href="https://pub.dev/documentation/frefresh/latest/frefresh/frefresh-library.html">
    <img height="20" src="https://img.shields.io/badge/API-done-yellowgreen.svg">
</a>

<a href="http://www.apache.org/licenses/LICENSE-2.0.txt">
   <img height="20" src="https://img.shields.io/badge/License-Apache--2.0-blueviolet.svg">
</a>

<p>
<p>

<img height="700" src="https://gw.alicdn.com/tfs/TB10qvQFrj1gK0jSZFOXXc7GpXa-964-1232.png">

</div>

**[English](https://github.com/Fliggy-Mobile/frefresh) | 简体中文**

> 感觉还不错？请投出您的 **Star** 吧 🥰 ！

# ✨ 特性



# 🛠 使用指南


## ⚙️ 参数 & 接口

### 🔩 FRefresh 参数

|参数|类型|必要|默认值|说明|
|---|---|:---:|---|---|
|header|Widget|否|null|下拉刷新时会展示的元素|
|headerHeight|double|否|50.0|[header] 区域的高度|
|headerTrigger|double|否|0.0|触发下拉刷新的距离，应大于 [headerHeight]|
|onRefresh|VoidCallback|否|null|触发刷新时会回调|
|footer|Widget|否|null|上拉加载时会展示的元素|
|footerHeight|double|否|0.0|[footer] 区域的高度|
|footerTrigger|double|否|0.0|触发上拉加载的距离，应大于 [headerHeight]|
|onLoad|VoidCallback|否|null|触发加载时会回调|
|controller|FRefreshController|否|null|[FRefresh] 的控制器。详见 [FRefreshController]|


### ⌨️ FRefreshController 

#### 🔧 属性

|属性|类型|说明|
|---|---|---|
|refreshState|RefreshState|获取下拉刷新状态。详见 [RefreshState]|
|loadState|LoadState|获取上拉加载状态。详见 [LoadState]|

#### 📡 接口

---
- `void refresh({Duration duration = const Duration(milliseconds: 300)})`

主动触发下拉刷新。  

[duration] 下拉动效时长。默认 300ms

---
- `finishRefresh()`

结束下拉刷新。

---
- `finishLoad()`

结束上拉加载。

---
- `void setOnStateChangedCallback(OnStateChangedCallback callback)`

设置状态监听。e.g.:

```
controller.setOnStateChangedCallback((state){
  if (state is RefreshState) {

  }
  if (state is LoadState) {

   }
})
```
---
- `void setOnScrollListener(OnScrollListener onScrollListener)`

设置滚动监听。接收 [ScrollMetrics]。

### 🃏 RefreshState

|值|说明|
|---|---|
|PREPARING_REFRESH|达到 [headerTrigger]，准备进入刷新状态|
|REFRESHING|刷新中|
|FINISHING|刷新结束中|
|IDLE|空闲状态|


### 🃏 LoadState

|值|说明|
|---|---|
|PREPARING_LOAD|达到 [footerTrigger]，准备进入加载状态|
|LOADING|加载中|
|FINISHING|加载结束中|
|IDLE|空闲状态|


## 📺 使用示例

### 🔩 基本使用



# 😃 如何使用？

在项目 `pubspec.yaml` 文件中添加依赖：

## 🌐 pub 依赖方式

```
dependencies:
  frefresh: ^<版本号>
```

> ⚠️ 注意，请到 [**pub**](https://pub.dev/packages/frefresh) 获取 **frefresh** 最新版本号

## 🖥 git 依赖方式

```
dependencies:
  frefresh:
    git:
      url: 'git@github.com:Fliggy-Mobile/frefresh.git'
      ref: '<分支号 或 tag>'
```


> ⚠️ 注意，分支号 或 tag 请以 [**frefresh**](https://github.com/Fliggy-Mobile/frefresh) 官方项目为准。


# 💡 License

```
Copyright 2020-present Fliggy Android Team <alitrip_android@list.alibaba-inc.com>.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at following link.

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

```


### 感觉还不错？请投出您的 [**Star**](https://github.com/Fliggy-Mobile/frefresh) 吧 🥰 ！


--

# 如何运行 Demo 工程？

1. **clone** 工程到本地

2. 进入工程 `example` 目录，运行以下命令

```
flutter create .
```

3. 运行 `example` 中的 Demo
