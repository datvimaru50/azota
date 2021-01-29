
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => new _LoadingScreenState();
}

class _LoadingScreenState extends StateMVC<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: MaterialApp(
        home: new Scaffold(
          body: new Center(
            child: Image.asset(
              "assets/images/loading.gif",
              height: 100.0,
            ),
          ),
        ),
      ),
    );
  }
}
