import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:azt/view/submit_homeworks/graded_exersice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:azt/models/core_mo.dart';
import 'package:azt/controller/homework_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class GradedExersice extends StatefulWidget {
  GradedExersice({
    Key key,
    @required this.hashId,
    this.studentId,
    this.stdName,
    this.deadline,
    this.className,
    this.answerObj,
    this.answerHistoryObjs,
    this.content,
  }) : super(key: key);
  final String hashId;
  final int studentId;
  final String stdName;
  final String deadline;
  final String className;
  final String content;
  final dynamic answerObj;
  final dynamic answerHistoryObjs;

  List<Widget> hldfdf;

  @override
  _GradedExersiceState createState() => _GradedExersiceState();
}

class _GradedExersiceState extends State<GradedExersice> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              '${widget.stdName} - Lớp: ${widget.className}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Hạn nộp: ${DateFormat.yMd().format(DateTime.parse(widget.deadline))}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                color: Color(0xff00a7d0),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.content,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black12),
                  ),
                  color: Color(0xfff2f2f2),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Bài làm ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text:
                            '(Đã nộp bài lúc: ${DateFormat.yMd().format(DateTime.parse(widget.answerObj["createdAt"]))})',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              ),
              Container(
                alignment: Alignment.center,
                child: Text('file'),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(left: 20, right: 20),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Kết quả ',
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
                alignment: Alignment.center,
                child: Text('${widget.answerObj['point']}',
                    style: TextStyle(fontSize: 70, color: Colors.red)),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(left: 20, right: 20),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text('Nhận Xét'),
                padding: EdgeInsets.only(top: 15, bottom: 2, left: 25),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(jsonDecode(widget.answerObj["result"])["comment"]),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
