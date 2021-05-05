import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/view/listStudents.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(AddStudent());
}

class AddStudent extends StatefulWidget {
  AddStudent({
    this.classRoomId,
    this.className,
    this.countStudents,
    this.homeworkId,
  });
  final String countStudents;
  final String homeworkId;
  final String classRoomId;
  final String className;
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  int gender;
  TextEditingController fullName = new TextEditingController();
  TextEditingController birthday = new TextEditingController();
  // TextEditingController birthday = new TextEditingController();

  void initState() {
    super.initState();
    gender = 0;
  }

  setgender(int val) {
    setState(
      () {
        gender = val;
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text(
          'Thêm học sinh',
          style: TextStyle(fontSize: 18),
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
                        'Tạo học sinh',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    color: Color(0xff00a7d0),
                  ),

                  // InputDatePickerFormField(firstDate: firstDate, lastDate: lastDate);

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
                        top: 15, left: 20, right: 20, bottom: 15),
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
                      left: 20,
                      right: 20,
                    ),
                  ),
                  Container(
                    child: ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 0,
                          groupValue: gender,
                          activeColor: Colors.green,
                          onChanged: (val) {
                            print("Radio $val");
                            setgender(val);
                          },
                        ),
                        Text('Nam'),
                        Radio(
                          value: 1,
                          groupValue: gender,
                          activeColor: Colors.blue,
                          onChanged: (val) {
                            print("Radio $val");
                            setgender(val);
                          },
                        ),
                        Text('Nữ'),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple[900],
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return MyDialog(
                                    classRoomId: widget.classRoomId,
                                    className: widget.className,
                                    countStudents: widget.countStudents,
                                    homeworkId: widget.homeworkId,
                                  );
                                });
                          },
                          child: Text('FILE EXCEL',
                              style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              ClassroomController.addStudentRoom(
                                classRoomId: widget.classRoomId,
                                className: widget.className,
                                countStudents: widget.countStudents,
                                homeworkId: widget.homeworkId,
                                context: context,
                                fullName: fullName.text,
                                gender: gender,
                                birthday: birthday.text,
                              );
                            }
                          },
                          child: Text(
                            'LƯU',
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(
                                context,
                              );
                            });
                          },
                          child: Text('HỦY',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                  )
                ],
              ),
            ),
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
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

class MyDialog extends StatefulWidget {
  MyDialog({
    this.classRoomId,
    this.className,
    this.countStudents,
    this.homeworkId,
  });
  final String countStudents;
  final String homeworkId;
  final String classRoomId;
  final String className;
  @override
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final _formKey = GlobalKey<FormState>();
  String filePath;
  // ignore: unused_field
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                child: Container(
                  alignment: Alignment.center,
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
                                  alignment: Alignment.center,
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  color: Color(0xFFecf0f5),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 15, top: 10),
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
                                  alignment: Alignment.center,
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
                width: 300,
                margin: EdgeInsets.only(left: 20, right: 20),
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
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          try {
                            setState(() {
                              _creatingClass = true;
                            });
                            if (filePath != null) {
                              await ClassroomController.updateClassRoom(
                                filePath: filePath,
                                className: widget.className,
                                idClassRoom: widget.classRoomId,
                              );
                            }
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => ListStudents(
                                    id: widget.classRoomId,
                                    className: widget.className,
                                    countStudents: widget.countStudents,
                                    homeworkId: widget.homeworkId,
                                  ),
                                ),
                                (Route<dynamic> route) => false);
                          } catch (err) {
                            setState(() {
                              _creatingClass = false;
                            });
                            Fluttertoast.showToast(
                                msg: err.toString(),
                                backgroundColor: Colors.red);
                          }
                        }
                      },
                      child: Text(
                        'LƯU',
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow[800],
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'HỦY',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                padding:
                    EdgeInsets.only(left: 35, top: 10, bottom: 10, right: 35),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.5, color: Colors.black12),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
