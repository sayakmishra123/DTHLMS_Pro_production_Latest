import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';

bool eye = false;

class ChangePasswordMobile extends StatefulWidget {
  const ChangePasswordMobile({super.key});

  @override
  State<ChangePasswordMobile> createState() => _ChangePasswordMobileState();
}

class _ChangePasswordMobileState extends State<ChangePasswordMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorPage.mainBlue,
        title: Text(
          'Change Password',
          style: FontFamily.style.copyWith(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ChangePasswordBox(),
      ),
    );
  }
}

class ChangePasswordBox extends StatefulWidget {
  @override
  State<ChangePasswordBox> createState() => _ChangePasswordBoxState();
}

class _ChangePasswordBoxState extends State<ChangePasswordBox> {
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate 20% of the width for padding
        double horizontalPadding = constraints.maxWidth * 0.05;
        double h = constraints.maxHeight * 0.08;

        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xffF8FBFF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Image(
                        image: AssetImage('assets/lock.png'),
                        // height: 30, // Uncomment if you want to specify the height
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10), // Add some space between the rows
                Row(
                  children: [
                    Text(
                      'Change Password',
                      style: FontFamily.styleb,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      'To change your password, please fill in the fields below. Your password must contain at least 8 characters, and it must also include at least one uppercase letter, one lowercase letter, one number, and one special character.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    )),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Text(
                      'Current Password',
                      style: FontFamily.styleb.copyWith(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),

                PasswordTextField(
                  controller: currentPassword,
                  label: 'Current Password',
                  onPressed: () {
                    setState(() {
                      eye = !eye;
                    });
                  },
                ),

                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'New Password',
                      style: FontFamily.styleb.copyWith(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),

                PasswordTextField(
                  controller: newPassword,
                  label: 'New Password',
                  onPressed: () {
                    setState(() {
                      eye = !eye;
                    });
                  },
                ),

                SizedBox(height: 20),
                // Confirm Password
                Row(
                  children: [
                    Text(
                      'Confirm Password',
                      style: FontFamily.styleb.copyWith(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),

                PasswordTextField(
                  controller: confirmPassword,
                  label: 'Confirm Password',
                  onPressed: () {
                    setState(() {
                      eye = !eye;
                    });
                  },
                ),
                SizedBox(height: 80),
                Row(
                  children: [
                    // TextButton(onPressed: () {
                    //       print(currentPassword.text);
                    //       print(newPassword.text);
                    //       print(confirmPassword.text);
                    //       setState(() {
                    //         print('dfgerg');
                    //       });
                    //     }, child: Text('data')),
                    Expanded(
                      child: MaterialButton(

                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        height: 50,
                        color: ColorPage.mainBlue,
                        onPressed: () {
                          print(currentPassword.text);
                          print(newPassword.text);
                          print(confirmPassword.text);
                          setState(() {
                            print('dfgerg');
                          });
                        },
                        child: Text(
                          'Change Passwordsd',
                          style: FontFamily.style
                              .copyWith(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String label;
  final Function()? onPressed;
  final TextEditingController controller;

  const PasswordTextField({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.controller,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool eye = true; // State variable to manage visibility of password

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: eye,
      decoration: InputDecoration(
        prefixIcon: Image(
          image: AssetImage('assets/locksmall.png'),
        ),
        suffixIcon: IconButton(
          iconSize: 20,
          onPressed: () {
            setState(() {
              eye = !eye; // Toggle password visibility
            });
            if (widget.onPressed != null) {
              widget.onPressed!();
            }
          },
          icon: eye
              ? Icon(Icons.visibility_off_outlined)
              : Icon(Icons.visibility_outlined),
          color: Colors.grey[600],
        ),
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // No border when not focused or enabled
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.4), // Grey border color
            width: 2, // Border width set to 2
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color:
                Colors.grey.withOpacity(0.4), // Grey border color when focused
            width: 2, // Border width set to 2
          ),
        ),
        filled: true,
        fillColor: Colors.transparent,
      ),
    );
  }
}
