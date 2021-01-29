import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:azt/models/authen.dart';

// Login controller, handle different type of logins
class LoginController extends ControllerMVC {
  factory LoginController() {
    if (_this == null) _this = LoginController._();
    return _this;
  }

  static LoginController _this;

  LoginController._();

  /// Allow for easy access to 'the Controller' throughout the application.
  static LoginController get con => _this;

  // Normal login with phone number and password
  // ignore: missing_return
  static Future loginGetAccessToken(Map<String, dynamic> params) async {
    try {
      var auth = await Login.normalLogin(params);
      print(auth.toString());
      if (auth.success == 1) {
        return 1;
      } else {
        return 0;
      }
    } catch (err) {
      return Fluttertoast.showToast(
          msg: 'Sai thông tin đăng nhập!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  // Login with Zalo token
  static requestZaloLogin() {}

  // Login with Apple ID
  static requestAppleLogin() {}
}
