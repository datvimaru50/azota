import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:azt/controller/notification_controller.dart';
import 'package:azt/view/submit_homeworks.dart';
import 'package:provider/provider.dart';
import 'package:azt/store/notification_store.dart';

class NotificationStudentItem extends StatefulWidget {
  NotificationStudentItem(
      {this.notiType,
      this.noticeId,
      this.read,
      this.className,
      this.deadline,
      this.score,
      this.submitTime,
      this.token,
      this.answerId,
      this.resendNote});

  final int noticeId;
  final bool read;
  final String resendNote;
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
        onTap: () async {
          setState(() {
            _clickedStatus = true;
          });
          await NotiController.markAsRead(
              noticeId: widget.noticeId, accType: 'parent');
          await Provider.of<NotiModel>(context, listen: false)
              .setTotal(accType: 'parent');

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SubmitForm()),
              (Route<dynamic> route) => false);
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
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
                                              DateTime.parse(widget.deadline)),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                              child: Text(
                                TimeAgo.timeAgoSinceDate(widget.submitTime),
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.notiType == 'RESEND_ANSWER'
                          ? Text('')
                          : Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 40,
                              child: Text(
                                widget.score,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.red,
                              ),
                            ),
                    ],
                  ),
                  color: Colors.white,
                ),
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
            color: _clickedStatus || widget.read
                ? Colors.black38
                : Color(0xff00c0ef),
          ),
        ),
      ),
    );
  }
}

class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return 'nộp ngày' + DateFormat.yMd().format(DateTime.parse(dateString));
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 tuần trước' : '1 tuần trước';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 ngày trước' : '1 ngày trước';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 giờ trước' : '1 giờ trước';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 phút trước' : '1 phút trước';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} giây trước';
    } else {
      return 'vừa xong';
    }
  }
}
