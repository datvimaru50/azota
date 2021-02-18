import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:azt/models/authen.dart';
import 'package:azt/models/anonymous_use.dart';
import 'package:azt/models/zalo_mo.dart';

// Login controller, handle different type of logins
enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

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
  static Future<Map<String, dynamic>> loginGetAccessToken(
      Map<String, dynamic> params) async {
    var result;

    final response = await http.Client().post(AZO_LOGIN,
        body: jsonEncode(params),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> resBody = json.decode(response.body);

      var userData = resBody['data'];

      User authUser = User.fromJson(userData);

      Prefs.savePrefs(ACCESS_TOKEN, authUser.rememberToken);

      result = {'status': true, 'message': 'successful', 'user': authUser};
    } else {
      result = {'status': false, 'message': "Login failed"};
      return result;
    }
  }

  static Future<User> getUserInfo() async {
    final String token = await Prefs.getPref(ACCESS_TOKEN);

    final response = await http.Client().get(AZO_AUTH_INFO, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + token
    });

    // ???? CÁCH NÀY VÌ SAO K ĐC
    //
    // var response = await Prefs.getPref(ACCESS_TOKEN).then((value) => {
    //   http.Client().get(AZO_AUTH_INFO, headers: {
    //     HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    //     HttpHeaders.authorizationHeader: "Bearer "+value
    //   })
    // });

    if (response.statusCode == 200) {
      final Map<String, dynamic> resBody = json.decode(response.body);
      var userData = resBody['data'];
      User authUser = User.fromJson(userData);

      return authUser;
    } else {
      return throw 'Có lỗi xảy ra';
    }
  }

  static Future<AnonymousUser> loginAnonymous() async {
    final response = await http.Client().get(AZO_LOGIN_ANONYMOUS, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      var anonymousInfo = responseBody['data'];
      Prefs.savePrefs(ANONYMOUS_TOKEN, anonymousInfo['rememberToken']);
      return AnonymousUser.fromJson(anonymousInfo);
    } else {
      return throw 'Có lỗi xảy ra';
    }
  }

  static Future<UserZalo> loginZalo(String code, int role) async {
    final response = await http.Client().get(AZO_AUTH_ZALO + '?code=' + code + '&isTeacher=' + role.toString(), headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    });

    if (response.statusCode == 200) {
      print('Gọi api thanh cong:::::>>>>');
      final responseBody = json.decode(response.body);
      var zaloInfo = responseBody['data'];
      Prefs.savePrefs(ACCESS_TOKEN, zaloInfo['rememberToken']);
      return UserZalo.fromJson(zaloInfo);
    } else {
      print('Gọi api KHONG THÀNH CÔNG:::::>>>>');
      return throw 'Có lỗi xảy ra';
    }
  }
}
