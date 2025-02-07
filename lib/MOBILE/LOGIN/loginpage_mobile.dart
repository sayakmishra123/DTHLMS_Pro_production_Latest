import 'dart:developer';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/API/LOGIN/login_api.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/MOBILE/FORGETPASSWORD/forgetpassword_screen.dart';
import 'package:dthlms/MOBILE/SIM_INFORMATION/sim_information.dart';
import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
// import 'package:dthlms/android/ForgetPassword/ForgetPasswordScreen.dart';

// import 'package:dthlms/android/SigninOtp/OtpScreen.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';

// import 'package:dthlms/getx/getxcontroller.dart';
// import 'package:dthlms/utils/getpackagebyid.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

// import '../phone/siminformation.dart';

class Mobilelogin extends StatefulWidget {
  const Mobilelogin({super.key});

  @override
  State<Mobilelogin> createState() => _MobileloginState();
}

class _MobileloginState extends State<Mobilelogin> {
  TextEditingController signupfirstname = TextEditingController();
  TextEditingController signuplastname = TextEditingController();
  TextEditingController signupemail = TextEditingController();
  TextEditingController signupphno = TextEditingController();

  TextEditingController signupwaphno = TextEditingController();

  TextEditingController phoneNumberCountryId = TextEditingController();
  TextEditingController whatsAppNumberCountryId = TextEditingController();

  TextEditingController signuppassword = TextEditingController();
  TextEditingController signupconfirmpassword = TextEditingController();
  String signupcourse = "JEE";
  TextEditingController loginemail = TextEditingController();
  TextEditingController loginpassword = TextEditingController();
  TextEditingController loginotp = TextEditingController();
  TextEditingController activationkey = TextEditingController();

  int selectedCountryCodePhone = 1;
  int selectedCountryCodeWA = 1;

  int controllerIndex = 0;

  RxList<Map<String, dynamic>> countryCode = <Map<String, dynamic>>[
    {"value": 1, "label": "91 - India"},
    {"value": 2, "label": "93 - Afghanistan"},
  ].obs;

  // ignore: non_constant_identifier_names
  // final GlobalKey<FormState> desktop_key = GlobalKey();
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();

  List<String> courseList = ["JEE", "NEET", "CA"];

  RxBool showPass = false.obs;

  // ignore: non_constant_identifier_names
  final GlobalKey<FormState> mobile_key_login = GlobalKey();
  // ignore: non_constant_identifier_names
  final GlobalKey<FormState> mobile_key_signup = GlobalKey();
  late double formfieldsize = MediaQuery.of(context).size.width - 60;
  late double fontsize = ClsFontsize.ExtraLarge + 2;
  Getx getxController = Get.put(Getx());
  InputBorder border = const UnderlineInputBorder(
      borderSide: BorderSide(color: ColorPage.colorgrey));
  var key = '0';
  Getx getx = Get.put(Getx());

  @override
  void initState() {
    if (getx.loginuserdata.isNotEmpty) {
      print("get login id and password");
      loginemail.text = getx.loginuserdata[0].loginId;
      loginpassword.text = getx.loginuserdata[0].password;
    }
    // signupfirstname.text = "Rahul";

    super.initState();

    print('logindth');

    // Set the initial state after the super call
    getUserid();
    getCountrycodeListFunction().whenComplete(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getx.loginId.isEmpty) {
        getx.isSignup.value = true;
        getx.ButtonControllerIndex.value = 0; // Set the button index to 1
        getx.show.value = true;
      }

      // Ensure to set the controller index after state change
      setState(() {
        _animatedButtonController.setIndex(getx.ButtonControllerIndex.value);
      });
    });
  }

  getUserid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    loginemail.text = prefs.getString("LoginId") ?? '';
  }

  Future getCountrycodeListFunction() async {
    countryCode.value = await getCountryId();
  }

  final _animatedButtonController = AnimatedButtonController();

  @override
  void dispose() {
    getx.ButtonControllerIndex.value = 0;
    // TODO: implement dispose
    super.dispose();
  }

  double height = 4;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/bg_android_login.png'),
                    fit: BoxFit.fill),
                // gradient: LinearGradient(colors: [
                //   const Color.fromARGB(255, 250, 246, 247),
                //   const Color.fromARGB(255, 238, 243, 247)
                // ]),
                // color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.sizeOf(context).height,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),

                    padding: EdgeInsets.symmetric(vertical: 10),
                    // width: 400,
                    // height: MediaQuery.sizeOf(context).height - 200,

                    alignment: Alignment.center,
                    child: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // margin: EdgeInsets.all(10),
                                alignment: Alignment.topLeft,
                                child: Image(
                                  image: AssetImage(
                                    logopath,
                                  ),
                                  height: 100,
                                  width: 150,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text('Signup'),
                              // Text('Login'),
                              SizedBox(
                                width: 300,
                                child: AnimatedButtonBar(
                                  controller: _animatedButtonController
                                    ..setIndex(getxController
                                        .ButtonControllerIndex.value),
                                  radius: 32.0,
                                  padding: const EdgeInsets.all(16.0),
                                  backgroundColor:
                                      const Color.fromARGB(255, 227, 228, 228),
                                  foregroundColor: Colors.blueGrey.shade300,
                                  elevation: 4,
                                  curve: Curves.linear,
                                  borderColor: Colors.white,
                                  borderWidth: 2,
                                  innerVerticalPadding: 16,
                                  children: [
                                    ButtonBarEntry(
                                        onTap: () {
                                          getxController.show.value = false;
                                          getxController
                                              .ButtonControllerIndex.value = 0;
                                          // print(getxController
                                          //     .ButtonControllerIndex.value
                                          //     .toString());
                                        },
                                        child: Text(
                                          'Log in',
                                          style: FontFamily.font,
                                        )),
                                    ButtonBarEntry(
                                        onTap: () {
                                          getxController.show.value = true;
                                          getxController
                                              .ButtonControllerIndex.value = 1;
                                          print(getxController
                                              .ButtonControllerIndex.value
                                              .toString());
                                        },
                                        child: Text(
                                          'Sign up',
                                          style: FontFamily.font,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          getxController.show.value &&
                                  getxController.ButtonControllerIndex.value ==
                                      1
                              ? Form(
                                  // autovalidateMode:
                                  //     AutovalidateMode.onUserInteraction,
                                  key: mobile_key_signup,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: formfieldsize / 2.1,
                                            child: Text(
                                              'First Name',
                                              style: FontFamily.font,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          SizedBox(
                                            width: formfieldsize / 2.1,
                                            child: Text(
                                              'Last Name',
                                              style: FontFamily.font,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: formfieldsize / 2.1,
                                              child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Cannot be blank';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.name,
                                                controller: signupfirstname,
                                                decoration: InputDecoration(
                                                  hintText: 'First Name',
                                                  fillColor: Color.fromARGB(
                                                      255, 247, 246, 246),
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                            width: height,
                                          ),
                                          SizedBox(
                                              width: formfieldsize / 2,
                                              child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Cannot be blank';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.name,
                                                controller: signuplastname,
                                                decoration: InputDecoration(
                                                  hintText: 'Last Name',
                                                  fillColor: Color.fromARGB(
                                                      255, 247, 246, 246),
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: formfieldsize,
                                            child: Text(
                                              'Email',
                                              style: FontFamily.mobilefont,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: formfieldsize,
                                              child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Cannot be blank';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                controller: signupemail,
                                                decoration: InputDecoration(
                                                  hintText: 'Enter your email',
                                                  fillColor: Color.fromARGB(
                                                      255, 247, 246, 246),
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: formfieldsize,
                                            child: Text(
                                              'Contact Number',
                                              style: FontFamily.mobilefont,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.22,
                                            child: DropdownButton<int>(
                                              isExpanded: true,
                                              isDense: true,
                                              value: selectedCountryCodePhone,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedCountryCodePhone =
                                                      newValue!;
                                                  phoneNumberCountryId.text =
                                                      newValue.toString();
                                                });
                                              },
                                              items: countryCode
                                                  .map<DropdownMenuItem<int>>(
                                                      (item) {
                                                return DropdownMenuItem<int>(
                                                  value: item["value"],
                                                  child: Text(
                                                    item["label"]!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                );
                                              }).toList(),
                                              dropdownColor: ColorPage.white,
                                              style: TextStyle(
                                                  color: ColorPage.colorgrey),
                                              underline: Container(),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6,
                                                  child: TextFormField(
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    validator: (value) {
                                                      log(selectedCountryCodePhone
                                                          .toString());
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Phone number is required';
                                                      }
                                                      // if (value.length != 10) {
                                                      //   return 'must be 10 digits';
                                                      // }
                                                      if (RegExp(r'^[0-9]+\$')
                                                          .hasMatch(value)) {
                                                        return 'must contain only digits';
                                                      }

                                                      if (value.length > 10 &&
                                                          selectedCountryCodePhone
                                                              .toString()
                                                              .startsWith(
                                                                  '1')) {
                                                        return "The number must be 10 digits.";
                                                      }

                                                      return null;
                                                    },

                                                    controller: signupphno,
                                                    obscureText: getx
                                                        .forgetpassword1.value,
                                                    onTap: () async {},
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    decoration: InputDecoration(
                                                      labelText: 'Phone no',
                                                      hintText:
                                                          'Enter your phone number',
                                                      fillColor: Color.fromARGB(
                                                          255, 247, 246, 246),
                                                      filled: true,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: Color.fromARGB(
                                                              255,
                                                              196,
                                                              194,
                                                              194),
                                                        ),
                                                        gapPadding: 20,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: Color.fromARGB(
                                                              255,
                                                              196,
                                                              194,
                                                              194),
                                                        ),
                                                        gapPadding: 20,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    // controller: ,
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: formfieldsize,
                                            child: Text(
                                              'Whatsapp Number',
                                              style: FontFamily.mobilefont,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.22,
                                            child: DropdownButton<int>(
                                              isExpanded: true,
                                              isDense: true,
                                              value: selectedCountryCodeWA,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedCountryCodeWA =
                                                      newValue!;
                                                  whatsAppNumberCountryId.text =
                                                      newValue.toString();
                                                });
                                              },
                                              items: countryCode
                                                  .map<DropdownMenuItem<int>>(
                                                      (item) {
                                                return DropdownMenuItem<int>(
                                                  value: item["value"],
                                                  child: Text(
                                                    item["label"]!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                );
                                              }).toList(),
                                              dropdownColor: ColorPage.white,
                                              style: TextStyle(
                                                  color: ColorPage.colorgrey),
                                              underline: Container(),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6,
                                                  child: TextFormField(
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Contact number is required';
                                                      }
                                                      // if (value.length != 10) {
                                                      //   return 'must be 10 digits';
                                                      // }
                                                      if (RegExp(r'^[0-9]+\$')
                                                          .hasMatch(value)) {
                                                        return 'must contain only digits';
                                                      }
                                                      return null;
                                                    },

                                                    controller: signupwaphno,
                                                    obscureText: getx
                                                        .forgetpassword1.value,

                                                    keyboardType:
                                                        TextInputType.phone,
                                                    decoration: InputDecoration(
                                                      labelText: 'Phone no',
                                                      hintText:
                                                          'Enter your phone number',
                                                      fillColor: Color.fromARGB(
                                                          255, 247, 246, 246),
                                                      filled: true,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: Color.fromARGB(
                                                              255,
                                                              196,
                                                              194,
                                                              194),
                                                        ),
                                                        gapPadding: 20,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: Color.fromARGB(
                                                              255,
                                                              196,
                                                              194,
                                                              194),
                                                        ),
                                                        gapPadding: 20,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    // controller: ,
                                                    onTap: () async {
                                                      // await ClsSimInfo()
                                                      //     .printSimCardsData(
                                                      //         context)
                                                      //     .whenComplete(() {
                                                      //   Future.delayed(
                                                      //       const Duration(
                                                      //           seconds: 1), () {
                                                      //     showDialog(
                                                      //         context: context,
                                                      //         builder: (context) {
                                                      //           return Obx(() {
                                                      //             return AlertDialog(
                                                      //               title: const Text(
                                                      //                   'Choose Sim number'),
                                                      //               content:
                                                      //                   SizedBox(
                                                      //                 height: 100,
                                                      //                 child: Column(
                                                      //                   children: [
                                                      //                     for (int i =
                                                      //                             0;
                                                      //                         i < getx.simCardinfo.length;
                                                      //                         i++)
                                                      //                       ElevatedButton(
                                                      //                           onPressed: () {
                                                      //                             signupphno.text = getx.simCardinfo[i].phoneNumber.toString();
                                                      //                             Get.back();
                                                      //                           },
                                                      //                           child: Text(getx.simCardinfo[i].phoneNumber.toString())),
                                                      //                   ],
                                                      //                 ),
                                                      //               ),
                                                      //             );
                                                      //           });
                                                      //         });
                                                      //   });
                                                      // });
                                                    },
                                                  ))
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: formfieldsize,
                                            child: Text(
                                              'Password',
                                              style: FontFamily.mobilefont,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: formfieldsize,
                                            child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Password cannot be blank';
                                                  } else if (value.length < 8) {
                                                    return 'Password must be at least 9 characters long';
                                                  } else if (!RegExp(
                                                          r'^(?=.*[A-Z])')
                                                      .hasMatch(value)) {
                                                    return 'Password must contain at least one uppercase letter';
                                                  } else if (!RegExp(
                                                          r'^(?=.*[a-z])')
                                                      .hasMatch(value)) {
                                                    return 'Password must contain at least one lowercase letter';
                                                  } else if (!RegExp(
                                                          r'^(?=.*\d)')
                                                      .hasMatch(value)) {
                                                    return 'Password must contain at least one number';
                                                  } else if (!RegExp(
                                                          r'^(?=.*[\W_])')
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
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                controller: signuppassword,
                                                obscureText: !showPass.value,
                                                decoration: InputDecoration(
                                                  hintText: 'Password',
                                                  fillColor: Color.fromARGB(
                                                      255, 247, 246, 246),
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  suffixIcon: IconButton(
                                                      onPressed: () {
                                                        showPass.value =
                                                            !showPass.value;
                                                      },
                                                      icon: Icon(showPass.value
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off)),
                                                )),
                                          )
                                        ],
                                      ),

                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: formfieldsize,
                                            child: Text(
                                              'Confirm Password',
                                              style: FontFamily.mobilefont,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: formfieldsize,
                                            child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Confirm Password cannot be blank';
                                                  } else if (value.length < 8) {
                                                    return 'Confirm Password must be at least 9 characters long';
                                                  } else if (!RegExp(
                                                          r'^(?=.*[A-Z])')
                                                      .hasMatch(value)) {
                                                    return 'Confirm Password must contain at least one uppercase letter';
                                                  } else if (!RegExp(
                                                          r'^(?=.*[a-z])')
                                                      .hasMatch(value)) {
                                                    return 'Confirm Password must contain at least one lowercase letter';
                                                  } else if (!RegExp(
                                                          r'^(?=.*\d)')
                                                      .hasMatch(value)) {
                                                    return 'Confirm Password must contain at least one number';
                                                  } else if (!RegExp(
                                                          r'^(?=.*[\W_])')
                                                      .hasMatch(value)) {
                                                    return 'Confirm Password must contain at least one special character';
                                                  } else if (RegExp(r'[a-zA-Z]')
                                                          .allMatches(value)
                                                          .length <
                                                      5) {
                                                    return 'Confirm Password must contain at least 5 alphabetic characters (both uppercase and lowercase)';
                                                  }
                                                  return null;
                                                },
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                controller:
                                                    signupconfirmpassword,
                                                obscureText: !showPass.value,
                                                decoration: InputDecoration(
                                                  hintText: 'Confirm Password',
                                                  fillColor: Color.fromARGB(
                                                      255, 247, 246, 246),
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  suffixIcon: IconButton(
                                                      onPressed: () {
                                                        showPass.value =
                                                            !showPass.value;
                                                      },
                                                      icon: Icon(showPass.value
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off)),
                                                )),
                                          )
                                        ],
                                      ),

                                      SizedBox(
                                        height: height,
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: formfieldsize,
                                            child: Text(
                                              'Activation key (Optional)',
                                              style: FontFamily.mobilefont,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: formfieldsize,
                                              child: TextFormField(
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                controller: activationkey,
                                                decoration: InputDecoration(
                                                  hintText: 'Activation key',
                                                  fillColor: Color.fromARGB(
                                                      255, 247, 246, 246),
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: formfieldsize,
                                                // height: 30,
                                                child: MaterialButton(
                                                  shape:
                                                      ContinuousRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 15),
                                                  color: ColorPage.color1,
                                                  onPressed: () async {
                                                    if (signuppassword.text ==
                                                        signupconfirmpassword
                                                            .text) {
                                                      if (mobile_key_signup
                                                              .currentState!
                                                              .validate() &
                                                          GetUtils.isEmail(
                                                              signupemail
                                                                  .text)) {
                                                        print(
                                                            activationkey.text);
                                                        await checkUserBeforeRegister(
                                                                context,
                                                                signupemail
                                                                    .text,
                                                                signupphno.text,
                                                                activationkey
                                                                    .text
                                                                    .toString())
                                                            .then(
                                                                (activationKey) {
                                                          if (activationKey !=
                                                              '') {
                                                            print(
                                                                "section 2 shubha");

                                                            activationkey.text =
                                                                activationKey;

                                                            mobile_key_signup
                                                                .currentState!
                                                                .save();
                                                            Get.toNamed(
                                                                "/Mobilesigninotpscreen",
                                                                arguments: {
                                                                  'signupuser':
                                                                      signupphno
                                                                          .text,
                                                                  'signupfirstname':
                                                                      signupfirstname
                                                                          .text,
                                                                  'signuplastname':
                                                                      signuplastname
                                                                          .text,
                                                                  'signupemail':
                                                                      signupemail
                                                                          .text,
                                                                  'signuppassword':
                                                                      signuppassword
                                                                          .text,
                                                                  'signupphno':
                                                                      signupphno
                                                                          .text,
                                                                  // 'signupcourse':signupcourse,
                                                                  'activationkey':
                                                                      activationkey
                                                                          .text,

                                                                  'signupwaphno':
                                                                      signupwaphno
                                                                          .text,
                                                                  'phonenumbercountryid':
                                                                      phoneNumberCountryId
                                                                          .text,
                                                                  'whatsappnumbercountryid':
                                                                      whatsAppNumberCountryId
                                                                          .text,
                                                                });
                                                          }
                                                        });
                                                      } else {
                                                        Get.snackbar("Error",
                                                            "Please enter valid details",
                                                            colorText: ColorPage
                                                                .white);
                                                      }
                                                    }
                                                  },
                                                  child: Text(
                                                    'Sign Up',
                                                    style: TextStyle(
                                                        fontSize:
                                                            ClsFontsize.Large,
                                                        color: Colors.white),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [
                                      //     SizedBox(
                                      //         width: formfieldsize,
                                      //         // height: 10,
                                      //         child: MaterialButton(
                                      //           shape:
                                      //               ContinuousRectangleBorder(
                                      //                   borderRadius:
                                      //                       BorderRadius
                                      //                           .circular(
                                      //                               20)),

                                      //           // color: ColorPage.colorgrey,
                                      //           onPressed: () {},
                                      //           child: Text(
                                      //             'Login',
                                      //             style: TextStyle(
                                      //               fontSize: ClsFontsize
                                      //                   .DoubleExtraSmall,
                                      //             ),
                                      //           ),
                                      //         ))
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                )
                              : Form(
                                  key: mobile_key_login,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: formfieldsize,
                                            child: Text(
                                              origin ==
                                                      "com.dthlms.pro" //dont change it by sayak mishra
                                                  ? 'User name'
                                                  : 'Username/Email/Phone',
                                              style: FontFamily.mobilefont,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: formfieldsize,
                                              child: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Cannot be blank';
                                                  }
                                                  return null;
                                                },
                                                controller: loginemail,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  hintText: origin ==
                                                          "com.dthlms.pro" //dont change it by sayak mishra
                                                      ? 'Enter Your User name'
                                                      : 'Enter Your Username or Email or Phone',
                                                  fillColor: Color.fromARGB(
                                                      255, 247, 246, 246),
                                                  filled: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0.5,
                                                      color: Color.fromARGB(
                                                          255, 196, 194, 194),
                                                    ),
                                                    gapPadding: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                // controller: ,
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: formfieldsize,
                                            child: Text(
                                              'Password',
                                              style: FontFamily.mobilefont,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: formfieldsize,
                                              child: Obx(
                                                () => TextFormField(
                                                  obscureText: getx
                                                      .loginpasswordshow.value,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Cannot be blank';
                                                    }
                                                    return null;
                                                  },
                                                  controller: loginpassword,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  decoration: InputDecoration(
                                                      hintText: '************',
                                                      fillColor: Color.fromARGB(
                                                          255, 247, 246, 246),
                                                      filled: true,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: Color.fromARGB(
                                                              255,
                                                              196,
                                                              194,
                                                              194),
                                                        ),
                                                        gapPadding: 20,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: Color.fromARGB(
                                                              255,
                                                              196,
                                                              194,
                                                              194),
                                                        ),
                                                        gapPadding: 20,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      suffixIcon: IconButton(
                                                          onPressed: () {
                                                            getx.loginpasswordshow
                                                                    .value =
                                                                !getx
                                                                    .loginpasswordshow
                                                                    .value;
                                                          },
                                                          icon: getx
                                                                  .loginpasswordshow
                                                                  .value
                                                              ? const Icon(Icons
                                                                  .visibility)
                                                              : const Icon(Icons
                                                                  .visibility_off))),
                                                ),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                      ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [
                                      //     Container(
                                      //       alignment: Alignment.topRight,
                                      //       width: formfieldsize,
                                      //       child: TextButton(
                                      //         onPressed: () {
                                      //           Get.to(
                                      //               () => ForgotScreenMobile());
                                      //           // Get.to(() =>
                                      //           //     const ForgetPasswordMobile());
                                      //         },
                                      //         child: Text(
                                      //           'Forget password',
                                      //           style: FontFamily.mobilefont,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [
                                      //     SizedBox(
                                      //       width: formfieldsize,
                                      //       child: Text(
                                      //         'OTP',
                                      //         style:
                                      //             FontFamily.mobilefont,
                                      //       ),
                                      //     )
                                      //   ],
                                      // ),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [
                                      //     SizedBox(
                                      //         width: formfieldsize,
                                      //         child: TextFormField(
                                      //           autovalidateMode:
                                      //               AutovalidateMode
                                      //                   .onUserInteraction,
                                      //           validator: (value) {
                                      //             if (value!.isEmpty) {
                                      //               return 'Cannot be blank';
                                      //             }
                                      //             return null;
                                      //           },
                                      //           controller: loginotp,
                                      //           keyboardType:
                                      //               const TextInputType
                                      //                   .numberWithOptions(),
                                      //           decoration: InputDecoration(
                                      //               enabledBorder: border,
                                      //               focusedBorder: border,
                                      //               suffixIcon: IconButton(
                                      //                   onPressed: () {},
                                      //                   icon: const Icon(Icons
                                      //                       .visibility)),
                                      //               hintText:
                                      //                   '*'),
                                      //         ))
                                      //   ],
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: formfieldsize,
                                                child: MaterialButton(
                                                  shape:
                                                      ContinuousRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  color: ColorPage.color1,
                                                  onPressed: () async {
                                                    // var token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJGaXJzdE5hbWUiOiJTb3VyYXYiLCJMYXN0TmFtZSI6Ik5hdGgiLCJuYW1laWQiOiI2NTg0YWUzNC00NjMwLTRhNjMtYjI3MC1kNjUwNjdmNTNmZDIiLCJGcmFuY2hpc2VJZCI6IjEiLCJNb2JpbGUiOiI5ODMxODExOTIzIiwiZW1haWwiOiJpc3NzYnN0MjAxNkBnbWFpbC5jb20iLCJyb2xlIjoiVGVzdGVyIiwibmJmIjoxNzIxNzI2NjA3LCJleHAiOjE3MjE3MzAyMDcsImlhdCI6MTcyMTcyNjYwN30.Z3ALSqb6bZwjkOcx2uSFpPjS3Ktqhp8dkolsUrekH1o";
                                                    //  await tableEncryptionHistory(context,token);

                                                    if (mobile_key_login
                                                        .currentState!
                                                        .validate()) {
                                                      mobile_key_login
                                                          .currentState!
                                                          .save();

                                                      await loginApi(
                                                          context,
                                                          loginemail.text,
                                                          loginpassword.text,
                                                          loginotp.text);
                                                    }
                                                    // await loginApi(
                                                    //                   context,
                                                    //                   'wotepog836@rowplant.com',
                                                    //                   'Shubha@2003',
                                                    //                   '1234'
                                                    //                   );
                                                  },
                                                  child: Text(
                                                    'Login',
                                                    style: TextStyle(
                                                        fontSize: fontsize,
                                                        color: Colors.white),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: height,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: Colors.grey[400],
                                              thickness: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'OR',
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: Colors.grey[400],
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),

                                      // Forget Password Text
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                              transition: Transition.cupertino,
                                              () => ForgotScreenMobile());
                                        },
                                        child: const Text.rich(
                                          TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400),
                                              // style: TextStyle(color: Colors.blu),
                                              text: 'Recover your password ? ',
                                              children: [
                                                TextSpan(
                                                    text: 'FORGET PASSWORD',
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: Color.fromARGB(
                                                            255, 44, 27, 197),
                                                        fontWeight:
                                                            FontWeight.w400))
                                              ]),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text("Version: ${getx.appVersion.value}",
                        style: TextStyle(color: Colors.black45, fontSize: 12)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
