import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:azt/view/detailClass_teacher.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(AddExersice());
}

class AddExersice extends StatefulWidget {
  AddExersice({
    this.id,
    this.countStudents,
    this.className,
    this.homeworkId,
    this.homeworks,
  });
  final String id;
  final String countStudents;
  final String className;
  final String homeworkId;
  final String homeworks;
  @override
  _AddExersiceState createState() => _AddExersiceState();
}

class _AddExersiceState extends State<AddExersice> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController deadline = new TextEditingController();
  TextEditingController content = new TextEditingController();

  Future addExersice() async {
    final token = await Prefs.getPref(ACCESS_TOKEN);
    Map mapdata = <String, String>{
      "name": "Bài Tập ",
      "content": content.text,
      "classroomId": widget.id,
      "deadline": deadline.text,
    };
    //log data in form
    // ignore: unnecessary_brace_in_string_interps
    print("JSON DATA : ${mapdata}");
    final reponse = await http.Client().post(
      AZO_HOMEWORK_SAVE,
      body: jsonEncode(mapdata),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.authorizationHeader: "Bearer " + token,
      },
    );
    var data = jsonDecode(reponse.body);
    if (data['success'] == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailClass(
            idClassroom: widget.id,
            countStudents: widget.countStudents,
            className: widget.className,
            homeworks: widget.homeworks,
            homeworkId: widget.homeworkId,
          ),
        ),
      );
      return Fluttertoast.showToast(
          msg: 'Tạo bài tập thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      return Fluttertoast.showToast(
          msg: 'Tạo bài tập không thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text('Thêm bài tập', style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailClass(
                  idClassroom: widget.id,
                  countStudents: widget.countStudents,
                  className: widget.className,
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
            child: Form(
              key: _formKey,
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
                  Container(
                    child: DateTimePicker(
                      controller: deadline,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.event,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Chọn thời hạn nộp bài tập* ',
                        hintText: 'Chọn thời hạn nộp ',
                      ),
                      dateMask: 'dd/MM/yyyy',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: Icon(Icons.event),
                      dateLabelText: 'Ngày',
                      onChanged: (value) => print(value),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Vui lòng chọn thời hạn nộp bài tập';
                        }
                        return null;
                      },
                      onSaved: (value) => print(value),
                    ),
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 15,
                      bottom: 10,
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: content,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nội dung bài tập* ',
                        hintText: 'Nhập nội dung bài tập',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Vui lòng điền nội dung bài tập';
                        }
                        return null;
                      },
                    ),
                    margin: EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '+ Thêm file bài tập',
                        style: TextStyle(color: Colors.blue),
                      ),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black38),
                        ),
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '+ Chọn từ ngân hàng đê thi',
                        style: TextStyle(color: Colors.blue),
                      ),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.black38),
                        ),
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              addExersice();
                            }
                          },
                          child: Text(
                            'THÊM BÀI TẬP',
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
                                builder: (context) => DetailClass(
                                  idClassroom: widget.id,
                                  countStudents: widget.countStudents,
                                  className: widget.className,
                                  homeworks: widget.homeworks,
                                  homeworkId: widget.homeworkId,
                                ),
                              ),
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
                        top: BorderSide(width: 1.5, color: Colors.black38),
                      ),
                    ),
                  )
                ],
              ),
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

// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:azt/config/connect.dart';
// import 'package:azt/config/global.dart';
// import 'package:azt/view/detailClass_teacher.dart';
// import 'package:date_time_picker/date_time_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:html_editor_enhanced/html_editor.dart';

// void main() {
//   runApp(AddExersice());
// }

// class AddExersice extends StatefulWidget {
//   AddExersice({
//     this.id,
//     this.countStudents,
//     this.className,
//     this.homeworkId,
//     this.homeworks,
//   });
//   final String id;
//   final String countStudents;
//   final String className;
//   final String homeworkId;
//   final String homeworks;
//   @override
//   _AddExersiceState createState() => _AddExersiceState();
// }

// class _AddExersiceState extends State<AddExersice> {
//   final _formKey = GlobalKey<FormState>();
//   HtmlEditorController content = new HtmlEditorController();
//   TextEditingController deadline = new TextEditingController();

//   Future addExersice() async {
//     final token = await Prefs.getPref(ACCESS_TOKEN);
//     final textContent = await content.getText();
//     Map mapdata = <String, String>{
//       "name": "Bài Tập ",
//       "content": textContent,
//       "classroomId": widget.id,
//       "deadline": deadline.text,
//     };
//     //log data in form
//     // ignore: unnecessary_brace_in_string_interps
//     print("JSON DATA : ${mapdata}");
//     final reponse = await http.Client().post(
//       AZO_HOMEWORK_SAVE,
//       body: jsonEncode(mapdata),
//       headers: {
//         HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
//         HttpHeaders.authorizationHeader: "Bearer " + token,
//       },
//     );
//     var data = jsonDecode(reponse.body);
//     if (data['success'] == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DetailClass(
//             id: widget.id,
//             countStudents: widget.countStudents,
//             className: widget.className,
//             homeworks: widget.homeworks,
//             homeworkId: widget.homeworkId,
//           ),
//         ),
//       );
//       return Fluttertoast.showToast(
//           msg: 'Tạo bài tập thành công',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIos: 1,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     } else {
//       return Fluttertoast.showToast(
//           msg: 'Tạo bài tập không thành công',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIos: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFecf0f5),
//       appBar: AppBar(
//         title: Text('Thêm bài tập', style: TextStyle(fontSize: 18)),
//         leading: IconButton(
//           icon: Icon(Icons.keyboard_arrow_left),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DetailClass(
//                   id: widget.id,
//                   countStudents: widget.countStudents,
//                   className: widget.className,
//                   homeworks: widget.homeworks,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       body: ListView(
//         children: [
//           Form(
//             key: _formKey,
//             child: Container(
//               child: Column(
//                 children: [
//                   Container(
//                     alignment: Alignment.topLeft,
//                     child: Container(
//                       margin: EdgeInsets.only(
//                         left: 10,
//                         right: 50,
//                         top: 5,
//                         bottom: 5,
//                       ),
//                       child: DateTimePicker(
//                         controller: deadline,
//                         decoration: InputDecoration(
//                             suffixIcon: Icon(
//                               Icons.event,
//                               color: Colors.white,
//                             ),
//                             border: OutlineInputBorder(),
//                             labelText: 'Chọn thời hạn nộp bài tập* ',
//                             hintText: 'Chọn này sinh ',
//                             labelStyle: TextStyle(color: Colors.white),
//                             counterStyle: TextStyle(color: Colors.black)),
//                         dateMask: 'dd/MM/yyyy',
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime(2100),
//                         icon: Icon(Icons.event),
//                         dateLabelText: 'Ngày',
//                         onChanged: (value) => print(value),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Vui lòng chọn ngày sinh';
//                           }
//                           return null;
//                         },
//                         onSaved: (value) => print(value),
//                       ),
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Color(0xff00a7d0)),
//                       color: Color(0xff00a7d0),
//                     ),
//                   ),
//                   HtmlEditor(
//                     controller: content,
//                     hint: "Nhập nội dung...",
//                   ),
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             if (_formKey.currentState.validate()) {
//                               addExersice();
//                             }
//                           },
//                           child: Text(
//                             'THÊM BÀI TẬP',
//                           ),
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             primary: Colors.white,
//                           ),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => DetailClass(
//                                   id: widget.id,
//                                   countStudents: widget.countStudents,
//                                   className: widget.className,
//                                   homeworks: widget.homeworks,
//                                   homeworkId: widget.homeworkId,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Text('HỦY',
//                               style: TextStyle(color: Colors.black)),
//                         ),
//                       ],
//                     ),
//                     padding: EdgeInsets.only(
//                         left: 35, top: 10, bottom: 10, right: 35),
//                     decoration: BoxDecoration(
//                       border: Border(
//                         top: BorderSide(width: 2.0, color: Colors.black12),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5.0),
//                 border: Border.all(
//                   width: 2,
//                   color: Color(0xff00a7d0),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
