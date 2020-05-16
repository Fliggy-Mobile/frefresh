import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fradio/fradio.dart';

import 'package:frefresh/frefresh.dart';
import 'package:frefresh_example/part.dart';
import 'package:fsuper/fsuper.dart';
import 'package:fradio/fradio.dart';

import 'color.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FRefreshController controller1;
  FRefreshController controller2;
  bool canLoad = true;
  int clickCount = 0;

  int itemCount1 = 2;

  int itemCount2 = 4;

  double groupValue = 1.0;

  String image2 = "assets/icon_refresh11.gif";

  @override
  void initState() {
    super.initState();
    FRefresh.debug = true;
    controller1 = FRefreshController();
    controller1.setOnStateChangedCallback((state) {
      print('state = $state');
      if (state is RefreshState) {}
    });
    controller1.setOnScrollListener((metrics) {});

    controller2 = FRefreshController();
    controller2.setOnStateChangedCallback((state) {
      print('state = $state');
    });
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
                  buildTitle("HeaderBuilder Demo"),
                  buildMiddleMargin(),
                  buildFRefreshContainer(FRefresh(
                    controller: controller2,
                    headerBuilder: (setter, constraints) {
                      return Container(
                        width: 220,
                        height: 100.0,
                        child: Stack(
                          children: [
                            Image.asset(
                              image2,
                              height: 100.0,
                              width: 220,
                              fit: BoxFit.fitWidth,
                            ),
                            Positioned(
                                right: 12,
                                bottom: 10,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    FRadio(
                                      width: 20,
                                      height: 10,
                                      value: 1.0,
                                      groupValue: groupValue,
                                      normalColor: mainBackgroundColor,
                                      selectedColor: mainTextNormalColor,
                                      onChanged: (value) {
                                        setter(() {
                                          groupValue = value;
                                          image2 = "assets/icon_refresh11.gif";
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 6.0),
                                    FRadio(
                                      width: 20,
                                      height: 10,
                                      value: 2.0,
                                      groupValue: groupValue,
                                      normalColor: mainBackgroundColor,
                                      selectedColor: mainTextNormalColor,
                                      onChanged: (value) {
                                        setter(() {
                                          groupValue = value;
                                          image2 = "assets/icon_refresh9.gif";
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 6.0),
                                    FRadio(
                                      width: 20,
                                      height: 10,
                                      value: 3.0,
                                      groupValue: groupValue,
                                      normalColor: mainBackgroundColor,
                                      selectedColor: mainTextNormalColor,
                                      onChanged: (value) {
                                        setter(() {
                                          groupValue = value;
                                          image2 = "assets/icon_refresh8.gif";
                                        });
                                      },
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      );
                    },
                    headerHeight: 100.0,
                    headerTrigger: 50,
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                            top: 9.0, left: 12.0, right: 12.0, bottom: 9.0),
                        itemCount: itemCount2,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 9.0,
                          mainAxisSpacing: 9.0,
                        ),
                        itemBuilder: (_, index) {
                          return LayoutBuilder(builder: (_, constraints) {
                            return GridItem(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              index: index,
                            );
                          });
                        }),
                    onRefresh: () {
                      Timer(Duration(milliseconds: 5000), () {
                        controller2.finishRefresh();
                        setState(() {
                          itemCount2++;
                        });
                      });
                    },
                  )),
                  buildBiggestMargin(),
                  buildBiggestMargin(),
                  buildBiggestMargin(),
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
      margin:
          EdgeInsets.only(top: 12.0 * hR, left: 12.0 * hR, right: 12.0 * hR),
      padding: EdgeInsets.all(6.0 * hR),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3.0 * hR)),
        boxShadow: [
          BoxShadow(
              color: mainShadowColor,
              blurRadius: 3.0,
              offset: Offset(2.0, 2.0)),
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
    double wR = width / 93.5;
    double hR = height / 93.5;
    return FSuper(
      width: width,
      height: height,
      backgroundColor: Colors.white,
      corner: Corner.all(6.0 * wR),
      shadowColor: mainShadowColor,
      shadowBlur: 3.0,
      shadowOffset: Offset(2.0, 2.0),
      child1: FSuper(
        width: width,
        height: 36.0 * hR,
        backgroundColor: Colors.grey.withOpacity(0.1),
        corner: Corner(leftBottomCorner: 6.0 * wR, rightBottomCorner: 6.0 * wR),
        child1: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FSuper(
              width: width / 2.0,
              height: 5.0 * hR,
              backgroundColor: Colors.white,
              corner: Corner.all(5.0 * hR),
            ),
            SizedBox(height: 6.0 * hR),
            FSuper(
              width: width / 1.3,
              height: 5.0 * hR,
              backgroundColor: Colors.white,
              corner: Corner.all(5.0 * hR),
            ),
          ],
        ),
        child1Alignment: Alignment.centerLeft,
        child1Margin: EdgeInsets.only(left: 9.0 * wR),
      ),
      child1Alignment: Alignment.bottomCenter,
    );
  }
}
