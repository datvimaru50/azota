import 'dart:io';
import 'dart:async';
import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/view/groupScreenTeacher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(AddClass());
}

class AddClass extends StatefulWidget {
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController name = new TextEditingController();

  //upload file
  // ignore: unused_field
  File _image;

  Future getFile() async {
    FilePickerResult getFile = await FilePicker.platform.pickFiles();

    setState(
      () {
        if (getFile != null) {
          PlatformFile file = getFile.files.first;

          _image = File(file.path);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text('Thêm lớp học', style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GroupScreenTeacher()),
            );
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
                        hintText: 'Nhập tên lớp học',
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
                          child: Column(
                            children: [
                              Icon(
                                Icons.cloud_upload,
                                color: Colors.blue,
                              ),
                              Text(
                                'Chưa có file được chọn',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 15, left: 20, right: 20),
                                child: Text(
                                  'Kéo thả file Excel hoặc Click để chọn File',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      color: Color.fromRGBO(27, 171, 161, .05),
                      // margin: EdgeInsets.all(10),
                    ),
                    padding: EdgeInsets.only(top: 15, left: 30, right: 30),
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
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              ClassroomController.addClassRoom(name, context);
                            }
                          },
                          child: Text(
                            'TẠO LỚP',
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupScreenTeacher()),
                            );
                          },
                          child: Text('HỦY',
                              style: TextStyle(color: Colors.black)),
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
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
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
    );
  }
}
