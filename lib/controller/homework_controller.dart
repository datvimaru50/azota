import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:azt/models/core_mo.dart';
import 'package:azt/controller/login_controller.dart';

class HomeworkController extends ControllerMVC {
  factory HomeworkController() {
    if (_this == null) _this = HomeworkController._();
    return _this;
  }

  static HomeworkController _this;
  HomeworkController._();
  static HomeworkController get con => _this;

  /* **********************************
  Get homework info from hashId
  <first time to choose student>
  ********************************** */
  static Future<HomeworkHashIdInfo> getHomeworkInfo(String hashId) async {
    final authUser = await LoginController.login('ANONYMOUS');

    final response =
        await http.Client().get(AZO_HOMEWORK_INFO + '?id=' + hashId, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + authUser.rememberToken
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return HomeworkHashIdInfo.fromJson(resBody['data']);
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
  Get homework info from hashId
  <after update parent>
  ********************************** */
  static Future<HomeworkHashIdInfo> getHomeworkInfoAgain() async {
    final token = await Prefs.getPref(ANONYMOUS_TOKEN);
    final hashId = await Prefs.getPref(HASH_ID);
    final response =
    await http.Client().get(AZO_HOMEWORK_INFO + '?id=' + hashId, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return HomeworkHashIdInfo.fromJson(resBody['data']);
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
  Update parent for student in class
  ********************************** */
  static Future<String> updateParent(String studentId) async {
    final String token = await Prefs.getPref(ANONYMOUS_TOKEN);
    final response = await http.Client()
        .get(AZO_UPDATE_PARENT + '?id=' + studentId, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return SUCCESS_UPDATE_PARENT;
        } else {
          throw ERR_UPDATE_PARENT;
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
