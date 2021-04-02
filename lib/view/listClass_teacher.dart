import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/models/core_mo.dart';
import 'package:azt/view/addClass.dart';
import 'package:azt/view/detailClass_teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(ListClass());
}

class ListClass extends StatefulWidget {
  @override
  _ListClassState createState() => _ListClassState();
}

class _ListClassState extends State<ListClass> {
  Future<ClassroomHashIdInfo> classroomHashIdInfo;
  Future<ClassroomHashIdInfo> deleteClassroom;
  @override
  void initState() {
    super.initState();
    classroomHashIdInfo = ClassroomController.getClassroomkInfo();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        appBar: AppBar(
          title: Text('Danh sách lớp'),
        ),
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
                    margin: EdgeInsets.only(top: 10, left: 25, right: 25),
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
                                GestureDetector(
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
                                                    deleteClassroom =
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
                                      animationType: DialogTransitionType.size,
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(seconds: 1),
                                    );
                                  },
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailClass(
                                          id: item['id'].toString(),
                                          countStudents:
                                              item['countStudents'].toString(),
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
                                                  alignment: Alignment.topLeft,
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
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    item['homeworkId'] == 0
                                                        ? 'Sĩ số: ${item['countStudents']}'
                                                        : 'Sĩ số: ${item['countStudents']}  Hạn nộp: ${DateFormat.yMd().format(DateTime.parse(item["deadline"]))}',
                                                    style: TextStyle(
                                                        color: Colors.black45),
                                                  ),
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                )
                                              ],
                                            ),
                                            color: Colors.white,
                                            padding: EdgeInsets.only(left: 15),
                                          ),
                                        )
                                      ],
                                    ),
                                    margin: EdgeInsets.only(
                                        left: 25, right: 25, top: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
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
