import 'package:flutter/material.dart';

void main() {
  runApp(NewSplash());
}

class NewSplash extends StatefulWidget {
  @override
  _NewSplashState createState() => _NewSplashState();
}

class _NewSplashState extends State<NewSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 0),
            ),
            Column(
              children: [
                Image(
                  image: AssetImage('assets/icon_app_512.png'),
                  height: 170,
                ),
                Image(
                  image: AssetImage('assets/azota-logo-text.png'),
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 80, left: 80, top: 20),
                  child: Text(
                    'Một cách thật đơn giản để',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 0),
                  child: Text(
                    'giao bài tập',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            CircularProgressIndicator(),
            Container(
              child: Column(
                children: [
                  Text('Phiên bản: 1.0'),
                  Padding(
                    padding: EdgeInsets.only(left: 40, right: 40, top: 10),
                    child: Text(
                      'Được phát triển bởi GET.jsc',
                      textAlign: TextAlign.center,
                    ),
                  )
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
