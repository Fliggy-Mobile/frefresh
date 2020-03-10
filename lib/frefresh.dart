import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

enum RefreshState {
  PREPARING_REFRESH,
  SCROLL_TO_REFRESH,
  REFRESHING,
  FINISHING,
  AIDL,
  SCROLLING,
}

typedef OnStateChangedCallback = void Function(RefreshState state);

class FRefreshController {
  VoidCallback onRefresh;
  VoidCallback onFinish;
  OnStateChangedCallback onStateChangedCallback;

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
      print('未绑定任何 FRefresh!');
    }
  }

  void finish() {
    if (_fRefreshState != null) {
      _fRefreshState.finish();
    } else {
      print('未绑定任何 FRefresh!');
    }
  }

  void setOnRefreshListener(VoidCallback onRefresh) {
    this.onRefresh = onRefresh;
  }

  void setOnFinishListener(VoidCallback onFinish) {
    this.onFinish = onFinish;
  }

  void _setFRefreshState(_FRefreshState _fRefreshState) {
    this._fRefreshState = _fRefreshState;
  }

  void setOnStateChangedCallback(OnStateChangedCallback callback) {
    this.onStateChangedCallback = callback;
  }

  void dispose() {
    _fRefreshState = null;
  }
}

class FRefresh extends StatefulWidget {
  Widget header;
  Widget child;
  Widget footer;
  VoidCallback onRefresh;
  double headerHeight;
  double triggerOffset;
  FRefreshController controller;

  FRefresh({
    Key key,
    this.header,
    @required this.child,
    this.footer,
    this.onRefresh,
    this.controller,
    this.headerHeight = 50.0,
    this.triggerOffset = 60.0,
  }) : super(key: key);

  @override
  _FRefreshState createState() => _FRefreshState();
}

class _FRefreshState extends State<FRefresh> {
  ValueNotifier<ScrollNotification> _scrollNotifier;
  ValueNotifier<RefreshState> _stateNotifier;
  ValueNotifier _dragNotifier;
  ScrollPhysics _physics;
  ScrollController _scrollController;

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
      if (_dragNotifier.value is DragUpdateDetails) {
        if (_stateNotifier.value == RefreshState.AIDL &&
            -_scrollController.position.pixels >= widget.triggerOffset) {
          _stateNotifier.value = RefreshState.PREPARING_REFRESH;
        } else if (!(-_scrollController.position.pixels >=
                widget.triggerOffset) &&
            _stateNotifier.value == RefreshState.PREPARING_REFRESH) {
          _stateNotifier.value = RefreshState.SCROLL_TO_REFRESH;
//          _stateNotifier.value = RefreshState.AIDL;
        } else if(_stateNotifier.value == RefreshState.PREPARING_REFRESH){
//          _stateNotifier.value = RefreshState.SCROLL_TO_REFRESH;
        }
      } else if(_dragNotifier.value == null || _dragNotifier.value is UserScrollNotification){
        if (_scrollController.position.pixels == 0.0 && _stateNotifier.value == RefreshState.SCROLL_TO_REFRESH) {
          _stateNotifier.value = RefreshState.REFRESHING;
        }
      }
    });
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

  void refresh(Duration duration) {
    if (_stateNotifier != null &&
        _stateNotifier.value == RefreshState.AIDL &&
        _scrollController != null) {
      _scrollController.animateTo(widget.headerHeight,
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
        triggerOffset: widget.triggerOffset,
        scrollNotifier: _scrollNotifier,
        stateNotifier: _stateNotifier,
        dragNotifier: _dragNotifier,
        scrollController: _scrollController,
        child: widget.header,
      ));
    }
    if (widget.child != null) {
      slivers.add(
        SliverList(delegate: SliverChildListDelegate([widget.child])),
      );
    }
    if (widget.footer != null) {}
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          _dragNotifier.value = notification.dragDetails;
        } else if (notification is ScrollUpdateNotification) {
          _dragNotifier.value = notification.dragDetails;
        } else if (notification is ScrollEndNotification) {
          _dragNotifier.value = notification.dragDetails;
        } else {
          _dragNotifier.value = notification;
        }
        return false;
      },
      child: CustomScrollView(
        physics: _physics,
        controller: _scrollController,
        slivers: slivers,
      ),
    );
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
      child: LayoutBuilder(
        builder: (context, constraints) {
//          print('LayoutBuilder => constraints = ${constraints.maxHeight}');
          return Container(
//            color: Colors.redAccent,
            alignment: Alignment.bottomCenter,
            height: widget.headerHeight > constraints.maxHeight
                ? widget.headerHeight
                : constraints.maxHeight,
            child: widget.child,
          );
        },
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
      ..headerHeight = headerHeight
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

  double get headerHeight => _headerHeight;

  set headerHeight(double value) {
    if (headerHeight == value) return;
    _headerHeight = value;
    markNeedsLayout();
  }

//  RefreshState _state;
//
//  RefreshState get state => _state ?? RefreshState.AIDL;
//
//  set state(RefreshState value) {
//    if (_state == value) return;
//    _state = value;
//    markNeedsLayout();
//  }

  bool get scrollToRefreshing => stateNotifier != null && stateNotifier.value == RefreshState.SCROLL_TO_REFRESH;

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
//    print("performLayout---------------------strat-----------------------");
    final double overOffset =
        constraints.overlap < 0.0 ? constraints.overlap.abs() : 0.0;
    child.layout(
      constraints.asBoxConstraints(
        maxExtent: headerHeight,
      ),
      parentUsesSize: true,
    );

//    print("constraints.overlap = ${constraints.overlap}");
//    print("childSize = ${childSize}");
//    print("constraints.scrollOffset = ${constraints.scrollOffset}");
//    print(
//        "constraints.userScrollDirection = ${constraints.userScrollDirection}");
//    print("constraints.axis = ${constraints.axis}");
//    print("refresh = $refreshing");
//    print("finishing = $finishing");
//    if (refreshing) scrollToRefreshing = false;
    if (isOverScroll || scrollToRefreshing) {
      if (refreshing || scrollToRefreshing) {
        geometry = SliverGeometry(
          paintOrigin: 0.0,
          paintExtent: childSize,
          maxPaintExtent: childSize,
          layoutExtent: childSize,
          visible: true,
          hasVisualOverflow: true,
        );
      } else {
        geometry = SliverGeometry(
          paintOrigin: -childSize + min(overOffset, childSize),
          paintExtent: childSize,
          maxPaintExtent: childSize,
          layoutExtent: min(overOffset, childSize),
        );
      }
    } else {
      if (refreshing) {
        geometry = SliverGeometry(
          paintOrigin: 0.0,
          paintExtent: childSize,
          maxPaintExtent: childSize,
          layoutExtent: childSize,
          visible: true,
          hasVisualOverflow: true,
        );
      } else if (finishing) {
        geometry = SliverGeometry(
          scrollExtent: childSize,
          paintOrigin: -constraints.scrollOffset,
          paintExtent: max(childSize - constraints.scrollOffset, 0.0),
          maxPaintExtent: max(childSize - constraints.scrollOffset, 0.0),
          layoutExtent: max(childSize - constraints.scrollOffset, 0.0),
        );
      } else {
//        print("SliverGeometry.zero");
        geometry = SliverGeometry(
          scrollExtent:
              constraints.userScrollDirection == ScrollDirection.reverse
                  ? 0.0
                  : childSize,
        );
      }
    }
//    if (overOffset <= triggerOffset &&
//        stateNotifier != null &&
//        stateNotifier.value == RefreshState.PREPARING_REFRESH &&
//        !scrollToRefreshing) {
//      scrollToRefreshing = true;
//    } else if (overOffset == 0.0 && scrollToRefreshing) {
//      SchedulerBinding.instance.addPostFrameCallback((time) {
//        stateNotifier.value = RefreshState.REFRESHING;
//      });
//    }
//    print("performLayout---------------------end-----------------------\n");
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
