import 'dart:async';

import 'package:ffloat/ffloat.dart';
import 'package:flutter/material.dart';

import 'package:frefresh/frefresh.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FRefreshController controller;

  @override
  void initState() {
    super.initState();
    controller = FRefreshController();
    controller.setOnStateChangedCallback((state) {
      print('state = $state');
      if (state is RefreshState) {

      }
    });
    controller.setOnScrollListener((metrics) {
//      print('scollerOffset = ${metrics.pixels}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FRefresh'),
        ),
        body: Container(
          width: double.infinity,
//          height: 200,
          color: Colors.blue,
          child: FRefresh(
            headerHeight: 80.0 + 20,
            headerTrigger: 200,
            controller: controller,
            header: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.red,
                  child: Image.asset(
                    "asserts/gif1.gif",
                    width: 80,
                    height: 80,
                  ),
                ),
                Text("刷新中.."),
              ],
            ),
            footer: Container(
                alignment: Alignment.center,
                height: 100,
                color: Colors.red,
                child: Text("加载更多..")),
            footerHeight: 100,
            footerTrigger: 50,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      controller.refresh(
                          duration: Duration(milliseconds: 1000));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text("Item $index"),
                    ),
                  );
                }),
            onRefresh: () {
              Timer(Duration(milliseconds: 3000), () {
                controller.finishRefresh();
              });
            },
            onLoad: () {
              Timer(Duration(milliseconds: 3000), () {
                controller.finishLoad();
              });
            },
          ),
        ),
      ),
    );
  }
}
