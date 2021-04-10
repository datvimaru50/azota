import 'package:azt/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:azt/store/notification_store.dart';
void main() {
  runApp(
      ChangeNotifierProvider(
          create: (context) => NotiModel(),
          builder: (context, child){
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Splash(),
            );
          }
      )
  );
}