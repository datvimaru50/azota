import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/controller/update_controller.dart';
import 'package:azt/models/core_mo.dart';
import 'package:azt/view/addExersice.dart';
import 'package:azt/view/detailExersice_teacher.dart';
import 'package:azt/view/editExersice.dart';
import 'package:azt/view/groupScreenTeacher.dart';
import 'package:azt/view/listStudents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(DetailClass());
}

class DetailClass extends StatefulWidget {
  DetailClass({
    this.idClassroom,
    this.countStudents,
    this.className,
    this.homeworkId,
    this.homeworks,
    this.aaa,
    this.showAddStudent,
  });
  final String idClassroom;
  final int showAddStudent;
  final int aaa;
  final String countStudents;
  final String className;
  final String homeworkId;
  final String homeworks;
  @override
  _DetailClassState createState() => _DetailClassState();
}

class _DetailClassState extends State<DetailClass> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name;
  Future<ClassroomHashIdInfo> classroomHashIdInfo;
  Future<GetShowAddNew> getClassroomById;
  Future<ClassroomHashIdInfo> deleteClassroom;
  bool status;
  String a1;

  @override
  void initState() {
    super.initState();
    classroomHashIdInfo =
        ClassroomController.getExersiceInfoAgain(widget.idClassroom);
    status = widget.showAddStudent == 1 ? true : false;
    print(status);
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => GroupScreenTeacher()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xFFecf0f5),
        appBar: AppBar(
          title: Text('Bài tập', style: TextStyle(fontSize: 18)),
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: _onBackPressed,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ignore: deprecated_member_use
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    showAnimatedDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return ClassicGeneralDialogWidget(
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListStudents(
                                      id: widget.idClassroom,
                                      className: widget.className,
                                      countStudents: widget.countStudents,
                                      homeworkId: widget.homeworkId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Quản lý danh sách học sinh',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: new Text(
                                          "Chỉnh sửa thông tin lớp học"),
                                      actions: <Widget>[
                                        Container(
                                          width: 300,
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    'Tên lớp học:',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Nhắc nhở: Tên lớp học không được chứa ký tự đặc biệt',
                                                    style: TextStyle(
                                                        color: Colors.black38),
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      bottom: 10, top: 15),
                                                ),
                                                TextFormField(
                                                  controller: name =
                                                      new TextEditingController(
                                                          text:
                                                              widget.className),
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Tên lớp học*',
                                                    hintText:
                                                        'Nhập vào tên lớp',
                                                  ),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Vui lòng điền đầy đủ thông tin';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          if (_formKey
                                                              .currentState
                                                              .validate()) {
                                                            ClassroomController.updateClassroom(
                                                                widget
                                                                    .idClassroom,
                                                                name,
                                                                widget
                                                                    .countStudents,
                                                                widget
                                                                    .homeworkId,
                                                                widget
                                                                    .homeworks,
                                                                context);
                                                          }
                                                        },
                                                        child: Text(
                                                          'SỬA',
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      DetailClass(
                                                                idClassroom: widget
                                                                    .idClassroom,
                                                                className: widget
                                                                    .className,
                                                                countStudents:
                                                                    widget
                                                                        .countStudents,
                                                                homeworkId: widget
                                                                    .homeworkId,
                                                                homeworks: widget
                                                                    .homeworks,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: Text('HỦY',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                    ],
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                // color: Colors.black,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Sửa thông tin lớp học',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Container(
                                // color: Colors.black,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Xuất bảng điểm lớp học',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return ClassicGeneralDialogWidget(
                                      titleText: 'Bạn có chắc chắn',
                                      actions: [
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          onPressed: () {
                                            setState(
                                              () {
                                                deleteClassroom =
                                                    ClassroomController
                                                        .deleteClassroom(
                                                            widget.idClassroom,
                                                            context);
                                              },
                                            );
                                          },
                                          child: Text('Xóa'),
                                          color: Colors.red,
                                        ),
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Hủy'),
                                          color: Colors.black38,
                                        )
                                      ],
                                    );
                                  },
                                  animationType: DialogTransitionType.size,
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(seconds: 1),
                                );
                              },
                              child: Container(
                                // color: Colors.black,
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Xóa lớp học',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      animationType: DialogTransitionType.size,
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(seconds: 1),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                'Lớp: ${widget.className}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              margin: EdgeInsets.all(10),
            ),
            Column(
              children: <Widget>[
                FutureBuilder<ClassroomHashIdInfo>(
                  future: classroomHashIdInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        child: snapshot.data.data.length == 0
                            ? Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 25, right: 25),
                                child: Html(
                                    data:
                                        'Thầy/Cô đã tạo thành công lớp <b>${widget.className}</b>. Bấm vào nút <b>THÊM BÀI TẬP</b> để bắt đầu giao bài tập cho các học sinh trong lớp.</br></br>Quy trình giao và chấm bài diễn ra như sau: </br></br><b>1</b>. Thầy / Cô thực hiện giao các phiếu bài tập cho học sinh ở trên lớp như bình thường </br><b>2</b>. Bấm vào nút <b>THÊM BÀI TẬP</b> bên dưới để thực hiện tạo bài tập. Việc tạo bài tập này mục đích để Phụ huynh / Học sinh có thể nộp bài online </br><b>3</b>. Gửi link bài tập vừa tạo qua group Zalo cho phụ huynh / học sinh (Nhấn nút <b>COPY LINK</b> hoặc <b>SHARE ZALO</b>) </br><b>4</b>. Phụ huynh nhận được link bài tập qua Zalo và cho học sinh làm bài </br><b>5</b>. Học sinh làm bài xong phụ huynh vào lại link bài tập đã nhận được trước đó để chụp lại ảnh bài làm của học sinh và nộp bài online </br><b>6</b>. Giáo viên nhận được bài nộp và thực hiện chấm online'),
                              )
                            : Container(),
                      );
                    }
                    return Container();
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddExersice(
                          id: widget.idClassroom,
                          className: widget.className,
                          countStudents: widget.countStudents,
                          homeworkId: widget.homeworkId,
                          homeworks: widget.homeworks,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '+ Thêm bài tập',
                      style: TextStyle(color: Colors.blue),
                    ),
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(left: 25, right: 25),
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
                            width: 47.0,
                            height: 22.0,
                            valueFontSize: 13.0,
                            toggleSize: 13.0,
                            value: status,
                            borderRadius: 30.0,
                            padding: 4.0,
                            showOnOff: true,
                            onToggle: (val) {
                              UpdateController.updateChangeShowAddStudent(
                                changeShowAdd: status == true ? 0 : 1,
                                idClassroom: widget.idClassroom,
                              );
                              setState(() {
                                status = val;
                              });
                            }),
                      ),
                      Text(status == true ? '(cho phép)' : '(Không cho phép)'),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: Text(
                      'Chức năng này để tránh việc Phụ huynh có thể thêm tên con mình vào hệ thống khi Nộp bài (Sĩ số lớp sẽ bằng sĩ số lớp do giáo viên tải lên hệ thống)'),
                ),
                FutureBuilder<ClassroomHashIdInfo>(
                  future: classroomHashIdInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          ...snapshot.data.data.map(
                            (dynamic item) => Column(
                              children: [
                                Container(
                                  child: Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    child: GestureDetector(
                                      onLongPress: () {
                                        showAnimatedDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return ClassicGeneralDialogWidget(
                                              titleText: 'Bạn có chắc chắn',
                                              actions: [
                                                // ignore: deprecated_member_use
                                                FlatButton(
                                                  onPressed: () {
                                                    setState(
                                                      () {
                                                        ClassroomController
                                                            .deleteExersice(
                                                          widget.countStudents,
                                                          widget.className,
                                                          widget.homeworkId,
                                                          widget.homeworks,
                                                          widget.idClassroom,
                                                          idExersice: item['id']
                                                              .toString(),
                                                          context: context,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text('Xóa'),
                                                  color: Colors.red,
                                                ),
                                                // ignore: deprecated_member_use
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Hủy'),
                                                  color: Colors.black38,
                                                )
                                              ],
                                            );
                                          },
                                          animationType:
                                              DialogTransitionType.size,
                                          curve: Curves.fastOutSlowIn,
                                          duration: Duration(seconds: 1),
                                        );
                                      },
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailExersice(
                                              hashId: item['hashId'].toString(),
                                              deadline:
                                                  item["deadline"].toString(),
                                              exerciseId: item['id'].toString(),
                                              content:
                                                  item['content'].toString(),
                                              countStudents:
                                                  widget.countStudents,
                                              className: widget.className,
                                              homeworkId: widget.homeworkId,
                                              homeworks: widget.homeworks,
                                              idClassroom: widget.idClassroom,
                                              idExersice: item['id'].toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          'Bài tập ngày: ${DateFormat.yMd().format(DateTime.parse(item["createdAt"]))}', // dfdfdfd
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        margin: EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 2,
                                                        ),
                                                        width: 165,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          'Hạn nộp: ${DateFormat.yMd().format(DateTime.parse(item["deadline"]))}',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        width: 165,
                                                      ),
                                                    ],
                                                  ),
                                                  margin:
                                                      EdgeInsets.only(left: 15),
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Đã nộp: ${item['count']}/${widget.countStudents}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      right: 15),
                                                  height: 32,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              child: Html(
                                                data:
                                                    """<div >${item['content']}</div>""",
                                                style: {
                                                  "div": Style(
                                                    height: 18,
                                                    color: Colors.white,
                                                  ),
                                                  "p": Style(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  "a": Style(
                                                      color: Colors.white),
                                                  "h1": Style(
                                                      color: Colors.white),
                                                },
                                              ),
                                              padding: EdgeInsets.only(left: 9),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.only(
                                            left: 25, right: 25),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.black12,
                                          ),
                                          color: Color(0xff00c0ef),
                                        ),
                                      ),
                                    ),
                                    secondaryActions: <Widget>[
                                      IconSlideAction(
                                        caption: 'Sửa',
                                        color: Colors.black45,
                                        icon: Icons.edit,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditExersice(
                                                getFiles: item["files"],
                                                deadline:
                                                    item["deadline"].toString(),
                                                exerciseId:
                                                    item['id'].toString(),
                                                content:
                                                    item['content'].toString(),
                                                countStudents:
                                                    widget.countStudents,
                                                className: widget.className,
                                                homeworkId: widget.homeworkId,
                                                homeworks: widget.homeworks,
                                                idClassroom: widget.idClassroom,
                                                idExersice:
                                                    item['id'].toString(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconSlideAction(
                                        caption: 'Xóa',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () {
                                          showAnimatedDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return ClassicGeneralDialogWidget(
                                                titleText: 'Bạn có chắc chắn',
                                                actions: [
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          ClassroomController
                                                              .deleteExersice(
                                                            widget
                                                                .countStudents,
                                                            widget.className,
                                                            widget.homeworkId,
                                                            widget.homeworks,
                                                            widget.idClassroom,
                                                            idExersice:
                                                                item['id']
                                                                    .toString(),
                                                            context: context,
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Text('Xóa'),
                                                    color: Colors.red,
                                                  ),
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Hủy'),
                                                    color: Colors.black38,
                                                  )
                                                ],
                                              );
                                            },
                                            animationType:
                                                DialogTransitionType.size,
                                            curve: Curves.fastOutSlowIn,
                                            duration: Duration(seconds: 1),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 8, bottom: 5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Container(
                          child: Text('Kiểm tra lại kết nối'),
                        ),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
