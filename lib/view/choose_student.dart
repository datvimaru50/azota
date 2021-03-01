import 'dart:async';
import 'package:azt/config/global.dart';
import 'package:azt/controller/homework_controller.dart';
import 'package:azt/view/notificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:azt/models/core_mo.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class ChooseStudent extends StatefulWidget {
  ChooseStudent({Key key, @required this.hashId, @required this.anonymousToken})
      : super(key: key);
  final String hashId;
  final String anonymousToken;

  @override
  _ChooseStudentState createState() => _ChooseStudentState();
}

class _ChooseStudentState extends State<ChooseStudent> {
  Future<HomeworkHashIdInfo> homeworkHashIdInfo;
  // final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    homeworkHashIdInfo = HomeworkController.getHomeworkInfo(
        widget.hashId, widget.anonymousToken);
  }

  var accessToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text('Chọn học sinh'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Prefs.deletePref();
            Navigator.pop(
              context,
            );
          },
        ),
      ),
      body: Container(
        child: FutureBuilder<HomeworkHashIdInfo>(
          future: homeworkHashIdInfo,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print('thong tin hashid ' +snapshot.data.studentObjs.elementAt(0)['fullName']);
              return CustomScrollView(
                slivers: <Widget>[
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3,
                      crossAxisCount: 2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            showAnimatedDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return ClassicGeneralDialogWidget(
                                  titleText: snapshot.data.studentObjs
                                      .elementAt(index)['fullName'],
                                  contentText:
                                      'Bạn có chắc đây là con của bạn?',
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'Hủy Chọn',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Tiếp Tục',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onPressed: () {
                                        var stdID = snapshot.data.studentObjs
                                            .elementAt(index)['id']
                                            .toString();

                                        HomeworkController.updateParent(
                                                stdID, widget.anonymousToken)
                                            .then((ok) {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NotificationScreen(
                                                            role: 'parent',
                                                          )),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        }).catchError((error) {
                                          print(error.toString());
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                              animationType: DialogTransitionType.size,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 1),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: InkWell(
                              child: Text(
                                snapshot.data.studentObjs
                                    .elementAt(index)['fullName'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: Colors.black12,
                              ),
                              color: Color(0xFFfafafa),
                            ),
                          ),
                        );
                      },
                      childCount: snapshot.data.studentObjs.length,
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 30, right: 30),
                      child: Text(
                        'Mã bài tập không tồn tại, vui lòng kiểm tra lại.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    FlatButton.icon(
                      color: Colors.blue,
                      onPressed: () {
                        Prefs.deletePref();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text(
                        'Thử Lại',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        // color: Color(0xFFf2f2f2),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
          ),
          color: Colors.white,
        ),
      ),
    );
  }
}
