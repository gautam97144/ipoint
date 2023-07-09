import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void toast(String data) {
    Fluttertoast.showToast(
      timeInSecForIosWeb: 1,
      msg: data,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
