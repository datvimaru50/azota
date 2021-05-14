import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:azt/controller/upload_controller.dart';
import 'package:mime/mime.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_html/flutter_html.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:file_picker/file_picker.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

typedef void OnDownloadProgressCallback(int receivedBytes, int totalBytes);
typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

enum SubmitStatus { notSubmitted, submitting, doneSubmit }

class SubmitExersice extends StatefulWidget {
  SubmitExersice({
    this.classroomObj,
    this.studentObj,
    this.homeworkObj,
    this.answerObj,
  });
  final dynamic homeworkObj;
  final dynamic answerObj;
  final dynamic studentObj;
  final dynamic classroomObj;

  @override
  _SubmitExersiceState createState() => _SubmitExersiceState();
}

class _SubmitExersiceState extends State<SubmitExersice> {
  List<Asset> images;
  List<dynamic> imgUploadedFiles = [];
  SubmitStatus submitStatus = SubmitStatus.notSubmitted;

  List<String> fileNames;
  List<String> filePaths;

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

  Future<void> _showErrorToast(String errMsg) async {
    return Fluttertoast.showToast(
      msg: errMsg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> loadFiles() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4', 'mov'],
    );

    if (result != null) {
      print('chon file thanh cong');
      // List<File> files = result.paths.map((path) => File(path)).toList();
      setState(() {
        fileNames = result.names.map((name) => name).toList();
        filePaths = result.paths.map((path) => path).toList();
      });
    } else {
      print('User không chọn file!');
    }
  }

  // *** Load ảnh thừ thư viện
  Future<void> loadAssets() async {
    List<Asset> resultList;
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        materialOptions: MaterialOptions(
          actionBarTitle: "Ảnh theo nhóm",
          allViewTitle: "Chọn hình ảnh",
          startInAllView: true,
          selectionLimitReachedText: "Bạn không thể chọn thêm",
        ),
      );
    } on Exception catch (e) {
      print('Lỗi: ' + e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  // Build grid of photos
  Widget buildGridView() {
    if (images != null)
      return Container(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            children: List.generate(images.length, (index) {
              Asset asset = images[index];
              return AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              );
            }),
          ));
    else
      return Container(color: Colors.white);
  }

  // Build grid of photos
  Widget buildGridViewFiles() {
    if (filePaths != null)
      return Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            children: List.generate(fileNames.length, (index) {
              return Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    color: Colors.blue,
                  ),
                  Flexible(
                    child: Container(
                        child: Text(
                      fileNames[index],
                      style: TextStyle(fontStyle: FontStyle.italic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                  )
                ],
              );
            }),
          ));
    else
      return Container(color: Colors.white);
  }

  static HttpClient getHttpClient() {
    HttpClient httpClient = new HttpClient();
    return httpClient;
  }

  Future uploadSingleImage(
      Asset image, OnUploadProgressCallback onUploadProgress) async {
    final String imgPath =
        await FlutterAbsolutePath.getAbsolutePath(image.identifier);
    var fileStream = File(imgPath).openRead();
    var fileName = image.name;
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

  Future uploadSingleFile(
      String filePath, OnUploadProgressCallback onUploadProgress) async {
    var fileStream = File(filePath).openRead();
    var fileName = filePath.split('/').last;
    int totalByteLength = File(filePath).lengthSync();

    print('fileBytes length:::: $totalByteLength');

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
      images != null ? await uploadAllImage() : print('no image selected');
      filePaths != null ? await uploadAllFile() : print('no file selected');
      String successStr = await UploadController.saveUploadInfo({
        "files": jsonEncode(imgUploadedFiles),
        "homeworkId": widget.homeworkObj["hashId"],
        "studentId": widget.studentObj["id"].toString(),
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
    for (var i = 0; i < images.length; i++) {
      await uploadSingleImage(images[i], callbackUpload);
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
    Intl.defaultLocale = 'vi_VN';
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    // Nếu giáo viên đã chấm bài, không hiển thị nút chụp ảnh nữa
    return widget.answerObj["confirmedAt"] == null
        ? Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Lớp: ' + widget.classroomObj['name'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Container(
                      alignment: Alignment.center,
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
                              text: widget.homeworkObj['hashId'].toString(),
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.only(top: 4, bottom: 10),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15, right: 10, top: 15, bottom: 15),
                            child: Text(
                              'Hạn nộp: ${DateFormat.yMd().format(DateTime.parse(widget.homeworkObj["deadline"]))}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  right: 10, top: 10, bottom: 10),
                              child: Text(
                                widget.studentObj["fullName"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      color: Color(0xff00a7d0),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Html(
                        data: widget.homeworkObj["content"],
                      ),
                      padding: EdgeInsets.only(
                          top: 6, bottom: 6, left: 10, right: 10),
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
                                  onPressed: loadAssets,
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
                                onPressed: loadFiles,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.attach_file,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      'Chọn file âm thanh/video',
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
                      padding: EdgeInsets.only(
                          top: 15, left: 30, right: 30, bottom: 20),
                    ),
                    submitStatus == SubmitStatus.submitting
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                    'Bài làm đang được tải lên. Vui lòng đợi trong giây lát!',
                                    textAlign: TextAlign.center),
                              ),
                              CircularProgressIndicator(),
                            ],
                          )
                        : submitStatus == SubmitStatus.doneSubmit
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Đã nộp bài thành công!',
                                      style: TextStyle(color: Colors.green)),
                                  Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  ),
                                ],
                              )
                            : Container(),
                    buildGridView(),
                    buildGridViewFiles(),
                    images == null && filePaths == null
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.file_upload),
                                label: Text('NỘP BÀI'),
                                onPressed:
                                    submitStatus == SubmitStatus.submitting
                                        ? null
                                        : handleSubmit,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    icon: Icon(Icons.refresh),
                                    label: Text('LÀM LẠI'),
                                    onPressed:
                                        submitStatus == SubmitStatus.submitting
                                            ? null
                                            : () {
                                                setState(() {
                                                  images = null;
                                                  filePaths = null;
                                                  submitStatus =
                                                      SubmitStatus.notSubmitted;
                                                });
                                              }),
                              )
                            ],
                          ),
                  ],
                ),
                margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                padding: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}
