import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final String description;
  final String btn1;
  final String btn2;
  final String linkText;
  final void Function()? OnCancell;
  final void Function()? OnConfirm;

  CustomDialog({
    required this.title,
    required this.description,
    required this.OnCancell,
    required this.OnConfirm,
    this.btn1 = 'Cancel',
    this.btn2 = 'Confirm',
    this.linkText = 'Learn more',
  });

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder( 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 600,
        height: 280,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/notification_bg.png',
              ),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.min,
            children: [
              // SizedBox(height: 10),
              Row(
                children: [
                  Text(widget.title,
                      // 'Privacy info',
                      style: FontFamily.styleb
                          .copyWith(color: Colors.white, fontSize: 28)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(widget.description,
                        style: FontFamily.style
                            .copyWith(color: Colors.white70, fontSize: 18)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // Add functionality for the link text here
                    },
                    style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                    child: Text('',
                        // 'Learn more',
                        style: FontFamily.style.copyWith(

                            //  backgroundColor: Colors.white,
                            color: Colors.white60,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white60,
                            fontSize: 16)),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: widget.OnCancell,
                      child: Text(
                        widget.btn1,
                        // 'Cancel',
                        style: FontFamily.style
                            .copyWith(color: Colors.white70, fontSize: 18),
                      ),
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                        backgroundColor: Colors.black12,
                        // side: BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        minimumSize: Size(100, 45),
                      ),
                    ),
                    SizedBox(width: 15),
                    TextButton(
                      onPressed: widget.OnConfirm,
                      child: Text(
                        widget.btn2,
                        // 'Confirm',
                        style: FontFamily.styleb
                            .copyWith(color: Color(0xff3366FF), fontSize: 18),
                      ),
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                        backgroundColor: Colors.white,
                        // side: BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        minimumSize: Size(100, 45),
                      ),
                    ),
                  ],
                ),
              ]),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
