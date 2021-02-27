import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';

class NewVersionInfo{
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

}
