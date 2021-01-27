import 'package:flutter/material.dart';
import 'package:azt/config/global.dart';
import 'package:azt/models/authen.dart';
import 'package:azt/models/profile_mo.dart';
import 'package:azt/view/dashboard_screen.dart';
import 'package:azt/view/mainHome.dart';

import 'loading_screen.dart';

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
            print("TOKEN: "+ snapshot.data);
            return FutureBuilder(
                future: Login.getUserInfo(snapshot.data.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Dashboard();
                  } else {
                    return LoadingScreen();
                  }
                });
          } else {
            return MainHome();
          }
        });
  }
}
