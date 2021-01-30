import 'dart:async';
import 'package:azt/controller/homework_controller.dart';
import 'package:flutter/material.dart';
import 'package:azt/view/notificationScreen.dart';
import 'package:azt/models/core_mo.dart';

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

  @override
  void initState() {
    super.initState();
    homeworkHashIdInfo = HomeworkController.getHomeworkInfo(
        widget.hashId, widget.anonymousToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn học sinh'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 15, bottom: 10),
            child: Text(
              'Chọn tên con của bạn phía dưới đây:',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          FutureBuilder<HomeworkHashIdInfo>(
            future: homeworkHashIdInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('thongtin hashid ' +
                    snapshot.data.studentObjs.elementAt(0)['fullName']);
                // print('thongtin hashid '+ jsonDecode(snapshot.data.studentObjs)[0].toString());

                return Flexible(
                    child: GridView.builder(
                        padding: EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 4.0),
                        itemCount: snapshot.data.studentObjs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            alignment: Alignment.center,
                            color: Colors.green,
                            child: InkWell(
                              child: Text(
                                snapshot.data.studentObjs
                                    .elementAt(index)['fullName'],
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onTap: () {
                                var stdID = snapshot.data.studentObjs
                                    .elementAt(index)['id']
                                    .toString();

                                HomeworkController.updateParent(
                                        stdID, widget.anonymousToken)
                                    .then((ok) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationScreen(
                                                topic: 'parent',
                                              )),
                                      (Route<dynamic> route) => false);
                                }).catchError((error) {
                                  print(error.toString());
                                });
                              },
                            ),
                          );
                        }));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
