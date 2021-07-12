import 'dart:convert';
import 'package:azt/view/groupScreenStudent.dart';
import 'package:azt/view/groupScreenTeacher.dart';
import 'package:azt/view/notificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:azt/config/global.dart';
import 'package:azt/view/login_screen.dart';
import 'package:azt/controller/load_config.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Splash extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Splash> {
  Future<String> accessToken;
  Future<String> baseUrl;
  @override
  void initState() {
    super.initState();
    accessToken = Prefs.getPref(ACCESS_TOKEN);
    baseUrl = LoadConfigController.load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: baseUrl,
      builder: (context, snapshot){
        if(snapshot.hasData) { // co thong tin config
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
        }else if(snapshot.hasError){
          return Text("${snapshot.error}");
        }
        return Center(
          child: CircularProgressIndicator(),
        );

      }
    );


  }
}
