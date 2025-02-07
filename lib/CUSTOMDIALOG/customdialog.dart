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
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 600,
        height: 400, // Increased height for better spacing
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/notification_bg.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title row
              Row(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Description text
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Instruction text before the text field
              Row(
                children: [
                  Text(
                    'Write your reason for rechecking the paper:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // TextField for input
              TextField(
                controller: _controller,
                maxLines: 4, // Makes the TextField behave like a text area
                decoration: InputDecoration(
                  labelText: "Your Message", // Label for the text area
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // Buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Learn more link (empty for now)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // Add functionality for the link text here
                      },
                      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
                      child: Text(''),
                    ),
                  ),
                  // Right side: Cancel and Confirm buttons
                  Row(
                    children: [
                      TextButton(
                        onPressed: widget.OnCancell,
                        child: Text(widget.btn1),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 25),
                          backgroundColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          minimumSize: Size(100, 45),
                        ),
                      ),
                      SizedBox(width: 15),
                      TextButton(
                        onPressed: widget.OnConfirm,
                        child: Text(widget.btn2),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 25),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          minimumSize: Size(100, 45),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
