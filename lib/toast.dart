import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

class ToastClass {
  static showToast(String msg,
      {required context, int? duration, int? position}) {
    FlutterToastr.show(
        // duration:4,
        "Item removed from cart", // Toast message
        context, // Context for the toast
        duration: FlutterToastr.lengthLong, // Duration of the toast
        position: FlutterToastr.bottom, // Position of the toast
        backgroundColor: ColorPage.buttonColor,
        textStyle: TextStyle(fontSize: 15, color: Colors.white)
        // Optional: background color of the toast
        // textColor: Colors.white,          // Optional: text color of the toast
        // fontSize: 16.0,                   // Optional: font size of the toast
        );
  }
}
