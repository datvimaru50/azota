import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/models/core_mo.dart';
import 'package:azt/view/addStudents.dart';
import 'package:azt/view/detailClass_teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(ListStudents());
}

class ListStudents extends StatefulWidget {
  ListStudents({
    this.id,
    this.className,
  });
  final String id;
  final String className;
  @override
  _ListStudentsState createState() => _ListStudentsState();
}

class _ListStudentsState extends State<ListStudents> {
  Future<ClassroomHashIdInfo> classroomHashIdInfo;
  Future<ClassroomHashIdInfo> deleteStudent;
  int i = 1;
  @override
  void initState() {
    super.initState();
    classroomHashIdInfo = ClassroomController.studentClassroom(widget.id);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ignore: deprecated_member_use
                // FlatButton.icon(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => DetailClass(
                //               id: widget.id, className: widget.className)),
                //     );
                //   },
                //   label: Text('Quay lại'),
                //   icon: Icon(Icons.keyboard_arrow_left),
                // ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_left),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailClass(
                              id: widget.id, className: widget.className)),
                    );
                  },
                ),
                Text('Lớp: ${widget.className}'),
                IconButton(
                  icon: Icon(
                    Icons.nat,
                    color: Colors.white,
                  ),
                  onPressed: null,
                )
              ],
            ),
            margin: EdgeInsets.only(left: 10, right: 10),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddStudent(
                        classRoomId: widget.id, className: widget.className)),
              );
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '+ Thêm học sinh',
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
          Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Danh Sách Học Sinh',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  color: Color(0xff00a7d0),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 60,
                        child: Text(
                          'STT',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            'Họ Tên',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 85,
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          'Hành động',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2.0, color: Colors.black12),
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
                            (dynamic item) => Container(
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 60,
                                    child: Text(
                                      '${i++}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            item['fullName'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            // ignore: unrelated_type_equality_checks
                                            item['gender'].toString() != '0'
                                                ? 'Giới tính: Nữ'
                                                : 'Giới tính: Nam',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Ngày sinh: ' +
                                                DateFormat.yMd().format(
                                                    DateTime.parse(
                                                        item['birthday'])),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 40,
                                    // ignore: missing_required_param
                                    child: IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return ClassicGeneralDialogWidget(
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ListStudents(
                                                                id: widget.id,
                                                                className: widget
                                                                    .className),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    // color: Colors.black,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Sửa thông tin học sinh',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    showAnimatedDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return ClassicGeneralDialogWidget(
                                                          titleText:
                                                              'Bạn có chắc chắn',
                                                          actions: [
                                                            // ignore: deprecated_member_use
                                                            FlatButton(
                                                              onPressed: () {
                                                                setState(
                                                                  () {
                                                                    deleteStudent = ClassroomController.deleteStudent(
                                                                        item['id']
                                                                            .toString(),
                                                                        context,
                                                                        item['classroomId']
                                                                            .toString(),
                                                                        widget
                                                                            .className);
                                                                  },
                                                                );
                                                              },
                                                              child:
                                                                  Text('Xóa'),
                                                              color: Colors.red,
                                                            ),
                                                            // ignore: deprecated_member_use
                                                            FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text('Hủy'),
                                                              color: Colors
                                                                  .black38,
                                                            )
                                                          ],
                                                        );
                                                      },
                                                      animationType:
                                                          DialogTransitionType
                                                              .size,
                                                      curve:
                                                          Curves.fastOutSlowIn,
                                                      duration:
                                                          Duration(seconds: 1),
                                                    );
                                                  },
                                                  child: Container(
                                                    // color: Colors.black,
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Xóa học sinh',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                item['parentId'] == 0
                                                    ? null
                                                    : TextButton(
                                                        onPressed: () {
                                                          showAnimatedDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return ClassicGeneralDialogWidget(
                                                                titleText:
                                                                    'Bạn có chắc chắn',
                                                                actions: [
                                                                  // ignore: deprecated_member_use
                                                                  FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      // setState(
                                                                      //   () {
                                                                      //     deleteClassroom =
                                                                      //         ClassroomController
                                                                      //             .deleteClassroom(
                                                                      //                 widget.id, context);
                                                                      //   },
                                                                      // );
                                                                    },
                                                                    child: Text(
                                                                        'Xóa'),
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  // ignore: deprecated_member_use
                                                                  FlatButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Hủy'),
                                                                    color: Colors
                                                                        .black38,
                                                                  )
                                                                ],
                                                              );
                                                            },
                                                            animationType:
                                                                DialogTransitionType
                                                                    .size,
                                                            curve: Curves
                                                                .fastOutSlowIn,
                                                            duration: Duration(
                                                                seconds: 1),
                                                          );
                                                        },
                                                        child: Container(
                                                          // color: Colors.black,
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            'Xóa phụ huynh',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
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
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: Colors.black12),
                                ),
                              ),
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        margin: EdgeInsets.all(20),
                        child: Text('Danh sách học sinh trống'),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
            margin: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Colors.blue,
              ),
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
