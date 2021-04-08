import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/models/core_mo.dart';
import 'package:azt/view/addClass.dart';
import 'package:azt/view/detailClass_teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(ListClass());
}

class ListClass extends StatefulWidget {
  @override
  _ListClassState createState() => _ListClassState();
}

class _ListClassState extends State<ListClass> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name;

  Future<ClassroomHashIdInfo> classroomHashIdInfo;
  @override
  void initState() {
    super.initState();
    classroomHashIdInfo = ClassroomController.getClassroomkInfo();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        body: ListView(
          children: [
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddClass()),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '+ Thêm lớp',
                      style: TextStyle(color: Colors.blue),
                    ),
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(
                      top: 10,
                      left: 25,
                      right: 25,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.black12,
                      ),
                    ),
                  ),
                ),
                FutureBuilder<ClassroomHashIdInfo>(
                  future: classroomHashIdInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          ...snapshot.data.data.map(
                            (dynamic item) => Column(
                              children: [
                                SizedBox(height: 15),
                                Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: GestureDetector(
                                    onLongPress: () {
                                      showAnimatedDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return ClassicGeneralDialogWidget(
                                            titleText: 'Bạn có chắc chắn',
                                            actions: [
                                              // ignore: deprecated_member_use
                                              FlatButton(
                                                onPressed: () {
                                                  setState(
                                                    () {
                                                      ClassroomController
                                                          .deleteClassroom(
                                                        item['id'].toString(),
                                                        context,
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text('Xóa'),
                                                color: Colors.red,
                                              ),
                                              // ignore: deprecated_member_use
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Hủy'),
                                                color: Colors.black38,
                                              )
                                            ],
                                          );
                                        },
                                        animationType:
                                            DialogTransitionType.size,
                                        curve: Curves.fastOutSlowIn,
                                        duration: Duration(seconds: 1),
                                      );
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailClass(
                                            idClassroom: item['id'].toString(),
                                            countStudents: item['countStudents']
                                                .toString(),
                                            className: item['name'].toString(),
                                            homeworkId:
                                                item['homeworkId'].toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              item['homeworkId'] == 0
                                                  ? 'Chưa giao bài'
                                                  : 'Đã nộp bài\n${item['countAnswers']}/${item['countStudents']}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            padding: EdgeInsets.all(10),
                                            color: Color(0xff00c0ef),
                                            width: 85,
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      item['name'],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      item['homeworkId'] == 0
                                                          ? 'Sĩ số: ${item['countStudents']}'
                                                          : 'Sĩ số: ${item['countStudents']}  Hạn nộp: ${DateFormat.yMd().format(DateTime.parse(item["deadline"]))}',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    padding:
                                                        EdgeInsets.only(top: 5),
                                                  )
                                                ],
                                              ),
                                              color: Colors.white,
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                      margin:
                                          EdgeInsets.only(left: 25, right: 25),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // actions: <Widget>[
                                  //   IconSlideAction(
                                  //     caption: 'Archive',
                                  //     color: Colors.blue,
                                  //     icon: Icons.archive,
                                  //     onTap: () => () {},
                                  //   ),
                                  //   IconSlideAction(
                                  //     caption: 'Share',
                                  //     color: Colors.indigo,
                                  //     icon: Icons.share,
                                  //     onTap: () => () {},
                                  //   ),
                                  // ],
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Sửa',
                                      color: Colors.black45,
                                      icon: Icons.edit,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: new Text(
                                                  "Chỉnh sửa thông tin lớp học"),
                                              actions: <Widget>[
                                                Container(
                                                  width: 300,
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 15),
                                                  child: Form(
                                                    key: _formKey,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            'Tên lớp học:',
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            'Nhắc nhở: Tên lớp học không được chứa ký tự đặc biệt',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black38),
                                                          ),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 10,
                                                                  top: 15),
                                                        ),
                                                        TextFormField(
                                                          controller: name =
                                                              new TextEditingController(
                                                                  text: item[
                                                                          'name']
                                                                      .toString()),
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Tên lớp học*',
                                                            hintText:
                                                                'Nhập vào tên lớp',
                                                          ),
                                                          validator: (value) {
                                                            if (value.isEmpty) {
                                                              return 'Vui lòng điền đầy đủ thông tin';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  if (_formKey
                                                                      .currentState
                                                                      .validate()) {
                                                                    ClassroomController.updateClassroom(
                                                                        item['id']
                                                                            .toString(),
                                                                        name,
                                                                        item['countStudents']
                                                                            .toString(),
                                                                        item['homeworkId']
                                                                            .toString(),
                                                                        item['homeworks']
                                                                            .toString(),
                                                                        context);
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'SỬA',
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary: Colors
                                                                      .white,
                                                                ),
                                                                onPressed: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ListClass(),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Text(
                                                                    'HỦY',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black)),
                                                              ),
                                                            ],
                                                          ),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconSlideAction(
                                      caption: 'Xóa',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return ClassicGeneralDialogWidget(
                                              titleText: 'Bạn có chắc chắn',
                                              actions: [
                                                // ignore: deprecated_member_use
                                                FlatButton(
                                                  onPressed: () {
                                                    setState(
                                                      () {
                                                        ClassroomController
                                                            .deleteClassroom(
                                                          item['id'].toString(),
                                                          context,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text('Xóa'),
                                                  color: Colors.red,
                                                ),
                                                // ignore: deprecated_member_use
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Hủy'),
                                                  color: Colors.black38,
                                                )
                                              ],
                                            );
                                          },
                                          animationType:
                                              DialogTransitionType.size,
                                          curve: Curves.fastOutSlowIn,
                                          duration: Duration(seconds: 1),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
