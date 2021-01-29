import 'dart:ui';

import 'package:azt/view/notification/notificationStudent.dart';
import 'package:flutter/material.dart';
import 'package:azt/view/notification/notificationTeacher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({@required this.topic});
  final String topic;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map> notiArray = [];
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Widget build(BuildContext context) {
    List<Widget> notifSection =
        notiArray.length != 0 && widget.topic == 'teacher'
            ? <Widget>[
                ...notiArray
                    .map((Map item) => NotificationTeacherItem(
                          className: item['className'],
                          student: item['student'],
                          deadline: item['deadline'],
                          submitTime: item['submitTime'],
                          webUrl: item['webUrl'],
                        ))
                    .toList(),
              ]
            : notiArray.length != 0 && widget.topic == 'parent'
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
        title: Text('Thông báo'),
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
  // Future<void> handleNotificationData() async{
  //   if(Prefs.getPref('noti_'+widget.topic) == null){
  //     Prefs.savePrefs('noti_'+widget.topic, [].toString());
  //   } else {
  //     final dataNotif = await Prefs.getPref('noti_'+widget.topic);
  //     setState(() {
  //       notiArray = jsonDecode(dataNotif);
  //     });
  //   }
  // }

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

    // Subcribe to an Topic: teacher/parent/both

    _firebaseMessaging.subscribeToTopic(widget.topic);
  }
}
