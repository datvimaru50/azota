import 'dart:ui';
import 'dart:io';

import 'package:azt/view/submit_homeworks/graded_exersice.dart';
import 'package:azt/view/submit_homeworks/history_submit.dart';
import 'package:azt/view/submit_homeworks/submit_exersice.dart';
import 'package:flutter/material.dart';

class SubmitForm extends StatefulWidget {
  SubmitForm({@required this.role});

  final String role;
  @override
  _SubmitFormState createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      body: Center(
        child: ListView(
          children: <Widget>[
            SubmitExersice(),

            //đã chấm
            GradedExersice(),
            HistorySubmit(),
          ],
        ),
        // By default, show a loading spinner.
      ),
    );
  }
}
