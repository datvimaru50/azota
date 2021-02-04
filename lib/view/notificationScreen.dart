import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:azt/view/notification/notificationStudent.dart';
import 'package:azt/view/notification/notificationTeacher.dart';
import 'package:azt/controller/notification_controller.dart';
import 'package:azt/models/firebase_mo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:azt/config/global.dart';
import 'package:azt/view/splash_screen.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({@required this.role});

  final String role;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  Iterable _notiArr = [];
  var accessToken;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // ignore: unused_field
  AppLifecycleState _notification;

  void fetchNoti() async {
    var result = widget.role == 'parent'
        ? await NotiController.getNotiAnonymous(1)
        : await NotiController.getNoti(1);
    setState(() {
      _notiArr = result.objs;
    });
  }

  void getAccessToken() async {
    var token = widget.role == 'parent'
        ? await Prefs.getPref(ANONYMOUS_TOKEN)
        : await Prefs.getPref(ACCESS_TOKEN);
    setState(() {
      accessToken = token;
    });

    print('accesstoken::: '+accessToken);
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
                SavedToken.deleteToken(accessToken);
                Prefs.deletePref();
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

  Widget _buildList() {
    return _notiArr.length != 0
        ? RefreshIndicator(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: _notiArr.length,
                      itemBuilder: (BuildContext context, int index) {
                        return widget.role == 'parent'
                            ? NotificationStudentItem(
                                className:
                                    _notiArr.elementAt(index)['classroomName'],
                                score: _notiArr
                                    .elementAt(index)['point']
                                    .toString(),
                                deadline: _notiArr.elementAt(index)['deadline'],
                                submitTime:
                                    _notiArr.elementAt(index)['createdAt'],
                                webUrl:
                                    'https://azota.vn/en/auth/login?access_token=$accessToken&return_url=/en/xem-bai-tap/${_notiArr.elementAt(index)['answerId']}',
                              )
                            : NotificationTeacherItem(
                                className:
                                    _notiArr.elementAt(index)['classroomName'],
                                student:
                                    _notiArr.elementAt(index)['studentName'],
                                deadline: _notiArr.elementAt(index)['deadline'],
                                submitTime:
                                    _notiArr.elementAt(index)['createdAt'],
                                webUrl:
                                    'https://azota.vn/en/auth/login?access_token=$accessToken&return_url=/en/admin/mark-exercise/${_notiArr.elementAt(index)['answerId']}',
                              );
                      }),
                )
              ],
            ),
            onRefresh: _getData,
          )
        : Center(
            child: Text(
            'Bạn không có thông báo nào!',
            style: TextStyle(fontSize: 18),
          ));
  }

  Future<void> _getData() async {
    setState(() {
      fetchNoti();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == 0) {
      _getData();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchNoti();
    getAccessToken();
    _firebaseMessaging.configure(
      onMessage: (message) async {
        _getData();
      },
    );
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      if (widget.role == 'parent') {
        SavedToken.saveAnonymousToken(token);
      }
      if (widget.role == 'teacher') {
        SavedToken.saveToken(token);
      }

      // print('Init token: ' + token);
    });

    _firebaseMessaging.onTokenRefresh.listen((token) {
      assert(token != null);
      if (widget.role == 'parent') {
        SavedToken.saveAnonymousToken(token);
      }
      if (widget.role == 'teacher') {
        SavedToken.saveToken(token);
      }
      // print('Refresh token: ' + token);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.role == 'teacher' ? 'Thông báo giáo viên' : 'Thông báo phụ huynh'),
              GestureDetector(
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onTap: () {
                  _showMyDialog();
                },
              ),
            ],
          ),
        ),
        body: _buildList());
  }
}
