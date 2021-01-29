import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:azt/view/profile_screen.dart';
import 'package:azt/models/authen.dart';
import 'package:azt/view/notificationScreen.dart';
import 'package:azt/models/firebase_mo.dart';
import 'package:azt/config/global.dart';
import 'package:azt/view/splash_screen.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      SavedToken.saveToken(token);
      print('Init token: ' + token);
    });

    _firebaseMessaging.onTokenRefresh.listen((token) {
      assert(token != null);
      SavedToken.saveToken(token);
      print('Refresh token: ' + token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
                future: Prefs.getPref(ACCESS_TOKEN),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return FutureBuilder(
                      future: Login.getUserInfo(snapshot.data.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var rolesJson = jsonDecode(snapshot.data.data.roles);

                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: Image.network(
                                  'https://i0.wp.com/s1.uphinh.org/2021/01/15/logo.png',
                                  height: 120,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  rolesJson['TEACHER'] == 1 &&
                                          rolesJson['PARENT'] == 1
                                      ? "Giáo viên + Phụ huynh"
                                      : rolesJson['TEACHER'] == 1
                                          ? "Giáo viên"
                                          : "Phụ huynh",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreen()),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 40,
                                              bottom: 40,
                                              left: 10,
                                              right: 10),
                                          child: Text(
                                            snapshot.data.data.fullName,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            border: Border.all(
                                              color: Colors.black12,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return NotificationScreen(
                                              topic: rolesJson['TEACHER'] ==
                                                          1 &&
                                                      rolesJson['PARENT'] == 1
                                                  ? "both"
                                                  : rolesJson['TEACHER'] == 1
                                                      ? "teacher"
                                                      : "parent",
                                            );
                                          }),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 40,
                                              bottom: 40,
                                              left: 10,
                                              right: 10),
                                          child: Text(
                                            'Thông báo (9)',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            border: Border.all(
                                              color: Colors.black12,
                                            ),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(20.0),
                              ),
                            ],
                          );
                        } else {
                          return Text('Loading...');
                        }
                      },
                    );
                  } else {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          print('Đăng xuất');
                          Prefs.deletePref();
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Splash()),
                            ModalRoute.withName('/'),
                          );
                        },
                        child: Text('Đăng Xuất - Default Screen Dashboard'),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
