import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/view/detailExersice_teacher.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EditExersice());
}

class EditExersice extends StatefulWidget {
  EditExersice({
    this.idClassroom,
    this.countStudents,
    this.className,
    this.homeworkId,
    this.homeworks,
    this.deadline,
    this.exerciseId,
    this.idExersice,
    this.content,
  });
  final String idClassroom;
  final String countStudents;
  final String className;
  final String homeworkId;
  final String homeworks;
  final String deadline;
  final String content;
  final String idExersice;
  final String exerciseId;
  @override
  _EditExersiceState createState() => _EditExersiceState();
}

class _EditExersiceState extends State<EditExersice> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController content;
  TextEditingController deadline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text('Sửa bài tập', style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailExersice(
                  deadline: widget.deadline,
                  exerciseId: widget.exerciseId,
                  content: widget.content,
                  countStudents: widget.countStudents,
                  className: widget.className,
                  homeworkId: widget.homeworkId,
                  homeworks: widget.homeworks,
                  idClassroom: widget.idClassroom,
                  idExersice: widget.idExersice,
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
                        'Tạo bài tập',
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
                      controller: deadline =
                          TextEditingController(text: widget.deadline),
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
                      controller: content =
                          TextEditingController(text: widget.content),
                      minLines: 6,
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
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
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '+ Thêm file bài tập',
                              style: TextStyle(color: Colors.blue),
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black12),
                              ),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '636b279ea5d0578e0ec1.abc636b279ea5d0578e0ec1',
                            maxLines: 1,
                            style: TextStyle(color: Colors.black38),
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.black12),
                            ),
                          ),
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(8),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.black12),
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              ClassroomController.editExersice(
                                context: context,
                                idExersice: widget.idExersice,
                                content: content.text,
                                deadline: deadline.text,
                                exerciseId: widget.exerciseId,
                                countStudents: widget.countStudents,
                                className: widget.className,
                                homeworkId: widget.homeworkId,
                                homeworks: widget.homeworks,
                                idClassroom: widget.idClassroom,
                              );
                            }
                          },
                          child: Text(
                            'CẬP NHẬT',
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
                                builder: (context) => DetailExersice(
                                  deadline: widget.deadline,
                                  exerciseId: widget.exerciseId,
                                  content: widget.content,
                                  countStudents: widget.countStudents,
                                  className: widget.className,
                                  homeworkId: widget.homeworkId,
                                  homeworks: widget.homeworks,
                                  idClassroom: widget.idClassroom,
                                  idExersice: widget.idExersice,
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
          )
        ],
      ),
    );
  }
}
