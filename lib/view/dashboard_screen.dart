import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:azt/view/profile_screen.dart';
import 'package:azt/view/notificationScreenTeacher.dart';
import 'package:azt/view/notificationScreenStudent.dart';


class Dashboard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      body: Center(
        child: Column(
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
                'Trang quản trị, thống kê',
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
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 40, bottom: 40, left: 20, right: 20),
                        child: Text(
                          'Cá nhân',
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
                            builder: (context) {
                              var type = 1; // tài khoản giáo viên
                              if(type == 1){
                                return NotificationScreenTeacher();
                              } else {
                                return NotificationScreenStudent();
                              }

                            }),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 40, bottom: 40, left: 20, right: 20),
                        child: Text(
                          'Thông báo (10)',
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
        ),
      ),
    );
  }
}
