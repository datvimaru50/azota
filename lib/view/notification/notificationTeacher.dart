import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationTeacherItem extends StatefulWidget {
  NotificationTeacherItem({this.className, this.deadline, this.student, this.submitTime, this.webUrl});

  final String className;
  final String student;
  final String deadline;
  final String submitTime;
  final String webUrl;

  @override
  _NotifTeacherItemState createState() => _NotifTeacherItemState();
}

class _NotifTeacherItemState extends State<NotificationTeacherItem> with AutomaticKeepAliveClientMixin {
  bool _clickedStatus = false;


  @override
  bool get wantKeepAlive => true;

  @override
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
                    Padding(
                      padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                      child: Text(
                        'Lớp',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 25, right: 25, bottom: 25),
                      child: Text(
                        widget.className,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                color: _clickedStatus ? Colors.black38 : Color(0xff00c0ef),
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
                                            fontSize: 16),
                                      ),
                                      TextSpan(
                                          text: ' nộp bài tập',
                                          style: TextStyle(fontSize: 16)),
                                      TextSpan(
                                        text: ' Ngày '+ widget.deadline,
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
                            child: Text(widget.submitTime),
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
            bottom: 10,
            left: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

}
