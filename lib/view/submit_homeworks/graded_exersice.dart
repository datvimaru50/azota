import 'dart:convert';
import 'package:azt/view/view_mark_student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class GradedExersice extends StatefulWidget {
  GradedExersice(
      {Key key,
      this.answerObj,
      this.homeworkObj,
      this.studentObj,
      this.classroomObj})
      : super(key: key);

  final dynamic homeworkObj;
  final dynamic answerObj;
  final dynamic studentObj;
  final dynamic classroomObj;

  @override
  _GradedExersiceState createState() => _GradedExersiceState();
}

class _GradedExersiceState extends State<GradedExersice> {
  final f = new DateFormat('yyyy-MM-dd hh:mm');

  @override
  Widget build(BuildContext context) {
    return widget.answerObj["confirmedAt"] != null
        ? Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    '${widget.studentObj["fullName"]} - Lớp: ${widget.classroomObj["name"]}',
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
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Bài tập ngày ${DateFormat.yMd().format(DateTime.parse(widget.homeworkObj["createdAt"]))}'
                        ' (Hạn nộp: ${DateFormat.yMd().format(DateTime.parse(widget.homeworkObj["deadline"]))})',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      color: Color(0xff00a7d0),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Html(
                        data: widget.homeworkObj["content"],
                      ),
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 10, right: 10),
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
                              text: 'Bài làm',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '(Đã nộp bài lúc: ${f.format(DateTime.parse(widget.answerObj["createdAt"]))} )',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    ),
                    Container(
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        childAspectRatio: 4,
                        crossAxisCount: 2,
                        children: [
                          ...jsonDecode(widget.answerObj['files']).map(
                            (dynamic item) => Container(
                              padding:
                                  EdgeInsets.only(top: 6, left: 3, right: 3),
                              child: Text(
                                item['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                maxLines: 1,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.all(5),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewMarking(
                                    answerId: widget.answerObj["id"].toString(),
                                    fullName: widget.studentObj["fullName"],
                                    className: widget.classroomObj["name"]),
                              ),
                            );
                          },
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
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        )),
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
                      padding: EdgeInsets.only(top: 15, left: 25, bottom: 3),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        jsonDecode(widget.answerObj["result"])["comment"],
                        style: GoogleFonts.pacifico(
                          textStyle: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                      ),
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
          )
        : Container();
  }
}
