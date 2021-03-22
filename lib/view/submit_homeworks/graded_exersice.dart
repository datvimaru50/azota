import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';

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
  Future<String> _buildWebUrl(String answerId) async {
    final token = await Prefs.getPref(ANONYMOUS_TOKEN);
    final baseAccess =
        '$AZT_DOMAIN_NAME/en/auth/login?access_token=$token&return_url=';

    return '$baseAccess/en/xem-bai-tap/$answerId';
  }

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              'Hạn nộp: ${DateFormat.yMd().format(DateTime.parse(widget.homeworkObj["deadline"]))}',
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
                    // Container(
                    //   alignment: Alignment.topLeft,
                    //   child: RichText(
                    //     text: TextSpan(
                    //       style: TextStyle(color: Colors.black),
                    //       children: <TextSpan>[
                    //         TextSpan(
                    //           text: 'Bài làm',
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 13,
                    //           ),
                    //         ),
                    //         TextSpan(
                    //           text:
                    //               '(Đã nộp bài lúc: ${DateFormat.yMd().format(DateTime.parse(widget.answerObj["createdAt"]))})',
                    //           style: TextStyle(fontSize: 13),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    // ),
                    // Container(
                    //   alignment: Alignment.center,
                    //   child: Text(widget.answerObj["files"]),
                    //   padding: EdgeInsets.all(15),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5.0),
                    //     border: Border.all(
                    //       color: Colors.black12,
                    //     ),
                    //     color: Colors.white,
                    //   ),
                    //   margin: EdgeInsets.only(left: 20, right: 20),
                    // ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () async {
                            final String url = await _buildWebUrl(
                                widget.answerObj["id"].toString());
                            launch(url);
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
