import 'package:azt/view/notificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:azt/config/global.dart';
import 'package:azt/view/mainHome.dart';
import 'package:azt/view/submit_homeworks.dart';

class Splash extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Splash> {
  Future<String> accessToken;
  Future<String> anonymousToken;

  @override
  void initState() {
    super.initState();
    accessToken = Prefs.getPref(ACCESS_TOKEN);
    anonymousToken = Prefs.getPref(ANONYMOUS_TOKEN);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: accessToken,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NotificationScreen(
              role: 'teacher',
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return FutureBuilder(
            future: anonymousToken,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SubmitForm();
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return MainHome();
            },
          );
        });
  }
}
