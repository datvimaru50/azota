import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:azt/controller/homework_controller.dart';
import 'package:azt/view/groupScreenStudent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';

class NewVersionInfo {
  String name;
  String version;
  String build;
  String description;

  NewVersionInfo({
    this.version,
    this.build,
    this.name,
    this.description,
  });

  factory NewVersionInfo.fromJson(Map<String, dynamic> json) => NewVersionInfo(
        name: json["name"],
        version: json["version"],
        build: json["build"],
        description: json["description"],
      );
}

class UpdateController extends ControllerMVC {
  factory UpdateController() {
    if (_this == null) _this = UpdateController._();
    return _this;
  }

  static UpdateController _this;

  UpdateController._();

  static UpdateController get con => _this;

  static Future<NewVersionInfo> getNewVersionInfo() async {
    print('gọi thong tin ve');
    final response = await http.Client()
        .get('https://diendat.net/azota_latest_version.json', headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return NewVersionInfo.fromJson(responseBody);
    } else {
      return throw 'Có lỗi xảy ra';
    }
  }

  static Future updateChangeShowAddStudent(
      {int changeShowAdd, String idClassroom}) async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    print(idClassroom + changeShowAdd.toString() + "tesst");
    Map mapdata = <String, dynamic>{
      "id": idClassroom,
      "showAddStudent": changeShowAdd
    };
    // ignore: unnecessary_brace_in_string_interps
    print("JSON DATA : ${mapdata}");
    final reponse = await http.Client().get(
        AZO_CHANGESHOW_ADD_STUDENT +
            '?id=$idClassroom' +
            '&status=$changeShowAdd',
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        });

    var data = jsonDecode(reponse.body);
    if (data['success'] == 1) {
      return 'Cap nhat thanh cong';
    } else {
      return 'Cap nhat khong thanh cong';
    }
  }

  static Future saveNewStudent(
    String hashId,
    String fullName,
    String birthday,
    BuildContext context,
  ) async {
    final token = await Prefs.getPref(ANONYMOUS_TOKEN);
    print(birthday.toString() +
        fullName.toString() +
        hashId.toString() +
        "tesst");
    Map mapdata = <String, dynamic>{
      "birthday": birthday,
      "fullName": fullName,
      "homeworkHashId": hashId
    };
    final reponse = await http.Client().post(AZO_SAVE_NEW_PARENT,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        },
        body: jsonEncode(mapdata));

    var data = jsonDecode(reponse.body);
    print('::::::::::::test' + data['data']['id'].toString());

    if (data['success'] == 1) {
      try {
        await Prefs.savePrefs(HASH_ID, hashId);
        var stdID = data['data']['id'];

        await HomeworkController.updateParent(stdID.toString());

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    // ignore: missing_required_param
                    GroupScreenStudent()),
            (Route<dynamic> route) => false);
      } catch (err) {
        Fluttertoast.showToast(
            msg: err,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return 'Cap nhat thanh cong';
    } else {
      return 'Cap nhat khong thanh cong';
    }
  }
}
