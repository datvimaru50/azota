import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:azt/view/notificationScreenTeacher.dart';
import 'package:azt/view/register_screen.dart';

import 'package:azt/controller/login_controller.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final numberPhone = TextEditingController();
  final password = TextEditingController();

  String validatePhone(String value) {
    if (value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    if (value.isEmpty ||
        !RegExp(r'^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$')
            .hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải trên 6 ký tự';
    }
    return null;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    numberPhone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        body: Center(
          child: new ListView(
            padding: const EdgeInsets.only(
              top: 40,
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
                      'ĐĂNG NHẬP',
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
                              top: 15,
                            ),
                            child: TextFormField(
                                controller: numberPhone,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: 'Số điện thoại',
                                  prefixIcon:
                                      Icon(Icons.phone_android_outlined),
                                ),
                                validator: (value) => validatePhone(value)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            child: TextFormField(
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: 'Mật Khẩu',
                                  prefixIcon: Icon(Icons.lock),
                                  // suffixIcon: Icon(Icons.remove_red_eye),
                                ),
                                validator: (value) => validatePassword(value)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.
                                if (_formKey.currentState.validate()) {
                                  final paramsLogin = <String, dynamic>{
                                    "phone": numberPhone.text,
                                    "password": password.text,
                                  };

                                  LoginController.loginGetAccessToken(
                                          paramsLogin)
                                      .then((ok) {
                                    Future.delayed(
                                      Duration(seconds: 1),
                                      () {
                                        print('OK Message: ' + ok.toString());
                                        Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NotificationScreenTeacher()),
                                            (Route<dynamic> route) => false);
                                      },
                                    );
                                  }).catchError((onError) {
                                    return Fluttertoast.showToast(
                                        msg: "Thông tin đăng nhập không hợp lệ",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  });
                                }
                              },
                              child: Text('Đăng Nhập'),
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
                              top: 5.0, bottom: 5, left: 20, right: 19),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => SecondRoute()),
                            // );
                          },
                          icon: Image.network(
                            'https://i0.wp.com/s1.uphinh.org/2021/01/16/zalo.png',
                            width: 50,
                          ),
                          label: Text(
                            'Đăng nhập bằng Zalo',
                            style: TextStyle(
                                color: Color(0xff17A2B8), fontSize: 20),
                          )),
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
                                    builder: (context) => RegisterScreen()),
                              );
                            },
                            child: Text(
                              'Đăng ký thành viên mới',
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
