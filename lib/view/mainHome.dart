import 'package:flutter/material.dart';
import 'package:azt/view/enter_code.dart';
import 'package:azt/view/login_screen.dart';

void main() {
  runApp(MainHome());
}

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // FlatButton.icon(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => WebViewExample()),
            //     );
            //   },
            //   icon: Icon(Icons.ac_unit),
            //   label: Text('fasfs'),
            // ),
            Padding(
              padding: EdgeInsets.only(right: 0),
              child: Image(
                image: AssetImage('assets/logo.png'),
                height: 90,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // ignore: deprecated_member_use
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
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      padding: EdgeInsets.only(
                          top: 40, bottom: 40, left: 20, right: 20),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CodeForm()),
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
