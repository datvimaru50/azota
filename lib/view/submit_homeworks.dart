import 'dart:ui';
import 'dart:io';

import 'package:azt/view/submit_homeworks/graded_exersice.dart';
import 'package:azt/view/submit_homeworks/history_submit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SubmitForm extends StatefulWidget {
  @override
  _SubmitFormState createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              child: TextButton.icon(
                onPressed: getImage,
                icon: Icon(Icons.add_a_photo),
                label: Text('Pick Image'),
              ),
            ),

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
