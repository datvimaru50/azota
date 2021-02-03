import 'dart:async';
import 'package:azt/controller/homework_controller.dart';
import 'package:flutter/material.dart';
import 'package:azt/view/notificationScreen.dart';
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
  // final _formKey = GlobalKey<FormState>();
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
        title: Text('Chọn học sinh')
      ),
      body: Container(
        child: FutureBuilder<HomeworkHashIdInfo>(
          future: homeworkHashIdInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('thong tin hashid ' +
                  snapshot.data.studentObjs.elementAt(0)['fullName']);
              return CustomScrollView(
                slivers: <Widget>[
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3,
                      crossAxisCount: 2,
                      // crossAxisSpacing: 5.0,
                      // mainAxisSpacing: 4.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            child: Text(
                              snapshot.data.studentObjs
                                  .elementAt(index)['fullName'],
                              style: TextStyle(
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
                                            NotificationScreen(
                                              role: 'parent',
                                            )),
                                    (Route<dynamic> route) => false);
                              }).catchError((error) {
                                print(error.toString());
                              });
                            },
                          ),
                          margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            color: Color(0xFFfafafa),
                          ),
                        );
                      },
                      childCount: snapshot.data.studentObjs.length,
                    ),
                  ),

                  // SliverGrid(
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     childAspectRatio: 1.45,
                  //     crossAxisCount: 1,
                  //     crossAxisSpacing: 20.0,
                  //     mainAxisSpacing: 4.0,
                  //   ),
                  //   delegate: SliverChildBuilderDelegate(
                  //     (BuildContext context, int index) {
                  //       return Container(
                  //         child: Column(
                  //           children: [
                  //             Padding(
                  //               padding: EdgeInsets.only(
                  //                   top: 10, left: 50, right: 50),
                  //               child: Text(
                  //                   '(*) Nếu bạn chưa tìm thấy tên con mình. Vui lòng nhập tên và ngày sinh của con bạn!'),
                  //             ),
                  //             Form(
                  //               key: _formKey,
                  //               child: Column(
                  //                 children: <Widget>[
                  //                   Padding(
                  //                     padding:
                  //                         EdgeInsets.only(left: 50, right: 50),
                  //                     child: TextFormField(
                  //                       decoration: InputDecoration(
                  //                         suffixIcon:
                  //                             Icon(Icons.account_circle),
                  //                         hintText: 'Họ và tên',
                  //                       ),
                  //                       validator: (value) {
                  //                         if (value.isEmpty) {
                  //                           return 'Vui lòng nhập họ tên';
                  //                         }
                  //                         if (value.length < 6) {
                  //                           return 'Họ tên phải trên 6 ký tự';
                  //                         }
                  //                         return null;
                  //                       },
                  //                     ),
                  //                   ),
                  //                   Padding(
                  //                     padding:
                  //                         EdgeInsets.only(left: 50, right: 50),
                  //                     child: DateTimePicker(
                  //                       decoration: InputDecoration(
                  //                         suffixIcon: Icon(Icons.date_range),
                  //                         hintText: 'Ngày Sinh ',
                  //                       ),
                  //                       initialValue: '',
                  //                       icon: Icon(Icons.date_range),
                  //                       firstDate: DateTime(2000),
                  //                       lastDate: DateTime(2100),
                  //                       onChanged: (val) => print(val),
                  //                       validator: (val) {
                  //                         if (val.isEmpty) {
                  //                           return 'Vui lòng chọn ngày sinh';
                  //                         }
                  //                         print(val);
                  //                         return null;
                  //                       },
                  //                       onSaved: (val) => print(val),
                  //                     ),
                  //                   ),
                  //                   Padding(
                  //                     padding: const EdgeInsets.only(top: 10),
                  //                     child: ElevatedButton(
                  //                       onPressed: () {
                  //                         // Validate will return true if the form is valid, or false if
                  //                         // the form is invalid.
                  //                         if (_formKey.currentState
                  //                             .validate()) {
                  //                           // Navigator.push(
                  //                           //   context,
                  //                           //   MaterialPageRoute(
                  //                           //       builder: (context) =>
                  //                           //           HomePageTeacher()),
                  //                           //   // NotificationScreenTeacher()),
                  //                           // );
                  //                         }
                  //                       },
                  //                       child: Text('Tiếp Tục'),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(
                  //             color: Colors.black12,
                  //           ),
                  //           color: Color(0xFFf2f2f2),
                  //         ),
                  //         margin: EdgeInsets.only(top: 5),
                  //       );
                  //     },
                  //     childCount: 1,
                  //   ),
                  // ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        // color: Color(0xFFf2f2f2),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
          ),
          color: Colors.white,
        ),
      ),
    );
  }
}
