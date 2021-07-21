import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:login_fudosan/screens/homescreen.dart';
import 'package:login_fudosan/utils/colorconstant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(ColorConstant.statusBarColor);
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: ColorConstant.statusBarColor));
     */
    return MaterialApp(
      title: '不動産カレンダー',
      theme: ThemeData(
        fontFamily: "NotoSansJP",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Show(), //MyMaterialApp(),
      supportedLocales: [
        const Locale('en'),
        const Locale('ja'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
