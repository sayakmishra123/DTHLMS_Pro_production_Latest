import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:flutter/material.dart';

import '../THEME_DATA/font/font_family.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPage.color1,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'ALL ONLINE',
                  style: TextStyle(
                    color: ColorPage.red,
                    fontWeight: FontWeight.bold,
                    fontSize: ClsFontsize.Large + 1,
                  ), //25
                ),
              ],
            ),
            Row(
              children: [
                Text.rich(TextSpan(
                    style: FontFamily.font3,
                    text: 'TOTAL VIDEO:',
                    children: const <InlineSpan>[
                      TextSpan(
                          style: TextStyle(
                              color: ColorPage.white,
                              fontWeight: FontWeight.bold),
                          text: '8')
                    ])),
              ],
            ),
            Row(
              children: [
                Text.rich(TextSpan(
                    style: FontFamily.font3,
                    text: 'DURATION:',
                    children: const <InlineSpan>[
                      TextSpan(
                          style: TextStyle(color: ColorPage.white),
                          text: '04:06:57')
                    ])),
              ],
            ),
            Row(
              children: [
                Text.rich(TextSpan(
                    style: FontFamily.font3,
                    text: 'View limit:',
                    children: const <InlineSpan>[
                      TextSpan(
                          style: TextStyle(
                              color: ColorPage.white,
                              fontWeight: FontWeight.bold),
                          text: ' 00:00:01')
                    ])),
              ],
            ),
            Row(
              children: [
                Text.rich(TextSpan(
                    style: FontFamily.font3,
                    text: 'Expiry date:',
                    children: const <InlineSpan>[
                      TextSpan(
                          style: TextStyle(
                              color: ColorPage.white,
                              fontWeight: FontWeight.bold),
                          text: '2026-08-31')
                    ])),
              ],
            )
          ],
        ),
      ),
    );
  }
}
