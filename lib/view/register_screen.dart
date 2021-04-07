import 'dart:async';
import 'package:azt/view/notificationScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:azt/view/login_screen.dart';
import 'package:azt/controller/login_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fullName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Future<void> _register(params) async {
    try {
      setState(() {
        _isRegistering = true;
      });
      await LoginController.register(params);
      _enterNotificationScreenTeacher();
    } catch (err) {
      Fluttertoast.showToast(
          msg: err.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _isRegistering = false;
      });
    }
  }

  void _enterNotificationScreenTeacher() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => NotificationScreen(
                  role: 'teacher',
                )),
        (Route<dynamic> route) => false);
  }

  bool _showPass = true;
  bool _isRegistering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        body: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).copyWith().size.height / 1.11,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/logo.png'),
                    height: 80,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'ĐĂNG KÝ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                                  controller: fullName,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Họ tên*',
                                    hintText: 'Nhập họ tên',
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
                                    border: OutlineInputBorder(),
                                    labelText: 'Số điện thoại*',
                                    hintText: 'Nhập số điện thoại',
                                    prefixIcon:
                                        Icon(Icons.phone_android_outlined),
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
                                  // validator: (value) => validatePhone(value)
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
                                  initialValue: null,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email*',
                                    hintText: 'email (không bắt buộc)',
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
                                        border: OutlineInputBorder(),
                                        labelText: 'Mật khẩu*',
                                        hintText: 'Nhập mật Khẩu',
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
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  onPressed: _isRegistering
                                      ? null
                                      : () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _register({
                                              'fullName': fullName.text,
                                              'email': email.text != null
                                                  ? null
                                                  : email.text,
                                              'phone': phone.text,
                                              'password': password.text,
                                            });
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
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    margin:
                        const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
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
            )
          ],
        ));
  }
}
