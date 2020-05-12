import 'dart:async';

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
    });
    controller.setOnScrollListener((metrics) {
//      print('metrics = $metrics');
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
          height: 200,
          color: Colors.blue,
          child: FRefresh(
            headerHeight: 80.0 + 20,
            headerTrigger: 50,
            controller: controller,
            header: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "asserts/gif1.gif",
                  width: 80,
                  height: 80,
                ),
                Text("刷新中.."),
              ],
            ),
            footer: Container(height: 50, color: Colors.red, child: Text("加载更多..")),
            footerHeight: 50,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      controller.refresh(duration: Duration(milliseconds: 1000));
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
                controller.finish();
              });
            },
          ),
        ),
      ),
    );
  }
}
