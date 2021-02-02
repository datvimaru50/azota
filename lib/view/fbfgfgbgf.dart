import 'dart:async';
import 'package:azt/controller/homework_controller.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:azt/view/notificationScreenStudent.dart';
import 'package:azt/models/core_mo.dart';

class ChooseStudent extends StatefulWidget {
  ChooseStudent({Key key, @required this.hashId, @required this.anonymousToken})
      : super(key: key);
  final String hashId;
  final String anonymousToken;

  @override
  _ChooseStudentState createState() => _ChooseStudentState();
}

class _ChooseStudentState extends State<ChooseStudent> {
  Future<HomeworkHashIdInfo> homeworkHashIdInfo;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    homeworkHashIdInfo = HomeworkController.getHomeworkInfo(
        widget.hashId, widget.anonymousToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Chọn học sinh'),
              Text(
                'Hạn nộp: 15/01/21',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            FutureBuilder<HomeworkHashIdInfo>(
              future: homeworkHashIdInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print('thong tin hashid ' +
                      snapshot.data.studentObjs.elementAt(0)['fullName']);
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3,
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 4.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          color: Colors.black12,
                          child: InkWell(
                            child: Text(
                              snapshot.data.studentObjs
                                  .elementAt(index)['fullName'],
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            onTap: () {
                              var stdID = snapshot.data.studentObjs
                                  .elementAt(index)['id']
                                  .toString();

                              HomeworkController.updateParent(
                                      stdID, widget.anonymousToken)
                                  .then((ok) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationScreenStudent()),
                                    (Route<dynamic> route) => false);
                              }).catchError((error) {
                                print(error.toString());
                              });
                            },
                          ),
                        );
                      },
                      childCount: snapshot.data.studentObjs.length,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.6,
                crossAxisCount: 1,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 4.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: 15, left: 35, right: 35),
                          child: Text(
                              '(*) Nếu bạn chưa tìm thấy tên con mình. Vui lòng nhập tên và ngày sinh của con bạn!'),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.phone_android_outlined),
                                    hintText: 'Họ và tên',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Vui lòng nhập họ tên';
                                    }
                                    if (value.length > 6) {
                                      return 'Họ tên phải trên 6 ký tự';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: DateTimePicker(
                                  initialValue: '',
                                  icon: Icon(Icons.date_range),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  dateLabelText: 'Ngày Sinh',
                                  onChanged: (val) => print(val),
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return 'Vui lòng chọn ngày sinh';
                                    }
                                    print(val);
                                    return null;
                                  },
                                  onSaved: (val) => print(val),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Validate will return true if the form is valid, or false if
                                    // the form is invalid.
                                    if (_formKey.currentState.validate()) {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           HomePageTeacher()),
                                      //   // NotificationScreenTeacher()),
                                      // );
                                    }
                                  },
                                  child: Text('Tiếp Tục'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // color: Colors.black12,
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        )
        //Your Widgets
        );
  }
}
