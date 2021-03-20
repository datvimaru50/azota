import 'package:flutter/material.dart';
import 'package:azt/view/choose_student.dart';

class CodeForm extends StatefulWidget {
  @override
  _CodeFormState createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  final _formKey = GlobalKey<FormState>();
  final code = TextEditingController();

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        appBar: AppBar(
          title: Text('Nhập mã bài tập'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          ),
        ),
        body: Center(
            child: ListView(
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
                        child: Image(
                          image: AssetImage('assets/code.png'),
                        ),
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
                                    return 'Mã bài tập phải lớn hơn 6 ký tự ';
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ChooseStudent(
                                        hashId: code.text,
                                      )),
                                    );
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
            )
        ));
  }
}
