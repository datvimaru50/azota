import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';

class ConfigInformation {
  String api_url;
  String slogan;

  ConfigInformation({this.slogan, this.api_url});
  factory ConfigInformation.fromJson(Map<String, dynamic> json) =>
      ConfigInformation(
        api_url: json["api_url"],
        slogan: json["slogan"],
      );
}

class ConfigController extends ControllerMVC {
  factory ConfigController() {
    if (_this == null) _this = ConfigController._();
    return _this;
  }

  static ConfigController _this;

  ConfigController._();

  static ConfigController get con => _this;

  static Future<ConfigInformation> getConfigInfo(int page) async {
   final response = await http.Client()
        .get('https://diendat.net/azota_config.json', headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return ConfigInformation.fromJson(responseBody);
    } else {
      return throw 'Không lấy được thông tin config';
    }
  }


}
