import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:azt/config/connect.dart';
import 'package:azt/models/anonymous_use.dart';

class LoginAnonymousController {
  Future<dynamic> loginAnonymous() async {
    final response = await http.Client().get(AZO_LOGIN_ANONYMOUS, headers: {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    });

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return AnonymousUser.fromJson(responseBody['data']);
    } else {
      return throw 'Có lỗi xảy ra';
    }
  }
}
