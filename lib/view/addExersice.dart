import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/view/detailClass_teacher.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mime/mime.dart';
import 'package:file_picker/file_picker.dart';
import 'package:azt/controller/upload_controller.dart';

typedef void OnDownloadProgressCallback(int receivedBytes, int totalBytes);
typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

enum SubmitStatus { notSubmitted, submitting, doneSubmit }

class AddExersice extends StatefulWidget {
  AddExersice({
    this.id,
    this.countStudents,
    this.className,
    this.homeworkId,
    this.homeworks,
  });
  final String id;
  final String countStudents;
  final String className;
  final String homeworkId;
  final String homeworks;
  @override
  _AddExersiceState createState() => _AddExersiceState();
}

class _AddExersiceState extends State<AddExersice> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController deadline = new TextEditingController();
  TextEditingController content = new TextEditingController();

  SubmitStatus submitStatus = SubmitStatus.notSubmitted;
  List<String> filePaths;

  List<dynamic> imgUploadedFiles = [];

  Future<void> loadFiles() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'mp4',
        'mov',
        'jpg',
        'png',
        'jpeg',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'pdf'
      ],
    );

    if (result != null) {
      setState(() {
        filePaths = result.paths.map((path) => path).toList();
      });
    } else {
      print('User không chọn file!');
    }
  }

  // Build grid of files
  Widget buildGridViewFiles() {
    if (filePaths != null)
      return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          children: List.generate(filePaths.length, (index) {
            return Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      filePaths.elementAt(index).split('/').last,
                      maxLines: 1,
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          filePaths.remove(filePaths[index]);
                        });
                      })
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black12),
                color: Color(0xFFecf0f5),
              ),
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 6),
              padding: EdgeInsets.only(left: 10),
            );
          }),
        ),
      );
    else
      return Container();
  }

  static HttpClient getHttpClient() {
    HttpClient httpClient = new HttpClient();
    return httpClient;
  }

  Future uploadSingleFile(
      String filePath, OnUploadProgressCallback onUploadProgress) async {
    var fileStream = File(filePath).openRead();
    var fileName = filePath.split('/').last;
    int totalByteLength = File(filePath).lengthSync();

    final uploadInfor = await UploadController.getPulicUpload(
        fileName, totalByteLength.toString(), lookupMimeType(filePath));

    var httpClient = getHttpClient();

    final request = await httpClient.putUrl(Uri.parse(uploadInfor.upload_url));

    request.headers
        .set(HttpHeaders.contentTypeHeader, lookupMimeType(filePath));
    request.headers.add("x-amz-acl", 'public-read');
    request.contentLength = totalByteLength;

    int byteCount = 0;

    Stream<List<int>> streamUpload = fileStream.transform(
      new StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          byteCount += data.length;

          if (onUploadProgress != null) {
            onUploadProgress(byteCount, totalByteLength);
            // CALL STATUS CALLBACK;
          }
          sink.add(data);
        },
        handleError: (error, stack, sink) {
          print(error.toString());
        },
        handleDone: (sink) {
          sink.close();
          setState(() {
            imgUploadedFiles.add({
              "name": uploadInfor.name,
              "mines": uploadInfor.mimes,
              "path": uploadInfor.path,
              "extension": uploadInfor.extension,
              "size": uploadInfor.size,
              "url": uploadInfor.url,
              "upload_url": uploadInfor.upload_url
            });
          });

          print('Upload img item successfully!');
          // UPLOAD DONE;
        },
      ),
    );

    await request.addStream(streamUpload);

    final httpResponse = await request.close();

    if (httpResponse.statusCode != 200) {
      throw Exception('Error uploading file');
    } else {
      return await readResponseAsString(httpResponse);
    }
  }

  Future<void> handleSubmit() async {
    try {
      setState(() {
        submitStatus = SubmitStatus.submitting;
      });

      filePaths != null ? await uploadAllFile() : print('No file selected');

      if (filePaths != null) {
        await ClassroomController.addExersice({
          "files": jsonEncode(imgUploadedFiles),
          "classroomId": widget.id,
          "content": content.text,
          "deadline": deadline.text,
          "name": "Bài tập"
        });
      } else {
        await ClassroomController.addExersice({
          "classroomId": widget.id,
          "content": content.text,
          "deadline": deadline.text,
          "name": "Bài tập"
        });
      }

      Fluttertoast.showToast(
          msg: "Tạo bài tập thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        submitStatus = SubmitStatus.doneSubmit;
      });

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => DetailClass(
                    idClassroom: widget.id,
                    countStudents: widget.countStudents,
                    className: widget.className,
                    homeworks: widget.homeworks,
                  )),
          (Route<dynamic> route) => false);
    } catch (err) {
      Fluttertoast.showToast(
          msg: "Tạo bài tập không thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      setState(() {
        submitStatus = SubmitStatus.notSubmitted;
      });
    }
  }

  Future<void> uploadAllFile() async {
    for (var i = 0; i < filePaths.length; i++) {
      await uploadSingleFile(filePaths[i], callbackUpload);
    }
  }

  static Future<String> readResponseAsString(HttpClientResponse response) {
    var completer = new Completer<String>();
    var contents = new StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  static void callbackUpload(int sentBytes, int totalBytes) {
    print('Upload progress: ${sentBytes / totalBytes * 100}%');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text('Thêm bài tập', style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailClass(
                  idClassroom: widget.id,
                  countStudents: widget.countStudents,
                  className: widget.className,
                  homeworks: widget.homeworks,
                ),
              ),
            );
          },
        ),
      ),
      body: submitStatus == SubmitStatus.submitting
          ? Center(
              child: Container(
                width: 150,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotatePulse,
                  color: Color(0xff00c0ef),
                ),
              ),
            )
          : ListView(
              children: [
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                            bottom: 5,
                          ),
                          child: DateTimePicker(
                            controller: deadline,
                            decoration: InputDecoration(
                                suffixIcon:
                                    Icon(Icons.event, color: Colors.black54),
                                border: OutlineInputBorder(),
                                labelText: 'Chọn thời hạn nộp bài tập* ',
                                counterStyle: TextStyle(color: Colors.black)),
                            dateMask: 'dd/MM/yyyy',
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            icon: Icon(Icons.event),
                            dateLabelText: 'Ngày',
                            onChanged: (value) => print(value),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Vui lòng chọn ngày sinh';
                              }
                              return null;
                            },
                            onSaved: (value) => print(value),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            controller: content,
                            minLines: 6,
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nội dung bài tập* ',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Vui lòng điền nội dung bài tập';
                              }
                              return null;
                            },
                          ),
                          margin: EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 20,
                            bottom: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showAdaptiveActionSheet(
                              context: context,
                              actions: <BottomSheetAction>[
                                BottomSheetAction(
                                    title: Text('Thư viện ảnh'),
                                    onPressed: () {}),
                                BottomSheetAction(
                                    title: Text('Tài liệu'),
                                    onPressed: loadFiles),
                              ],
                              cancelAction: CancelAction(
                                title: Text('Cancel'),
                              ), // onPressed parameter is optional by default will dismiss the ActionSheet
                            );
                          },
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '+ Thêm file bài tập',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                            padding:
                                EdgeInsets.only(left: 32, top: 10, bottom: 5),
                          ),
                        ),
                        Container(
                          child: Text(
                              'Chụp ảnh bài tập hoặc chọn file word, pdf, audio, video có sẵn'),
                          margin:
                              EdgeInsets.only(left: 30, right: 30, bottom: 5),
                        ),
                        buildGridViewFiles(),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: submitStatus ==
                                        SubmitStatus.submitting
                                    ? null
                                    : () {
                                        if (_formKey.currentState.validate()) {
                                          handleSubmit();
                                        }
                                      },
                                child: Text(
                                  'THÊM BÀI TẬP',
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.yellow[800],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailClass(
                                        idClassroom: widget.id,
                                        countStudents: widget.countStudents,
                                        className: widget.className,
                                        homeworks: widget.homeworks,
                                        homeworkId: widget.homeworkId,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'HỦY',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(
                              left: 35, top: 10, bottom: 10, right: 35),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 2, color: Colors.black12),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  margin:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      width: 1,
                      color: Color(0xff00a7d0),
                    ),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
    );
  }
}
