<p align="center">
  <a href="https://github.com/Fliggy-Mobile">
    <img width="200" src="https://gw.alicdn.com/tfs/TB1a288sxD1gK0jSZFKXXcJrVXa-360-360.png">
  </a>
</p>

<h1 align="center">frefresh</h1>


<div align="center">

<p>Help you to build pull-down refresh and pull-up loading in the simplest way.</p>

<p>Although unprecedented simplicity, but the effect is amazing. It also supports configuration refresh and loading elements. The complete controller allows you to help you control the entire dynamic process.</p>

<p><strong>Author：<a href="https://github.com/chenBingX">Newton</a>(<a href="coorchice.cb@alibaba-inc.com">coorchice.cb@alibaba-inc.com</a>)</strong></p>

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

**English | [简体中文](https://github.com/Fliggy-Mobile/frefresh/blob/master/README_CN.md)**

> Like it? Please cast your **Star**  🥰 ！

# ✨ Features


# 🛠 Guide


## ⚙️ Parameter & Interface

### 🔩 FRefresh param

|Param|Type|Necessary|Default|desc|
|---|---|:---:|---|---|
|child|Widget|true|null|Main view content|
|header|Widget|false|null|Elements that will be displayed when you pull down and refresh|
|headerBuilder|HeaderBuilder|false|null|Construct a pull-down refresh element. [Header] configuration will be overwritten.|
|headerHeight|double|false|50.0|[header] The height of the area|
|headerTrigger|double|false|0.0|The distance to trigger pull-down refresh should be greater than [headerHeight]|
|onRefresh|VoidCallback|false|null|Callback when refresh is triggered|
|footer|Widget|false|null|Elements that will be displayed when pulling up|
|footerBuilder|FooterBuilder|false|null|Build pull-up loading elements. Will override [footer] configuration.|
|footerHeight|double|false|0.0|[footer] The height of the area|
|footerTrigger|double|false|0.0|The distance to trigger the pull-up loading should be greater than [headerHeight]|
|shouldLoad|bool|false|true|Whether the pull-up load should be triggered. In some scenarios, when the loading is completed, the pull-up loading element will need to be turned into a footer|
|onLoad|VoidCallback|false|null|Callback when loading is triggered|
|controller|FRefreshController|false|null|[Refresh] controller. See [Refresh Controller] for details|


### ⌨️ FRefreshController 

#### 🔧 Param

|Param|Type|Desc|
|---|---|---|
|refreshState|RefreshState|Get the pull-down refresh status. See [RefreshState] for details|
|loadState|LoadState|Get the pull-up loading status. See [LoadState] for details|
|position|double|Current scroll position|
|scrollMetrics|ScrollMetrics|Current scroll information. See [ScrollMetrics] for details.|
|backOriginOnLoadFinish|bool|When loading is completed, whether to return to the original position. This parameter is useful when the GridView only adds one element.|

#### 📡 Interface

---
- `void refresh({Duration duration = const Duration(milliseconds: 300)})`

Actively trigger pull-down refresh. 

[duration] The duration of the pull-down effect. Default 300ms

---
- `finishRefresh()`

End pull-down refresh.

---
- `finishLoad()`

End pull-up loading.

---
- `void setOnStateChangedCallback(OnStateChangedCallback callback)`

Set up status listener. e.g .:

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

Set up scroll listener. Receive [ScrollMetrics].

---

- `void scrollTo(double position, {Duration duration = const Duration(milliseconds: 300)})`

Scroll to the specified position.

--- 

- `void scrollBy(double offset, {Duration duration = const Duration(milliseconds: 300)})`

Scroll the specified distance.

--- 

- `void jumpTo(double position)`

Jump to the specified position.

### 🃏 RefreshState

|Value|Desc|
|---|---|
|PREPARING_REFRESH|Reach [headerTrigger], ready to enter refresh state|
|REFRESHING|Refreshing|
|FINISHING|Refresh ending|
|IDLE|Idle state|


### 🃏 LoadState

|Value|Desc|
|---|---|
|PREPARING_LOAD|Reach [footerTrigger], ready to enter the loading state|
|LOADING|Loading|
|FINISHING|Load ending|
|IDLE|Idle state|


## 📺 Demo

### 🔩 Refresh Example

![](https://gw.alicdn.com/tfs/TB17ld1Gxz1gK0jSZSgXXavwpXa-550-391.gif)

This is our most common pull-down refresh example in daily development 🌰. Believe me, if you want to build such an effect, it will be very difficult!

But if you use **FRefresh**, the situation is completely different.

Next, we only need a few lines of code to complete the construction of this effect.

#### 1. Create FRefreshController


```dart

/// Create a controller
FRefreshController controller = FRefreshController()

```

#### 2. Create FRefresh

```dart

FRefresh(

  /// Set up the controller
  controller: controller,

  /// create Header
  header: buildRefreshView(),

  /// Need to pass the size of the header area
  headerHeight: 75.0,

  /// Content area widget
  child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      ...
  ),

  /// This function will be called back after entering Refreshing
  onRefresh: () {

     /// End refresh via controller
     controller.finishRefresh();
  },
);
```

Done 🔨！

This is all you need to do to create a pull-down refresh.

**FRefresh** takes care of everything, developers only need to focus on the construction of the **Header area** and **content area**.
 
 > ⚠️ Attention，To use **ListView**, **GridView** in **FRefresh**, you need to configure their `physics: NeverScrollableScrollPhysics ()`, `shrinkWrap: true`, otherwise it will affect the scrolling and layout effects.


### 🔩 HeaderBuilder Demo

![](https://gw.alicdn.com/tfs/TB1CTN0Gvb2gK0jSZK9XXaEgFXa-550-391.gif)

```dart

FRefresh(
  controller: controller,

  /// Build the header area with headerBuilder
  headerBuilder: (setter, constraints) {
    return FSuper(

       /// Get the available space in the current header area
       width: constraints.maxWidth,
       height: constraints.maxHeight,
       ...
       onClick:{
          setter((){
             /// Refresh the header area
          })
       },
    );
  },
  headerHeight: 100.0,

  /// Build content area
  child: GridView.builder(),

  /// This function will be called back after entering the refreshing state
  onRefresh: () {

    /// finish refresh
    controller.finishRefresh();
  }
)
```

**FRefresh** provides a very flexible **Header** area construction method, which is to complete the construction through the **HeaderBuilder** function.

In the **HeaderBuilder** function, the developer can get the refresh function **StateSetter** for the partial refresh **Header** area and the real-time size of the **Header area** through the parameters.

This way, the **Header area** is given more open creativity.

### 🔭 Load Example

![](https://gw.alicdn.com/tfs/TB186p6Grj1gK0jSZFOXXc7GpXa-550-391.gif)

Corresponding to the pull-down refresh, the construction of the pull-up loading effect is also very simple.

#### 1. Create FRefreshController


```dart

/// Create a controller
FRefreshController controller = FRefreshController()

```

#### 2. Create FRefresh

```dart
FRefresh(

  /// Setup the controller
  controller: controller,

  /// create Footer area
  footer: LinearProgressIndicator(),

  /// need to setup Footer area height
  footerHeight: 20.0,

  /// create content area
  child: builderContent(),

  /// This function will be called back after entering the Loading state
  onLoad: () {
    
    /// End loading state
    controller.finishLoad();
  },
)
```

Building pull-ups is equally simple enough. Developers only need to pay attention to the construction of **Footer area** and **content area**, and the state changes and visual effects control during the pull-up loading process can be safely handed over to **FRefresh**.



### 🔭 FooterBuilder Demo

![](https://gw.alicdn.com/tfs/TB1fHJ3Grr1gK0jSZFDXXb9yVXa-550-391.gif)

```dart

FRefresh(
  controller: controller,

  /// Build Footer Area Widget by FooterBuilder
  footerBuilder: (setter) {

    /// Get refresh status, partially update the content of Footer area
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

 **FRefresh** also provides a builder function **FooterBuilder** for building the **Footer area**. Through this function, you can get the refresh function **StateSetter** which refreshes only the **Footer area**.

In this way, the developer can easily change the view of the **footer area** according to the status or some other conditions. Very intimate 🥰.

### ⚙️ FRefreshController

![](https://gw.alicdn.com/tfs/TB11ex1Gvb2gK0jSZK9XXaEgFXa-550-391.gif)

**FRefresh** provides developers with intimate controllers **FRefreshController**, which supports many convenient capabilities.
 
#### 1. Add controller to FRefresh
 
```dart

/// Create Controller
FRefreshController controller = FRefreshController()

/// Configure controller for FRefresh
FRefresh(
  controller: controller,
)
```

When the developer creates a controller and then sets it into a **FRefresh**, the controller can start to monitor the status of this **FRefresh** and control it.
 
#### 2. Stop refreshing or loading

When the refresh state or loading state is triggered, data processing tasks such as network requests are usually performed. After these tasks are completed, we need to stop the refresh state or loading state. How to do it?

- `controller.finishRefresh()` Can stop refreshing
 
- `controller.finishLoad()` Can stop loading
 
#### 3. State Change Listen 

```dart
controller5.setOnStateChangedCallback((state) {
  /// Refresh status
  if (state is RefreshState) {
  }
  /// Loading state
  if (state is LoadState) {
  }
});
```

Through the above simple code, you can monitor the status change of **FRefresh**, whether it is pull-down refresh or pull-up loading.


#### 4. Scroll Listen

```dart
controller.setOnScrollListener((metrics) {
  /// Get scroll information
});
```

**FRefreshController** It is really convenient to add sliding monitor. The parameters received is [[ScrollMetrics]](https://api.flutter.dev/flutter/widgets/ScrollMetrics-class.html)，it can get very comprehensive information such as **current scroll distance**, **maximum scroll distance**, **whether it exceeds the scroll range**, etc..


#### 5. Actively trigger refresh

Through **FRefreshController**, developers can also actively trigger a refresh, and can specify the length of time to slide to the refresh position. 

```dart

controller.refresh(duration: Duration(milliseconds: 2000));

```

This feature is very useful in many scenarios.

#### 6. Scroll control

**FRefreshController** provides a variety of intimate and delicate sliding controls for developers to choose.

```dart

/// Scroll to the specified position
controller.scrollTo(100.0, duration:Duration(milliseconds: 2000));

/// Scroll the specified distance
controller.scrollBy(20.0, duration:Duration(milliseconds: 800));

/// Jump to the specified position
controller.jumpTo(100.0);
```

This makes many beautiful interactions easier to build.

# 😃 How to use？

Add dependencies in the project `pubspec.yaml` file:

## 🌐 pub dependency

```
dependencies:
  frefresh: ^<version number>
```

> ⚠️ Attention，please go to [**pub**] (https://pub.dev/packages/frefresh) to get the latest version number of **FRefresh**

## 🖥 Git dependency

```
dependencies:
  frefresh:
    git:
      url: 'git@github.com:Fliggy-Mobile/frefresh.git'
      ref: '<Branch number or tag number>'
```

> ⚠️ Attention，please refer to [**FRefresh**] (https://github.com/Fliggy-Mobile/frefresh) official project for branch number or tag.


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


### Like it? Please cast your [**Star**](https://github.com/Fliggy-Mobile/frefresh) 🥰 ！


---

# How to run Demo project?

1. **clone** project to local

2. Enter the project `example` directory and run the following command

```
flutter create .
```

3. Run the demo in `example`
