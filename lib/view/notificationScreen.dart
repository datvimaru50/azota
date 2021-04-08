import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:azt/view/notification/notificationStudent.dart';
import 'package:azt/view/notification/notificationTeacher.dart';
import 'package:azt/controller/notification_controller.dart';
import 'package:azt/models/firebase_mo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:azt/config/global.dart';
import 'package:azt/config/connect.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({@required this.role});

  final String role;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  Iterable _notiArr = [];
  var baseAccess;
  var accessToken;
  bool doneLoading = false;
  var currentVerion = '';
  var latestVerion = '';
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // ignore: unused_field
  AppLifecycleState _notification;

  void fetchNoti() async {
    var result = widget.role == 'parent'
        ? await NotiController.getNotiAnonymous(1)
        : await NotiController.getNoti(1);
    setState(() {
      doneLoading = true;
      _notiArr = result.objs;
    });
  }

  void setBaseAccess() async {
    var token = widget.role == 'parent'
        ? await Prefs.getPref(ANONYMOUS_TOKEN)
        : await Prefs.getPref(ACCESS_TOKEN);
    setState(() {
      accessToken = token;
      baseAccess =
          '$AZT_DOMAIN_NAME/en/auth/login?access_token=$token&return_url=';
    });

    print('accesstoken::: ' + token);
  }

  Future<void> _showUpdateDialog(
      String dialogTitle, String dialogDesc, String storeUrl) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(dialogDesc),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Để sau'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Cập nhật',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.pop(context);
                launch(storeUrl);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildList() {
    return doneLoading == false ?
        Center(child: CircularProgressIndicator()) :
        _notiArr.length != 0 ?
        RefreshIndicator(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: _notiArr.length,
                      itemBuilder: (BuildContext context, int index) {
                        return widget.role == 'parent'
                            ? NotificationStudentItem(
                                notiType: _notiArr.elementAt(index)['type'],
                                className:
                                    _notiArr.elementAt(index)['classroomName'],
                                score: _notiArr
                                    .elementAt(index)['point']
                                    .toString(),
                                deadline: _notiArr.elementAt(index)['deadline'],
                                submitTime:
                                    _notiArr.elementAt(index)['createdAt'],
                                token: accessToken,
                                answerId: _notiArr
                                    .elementAt(index)['answerId']
                                    .toString(),
                              )
                            : NotificationTeacherItem(
                                noticeId: _notiArr.elementAt(index)['id'],
                                read:  _notiArr.elementAt(index)['readAt'] != null ? true : false,
                                className:
                                    _notiArr.elementAt(index)['classroomName'],
                                student:
                                    _notiArr.elementAt(index)['studentName'],
                                deadline: _notiArr.elementAt(index)['deadline'],
                                submitTime:
                                    _notiArr.elementAt(index)['createdAt'],
                                webUrl:
                                    '$baseAccess/en/admin/mark-exercise/${_notiArr.elementAt(index)['answerId']}',
                              );
                      }),
                )
              ],
            ),
            onRefresh: _getData,
          )
        : Center(child: Text('Bạn không có thông báo nào!', style: TextStyle(fontSize: 16),));
  }

  Future<void> _getData() async {
    setState(() {
      fetchNoti();
    });
  }

  // Future<void> _checkNewVersion() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   NewVersionInfo newVersionInfo = await UpdateController.getNewVersionInfo();
  //   if(packageInfo.version != newVersionInfo.version){
  //     _showUpdateDialog(newVersionInfo.description);
  //   }
  // }

  _checkUpdateNoticeType(dynamic message) {
    final String type =
        Platform.isAndroid ? message['data']['type'] : message['type'];
    final String title =
        Platform.isAndroid ? message['data']['title'] : message['title'];
    final String body =
        Platform.isAndroid ? message['data']['body'] : message['body'];
    final String storeUrl =
        Platform.isAndroid ? message['data']['storeUrl'] : message['storeUrl'];
    if (type == 'update') {
      _showUpdateDialog(title, body, storeUrl);
    }
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
    // _checkNewVersion();
    WidgetsBinding.instance.addObserver(this);
    fetchNoti();
    setBaseAccess();

    _firebaseMessaging.configure(
      onMessage: (message) async {
        _getData();
        print("onMessage: $message");
        _checkUpdateNoticeType(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _checkUpdateNoticeType(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _checkUpdateNoticeType(message);
      },
      onBackgroundMessage:
          Platform.isAndroid ? myBackgroundMessageHandler : null,
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      print('type_acc::::: ' + widget.role);
      assert(token != null);
      if (widget.role == 'parent') {
        SavedToken.saveAnonymousToken(token);
        print('FCManonymous::: ' + token);
      }
      if (widget.role == 'teacher') {
        SavedToken.saveToken(token);
        print('FCM::' + token);
      }
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

  // TOP-LEVEL or STATIC function to handle background messages
  // ignore: missing_return
  static Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
    print('AppPushs myBackgroundMessageHandler : $message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.role == 'teacher' ? 'Thông báo' : 'Thông báo phụ huynh',
              style: TextStyle(fontSize: 18),
            ),
            _notiArr.length != 0 ?
            IconButton(
                icon: Icon(Icons.delete_forever_outlined),
              onPressed: () {
                showAnimatedDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return ClassicGeneralDialogWidget(
                      actions: [
                        Container(
                          width: 300,
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () async{
                                  await NotiController.markAllAsRead();
                                  await _getData();
                                },
                                child: Container(
                                  // color: Colors.black,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Đánh dấu tất cả là đã đọc',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async{
                                  await NotiController.deleteAllNotif();
                                  await _getData();
                                },
                                child: Container(
                                  // color: Colors.black,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Xóa tất cả thông báo',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                  animationType: DialogTransitionType.size,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 1),
                );
              },
            ) : Container()
          ],
        ),
      ),
      body: _buildList(),
    );
  }
}
