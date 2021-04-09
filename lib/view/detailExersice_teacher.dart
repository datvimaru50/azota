import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/controller/homework_controller.dart';
import 'package:azt/models/core_mo.dart';
import 'package:azt/view/detailClass_teacher.dart';
import 'package:azt/view/editExersice.dart';
import 'package:azt/view/listStudents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

enum SubmitStatus { notSubmitted, notMarked, marked }

class DetailExersice extends StatefulWidget {
  DetailExersice({
    this.homeworkId,
    this.exerciseId,
    this.content,
    this.countStudents,
    this.className,
    this.homeworks,
    this.idClassroom,
    this.idExersice,
    this.deadline,
  });
  final String homeworkId;
  final String exerciseId;
  final String content;
  final String countStudents;
  final String className;
  final String homeworks;
  final String idClassroom;
  final String idExersice;
  final String deadline;
  @override
  _DetailExersiceState createState() => _DetailExersiceState();
}

class _DetailExersiceState extends State<DetailExersice> {
  final _formKey = GlobalKey<FormState>();
  final noteText = TextEditingController();
  bool status = false;
  bool isSubmitDateDecending = false;
  Future<List<dynamic>> classroomHashIdInfo;

  Future<AnswerHashIdInfo> submitedStudents;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'vi_VN';
    initializeDateFormatting();
    submitedStudents = ClassroomController.answerStudent(widget.exerciseId);

    classroomHashIdInfo = ClassroomController.studentClassroom(
        id: widget.idClassroom); // list all student
  }

  Future<void> _showMyDialog(int studentId) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gửi yêu cầu nộp lại'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text('Nhập lý do yêu cầu nộp lại'),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: noteText,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Ghi chú',
                          prefixIcon: Icon(Icons.phone_android_outlined),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Vui lòng nêu lý do yêu cầu nộp lại';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  try {
                    await HomeworkController.requestResubmitAnswer({
                      "id": studentId.toString(),
                      "resendNote": noteText.text
                    });
                    Navigator.pop(context);
                    // reload
                    setState(() {
                      submitedStudents =
                          ClassroomController.answerStudent(widget.exerciseId);
                    });
                  } catch (err) {
                    Fluttertoast.showToast(
                        msg: err.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void markExercise() {}

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailClass(
                  idClassroom: widget.idClassroom,
                  className: widget.className,
                  countStudents: widget.countStudents,
                  homeworkId: widget.homeworkId,
                  homeworks: widget.homeworks,
                ),
              ),
            );
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 15, right: 20, top: 10),
                  child: Html(
                    data:
                        """<div>${widget.content == '' ? 'Không có nội dung' : widget.content}</div>""",
                    style: {
                      "div": Style(
                        color: Colors.black,
                      ),
                    },
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ignore: deprecated_member_use
                      RaisedButton.icon(
                        onPressed: () {
                          print('Button Clicked.');
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        label: Text(
                          'COPY LINK',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        icon: Icon(Icons.copy_sharp, color: Colors.black),
                        textColor: Colors.white,
                        splashColor: Colors.red,
                        color: Colors.white,
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton.icon(
                        onPressed: () {
                          print('Button Clicked.');
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        label: Text(
                          'GỬI ZALO',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        icon: Icon(Icons.share, color: Colors.white),
                        textColor: Colors.white,
                        splashColor: Colors.red,
                        color: Colors.lightBlueAccent,
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.more_vert_outlined),
                          onPressed: () {
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return ClassicGeneralDialogWidget(
                                  actions: [
                                    Container(
                                      width: 300,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    var editExersice =
                                                        EditExersice(
                                                      deadline: widget.deadline,
                                                      exerciseId:
                                                          widget.exerciseId,
                                                      content: widget.content,
                                                      countStudents:
                                                          widget.countStudents,
                                                      className:
                                                          widget.className,
                                                      homeworkId:
                                                          widget.homeworkId,
                                                      homeworks:
                                                          widget.homeworks,
                                                      idClassroom:
                                                          widget.idClassroom,
                                                      idExersice:
                                                          widget.idExersice,
                                                    );
                                                    return editExersice;
                                                  },
                                                ),
                                              );
                                            },
                                            child: Container(
                                              // color: Colors.black,
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Sửa',
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
                                                builder:
                                                    (BuildContext context) {
                                                  return ClassicGeneralDialogWidget(
                                                    titleText:
                                                        'Bạn có chắc chắn',
                                                    actions: [
                                                      // ignore: deprecated_member_use
                                                      FlatButton(
                                                        onPressed: () {
                                                          setState(
                                                            () {
                                                              ClassroomController
                                                                  .deleteExersice(
                                                                widget
                                                                    .countStudents,
                                                                widget
                                                                    .className,
                                                                widget
                                                                    .homeworkId,
                                                                widget
                                                                    .homeworks,
                                                                widget
                                                                    .idClassroom,
                                                                idExersice: widget
                                                                    .idExersice,
                                                                context:
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
                                                          Navigator.of(context)
                                                              .pop();
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
                                            child: Container(
                                              // color: Colors.black,
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Xóa',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                              animationType: DialogTransitionType.size,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 1),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20),
                ),
                Container(
                  child: Text(
                    'Gửi bài tập qua nhóm Zalo để phụ huynh / học sinh có thể nộp bài online',
                    style: TextStyle(fontSize: 13),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.5, color: Colors.black12),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                ),
                Container(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Ngày nộp bài giảm dần '),
                              FlutterSwitch(
                                width: 47.0,
                                height: 22.0,
                                valueFontSize: 13.0,
                                toggleSize: 13.0,
                                value: isSubmitDateDecending,
                                borderRadius: 30.0,
                                padding: 4.0,
                                showOnOff: true,
                                onToggle: (val) {
                                  setState(() {
                                    isSubmitDateDecending = val;
                                    classroomHashIdInfo =
                                        ClassroomController.studentClassroom(
                                            id: widget.idClassroom);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Chỉ hiện những bài chưa chấm '),
                              FlutterSwitch(
                                width: 47.0,
                                height: 22.0,
                                valueFontSize: 13.0,
                                toggleSize: 13.0,
                                value: status,
                                borderRadius: 30.0,
                                padding: 4.0,
                                showOnOff: true,
                                onToggle: (val) {
                                  setState(() {
                                    status = val;
                                    classroomHashIdInfo =
                                        ClassroomController.studentClassroom(
                                            id: widget.idClassroom);
                                  });
                                },
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(bottom: 10, top: 5),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 1.5, color: Colors.black12),
                            ),
                          ),
                        ),
                        FutureBuilder<AnswerHashIdInfo>(
                          future: submitedStudents,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // Xử lý if-else
                              var submittedData = snapshot.data.dataAnswer;

                              // Check submit status
                              SubmitStatus checkSubmitStatus(int studentId) {
                                var result = SubmitStatus.notSubmitted;

                                if (submittedData.isEmpty) {
                                  return result;
                                }

                                for (var i = 0; i < submittedData.length; i++) {
                                  if (submittedData.elementAt(i)["studentId"] ==
                                      studentId) {
                                    if (submittedData
                                            .elementAt(i)["confirmedAt"] ==
                                        null) {
                                      result = SubmitStatus.notMarked;
                                    } else {
                                      result = SubmitStatus.marked;
                                    }

                                    break;
                                  }
                                }
                                return result;
                              }

                              // Get answer ID
                              dynamic getAnswerId(int studentId) {
                                var result;
                                if (submittedData.isEmpty) {
                                  return result;
                                }

                                for (var i = 0; i < submittedData.length; i++) {
                                  if (submittedData.elementAt(i)["studentId"] ==
                                      studentId) {
                                    result = submittedData.elementAt(i)["id"];
                                    break;
                                  }
                                }
                                return result;
                              }

                              // Get submitDate
                              DateTime getSubmitDate(
                                  {@required int studentId}) {
                                var result = DateTime.parse(
                                    "1900-04-07T15:04:14"); // along time ago: 17/04/1900

                                if (submittedData.isEmpty) {
                                  return result;
                                }
                                for (var i = 0; i < submittedData.length; i++) {
                                  if (submittedData.elementAt(i)["studentId"] ==
                                      studentId) {
                                    result = DateTime.parse(submittedData
                                        .elementAt(i)["updatedAt"]);
                                    break;
                                  }
                                }
                                return result;
                              }

                              return FutureBuilder<List<dynamic>>(
                                future: classroomHashIdInfo,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var arr = snapshot.data;
                                    if (status) {
                                      arr = snapshot.data
                                          .where((item) =>
                                              checkSubmitStatus(item["id"]) ==
                                              SubmitStatus.notMarked)
                                          .toList();
                                    }
                                    if (isSubmitDateDecending) {
                                      arr.sort((a, b) =>
                                          getSubmitDate(studentId: b["id"])
                                              .compareTo(getSubmitDate(
                                                  studentId: a["id"])));
                                    }
                                    return snapshot.data.length.toString() ==
                                            '0'
                                        ? Container(
                                            child: Column(
                                              children: [
                                                Text(
                                                    'Không có dữ liệu học sinh ! '),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ListStudents(
                                                          id: widget
                                                              .idClassroom,
                                                          className:
                                                              widget.className,
                                                          countStudents: widget
                                                              .countStudents,
                                                          homeworkId:
                                                              widget.homeworkId,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'Tạo học sinh ngay.',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            margin: EdgeInsets.all(20),
                                          )
                                        : Column(
                                            children: [
                                              ...arr.map(
                                                (dynamic item) => Column(
                                                  children: [
                                                    Container(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child: Text(
                                                                          item[
                                                                              'fullName']),
                                                                    ),
                                                                    checkSubmitStatus(item["id"]) ==
                                                                            SubmitStatus.notSubmitted
                                                                        ? Container()
                                                                        : Container(
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            child:
                                                                                Text(
                                                                              DateTimeFormat.relative(DateTime.parse(item["updatedAt"]), relativeTo: DateTime.now(), levelOfPrecision: 1, appendIfAfter: ' ago', abbr: true),
                                                                              style: TextStyle(
                                                                                color: Colors.black26,
                                                                              ),
                                                                            ),
                                                                            margin:
                                                                                EdgeInsets.only(
                                                                              top: 3,
                                                                              bottom: 3,
                                                                            ),
                                                                          ),
                                                                    getAnswerId(item["id"]) ==
                                                                            null
                                                                        ? Container()
                                                                        : GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _showMyDialog(getAnswerId(item["id"]));
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Text(
                                                                                'Yêu cầu nộp lại',
                                                                                style: TextStyle(
                                                                                  color: Colors.blue,
                                                                                ),
                                                                              ),
                                                                            ))
                                                                  ],
                                                                ),
                                                                width: 120,
                                                              ),
                                                              ElevatedButton(
                                                                child: Text(checkSubmitStatus(item[
                                                                            "id"]) ==
                                                                        SubmitStatus
                                                                            .notSubmitted
                                                                    ? 'Chưa nộp'
                                                                    : checkSubmitStatus(item["id"]) ==
                                                                            SubmitStatus.marked
                                                                        ? 'Chấm lại'
                                                                        : 'Chấm bài'),
                                                                onPressed: checkSubmitStatus(item[
                                                                            "id"]) ==
                                                                        SubmitStatus
                                                                            .notSubmitted
                                                                    ? null
                                                                    : checkSubmitStatus(item["id"]) ==
                                                                            SubmitStatus.notMarked
                                                                        ? markExercise
                                                                        : markExercise,
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary: checkSubmitStatus(item[
                                                                              "id"]) ==
                                                                          SubmitStatus
                                                                              .marked
                                                                      ? Colors
                                                                          .blueGrey
                                                                          .shade800
                                                                      : Colors
                                                                          .yellow
                                                                          .shade800,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                              width: 1.5,
                                                              color: Colors
                                                                  .black12),
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          top: 10, bottom: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                  } else if (snapshot.hasError) {
                                    return Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text('Không có dữ liệu...'),
                                    );
                                  }

                                  // By default, show a loading spinner.
                                  return Container(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Text('Không có dữ liệu...');
                            }
                            return Container(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 15),
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                  ),
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.5, color: Colors.black12),
                    ),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 2,
                color: Colors.blue.shade200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
