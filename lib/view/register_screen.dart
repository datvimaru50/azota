import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:azt/view/dashboard_screen.dart';
import 'package:azt/view/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:azt/config/connect.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _FormRegister createState() => _FormRegister();
}

class _FormRegister extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController password = new TextEditingController();

//post data API

  Future register() async {
    Map mapdata = <String, dynamic>{
      'fullName': fullName.text,
      'email': email.text != null ? null : email.text,
      'phone': phone.text,
      'password': password.text,
    };
    //log data in form
    // ignore: unnecessary_brace_in_string_interps
    print("JSON DATA : ${mapdata}");
    final reponse = await http.Client().post(AZO_REGISTER,
        body: jsonEncode(mapdata),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
        });

    var data = jsonDecode(reponse.body);
    if (data['code'] == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Dashboard()),
          (Route<dynamic> route) => false);
      //log data in api
      // ignore: unnecessary_brace_in_string_interps
      return print("DATA TRUE: ${data}");
    } else {
      return Fluttertoast.showToast(
          msg: 'Số điện thoại đã tồn tại',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 16.0);
      // ignore: unnecessary_brace_in_string_interps
      // return print("DATA: ${data}");
    }
  }

  bool _showPass = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        appBar: AppBar(
          title: Text('Đăng Ký'),
        ),
        body: Center(
          child: new ListView(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            children: <Widget>[
              Image.network(
                'https://i0.wp.com/s1.uphinh.org/2021/01/15/logo.png',
                height: 80,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'ĐĂNG KÝ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            child: TextFormField(
                              obscureText: true,
                              controller: fullName,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: 'Họ tên',
                                prefixIcon: Icon(Icons.account_circle),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Vui lòng nhập họ tên';
                                }
                                if (value.length < 6) {
                                  return 'Họ phải trên 6 ký tự';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            child: TextFormField(
                              controller: phone,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: 'Số điện thoại',
                                prefixIcon: Icon(Icons.phone_android_outlined),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Vui lòng nhập số điện thoại';
                                }
                                if (value.isEmpty ||
                                    !RegExp(r'^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$')
                                        .hasMatch(value)) {
                                  return 'Số điện thoại không hợp lệ';
                                }

                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              children: [
                                TextFormField(
                                  controller: password,
                                  obscureText: _showPass,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintText: 'Mật Khẩu',
                                    prefixIcon: Icon(Icons.lock),
                                    // suffixIcon: Icon(Icons.remove_red_eye),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Vui lòng nhập mật khẩu';
                                    }
                                    if (value.length < 6) {
                                      return 'Mật khẩu phải trên 6 ký tự';
                                    }
                                    return null;
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showPass = !_showPass;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: FaIcon(
                                      _showPass
                                          ? Icons.remove_red_eye_rounded
                                          : FontAwesomeIcons.lowVision,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            child: TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: 'Email (không bắt buộc)',
                                prefixIcon: Icon(Icons.email),
                              ),
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return null;
                                }
                                if (value.isEmpty ||
                                    !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                        .hasMatch(value)) {
                                  return 'Email không hợp lệ';
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.
                                if (_formKey.currentState.validate()) {
                                  register();
                                }
                              },
                              child: Text('Đăng Ký'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        '---Hoặc---',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: OutlineButton.icon(
                        disabledBorderColor: Colors.blue,
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 5, left: 15, right: 15),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => SecondRoute()),
                          // );
                        },
                        icon: Image.network(
                          'https://i0.wp.com/s1.uphinh.org/2021/01/21/Logo-zalo-png.png',
                          width: 35,
                        ),
                        label: Text(
                          'Đăng nhập bằng Zalo',
                          style:
                              TextStyle(color: Color(0xff17A2B8), fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginForm()),
                              );
                            },
                            child: Text(
                              'Bạn đã có tài khoản',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
