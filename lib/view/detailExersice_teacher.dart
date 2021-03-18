import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

void main() {
  runApp(DetailExersice());
}

class DetailExersice extends StatefulWidget {
  @override
  _DetailExersiceState createState() => _DetailExersiceState();
}

class _DetailExersiceState extends State<DetailExersice> {
  bool status = false;
  bool submitDate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        appBar: AppBar(
          title: Text(
            'bài tập',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Text(
                      'yêu cầu nộp lại Hed have you all unravel at the Hed have you all unravel at the',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ignore: deprecated_member_use
                        RaisedButton.icon(
                          onPressed: () {
                            print('Button Clicked.');
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          label: Text(
                            'COPY LINK',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          icon: Icon(Icons.copy_sharp, color: Colors.black),
                          textColor: Colors.white,
                          splashColor: Colors.red,
                          color: Colors.white,
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton.icon(
                          onPressed: () {
                            print('Button Clicked.');
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          label: Text(
                            'GỬI ZALO',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          icon: Icon(Icons.share, color: Colors.white),
                          textColor: Colors.white,
                          splashColor: Colors.red,
                          color: Colors.lightBlueAccent,
                        ),
                        GestureDetector(
                          child: Container(
                            child: Icon(Icons.more_vert),
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20),
                  ),
                  Container(
                    child: Text(
                        'Gửi bài tập qua nhom Zalo để phụ huynh / học sinh có thể nộp bài online'),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.black12),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  ),
                  Container(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Ngầy nộp bài giảm dần '),
                                FlutterSwitch(
                                  width: 45.0,
                                  height: 20.0,
                                  valueFontSize: 13.0,
                                  toggleSize: 13.0,
                                  value: submitDate,
                                  borderRadius: 30.0,
                                  padding: 4.0,
                                  showOnOff: true,
                                  onToggle: (val) {
                                    setState(() {
                                      submitDate = val;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Chỉ hiện những bài chưa chấm '),
                                FlutterSwitch(
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
                              ],
                            ),
                            padding: EdgeInsets.only(bottom: 10, top: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 2.0, color: Colors.black12),
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text('Hoàng thùy linh'),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                '9 giờ trước',
                                                style: TextStyle(
                                                  color: Colors.black26,
                                                ),
                                              ),
                                              width: 95,
                                              margin: EdgeInsets.only(
                                                top: 3,
                                                bottom: 3,
                                              ),
                                            ),
                                            Text(
                                              'yêu cầu nộp lại',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: ElevatedButton(
                                          child: Text('CHẤM BÀI'),
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.yellow.shade800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GridView.count(
                                  padding: EdgeInsets.only(top: 15, bottom: 10),
                                  shrinkWrap: true,
                                  crossAxisSpacing: 5,
                                  crossAxisCount: 2,
                                  childAspectRatio: 5,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                          "He'd have you all unravel at the"),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text('Heed not the rabble'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                          'Sound of screams but the'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text('Who scream'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child:
                                          const Text('Revolution is coming...'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text('Revolution, they...'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 2.0, color: Colors.black12),
                              ),
                            ),
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text('Hoàng thùy linh'),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    child: Text('CHƯA NỘP'),
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.black12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 2.0, color: Colors.black12),
                              ),
                            ),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.only(top: 15),
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                    ),
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2.0, color: Colors.black12),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  width: 2,
                  color: Colors.blue.shade200,
                ),
              ),
            ),
          ],
        ));
  }
}
