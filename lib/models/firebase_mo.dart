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

class SavedToken {
  int code;
  Data data;
  int success;
  String message;

  SavedToken({this.code, this.message, this.data, this.success});

  factory SavedToken.fromJson(Map<String, dynamic> json) {
    SavedToken savedToken = new SavedToken(
        code: json['code'],
        success: json['success'],
        message: json['message'],
        data: Data.fromJson(json['data']));
    return savedToken;
  }

// Function to save firebase token to DB, according to TEACHER
  static Future<SavedToken> saveToken(String firebaseToken) async {
    final accessToken = await Prefs.getPref(ACCESS_TOKEN);
    final response = await http.Client()
        .get(AZO_TOKEN_SAVE + '?token=$firebaseToken', headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + accessToken
    });

    if (response.statusCode == 200) {
      final tkn = json.decode(response.body);
      return SavedToken.fromJson(tkn);
    } else {
      return throw 'Có lỗi xảy ra';
    }
  }

  // Function to save firebase token to DB, according to PARENT
  static Future<SavedToken> saveAnonymousToken(String firebaseToken) async {
    final token = await Prefs.getPref(ANONYMOUS_TOKEN);
    final response = await http.Client()
        .get(AZO_TOKEN_SAVE + '?token=$firebaseToken', headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + token
    });

    if (response.statusCode == 200) {
      final tkn = json.decode(response.body);
      return SavedToken.fromJson(tkn);
    } else {
      print('Save token không thành công!');
      return throw 'Có lỗi xảy ra';
    }
  }

  // Function to delete firebase token according to user token
  static Future<String> deleteToken(String userToken) async {
    final response = await http.Client().get(AZO_TOKEN_DELETE, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + userToken
    });

    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      final tkn = json.decode(response.body);
      return "DELETE_SUCCESS";
    } else {
      return throw 'DELETE_FAIL';
    }
  }
}

class Data {
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
