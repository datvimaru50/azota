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
import 'package:azt/view/notificationScreenStudent.dart';
import 'package:azt/models/authen.dart';
import 'package:azt/models/core_mo.dart';

// Login controller, handle different type of logins
class HomeworkController extends ControllerMVC {
  factory HomeworkController() {
    if (_this == null) _this = HomeworkController._();
    return _this;
  }

  static HomeworkController _this;

  HomeworkController._();

  /// Allow for easy access to 'the Controller' throughout the application.
  static HomeworkController get con => _this;


  static Future<HomeworkHashIdInfo> getHomeworkInfo(String hashId, String anonymousToken) async{
    final response = await http.Client().get(AZO_HOMEWORK_INFO + '?id=' + hashId, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer "+anonymousToken
    });

    if(response.statusCode == 200){
      final responseBody = json.decode(response.body);
      return HomeworkHashIdInfo.fromJson(responseBody['data']);
    } else {
      return throw 'Có lỗi xảy ra';
    }
  }

  static Future<String> updateParent(String studentId, String anonymousToken) async{
    final response = await http.Client().get(AZO_UPDATE_PARENT + '?id=' + studentId, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer "+anonymousToken
    });

    if(response.statusCode == 200){

      return "Cập nhật phụ huynh thành công!";
    } else {
      return throw 'Có lỗi xảy ra';
    }
  }
}