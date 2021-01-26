import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';

class Profile {
  int id;
  String name;
  String email;
  String avatar;
  String phone;
  String address;
  String location;
  dynamic gender;
  int balance;

  Profile({
    this.id,
    this.email,
    this.name,
    this.avatar,
    this.gender,
    this.phone,
    this.address,
    this.location,
    this.balance,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    Profile profile = new Profile(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      name: json['name'],
      avatar: json['avatar'],
      address: json['address'],
      gender: json['gender'],
      location: json['location'],
      balance: json['balance'],
    );
    return profile;
  }

  static Future<bool> getInfor(String token) async {
    final response = await http.Client().get(HKS_GET_PROFILE, headers: {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      Prefs.savePrefs(PROFILE, response.body.toString());
      print(responseBody);
      print("getInfor: "+ response.body.toString());
      return true;
    } else {
      return false;
    }
  }

  static Future<Profile> getAllUserInformation(String token) async {
    final response = await http.Client().get(HKS_GET_PROFILE, headers: {
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    });
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      Prefs.savePrefs(PROFILE, response.body.toString());
      return Profile.fromJson(responseBody);
    } else {
      throw Fluttertoast.showToast(msg: "Lỗi, vui lòng thử lại");
    }
  }

  static Future<Profile> getInforPrefs() async {
    String jsonProfile;
    await Prefs.getPref(PROFILE).then((onValue) {
      jsonProfile = onValue;
    });
    final responseBody = await json.decode(jsonProfile);
    return Profile.fromJson(responseBody);
  }
}
