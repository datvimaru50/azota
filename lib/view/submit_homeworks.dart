import 'dart:ui';

import 'package:azt/view/submit_homeworks/history_submit.dart';
import 'package:azt/view/submit_homeworks/submit_exersice.dart';
import 'package:flutter/material.dart';

import 'package:azt/config/global.dart';
import 'package:azt/view/splash_screen.dart';

class SubmitForm extends StatefulWidget {
  SubmitForm(
      {@required this.role,
      this.hashId,
      this.studentId,
      this.className,
      this.stdName,
      this.deadline,
      this.content,
      this.files});

  final String hashId;
  final int studentId;
  final String role;
  final String className;
  final String stdName;
  final String deadline;
  final String content;
  final dynamic files;
  @override
  _SubmitFormState createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng xuất'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có thực sự muốn thoát ứng dụng?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Prefs.deletePref();
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Splash()),
                  ModalRoute.withName('/'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nộp bài'),
            GestureDetector(
              child: Container(
                width: 30,
                height: 30,
                child: Stack(
                  children: [
                    Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 30,
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffc32c37),
                            border: Border.all(color: Colors.white, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                _showMyDialog();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            SubmitExersice(
              content: widget.content,
              studentId: widget.studentId,
              hashId: widget.hashId,
              stdName: widget.stdName,
              deadline: widget.deadline,
              className: widget.className,
            ),
            //đã chấm
            // GradedExersice(),
            HistorySubmit(
              nameFile: widget.files['name'],
              content: widget.content,
              hashId: widget.hashId,
              studentId: widget.studentId,
              stdName: widget.stdName,
              deadline: widget.deadline,
              className: widget.className,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                  //ElevatedButton.icon(onPressed: onPressed, icon: icon, label: label),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  icon: Icon(Icons.logout),
                  label: Text('Đăng Xuất'),
                  onPressed: _showMyDialog),
            )
          ],
        ),
        // By default, show a loading spinner.
      ),
    );
  }
}
