import 'package:azt/store/notification_store.dart';
import 'package:azt/view/listClass_teacher.dart';
import 'package:azt/view/notificationScreen.dart';
import 'package:azt/controller/notification_controller.dart';
import 'package:azt/view/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class GroupScreenTeacher extends StatefulWidget {
  @override
  _GroupScreenTeacherState createState() => _GroupScreenTeacherState();
}

class _GroupScreenTeacherState extends State<GroupScreenTeacher> {
  int _selectedIndex = 0;
  Future<ListNotification> notiData;
  List<Widget> _widgetOptions = <Widget>[
    ListClass(),
    NotificationScreen(role: 'teacher'),
    Center(child: Text(
      'Tính năng đang cập nhật!',
    ),),
    UserProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    notiData = Provider.of<NotiModel>(context, listen: false).setTotal();
  }

  @override
  Widget build(BuildContext context) {
      // use noti data from store provider
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.room_preferences_outlined),
            label: 'Lớp học',
            backgroundColor: Color(0xff17A2B8),
          ),

          BottomNavigationBarItem(
            // icon: Icon(Icons.notifications_none),
            icon: Stack(
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 30,
                ),
                FutureBuilder<ListNotification>(
                    future: notiData,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return Consumer<NotiModel>(
                          builder: (context, noti, child){
                            return noti.totalUnread == 0? Container(width: 0, height: 0,) : Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffc32c37),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(
                                    child: Text(
                                      '${noti.totalUnread}', // <========== access store data
                                      style: TextStyle(fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if(snapshot.hasError){
                        return Container(width: 0, height: 0,);
                      }
                      return Container(width: 0, height: 0,);
                    }
                ),

              ],
            ),
            label: 'Thông báo',
            backgroundColor: Color(0xff17A2B8),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Nội dung',
            backgroundColor: Color(0xff17A2B8),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Tài khoản',
            backgroundColor: Color(0xff17A2B8),
          ),
        ],
        backgroundColor: Color(0xff17A2B8),
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xff6cdbed),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
