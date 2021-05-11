import 'package:azt/config/global.dart';
import 'package:azt/controller/homework_controller.dart';
import 'package:azt/models/core_mo.dart';
import 'package:azt/view/groupScreenStudent.dart';
import 'package:azt/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(UserProfileStudent());
}

class UserProfileStudent extends StatefulWidget {
  @override
  _UserProfileStudentState createState() => _UserProfileStudentState();
}

class _UserProfileStudentState extends State<UserProfileStudent> {
  Future<HomeworkHashIdInfo> homeworkHashIdInfo;
  var accessToken;
  @override
  void initState() {
    super.initState();
    homeworkHashIdInfo = HomeworkController.getHomeworkInfoAgain();
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => GroupScreenStudent(),
        ),
        (Route<dynamic> route) => false);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        body: FutureBuilder<HomeworkHashIdInfo>(
          future: homeworkHashIdInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              offset: Offset(0, 0))
                        ]),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 26,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "https://tryhsk.com/img/default_avatar.6aadcee8.png",
                                              scale: 4.0))),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  snapshot.data.studentObj['fullName'],
                                  style: TextStyle(
                                      color: Color(0xff17A2B8),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 25),
                    margin: EdgeInsets.only(bottom: 20),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: 30,
                          color: Color(0xff17A2B8),
                        ),
                        Container(
                          child: Text(
                            snapshot.data.studentObj['fullName'],
                            style:
                                TextStyle(fontSize: 18, color: Colors.black45),
                          ),
                          margin: EdgeInsets.only(left: 30),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.5, color: Colors.black12),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 20),
                  ),
                  Container(
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.venusMars,
                          size: 26,
                          color: Color(0xff17A2B8),
                        ),
                        Container(
                          child: Text(
                            snapshot.data.studentObj['gender'] == 0
                                ? 'Nữ'
                                : 'Nam',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black45),
                          ),
                          margin: EdgeInsets.only(left: 30),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.5, color: Colors.black12),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 20),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 30,
                          color: Color(0xff17A2B8),
                        ),
                        Container(
                          child: Text(
                            snapshot.data.studentObj['birthday'] == null
                                ? 'Bạn chưa thêm ngày sinh'
                                : DateFormat.yMd().format(DateTime.parse(
                                    snapshot.data.studentObj['birthday'])),
                            style:
                                TextStyle(fontSize: 18, color: Colors.black45),
                          ),
                          margin: EdgeInsets.only(left: 30),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.5, color: Colors.black12),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 20),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone_iphone,
                          size: 30,
                          color: Color(0xff17A2B8),
                        ),
                        Container(
                          child: Text(
                            'Bạn chưa có số điện thoại',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black45),
                          ),
                          margin: EdgeInsets.only(left: 30),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.5, color: Colors.black12),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 20),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 30,
                          color: Color(0xff17A2B8),
                        ),
                        Container(
                          child: Text(
                            'Bạn chưa có email',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black45),
                          ),
                          margin: EdgeInsets.only(left: 30),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.5, color: Colors.black12),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 20),
                  ),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff17A2B8),
                      ),
                      child: Text(
                        'Đăng xuất',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () {
                        showAnimatedDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return ClassicGeneralDialogWidget(
                              titleText: 'Bạn có chắc chắn',
                              actions: [
                                // ignore: deprecated_member_use
                                ElevatedButton.icon(
                                    //ElevatedButton.icon(onPressed: onPressed, icon: icon, label: label),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    icon: Icon(Icons.logout),
                                    label: Text('Đăng Xuất'),
                                    onPressed: () {
                                      Prefs.deletePref();
                                      // _firebaseMessaging.deleteInstanceID();
                                      Navigator.pop(context);
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Splash()),
                                        ModalRoute.withName('/'),
                                      );
                                    }),
                                // ignore: deprecated_member_use
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Hủy'),
                                  color: Colors.black38,
                                )
                              ],
                            );
                          },
                          animationType: DialogTransitionType.size,
                          curve: Curves.fastOutSlowIn,
                          duration: Duration(seconds: 1),
                        );
                      },
                    ),
                    margin: EdgeInsets.all(20),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(20),
                child: Text('Kiểm tra lại kết nối'),
              );
            }
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
