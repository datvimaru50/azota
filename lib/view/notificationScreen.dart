import 'dart:ui';

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

    List<Widget> notifSection = notiArray.length != 0 ? <Widget>[
      ...notiArray.map(
              (Map item) => NotificationTeacherItem(
            className: item['className'],
            student: item['student'],
            deadline: item['deadline'],
            submitTime: item['submitTime'],
            webUrl: item['webUrl'],
          )).toList(),
    ]:
        <Widget>[Text('Bạn không có thông báo nào', style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        )];

    return Scaffold(
        appBar: AppBar(
          title: Text('Thông báo'),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 40, bottom: 30),
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: ListView(
                children: notifSection
            ),
          ),
        ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (message) async{
        setState(() {
          notiArray.insert(0, message["data"]);
        });

      },

    );

    // Subcribe to an Topic: teacher/parent/both

    _firebaseMessaging.subscribeToTopic(widget.topic);

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print(token);
    });


  }

}
