import 'dart:async';
import 'package:azt/config/global.dart';
import 'package:azt/controller/homework_controller.dart';
import 'package:azt/controller/update_controller.dart';
import 'package:azt/view/groupScreenStudent.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:azt/models/core_mo.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChooseStudent extends StatefulWidget {
  ChooseStudent({Key key, @required this.hashId}) : super(key: key);
  final String hashId;

  @override
  _ChooseStudentState createState() => _ChooseStudentState();
}

class _ChooseStudentState extends State<ChooseStudent> {
  Future<HomeworkHashIdInfo> homeworkHashIdInfo;
  TextEditingController fullName = new TextEditingController();
  TextEditingController birthday = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int gender;
  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Prefs.deletePref();
    Navigator.pop(
      context,
    );
  }

  Future<void> _showErrorToast(String errMsg) async {
    return Fluttertoast.showToast(
        msg: errMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    super.initState();
    homeworkHashIdInfo = HomeworkController.getHomeworkInfo(widget.hashId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text('Chọn học sinh', style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _onBackPressed,
        ),
      ),
      body: ListView(
        children: [
          FutureBuilder<HomeworkHashIdInfo>(
            future: homeworkHashIdInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Lớp: ' + snapshot.data.classroomObj['name'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Mã bài tập: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: snapshot.data.homeworkObj["hashId"]
                                  .toString(),
                              style:
                                  TextStyle(fontSize: 13, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.only(top: 10),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Container();
              }
              return Center();
            },
          ),
          FutureBuilder<HomeworkHashIdInfo>(
            future: homeworkHashIdInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Bài tập ngày: ${DateFormat.yMd().format(DateTime.parse(snapshot.data.homeworkObj['createdAt']))}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Hạn nộp: ' +
                                      DateFormat.yMd().format(DateTime.parse(
                                          snapshot
                                              .data.homeworkObj['deadline'])),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        color: Color(0xff00a7d0),
                      ),
                      GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        childAspectRatio: 3,
                        crossAxisCount: 2,
                        children: [
                          ...snapshot.data.studentObjs.map(
                            (dynamic item) => GestureDetector(
                              onTap: () {
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return ClassicGeneralDialogWidget(
                                      titleText: item['fullName'],
                                      contentText:
                                          'Bạn có chắc đây là con của bạn?',
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                            'Hủy Chọn',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'Tiếp Tục',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          onPressed: () async {
                                            try {
                                              await Prefs.savePrefs(
                                                  HASH_ID, widget.hashId);
                                              var stdID = item['id'];

                                              await HomeworkController
                                                  .updateParent(
                                                      stdID.toString());

                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              // ignore: missing_required_param
                                                              GroupScreenStudent()),
                                                      (Route<dynamic> route) =>
                                                          false);
                                            } catch (err) {
                                              _showErrorToast(err.toString());
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                  animationType: DialogTransitionType.size,
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(seconds: 1),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: InkWell(
                                  child: Text(
                                    item['fullName'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                margin:
                                    EdgeInsets.only(top: 7, left: 5, right: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  color: Color(0xFFfafafa),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      snapshot.data.classroomObj['showAddStudent'] == 1
                          ? Container(
                              alignment: Alignment.center,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      child: Text(
                                        '(*) Nếu bạn chưa tìm thấy tên con mình. Vui lòng nhập tên và ngày sinh của con bạn!',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      child: TextFormField(
                                        controller: fullName,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Họ tên học sinh*',
                                        ),
                                        autofocus: false,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Vui lòng điền họ tên học sinh';
                                          }
                                          return null;
                                        },
                                      ),
                                      margin: EdgeInsets.only(
                                          top: 15,
                                          left: 30,
                                          right: 30,
                                          bottom: 15),
                                    ),
                                    Container(
                                      child: Container(
                                        child: DateTimePicker(
                                          controller: birthday,
                                          decoration: InputDecoration(
                                            suffixIcon: Icon(Icons.event),
                                            border: OutlineInputBorder(),
                                            labelText: 'Ngày sinh*',
                                          ),
                                          dateMask: 'dd/MM/yyyy',
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                          icon: Icon(Icons.event),
                                          dateLabelText: 'Ngày',
                                          onChanged: (value) => print(value),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Vui lòng chọn ngày sinh';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => print(value),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(
                                        left: 30,
                                        right: 30,
                                      ),
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            UpdateController.saveNewStudent(
                                                widget.hashId,
                                                fullName.text,
                                                birthday.text,
                                                context);
                                          }
                                        },
                                        child: Text(
                                          'TIẾP TỤC',
                                        ),
                                      ),
                                      margin: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                    )
                                  ],
                                ),
                              ),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0, color: Colors.black26),
                                ),
                                color: Color(0xfff2f2f2),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      width: 1,
                      color: Color(0xff00a7d0),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: 10, left: 30, right: 30),
                        child: Text(
                          'Mã bài tập không tồn tại, vui lòng kiểm tra lại.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      // ignore: deprecated_member_use
                      FlatButton.icon(
                        color: Colors.blue,
                        onPressed: () {
                          Prefs.deletePref();
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                        label: Text(
                          'Thử Lại',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Center(
                child: Container(
                  child: CircularProgressIndicator(),
                  margin: EdgeInsets.all(20),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
