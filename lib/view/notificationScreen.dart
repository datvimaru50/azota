import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:azt/view/notification/notificationStudent.dart';
import 'package:azt/view/notification/notificationTeacher.dart';
import 'package:azt/controller/notification_controller.dart';
import 'package:azt/models/firebase_mo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({@required this.role});

  final String role;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Iterable _notiArr = [];
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void fetchNoti() async {
    var result = widget.role == 'parent' ? await NotiController.getNotiAnonymous(1) : await NotiController.getNoti(1);
    setState(() {
      _notiArr = result.objs;
    });
  }

  Widget _buildList() {
    return _notiArr != null
        ? RefreshIndicator(
      child: Column(
        children: <Widget>[
          Expanded(child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount:  _notiArr.length,
              itemBuilder: (BuildContext context, int index) {
                return widget.role == 'parent' ? NotificationStudentItem(
                  className: _notiArr.elementAt(index)['classroomName'],
                  score: _notiArr.elementAt(index)['point'].toString(),
                  deadline: _notiArr.elementAt(index)['deadline'],
                  submitTime: _notiArr.elementAt(index)['createdAt'],
                  webUrl: 'https://tinhte.vn',
                ) : NotificationTeacherItem(
                  className: _notiArr.elementAt(index)['classroomName'],
                  student: _notiArr.elementAt(index)['studentName'],
                  deadline: _notiArr.elementAt(index)['deadline'],
                  submitTime: _notiArr.elementAt(index)['createdAt'],
                  webUrl: 'https://tinhte.vn',
                );
              }),)
        ],
      ),
      onRefresh: _getData,
    )
        : Center(child: CircularProgressIndicator());
  }

  Future<void> _getData() async {
    setState(() {
      fetchNoti();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNoti();
    _firebaseMessaging.configure(
      onMessage: (message) async{
        setState(() {
          // notiArray.toList().insert(0, message["data"]);
        });

      },

    );
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      if(widget.role == 'parent') {
        SavedToken.saveAnonymousToken(token);
      }
      if(widget.role == 'teacher') {
        SavedToken.saveToken(token);
      }

      print('Init token: '+token);
    });

    _firebaseMessaging.onTokenRefresh.listen((token) {
      assert(token != null);
      if(widget.role == 'parent') {
        SavedToken.saveAnonymousToken(token);
      }
      if(widget.role == 'teacher') {
        SavedToken.saveToken(token);
      }
      print('Refresh token: '+token);

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Thông báo'),
        ),
        body: _buildList()
    );
  }



}
