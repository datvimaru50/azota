import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(AddClass());
}

class AddClass extends StatefulWidget {
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
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
        title: Text(
          'Thêm lớp',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Tạo lớp mới',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  color: Color(0xff00a7d0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Nhập vào tên lớp',
                      prefixIcon: Icon(Icons.code_sharp),
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
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
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
                              padding:
                                  EdgeInsets.only(top: 15, left: 20, right: 20),
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
                      onPressed: () {},
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
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
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                        },
                        child:
                            Text('HỦY', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  padding:
                      EdgeInsets.only(left: 35, top: 10, bottom: 10, right: 35),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 2.0, color: Colors.black12),
                    ),
                  ),
                )
              ],
            ),
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                width: 2,
                color: Color(0xff00a7d0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
