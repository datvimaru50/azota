import 'dart:convert';
import 'package:azt/view/groupScreenStudent.dart';
import 'package:azt/view/groupScreenTeacher.dart';
import 'package:azt/view/notificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:azt/config/global.dart';
import 'package:azt/view/login_screen.dart';

import 'package:jwt_decoder/jwt_decoder.dart';

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
            Map<String, dynamic> decodedToken = JwtDecoder.decode(snapshot.data);

            var role = 'teacher';
            var rolesJson = json.decode(decodedToken['roles']);

            if(rolesJson['STUDENT'] == 1){
              role =  'student';
            }

            return GroupScreenTeacher(role: role);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return LoginForm();
        });
  }
}
