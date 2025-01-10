// ignore_for_file: prefer_const_constructors

import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

loader(context) async {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SpinKitPulsingGrid(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven
                    ? Color.fromARGB(255, 102, 132, 141)
                    : ColorPage.color1,
              ),
            );
          },
        );
      });
}
