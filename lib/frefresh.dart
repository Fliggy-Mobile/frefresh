import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

enum RefreshState {
  PREPARING_REFRESH,
  REFRESHING,
  FINISHING,
  AIDL,
  SCROLLING,
}

typedef OnStateChangedCallback = void Function(RefreshState state);

typedef OnScrollListener = void Function(ScrollMetrics metrics);

class FRefreshController {
  OnStateChangedCallback onStateChangedCallback;
  OnScrollListener onScrollListener;

  RefreshState _state = RefreshState.AIDL;

  RefreshState get state => _state;

  set state(RefreshState value) {
    if (_state == value) return;
    _state = value;
    if (onStateChangedCallback != null) {
      onStateChangedCallback(state);
    }
  }

  _FRefreshState _fRefreshState;

  FRefreshController();

  bool get refreshing =>
      _fRefreshState?._stateNotifier?.value == RefreshState.REFRESHING;

  void refresh({Duration duration = const Duration(milliseconds: 300)}) {
    if (_fRefreshState != null) {
      _fRefreshState.refresh(duration);
    } else {
      print('No FRefresh is bound!');
    }
  }

  void finish() {
    if (_fRefreshState != null) {
      _fRefreshState.finish();
    } else {
      print('No FRefresh is bound!');
    }
  }

  void _setFRefreshState(_FRefreshState _fRefreshState) {
    this._fRefreshState = _fRefreshState;
  }

  void setOnStateChangedCallback(OnStateChangedCallback callback) {
    this.onStateChangedCallback = callback;
  }

  void setOnScrollListener(OnScrollListener onScrollListener) {
    this.onScrollListener = onScrollListener;
  }

  void dispose() {
    _fRefreshState = null;
    onStateChangedCallback = null;
    onScrollListener = null;
  }
}

class FRefresh extends StatefulWidget {
  final Widget header;
  final Widget child;
  final Widget footer;
  final VoidCallback onRefresh;
  final double headerHeight;
  double headerTrigger;
  final double footerHeight;
  double footerTrigger;
  final FRefreshController controller;

//  final bool shrinkWrap;

  FRefresh({
    Key key,
    this.header,
    @required this.child,
    this.footer,
    this.onRefresh,
    this.controller,
    this.headerHeight = 50.0,
    this.headerTrigger,
    this.footerHeight = 0.0,
    this.footerTrigger,
//    this.shrinkWrap = false,
  }) : super(key: key) {
    if (headerTrigger == null) {
      headerTrigger = (headerHeight ?? 0.0) / 2.0;
    }
    if (footerTrigger == null) {
      footerTrigger = (footerHeight ?? 0.0) / 2.0;
    }
  }

  @override
  _FRefreshState createState() => _FRefreshState();
}

class _FRefreshState extends State<FRefresh> {
  ValueNotifier<ScrollNotification> _scrollNotifier;
  ValueNotifier<RefreshState> _stateNotifier;
  ValueNotifier _dragNotifier;
  ScrollPhysics _physics;
  ScrollController _scrollController;

  GlobalKey headerGlobalKey = GlobalKey();

  @override
  void initState() {
    _scrollNotifier = ValueNotifier(null);
    _stateNotifier = ValueNotifier(RefreshState.AIDL);
    _dragNotifier = ValueNotifier(null);
    _physics = FBouncingScrollPhysics();
    _scrollController = ScrollController();
    if (widget.controller != null) {
      widget.controller._setFRefreshState(this);
    }

    _stateNotifier.addListener(() {
      if (widget.controller != null) {
        widget.controller.state = _stateNotifier.value;
      }
      if (_stateNotifier.value == RefreshState.REFRESHING) {
        if (widget.onRefresh != null) {
          widget.onRefresh();
        }
      }
    });
    _dragNotifier.addListener(() {
      if (_dragNotifier.value is ScrollUpdateNotification) {
        if (_stateNotifier.value == RefreshState.AIDL &&
            -_scrollController.position.pixels >= widget.headerTrigger) {
          _stateNotifier.value = RefreshState.PREPARING_REFRESH;
        } else if (!(-_scrollController.position.pixels >=
                widget.headerTrigger) &&
            _stateNotifier.value == RefreshState.PREPARING_REFRESH) {
          _stateNotifier.value = RefreshState.AIDL;
        }
      }
    });
  }

  void refresh(Duration duration) {
    if (_stateNotifier != null &&
        _stateNotifier.value == RefreshState.AIDL &&
        _scrollController != null) {
      _scrollController.jumpTo(0.0);
      _scrollController.animateTo(-widget.headerHeight,
          duration: duration, curve: Curves.linear);
    }
  }

  void _finishAnim() {
    _stateNotifier.value = RefreshState.FINISHING;
    _scrollController
        .animateTo(widget.headerHeight,
            duration: Duration(milliseconds: 200), curve: Curves.linear)
        .whenComplete(() {
      _stateNotifier.value = RefreshState.AIDL;
    });
  }

  void finish() {
    if (_stateNotifier != null &&
        _stateNotifier.value == RefreshState.REFRESHING &&
        _scrollController != null) {
      SchedulerBinding.instance.addPostFrameCallback((time) {
        _finishAnim();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return SizedBox();
    List<Widget> slivers = <Widget>[];
    if (widget.header != null) {
      slivers.add(Header(
        headerHeight: widget.headerHeight,
        triggerOffset: widget.headerTrigger,
        scrollNotifier: _scrollNotifier,
        stateNotifier: _stateNotifier,
        dragNotifier: _dragNotifier,
        scrollController: _scrollController,
        child: widget.header,
      ));
    }
    if (widget.child != null) {
      slivers.add(SliverToBoxAdapter(child: widget.child));
    }
    if (widget.footer != null) {
//      slivers.add(Footer(
//        height: widget.footerHeight,
//        trigger: widget.footerTrigger,
//        scrollNotifier: _scrollNotifier,
//        stateNotifier: _stateNotifier,
//        dragNotifier: _dragNotifier,
//        scrollController: _scrollController,
//        child: widget.footer,
//      ));
//      slivers.add(SliverToBoxAdapter(child: widget.footer));
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          _dragNotifier.value = notification;
        } else if (notification is ScrollUpdateNotification) {
          _dragNotifier.value = notification;
        } else if (notification is ScrollEndNotification) {
          _dragNotifier.value = notification;
        }
        if (widget.controller != null &&
            widget.controller.onScrollListener != null) {
          widget.controller.onScrollListener(notification.metrics);
        }
        return false;
      },
      child: CustomScrollView(
        key: widget.key,
//          shrinkWrap: widget.shrinkWrap,
        physics: _physics,
        controller: _scrollController,
        slivers: slivers,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _scrollNotifier.dispose();
    _stateNotifier.dispose();
    _dragNotifier.dispose();
    if (widget.controller != null) {
      widget.controller.dispose();
    }
  }
}

class Header extends StatefulWidget {
  ValueNotifier<ScrollNotification> scrollNotifier;
  ValueNotifier<RefreshState> stateNotifier;
  ValueNotifier dragNotifier;
  ScrollController scrollController;
  double headerHeight;
  double triggerOffset;
  Widget child;

  Header({
    Key key,
    this.scrollNotifier,
    this.stateNotifier,
    this.dragNotifier,
    this.scrollController,
    this.child,
    this.headerHeight = 50.0,
    this.triggerOffset = 60.0,
  }) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  void initState() {
    if (widget.stateNotifier != null) {
      widget.stateNotifier.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return SizedBox();
    return _HeaderContainerWidget(
      headerHeight: widget.headerHeight,
      triggerOffset: widget.triggerOffset,
      stateNotifier: widget.stateNotifier,
      child: Container(
        height: widget.headerHeight,
        alignment: Alignment.bottomCenter,
        child: widget.child,
      ),
    );
  }
}

class _HeaderContainerWidget extends SingleChildRenderObjectWidget {
  Key key;
  Widget child;
  double headerHeight;
  double triggerOffset;
  ValueNotifier<RefreshState> stateNotifier;

  _HeaderContainerWidget({
    this.key,
    this.child,
    this.headerHeight = 50.0,
    this.triggerOffset = 60.0,
    this.stateNotifier,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _HeaderContainerRenderObject(
      headerHeight: headerHeight,
      triggerOffset: triggerOffset,
      stateNotifier: stateNotifier,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant _HeaderContainerRenderObject renderObject) {
    renderObject
      ..height = headerHeight
      ..triggerOffset = triggerOffset
      ..stateNotifier = stateNotifier;
  }
}

class _HeaderContainerRenderObject extends RenderSliverSingleBoxAdapter {
  ValueNotifier<RefreshState> stateNotifier;

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

  double get childSize => child.size.height;

  bool get isOverScroll => constraints.overlap < 0.0;

  _HeaderContainerRenderObject({
    double headerHeight = 50.0,
    double triggerOffset = 60.0,
    RefreshState state,
    this.stateNotifier,
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
  void performLayout() {
    final double overOffset =
        constraints.overlap < 0.0 ? constraints.overlap.abs() : 0.0;
    child.layout(
      constraints.asBoxConstraints(
        maxExtent: height,
      ),
      parentUsesSize: true,
    );
    if (refreshing || finishing) scrollToRefreshing = false;
    if (isOverScroll || scrollToRefreshing) {
      if (refreshing || scrollToRefreshing) {
        geometry = SliverGeometry(
          paintOrigin: -0.0,
          paintExtent: childSize,
          maxPaintExtent: childSize,
          layoutExtent: childSize,
        );
      } else {
        double paintOrigin = childSize;
        if (overOffset <= childSize) {
          paintOrigin = childSize - overOffset;
        } else {
          paintOrigin = 0.0;
        }
        geometry = SliverGeometry(
          paintOrigin: -paintOrigin,
          paintExtent: childSize,
          maxPaintExtent: childSize,
          layoutExtent: childSize.clamp(0.0, overOffset),
        );
      }
    } else {
      if (refreshing) {
        geometry = SliverGeometry(
          paintOrigin: 0.0,
          paintExtent: childSize,
          maxPaintExtent: childSize,
          layoutExtent: childSize,
        );
      } else if (finishing) {
        geometry = SliverGeometry(
          scrollExtent: childSize,
          paintOrigin: -constraints.scrollOffset,
          paintExtent: childSize,
          maxPaintExtent: childSize,
          layoutExtent: childSize - constraints.scrollOffset,
        );
      } else {
        geometry = SliverGeometry.zero;
      }
    }
    if (overOffset >= height &&
        stateNotifier != null &&
        stateNotifier.value == RefreshState.PREPARING_REFRESH &&
        !scrollToRefreshing) {
      scrollToRefreshing = true;
    } else if (overOffset == 0.0 && scrollToRefreshing) {
      SchedulerBinding.instance.addPostFrameCallback((time) {
        stateNotifier.value = RefreshState.REFRESHING;
      });
    }
  }
}

class Footer extends StatefulWidget {
  ValueNotifier<ScrollNotification> scrollNotifier;
  ValueNotifier<RefreshState> stateNotifier;
  ValueNotifier dragNotifier;
  ScrollController scrollController;
  double height;
  double trigger;
  Widget child;

  Footer({
    Key key,
    this.scrollNotifier,
    this.stateNotifier,
    this.dragNotifier,
    this.scrollController,
    this.child,
    this.height,
    this.trigger,
  }) : super(key: key);

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  void initState() {
    if (widget.stateNotifier != null) {
      widget.stateNotifier.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return SizedBox();
    return _FooterContainerWidget(
      height: widget.height,
      trigger: widget.trigger,
      stateNotifier: widget.stateNotifier,
      child: LayoutBuilder(builder: (_, constraints) {
        return Container(
          height: constraints.maxHeight,
          alignment: Alignment.bottomCenter,
          child: widget.child,
        );
      }),
//      child: Container(
//        height: widget.height,
//        alignment: Alignment.bottomCenter,
//        child: widget.child,
//      ),
    );
  }
}

class _FooterContainerWidget extends SingleChildRenderObjectWidget {
  Key key;
  Widget child;
  double height;
  double trigger;
  ValueNotifier<RefreshState> stateNotifier;

  _FooterContainerWidget({
    this.key,
    this.child,
    this.height,
    this.trigger,
    this.stateNotifier,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _FooterContainerRenderObject(
      headerHeight: height,
      triggerOffset: trigger,
      stateNotifier: stateNotifier,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant _FooterContainerRenderObject renderObject) {
    renderObject
      ..height = height
      ..trigger = trigger
      ..stateNotifier = stateNotifier;
  }
}

class _FooterContainerRenderObject extends RenderSliverSingleBoxAdapter {
  ValueNotifier<RefreshState> stateNotifier;

  double _triggerOffset;

  double get trigger => _triggerOffset;

  set trigger(double value) {
    if (trigger == value) return;
    _triggerOffset = value;
    markNeedsLayout();
  }

  double _height;

  double get height => _height;

  set height(double value) {
    if (height == value) return;
    _height = value;
    markNeedsLayout();
  }

  bool scrollToRefreshing = false;

  bool get refreshing =>
      stateNotifier != null && stateNotifier.value == RefreshState.REFRESHING;

  bool get finishing =>
      stateNotifier != null && stateNotifier.value == RefreshState.FINISHING;

  double get childSize => child.size.height;

  bool get isOverScroll => constraints.overlap < 0.0;

  _FooterContainerRenderObject({
    double headerHeight = 50.0,
    double triggerOffset = 60.0,
    RefreshState state,
    this.stateNotifier,
  })  : _height = headerHeight ?? 50.0,
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
  void performLayout() {
    print('Footer-> constraints = $constraints');
    print('Footer-> constraints.overlap = ${constraints.overlap}');
    print(
        'Footer-> constraints.precedingScrollExtent = ${constraints.precedingScrollExtent}');
    print('Footer-> constraints.scrollOffset = ${constraints.scrollOffset}');
    print(
        'Footer-> constraints.remainingPaintExtent = ${constraints.remainingPaintExtent}');

    final double overscrolledExtent = max(
        constraints.remainingPaintExtent +
            (constraints.precedingScrollExtent < height
                ? constraints.scrollOffset
                : 0.0),
        0.0);
    print('Footer-> overscrolledExtent = ${overscrolledExtent}');
//    child.layout(
//      constraints.asBoxConstraints(
//          maxExtent: constraints.viewportMainAxisExtent -
//              constraints.precedingScrollExtent),
//      parentUsesSize: true,
//    );
    double maxExtent = constraints.remainingPaintExtent -
        (constraints.remainingCacheExtent - constraints.viewportMainAxisExtent);
    child.layout(constraints.asBoxConstraints(maxExtent: maxExtent + height),
        parentUsesSize: true);
    double childExtent = child.size.height;
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

//    if (maxExtent == height) {
//      maxExtent -= 1;
//    }
    print('maxExtent = ${maxExtent}');
//    child.layout(
//        constraints.asBoxConstraints(
//            maxExtent: maxExtent <= height * 1.0 ? height * 2.0 : maxExtent),
//        parentUsesSize: true);
//    geometry = SliverGeometry(
//      scrollExtent: height,
//      paintOrigin: maxExtent <= height ? -height + maxExtent : height,
//      paintExtent: height,
//      maxPaintExtent: height,
//      layoutExtent: 0,
//      hasVisualOverflow: true,
//
//    );
    geometry = SliverGeometry(
//      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
//    geometry = SliverGeometry.zero;
  }
}

class FBouncingScrollPhysics extends BouncingScrollPhysics {
  const FBouncingScrollPhysics({
    ScrollPhysics parent,
  }) : super(parent: parent);

  @override
  FBouncingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return FBouncingScrollPhysics(
      parent: buildParent(ancestor),
    );
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    return true;
  }
}
