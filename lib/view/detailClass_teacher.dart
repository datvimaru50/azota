import 'package:azt/view/addExersice.dart';
import 'package:azt/view/detailExersice_teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

void main() {
  runApp(DetailClass());
}

class DetailClass extends StatefulWidget {
  @override
  _DetailClassState createState() => _DetailClassState();
}

class _DetailClassState extends State<DetailClass> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text(
          'Quay lại',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                'Lớp: 1CN-3',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              margin: EdgeInsets.only(top: 10),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddExersice()),
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '+ Thêm bài tập',
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
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 10, left: 25, right: 25),
              child: Text(
                'Cho phép phụ huynh thêm tên con ở phần nộp bài?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 10, left: 25, right: 25),
              child: Row(
                children: [
                  Container(
                    child: FlutterSwitch(
                      width: 45.0,
                      height: 20.0,
                      valueFontSize: 13.0,
                      toggleSize: 13.0,
                      value: status,
                      borderRadius: 30.0,
                      padding: 4.0,
                      showOnOff: true,
                      onToggle: (val) {
                        setState(() {
                          status = val;
                        });
                      },
                    ),
                  ),
                  Text(status ? '(cho phép)' : '(Không cho phép)'),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 10, left: 25, right: 25),
              child: Text(
                  'Chức năng này để tránh việc Phụ huynh có thể thêm tên con mình vào hệ thống khi Nộp bài (Sĩ số lớp sẽ bằng sĩ số lớp do giáo viên tải lên hệ thống)'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailExersice()),
                );
              },
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Bài tập ngày: 01/01/20',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                  top: 5,
                                  bottom: 2,
                                ),
                                width: 165,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Hạn nộp: 01/01/20',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                width: 165,
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(left: 15),
                        ),
                        Container(
                          child: Text(
                            'Đã nộp: 1/100',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          margin: EdgeInsets.only(right: 15),
                          height: 32,
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Cho phép phụ huynh thêm tên con ở phần nộp bài?',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      // width: 165,
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      padding: EdgeInsets.only(left: 15, right: 15),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 25, right: 25, top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                  color: Color(0xff00c0ef),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
