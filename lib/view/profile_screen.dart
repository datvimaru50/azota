import 'package:flutter/material.dart';
import 'package:azt/config/global.dart';
import 'package:azt/view/splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0089a7),
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // print('Đăng xuất');
            Prefs.deletePref();
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => Splash()),
              ModalRoute.withName('/'),
            );
          },
          child: Text('Đăng Xuất'),
        ),
      ),
    );
  }
}
