import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

enum RefreshState {
  /// 达到 [headerTrigger]，准备进入刷新状态
  ///
  /// Reach [headerTrigger], ready to enter refresh state
  PREPARING_REFRESH,

  /// 刷新中
  ///
  /// Refreshing
  REFRESHING,

  /// 刷新结束中
  ///
  /// End of refresh
  FINISHING,

  /// 空闲状态
  ///
  /// Idle state
  IDLE,
}

enum LoadState {
  /// 达到 [footerTrigger]，准备进入加载状态
  ///
  /// Reach [footerTrigger], ready to enter the loading state
  PREPARING_LOAD,

  /// 加载中
  ///
  /// Loading
  LOADING,

  /// 加载结束中
  ///
  /// Loading finished
  FINISHING,

  /// 空闲状态
  ///
  /// Idle state
  IDLE,
}

/// 当 [FRefresh] 下拉刷新或上拉加载状态变化时会回调
///
/// Callback when [FRefresh] pull-down refresh or pull-up loading status changes
typedef OnStateChangedCallback = void Function(dynamic state);

/// 当 [FRefresh] 发生滚动时会回调
///
/// Callback when [FRefresh] scroll occurs
typedef OnScrollListener = void Function(ScrollMetrics metrics);

/// 用于构建下拉刷新元素
///
/// Used to construct pull-down refresh elements
typedef HeaderBuilder = Widget Function(
    StateSetter setter, BoxConstraints constraints);

class FRefreshController {
  OnStateChangedCallback _onStateChangedCallback;
  OnScrollListener _onScrollListener;

  RefreshState _refreshState = RefreshState.IDLE;

  /// 获取下拉刷新状态。详见 [RefreshState]
  ///
  /// Get the pull-down refresh status. See [RefreshState] for details
  RefreshState get refreshState => _refreshState;

  set refreshState(RefreshState value) {
    if (_refreshState == value) return;
    _refreshState = value;
    if (_onStateChangedCallback != null) {
      _onStateChangedCallback(refreshState);
    }
  }

  LoadState _loadState = LoadState.IDLE;

  /// 获取上拉加载状态。详见 [LoadState]
  ///
  /// Get the pull-up loading status. See [LoadState] for details
  LoadState get loadState => _loadState;

  set loadState(LoadState value) {
    if (_loadState == value) return;
    _loadState = value;
    if (_onStateChangedCallback != null) {
      _onStateChangedCallback(loadState);
    }
  }

  _FRefreshState _fRefreshState;

  FRefreshController();

  /// 主动触发下拉刷新。
  /// [duration] 下拉动效时长。默认 300ms
  ///
  /// Actively trigger pull-down refresh.
  /// [duration] The duration of the pull-down effect. Default 300ms
  void refresh({Duration duration = const Duration(milliseconds: 300)}) {
    if (_fRefreshState != null) {
      _fRefreshState.refresh(duration);
    } else {
      print('No FRefresh is bound!');
    }
  }

  /// 结束下拉刷新
  ///
  /// End pull-down refresh
  void finishRefresh() {
    if (_fRefreshState != null) {
      _fRefreshState.finishRefresh();
    } else {
      print('No FRefresh is bound!');
    }
  }

  /// 结束上拉加载
  ///
  /// End pull-up loading
  void finishLoad() {
    if (_fRefreshState != null) {
      _fRefreshState.finishLoad();
    } else {
      print('No FRefresh is bound!');
    }
  }

  void _setFRefreshState(_FRefreshState _fRefreshState) {
    this._fRefreshState = _fRefreshState;
  }

  /// 设置状态监听。e.g.:
  ///
  /// Set up status monitoring. e.g .:
  ///
  /// ```
  /// controller.setOnStateChangedCallback((state){
  ///   if (state is RefreshState) {
  ///
  ///   }
  ///   if (state is LoadState) {
  ///
  ///    }
  /// })
  /// ```
  void setOnStateChangedCallback(OnStateChangedCallback callback) {
    this._onStateChangedCallback = callback;
  }

  /// 设置滚动监听。接收 [ScrollMetrics]。
  ///
  /// Set up rolling monitoring. Receive [ScrollMetrics].
  void setOnScrollListener(OnScrollListener onScrollListener) {
    this._onScrollListener = onScrollListener;
  }

  void dispose() {
    _fRefreshState = null;
    _onStateChangedCallback = null;
    _onScrollListener = null;
  }
}

// ignore: must_be_immutable
class FRefresh extends StatefulWidget {
  /// Debug 配置
  ///
  /// Debug configuration
  static bool debug = false;

  /// 下拉刷新时会展示的元素
  ///
  /// Elements that will be displayed when you pull down and refresh
  final Widget header;

  /// 构建下拉刷新元素。会覆盖 [header] 配置。
  ///
  /// Build drop-down refresh element. [Header] configuration will be overwritten.
  final HeaderBuilder headerBuilder;

  /// 主要视图内容
  ///
  /// Main view content
  final Widget child;

  /// 上拉加载时会展示的元素
  ///
  /// Elements that will be displayed when pulling up
  final Widget footer;

  /// 触发刷新时会回调
  ///
  /// Callback when refresh is triggered
  final VoidCallback onRefresh;

  /// 触发加载时会回调
  ///
  /// Callback when loading is triggered
  final VoidCallback onLoad;

  /// [header] 区域的高度
  ///
  /// [header] The height of the area
  final double headerHeight;

  /// 触发下拉刷新的距离，应大于 [headerHeight]
  ///
  /// The distance to trigger pull-down refresh should be greater than [headerHeight]
  double headerTrigger;

  /// [footer] 区域的高度
  ///
  /// [footer] The height of the area
  final double footerHeight;

  /// 触发上拉加载的距离，应大于 [headerHeight]
  ///
  /// The distance to trigger the pull-up loading should be greater than [headerHeight]
  double footerTrigger;

  /// [FRefresh] 的控制器。详见 [FRefreshController]。
  ///
  /// [Refresh] controller. See [Refresh Controller] for details.
  final FRefreshController controller;

  /// 是否应该触发上拉加载。在一些场景中，当加载完成后，上拉加载元素将需要变为页脚。
  ///
  /// Whether the pull-up load should be triggered.
  /// In some scenarios, when loading is complete, the pull-up loading element will need to be turned into a footer.
  bool shouldLoad;

//  final bool shrinkWrap;

  FRefresh({
    Key key,
    this.header,
    this.headerBuilder,
    @required this.child,
    this.footer,
    this.onRefresh,
    this.controller,
    this.headerHeight = 50.0,
    this.headerTrigger,
    this.footerHeight = 0.0,
    this.footerTrigger,
    this.onLoad,
    this.shouldLoad = true,
//    this.shrinkWrap = false,
  })  : assert(child != null),
        super(key: key) {
    if (headerTrigger == null || headerTrigger < headerHeight) {
      headerTrigger = headerHeight;
    }
    if (footerTrigger == null) {
      footerTrigger = footerHeight;
    }
  }

  @override
  _FRefreshState createState() => _FRefreshState();
}

class _FRefreshState extends State<FRefresh> {
  ValueNotifier<ScrollNotification> _scrollNotifier;
  ValueNotifier<RefreshState> _stateNotifier;
  ValueNotifier<LoadState> _loadStateNotifier;

  ScrollPhysics _physics;
  ScrollController _scrollController;

  Timer loadTimer;

  GlobalKey headerGlobalKey = GlobalKey();

  double tempHeaderHeight = 0.0;

  @override
  // ignore: must_call_super
  void initState() {
    _scrollNotifier = ValueNotifier(null);
    _stateNotifier = ValueNotifier(RefreshState.IDLE);
    _loadStateNotifier = ValueNotifier(LoadState.IDLE);
    _physics = FBouncingScrollPhysics(footerHeight: widget.footerHeight);
    _scrollController = ScrollController();
    if (widget.controller != null) {
      widget.controller._setFRefreshState(this);
    }

    _stateNotifier.addListener(() {
      widget.controller?.refreshState = _stateNotifier.value;
      if (widget.onRefresh != null &&
          _stateNotifier.value == RefreshState.REFRESHING) {
        widget.onRefresh();
      }
    });
    _loadStateNotifier.addListener(() {
      widget?.controller?.loadState = _loadStateNotifier.value;
      if (widget.onRefresh != null &&
          _loadStateNotifier.value == LoadState.LOADING) {
        widget?.onLoad();
      }
    });
    super.initState();
  }

  void refresh(Duration duration) {
    if (_stateNotifier != null &&
        _stateNotifier.value == RefreshState.IDLE &&
        _scrollController != null) {
      _scrollController.jumpTo(0.0);
      _scrollController.animateTo(-widget.headerTrigger,
          duration: duration, curve: Curves.linear);
    }
  }

  void _finishRefreshAnim() {
    _stateNotifier?.value = RefreshState.FINISHING;
    _scrollController
        .animateTo(widget.headerHeight,
            duration: Duration(milliseconds: FRefresh.debug ? 2000 : 300),
            curve: Curves.linear)
        .whenComplete(() {
      _stateNotifier?.value = RefreshState.IDLE;
      _scrollController.jumpTo(0);
    });
  }

  void finishRefresh() {
    if (_stateNotifier != null &&
        _stateNotifier.value == RefreshState.REFRESHING &&
        _scrollController != null) {
      _finishRefreshAnim();
    }
  }

  void _finishLoadAnim() {
    _loadStateNotifier?.value = LoadState.FINISHING;
    _scrollController
        .animateTo(
            _scrollController.position.maxScrollExtent - widget.footerHeight,
            duration: Duration(milliseconds: 300),
            curve: Curves.linear)
        .whenComplete(() {
      _loadStateNotifier?.value = LoadState.IDLE;
    });
  }

  void finishLoad() {
    _finishLoadAnim();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return SizedBox();
    List<Widget> slivers = <Widget>[];
    if (isHeaderShow()) {
      slivers.add(_Header(
        headerHeight: widget.headerHeight,
        triggerOffset: widget.headerTrigger,
        scrollNotifier: _scrollNotifier,
        stateNotifier: _stateNotifier,
        scrollController: _scrollController,
        child: widget.header,
        build: widget.headerBuilder,
      ));
    }
    if (widget.child != null) {
      slivers.add(SliverToBoxAdapter(child: widget.child));
    }
    if (isFooterShow()) {
      slivers.add(Footer(child: widget.footer));
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        double offset = _scrollController.position.pixels;
        if (notification is ScrollStartNotification) {
        } else if (notification is ScrollUpdateNotification) {
          if (checkRefreshState(RefreshState.IDLE) &&
              checkLoadState(LoadState.IDLE) &&
              -offset >= widget.headerTrigger &&
              (widget.header != null || widget.headerBuilder != null)) {
            /// enter preparing refresh
            _stateNotifier?.value = RefreshState.PREPARING_REFRESH;
          }
        }
        if (widget.controller != null &&
            widget.controller._onScrollListener != null) {
          widget.controller._onScrollListener(notification.metrics);
        }

        /// handle loading
        if (widget.shouldLoad &&
            widget.footer != null &&
            widget.footerHeight > 0 &&
            widget.onLoad != null &&
            notification.metrics.maxScrollExtent > 0.0) {
          if (loadTimer != null) loadTimer.cancel();
          var maxScrollExtent = _scrollController.position.maxScrollExtent;
          double extentAfter = maxScrollExtent - offset;
          if (extentAfter == 0.0 && checkLoadState(LoadState.PREPARING_LOAD)) {
            /// Enter loading
            _loadStateNotifier.value = LoadState.LOADING;
          } else if (offset - maxScrollExtent + widget.headerHeight >
              widget.footerTrigger) {
            /// This slide does not reach [footerTrigger] and will return to the bottom
            loadTimer = Timer(Duration(milliseconds: 100), () {
              if (checkLoadState(LoadState.IDLE) &&
                  checkRefreshState(RefreshState.IDLE)) {
                _loadStateNotifier?.value = LoadState.PREPARING_LOAD;
                if (maxScrollExtent == offset) {
                  _loadStateNotifier?.value = LoadState.LOADING;
                } else {
                  _scrollController?.animateTo(
                      _scrollController?.position?.maxScrollExtent,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.linear);
                }
              }
            });
          } else if (extentAfter < widget.footerHeight) {
            /// When this slide reaches between [footerTrigger] and [footerHeight], it will enter loading
            loadTimer = Timer(Duration(milliseconds: 100), () {
              if (_scrollController != null &&
                  _loadStateNotifier.value == LoadState.IDLE) {
                _scrollController?.animateTo(
                    maxScrollExtent - widget.footerHeight,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear);
              }
            });
          }
        }
        return false;
      },
      child: CustomScrollView(
        key: widget.key,
        physics: _physics,
        controller: _scrollController,
        slivers: slivers,
//        cacheExtent: widget.headerHeight,
      ),
    );
  }

  bool checkRefreshState(RefreshState state) {
    if (_stateNotifier != null) {
      return _stateNotifier.value == state;
    } else {
      return false;
    }
  }

  bool checkLoadState(LoadState state) {
    if (_loadStateNotifier != null) {
      return _loadStateNotifier.value == state;
    } else {
      return false;
    }
  }

  bool isFooterShow() =>
      widget.footer != null &&
      widget.footerHeight != null &&
      widget.footerHeight > 0;

  bool isHeaderShow() =>
      (widget.header != null || widget.headerBuilder != null) &&
      widget.headerHeight > 0;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _scrollNotifier.dispose();
    _stateNotifier.dispose();
    _loadStateNotifier.dispose();
    if (widget.controller != null) {
      widget.controller.dispose();
    }
  }
}

// ignore: must_be_immutable
class _Header extends StatefulWidget {
  ValueNotifier<ScrollNotification> scrollNotifier;
  ValueNotifier<RefreshState> stateNotifier;
  ScrollController scrollController;
  double headerHeight;
  double triggerOffset;
  Widget child;
  HeaderBuilder build;

  _Header({
    Key key,
    this.scrollNotifier,
    this.stateNotifier,
    this.scrollController,
    this.child,
    this.headerHeight = 50.0,
    this.triggerOffset = 60.0,
    this.build,
  }) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  ValueNotifier<double> headerTopOffset;

  @override
  // ignore: must_call_super
  void initState() {
    if (widget.stateNotifier != null) {
      widget.stateNotifier.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
      headerTopOffset = ValueNotifier(0.0);
    }
    super.initState();
  }

  @override
  void dispose() {
    headerTopOffset?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _HeaderContainerWidget(
      headerHeight: widget.headerHeight,
      triggerOffset: widget.triggerOffset,
      stateNotifier: widget.stateNotifier,
      headerTopOffset: headerTopOffset,
      child: LayoutBuilder(builder: (_, constraints) {
        double top = -widget.headerHeight + headerTopOffset?.value ?? 0.0;
        return Container(
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              color: FRefresh.debug ? Colors.blue.withOpacity(0.2) : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    top: top,
                    child: widget.build != null
                        ? widget.build(setState, constraints)
                        : widget.child),
              ],
            ));
      }),
    );
  }
}

// ignore: must_be_immutable
class _HeaderContainerWidget extends SingleChildRenderObjectWidget {
  Key key;
  Widget child;
  double headerHeight;
  double triggerOffset;
  ValueNotifier<RefreshState> stateNotifier;
  ValueNotifier<double> headerTopOffset;

  _HeaderContainerWidget({
    this.key,
    this.child,
    this.headerHeight = 50.0,
    this.triggerOffset = 60.0,
    this.stateNotifier,
    this.headerTopOffset,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _HeaderContainerRenderObject(
      headerHeight: headerHeight,
      triggerOffset: triggerOffset,
      stateNotifier: stateNotifier,
      headerTopOffset: headerTopOffset,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant _HeaderContainerRenderObject renderObject) {
    renderObject
      ..height = headerHeight
      ..triggerOffset = triggerOffset
      ..stateNotifier = stateNotifier
      ..headerTopOffset = headerTopOffset;
  }
}

class _HeaderContainerRenderObject extends RenderSliverSingleBoxAdapter {
  ValueNotifier<RefreshState> stateNotifier;
  ValueNotifier<double> headerTopOffset;

  double _triggerOffset;

  double get triggerOffset => _triggerOffset;

  set triggerOffset(double value) {
    if (triggerOffset == value) return;
    _triggerOffset = value;
    markNeedsLayout();
  }

  double _headerHeight;

  double get height => _headerHeight;

  set height(double value) {
    if (height == value) return;
    _headerHeight = value;
    markNeedsLayout();
  }

  bool scrollToRefreshing = false;

  bool get refreshing =>
      stateNotifier != null && stateNotifier.value == RefreshState.REFRESHING;

  bool get finishing =>
      stateNotifier != null && stateNotifier.value == RefreshState.FINISHING;

  bool get preparingRefresh =>
      stateNotifier != null &&
      stateNotifier.value == RefreshState.PREPARING_REFRESH;

  bool get idle =>
      stateNotifier != null && stateNotifier.value == RefreshState.IDLE;

  double get childSize => child.size.height;

  bool get isOverScroll => constraints.overlap < 0.0;

  bool useBuffer = false;

  _HeaderContainerRenderObject({
    double headerHeight = 50.0,
    double triggerOffset = 60.0,
    RefreshState state,
    this.stateNotifier,
    this.headerTopOffset,
  })  : _headerHeight = headerHeight ?? 50.0,
        _triggerOffset = triggerOffset ?? 60.0 {
    triggerOffset ??= 60.0;
  }

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    super.layout(constraints, parentUsesSize: parentUsesSize);
  }

  @override
  void performResize() {
    super.performResize();
  }

  @override
  double get centerOffsetAdjustment {
    // Header浮动时去掉越界
    if (refreshing) {
      final RenderViewportBase renderViewport = parent;
      return max(0.0, -renderViewport.offset.pixels);
    }
    return super.centerOffsetAdjustment;
  }

  @override
  void performLayout() {
    final double overOffset =
        constraints.overlap < 0.0 ? constraints.overlap.abs() : 0.0;
//    print('constraints = ${constraints}');
//    print('overOffset = ${overOffset}');
    child.layout(
      constraints.asBoxConstraints(maxExtent: height + overOffset),
      parentUsesSize: true,
    );
    if (refreshing || preparingRefresh) {
      headerTopOffset?.value = overOffset + height;
      geometry = SliverGeometry(
        paintOrigin: -overOffset,
        paintExtent: childSize,
        maxPaintExtent: childSize,
        layoutExtent: height,
      );
    } else if (finishing) {
      headerTopOffset?.value = overOffset;
      geometry = SliverGeometry(
        paintOrigin: -min(constraints.scrollOffset, height),
        paintExtent: childSize,
        maxPaintExtent: childSize,
        layoutExtent: height,
      );
      useBuffer = true;
    } else if (useBuffer) {
      geometry = SliverGeometry(
        scrollExtent: constraints.scrollOffset,
        paintOrigin: -height,
        paintExtent: childSize,
        maxPaintExtent: childSize,
        layoutExtent: overOffset,
        visible: overOffset > 0,
        hasVisualOverflow: false,
      );
      if (constraints.scrollOffset == 0) {
        useBuffer = false;
      }
    } else {
      headerTopOffset?.value = overOffset +
          (constraints.viewportMainAxisExtent -
              constraints.remainingPaintExtent);
      geometry = SliverGeometry(
        paintOrigin: -min(overOffset, height),
        paintExtent: childSize,
        maxPaintExtent: childSize,
        layoutExtent: overOffset,
        visible: overOffset > 0,
        hasVisualOverflow: false,
      );
    }
    if (overOffset == 0 && preparingRefresh) {
      SchedulerBinding.instance.addPostFrameCallback((time) {
        stateNotifier?.value = RefreshState.REFRESHING;
      });
    }
  }

  @override
  void paint(PaintingContext paintContext, Offset offset) {
    if (constraints.overlap < 0.0 || constraints.scrollOffset + childSize > 0) {
      paintContext.paintChild(child, offset);
    }
  }
}

class Footer extends SingleChildRenderObjectWidget {
  /// Creates a sliver that contains a single box widget.
  const Footer({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  _FooterState createRenderObject(BuildContext context) => _FooterState();
}

class _FooterState extends RenderSliverToBoxAdapter {
  _FooterState({
    RenderBox child,
  }) : super(child: child);

  @override
  void performLayout() {
    if (constraints.precedingScrollExtent <
        constraints.viewportMainAxisExtent) {
      geometry = SliverGeometry(
        visible: false,
      );
    } else {
      super.performLayout();
    }
  }
}

class FBouncingScrollPhysics extends BouncingScrollPhysics {
  final double footerHeight;

  const FBouncingScrollPhysics({
    ScrollPhysics parent,
    this.footerHeight,
  }) : super(parent: parent);

  @override
  FBouncingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return FBouncingScrollPhysics(
      footerHeight: footerHeight,
      parent: buildParent(ancestor),
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != 0.0);
    assert(position.minScrollExtent <= position.maxScrollExtent);
    if (!outOfRange(position)) return offset;
    final double overscrollPastStart =
        max(position.minScrollExtent - position.pixels, 0.0);
    final double overscrollPastEnd = max(
        position.pixels - (position.maxScrollExtent - (footerHeight ?? 0.0)),
        0.0);
    final double overscrollPast = max(overscrollPastStart, overscrollPastEnd);
    final bool easing = (overscrollPastStart > 0.0 && offset < 0.0) ||
        (overscrollPastEnd > 0.0 && offset > 0.0);
//    print('overscrollPastEnd = ${overscrollPastEnd}, offset = ${offset}, easing = ${easing}');
    final double friction = easing
        // Apply less resistance when easing the overscroll vs tensioning.
        ? frictionFactor(
            (overscrollPast - offset.abs()) / position.viewportDimension)
        : frictionFactor(overscrollPast / position.viewportDimension);
    final double direction = offset.sign;

    return direction * _applyFriction(overscrollPast, offset.abs(), friction);
  }

  bool outOfRange(ScrollMetrics position) {
    return (position.pixels < position.minScrollExtent ||
        position.pixels > position.maxScrollExtent - (footerHeight ?? 0.0));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true;
  }

  static double _applyFriction(
      double extentOutside, double absDelta, double gamma) {
    assert(absDelta > 0);
    double total = 0.0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside / gamma;
      if (absDelta < deltaToLimit) return absDelta * gamma;
      total += extentOutside;
      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }
}
