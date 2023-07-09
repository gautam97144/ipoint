import 'package:flutter/material.dart';

class CustomTheme {
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color primarycolor = Color(0xff00F0FF);
  static const Color primarylightcolor = Color(0xffD7FEFF);
  static const Color yellow = Color(0xffF9EC23);
  static const Color red = Color(0xffED1C24);
  static const Color darkblue = Color(0xff0000FF);
  static const Color grey = Color(0xffE6E6E6);
  static const Color shadowcolor = Color(0xffFFFFFF);
  static const Color shadowcolor1 = Color(0xff3090A6);
  static const Color offwhite = Color(0xffB3B3B3);
  static const Color darkGrey = Color(0xff808080);
  static const Color lightGrey = Color(0xffF2F2F2);

  static const String fontFamily = "Noto_Sans";

  static TextStyle body1 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static TextStyle body5 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static TextStyle body6 = TextStyle(
      fontFamily: fontFamily,
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic);

  static TextStyle body9 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static TextStyle body7 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static TextStyle body2 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  static TextStyle body3 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static TextStyle body4 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static TextStyle body8 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.grey.shade400,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle inputFieldHintStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: grey,
  );

  static TextStyle buttonTextStyle = TextStyle(
      //  fontFamily: fontFamily,
      fontSize: 16,
      color: black,
      fontWeight: FontWeight.bold);

  static TextStyle subtitle = TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      color: black,
      fontWeight: FontWeight.bold);

  static TextStyle headline = TextStyle(
      fontFamily: fontFamily,
      fontSize: 20,
      color: black,
      fontWeight: FontWeight.bold);

  static TextStyle textStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: black,
  );
  static TextStyle italic = TextStyle(
      fontFamily: fontFamily,
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic);

  static TextStyle title = TextStyle(
    fontFamily: fontFamily,
    color: Colors.grey,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static TextStyle title1 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.black,
    fontSize: 16,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  );
  static TextStyle title2 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.black,
    fontSize: 14,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  );

  static TextStyle title3 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.grey,
    fontSize: 16,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  );
  static TextStyle title4 = TextStyle(
    fontFamily: fontFamily,
    color: Colors.grey,
    fontSize: 14,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  );
}
