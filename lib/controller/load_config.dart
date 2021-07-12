import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:azt/config/global.dart';
import 'package:azt/config/connect.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class LoadConfigController extends ControllerMVC {
  factory LoadConfigController() {
    if (_this == null) _this = LoadConfigController._();
    return _this;
  }

  static LoadConfigController _this;
  LoadConfigController._();
  static LoadConfigController get con => _this;

  /* **********************************
  Loading config json info from server
  ********************************** */
  static Future<String> load() async {
    const headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };

    final String apiUrl = 'https://diendat.net/azota_config.json?t=' + DateTime.now().toString();

    final response = await http.Client().get(apiUrl, headers: headers);

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);
        print(resBody['base_url']);
        Prefs.savePrefs(BASE_URL, resBody['base_url']);
        return resBody['base_url'];
        break;

      case 400:
        throw ERR_BAD_REQUEST;
        break;

      default:
        throw ERR_SERVER_CONNECT;
    }
  }
}
