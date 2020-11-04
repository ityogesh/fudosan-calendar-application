import 'package:flutter/cupertino.dart';

import 'colorconstant.dart';

class FontHelper {
  static String fontFamily = "NotoSansJP";
  static double appBarTitleSize = 16.0;
  static double hintTextSize = 16.0;
  static double buttonTextSize = 16.0;

  static TextStyle appBarTitle = TextStyle(
      fontFamily: "$fontFamily",
      fontSize: appBarTitleSize,
      fontWeight: FontWeight.bold);

  static TextStyle hintText = TextStyle(
      fontFamily: "$fontFamily",
      fontSize: hintTextSize,
      color: ColorConstant.lHintTextColor);

  static TextStyle buttonText = TextStyle(
    fontFamily: "$fontFamily",
    fontSize: buttonTextSize,
    fontWeight: FontWeight.bold,
  );

 // static TextStyle 
}
