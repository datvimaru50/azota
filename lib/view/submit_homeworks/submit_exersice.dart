import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class SubmitExersice extends StatefulWidget {
  SubmitExersice(
      {this.notiType,
      this.className,
      this.deadline,
      this.score,
      this.submitTime,
      this.token,
      this.answerId,
      this.hashId});

  final String notiType;
  final String className;
  final String score;
  final String deadline;
  final String submitTime;
  final String token;
  final String answerId;
  final String hashId;

  @override
  _SubmitExersiceState createState() => _SubmitExersiceState();
}

class _SubmitExersiceState extends State<SubmitExersice> {
  File _image;
  final picker = ImagePicker();
  var _controllerClear = TextEditingController();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(
      () {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      },
    );
  }

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
    return Column(
      children: [
        Container(
          child: Text(
            'Lớp: 1CN-3',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          padding: EdgeInsets.only(top: 10),
        ),
        Container(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: 'Mã bài tập:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: ' 3vqstm',
                  style: TextStyle(fontSize: 13, color: Colors.blue),
                ),
              ],
            ),
          ),
          padding: EdgeInsets.only(top: 10),
        ),
        Container(
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Hạn nộp: 20/12/2021',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Vũ Quốc Đạt',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                color: Color(0xff00a7d0),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Center(
                        child: DottedBorder(
                          color: Colors.blue,
                          strokeWidth: 1,
                          child: TextButton(
                            onPressed: getImage,
                            child: Container(
                              child: Column(
                                children: [
                                  Icon(Icons.add_a_photo),
                                  Text(
                                    'Chụp ảnh',
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              width: 100,
                            ),
                          ),
                        ),
                      ),
                      width: 100,
                      color: Color.fromRGBO(27, 171, 161, .05),
                    ),
                    Container(
                      child: DottedBorder(
                        color: Colors.blue,
                        strokeWidth: 1,
                        child: TextButton(
                          onPressed: getFile,
                          child: Column(
                            children: [
                              Icon(
                                Icons.attach_file,
                                color: Colors.blue,
                              ),
                              Text(
                                'Chọn file (Hỗ trợ Ảnh và Video hoặc Audio)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      width: 100,
                      color: Color.fromRGBO(27, 171, 161, .05),
                      // margin: EdgeInsets.all(10),
                    ),
                  ],
                ),
                padding:
                    EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 20),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: _image == null
                          ? Text('')
                          : Container(
                              child: Image.file(_image),
                            ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 30, right: 30),
                      color: Colors.white,
                    ),

                    // TextButton(onPressed: _image, child: Text('xóa'))
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                },
                child: Text(
                  'NỘP BÀI',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
