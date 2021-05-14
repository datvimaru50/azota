import 'dart:ui';
import 'dart:io';
import 'package:azt/models/core_mo.dart';
import 'package:azt/controller/homework_controller.dart';
import 'package:azt/controller/notification_controller.dart';
import 'package:azt/view/submit_homeworks/graded_exersice.dart';
import 'package:azt/view/submit_homeworks/history_submit.dart';
import 'package:azt/view/submit_homeworks/submit_exersice.dart';
import 'package:azt/view/submit_homeworks/submit_exersice_android.dart';
import 'package:flutter/material.dart';
import 'package:azt/store/notification_store.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SubmitForm extends StatefulWidget {
  @override
  _SubmitFormState createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  Future<ListNotification> notiData;
  Future<HomeworkHashIdInfo> homeworkHashIdInfo;
  // ignore: unused_field
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    notiData = Provider.of<NotiModel>(context, listen: false)
        .setTotal(accType: 'parent');
    homeworkHashIdInfo = HomeworkController.getHomeworkInfoAgain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text(
          'Nộp bài',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: FutureBuilder<HomeworkHashIdInfo>(
        future: homeworkHashIdInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: ListView(
                children: <Widget>[
                  Platform.isIOS
                      ? SubmitExersice(
                          homeworkObj: snapshot.data.homeworkObj,
                          studentObj: snapshot.data.studentObj,
                          classroomObj: snapshot.data.classroomObj,
                          answerObj: snapshot.data
                              .answerObj // Dùng để check trạng thái giáo viên đã chấm bài hay chưa
                          )
                      : SubmitExersiceAndroid(
                          homeworkObj: snapshot.data.homeworkObj,
                          studentObj: snapshot.data.studentObj,
                          classroomObj: snapshot.data.classroomObj,
                          answerObj: snapshot.data
                              .answerObj // Dùng để check trạng thái giáo viên đã chấm bài hay chưa
                          ),
                  GradedExersice(
                    answerObj: snapshot.data.answerObj,
                    homeworkObj: snapshot.data.homeworkObj,
                    studentObj: snapshot.data.studentObj,
                    classroomObj: snapshot.data.classroomObj,
                  ),
                  HistorySubmit(
                    homeworkObj: snapshot.data.homeworkObj,
                    answerHistoryObjs: snapshot.data.answerHistoryObjs,
                  ),
                ],
              ),
              // By default, show a loading spinner.
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
