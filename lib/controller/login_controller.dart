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
import 'package:azt/models/anonymous_use.dart';

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
  static Future<Map<String, dynamic>> loginGetAccessToken(Map<String, dynamic> params) async{

    var result;

    final response = await http.Client().post(AZO_LOGIN, body: jsonEncode(params), headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    });

    if(response.statusCode == 200){
      final Map<String, dynamic> resBody = json.decode(response.body);

      var userData = resBody['data'];

      User authUser = User.fromJson(userData);

      Prefs.savePrefs(ACCESS_TOKEN, authUser.rememberToken);

      result = {'status': true, 'message': 'successful', 'user': authUser};

    } else {
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
      return result;
    }

    // try{
    //   var auth = await Login.normalLogin(params);
    //   print(auth.toString());
    //   if(auth.success == 1){
    //     return 1;
    //   } else {
    //     return 0;
    //   }
    //
    // } catch (err) {
    //   return throw Fluttertoast.showToast(
    //       msg: 'Sai thông tin đăng nhập!',
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIos: 1,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }

  }

  static Future<User> getUserInfo(String token) async {

    final response = await http.Client().get(AZO_AUTH_INFO, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer "+token
    });

    if(response.statusCode == 200){
      final Map<String, dynamic> resBody = json.decode(response.body);
      var userData = resBody['data'];
      User authUser = User.fromJson(userData);

      return authUser;
    } else {
      return throw 'Có lỗi xảy ra';
    }

  }


  static Future<AnonymousUser> loginAnonymous() async{
    final response = await http.Client().get(AZO_LOGIN_ANONYMOUS, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    });

    if(response.statusCode == 200){
      final responseBody = json.decode(response.body);
      return AnonymousUser.fromJson(responseBody['data']);
    } else {
      return throw 'Có lỗi xảy ra';
    }
  }
}