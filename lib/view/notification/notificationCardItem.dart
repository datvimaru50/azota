import 'package:flutter/material.dart';
import 'notificationStudent.dart';
import 'notificationTeacher.dart';

class NotificationCardItem extends StatelessWidget {
  NotificationCardItem({@required this.notifItem});
  final Map<String, dynamic> notifItem;

  @override
  Widget build(BuildContext context) {
    return notifItem['type'] == 'NEW_ANSWER'?
      NotificationTeacherItem(notificationItem: notifItem) :
      NotificationStudentItem(notificationItem: notifItem);
  }
}


