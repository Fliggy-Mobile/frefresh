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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child: FRefresh(
            controller: controller,
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "asserts/gif1.gif",
                  width: 30,
                  height: 30,
                ),
                Text("刷新中.."),
              ],
            ),
            child: Container(
              color: Colors.redAccent,
              height: 500,
            ),
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
