import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:azt/models/core_mo.dart';
import 'package:azt/controller/homework_controller.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HistorySubmit extends StatefulWidget {
  HistorySubmit({Key key, @required this.hashId}) : super(key: key);
  final String hashId;

  List<Widget> hldfdf;

  @override
  _HistorySubmitState createState() => _HistorySubmitState();
}

class _HistorySubmitState extends State<HistorySubmit> {
  Future<HomeworkHashIdInfo> homeworkHashIdInfo;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'vi_VN';
    initializeDateFormatting();
    homeworkHashIdInfo = HomeworkController.getHomeworkInfoAgain(widget.hashId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeworkHashIdInfo>(
        future: homeworkHashIdInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: snapshot.data.answerHistoryObjs.length != 0 ? Column(
                children:  [
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Lịch sử nộp bài',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    color: Color(0xff00a7d0),
                  ),
                  ...snapshot.data.answerHistoryObjs.map((dynamic item) => Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Nộp lúc: ${DateFormat.yMd().format(DateTime.parse(item["createdAt"]))}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        margin: EdgeInsets.only(left: 30, right: 30, bottom: 15, top: 15),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text('Yêu cầu nộp lại vì: '),
                        margin: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(item["resendNote"]),
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(left: 30, right: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Kết quả',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: '(Xem chi tiết kết quả)',
                                style: TextStyle(fontSize: 13, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            item["point"].toString(),
                            style: TextStyle(fontSize: 70, color: Colors.red),
                          ),
                        ),
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(left: 30, right: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text('Nhận Xét'),
                        padding: EdgeInsets.only(top: 15, left: 35),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(jsonDecode(item["result"])["comment"]),
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )).toList()
                ],
              ) : Container(child: Column(children: [
                    Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Lịch sử nộp bài',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      color: Color(0xff00a7d0),
                    ),
                    Container(child: Center(child: Text('Bạn chưa nộp bài lần nào'),),)
              ],),),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: Colors.blue,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }


}
