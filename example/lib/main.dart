import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:frefresh/frefresh.dart';
import 'package:frefresh_example/part.dart';
import 'package:fsuper/fsuper.dart';

import 'color.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FRefreshController controller1;
  bool canLoad = true;
  int clickCount = 0;

  int itemCount1 = 2;

  @override
  void initState() {
    super.initState();
//    FRefresh.debug = true;
    controller1 = FRefreshController();
    controller1.setOnStateChangedCallback((state) {
      print('state = $state');
      if (state is RefreshState) {}
    });
    controller1.setOnScrollListener((metrics) {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: mainBackgroundColor,
        appBar: AppBar(
          backgroundColor: mainBackgroundColor,
          title: const Text(
            'FRefresh',
            style: TextStyle(color: mainTextTitleColor),
          ),
          centerTitle: true,
        ),
        body: Container(
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildTitle("Base Demo"),
                  buildMiddleMargin(),
                  baseDemo(),
                  buildMiddleMargin(),
                  buildTitle("Base Demo"),
                ],
              ),
            )),
      ),
    );
  }

  Widget baseDemo() {
    return buildFRefreshContainer(FRefresh(
      controller: controller1,
      header: Container(
        width: 75.0,
        height: 75.0,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(),
        child: OverflowBox(
          maxHeight: 100.0,
          maxWidth: 100.0,
          child: Image.asset(
            "assets/icon_refresh3.gif",
            width: 100.0,
            height: 100.0,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      headerHeight: 75.0,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: itemCount1,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                controller1.refresh(duration: Duration(milliseconds: 2000));
              },
              child: ListItem(
                width: 350.0 - 24.0,
                height: 80.0,
                index: index,
              ),
            );
          }),
      onRefresh: () {
        Timer(Duration(milliseconds: 5000), () {
          setState(() {
            itemCount1++;
          });
          controller1.finishRefresh();
        });
      },
    ));
  }

  Widget buildFRefreshContainer(Widget child) {
    return Container(
      height: 350.0,
      width: 220.0,
      padding: EdgeInsets.only(left: 12.0, right: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        boxShadow: [
          BoxShadow(
              color: mainShadowColor, blurRadius: 6.0, offset: Offset(3, 3)),
        ],
      ),
      child: child,
    );
  }
}

class ListItem extends StatelessWidget {
  final double width;
  final double height;
  final int index;

  ListItem({
    this.width = double.infinity,
    this.height = 100,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    double wR = width / 326.0;
    double hR = height / 80.0;
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(top: 12.0 * hR),
      padding: EdgeInsets.all(6.0 * hR),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3.0 * hR)),
        boxShadow: [
          BoxShadow(
              color: mainShadowColor, blurRadius: 2, offset: Offset(1, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FSuper(
                backgroundColor: mainBackgroundColor,
                width: 30.0 * hR,
                height: 30.0 * hR,
                corner: Corner.all(30.0 * hR / 2.0),
              ),
              SizedBox(width: 9.0 * wR),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FSuper(
                    backgroundColor: mainBackgroundColor,
                    width: 50.0 * wR,
                    height: 5.0 * hR,
                    corner: Corner.all(10.0 * hR / 2.0),
                  ),
                  SizedBox(height: 6.0 * hR),
                  FSuper(
                    backgroundColor: mainBackgroundColor,
                    width: 38.0 * wR,
                    height: 5.0 * hR,
                    corner: Corner.all(10.0 * hR / 2.0),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0 * hR),
          FSuper(
            margin: EdgeInsets.only(left: 2.0),
            backgroundColor: mainBackgroundColor,
            width: width / 2.8,
            height: 5.0 * hR,
            corner: Corner.all(10.0 * hR / 2.0),
          ),
          SizedBox(height: 6.0 * hR),
          FSuper(
            margin: EdgeInsets.only(left: 2.0),
            backgroundColor: mainBackgroundColor,
            width: width / 2.0,
            height: 5.0 * hR,
            corner: Corner.all(10.0 * hR / 2.0),
          ),
          SizedBox(height: 6.0 * hR),
          FSuper(
            margin: EdgeInsets.only(left: 2.0),
            backgroundColor: mainBackgroundColor,
            width: width / 2.0,
            height: 5.0 * hR,
            corner: Corner.all(10.0 * hR / 2.0),
          ),
        ],
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final double width;
  final double height;
  final int index;

  GridItem({
    this.width = 100,
    this.height = 100,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return FSuper(
      width: width,
      height: height,
      backgroundColor: mainBackgroundColor,
      corner: Corner.all(6.0),
    );
  }
}
