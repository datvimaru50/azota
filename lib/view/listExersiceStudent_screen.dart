import 'dart:convert';
import 'dart:async';
import 'package:azt/config/global.dart';
import 'package:azt/controller/homework_controller.dart';
import 'package:azt/view/groupScreenStudent.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:azt/models/core_mo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// class Name {
//   dynamic getAnswerObjs;

//   Name({
//     // this.homeworkObjs,
//     // this.answerObjs,
//     // this.studentObj,
//     // this.classroomObj,
//     this.getAnswerObjs,
//   });
// }

class ListExersiceStudent extends StatefulWidget {
  @override
  _ListExersiceStudentState createState() => _ListExersiceStudentState();
}

class _ListExersiceStudentState extends State<ListExersiceStudent> {
  Future<GetAnswersOfParent> getAnswersOfParent;
  final f = new DateFormat('yyyy-MM-dd hh:mm');

  @override
  void initState() {
    super.initState();
    getAnswersOfParent = HomeworkController.getAnswers();
  }

  _showAnswer(
      {int homeworkId, dynamic answerObjs, String content, String hashId}) {
    // print(answerObjs.length.toString() + 'qq');
    for (var i2 = 0; i2 < answerObjs.length; i2++) {
      if (answerObjs[i2]['homeworkId'] == homeworkId) {
        return Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Html(
                data: """<div >${content.toString()}</div>""",
                style: {
                  "div": Style(
                    color: Colors.black,
                  ),
                  "p": Style(fontWeight: FontWeight.bold)
                },
              ),
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 15,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1.5,
                    color: Colors.black26,
                  ),
                ),
                color: Colors.black12,
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
                          '(Đã nộp bài lúc: ${f.format(DateTime.parse(answerObjs[i2]["createdAt"]))} )',
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
                  ...jsonDecode(answerObjs[i2]['files']).map(
                    (dynamic item) => Container(
                      padding: EdgeInsets.only(top: 6, left: 3, right: 3),
                      child: Text(
                        item['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                        maxLines: 1,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.black12,
                        ),
                        color: Colors.black12,
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
            answerObjs[i2]['confirmedAt'] != null
                ? Container()
                : Container(
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          'Đang đợi giáo viên chấm bài',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            print(hashId);
                            try {
                              await Prefs.savePrefs(HASH_ID, hashId);

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          // ignore: missing_required_param
                                          GroupScreenStudent()),
                                  (Route<dynamic> route) => false);
                            } catch (err) {
                              return Fluttertoast.showToast(
                                  msg: 'Không lưu được mã lớp',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Text(
                            '(click để nộp lại)',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ),
            answerObjs[i2]['confirmedAt'] == null
                ? Container()
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          // onTap: () async {
                          //   final String url =
                          //       await _buildWebUrl(widget.answerObj["id"].toString());
                          //   launch(url);
                          // },
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
                        alignment: Alignment.center,
                        child: Text('${answerObjs[i2]['point']}',
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
                          jsonDecode(answerObjs[i2]["result"])["comment"],
                          style: GoogleFonts.pacifico(
                            textStyle:
                                TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        ),
                        padding: EdgeInsets.all(15),
                        margin:
                            EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
          ],
        );
      }
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Html(
            data: """<div >${content.toString()}</div>""",
            style: {
              "div": Style(
                color: Colors.black,
              ),
              "p": Style(fontWeight: FontWeight.bold)
            },
          ),
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 15,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.5,
                color: Colors.black26,
              ),
            ),
            color: Colors.black12,
          ),
        ),
        Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Không tìm thấy File đính kèm cho bài tập',
            ),
            SizedBox(height: 10),
            Text(
              'Bạn chưa nộp bài tập này!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Prefs.savePrefs(HASH_ID, hashId);

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              // ignore: missing_required_param
                              GroupScreenStudent()),
                      (Route<dynamic> route) => false);
                } catch (err) {
                  return Fluttertoast.showToast(
                      msg: 'Không lưu được mã lớp',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: Text(
                'Tiến tới nộp bài',
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ],
    );
  }

  _showAnswerTitle({int homeworkId, dynamic answerObjs}) {
    // print(answerObjs.length.toString() + 'qq');
    for (var i2 = 0; i2 < answerObjs.length; i2++) {
      if (answerObjs[i2]['homeworkId'] == homeworkId) {
        return Container(
          width: 175,
          alignment: Alignment.topLeft,
          child: Text(
            'Nộp ngày: ' +
                DateFormat.yMd().format(
                  DateTime.parse(
                    answerObjs[i2]['createdAt'].toString(),
                  ),
                ),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    }
    return Container(
      width: 175,
      alignment: Alignment.topLeft,
      child: Text(
        'Chưa nộp bài ',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _showAnswerPoid({int homeworkId, dynamic answerObjs}) {
    // print(answerObjs.length.toString() + 'qq');
    for (var i2 = 0; i2 < answerObjs.length; i2++) {
      if (answerObjs[i2]['homeworkId'] == homeworkId) {
        return answerObjs[i2]['point'] == 0
            ? Container()
            : Container(
                alignment: Alignment.center,
                height: 32,
                width: 32,
                child: Text(
                  answerObjs[i2]['point'].toString().replaceAll(".0", ""),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                margin: EdgeInsets.only(left: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.red,
                ),
              );
      }
    }
    return Container();
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => GroupScreenStudent(),
        ),
        (Route<dynamic> route) => false);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        appBar: AppBar(
          title: Text(
            'Danh sách bài tập trong lớp',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: ListView(
          children: [
            FutureBuilder<GetAnswersOfParent>(
              future: getAnswersOfParent,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      ...snapshot.data.data.map(
                        (dynamic item) => Column(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              item['studentObj']['fullName'].toString() +
                                  ' - Lớp: ' +
                                  item['classroomObj']['name'].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            ...item['homeworkObjs'].map(
                              (dynamic itemm) => Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    ExpansionTile(
                                      title: Row(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(height: 8),
                                              Container(
                                                width: 175,
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'Bài tập ngày: ' +
                                                      DateFormat.yMd().format(
                                                        DateTime.parse(
                                                          itemm["createdAt"],
                                                        ),
                                                      ),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 175,
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'Hạn nộp: ' +
                                                      DateFormat.yMd().format(
                                                        DateTime.parse(
                                                          itemm["deadline"],
                                                        ),
                                                      ),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                margin: EdgeInsets.only(
                                                    top: 3, bottom: 3),
                                              ),
                                              _showAnswerTitle(
                                                homeworkId: itemm['id'],
                                                answerObjs: item['answerObjs'],
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                          _showAnswerPoid(
                                            homeworkId: itemm['id'],
                                            answerObjs: item['answerObjs'],
                                          )
                                        ],
                                      ),
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          child: Container(
                                            child: _showAnswer(
                                              hashId: itemm['hashId'],
                                              content: itemm['content'],
                                              homeworkId: itemm['id'],
                                              answerObjs: item['answerObjs'],
                                            ),
                                          ),
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.only(
                                    left: 25, right: 25, top: 7, bottom: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  color: Color(0xff00c0ef),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(20),
                    child: Text('Kiểm tra lại kết nối'),
                  );
                }
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
