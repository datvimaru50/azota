import 'package:flutter/material.dart';
import 'package:azt/config/global.dart';
import 'package:azt/view/dashboard_screen.dart';
import 'package:azt/view/mainHome.dart';

class Splash extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Splash> {
  Future<String> accessToken;

  @override
  void initState() {
    super.initState();
    accessToken = Prefs.getPref(ACCESS_TOKEN);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: accessToken,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Dashboard();
          } else if (snapshot.hasError){
            return Text("${snapshot.error}");
          }
          return MainHome();
        });
  }
}
