import 'package:flutter/material.dart';
import 'package:azt/view/login_screen.dart';
import 'package:azt/view/register_screen.dart';

class CommonFile extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<CommonFile> {
  @override
  Widget build(BuildContext context) {
    return LoginForm();
  }
}
Widget goRegister(BuildContext context) {
  return RegisterScreen();
}
