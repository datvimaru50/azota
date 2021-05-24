import 'dart:io';

import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:azt/view/detailExersice_teacher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MarkingScreen extends StatefulWidget {
  MarkingScreen({
    this.answerId,
    this.fullName,
    this.className,
    this.hashId,
    this.deadline,
    this.exerciseId,
    this.content,
    this.countStudents,
    this.homeworkId,
    this.homeworks,
    this.idClassroom,
    this.idExersice,
  });
  final String answerId;
  final String fullName;
  final String className;
  final String hashId;
  final String deadline;
  final String exerciseId;
  final String content;
  final String countStudents;
  final String homeworkId;
  final String homeworks;
  final String idClassroom;
  final String idExersice;
  @override
  MarkingScreenState createState() => MarkingScreenState();
}

class MarkingScreenState extends State<MarkingScreen> {
  var baseAccess;
  var accessToken;
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    setBaseAccess();
  }

  void setBaseAccess() async {
    var token = await Prefs.getPref(ACCESS_TOKEN);
    // ignore: await_only_futures
    await setState(() {
      accessToken = token;
      baseAccess =
          '$AZT_DOMAIN_NAME/en/auth/login?access_token=$token&return_url=';
      print(baseAccess);
    });
    print('accesstoken1::: ' + token);
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => DetailExersice(
            hashId: widget.hashId,
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
        (Route<dynamic> route) => false);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50),
                  height: MediaQuery.of(context).size.height / 1,
                  child: WebView(
                    initialUrl: baseAccess +
                        '/en/admin/mark-exercise/' +
                        widget.answerId,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
                Container(
                  color: Colors.blue,
                  height: 89,
                ),
                Container(
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.blue[600],
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(''),
                            Text(
                              widget.fullName + ', ' + widget.className,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.keyboard_arrow_left),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailExersice(
                                  hashId: widget.hashId,
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
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
