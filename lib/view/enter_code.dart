import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:azt/view/dashboard_screen.dart';
import 'package:azt/view/choose_student.dart';
import 'package:azt/models/anonymous_use.dart';
import 'package:azt/controller/login_controller.dart';

class CodeForm extends StatefulWidget {
  @override
  _CodeFormState createState() => _CodeFormState();
}


class _CodeFormState extends State<CodeForm> {
  Future<AnonymousUser> anonymousUser;
  final _formKey = GlobalKey<FormState>();
  final code = TextEditingController();
  String validateCode(String value){
    if (value.isEmpty) {
      return 'Vui lòng nhập mã bài tập';
    }
    return null;
  }

  Future<void> handleEnterCode(params) async{

  }

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    anonymousUser = LoginController.loginAnonymous();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        body: Center(
          child: FutureBuilder<AnonymousUser> (
            future: anonymousUser,
            builder: (context, snapshot){
              if (snapshot.hasData) {
                print('anonymous token: '+snapshot.data.rememberToken);
                return new ListView(
                  padding: const EdgeInsets.only(
                    top: 40,
                  ),
                  children: <Widget>[

                    Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Thực hiện các bước sau để đăng nhập'
                            ,
                            softWrap: true,
                          ),
                          Text(
                            '1. Truy cập vào đường link nộp bài mà'
                                'giáo viên đã gửi cho bạn'
                            ,
                            softWrap: true,
                          ),
                          Text(
                            '2. Nhập mã bài tập vào ô bên dưới để'
                                'đăng nhập'
                            ,
                            softWrap: true,
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
                                      controller: code,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        hintText: 'Mã bài tập',
                                        prefixIcon: Icon(Icons.phone_android_outlined),
                                      ),
                                      validator: (value) => validateCode(value)
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) => ChooseStudent(hashId: code.text, anonymousToken: snapshot.data.rememberToken,)),
                                                (Route<dynamic> route) => false);
                                      }
                                    },

                                    child: Text('Đồng ý'),
                                  ),
                                ),
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
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          )
        ));
  }
}
