import 'dart:async';
import 'dart:core';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dthlms/API/LOGIN/login_api.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/MOBILE/LOGIN/loginpage_mobile.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class SignInOtpScreen extends StatefulWidget {
  SignInOtpScreen({super.key});

  // signInOtpScreen({super.key});

  @override
  State<SignInOtpScreen> createState() => _SignInOtpScreenState();
}

class _SignInOtpScreenState extends State<SignInOtpScreen> {
  late double screenwidth = MediaQuery.of(context).size.width;
  late double spaceBetweenOtpAndText = MediaQuery.of(context).size.width / 22;
  late double spaceBetweenOtpboxAndText =
      MediaQuery.of(context).size.width / 20;
  // ignore: non_constant_identifier_names
  late double OtpBoxWidth = MediaQuery.of(context).size.width / 9;
  // ignore: non_constant_identifier_names
  late double OtpBoxHeight = MediaQuery.of(context).size.width / 8;
  late double spaceBetweenOtpboxAndResendOtp =
      MediaQuery.of(context).size.width / 18;
  // ignore: non_constant_identifier_names
  Getx getObj = Get.put(Getx());

  final signupuser = Get.arguments['signupuser'];
  final activationkey = Get.arguments['activationkey'];

  final signupfirstname = Get.arguments['signupfirstname'];
  final signuplastname = Get.arguments['signuplastname'];

  final signupemail = Get.arguments['signupemail'];
  final signuppassword = Get.arguments['signuppassword'];
  final signupphno = Get.arguments['signupphno'];
  final signupcourse = Get.arguments['signupcourse'];

  final signupwaphno = Get.arguments['signupwaphno'];
  final phonenumbercountryid = Get.arguments['phonenumbercountryid'];
  final whatsappnumbercountryid = Get.arguments['whatsappnumbercountryid'];

  String key = '';

  @override
  void initState() {
    // getObj.isPhoneOtpRequired.value =true;
    // getObj.isEmailOtpRequired.value = true;
    // getObj.isWhatsAppOtpRequired.value = true;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      call();
    });

    super.initState();
  }

  void call() async {
    try {
      signupcodegenerate(phonenumbercountryid, signupphno, signupemail,
              activationkey, whatsappnumbercountryid, signupwaphno, context)
          .then((value) {
        print(value + "key");
        key = value;
        if (key == 'error') {
          Get.back();
        }
      });
    } catch (e) {
      writeToFile(e, "call");
      print(e.toString() + "hello");
      Get.back();
    }
  }

  TextEditingController emailotpcontroller = TextEditingController();
  TextEditingController phoneotpcontroller = TextEditingController();
  TextEditingController waotpcontroller = TextEditingController();

  //  TextEditingController otpcontroller = TextEditingController();

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

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    
    super.dispose();
  }

  GlobalKey<FormState> globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: ColorPage.color1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  gradient: SweepGradient(
                colors: [ColorPage.color1, ColorPage.bgcolor],
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Obx(
                  //   () => Visibility(
                  //     visible: getObj.otplineshow.value,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Container(
                  //           color: getObj.otplineshow.value
                  //               ? ColorPage.green
                  //               : ColorPage.red,
                  //           padding: const EdgeInsets.symmetric(
                  //               vertical: 10, horizontal: 5),
                  //           child: Row(
                  //             children: [
                  //               TextButton.icon(
                  //                 onPressed: () {},
                  //                 icon: const Icon(
                  //                   Icons.info,
                  //                   color: ColorPage.deepblue,
                  //                 ),
                  //                 label: Text(
                  //                   getObj.otplineshow.value
                  //                       ? 'OTP has been send to your mail'
                  //                       : 'OTP send failed',
                  //                   style: FontFamily.font3.copyWith(fontSize: 14),
                  //                   // textScaler: TextScaler.linear(1.8),
                  //                 ),
                  //               ),
                  //               IconButton(
                  //                   onPressed: () {
                  //                     getObj.otplineshow.value = false;
                  //                   },
                  //                   icon: const Icon(Icons.close))
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 30,
                        child: Container(
                          width: screenwidth - 10,
                          decoration: BoxDecoration(
                              color: ColorPage.white,
                              borderRadius: BorderRadius.circular(20)),

                          // padding: const EdgeInsets.all(250),
                          // height: 300,
                          //  width: 300,
                          child: Obx(
                            () => Form(
                              key: globalKey,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'OTP Verification',
                                        style: FontFamily.font,
                                        textScaler:
                                            const TextScaler.linear(1.8),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: spaceBetweenOtpAndText,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: screenwidth - 40,
                                        child: AutoSizeText(
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          getObj.signUpMSG.value,
                                          style: FontFamily.font4,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: spaceBetweenOtpboxAndText,
                                  ),
                                  if (getObj.isWhatsAppOtpRequired.value)
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FontAwesome.whatsapp,
                                              color: Colors.green,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'WhatsAPP OTP',
                                              style: FontFamily.font4,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 200,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) {
                                              if (value!.isEmpty &&
                                                  getObj.isWhatsAppOtpRequired
                                                      .value &&
                                                  getObj.isWhatsAppOrRequired
                                                      .value &&
                                                  emailotpcontroller.text ==
                                                      '') {
                                                return 'Cannot be blank';
                                              } else if (value.isEmpty &&
                                                  getObj.isWhatsAppOtpRequired
                                                      .value &&
                                                  !getObj.isWhatsAppOrRequired
                                                      .value) {
                                                return 'Cannot be blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                            style: TextStyle(fontSize: 18),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            controller: waotpcontroller,
                                            decoration: InputDecoration(
                                                hintText: '0-0-0-0-0-0-0'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (getObj.isEmailOtpRequired.value)
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.email_rounded,
                                              color: Colors.blueGrey,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Email OTP',
                                              style: FontFamily.font4,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 200,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) {
                                              if (value!.isEmpty &&
                                                  getObj.isEmailOtpRequired
                                                      .value &&
                                                  getObj.isWhatsAppOrRequired
                                                      .value &&
                                                  waotpcontroller.text == "") {
                                                return 'Cannot be blank';
                                              } else if (value.isEmpty &&
                                                  getObj.isEmailOtpRequired
                                                      .value &&
                                                  getObj.isPhoneNumberOrRequired
                                                      .value &&
                                                  phoneotpcontroller.text ==
                                                      "") {
                                                return 'Cannot be blank';
                                              } else if (value.isEmpty &&
                                                  getObj.isEmailOtpRequired
                                                      .value &&
                                                  !getObj
                                                      .isPhoneNumberOrRequired
                                                      .value &&
                                                  !getObj.isWhatsAppOrRequired
                                                      .value) {
                                                return 'Cannot be blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                            style: TextStyle(fontSize: 18),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            controller: emailotpcontroller,
                                            decoration: InputDecoration(
                                                hintText: '0-0-0-0-0-0-0'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (getObj.isPhoneOtpRequired.value)
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FontAwesome.phone,
                                              color: Colors.blueGrey,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Phone Number OTP',
                                              style: FontFamily.font4,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 200,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: (value) {
                                              if (value!.isEmpty &&
                                                  getObj.isPhoneOtpRequired
                                                      .value &&
                                                  getObj.isPhoneNumberOrRequired
                                                      .value &&
                                                  emailotpcontroller.text ==
                                                      "") {
                                                return 'Cannot be blank';
                                              } else if (value.isEmpty &&
                                                  getObj.isPhoneOtpRequired
                                                      .value &&
                                                  !getObj
                                                      .isPhoneNumberOrRequired
                                                      .value) {
                                                return 'Cannot be blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                            style: TextStyle(fontSize: 18),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            controller: phoneotpcontroller,
                                            decoration: InputDecoration(
                                                hintText: '0-0-0-0-0-0-0'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        _isOTPresendEnable.value
                                            ? "Didn't you receive the OTP? "
                                            : "Resend OTP in ${_start} seconds",
                                        maxLines: 1,
                                        style: GoogleFonts.outfit(
                                            textStyle: const TextStyle()),
                                      ),

                                      TextButton(
                                        style: ButtonStyle(),
                                        onPressed: _isOTPresendEnable.value
                                            ? () {
                                                try {
                                                  signupcodegenerate(
                                                          phonenumbercountryid,
                                                          signupphno,
                                                          signupemail,
                                                          activationkey,
                                                          whatsappnumbercountryid,
                                                          signupwaphno,
                                                          context)
                                                      .then((value) {
                                                    print(value + "key");
                                                    key = value;

                                                    snackbar();

                                                    if (key == 'error') {
                                                      Get.back();
                                                    }
                                                  });
                                                } catch (e) {
                                                  writeToFile(e, "signupPageFunctionCall");
                                                  print(e.toString() + "hello");
                                                  Get.back();
                                                }
                                                startTimer(); // Disable the button and start the timer
                                              }
                                            : null,
                                        child: Text(
                                          'Resend OTP',
                                          style: _isOTPresendEnable.value
                                              ? FontFamily.ResendOtpfont
                                              : FontFamily.ResendOtpfont
                                                  .copyWith(color: Colors.grey),
                                        ),
                                      ),

                                      // TextButton(
                                      //   style: ButtonStyle(

                                      //   ),

                                      //   onPressed: _isOTPresendEnable? (){
                                      //     try {
                                      //       signupcodegenerate(
                                      //               phonenumbercountryid,
                                      //               signupphno,
                                      //               signupemail,
                                      //               activationkey,
                                      //               whatsappnumbercountryid,
                                      //               signupwaphno,
                                      //               context)
                                      //           .then((value) {
                                      //         print(value + "key");
                                      //         key = value;
                                      //         if (key == 'error') {
                                      //           Get.back();
                                      //         }
                                      //       });
                                      //     } catch (e) {
                                      //       print(e.toString() + "hello");
                                      //       Get.back();
                                      //     }

                                      // } : null,

                                      //  child: Text(
                                      //     'Resend OTP',
                                      //     style: _isOTPresendEnable ? FontFamily.ResendOtpfont : FontFamily.ResendOtpfont.copyWith(color: Colors.grey) ,
                                      //   ),)
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: SizedBox(
                                      width: screenwidth / 1.5,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (globalKey.currentState!
                                              .validate()) {
                                            signupApi(
                                                context,
                                                signupuser,
                                                signupfirstname,
                                                signuplastname,
                                                signupemail,
                                                signuppassword,
                                                signupphno,
                                                signupwaphno,
                                                key,
                                                emailotpcontroller.text,
                                                phoneotpcontroller.text,
                                                activationkey,
                                                phonenumbercountryid,
                                                whatsappnumbercountryid,
                                                waotpcontroller.text);
                                          } else {
                                            print('error');
                                          }
                                        },
                                        style: const ButtonStyle(
                                            padding: WidgetStatePropertyAll(
                                                EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 20)),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    ColorPage.color1),
                                            shape: WidgetStatePropertyAll(
                                                ContinuousRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.elliptical(
                                                                15, 15))))),
                                        child: Text(
                                          'Verify & Continue',
                                          style: FontFamily.font2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenwidth / 4,
                                    height: screenwidth / 8,
                                    child: TextButton(
                                      onPressed: () {
                                        // Get.back();
                                        Get.offAll(() => const Mobilelogin());
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  ColorPage.red),
                                          shape: WidgetStatePropertyAll(
                                              ContinuousRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.elliptical(
                                                              15, 15))))),
                                      child: Text(
                                        'Cancel',
                                        style: FontFamily.font3,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
