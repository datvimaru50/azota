import 'package:azt/config/global.dart';
import 'package:azt/models/firebase_mo.dart';
import 'package:flutter/material.dart';
import 'package:azt/view/enter_code.dart';
import 'package:azt/view/login_screen.dart';
import 'package:azt/models/anonymous_use.dart';
import 'package:azt/controller/login_controller.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(MainHome());
}

// Gọi API login anonymous ngay tại màn hình này,
// để đăng ký một FirebaseMessage token chung
// cho ứng dụng trên device này. Bất kể người dùng
// đănng nhập với vai trò gì, thì đều có token để nhận thông báo

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}


class _MainHomeState extends State<MainHome> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<AnonymousUser> anonymousUser;


  @override
  void initState() {
    super.initState();
    anonymousUser = LoginController.loginAnonymous();


    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      // SavedToken.saveAnonymousToken(token);

      Prefs.savePrefs(FIREBASE_TOKEN, token);


      print('Init token: '+token);
    });

    _firebaseMessaging.onTokenRefresh.listen((token) {
      assert(token != null);
      // SavedToken.saveAnonymousToken(token);
      Prefs.savePrefs(FIREBASE_TOKEN, token);
      print('Refresh token: '+token);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      body: Center(
        child: FutureBuilder<AnonymousUser>(
          future: anonymousUser,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return FutureBuilder<SavedToken>(
                future: SavedToken.saveToken(snapshot.data.rememberToken),
                builder: (context, snapshot){
                  if(snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Image.network(
                            'https://i0.wp.com/s1.uphinh.org/2021/01/15/logo.png',
                            height: 120,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Bạn là?',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginForm()),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 40, bottom: 40, left: 20, right: 20),
                                    child: Text(
                                      'GIÁO VIÊN',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset:
                                          Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CodeForm()),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 40, bottom: 40, left: 20, right: 20),
                                    child: Text(
                                      'HỌC VIÊN',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset:
                                          Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20.0),
                        ),
                      ],
                    );
                  } else if(snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              );

            } else if(snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        )
      ),
    );
  }

}