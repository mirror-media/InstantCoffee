import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error }

class ToastFactory {
  static void showToast(String msg, ToastType type) {
    Color backgroundColor;
    if (type == ToastType.success) {
      backgroundColor = Colors.green;
    } else if (type == ToastType.error) {
      backgroundColor = Colors.redAccent;
    } else {
      backgroundColor = Colors.grey; // 預設顏色
    }

    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}