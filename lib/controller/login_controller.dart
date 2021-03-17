import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:azt/models/authen.dart';


class LoginController extends ControllerMVC {
  factory LoginController() {
    if (_this == null) _this = LoginController._();
    return _this;
  }

  static LoginController _this;
  LoginController._();
  static LoginController get con => _this;

  /* **********************************
  Handle 4 different types of login
  ********************************** */
  static Future<User> login(String loginType, [Map<String, dynamic> params]) async {
    const headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };

    final String apiUrl = loginType == 'APPLE' ?
        AZO_AUTH_APPLE + '?code=${params['md5']}&email=${params['email']}'

        : loginType == 'ZALO' ?
        AZO_AUTH_ZALO + '?code=${params['code']}&isteacher=${params['role'].toString()}'

        : loginType == 'ANONYMOUS' ? AZO_LOGIN_ANONYMOUS

        : AZO_LOGIN;


    final response = loginType == 'NORMAL' ? await http.Client().post(
        apiUrl, body: jsonEncode(params), headers: headers)
        : await http.Client().get(apiUrl, headers: headers);

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);

        if (resBody['success'] == 1) {
          var userData = resBody['data'];
          User authUser = User.fromJson(userData);
          Prefs.savePrefs( loginType == 'ANONYMOUS' ? ANONYMOUS_TOKEN : ACCESS_TOKEN, authUser.rememberToken);
          Prefs.savePrefs( UPLOAD_TOKEN, authUser.uploadToken);
          return authUser;
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
}

