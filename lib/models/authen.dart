/* 
  * Data model for Authentification
  * Dev name: Vu Quoc Dat
  * 
 */
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';

// class Login {
//   int code;
//   Data data;
//   int success;
//   String message;
//
//   Login({this.code, this.message, this.data, this.success});
//
//   factory Login.fromJson(Map<String, dynamic> json){
//     Login authInfo = new Login(
//       code: json['code'],
//       success: json['success'],
//       message: json['message'],
//       data: Data.fromJson(json['data'])
//     );
//     return authInfo;
//   }
//
//   static Future<Login> normalLogin(Map<String, dynamic> params) async{
//
//     final response = await http.Client().post(AZO_LOGIN, body: jsonEncode(params), headers: {
//       HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
//     });
//
//     if(response.statusCode == 200){
//       final resBody = json.decode(response.body);
//       print(Login.fromJson(resBody).data.rememberToken);
//       Prefs.savePrefs(ACCESS_TOKEN, Login.fromJson(resBody).data.rememberToken);
//       return Login.fromJson(resBody);
//     } else {
//       return throw 'Có lỗi xảy ra';
//     }
//
//   }
//
//
//   static Future<Login> getUserInfo(String token) async {
//
//     final response = await http.Client().get(AZO_AUTH_INFO, headers: {
//       HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
//       HttpHeaders.authorizationHeader: "Bearer "+token
//     });
//
//     if(response.statusCode == 200){
//       final user = json.decode(response.body);
//
//       return Login.fromJson(user);
//     } else {
//       return throw 'Có lỗi xảy ra';
//     }
//
//   }
//
// }

class User{
  String avatar;
  String birthday;
  dynamic classrooms;
  String createdAt;
  dynamic createdBy;
  String email;
  String emailVerifiedAt;
  String fullName;
  int gender;
  int id;
  dynamic note;
  String password;
  String phone;
  String rememberToken;
  String roles;
  bool status;
  String updatedAt;
  String uploadToken;
  String zaloId;

  User({
    this.avatar,
    this.birthday,
    this.classrooms,
    this.createdAt,
    this.createdBy,
    this.email,
    this.emailVerifiedAt,
    this.fullName,
    this.gender,
    this.id,
    this.note,
    this.password,
    this.phone,
    this.roles,
    this.status,
    this.updatedAt,
    this.rememberToken,
    this.uploadToken,
    this.zaloId
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    avatar: json["avatar"],
    birthday: json["birthday"],
    classrooms: json["classrooms"],
    createdAt: json["createdAt"],
    createdBy: json["createdBy"],
    email: json["email"],
    emailVerifiedAt: json["emailVerifiedAt"],
    fullName: json["fullName"],
    gender: json["gender"],
    id: json["id"],
    note: json["note"],
    password: json["password"],
    phone: json["phone"],
    roles: json["roles"],
    status: json["status"],
    updatedAt: json["updatedAt"],
    rememberToken: json["rememberToken"],
    uploadToken: json["uploadToken"],
    zaloId: json["zaloId"],
  );

}