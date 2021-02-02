import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ListNotification {
  Iterable objs;
  ListNotification({this.objs});
  factory ListNotification.fromJson(Map<String, dynamic> json) =>
      ListNotification(
        objs: json["objs"],
      );
}

class NotiController extends ControllerMVC {
  factory NotiController() {
    if (_this == null) _this = NotiController._();
    return _this;
  }

  static NotiController _this;

  NotiController._();

  static NotiController get con => _this;

  static Future<ListNotification> getNoti(int page) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);

    final response = await http.Client()
        .get(AZO_GET_NOTIF + '?page=' + page.toString(), headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + token
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return ListNotification.fromJson(responseBody['data']);
    } else {
      return throw 'Có lỗi xảy ra';
    }
  }

  static Future<ListNotification> getNotiAnonymous(int page) async {
    final anonymousToken = await Prefs.getPref(ANONYMOUS_TOKEN);

    final response = await http.Client()
        .get(AZO_GET_NOTIF + '?page=' + page.toString(), headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + anonymousToken
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return ListNotification.fromJson(responseBody['data']);
    } else {
      return throw 'Có lỗi xảy ra';
    }
  }
}
