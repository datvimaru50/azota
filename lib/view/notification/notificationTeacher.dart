import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:azt/store/notification_store.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:azt/controller/notification_controller.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationTeacherItem extends StatefulWidget {
  NotificationTeacherItem({@required this.notificationItem});
  final Map<String, dynamic> notificationItem;

  @override
  _NotifTeacherItemState createState() => _NotifTeacherItemState();
}

class _NotifTeacherItemState extends State<NotificationTeacherItem>
    with AutomaticKeepAliveClientMixin {
  var baseAccess;
  var accessToken;
  DateFormat dateFormat;

  void setBaseAccess() async {
    var token = await Prefs.getPref(ACCESS_TOKEN);
    var base_url = await Prefs.getPref(BASE_URL);
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
    return Consumer<NotiModel>(builder: (context, noti, child) {
      return Center(
        child: GestureDetector(
          onTap: () async {
            try {
              await NotiController.markAsRead(noticeId: widget.notificationItem["id"]);
              await Provider.of<NotiModel>(context, listen: false).setTotal();
              launch('$baseAccess/en/admin/homework/mark-exercise/${widget.notificationItem['answerId']}');
            } catch (err) {
              Fluttertoast.showToast(
                msg: err.toString(),
                backgroundColor: Colors.red,
              );
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
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: widget.notificationItem["studentName"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        TextSpan(
                                            text: ' nộp bài tập',
                                            style: TextStyle(fontSize: 15)),
                                        TextSpan(
                                          text: ' Ngày ' +
                                              DateFormat.yMd().format(
                                                  DateTime.parse(widget.notificationItem["deadline"])),
                                          style: TextStyle(
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
                              padding: EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                              child: Text(
                                  TimeAgo.timeAgoSinceDate(widget.notificationItem["createdAt"]),
                                  style: TextStyle()),
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
              color: widget.notificationItem["readAt"] != null
                  ? Colors.black38
                  : Color(0xff00c0ef),
            ),
          ),
        ),
      );
    });
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
