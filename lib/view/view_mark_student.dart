import 'dart:io';

import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewMarking extends StatefulWidget {
  ViewMarking({
    this.answerId,
    this.fullName,
    this.className,
    this.homeworkId,
    this.viewScreen,
  });
  final String answerId;
  final String fullName;
  final String className;
  final String homeworkId;
  final String viewScreen;
  @override
  ViewMarkingState createState() => ViewMarkingState();
}

class ViewMarkingState extends State<ViewMarking> {
  var baseAccess;
  var accessToken;
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    setBaseAccess();
  }

  void setBaseAccess() async {
    final token = await Prefs.getPref(ANONYMOUS_TOKEN);

    // ignore: await_only_futures
    await setState(() {
      accessToken = token;
      baseAccess =
          '$AZT_DOMAIN_NAME/en/auth/login?access_token=$token&return_url=';
      print(baseAccess);
    });
    print('accesstoken1::: ' + token);
  }

  Future<bool> _onBackPressed() {
    Navigator.pop(
      context,
    );
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 55),
                  height: MediaQuery.of(context).size.height / 1,
                  child: WebView(
                    initialUrl: widget.viewScreen == 'history'
                        ? baseAccess +
                            '/en/xem-bai-tap/' +
                            widget.homeworkId +
                            widget.answerId
                        : baseAccess + '/en/xem-bai-tap/' + widget.answerId,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
                Container(
                  color: Colors.blue,
                  height: 92,
                ),
                Container(
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.blue[600],
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(''),
                            Text(
                              widget.fullName + ', ' + widget.className,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
