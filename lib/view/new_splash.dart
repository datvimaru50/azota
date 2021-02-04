import 'package:azt/view/mainHome.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// void main() {
//   runApp(NewSplash());
// }

// class NewSplash extends StatefulWidget {
//   @override
//   _NewSplashState createState() => _NewSplashState();
// }

// class _NewSplashState extends State<NewSplash> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFecf0f5),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.only(top: 0),
//             ),
// Column(
//   children: [
// Image(
//   image: AssetImage('assets/icon_app_512.png'),
//   height: 100,
//   color: Color(0xFF42C0B6),
// ),
//     Image(
//       image: AssetImage('assets/azota-logo-text.png'),
//       height: 70,
//     ),
//     Padding(
//       padding: EdgeInsets.only(right: 80, left: 80, top: 20),
//       child: Text(
//         'Một cách thật đơn giản để',
//         style: TextStyle(fontSize: 16),
//       ),
//     ),
//     Padding(
//       padding: EdgeInsets.only(right: 0),
//       child: Text(
//         'giao bài tập',
//         style: TextStyle(fontSize: 16),
//       ),
//     ),
//   ],
// ),
//             SizedBox(
//               height: 70,
//               child: LoadingIndicator(
//                 indicatorType: Indicator.ballClipRotatePulse,
//                 color: Color(0xFF42C0B6),
//               ),
//             ),
//             Container(
//               child: Column(
//                 children: [
//                   Text('Phiên bản: 1.0'),
//                   Padding(
//                     padding: EdgeInsets.only(left: 40, right: 40, top: 10),
//                     child: Text(
//                       'Được phát triển bởi GET.jsc',
//                       textAlign: TextAlign.center,
//                     ),
//                   )
//                 ],
//               ),
//               padding: const EdgeInsets.all(20.0),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
      // navigateAfterSeconds: new MainHome(),
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
        '\n'
        '\n'
        '\n'
        '\n'
        '\n'
        '\n'
        '\n'
        '\n'
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
