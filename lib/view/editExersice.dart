import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:azt/controller/classroom_controller.dart';
import 'package:azt/controller/upload_controller.dart';
import 'package:azt/view/detailClass_teacher.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mime/mime.dart';

enum SubmitStatus { notSubmitted, submitting, doneSubmit }
typedef void OnDownloadProgressCallback(int receivedBytes, int totalBytes);
typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);
void main() {
  runApp(EditExersice());
}

class EditExersice extends StatefulWidget {
  EditExersice({
    this.idClassroom,
    this.countStudents,
    this.className,
    this.homeworkId,
    this.homeworks,
    this.deadline,
    this.exerciseId,
    this.idExersice,
    this.content,
    this.getFiles,
  });
  final dynamic getFiles;
  final String idClassroom;
  final String countStudents;
  final String className;
  final String homeworkId;
  final String homeworks;
  final String deadline;
  final String content;
  final String idExersice;
  final String exerciseId;
  @override
  _EditExersiceState createState() => _EditExersiceState();
}

class _EditExersiceState extends State<EditExersice> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController content;
  TextEditingController deadline;
  List<String> filePaths;
  List<dynamic> imgUploadedFiles = [];
  List<dynamic> imgUpdate = [];
  SubmitStatus submitStatus = SubmitStatus.notSubmitted;

  Future<void> loadFiles(String getFile) async {
    FilePickerResult result = getFile == "fileDoccuments"
        ? await FilePicker.platform.pickFiles(
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
          )
        : await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.image,
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
                  GestureDetector(
                    child: Icon(Icons.clear),
                    onTap: () {
                      setState(() {
                        filePaths.remove(filePaths[index]);
                      });
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black12),
                color: Color(0xFFecf0f5),
              ),
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 6),
              padding: EdgeInsets.only(top: 7, bottom: 7, left: 10, right: 5),
            );
          }),
        ),
      );
    else
      return Container();
  }

  // ignore: missing_return
  Widget getFiles() {
    if (jsonEncode(widget.getFiles) != 'null') {
      return Column(
        children: List.generate(
          imgUpdate.length,
          (numberFiles) {
            return Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      imgUpdate[numberFiles]['name'],
                      maxLines: 1,
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                  GestureDetector(
                    child: Icon(Icons.clear),
                    onTap: () {
                      setState(
                        () {
                          imgUpdate.removeAt(numberFiles);
                        },
                      );
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black12),
                color: Color(0xFFecf0f5),
              ),
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 6),
              padding: EdgeInsets.only(top: 7, bottom: 7, left: 10, right: 5),
            );
          },
        ),
      );
    } else {
      return Container();
    }
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
    setState(() {
      for (var i = 0; i < imgUpdate.length; i++) {
        imgUploadedFiles.add({
          "name": imgUpdate[i]['name'].toString(),
          "mines": imgUpdate[i]['mimes'].toString(),
          "path": imgUpdate[i]['path'].toString(),
          "extension": imgUpdate[i]['extension'].toString(),
          "size": imgUpdate[i]['size'].toString(),
          "url": imgUpdate[i]['url'].toString(),
          "upload_url": imgUpdate[i]['upload_url'].toString()
        });
      }
    });
    try {
      setState(() {
        submitStatus = SubmitStatus.submitting;
      });
      filePaths != null ? await uploadAllFile() : print('No file selected');

      if (filePaths != null) {
        await ClassroomController.editExersice(
          files: jsonEncode(imgUploadedFiles),
          context: context,
          idExersice: widget.idExersice,
          content: content.text,
          deadline: deadline.text,
          exerciseId: widget.exerciseId,
          countStudents: widget.countStudents,
          className: widget.className,
          homeworkId: widget.homeworkId,
          homeworks: widget.homeworks,
          idClassroom: widget.idClassroom,
        );
      } else {
        await ClassroomController.editExersice(
          files: jsonEncode(imgUploadedFiles),
          context: context,
          idExersice: widget.idExersice,
          content: content.text,
          deadline: deadline.text,
          exerciseId: widget.exerciseId,
          countStudents: widget.countStudents,
          className: widget.className,
          homeworkId: widget.homeworkId,
          homeworks: widget.homeworks,
          idClassroom: widget.idClassroom,
        );
      }

      Fluttertoast.showToast(
          msg: "Sửa bài tập thành công",
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
                    countStudents: widget.countStudents,
                    className: widget.className,
                    homeworkId: widget.homeworkId,
                    homeworks: widget.homeworks,
                    idClassroom: widget.idClassroom,
                  )),
          (Route<dynamic> route) => false);
    } catch (err) {
      Fluttertoast.showToast(
          msg: "Sửa bài tập thành công",
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
  void initState() {
    super.initState();
    if (jsonEncode(widget.getFiles) != 'null') {
      for (var i = 0; i < jsonDecode(widget.getFiles).length; i++) {
        imgUpdate.add({
          "name": jsonDecode(widget.getFiles)[i]['name'].toString(),
          "mines": jsonDecode(widget.getFiles)[i]['mimes'].toString(),
          "path": jsonDecode(widget.getFiles)[i]['path'].toString(),
          "extension": jsonDecode(widget.getFiles)[i]['extension'].toString(),
          "size": jsonDecode(widget.getFiles)[i]['size'].toString(),
          "url": jsonDecode(widget.getFiles)[i]['url'].toString(),
          "upload_url": jsonDecode(widget.getFiles)[i]['upload_url'].toString()
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFecf0f5),
      appBar: AppBar(
        title: Text('Sửa bài tập', style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.of(context).pop();
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
                          child: DateTimePicker(
                            controller: deadline =
                                TextEditingController(text: widget.deadline),
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.event,
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Chọn thời hạn nộp bài tập* ',
                              hintText: 'Chọn thời hạn nộp ',
                            ),
                            dateMask: 'dd/MM/yyyy',
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            icon: Icon(Icons.event),
                            dateLabelText: 'Ngày',
                            onChanged: (value) => print(value),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Vui lòng chọn thời hạn nộp bài tập';
                              }
                              return null;
                            },
                            onSaved: (value) => print(value),
                          ),
                          margin: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 15,
                            bottom: 10,
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            controller: content =
                                TextEditingController(text: widget.content),
                            minLines: 6,
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nội dung bài tập* ',
                              hintText: 'Nhập nội dung bài tập',
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
                          onTap: Platform.isIOS
                              ? () async {
                                  showAdaptiveActionSheet(
                                    context: context,
                                    actions: <BottomSheetAction>[
                                      BottomSheetAction(
                                        title: Text('Thư viện ảnh'),
                                        onPressed: () {
                                          loadFiles("fileAlbumImages");
                                        },
                                      ),
                                      BottomSheetAction(
                                        title: Text('Tài liệu'),
                                        onPressed: () {
                                          loadFiles("fileDoccuments");
                                        },
                                      ),
                                    ],
                                    cancelAction: CancelAction(
                                      title: Text('Cancel'),
                                    ),
                                  );
                                }
                              : () {
                                  loadFiles("fileDoccuments");
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
                        getFiles(),
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
                                  'CẬP NHẬT',
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.yellow[800],
                                ),
                                onPressed: () {
                                  Navigator.pop(
                                    context,
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
                              top:
                                  BorderSide(width: 1.5, color: Colors.black12),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  margin:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
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
