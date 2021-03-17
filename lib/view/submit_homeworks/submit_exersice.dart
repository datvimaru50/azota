import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:azt/controller/upload_controller.dart';
import 'package:mime/mime.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

typedef void OnDownloadProgressCallback(int receivedBytes, int totalBytes);
typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

enum SubmitStatus { notSubmitted, submitting, doneSubmit }

class SubmitExersice extends StatefulWidget {
  SubmitExersice(
      {this.hashId,
      this.studentId,
      this.className,
      this.stdName,
      this.deadline});

  final String hashId;
  final int studentId;
  final String className;
  final String stdName;
  final String deadline;

  @override
  _SubmitExersiceState createState() => _SubmitExersiceState();
}

class _SubmitExersiceState extends State<SubmitExersice> {
  final picker = ImagePicker();
  var _controllerClear = TextEditingController();
  List<dynamic> imgFilePaths = [];
  List<dynamic> imgUploadedFiles = [];
  SubmitStatus submitStatus = SubmitStatus.notSubmitted;

  Future<void> _showErrorToast(String errMsg) async {
    return Fluttertoast.showToast(
        msg: errMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> _showSuccessToast(String successMsg) async {
    return Fluttertoast.showToast(
        msg: successMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static HttpClient getHttpClient() {
    HttpClient httpClient = new HttpClient();
    return httpClient;
  }

  static void callbackUpload(int sentBytes, int totalBytes) {
    print('Upload progress: ${sentBytes / totalBytes * 100}%');
  }

  Future<void> handleOpenCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      imgFilePaths.add({"url": pickedFile.path, "uploaded": false});
    });
  }

  // OnUploadProgressCallback onUploadProgress

  Future uploadSingleImage(String imgPath, int index,
      OnUploadProgressCallback onUploadProgress) async {
    var fileStream = File(imgPath).openRead();
    var fileName = imgPath.split("/").last;
    int totalByteLength = File(imgPath).lengthSync();
    print('fileBytes length:::: $totalByteLength');

    final uploadInfor = await UploadController.getPulicUpload(
        fileName, totalByteLength.toString(), lookupMimeType(imgPath));

    var httpClient = getHttpClient();

    final request = await httpClient.putUrl(Uri.parse(uploadInfor.upload_url));

    request.headers.set(HttpHeaders.contentTypeHeader, lookupMimeType(imgPath));
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
            imgFilePaths[index]["uploaded"] = true;

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
      await uploadAllImage();

      print('fildfdf upload::: ' + imgUploadedFiles.toString());

      String successStr = await UploadController.saveUploadInfo({
        "files": jsonEncode(imgUploadedFiles),
        "homeworkId": widget.hashId,
        "studentId": widget.studentId.toString(),
        "testbankExams": "[]"
      });

      _showSuccessToast(successStr);

      setState(() {
        submitStatus = SubmitStatus.doneSubmit;
      });
    } catch (err) {
      _showErrorToast(err.toString());
      setState(() {
        submitStatus = SubmitStatus.notSubmitted;
      });
    }
  }

  Future<void> uploadAllImage() async {
    for (var i = 0; i < imgFilePaths.length; i++) {
      await uploadSingleImage(imgFilePaths[i]["url"], i, callbackUpload);
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

  // Future getFile() async {
  //   FilePickerResult getFile = await FilePicker.platform.pickFiles();
  //
  //   setState(
  //     () {
  //       if (getFile != null) {
  //         PlatformFile file = getFile.files.first;
  //
  //         print(getFile.files.first.toString());
  //       }
  //     },
  //   );
  // }
  //
  // List<Widget> imageSelected = <Widget>[
  //   _imagesList.map(
  //           (File item) => Image.file(item)).toList(),
  // ];

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'vi_VN';
    initializeDateFormatting();
    print('student:: ' + widget.studentId.toString());
    print('hashid:::: ' + widget.hashId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            'Lớp: ${widget.className}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          padding: EdgeInsets.only(top: 10),
        ),
        Container(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: 'Mã bài tập:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: ' ${widget.hashId}',
                  style: TextStyle(fontSize: 13, color: Colors.blue),
                ),
              ],
            ),
          ),
          padding: EdgeInsets.only(top: 10),
        ),
        Container(
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Hạn nộp: ${DateFormat.yMd().format(DateTime.parse(widget.deadline))}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        widget.stdName,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black12),
                  ),
                  color: Color(0xfff2f2f2),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Center(
                        child: DottedBorder(
                          color: Colors.blue,
                          strokeWidth: 1,
                          child: TextButton(
                            onPressed: handleOpenCamera,
                            child: Container(
                              child: Column(
                                children: [
                                  Icon(Icons.add_a_photo),
                                  Text(
                                    'Chụp ảnh',
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              width: 100,
                            ),
                          ),
                        ),
                      ),
                      width: 100,
                      color: Color.fromRGBO(27, 171, 161, .05),
                    ),
                    Container(
                      child: DottedBorder(
                        color: Colors.blue,
                        strokeWidth: 1,
                        child: TextButton(
                          onPressed: null,
                          child: Column(
                            children: [
                              Icon(
                                Icons.attach_file,
                                color: Colors.blue,
                              ),
                              Text(
                                'Chọn file (Hỗ trợ Ảnh và Video hoặc Audio)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      width: 100,
                      color: Color.fromRGBO(27, 171, 161, .05),
                      // margin: EdgeInsets.all(10),
                    ),
                  ],
                ),
                padding:
                    EdgeInsets.only(top: 15, left: 30, right: 30, bottom: 20),
              ),
              submitStatus == SubmitStatus.submitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text('  '),
                        Column(
                          children: [
                            Text('Bài làm đang được tải lên,'),
                            Text('vui lòng đợi đợi trong giây lát!')
                          ],
                        ),
                      ],
                    )
                  : submitStatus == SubmitStatus.doneSubmit
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_box,
                              color: Colors.green,
                            ),
                            Text('  '),
                            Column(
                              children: [
                                Text('Bài làm đã được gửi tới giáo viên,'),
                                Text(
                                    'vui lòng kiểm tra thông báo để biết kết quả!')
                              ],
                            ),
                          ],
                        )
                      : Container(),
              imgFilePaths.length == 0
                  ? Container()
                  : Container(
                      child: GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 3,
                      children: <Widget>[
                        ...imgFilePaths
                            .map((dynamic item) => Container(
                                key: UniqueKey(),
                                child: Image.file(File(item["url"]))))
                            .toList()
                      ],
                    )),
              imgFilePaths.length == 0
                  ? Container()
                  : ElevatedButton(
                      onPressed: submitStatus == SubmitStatus.submitting
                          ? null
                          : handleSubmit,
                      child: Text(
                        'NỘP BÀI',
                        style: TextStyle(fontSize: 16),
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
