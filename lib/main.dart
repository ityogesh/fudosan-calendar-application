import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:login_fudosan/screens/loginscreen.dart';
import 'package:login_fudosan/utils/colorconstant.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

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
      title: 'Fudosan Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
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
