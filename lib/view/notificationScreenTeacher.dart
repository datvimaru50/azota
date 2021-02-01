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
  List<Map> notiArray = [];
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<ListNotification> listNotification;

  @override
  void initState() {
    super.initState();
    listNotification = NotiController.getNoti(1);

    _firebaseMessaging.configure(
      onMessage: (message) async{
        setState(() {
          notiArray.insert(0, message["data"]);
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo giáo viên'),
      ),
      body: FutureBuilder<ListNotification>(
        future: listNotification,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(

              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.objs.length,
                        itemBuilder: (BuildContext context, int index){

                          return NotificationTeacherItem(
                              className: snapshot.data.objs.elementAt(index)['classroomName'],
                              student: snapshot.data.objs.elementAt(index)['studentName'],
                              deadline: snapshot.data.objs.elementAt(index)['deadline'],
                              submitTime: snapshot.data.objs.elementAt(index)['createdAt'],
                              webUrl: "https://tinhte.vn"
                          );
                        }

                    )
                ),

              ],
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
