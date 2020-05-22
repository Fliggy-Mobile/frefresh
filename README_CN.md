<p align="center">
  <a href="https://github.com/Fliggy-Mobile">
    <img width="200" src="https://gw.alicdn.com/tfs/TB1a288sxD1gK0jSZFKXXcJrVXa-360-360.png">
  </a>
</p>

<h1 align="center">frefresh</h1>


<div align="center">

<p>帮助你用最简单的方式构建下拉刷新，上拉加载。</p>

<p>虽前所未有的简易，但效果却令人惊叹不已。同时支持配置刷新、加载元素。完备的控制器让你帮助你掌控整个动态过程。</p>

<p><strong>主理人：<a href="https://github.com/chenBingX">纽特</a>(<a href="coorchice.cb@alibaba-inc.com">coorchice.cb@alibaba-inc.com</a>)</strong></p>

<p>

<a href="https://pub.dev/packages/frefresh#-readme-tab-">
    <img height="20" src="https://img.shields.io/badge/Version-1.1.0-important.svg">
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

</div>

||||
|:--:|:--:|:--:|
|![](https://gw.alicdn.com/tfs/TB17ld1Gxz1gK0jSZSgXXavwpXa-550-391.gif)|![](https://gw.alicdn.com/tfs/TB1CTN0Gvb2gK0jSZK9XXaEgFXa-550-391.gif)|![](https://gw.alicdn.com/tfs/TB186p6Grj1gK0jSZFOXXc7GpXa-550-391.gif)|
|![](https://gw.alicdn.com/tfs/TB1fHJ3Grr1gK0jSZFDXXb9yVXa-550-391.gif)|![](https://gw.alicdn.com/tfs/TB11ex1Gvb2gK0jSZK9XXaEgFXa-550-391.gif)|![](https://gw.alicdn.com/tfs/TB19oLDGKT2gK0jSZFvXXXnFXXa-360-212.gif)|

**[English](https://github.com/Fliggy-Mobile/frefresh) | 简体中文**

> 感觉还不错？请投出您的 **Star** 吧 🥰 ！

# ✨ 特性



# 🛠 使用指南


## ⚙️ 参数 & 接口

### 🔩 FRefresh 参数

|参数|类型|必要|默认值|说明|
|---|---|:---:|---|---|
|child|Widget|是|null|主要视图内容|
|header|Widget|否|null|下拉刷新时会展示的元素|
|headerBuilder|HeaderBuilder|否|null|构建下拉刷新元素。会覆盖 [header] 配置。|
|headerHeight|double|否|50.0|[header] 区域的高度|
|headerTrigger|double|否|0.0|触发下拉刷新的距离，应大于 [headerHeight]|
|onRefresh|VoidCallback|否|null|触发刷新时会回调|
|footer|Widget|否|null|上拉加载时会展示的元素|
|footerBuilder|FooterBuilder|否|null|构建上拉加载元素。会覆盖 [footer] 配置。|
|footerHeight|double|否|0.0|[footer] 区域的高度|
|footerTrigger|double|否|0.0|触发上拉加载的距离，应大于 [headerHeight]|
|shouldLoad|bool|否|true|是否应该触发上拉加载。在一些场景中，当加载完成后，上拉加载元素将需要变为页脚|
|onLoad|VoidCallback|否|null|触发加载时会回调|
|controller|FRefreshController|否|null|[FRefresh] 的控制器。详见 [FRefreshController]|


### ⌨️ FRefreshController 

#### 🔧 属性

|属性|类型|说明|
|---|---|---|
|refreshState|RefreshState|获取下拉刷新状态。详见 [RefreshState]|
|loadState|LoadState|获取上拉加载状态。详见 [LoadState]|
|position|double|当前滑动位置|
|scrollMetrics|ScrollMetrics|当前滑动信息。详见 [ScrollMetrics]。|
|backOriginOnLoadFinish|bool|当加载完成后，是否回到原位置。例如当 GridView 只新增一个元素时，该参数会很有用。|

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

---

- `void scrollTo(double position, {Duration duration = const Duration(milliseconds: 300)})`

滚动到指定位置。

--- 

- `void scrollBy(double offset, {Duration duration = const Duration(milliseconds: 300)})`

滚动指定距离。

--- 

- `void jumpTo(double position)`

跳到指定位置。

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

### 🔩 Refresh 示例

![](https://gw.alicdn.com/tfs/TB17ld1Gxz1gK0jSZSgXXavwpXa-550-391.gif)

这是日常开发中我们最常见的下拉刷新例子 🌰。相信我，如果自己想要构建一个这样的效果，会很费劲的！

但如果使用  **FRefresh** ，情况就完全不同了。

接下来，我们只需要通过简单的几行代码，就能完成这一效果的构建。

#### 1. 创建 FRefreshController


```dart

/// 创建控制器
FRefreshController controller = FRefreshController()

```

#### 2. 创建 FRefresh

```dart

FRefresh(

  /// 设置控制器
  controller: controller,

  /// 构建刷新 Header
  header: buildRefreshView(),

  /// 需要传入 Header 区域大小
  headerHeight: 75.0,

  /// 内容区域 Widget
  child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      ...
  ),

  /// 进入 Refreshing 后会回调该函数
  onRefresh: () {

     /// 通过 controller 结束刷新
     controller.finishRefresh();
  },
);
```

完工 🔨！

这就是创建下拉刷新所要做的所有工作。

 **FRefresh**  处理好了一切，开发者只需要全身心关注 **Header 区域**  和  **内容区域** 的构建工作就够了。
 
 > ⚠️ 注意，在  **FRefresh**  中使用  **ListView** 、 **GridView**  等，需要配置它们的 `physics: NeverScrollableScrollPhysics()`、`shrinkWrap: true`，否则会影响滚动和布局效果。


### 🔩 HeaderBuilder 演示

![](https://gw.alicdn.com/tfs/TB1CTN0Gvb2gK0jSZK9XXaEgFXa-550-391.gif)

```dart

FRefresh(
  controller: controller,

  /// 通过 headerBuilder 构建 Header 区域
  headerBuilder: (setter, constraints) {
    return FSuper(

       /// 获取当前 Header 区域可用空间大小
       width: constraints.maxWidth,
       height: constraints.maxHeight,
       ...
       onClick:{
          setter((){
             /// 刷新 Header 区域
          })
       },
    );
  },
  headerHeight: 100.0,

  /// 构建内容区域
  child: GridView.builder(),

  /// 进入 Refreshing 状态后会回调该函数
  onRefresh: () {

    /// 结束刷新
    controller.finishRefresh();
  }
)
```

 **FRefresh**  提供了一种十分灵活的  **Header**  区域构建方式，即通过  **HeaderBuilder**  函数完成构建。

在  **HeaderBuilder**  函数中，开发者能够通过参数获取到用于局部刷新  **Header**  区域的刷新函数  **StateSetter** ，以及  **Header 区域** 的实时大小。

这种方式，赋予了  **Header 区域** 更加开放的创造性。

### 🔭 Load 示例

![](https://gw.alicdn.com/tfs/TB186p6Grj1gK0jSZFOXXc7GpXa-550-391.gif)

与下拉刷新对应，上拉加载效果的构建也同样非比寻常的简单。

#### 1. 创建 FRefreshController


```dart

/// 创建控制器
FRefreshController controller = FRefreshController()

```

#### 2. 创建 FRefresh

```dart
FRefresh(

  /// 设置控制器
  controller: controller,

  /// 构建 Footer 区域
  footer: LinearProgressIndicator(),

  /// 需要配置 Footer 区域高度
  footerHeight: 20.0,

  /// 构建内容区域
  child: builderContent(),

  /// 进入 Loading 状态后会回调该函数
  onLoad: () {
    
    /// 结束加载状态
    controller.finishLoad();
  },
)
```

构建上拉加载也一样足够简单。开发者只需要关注  **Footer 区域** 和 **内容区域** 的构建，上拉加载过程中的状态变更、视效控制等就放心交给  **FRefresh**  好了。



### 🔭 FooterBuilder 演示

![](https://gw.alicdn.com/tfs/TB1fHJ3Grr1gK0jSZFDXXb9yVXa-550-391.gif)

```dart

FRefresh(
  controller: controller,

  /// 通过 FooterBuilder 构建 Footer 区域 Widget
  footerBuilder: (setter) {

    /// 获取刷新状态，局部更新 Footer 区域内容
    controller.setOnStateChangedCallback((state) {
      setter(() {
        ...
      });
    });
    return buildFooter();
  },
  footerHeight: 38.0,
  child: buildContent(),
  onLoad: () {
    controller.finishLoad();
  },
)
```

 **FRefresh**  也为  **Footer 区域** 的构建提供了一个构建函数  **FooterBuilder** 。通过该函数可以获取到只局部刷新  **Footer 区域** 的刷新函数  **StateSetter** 。

这样开发者就能很方便的根据状态或是其它一些条件改变  **Footer 区域** 的视图了。很贴心的吧 🥰。

### ⚙️ FRefreshController

![](https://gw.alicdn.com/tfs/TB11ex1Gvb2gK0jSZK9XXaEgFXa-550-391.gif)

 **FRefresh**  向开发者提供了贴心的控制器  **FRefreshController** ，支持诸多便捷的能力。
 
#### 1. 给 FRefresh 添加控制器
 
```dart

/// 创建 控制器
FRefreshController controller = FRefreshController()

/// 给 FRefresh 配置控制器
FRefresh(
  controller: controller,
)
```

当开发者创建一个控制器，然后将它设置到一个  **FRefresh**  中后，控制器就能开始监听这个  **FRefresh**  的状态，以及对它进行控制了。
 
#### 2. 停止刷新或加载

当触发刷新状态或加载状态后，通常会进行网络请求等数据处理任务，在这些任务结束后，我们需要停止刷新状态或加载状态。怎么办呢？

- `controller.finishRefresh()` 可以停止刷新
 
- `controller.finishLoad()` 可以停止加载
 
#### 3. 监听状态

```dart
controller5.setOnStateChangedCallback((state) {
  /// 刷新状态
  if (state is RefreshState) {
  }
  /// 加载状态
  if (state is LoadState) {
  }
});
```

通过上面这段简单的代码，就能实现对  **FRefresh**  状态变化的监听，不论是下拉刷新，还是上拉加载。


#### 4. 滑动监听

```dart
controller.setOnScrollListener((metrics) {
  /// 获取滑动信息
});
```

 **FRefreshController**  添加滑动监听真的是很方便了。接收的参数是 [[ScrollMetrics]](https://api.flutter.dev/flutter/widgets/ScrollMetrics-class.html)，通过它能获取到诸如 **当前滑动距离** 、 **最大滑动距离** 、 **是否超出滑动范围** 等非常全面的信息。


#### 5. 主动触发刷新

通过 **FRefreshController**，开发者还能主动触发一次刷新，而且可以指定滑动到触发刷新位置的时长。 

```dart

controller.refresh(duration: Duration(milliseconds: 2000));

```

这项功能在很多场景中都大有用处。

#### 6. 滑动控制

**FRefreshController** 提供了多种贴心、细腻的滑动控制，供开发者选用。

```dart

/// 滚动到指定位置
controller.scrollTo(100.0, duration:Duration(milliseconds: 2000));

/// 滚动指定距离
controller.scrollBy(20.0, duration:Duration(milliseconds: 800));

/// 跳到指定位置
controller.jumpTo(100.0);
```

这让很多精美的交互都更易被构建。

# 😃 如何使用？

在项目 `pubspec.yaml` 文件中添加依赖：

## 🌐 pub 依赖方式

```
dependencies:
  frefresh: ^<版本号>
```

> ⚠️ 注意，请到 [**pub**](https://pub.dev/packages/frefresh) 获取 **FRefresh** 最新版本号

## 🖥 git 依赖方式

```
dependencies:
  frefresh:
    git:
      url: 'git@github.com:Fliggy-Mobile/frefresh.git'
      ref: '<分支号 或 tag>'
```


> ⚠️ 注意，分支号 或 tag 请以 [**FRefresh**](https://github.com/Fliggy-Mobile/frefresh) 官方项目为准。


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


---

# 如何运行 Demo 工程？

1. **clone** 工程到本地

2. 进入工程 `example` 目录，运行以下命令

```
flutter create .
```

3. 运行 `example` 中的 Demo
