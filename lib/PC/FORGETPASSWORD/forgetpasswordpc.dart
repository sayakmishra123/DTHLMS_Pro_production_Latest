import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ForgotScreenPC extends StatefulWidget {
  const ForgotScreenPC({super.key});

  @override
  State<ForgotScreenPC> createState() => _ForgotScreenPCState();
}

class _ForgotScreenPCState extends State<ForgotScreenPC> {
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
    // fillColor: Color.fromARGB(255, 248, 249, 252),
    // hintText: 'Enter your email',
    fillColor: Color.fromARGB(255, 247, 246, 246),
    // filled: true,
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

  // InputDecoration(
  // prefixIcon: Icon(Icons.email),
  // hintText: 'example@gmail.com',
  // hintStyle: const TextStyle(color: ColorPage.colorgrey),
  // labelText: 'Email',
  // labelStyle: GoogleFonts.outfit(),
  // filled: true,
  // fillColor: Color.fromARGB(255, 248, 249, 252));
  final newpassword = InputDecoration(
    prefixIcon: Icon(Icons.email),
    // hintText: 'example@gmail.com',
    hintStyle: const TextStyle(color: ColorPage.colorgrey),
    // labelText: 'Email',
    labelStyle: GoogleFonts.outfit(),
    filled: true,
    // fillColor: Color.fromARGB(255, 248, 249, 252),
    // hintText: 'Enter your email',
    fillColor: Color.fromARGB(255, 247, 246, 246),
    // filled: true,
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
    hintText: 'example@gmail.com',
    // hintStyle: const TextStyle(color: ColorPage.colorgrey),
    labelText: 'New Password',
    // labelStyle: GoogleFonts.outfit(),
    // prefixIcon: Icon(Icons.lock),

    // filled: true,
    // fillColor: Color.fromARGB(255, 248, 249, 252),
  );
  final confirmPassword = InputDecoration(
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
    prefixIcon: Icon(Icons.lock_outline),
    hintText: 'Confirm password',
    hintStyle: const TextStyle(color: ColorPage.colorgrey),
    labelText: 'Confirm Password',
    labelStyle: GoogleFonts.outfit(),
    filled: true,
    fillColor: Color.fromARGB(255, 247, 246, 246),
  );

  final otp = InputDecoration(
    hintText: '0-0-0-0-0-0',
    hintStyle: const TextStyle(color: ColorPage.colorgrey),
    labelStyle: GoogleFonts.outfit(),
    filled: true,
    fillColor: Color.fromARGB(255, 247, 246, 246),
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
    // border: InputBorder.none,
    // focusedBorder: OutlineInputBorder(
    //     borderSide: const BorderSide(color: ColorPage.color1),
    //     borderRadius: BorderRadius.circular(10)),
    // enabledBorder: OutlineInputBorder(
    //     borderSide: const BorderSide(color: ColorPage.color1),
    //     borderRadius: BorderRadius.circular(10)),
  );

  String forgetkey = " ";
  String resetcode = " ";
  String phonefromApi = "";
  String emailfromApi = "";
  @override
  void initState() {
    getCountrycodeListFunction().whenComplete(() {
      setState(() {});
    });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    // });
    // getx.forgetpageshow.value=false;

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

    // TODO: implement dispose
    super.dispose();
  }

  Timer? _timer;
  RxBool _isOTPresendEnable = true.obs;
  Rx _start = 60.obs; // 30 seconds

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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: ColorPage.white,
          body: Container(
            height: MediaQuery.sizeOf(context).height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/Black and Red Minimalist Modern Registration Gym Website Prototype (1).jpg'),
                    fit: BoxFit.fill)),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              elevation: 80,
                              color: ColorPage.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorPage.white,
                                ),
                                padding: const EdgeInsets.all(100),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 50),
                                      child: SizedBox(
                                        // height: 400,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Text('https://videoencryptor.com/assets/images/logo.png')
                                            // Image.network(
                                            //   'https://videoencryptor.com/assets/images/logo.png',
                                            //   width: 200,
                                            // ),
                                            Image(
                                              image: AssetImage(logopath),
                                              height: 70,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Check your email',
                                            style: FontFamily.font,
                                            textScaler:
                                                const TextScaler.linear(1.3),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "We've sent an email to your inbox.",
                                            style: GoogleFonts.outfit(
                                                textStyle: TextStyle(
                                              fontSize:
                                                  ClsFontsize.ExtraSmall - 2,
                                            )),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          OutlinedButton.icon(
                                              style: const ButtonStyle(
                                                  padding:
                                                      WidgetStatePropertyAll(
                                                          EdgeInsets.symmetric(
                                                              vertical: 20,
                                                              horizontal: 75))),
                                              onPressed: () {
                                                void openEmailClient() async {
                                                  final Uri emailLaunchUri =
                                                      Uri(
                                                    scheme: 'mailto',
                                                    path: '',
                                                  );
                                                  if (await canLaunchUrlString(
                                                      emailLaunchUri
                                                          .toString())) {
                                                    await launchUrl(
                                                        emailLaunchUri);
                                                  } else {
                                                    throw 'Could not launch email';
                                                  }
                                                }

                                                openEmailClient();
                                              },
                                              icon: Image.asset(
                                                'assets/email.png',
                                                width: 30,
                                              ),
                                              label: Text(
                                                'Open Email App',
                                                style: FontFamily.font,
                                              ))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          OutlinedButton.icon(
                                            style: const ButtonStyle(
                                                padding: WidgetStatePropertyAll(
                                                    EdgeInsets.symmetric(
                                                        vertical: 20,
                                                        horizontal: 95))),
                                            onPressed: () async {
                                              final Uri gmailUrl = Uri(
                                                scheme: 'https',
                                                host: 'mail.google.com',
                                                path: '/mail/u/0/',
                                                // queryParameters: {
                                                //   'authuser': '0'
                                                // }, // Change '0' to the account index you want to open
                                              );

                                              await launchUrlString(
                                                  gmailUrl.toString());
                                            },
                                            icon: Image.asset(
                                              'assets/gmail.png',
                                              width: 30,
                                            ),
                                            label: Text(
                                              'Open Email',
                                              style: FontFamily.font,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton.icon(
                                            onPressed: () {
                                              // getx.forgetPasswordOTPEntryValue
                                              //     .value = false;
                                              // getx.forgetPasswordNewPasswordEntryValue
                                              //     .value = false;
                                              // getx.forgetPasswordfieldEntryValue
                                              //     .value = true;

                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back_rounded,
                                              color: ColorPage.colorblack,
                                            ),
                                            label: Text(
                                              'Back to Login',
                                              style: GoogleFonts.outfit(
                                                  textStyle: TextStyle(
                                                      color:
                                                          ColorPage.colorblack,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: ClsFontsize
                                                              .ExtraSmall -
                                                          1)),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => SingleChildScrollView(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getx.forgetPasswordfieldEntryValue.value
                              ? credentialEntryField()
                              : getx.forgetPasswordOTPEntryValue.value
                                  ? otpEnterField()
                                  : getx.forgetPasswordNewPasswordEntryValue
                                          .value
                                      ? newPasswordEntryField()
                                      : SizedBox(),
                          // Initial selected option is "email"
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  // Default country code

// List<Map<String, dynamic>> countryCode = [
//   {"value": 91, "label": "91 - India"},
//   {"value": 93, "label": "93 - Afghanistan"},
// ];
// int selectedCountryCode = 91;
// String selectedOption = "email";
// final GlobalKey<FormState> key = GlobalKey<FormState>();

  Widget credentialEntryField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorPage.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Form(
              key: key,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          'Forgot password',
                          style: FontFamily.font.copyWith(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Send OTP on -',
                          style: FontFamily.font4.copyWith(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                  // Conditionally show the email input field with validation
                  Visibility(
                    visible: selectedOption == "email",
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: emailid,
                          textInputAction: TextInputAction.next,
                          decoration: email,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  // Conditionally show the phone number input field with country code dropdown and validation
                  Visibility(
                    visible: selectedOption == "phone",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: DropdownButton<int>(
                              menuWidth: 200,
                              isExpanded: true,
                              isDense: true,
                              value: selectedCountryCode,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCountryCode = newValue!;
                                });
                              },
                              items: countryCode
                                  .map<DropdownMenuItem<int>>((item) {
                                return DropdownMenuItem<int>(
                                  value: item["value"],
                                  child: Text(item["label"]!),
                                );
                              }).toList(),
                              dropdownColor: ColorPage.white,
                              style: TextStyle(color: ColorPage.colorgrey),
                              underline: Container(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 250,
                            child: Obx(() => TextFormField(
                                  controller: phno,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  obscureText: getx.forgetpassword1.value,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.phone),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 247, 246, 246),
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
                                    hintStyle: const TextStyle(
                                        color: ColorPage.colorgrey),
                                    labelStyle: GoogleFonts.outfit(),
                                    labelText: 'Phone no',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Phone number is required';
                                    }
                                    if (value.length != 10) {
                                      return 'Phone number must be 10 digits';
                                    }
                                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                      return 'Phone number must contain only digits';
                                    }
                                    return null;
                                  },
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: MaterialButton(
                      color: ColorPage.color1,
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          print(selectedCountryCode);
//  await forgetPasswordEmailVerify(
//                           context,
//                           emailid.text,
//                         ).then((v) async {
//                           if (v) {

                          forgetPasswordGeneratecode(
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

                          //   }
                          //   else{

                          //   }
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
      ],
    );
  }

  Widget otpEnterField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 80,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorPage.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 100),
            child: Form(
              key: otpkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Text(
                          'Verification',
                          style: FontFamily.font,
                          textScaler: const TextScaler.linear(1.5),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'You will get OTP via your selected \n option ${selectedOption}',

                        style: FontFamily.font4
                            .copyWith(fontSize: 14, color: Colors.grey),
                        // textScaler: const TextScaler.linear(1.4),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  // Radio buttons for selecting Email or Phone

                  // Conditionally show the email input field with validation
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: otpCode,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(),
                              decoration: otp,
                              validator: (value) {
                                // Email validation
                                if (value == null || value.isEmpty) {
                                  return 'Otp is required';
                                }

                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Conditionally show the phone number input field with country code dropdown and validation

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    child: MaterialButton(
                      color: ColorPage.color1,
                      onPressed: () async {
                        // Validate form fields before proceeding
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
                            // print("///////////////////");
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

                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Row(
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
                                      forgetPasswordGeneratecode(
                                              context,
                                              selectedCountryCode ?? 0,
                                              phno.text ?? "",
                                              emailid.text ?? "",
                                              selectedCountryCode ?? 0,
                                              phno.text ?? "")
                                          .then((value) {
                                        getx.forgetPasswordfieldEntryValue
                                            .value = false;
                                        getx.forgetPasswordOTPEntryValue.value =
                                            true;
                                        getx.forgetPasswordNewPasswordEntryValue
                                            .value = false;

                                        forgetkey = value;
                                        log(forgetkey);
                                      });
                                    } catch (e) {
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
                                  : FontFamily.ResendOtpfont.copyWith(
                                      color: Colors.grey),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget newPasswordEntryField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 80,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorPage.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 100),
            child: Form(
              key: confirmpsswordKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Row(
                      children: [
                        Text(
                          'Enter your new password',
                          style: FontFamily.font,
                          textScaler: const TextScaler.linear(1.4),
                        )
                      ],
                    ),
                  ),
                  // Radio buttons for selecting Email or Phone

                  // Conditionally show the email input field with validation
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
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
                                } else if (!RegExp(r'^(?=.*[A-Z])')
                                    .hasMatch(value)) {
                                  return 'Password must contain at least one uppercase letter';
                                } else if (!RegExp(r'^(?=.*[a-z])')
                                    .hasMatch(value)) {
                                  return 'Password must contain at least one lowercase letter';
                                } else if (!RegExp(r'^(?=.*\d)')
                                    .hasMatch(value)) {
                                  return 'Password must contain at least one number';
                                } else if (!RegExp(r'^(?=.*[\W_])')
                                    .hasMatch(value)) {
                                  return 'Password must contain at least one special character';
                                } else if (RegExp(r'[a-zA-Z]')
                                        .allMatches(value)
                                        .length <
                                    5) {
                                  return 'Password must contain at least 5 alphabetic characters (both uppercase and lowercase)';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Conditionally show the phone number input field with country code dropdown and validation
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Obx(() => TextFormField(
                                controller: confirmpassword,
                                obscureText: getx.forgetpassword1.value,
                                textInputAction: TextInputAction.next,
                                decoration: confirmPassword,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  // Phone number validation
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    child: MaterialButton(
                      color: ColorPage.color1,
                      onPressed: () async {
                        // Validate form fields before proceeding
                        if (confirmpsswordKey.currentState!.validate()) {
                          getx.forgetPasswordfieldEntryValue.value = true;
                          getx.forgetPasswordOTPEntryValue.value = false;
                          getx.forgetPasswordNewPasswordEntryValue.value =
                              false;

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
      ],
    );
  }
}
