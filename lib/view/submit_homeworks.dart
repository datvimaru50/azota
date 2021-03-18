import 'dart:ui';

import 'package:azt/view/submit_homeworks/history_submit.dart';
import 'package:azt/view/submit_homeworks/submit_exersice.dart';
import 'package:flutter/material.dart';

import 'package:azt/config/global.dart';
import 'package:azt/view/splash_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubmitForm extends StatefulWidget {
  SubmitForm(
      {@required this.role,
      this.hashId,
      this.studentId,
      this.className,
      this.stdName,
      this.deadline,
      this.content});

  final String hashId;
  final int studentId;
  final String role;
  final String className;
  final String stdName;
  final String deadline;
  final String content;
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
                // _firebaseMessaging.deleteInstanceID();
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
              child: Icon(
                FontAwesomeIcons.bell,
                color: Colors.white,
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
