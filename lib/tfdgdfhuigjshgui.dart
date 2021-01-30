import 'package:azt/view/fbfgfgbgf.dart';
import 'package:flutter/material.dart';

class Codetest extends StatefulWidget {
  @override
  _CodeFormState createState() => _CodeFormState();
}

class _CodeFormState extends State<Codetest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text('Nhập mã bài tập'),
      ),
      body: Column(
        children: [
          Container(
            child: new Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: [
                      Text(
                        'Hạn nộp: 15/01/21',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 30),
                  color: Color(0xFF00a7d0),
                ),
                Container(
                  child: Row(
                    children: [
                      Text(
                        'Làm bài tập lớn',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                  color: Colors.black12,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Chọn học sinh',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Color(0xFF00a7d0),
              ),
              // color: Color(0xFF00a7d0),
              color: Colors.white,
            ),
          ),
          Flexible(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio:
                    4, // Tỉ lệ chiều-ngang/chiều-rộng của một item trong grid, ở đây width = 1.6 * height
                crossAxisCount: 2, // Số item trên một hàng ngang
                crossAxisSpacing:
                    16, // Khoảng cách giữa các item trong hàng ngang
                mainAxisSpacing: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
