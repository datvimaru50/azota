import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistorySubmit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Lịch sử nộp bài',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            color: Color(0xff00a7d0),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              'Nộp lúc: 03/03/3333 33:33',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            margin: EdgeInsets.only(left: 30, right: 30, bottom: 15, top: 15),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text('Yêu cầu nộp lại vì: '),
            margin: EdgeInsets.only(left: 30, right: 30, bottom: 15),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text('file'),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(left: 30, right: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Colors.black12,
              ),
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Kết quả',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: '(Xem chi tiết kết quả)',
                    style: TextStyle(fontSize: 13, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                '7',
                style: TextStyle(fontSize: 70, color: Colors.red),
              ),
            ),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(left: 30, right: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Colors.black12,
              ),
              color: Colors.white,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text('Nhận Xét'),
            padding: EdgeInsets.only(top: 15, left: 35),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text('Nhận Xét'),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 20, left: 30, right: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Colors.black12,
              ),
              color: Colors.white,
            ),
          ),
        ],
      ),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Colors.blue,
        ),
      ),
    );
  }
}
