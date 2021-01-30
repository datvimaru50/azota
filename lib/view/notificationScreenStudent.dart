import 'dart:ui';

import 'package:azt/view/notification/notificationStudent.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:azt/models/firebase_mo.dart';

class NotificationScreenStudent extends StatefulWidget {
  @override
  _NotificationScreenStudentState createState() =>
      _NotificationScreenStudentState();
}

class _NotificationScreenStudentState extends State<NotificationScreenStudent> {
  List<Map> notiArray = [];
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Widget build(BuildContext context) {
    List<Widget> notifSection = notiArray.length != 0
        ? <Widget>[
            ...notiArray
                .map((Map item) => NotificationStudentItem(
                      className: item['className'],
                      score: item['score'],
                      deadline: item['deadline'],
                      submitTime: item['submitTime'],
                      webUrl: item['webUrl'],
                    ))
                .toList(),
          ]
        : <Widget>[
            Text(
              'Bạn không có thông báo nào',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo phụ huynh'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 40, bottom: 30),
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: ListView(children: notifSection),
        ),
      ),
    );
  }
  //

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    // handleNotificationData();

    _firebaseMessaging.configure(
      onMessage: (message) async {
        setState(() {
          notiArray.insert(0, message["data"]);
        });
      },
    );

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      SavedToken.saveAnonymousToken(token);
      print('Init token: ' + token);
    });

    _firebaseMessaging.onTokenRefresh.listen((token) {
      assert(token != null);
      SavedToken.saveAnonymousToken(token);
      print('Refresh token: ' + token);
    });
  }
}
