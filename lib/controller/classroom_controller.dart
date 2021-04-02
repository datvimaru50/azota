import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:azt/view/listClass_teacher.dart';
import 'package:azt/view/listStudents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:azt/models/core_mo.dart';

class ClassroomController extends ControllerMVC {
  factory ClassroomController() {
    if (_this == null) _this = ClassroomController._();
    return _this;
  }

  static ClassroomController _this;
  ClassroomController._();
  static ClassroomController get con => _this;

  static Future<ClassroomHashIdInfo> getClassroomkInfo() async {
    final token = await Prefs.getPref(ACCESS_TOKEN);

    final response = await http.Client().get(AZO_CLASSROOM_INFO, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + token
    });

    switch (response.statusCode) {
      case 200:
        final resBody = jsonDecode(response.body);
        if (resBody['success'] == 1) {
          return ClassroomHashIdInfo.fromJson(resBody);
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

  static Future deleteClassroom(String id, context) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    final response = await http.Client()
        .get(AZO_DELETECLASSROOM_INFO + '?id=' + id, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + token
    });

    switch (response.statusCode) {
      case 200:
        final resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ListClass(),
              ),
              (Route<dynamic> route) => false);
          return Fluttertoast.showToast(
              msg: 'Xóa Lớp Thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.green[900],
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          return Fluttertoast.showToast(
              msg: 'Xóa lớp học không thàng công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }
  }

  static Future deleteStudent(
    String id,
    context,
    classroomId,
    className,
    countStudents,
    homeworkId,
  ) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    final response =
        await http.Client().get(AZO_DELETESTUDENT_INFO + '?id=' + id, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + token
    });

    switch (response.statusCode) {
      case 200:
        final resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ListStudents(
                  id: classroomId,
                  className: className,
                  countStudents: countStudents,
                  homeworkId: homeworkId,
                ),
              ),
              (Route<dynamic> route) => false);
          return Fluttertoast.showToast(
            msg: 'Xóa học sinh thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.green[900],
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          return Fluttertoast.showToast(
            msg: 'Xóa học sinh không thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }
  }

  static Future<ClassroomHashIdInfo> getExersiceInfoAgain(String id) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    final response = await http.Client()
        .get(AZO_EXERSICE_INFO + '?classroomId=' + id, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + token
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return ClassroomHashIdInfo.fromJson(resBody);
        } else {
          throw ERR_BAD_REQUEST;
        }
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }
  }

  static Future<ClassroomHashIdInfo> studentClassroom(String id) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    final response = await http.Client()
        .get(AZO_STUDENT_INFO + '?classroomId=' + id, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return ClassroomHashIdInfo.fromJson(resBody);
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

  static Future<AnswerHashIdInfo> answerStudent(String homeworkId) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    final response = await http.Client()
        .get(AZO_ANSWER_INFO + '?homeworkId=' + homeworkId, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          return AnswerHashIdInfo.fromJson(resBody);
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
