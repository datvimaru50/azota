import 'package:azt/view/groupScreenTeacher.dart';
import 'package:flutter/material.dart';
import 'package:azt/config/global.dart';
import 'package:azt/view/mainHome.dart';
import 'package:azt/view/submit_homeworks.dart';
import 'package:provider/provider.dart';
import 'package:azt/store/notification_store.dart';

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
    return ChangeNotifierProvider(
      create: (context) => NotiModel(),
      child: FutureBuilder(
          future: accessToken,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GroupScreenTeacher();
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
          }),
    );
  }
}
