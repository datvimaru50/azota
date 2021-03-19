import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';

// ignore: must_be_immutable
class HistorySubmit extends StatefulWidget {
  HistorySubmit({
    this.homeworkObj,
    this.answerHistoryObjs,
  });

  final Iterable answerHistoryObjs;
  final dynamic homeworkObj;

  @override
  _HistorySubmitState createState() => _HistorySubmitState();
}

class _HistorySubmitState extends State<HistorySubmit> {
  Future<String> _buildWebUrl(String homeworkId, String answerId) async {
    final token = await Prefs.getPref(ANONYMOUS_TOKEN);
    final baseAccess =
        '$AZT_DOMAIN_NAME/en/auth/login?access_token=$token&return_url=';

    return '$baseAccess/en/xem-bai-tap/$homeworkId/$answerId';
  }

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'vi_VN';
    initializeDateFormatting();
    print('lent::: ' + widget.answerHistoryObjs.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.answerHistoryObjs.length != 0
          ? Column(
              children: [
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
                ...widget.answerHistoryObjs
                    .map(
                      (dynamic item) => Container(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Nộp lúc: ${DateFormat.yMd().format(DateTime.parse(item["createdAt"]))}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 15, top: 15),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Yêu cầu nộp lại vì: ',
                                    ),
                                    TextSpan(
                                      text: item["resendNote"],
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 15),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(''),
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(left: 20, right: 20),
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
                              child: GestureDetector(
                                onTap: () async {
                                  final String url = await _buildWebUrl(
                                      item["homeworkId"].toString(),
                                      item["id"].toString());
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
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  item["point"].toString(),
                                  style: TextStyle(
                                      fontSize: 70, color: Colors.red),
                                ),
                              ),
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(left: 20, right: 20),
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
                              padding:
                                  EdgeInsets.only(top: 15, left: 25, bottom: 3),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                jsonDecode(item["result"])["comment"],
                                style: GoogleFonts.pacifico(
                                  textStyle: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                ),
                              ),
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(
                                  bottom: 20, left: 20, right: 20),
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
                        margin: EdgeInsets.only(
                            top: 10, bottom: 5, left: 15, right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          color: Colors.white,
                        ),
                      ),
                    )
                    .toList()
              ],
            )
          : Container(
              child: Column(
                children: [
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
                  Container(
                    height: 50,
                    child: Center(
                      child: Text('Bạn chưa nộp bài lần nào'),
                    ),
                  )
                ],
              ),
            ),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Colors.blue,
        ),
      ),
    );
  }
}
