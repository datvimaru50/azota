import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:azt/view/notification/notificationStudent.dart';

class NotificationScreenStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 40, bottom: 30),
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Thông báo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
          NotificationStudent(),
        ],
      ),
    );
  }
}
