import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String mychild;
  final Color mycolor;
  final Color btncolor;

  final void Function()? onPressed;

   MyButton({super.key,required this.mychild,required this.mycolor,required this.onPressed,required this.btncolor
   });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(

                        splashColor: widget.mycolor,
                        hoverColor: widget.mycolor.withOpacity(0.5),
                        padding: EdgeInsets.all(16),
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: widget.btncolor,
                        onPressed: widget.onPressed,
                        child: Text(widget.mychild),
                      );
  }
}