import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/view/listStudents.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:html_editor_enhanced/utils/shims/dart_ui_real.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EditStudent());
}

class EditStudent extends StatefulWidget {
  EditStudent({
    this.classRoomId,
    this.className,
    this.birthday,
    this.fullName,
    this.idStudent,
    this.checkGender,
    this.countStudents,
    this.homeworkId,
  });
  final String countStudents;
  final int checkGender;
  final String idStudent;
  final String fullName;
  final String classRoomId;
  final String birthday;
  final String className;
  final String homeworkId;
  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final _formKey = GlobalKey<FormState>();
  int gender;
  TextEditingController fullName = new TextEditingController();
  TextEditingController birthday = new TextEditingController();

  void initState() {
    super.initState();
    gender = widget.checkGender;
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
          'Sửa học sinh',
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
                        'Sửa học sinh',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    color: Color(0xff00a7d0),
                  ),
                  Container(
                    child: TextFormField(
                      controller: fullName =
                          new TextEditingController(text: widget.fullName),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Họ tên học sinh*',
                        hintText: 'Nhập vào họ tên học sinh',
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
                        controller: birthday =
                            new TextEditingController(text: widget.birthday),
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.event),
                          border: OutlineInputBorder(),
                          labelText: 'Ngày sinh*',
                          hintText: 'Chọn này sinh ',
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey.currentState.validate()) {
                              ClassroomController.editStudentRoom(
                                  fullName.text,
                                  gender,
                                  widget.checkGender,
                                  birthday,
                                  widget.classRoomId,
                                  widget.idStudent,
                                  context,
                                  widget.className,
                                  widget.countStudents,
                                  widget.homeworkId);
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListStudents(
                                  id: widget.classRoomId,
                                  className: widget.className,
                                  countStudents: widget.countStudents,
                                  homeworkId: widget.homeworkId,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'HỦY',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: 10,
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
