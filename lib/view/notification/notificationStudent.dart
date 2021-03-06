import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:azt/controller/notification_controller.dart';
import 'package:provider/provider.dart';
import 'package:azt/store/notification_store.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationStudentItem extends StatefulWidget {
  NotificationStudentItem({@required this.notificationItem,});

  final Map<String, dynamic> notificationItem;

  @override
  _NotifStudentItemState createState() => _NotifStudentItemState();
}

class _NotifStudentItemState extends State<NotificationStudentItem>
    with AutomaticKeepAliveClientMixin {
  var baseAccess;
  var accessToken;

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

  void setBaseAccess() async {
    var token = await Prefs.getPref(ACCESS_TOKEN);
    var base_url = await Prefs.getPref(BASE_URL);
    print('zzzzz '+base_url);
    setState(() {
      accessToken = token;
      baseAccess =
      '$base_url/en/auth/login?access_token=$token&return_url=';
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'vi_VN';
    initializeDateFormatting();
    setBaseAccess();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          await NotiController.markAsRead(noticeId: widget.notificationItem["id"]);
          await Provider.of<NotiModel>(context, listen: false).setTotal();

          switch (widget.notificationItem["type"]) {
            case 'HAS_MARK':
              {
                launch('$baseAccess/en/homework/view-homework/${widget.notificationItem['answerId']}');
              }
              break;

            default: // NEW_HOMEWORK, RESEND_ANSWER
              {
                launch('$baseAccess/en/bai-tap/${widget.notificationItem['hashId']}');
              }
              break;
          }
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
                          widget.notificationItem["classroomName"],
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
                                      text: _buildText(widget.notificationItem["type"]),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: ' Ngày ' +
                                          DateFormat.yMd().format(
                                              DateTime.parse(widget.notificationItem["deadline"])),
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
                                TimeAgo.timeAgoSinceDate(widget.notificationItem["createdAt"]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.notificationItem["type"] == 'RESEND_ANSWER'
                          ? Text('')
                          : Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 40,
                              child: Text(
                                widget.notificationItem["point"].toString(),
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
            top: 5,
            left: 5,
            right: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            color: widget.notificationItem["readAt"] != null
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
      return DateFormat.yMd().format(DateTime.parse(dateString));
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
