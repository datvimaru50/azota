import 'dart:convert';
import 'dart:ui';

import 'package:azt/view/notification/notificationStudent.dart';
import 'package:flutter/material.dart';
import 'package:azt/view/notification/notificationTeacher.dart';
import 'package:azt/controller/notification_controller.dart';
import 'package:azt/models/firebase_mo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:date_time_format/date_time_format.dart';

class NotificationScreenTeacher extends StatefulWidget {

  @override
  _NotificationScreenTeacherState createState() => _NotificationScreenTeacherState();
}

class _NotificationScreenTeacherState extends State<NotificationScreenTeacher> {
  Iterable notiArray = [];
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<ListNotification> listNotification;

  @override
  void initState() {
    super.initState();
    listNotification = NotiController.getNoti(1);

    _firebaseMessaging.configure(
      onMessage: (message) async{
        setState(() {
          notiArray.toList().insert(0, message["data"]);
        });

      },

    );
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      SavedToken.saveToken(token);
      print('Init token: '+token);
    });

    _firebaseMessaging.onTokenRefresh.listen((token) {
      assert(token != null);
      SavedToken.saveToken(token);
      print('Refresh token: '+token);

    });

  }

  @override
  Widget build(BuildContext context) {

    List<Widget> notifSection = notiArray.length != 0 ?

    <Widget>[
      ...notiArray.where((element) => element['type'] == 'NEW_ANSWER').toList().map(
              (item) => NotificationTeacherItem(
            className: item['classroomName'],
            student: item['studentName'],
            deadline: item['deadline'],
            submitTime: item['createdAt'],
            webUrl: 'https://tinhte.vn',
          )).toList(),
    ]:

    <Widget>[Text('Bạn không có thông báo nào', style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    )];

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo giáo viên'),
      ),
      body: FutureBuilder<ListNotification>(
        future: listNotification,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            notiArray = snapshot.data.objs;
            return Column(

              children: notifSection
            );

          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }



}
