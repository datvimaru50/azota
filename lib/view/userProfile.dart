import 'package:azt/config/global.dart';
import 'package:azt/controller/login_controller.dart';
import 'package:azt/models/authen.dart';
import 'package:azt/models/firebase_mo.dart';
import 'package:azt/view/groupScreenTeacher.dart';
import 'package:azt/view/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

void main() {
  runApp(UserProfile());
}

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Future<User> getUserInfo;
  var accessToken;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    getUserInfo = LoginController.getUserInfo();
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => GroupScreenTeacher(),
        ),
        (Route<dynamic> route) => false);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        body: FutureBuilder<User>(
          future: getUserInfo,
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
                                  snapshot.data.fullName,
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
                            snapshot.data.fullName,
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
                            snapshot.data.birthday == null
                                ? 'Bạn chưa thêm ngày sinh'
                                : snapshot.data.birthday,
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
                            snapshot.data.phone,
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
                            snapshot.data.email == null
                                ? 'Bạn chưa có email'
                                : snapshot.data.email,
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
                                FlatButton(
                                  onPressed: () {
                                    SavedToken.deleteToken(accessToken);
                                    Prefs.deletePref();
                                    _firebaseMessaging.deleteInstanceID();
                                    Navigator.pop(context);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Splash()),
                                      ModalRoute.withName('/'),
                                    );
                                  },
                                  child: Text('Đăng xuất'),
                                  color: Colors.red,
                                ),
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
