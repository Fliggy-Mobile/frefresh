import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:ffloat/ffloat.dart';
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
  FRefreshController controller3;
  FRefreshController controller4;
  FRefreshController controller5;
  bool canLoad = true;
  int clickCount = 0;

  int itemCount1 = 2;

  int itemCount2 = 4;

  int itemCount3 = 1;

  int itemCount4 = 2;

  int itemCount5 = 15;

  double groupValue = 1.0;

  String image2 = "assets/icon_refresh11.gif";

  String text4 = "Drop-down to loading";

  Color textColor;
  List<Color> colorList;

  @override
  void initState() {
    super.initState();
    textColor = mainBackgroundColor;
    colorList = [
      mainBackgroundColor,
      Color(0xffffebee),
      Color(0xffd1c4e9),
      Color(0xffbbdefb),
      Color(0xffc8e6c9),
      Color(0xffffe0b2),
      Color(0xffffccbc),
    ];
//    FRefresh.debug = true;
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

    controller3 = FRefreshController();
    controller3.setOnStateChangedCallback((state) {
      print('state = $state');
    });
    controller4 = FRefreshController();

    controller5 = FRefreshController();
    controller5.setOnStateChangedCallback((state) {
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
            color: mainBackgroundColor,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildTitle("Header Demo"),
                  buildMiddleMargin(),

                  /// Header Demo
                  headerDemo(),
                  buildMiddleMargin(),
                  buildTitle("HeaderBuilder Demo"),
                  buildMiddleMargin(),

                  /// HeaderBuilder Demo
                  buildHeaderBuilderDemo(),
                  buildMiddleMargin(),
                  buildTitle("Footer Demo"),
                  buildMiddleMargin(),

                  /// Load Demo
                  buildLoadDemo(),
                  buildMiddleMargin(),
                  buildTitle("FooterBuilder Demo"),
                  buildMiddleMargin(),

                  /// FooterBuilder Demo
                  footerBuilderDemo(),
                  buildMiddleMargin(),
                  buildTitle("Controller Demo"),
                  buildMiddleMargin(),

                  /// Controller Demo
                  buildControllerDemo(),
                  buildBiggestMargin(),
                  buildBiggestMargin(),
                  buildBiggestMargin(),
                ],
              ),
            )),
      ),
    );
  }

  Widget buildControllerDemo() {
    return buildFRefreshContainer(StatefulBuilder(builder: (_, setState) {
      return FRefresh(
        controller: controller5,
        header: Image.asset(
          "assets/icon_refresh4.gif",
          height: 80.0,
          fit: BoxFit.fitHeight,
        ),
        headerHeight: 80.0,
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icon_refresh5.gif",
              height: 50.0,
            ),
            Text(
              "Writing..",
              style: TextStyle(color: Color(0xffcfd8dc)),
            ),
          ],
        ),
        footerHeight: 50,
        onRefresh: () {
          Timer(Duration(milliseconds: 3000), () {
            controller5?.finishRefresh();
            setState(() {
              textColor = getColor();
            });
          });
        },
        onLoad: () {
          Timer(Duration(milliseconds: 3000), () {
            controller5?.finishLoad();
            setState(() {
              itemCount5 = itemCount5 + 10;
            });
          });
        },
        child: Container(
          width: 220,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FSuper(
                width: 220.0,
                height: 100.0,
                backgroundColor: textColor,
                corner: Corner(leftTopCorner: 6.0, rightTopCorner: 6.0),
                shadowColor: mainShadowColor,
                shadowBlur: 3.0,
                shadowOffset: Offset(2.0, 2.0),
                child1: FSuper(
                  width: 28.0,
                  height: 28.0,
                  text: "R",
                  textColor: Colors.white,
                  textAlignment: Alignment.center,
                  corner: Corner.all(20.0),
                  backgroundColor: Colors.black38,
                  shadowColor: mainShadowColor,
                  shadowBlur: 3.0,
                  shadowOffset: Offset(2.0, 2.0),
                  onClick: () {
                    controller5?.refresh(
                        duration: Duration(milliseconds: 2000));
                  },
                ),
                child1Alignment: Alignment.topRight,
                child1Margin: EdgeInsets.only(top: 12.0, right: 12.0),
              ),
              const SizedBox(height: 18.0),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(left: 9.0, right: 9.0, bottom: 9.0),
                  shrinkWrap: true,
                  itemCount: itemCount5,
                  itemBuilder: (_, index) {
                    return FSuper(
                      width: 220.0 * (Random().nextDouble() * 0.5 + 0.5),
                      height: 5.0,
                      margin: EdgeInsets.only(top: index == 0 ? 0.0 : 12.0),
                      backgroundColor: textColor,
                      corner: Corner.all(2.0),
                      shadowColor: mainShadowColor,
                      shadowBlur: 5.0,
                      shadowOffset: Offset(2.0, 2.0),
                    );
                  })
            ],
          ),
        ),
      );
    }));
  }

  Color getColor() {
    return colorList[Random().nextInt(colorList.length - 1)];
  }

  Widget footerBuilderDemo() {
    return buildFRefreshContainer(StatefulBuilder(builder: (_, setState) {
      return FRefresh(
        controller: controller4,
        footerBuilder: (setter) {
          controller4.setOnStateChangedCallback((state) {
            setter(() {
              if (controller4.loadState == LoadState.PREPARING_LOAD) {
                text4 = "Release to load";
              } else if (controller4.loadState == LoadState.LOADING) {
                text4 = "Loading..";
              } else if (controller4.loadState == LoadState.FINISHING) {
                text4 = "Loading completed";
              } else {
                text4 = "Drop-down to loading";
              }
            });
          });
          return Container(
              height: 38,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      backgroundColor: mainBackgroundColor,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(mainTextSubColor),
                      strokeWidth: 2.0,
                    ),
                  ),
                  const SizedBox(width: 9.0),
                  Text(
                    text4,
                    style: TextStyle(color: mainTextSubColor),
                  ),
                ],
              ));
        },
        footerHeight: 38.0,
        onLoad: () {
          Timer(Duration(milliseconds: 3000), () {
            itemCount4++;
            controller4.backOriginOnLoadFinish = itemCount4 % 2 == 0;
            controller4.finishLoad();
            print('controller4.position = ${controller4.position}, controller4.scrollMetrics = ${controller4.scrollMetrics}');
            setState(() {
            });
          });
        },
        child: Container(
          width: 220,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FSuper(
                width: 220.0,
                height: 100.0,
                backgroundColor: mainBackgroundColor,
                corner: Corner(leftTopCorner: 6.0, rightTopCorner: 6.0),
                shadowColor: mainShadowColor,
                shadowBlur: 3.0,
                shadowOffset: Offset(2.0, 2.0),
              ),
              const SizedBox(height: 15.0),
              GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.only(left: 12.0, right: 12.0, bottom: 9.0),
                  itemCount: 5,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
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
              const SizedBox(height: 6.0),
              FSuper(
                width: 220.0 - 24.0,
                height: 90.0,
                backgroundColor: mainBackgroundColor,
                corner: Corner.all(6.0),
                shadowColor: mainShadowColor,
                shadowBlur: 3.0,
                shadowOffset: Offset(2.0, 2.0),
              ),
              const SizedBox(height: 9.0),
              GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.only(left: 12.0, right: 12.0, bottom: 9.0),
                  itemCount: itemCount4,
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
                        onTap: (){
                          controller4?.scrollBy(20.0);
                        },
                      );
                    });
                  }),
            ],
          ),
        ),
      );
    }));
  }

  Widget buildLoadDemo() {
    return buildFRefreshContainer(StatefulBuilder(builder: (_, setState) {
      return FRefresh(
        controller: controller3,
        footer: Container(
            height: 20,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: 10,
              child: LinearProgressIndicator(),
            )),
        footerHeight: 20.0,
        onLoad: () {
          Timer(Duration(milliseconds: 3000), () {
            controller3.finishLoad();
            setState(() {
              itemCount3++;
            });
          });
        },
        child: Container(
          width: 220,
          padding: EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FSuper(
                width: 220.0 - 24.0,
                height: 100.0,
                backgroundColor: mainBackgroundColor,
                corner: Corner.all(6.0),
                shadowColor: mainShadowColor,
                shadowBlur: 3.0,
                shadowOffset: Offset(2.0, 2.0),
              ),
              const SizedBox(height: 15.0),
              GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.only(left: 12.0, right: 12.0, bottom: 9.0),
                  itemCount: 8,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 9.0,
                  ),
                  itemBuilder: (_, index) {
                    return LayoutBuilder(builder: (_, constraints) {
                      return FFloat(
                        (settter) {
                          return Text(
                            "Hello, Developer!",
                            style: TextStyle(color: Colors.white),
                          );
                        },
                        anchor: GridItem(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          index: index,
                        ),
                        padding: EdgeInsets.all(6.0),
                        corner: FFloatCorner.all(3.0),
                        margin: EdgeInsets.only(bottom: 6.0),
                      );
                    });
                  }),
              const SizedBox(height: 6.0),
              FSuper(
                width: 220.0 - 24.0,
                height: 30.0,
                backgroundColor: mainBackgroundColor,
                corner: Corner.all(6.0),
                shadowColor: mainShadowColor,
                shadowBlur: 3.0,
                shadowOffset: Offset(2.0, 2.0),
              ),
              const SizedBox(height: 6.0),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.only(left: 12.0, right: 12.0, bottom: 9.0),
                  shrinkWrap: true,
                  itemCount: itemCount3,
                  itemBuilder: (_, index) {
                    return ListItem(
                      width: 350.0 - 24.0,
                      height: 80.0,
                      index: index,
                    );
                  })
            ],
          ),
        ),
      );
    }));
  }

  Widget buildHeaderBuilderDemo() {
    return buildFRefreshContainer(StatefulBuilder(builder: (_, setState) {
      return FRefresh(
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
            padding:
                EdgeInsets.only(top: 9.0, left: 12.0, right: 12.0, bottom: 9.0),
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
      );
    }));
  }

  Widget headerDemo() {
    return buildFRefreshContainer(StatefulBuilder(builder: (_, setState) {
      return FRefresh(
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
            padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 9.0),
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
      );
    }));
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
      margin: EdgeInsets.only(top: 12.0 * hR),
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
  final VoidCallback onTap;

  GridItem({
    this.width = 100,
    this.height = 100,
    this.index,
    this.onTap,
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
      onClick: onTap,
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
