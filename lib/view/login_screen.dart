import 'dart:convert';
import 'package:azt/config/connect.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:azt/view/notificationScreen.dart';
// import 'package:azt/view/register_screen.dart';
import 'dart:io';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:azt/controller/login_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_zalo_login/flutter_zalo_login.dart';
import 'package:crypto/crypto.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final numberPhone = TextEditingController();
  final password = TextEditingController();

  ZaloLoginResult zaloLoginResult = ZaloLoginResult(
    errorCode: -1,
    errorMessage: "",
    oauthCode: "",
    userId: "",
  );

  ZaloProfileModel zaloInfo = ZaloProfileModel(
    birthday: "",
    gender: "",
    id: "",
    name: "",
    picture: null,
  );

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

  Future<void> _showErrorToast(String errMsg) async {
    return Fluttertoast.showToast(
        msg: errMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _enterNotificationScreenTeacher() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => NotificationScreen(
                  role: 'teacher',
                )),
        (Route<dynamic> route) => false);
  }

  Future<void> _normalLogin(params) async {
    try {
      setState(() {
        _isSigningIn = true;
      });
      await LoginController.login('NORMAL', params);
      _enterNotificationScreenTeacher();
    } catch (err) {
      _showErrorToast(err.toString());
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  Future<void> _loginZalo() async {
    try {
      setState(() {
        _isSigningIn = true;
      });
      ZaloLoginResult res = await ZaloLogin().logIn();
      await LoginController.login('ZALO', {"code": res.oauthCode, "role": 1});
      _enterNotificationScreenTeacher();
    } catch (err) {
      _showErrorToast(err.toString());
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  void _appleLogIn() async {
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            setState(() {
              _isSigningIn = true;
            });
            var bytes = utf8.encode(SECRET_KEY + result.credential.user);
            var digest = md5.convert(bytes);
            await LoginController.login('APPLE',
                {'md5': digest.toString(), 'email': result.credential.user});
            _enterNotificationScreenTeacher();
          } catch (err) {
            _showErrorToast(err.toString());
            setState(() {
              _isSigningIn = false;
            });
          }
          break;

        case AuthorizationStatus.error:
          _showErrorToast(ERR_APPLE_SIGN_IN);
          break;

        default:
          _showErrorToast(ERR_APPLE_USER_CANCEL);
      }
    } else {
      _showErrorToast(ERR_APPLE_SIGNIN_NOT_AVAILABLE);
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    numberPhone.dispose();
    password.dispose();
    super.dispose();
  }

  bool _showPass = true;
  bool _isSigningIn = false;

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
                    children: <Widget>[
                      Text(
                        'ĐĂNG NHẬP',
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
                                validator: (value) => validatePhone(value),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      hintText: 'Mật Khẩu',
                                      prefixIcon: Icon(Icons.lock),
                                      // suffixIcon: Icon(Icons.remove_red_eye),
                                    ),
                                    validator: (value) =>
                                        validatePassword(value),
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
                              child: ElevatedButton.icon(
                                //ElevatedButton.icon(onPressed: onPressed, icon: icon, label: label),
                                icon: Icon(Icons.arrow_right_alt),
                                label: Text(_isSigningIn
                                    ? 'Đang đăng nhập...'
                                    : 'Đăng Nhập'),
                                onPressed: _isSigningIn
                                    ? null
                                    : () {
                                        // Validate will return true if the form is valid, or false if
                                        // the form is invalid.
                                        if (_formKey.currentState.validate()) {
                                          final paramsLogin = <String, dynamic>{
                                            "phone": numberPhone.text,
                                            "password": password.text,
                                          };

                                          _normalLogin(paramsLogin);
                                        }
                                      },
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
                        // ignore: deprecated_member_use
                        child: OutlineButton.icon(
                          disabledBorderColor: Colors.blue,
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 5, left: 15, right: 15),
                          onPressed: _isSigningIn
                              ? null
                              : () {
                                  _loginZalo();
                                },
                          icon: Image(
                            image: AssetImage('assets/zalo.png'),
                            width: 35,
                          ),
                          label: Text(
                            'Đăng nhập bằng Zalo',
                            style: TextStyle(
                                color: Color(0xff17A2B8), fontSize: 15),
                          ),
                        ),
                      ),
                      Platform.isAndroid
                          ? Container()
                          : AppleSignInButton(
                              type: ButtonType.continueButton,
                              onPressed: _appleLogIn,
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
          ),
        ],
      ),
    );
  }
}
