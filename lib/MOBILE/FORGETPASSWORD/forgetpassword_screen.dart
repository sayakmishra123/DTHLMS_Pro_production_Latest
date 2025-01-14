import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class ForgotScreenMobile extends StatefulWidget {
  const ForgotScreenMobile({super.key});

  @override
  State<ForgotScreenMobile> createState() => _ForgotScreenMobileState();
}

class _ForgotScreenMobileState extends State<ForgotScreenMobile> {
  GlobalKey<FormState> key = GlobalKey();
  GlobalKey<FormState> confirmpsswordKey = GlobalKey();

  GlobalKey<FormState> otpkey = GlobalKey();
  TextEditingController otpCode = TextEditingController();
  RxList<Map<String, dynamic>> countryCode = <Map<String, dynamic>>[
    {"value": 1, "label": "91 - India"},
    {"value": 2, "label": "93 - Afghanistan"},
  ].obs;
  String selectedOption = "email"; // To track selected option (email or phone)
  int selectedCountryCode = 1;
  TextEditingController phno = TextEditingController();
  TextEditingController emailid = TextEditingController();
  TextEditingController otpcode = TextEditingController();

  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  Getx getx = Get.put(Getx());
  final email = InputDecoration(
      prefixIcon: Icon(Icons.email),
      hintText: 'example@gmail.com',
      hintStyle: const TextStyle(color: ColorPage.colorgrey),
      labelText: 'Email',
      labelStyle: GoogleFonts.outfit(),
      filled: true,
      fillColor: Color.fromARGB(255, 248, 249, 252));
  final newpassword = InputDecoration(
    labelText: 'new password',
    hintText: 'Enter new password',
    fillColor: Color.fromARGB(255, 247, 246, 246),
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.5,
        color: Color.fromARGB(255, 196, 194, 194),
      ),
      gapPadding: 20,
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.5,
        color: Color.fromARGB(255, 196, 194, 194),
      ),
      gapPadding: 20,
      borderRadius: BorderRadius.circular(10),
    ),
  );
  final confirmPassword = InputDecoration(
    labelText: 'Confirm password',
    hintText: 'Confirm password',
    fillColor: Color.fromARGB(255, 247, 246, 246),
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.5,
        color: Color.fromARGB(255, 196, 194, 194),
      ),
      gapPadding: 20,
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.5,
        color: Color.fromARGB(255, 196, 194, 194),
      ),
      gapPadding: 20,
      borderRadius: BorderRadius.circular(10),
    ),
  );

  final otp = InputDecoration(
      hintText: '0-0-0-0-0-0',
      hintStyle: const TextStyle(color: ColorPage.colorgrey),
      labelStyle: GoogleFonts.outfit(),
      filled: true,
      fillColor: Color.fromARGB(255, 248, 249, 252));

  String forgetkey = " ";
  String resetcode = " ";
  String phonefromApi = "";
  String emailfromApi = "";
  @override
  void initState() {
    getCountrycodeListFunction().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  Future getCountrycodeListFunction() async {
    countryCode.value = await getCountryId();
  }

  @override
  void dispose() {
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer!.cancel();
      }
    }
    getx.forgetPasswordOTPEntryValue.value = false;
    getx.forgetPasswordNewPasswordEntryValue.value = false;
    getx.forgetPasswordfieldEntryValue.value = true;

    super.dispose();
  }

  Timer? _timer;
  RxBool _isOTPresendEnable = true.obs;
  Rx _start = 60.obs; // 30 seconds

  snackbar() {
    Get.snackbar(
      "OTP Sent", // Title
      "Your OTP has been successfully sent!", // Message
      snackPosition: SnackPosition.TOP, // Display at the top of the screen
      backgroundColor: Colors.blueAccent, // Custom background color
      colorText: Colors.white, // White text for better contrast
      borderRadius: 8, // Slightly rounded corners
      margin: EdgeInsets.symmetric(
          horizontal: 15, vertical: 10), // Margin for positioning
      duration: Duration(seconds: 4), // Visible for 4 seconds
      icon: Icon(
        Icons.sms, // SMS icon for relevance
        color: Colors.white, // Icon color
        size: 30, // Slightly larger icon
      ),
      shouldIconPulse: true, // Add subtle pulse animation to the icon
      forwardAnimationCurve: Curves.easeInOut, // Smooth animation
      reverseAnimationCurve: Curves.easeOut, // Smooth fade-out
      overlayBlur: 2.0, // Blur the background slightly for focus
      barBlur: 5.0, // Blur the snackbar itself for a glassy effect
      snackStyle: SnackStyle.FLOATING, // Make it appear like a floating card
    );
  }

  void startTimer() {
    _isOTPresendEnable.value = false;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start.value > 0) {
        _start.value--;
      } else {
        _isOTPresendEnable.value = true;
        _start.value = 60; // Reset the timer
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Resend OTP?',
            style: FontFamily.styleb,
          ),
          content: Text(
            'Are you sure you want to resend the OTP?',
            style: FontFamily.style
                .copyWith(color: Colors.grey[600], fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(width: 2, color: Colors.blueAccent),
                  ),
                ),
              ),
              onPressed: () {
                resendOtpLogic();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog without resending
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  resendOtpLogic() async {
    try {
      await forgetPasswordGeneratecode(
              context,
              selectedCountryCode ?? 0,
              phno.text ?? "",
              emailid.text ?? "",
              selectedCountryCode ?? 0,
              phno.text ?? "")
          .then((value) {
        getx.forgetPasswordfieldEntryValue.value = false;
        getx.forgetPasswordOTPEntryValue.value = true;
        getx.forgetPasswordNewPasswordEntryValue.value = false;

        forgetkey = value;
        log(forgetkey);
      });
    } catch (e) {
      print(e.toString() + "hello");
      Get.back();
    }
    startTimer(); // Disable the button and start the timer
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: ColorPage.white,
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/bg_android_login.png'),
                    fit: BoxFit.fill)),
            child: Center(
              child: Obx(
                () => SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      if (getx.forgetPasswordfieldEntryValue.value)
                        credentialEntryField()
                      else if (getx.forgetPasswordOTPEntryValue.value)
                        otpEnterField()
                      else if (getx.forgetPasswordNewPasswordEntryValue.value)
                        newPasswordEntryField()
                      else
                        SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget credentialEntryField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 8,
        child: Container(
          // width: MediaQuery.of(context).size.width > 600
          //     ? 500
          //     : MediaQuery.of(context).size.width * 0.8,
          // height: MediaQuery.of(context).size.height *0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorPage.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Form(
            key: key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      Text(
                        'Forgot password',
                        style: FontFamily.mobilefont.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      Text(
                        'Send OTP on -',
                        style: FontFamily.font4.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: "email",
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                      const Text('Email'),
                      Radio<String>(
                        value: "phone",
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                      const Text('Phone'),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: selectedOption == "email",
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }

                              // Regex for validating a proper email format
                              if (!RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                                return 'Enter a valid email address';
                              }

                              return null; // If no errors, return null
                            },
                            controller: emailid,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Enter Your Email',
                              fillColor: Color.fromARGB(255, 247, 246, 246),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color.fromARGB(255, 196, 194, 194),
                                ),
                                gapPadding: 20,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: Color.fromARGB(255, 196, 194, 194),
                                ),
                                gapPadding: 20,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            // controller: ,
                          )),
                    )
                  ],
                ),
                Visibility(
                  visible: selectedOption == "phone",
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.22,
                          child: DropdownButton<int>(
                            isExpanded: true,
                            isDense: true,
                            value: selectedCountryCode,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCountryCode = newValue!;
                              });
                            },
                            items:
                                countryCode.map<DropdownMenuItem<int>>((item) {
                              return DropdownMenuItem<int>(
                                value: item["value"],
                                child: Text(
                                  item["label"]!,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            dropdownColor: ColorPage.white,
                            style: TextStyle(color: ColorPage.colorgrey),
                            underline: Container(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Phone number is required';
                                    }
                                    if (value.length != 10) {
                                      return 'Phone number must be 10 digits';
                                    }
                                    if (RegExp(r'^[0-9]+\$').hasMatch(value)) {
                                      return 'Phone number must contain only digits';
                                    }
                                    return null;
                                  },

                                  controller: phno,
                                  obscureText: getx.forgetpassword1.value,

                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: 'Phone no',
                                    hintText: 'Enter your phone number',
                                    fillColor:
                                        Color.fromARGB(255, 247, 246, 246),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.5,
                                        color:
                                            Color.fromARGB(255, 196, 194, 194),
                                      ),
                                      gapPadding: 20,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.5,
                                        color:
                                            Color.fromARGB(255, 196, 194, 194),
                                      ),
                                      gapPadding: 20,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  // controller: ,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: ColorPage.color1,
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        print(selectedCountryCode);
                        // await forgetPasswordEmailVerify(
                        //   context,
                        //   emailid.text,
                        // ).then((v) async {
                        // if (v) {

                        await forgetPasswordGeneratecode(
                                context,
                                selectedCountryCode ?? 0,
                                phno.text ?? "",
                                emailid.text ?? "",
                                selectedCountryCode ?? 0,
                                phno.text ?? "")
                            .then((value) {
                          getx.forgetPasswordfieldEntryValue.value = false;
                          getx.forgetPasswordOTPEntryValue.value = true;
                          getx.forgetPasswordNewPasswordEntryValue.value =
                              false;

                          forgetkey = value;
                          log(forgetkey);
                        });
                        // }

                        // else {}

                        // });
                      }
                    },
                    child: Text(
                      'Submit',
                      style: FontFamily.font3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget otpEnterField() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: Card(
        elevation: 80,
        child: Container(
          width: MediaQuery.of(context).size.width > 600
              ? 500
              : MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorPage.white,
          ),
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Form(
            key: otpkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Verification',

                        style: FontFamily.font.copyWith(fontSize: 20),
                        // textScaler: const TextScaler.linear(1.4),
                      ),
                    ],
                  ),
                ),
                Text(
                  'You will get OTP via your selected option ${selectedOption}',

                  style: FontFamily.font4
                      .copyWith(fontSize: 14, color: Colors.grey),
                  // textScaler: const TextScaler.linear(1.4),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Cannot be blank';
                            }
                            return null;
                          },
                          controller: otpCode,

                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'OTP',
                            hintText: 'Enter OTP',
                            fillColor: Color.fromARGB(255, 247, 246, 246),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Color.fromARGB(255, 196, 194, 194),
                              ),
                              gapPadding: 20,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Color.fromARGB(255, 196, 194, 194),
                              ),
                              gapPadding: 20,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          // controller: ,
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        color: ColorPage.color1,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPressed: () async {
                          if (otpkey.currentState!.validate()) {
                            forgetPassword(
                                    context,
                                    selectedOption == "email"
                                        ? emailid.text
                                        : phno.text,
                                    forgetkey,
                                    otpCode.text)
                                .then((value) {
                              resetcode = value['token'].toString();
                              phonefromApi = value['phone'].toString();
                              emailfromApi = value['email'].toString();
                              print("///////////////////");
                              print(resetcode);
                              print(phonefromApi);
                              print(emailfromApi);
                              print("/////////////////////////////////");

                              getx.forgetPasswordfieldEntryValue.value = false;
                              getx.forgetPasswordOTPEntryValue.value = false;
                              getx.forgetPasswordNewPasswordEntryValue.value =
                                  true;
                            });
                          }
                        },
                        child: Text(
                          'Submit',
                          style: FontFamily.font3,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          _isOTPresendEnable.value
                              ? "Didn't you receive the OTP? "
                              : "Resend OTP in ${_start} seconds",
                          maxLines: 1,
                          style:
                              GoogleFonts.outfit(textStyle: const TextStyle()),
                        ),
                        InkWell(
                          onTap: _isOTPresendEnable.value ? resendOtp : null,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10, top: 5),
                            child: Text(
                              'Resend OTP',
                              style: _isOTPresendEnable.value
                                  ? FontFamily.ResendOtpfont.copyWith(
                                      fontSize: 12)
                                  : FontFamily.ResendOtpfont.copyWith(
                                      color: Colors.grey, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget newPasswordEntryField() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: Card(
        elevation: 80,
        child: Container(
          width: MediaQuery.of(context).size.width > 600
              ? 500
              : MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorPage.white,
          ),
          padding: EdgeInsets.symmetric(
              vertical: 50,
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Form(
            key: confirmpsswordKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Enter your new password',
                          style: FontFamily.font,
                          textScaler: const TextScaler.linear(1.4),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: password,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(),
                      decoration: newpassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password cannot be blank';
                        } else if (value.length < 8) {
                          return 'Password must be at least 9 characters long';
                        } else if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter';
                        } else if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
                          return 'Password must contain at least one lowercase letter';
                        } else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                          return 'Password must contain at least one number';
                        } else if (!RegExp(r'^(?=.*[\W_])').hasMatch(value)) {
                          return 'Password must contain at least one special character';
                        } else if (RegExp(r'[a-zA-Z]')
                                .allMatches(value)
                                .length <
                            5) {
                          return 'Password must contain at least 5 alphabetic characters (both uppercase and lowercase)';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Obx(() => TextFormField(
                          controller: confirmpassword,
                          obscureText: getx.forgetpassword1.value,
                          textInputAction: TextInputAction.next,
                          decoration: confirmPassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm Password is required';
                            }
                            if (value != password.text) {
                              return 'Confirm Password does not Match';
                            }

                            return null;
                          },
                        )),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: MaterialButton(
                    color: ColorPage.color1,
                    onPressed: () async {
                      if (confirmpsswordKey.currentState!.validate()) {
                        getx.forgetPasswordfieldEntryValue.value = true;
                        getx.forgetPasswordOTPEntryValue.value = false;
                        getx.forgetPasswordNewPasswordEntryValue.value = false;

                        resetPassword(context, emailfromApi, phonefromApi,
                            password.text, confirmpassword.text, resetcode);
                      }
                    },
                    child: Text(
                      'Submit',
                      style: FontFamily.font3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
