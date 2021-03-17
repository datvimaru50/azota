import 'package:azt/view/addClass.dart';
import 'package:azt/view/detailClass_teacher.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ListClass());
}

class ListClass extends StatefulWidget {
  @override
  _ListClassState createState() => _ListClassState();
}

class _ListClassState extends State<ListClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text('Danh sách lớp'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddClass()),
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '+ Thêm lớp',
                  style: TextStyle(color: Colors.blue),
                ),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 10, left: 25, right: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailClass()),
                );
              },
              child: Container(
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        'Đã nộp bài\n1/6',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      padding: EdgeInsets.all(10),
                      color: Color(0xff00c0ef),
                      width: 85,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '1CN-3',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Sĩ số: 16        Hạn nộp: 20/10/21',
                                style: TextStyle(color: Colors.black45),
                              ),
                              padding: EdgeInsets.only(top: 5),
                            )
                          ],
                        ),
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 15),
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 25, right: 25, top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
