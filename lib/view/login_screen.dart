import 'dart:convert';
import 'package:azt/config/connect.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:azt/view/notificationScreen.dart';
// import 'package:azt/view/register_screen.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

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

  Future<void> _showAppleDialog(String errMsg) async {
    return Fluttertoast.showToast(
        msg: errMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void loginZalo() async {
    setState(() {
      _isSigningIn = true;
    });

    ZaloLoginResult res = await ZaloLogin().logIn();

    LoginController.loginZalo(res.oauthCode, 1).then((ok) {
      Future.delayed(
        Duration(seconds: 1),
        () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => NotificationScreen(
                        role: 'teacher',
                      )),
              (Route<dynamic> route) => false);
        },
      );
    }).catchError((onError) {
      setState(() {
        _isSigningIn = false;
      });

      return Fluttertoast.showToast(
          msg: "Đăng nhập Zalo không thành công!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }


  void appleLogIn() async {
    setState(() {
      _isSigningIn = true;
    });

    if(await AppleSignIn.isAvailable()) {

      final AuthorizationResult result = await AppleSignIn.performRequests([AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]);

    switch (result.status) {
      case AuthorizationStatus.authorized:

        print('credential user::: '+result.credential.user);
        var bytes = utf8.encode(SECRET_KEY+result.credential.user);
        var digest = md5.convert(bytes);

        print("Digest as bytes: ${digest.bytes}");
        print("Digest as hex string: $digest");


      LoginController.registerWithApple(digest.toString(), result.credential.user).then((ok) {
        Future.delayed(
          Duration(seconds: 1),
              () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => NotificationScreen(
                      role: 'teacher',
                    )),
                    (Route<dynamic> route) => false);
          },
        );
      }).catchError((onError) {
        setState(() {
          _isSigningIn = false;
        });

        _showAppleDialog('Đăng nhập với Apple thất bại!');
      });
      break;

      case AuthorizationStatus.error:
      print("Sign in failed: ${result.error.localizedDescription}");
      _showAppleDialog('Đăng nhập với Apple thất bại: '+result.error.localizedDescription.toString());

      break;

      case AuthorizationStatus.cancelled:
      print('Bạn đã hủy bỏ');
      break;
    }

    }else{
    print('Apple SignIn is not available for your device');
    }
  }

  @override
  void initState() {
    super.initState();

    if(Platform.isIOS){                                                      //check for ios if developing for both android & ios
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
                              child: ElevatedButton(
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

                                          setState(() {
                                            _isSigningIn = true;
                                          });

                                          LoginController.loginGetAccessToken(
                                                  paramsLogin)
                                              .then((ok) {
                                            Future.delayed(
                                              Duration(seconds: 1),
                                              () {
                                                print('OK Message: ' +
                                                    ok.toString());
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                NotificationScreen(
                                                                  role:
                                                                      'teacher',
                                                                )),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                              },
                                            );
                                          }).catchError((onError) {
                                            setState(() {
                                              _isSigningIn = false;
                                            });
                                            return Fluttertoast.showToast(
                                                msg:
                                                    "Thông tin đăng nhập không hợp lệ",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIos: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          });
                                        }
                                      },
                                child: Text(_isSigningIn
                                    ? 'Đang đăng nhập...'
                                    : 'Đăng Nhập'),
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
                          onPressed: _isSigningIn
                              ? null
                              : () {
                                  loginZalo();
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
                      Platform.isAndroid ? null :
                      AppleSignInButton(
                        type: ButtonType.continueButton,
                        onPressed: appleLogIn,
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
