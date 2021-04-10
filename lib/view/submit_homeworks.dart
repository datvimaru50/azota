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
import 'package:azt/config/global.dart';
import 'package:azt/view/splash_screen.dart';
import 'package:azt/view/notificationScreen.dart';
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
    notiData = Provider.of<NotiModel>(context, listen: false).setTotal(accType: 'parent');
    homeworkHashIdInfo = HomeworkController.getHomeworkInfoAgain();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng xuất'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có thực sự muốn thoát ứng dụng?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Prefs.deletePref();
                // _firebaseMessaging.deleteInstanceID();
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Splash()),
                  ModalRoute.withName('/'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nộp bài'),
            GestureDetector(
              child: Container(
                width: 30,
                height: 30,
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 30,
                    ),
                    FutureBuilder<ListNotification>(
                        future: notiData,
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            return Consumer<NotiModel>(
                              builder: (context, noti, child){
                                return noti.totalUnread == 0? Container(width: 0, height: 0,) : Container(
                                  width: 30,
                                  height: 30,
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffc32c37),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Center(
                                        child: Text(
                                          '${noti.totalUnread}',
                                          style: TextStyle(fontSize: 10, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if(snapshot.hasError){
                            return Container(width: 0, height: 0,);
                          }
                          return Container(width: 0, height: 0,);
                        }
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(
                      role: 'parent',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<HomeworkHashIdInfo>(
        future: homeworkHashIdInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: ListView(
                children: <Widget>[
                  // Text(snapshot.data.answerHistoryObjs.toString()),
                  Platform.isIOS ? SubmitExersice(
                      homeworkObj: snapshot.data.homeworkObj,
                      studentObj: snapshot.data.studentObj,
                      classroomObj: snapshot.data.classroomObj,
                      answerObj: snapshot.data
                          .answerObj // Dùng để check trạng thái giáo viên đã chấm bài hay chưa
                  ) :
                  SubmitExersiceAndroid(
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton.icon(
                        //ElevatedButton.icon(onPressed: onPressed, icon: icon, label: label),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        icon: Icon(Icons.logout),
                        label: Text('Đăng Xuất'),
                        onPressed: _showMyDialog),
                  )
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
