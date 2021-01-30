import 'package:flutter/material.dart';
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

  Future<void> handleEnterCode(params) async {}

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
        appBar: AppBar(
          title: Text('Nhập mã bài tập'),
        ),
        body: Center(
            child: FutureBuilder<AnonymousUser>(
          future: anonymousUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('anonymous token: ' + snapshot.data.rememberToken);
              return new ListView(
                padding: const EdgeInsets.only(
                  top: 40,
                ),
                children: <Widget>[
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'Thực hiện các bước sau để đăng nhập',
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 30, left: 10, right: 10),
                          child: Text(
                            '1. Truy cập vào đường link nộp bài mà giáo viên đã gửi cho bạn',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: Text(
                            '2. Nhập mã bài tập vào ô bên dưới để đăng nhập',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: Image.network(
                              'https://i0.wp.com/s1.uphinh.org/2021/01/21/exersiceCode.png'),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 20, left: 15, right: 15),
                                child: TextFormField(
                                  controller: code,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintText: 'Nhập mã bài tập của bạn',
                                    prefixIcon: Icon(Icons.code_sharp),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Vui lòng nhập mã bài tập';
                                    }
                                    if (value.length < 6) {
                                      return 'Mã bài tập phải lớn hơn 6 ký tự';
                                    }
                                    return null;
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
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChooseStudent(
                                                    hashId: code.text,
                                                    anonymousToken: snapshot
                                                        .data.rememberToken,
                                                  )),
                                          (Route<dynamic> route) => false);
                                    }
                                  },
                                  child: Text(
                                    'ĐỒNG Ý',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
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
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        )));
  }
}
