import 'package:azt/view/listClass_teacher.dart';
import 'package:azt/view/notificationScreen.dart';
import 'package:azt/view/userProfile.dart';
import 'package:flutter/material.dart';

class GroupScreenTeacher extends StatefulWidget {
  @override
  _GroupScreenTeacherState createState() => _GroupScreenTeacherState();
}

class _GroupScreenTeacherState extends State<GroupScreenTeacher> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    ListClass(),
    NotificationScreen(role: 'teacher'),
    Text(
      'Index 2: School',
    ),
    UserProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.room_preferences_outlined),
            label: 'Lớp học',
            backgroundColor: Color(0xff17A2B8),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
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
