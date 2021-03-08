import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradedExersice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Vũ Ngọc Thu - Lớp: 1CN-3',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Hạn nộp: 20/12/2021',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                color: Color(0xff00a7d0),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  '+ Thêm file bài tập',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                color: Color(0xfff2f2f2),
                padding: EdgeInsets.only(top: 15, bottom: 15),
              ),
              Container(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Bài làm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text: '(Đã nộp bài lúc: 24/02/2021, 11:24)',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(10),
              ),
              Container(
                child: Text('file'),
                width: 250,
                padding: EdgeInsets.all(15),
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
                width: 250,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.black12,
                  ),
                  color: Colors.white,
                ),
              ),
              Container(
                child: Text('Nhận Xét'),
                width: 250,
                padding: EdgeInsets.only(top: 15, bottom: 1, left: 5),
              ),
              Container(
                child: Text('Nhận Xét'),
                width: 250,
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(bottom: 20),
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
        ),
      ],
    );
  }
}
