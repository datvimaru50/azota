import 'package:flutter/material.dart';
import 'package:azt/config/global.dart';
import 'package:azt/view/dashboard_screen.dart';
import 'package:azt/view/mainHome.dart';

class Splash extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Prefs.getPref(ACCESS_TOKEN),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("TOKEN: " + snapshot.data);
            return Dashboard();
          } else {
            return MainHome();
          }
        });
  }
}
