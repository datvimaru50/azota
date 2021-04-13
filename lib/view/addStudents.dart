import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/view/listStudents.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
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
