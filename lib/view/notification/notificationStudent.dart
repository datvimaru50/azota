import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:azt/config/connect.dart';
import 'package:azt/view/submit_homeworks.dart';

class NotificationStudentItem extends StatefulWidget {
  NotificationStudentItem(
      {this.notiType,
      this.className,
      this.deadline,
      this.score,
      this.submitTime,
      this.token,
      this.answerId,
      });

  final String notiType;
  final String className;
  final String score;
  final String deadline;
  final String submitTime;
  final String token;
  final String answerId;

  @override
  _NotifStudentItemState createState() => _NotifStudentItemState();
}

class _NotifStudentItemState extends State<NotificationStudentItem>
    with AutomaticKeepAliveClientMixin {
  bool _clickedStatus = false;

  String _buildText(String notiType) {
    switch (notiType) {
      case 'RESEND_ANSWER':
        {
          return 'Yêu cầu nộp lại bài tập ';
        }
        break;

      case 'NEW_HOMEWORK':
        {
          return 'Giáo viên giao bài tập ';
        }
        break;

      default:
        {
          return 'Kết quả bài tập ';
        }
        break;
    }
  }


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'vi_VN';
    initializeDateFormatting();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _clickedStatus = true;
          });

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => SubmitForm()),
                  (Route<dynamic> route) => false);

          // launch(_buildWebUrl(widget.notiType));
        },
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Lớp',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Center(
                        child: Text(
                          widget.className,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                width: 95,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: _buildText(widget.notiType),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: ' Ngày ' +
                                            DateFormat.yMd().format(
                                                DateTime.parse(
                                                    widget.deadline)),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 10, bottom: 10),
                            child: Text(DateTimeFormat.relative(
                                DateTime.parse(widget.submitTime),
                                relativeTo: DateTime.now(),
                                levelOfPrecision: 1,
                                appendIfAfter: 'ago',
                                abbr: true)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  color: Colors.white,
                ),
              ),
              Container(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 22, bottom: 22, left: 10, right: 10),
                    child: Text(
                      widget.score,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black12),
                    color: Colors.red,
                  ),
                ),
                color: Colors.white,
              ),
            ],
          ),
          margin: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            color: _clickedStatus ? Colors.black38 : Color(0xff00c0ef),
          ),
        ),
      ),
    );
  }
}
