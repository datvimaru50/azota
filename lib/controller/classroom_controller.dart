import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:azt/view/detailClass_teacher.dart';
import 'package:azt/view/detailExersice_teacher.dart';
import 'package:azt/view/groupScreenTeacher.dart';
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupScreenTeacher(),
            ),
          );
          return Fluttertoast.showToast(
              msg: 'Xóa Lớp Thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.green,
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
            backgroundColor: Colors.green,
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

  static Future<List<dynamic>> studentClassroom({@required String id}) async {
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
          List<dynamic> result = resBody["data"];
          return result;
        } else {
          throw "Lấy thông tin học sinh bị lỗi";
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

  static Future updateClassroom(String id, name, countStudents, homeworkId,
      homeworks, BuildContext context) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    Map mapdata = <String, dynamic>{"id": id, "name": name.text};
    // ignore: unnecessary_brace_in_string_interps
    print("JSON DATA : ${mapdata}");
    final reponse =
        await http.Client().post(AZO_CLASSROOM_UPDATE, body: mapdata, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    var data = jsonDecode(reponse.body);
    if (data['success'] == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailClass(
            idClassroom: id,
            className: name.text,
            countStudents: countStudents,
            homeworkId: homeworkId,
            homeworks: homeworks,
          ),
        ),
      );
      return Fluttertoast.showToast(
          msg: 'Sửa lớp thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      return Fluttertoast.showToast(
          msg: 'Sửa lớp không thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static Future deleteParent(
      {String idStudent,
      fullName,
      birthday,
      id,
      className,
      countStudents,
      context,
      homeworkId}) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    Map mapdata = <String, dynamic>{
      "id": idStudent,
      "classroomId": id,
      "fullName": fullName,
      "parentId": "0",
      "birthday": birthday,
    };
    //log data in form
    // ignore: unnecessary_brace_in_string_interps
    print("JSON DATA : ${mapdata}");
    final reponse = await http.Client().post(
      AZO_STUDENT_UPDATE + '?id=' + idStudent,
      body: jsonEncode(mapdata),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    var data = jsonDecode(reponse.body);
    if (data['success'] == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListStudents(
            id: id,
            className: className,
            countStudents: countStudents,
            homeworkId: homeworkId,
          ),
        ),
      );
      return Fluttertoast.showToast(
          msg: 'Xóa phụ huynh thành công ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      return Fluttertoast.showToast(
          msg: 'Xóa phụ huynh không thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static Future editStudentRoom(
      String fullName,
      gender,
      checkGender,
      birthday,
      classRoomId,
      idStudent,
      context,
      className,
      countStudents,
      homeworkId) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    Map mapdata = <String, dynamic>{
      "fullName": fullName,
      "gender": gender == null ? checkGender : gender,
      "birthday": birthday.text,
      "classroomId": classRoomId,
      "id": idStudent
    };
    //log data in form
    // ignore: unnecessary_brace_in_string_interps
    print("JSON DATA : ${mapdata}");
    final reponse = await http.Client().post(
      AZO_STUDENT_UPDATE + '?id=' + idStudent,
      body: jsonEncode(mapdata),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    var data = jsonDecode(reponse.body);
    if (data['success'] == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListStudents(
            id: classRoomId,
            className: className,
            countStudents: countStudents,
            homeworkId: homeworkId,
          ),
        ),
      );
      return Fluttertoast.showToast(
          msg: 'Sửa học sinh thành công ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      return Fluttertoast.showToast(
          msg: 'Sửa học sinh không thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static Future addClassRoom(name, context) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    final reponse = await http.Client().post(
      AZO_ADDCLASS_INFO,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: {"name": name.text},
    );

    var data = jsonDecode(reponse.body);
    final dataClass = data['data'];
    if (data['success'] == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailClass(
            idClassroom: dataClass['id'].toString(),
            countStudents: dataClass['countStudents'].toString(),
            className: dataClass['name'].toString(),
            homeworks: dataClass['homeworks'].toString(),
          ),
        ),
      );
      return Fluttertoast.showToast(
          msg: 'Tạo lớp học thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      // ignore: unnecessary_brace_in_string_interps
      return Fluttertoast.showToast(
          msg: 'Tạo lớp học không thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static Future deleteExersice(
      String countStudents, className, homeworkId, homeworks, idClassroom,
      {String idExersice, BuildContext context}) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    final response = await http.Client()
        .get(AZO_DELETEEXERSICE_INFO + '?id=' + idExersice, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + token
    });

    switch (response.statusCode) {
      case 200:
        final resBody = json.decode(response.body);
        if (resBody['success'] == 1) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => DetailClass(
                  idClassroom: idClassroom,
                  className: className,
                  countStudents: countStudents,
                  homeworkId: homeworkId,
                  homeworks: homeworks,
                ),
              ),
              (Route<dynamic> route) => false);
          return Fluttertoast.showToast(
              msg: 'Xóa bài tập Thành công',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          return Fluttertoast.showToast(
              msg: 'Xóa bài tập không thàng công',
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

  static Future editExersice(
      {String idExersice,
      String content,
      String deadline,
      BuildContext context,
      String exerciseId,
      String countStudents,
      String className,
      String homeworkId,
      String homeworks,
      String idClassroom}) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    Map mapdata = <String, String>{
      "id": idExersice,
      "name": "Bài Tập",
      "content": content,
      "deadline": deadline,
    };
    //log data in form
    // ignore: unnecessary_brace_in_string_interps
    print("JSON DATA : ${mapdata}");
    final reponse = await http.Client().post(
      AZO_UPDATEEXERSICE_INFO,
      body: jsonEncode(mapdata),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.authorizationHeader: "Bearer " + token,
      },
    );
    var data = jsonDecode(reponse.body);
    if (data['success'] == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailExersice(
            deadline: deadline,
            exerciseId: exerciseId,
            content: content,
            countStudents: countStudents,
            className: className,
            homeworkId: homeworkId,
            homeworks: homeworks,
            idClassroom: idClassroom,
            idExersice: idExersice,
          ),
        ),
      );

      return Fluttertoast.showToast(
          msg: 'Sửa bài tập thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      return Fluttertoast.showToast(
          msg: 'Sửa bài tập không thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static Future addStudentRoom(
      {String className,
      countStudents,
      homeworkId,
      classRoomId,
      BuildContext context,
      String fullName,
      int gender,
      String birthday}) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    Map mapdata = <String, dynamic>{
      "fullName": fullName,
      "gender": gender == null ? '0' : gender,
      "birthday": birthday,
      "classroomId": classRoomId,
    };
    //log data in form
    // ignore: unnecessary_brace_in_string_interps
    print("JSON DATA : ${mapdata}");
    final reponse = await http.Client()
        .post(AZO_STUDENT_SAVE, body: jsonEncode(mapdata), headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    var data = jsonDecode(reponse.body);
    if (data['success'] == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListStudents(
            id: classRoomId,
            className: className,
            countStudents: countStudents,
            homeworkId: homeworkId,
          ),
        ),
      );
      return Fluttertoast.showToast(
          msg: 'Thêm học sinh thành công ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      return Fluttertoast.showToast(
          msg: 'Thêm học sinh không thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static Future addExersice({
    String idClassroom,
    String countStudents,
    String className,
    String homeworks,
    String homeworkId,
    BuildContext context,
    String deadline,
    String content,
  }) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    Map mapdata = <String, String>{
      "name": "Bài Tập ",
      "content": content,
      "classroomId": idClassroom,
      "deadline": deadline,
    };
    //log data in form
    // ignore: unnecessary_brace_in_string_interps
    print("JSON DATA : ${mapdata}");
    final reponse = await http.Client().post(
      AZO_HOMEWORK_SAVE,
      body: jsonEncode(mapdata),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.authorizationHeader: "Bearer " + token,
      },
    );
    var data = jsonDecode(reponse.body);
    if (data['success'] == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailClass(
            idClassroom: idClassroom,
            countStudents: countStudents,
            className: className,
            homeworks: homeworks,
            homeworkId: homeworkId,
          ),
        ),
      );
      return Fluttertoast.showToast(
          msg: 'Tạo bài tập thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      return Fluttertoast.showToast(
          msg: 'Tạo bài tập không thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
