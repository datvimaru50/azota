import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class UploadInfo {
  String name;
  String path;
  String extension;
  String mimes;
  String size;
  String url;
  // ignore: non_constant_identifier_names
  String upload_url;

  UploadInfo({
    this.name,
    this.path,
    this.extension,
    this.mimes,
    this.size,
    this.url,
    // ignore: non_constant_identifier_names
    this.upload_url,
  });

  factory UploadInfo.fromJson(Map<String, dynamic> json) => UploadInfo(
        name: json["name"],
        path: json["path"],
        extension: json["extension"],
        mimes: json["mimes"],
        size: json["size"],
        url: json["url"],
        upload_url: json["upload_url"],
      );
}

class UploadController extends ControllerMVC {
  factory UploadController() {
    if (_this == null) _this = UploadController._();
    return _this;
  }

  static UploadController _this;
  UploadController._();
  static UploadController get con => _this;

  /* **********************************
  Get public uploads
  ********************************** */
  static Future<UploadInfo> getPulicUpload(
      String fileName, String fileSize, String mineType) async {
    final String uploadToken = await Prefs.getPref(UPLOAD_TOKEN);

    final dynamic headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    };

    final response = await http.Client().get(
        AZO_S3SPACE_SAVE +
            '?token=$uploadToken&file_name=$fileName&file_size=$fileSize&minetype=$mineType',
        headers: headers);

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);

        if (resBody['success'] == 1) {
          var uploadData = resBody['data'];
          UploadInfo uploadInfo = UploadInfo.fromJson(uploadData);
          return uploadInfo;
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

/* **********************************
  Upload files to CDN
  ********************************** */
  static Future<void> putToCdn(String apiUrl, payload) async {
    // ignore: unused_local_variable
    final response = await http.Client().put(apiUrl, body: payload, headers: {
      HttpHeaders.contentTypeHeader: 'application/octet-stream',
      'x-amz-acl': 'public-read'
    });
  }

/* **********************************
  Save upload info to database
  ********************************** */
  static Future<String> saveUploadInfo(Map<String, dynamic> params) async {
    final String token = await Prefs.getPref(ANONYMOUS_TOKEN);
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.authorizationHeader: "Bearer " + token
    };

    final response = await http.Client()
        .post(AZO_ANSWER_SAVE, body: jsonEncode(params), headers: headers);

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> resBody = json.decode(response.body);

        if (resBody['success'] == 1) {
          return SUCCESS_SUBMIT_HOMEWORK;
        } else {
          throw ERROR_SUBMIT_HOMEWORK;
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
