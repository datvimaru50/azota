import 'dart:async';
import 'dart:io';
import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/view/listClass_teacher.dart';
import 'package:azt/view/groupScreenTeacher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AddClass extends StatefulWidget {
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = new TextEditingController();
  String filePath;
  bool _creatingClass = false;
  Future getFile() async {
    FilePickerResult getFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx', 'xlsm'],
    );
    if (getFile != null) {
      setState(() {
        filePath = getFile.paths.first;
      });
    }
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => GroupScreenTeacher()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        appBar: AppBar(
          title: Text('Thêm lớp học', style: TextStyle(fontSize: 18)),
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              _onBackPressed();
            },
          ),
        ),
        body: ListView(
          children: [
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Tên lớp học* ',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Vui lòng điền đầy đủ thông tin';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 15, bottom: 10),
                      child: Text('Danh sách học sinh',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      child: Text(
                        'Nhập danh sách học sinh trong lớp mà thầy cô đang quản lý vào file Excel và đưa lên hệ thống. Các thông tin cần nhập bao gồm: Họ tên, Ngày sinh, Giới tính. Thầy/Cô có thể tải file biểu mẫu bên dưới để nhập danh sách học sinh',
                      ),
                    ),
                    Container(
                      child: Container(
                        child: DottedBorder(
                          color: Colors.blue,
                          strokeWidth: 1,
                          child: TextButton(
                            onPressed: getFile,
                            child: filePath != null
                                ? Column(
                                    children: [
                                      Icon(
                                        Icons.cloud_upload,
                                        color: Colors.blue,
                                      ),
                                      Container(
                                        child: DottedBorder(
                                          color: Colors.blue,
                                          strokeWidth: 1,
                                          child: Column(
                                            children: [
                                              Image.network(
                                                'https://azota.vn/assets/images/excel.png',
                                                width: 120,
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                child: Text(
                                                  filePath.split('/').last,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              // ignore: deprecated_member_use
                                              FlatButton(
                                                color: Colors.red,
                                                onPressed: () {
                                                  setState(() {
                                                    filePath = null;
                                                  });
                                                },
                                                child: Text(
                                                  'Xóa',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        color: Color(0xFFecf0f5),
                                        margin: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            bottom: 20,
                                            top: 10),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Icon(
                                        Icons.cloud_upload,
                                        color: Colors.blue,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 20, right: 20),
                                        child: Text(
                                          'Chưa có file được chọn\n' +
                                              'Click để chọn File',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        color: Color.fromRGBO(27, 171, 161, .05),
                        // margin: EdgeInsets.all(10),
                      ),
                      margin: EdgeInsets.only(left: 30, right: 30),
                    ),
                    GestureDetector(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            launch(
                                'https://azota.vn/assets/medias/excel_add_students_exp.xlsx');
                          },
                          child: Text(
                            'Tải file biểu mẫu',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        Icon(Icons.save_alt),
                      ],
                    )),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: _creatingClass ? null : () async {
                              if (_formKey.currentState.validate()) {
                                try{
                                  setState(() {
                                    _creatingClass = true;
                                  });
                                  if (filePath != null){
                                    await ClassroomController.addClassRoom(className: name.text, filePath: filePath);
                                  } else {
                                    await ClassroomController.addClassRoom(className: name.text);
                                  }
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => GroupScreenTeacher()),
                                          (Route<dynamic> route) => false);
                                }catch(err){
                                  setState(() {
                                    _creatingClass = false;
                                  });
                                  Fluttertoast.showToast(msg: err.toString(), backgroundColor: Colors.green);
                                }

                              }
                            },
                            child: Text(
                              'TẠO LỚP',
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.yellow[800],
                            ),
                            onPressed: () {
                              _onBackPressed();
                            },
                            child: Text(
                              'HỦY',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(
                          left: 35, top: 10, bottom: 10, right: 35),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 2.0, color: Colors.black12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              margin: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 15, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  width: 1,
                  color: Color(0xff00a7d0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
