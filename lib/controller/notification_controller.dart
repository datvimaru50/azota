import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
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

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return ListNotification.fromJson(resBody['data']);
        } else {
          throw "Có lỗi, không hiển thị được thông báo";
        }
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }
  }

  static Future<ListNotification> getNotiAnonymous(int page) async {
    final anonymousToken = await Prefs.getPref(ANONYMOUS_TOKEN);

    final response = await http.Client()
        .get(AZO_GET_NOTIF + '?page=' + page.toString(), headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + anonymousToken
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return ListNotification.fromJson(resBody['data']);
        } else {
          throw "Có lỗi, không hiển thị được thông báo";
        }
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }
  }

  static Future<String> markAsRead({@required int noticeId, String accType = 'teacher'}) async {
    final token = accType == 'teacher' ? await Prefs.getPref(ACCESS_TOKEN) : await Prefs.getPref(ANONYMOUS_TOKEN);

    final response = await http.Client()
        .get(AZO_NOTIF_MARK_READ + '?id=' + noticeId.toString(), headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return "Thông báo được đánh dấu là đã đọc";
        } else {
          throw "Có lỗi, không đánh dấu được";
        }
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }
  }

  static Future<String> markAllAsRead() async {
    final token = await Prefs.getPref(ACCESS_TOKEN);

    final response = await http.Client()
        .get(AZO_NOTIF_MARK_ALL_READ, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return "Tất cả thông báo được đánh dấu là đã đọc";
        } else {
          throw "Có lỗi, không đánh dấu được";
        }
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }
  }

  static Future<String> deleteNotif({@required int noticeId}) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);

    final response = await http.Client()
        .get(AZO_DELETE_NOTIF + '?id=$noticeId', headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return "Xóa thông báo thành công";
        } else {
          throw "Có lỗi, không xóa được thông báo";
        }
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }
  }

  static Future<String> deleteAllNotif() async {
    final token = await Prefs.getPref(ACCESS_TOKEN);

    final response = await http.Client()
        .get(AZO_DELETE_ALL_NOTIF, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return "Xóa thông báo thành công";
        } else {
          throw "Có lỗi, không xóa được thông báo";
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
