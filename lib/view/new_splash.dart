import 'package:azt/view/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(new MaterialApp(
    home: new NewSplash(),
  ));
}

class NewSplash extends StatefulWidget {
  @override
  _NewSplashState createState() => new _NewSplashState();
}

class _NewSplashState extends State<NewSplash> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new Splash(),
      title: new Text(
        'Một cách thật đơn giản để \ngiao bài tập.',
        style: TextStyle(fontSize: 16, color: Colors.black45),
        textAlign: TextAlign.center,
      ),
      image: Image(
        image: AssetImage('assets/splashscreen.png'),
        color: Color(0xFF42C0B6),
      ),
      backgroundColor: Color(0xFFecf0f5),
      photoSize: 90.0,
      onClick: () => print("Flutter Egypt"),
      loaderColor: Colors.redAccent,
      loadingText: Text(
        '\n'
        'Phiên bản: 1.0'
        '\n'
        'Được phát triển bởi GET.jsc',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black38),
      ),
    );
  }
}
