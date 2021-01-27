import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:azt/view/notificationScreen.dart';
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
  static Future<int> loginGetAccessToken(Map<String, dynamic> params) async{
    try{
      var auth = await Login.normalLogin(params);
      print(auth.toString());
      if(auth.success == 1){
        Prefs.savePrefs(ACCESS_TOKEN, auth.data.rememberToken);
        print(auth.data.rememberToken);
        return 1;
      } else {
        return 0;
      }

    } catch (err) {
      return throw Fluttertoast.showToast(
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
  static requestZaloLogin(){

  }

  // Login with Apple ID
  static requestAppleLogin(){

  }
}