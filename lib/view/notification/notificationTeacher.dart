import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NotificationTeacherItem extends StatefulWidget {
  NotificationTeacherItem(
      {this.className,
      this.deadline,
      this.student,
      this.submitTime,
      this.webUrl});

  final String className;
  final String student;
  final String deadline;
  final String submitTime;
  final String webUrl;

  @override
  _NotifTeacherItemState createState() => _NotifTeacherItemState();
}

class _NotifTeacherItemState extends State<NotificationTeacherItem>
    with AutomaticKeepAliveClientMixin {
  bool _clickedStatus = false;
  DateFormat dateFormat;

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
          launch(widget.webUrl);
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
                                        text: widget.student,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      TextSpan(
                                          text: ' nộp bài tập',
                                          style: TextStyle(fontSize: 15)),
                                      TextSpan(
                                        // text: ' Ngày '+ DateTimeFormat.format( DateTime.parse(widget.deadline), format: 'd/m/y' ),
                                        text: ' Ngày ' +
                                            DateFormat.yMd().format(
                                                DateTime.parse(
                                                    widget.deadline)),
                                        style: TextStyle(
                                            // color: _clickedStatus ? Colors.black38 : Color(0xff00c0ef),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
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
                            child: Text(
                                DateTimeFormat.relative(
                                    DateTime.parse(widget.submitTime),
                                    relativeTo: DateTime.now(),
                                    levelOfPrecision: 1,
                                    appendIfAfter: ' ago',
                                    abbr: true),
                                style: TextStyle(
                                    // color: _clickedStatus ? Colors.black38 : Color(0xff00c0ef),
                                    )),
                          ),
                        ],
                      ),
                    ],
                  ),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          margin: EdgeInsets.only(
            top: 5,
            left: 5,
            right: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            // color: Colors.white,
            color: _clickedStatus ? Colors.black38 : Color(0xff00c0ef),
          ),
        ),
      ),
    );
  }
}
