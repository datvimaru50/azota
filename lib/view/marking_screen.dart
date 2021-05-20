import 'dart:io';

import 'package:azt/config/connect.dart';
import 'package:azt/config/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MarkingScreen extends StatefulWidget {
  MarkingScreen({
    this.answerId,
  });
  final String answerId;
  @override
  MarkingScreenState createState() => MarkingScreenState();
}

class MarkingScreenState extends State<MarkingScreen> {
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
    var token = await Prefs.getPref(ACCESS_TOKEN);
    // ignore: await_only_futures
    await setState(() {
      accessToken = token;
      baseAccess =
          '$AZT_DOMAIN_NAME/en/auth/login?access_token=$token&return_url=';
      print(baseAccess);
    });
    print('accesstoken1::: ' + token);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('webview'),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
      ),
      body: WebView(
        initialUrl: baseAccess + '/en/admin/mark-exercise/' + widget.answerId,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
