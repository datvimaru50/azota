/*
  * Data model for Firebase Message
  * Dev name: Vu Quoc Dat
  *
 */
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';

class NotiObject {
  int code;
  Data data;
  int success;
  String message;

  NotiObject({this.code, this.message, this.data, this.success});

  factory NotiObject.fromJson(Map<String, dynamic> json){
    NotiObject gotObj = new NotiObject(
        code: json['code'],
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json['data'])
    );
    return gotObj;
  }


  static Future<NotiObject> saveToken() async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    final response = await http.Client().get(AZO_GET_NOTIF, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer "+token
    });

    if(response.statusCode == 200){
      final obj = json.decode(response.body);
      return NotiObject.fromJson(obj);
    } else {
      return throw 'Có lỗi xảy ra';
    }

  }

}

class Data{
  int id;
  int userId;
  String token;
  String createdAt;
  String updatedAt;

  Data({
    this.id,
    this.userId,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["userId"],
    token: json["token"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );
}

