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
  static LoginController get con => _this;

  /* *****************************************
  Normal login with phone number and password
  ***************************************** */
  static Future<String> loginGetAccessToken(Map<String, dynamic> params) async {

    final response = await http.Client().post(AZO_LOGIN,
        body: jsonEncode(params),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
        });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);

        if (resBody['success'] == 1) {
          var userData = resBody['data'];
          User authUser = User.fromJson(userData);
          Prefs.savePrefs(ACCESS_TOKEN, authUser.rememberToken);
          return SUCCESS_LOGIN;
        } else {
          throw ERR_INVALID_LOGIN_INFO;
        }
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }
  }


  /* **********************************
  Call API to get user information
  ********************************** */
  static Future<User> getUserInfo() async {
    final String token = await Prefs.getPref(ACCESS_TOKEN);

    final response = await http.Client().get(AZO_AUTH_INFO, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + token
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> resBody = json.decode(response.body);
      var userData = resBody['data'];
      User authUser = User.fromJson(userData);

      return authUser;
    } else {
      return throw 'Có lỗi xảy ra';
    }
  }



  /* **********************************
  Sign in anonymous
  ********************************** */
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



  /* **********************************
  Sign in with Zalo SDK
  ********************************** */
  static Future<String> loginZalo(String code, int role) async {

    final response = await http.Client().get(
        AZO_AUTH_ZALO + '?code=' + code + '&isteacher=' + role.toString(),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
        });
    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);

        if (resBody['success'] == 1) {
          var userData = resBody['data'];
          UserZalo authUser = UserZalo.fromJson(userData);
          Prefs.savePrefs(ACCESS_TOKEN, authUser.rememberToken);
          return SUCCESS_LOGIN;
        } else {
          throw ERR_INVALID_LOGIN_INFO;
        }
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }

  }

  static Future<String> registerWithApple( String md5, String email) async {
    final response = await http.Client()
        .get(AZO_AUTH_APPLE + '?code=$md5&email=$email', headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);

        if (resBody['success'] == 1) {
          var userData = resBody['data'];
          UserZalo authUser = UserZalo.fromJson(userData);
          Prefs.savePrefs(ACCESS_TOKEN, authUser.rememberToken);
          return SUCCESS_LOGIN;
        } else {
          throw ERR_INVALID_LOGIN_INFO;
        }
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }
  }
}
