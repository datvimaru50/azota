import 'package:azt/view/login_screen.dart';
import 'package:azt/view/register_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainHome());
}

class MainHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text('Trang Chủ'),
      ),
      body: Center(
        child: Column(
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
                  Container(
                    child: FlatButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      padding: EdgeInsets.only(
                          top: 40, bottom: 40, left: 20, right: 20),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginForm()),
                        );
                      },
                      child: Text(
                        "GIÁO VIÊN",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    child: FlatButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      padding: EdgeInsets.only(
                          top: 40, bottom: 40, left: 20, right: 20),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        "HỌC VIÊN",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.black12,
                      ),
                      color: Colors.white,
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
