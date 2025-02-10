import 'dart:io';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/API/LOGIN/login_api.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/MOBILE/LOGIN/loginpage_mobile.dart';
import 'package:dthlms/PC/OTP/otpscreen.dart';

// import 'package:dthlms/PC/RESET-PASSWORD/Changepassword.dart';
import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
// import 'package:dthlms/android/login/dth_mob_login.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:local_notifier/local_notifier.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../FORGETPASSWORD/forgetpasswordpc.dart';

class DthLmsLogin extends StatefulWidget {
  const DthLmsLogin({super.key});

  @override
  State<DthLmsLogin> createState() => _DthLmsLoginState();
}

class _DthLmsLoginState extends State<DthLmsLogin> {
  TextEditingController signupuser = TextEditingController();
  TextEditingController signupfirstname = TextEditingController();
  TextEditingController signuplastname = TextEditingController();
  TextEditingController signupemail = TextEditingController();
  TextEditingController signupphno = TextEditingController();
  TextEditingController signupwaphno = TextEditingController();

  TextEditingController phoneNumberCountryId = TextEditingController();
  TextEditingController whatsAppNumberCountryId = TextEditingController();

  TextEditingController signuppassword = TextEditingController();
  TextEditingController activationkey = TextEditingController();

  TextEditingController loginemail = TextEditingController();
  TextEditingController loginpassword = TextEditingController();

  TextEditingController loginotp = TextEditingController();
  FocusNode focusNode = FocusNode();
  TextEditingController signupconfirmpassword = TextEditingController();
  final GlobalKey<FormState> desktop_key1 = GlobalKey();
  final GlobalKey<FormState> desktop_key2 = GlobalKey();

  late double formfieldsize = 400;
  late double fontsize = ClsFontsize.DoubleExtraLarge + 2;
  Getx getxController = Get.put(Getx());

  //  String loginid = Get.arguments['loginid']??'0';
  //   String password = Get.arguments['password']??'0';
  InputBorder border = const UnderlineInputBorder(
      borderSide: BorderSide(color: ColorPage.colorgrey));
  final bool _isVisible = true;
  RxBool fullScreen = true.obs;

  @override
  void initState() {
    print('logindth');
    getUserid();

    if (getx.loginuserdata.isNotEmpty) {
      print("get login id and password");
      loginemail.text = getx.loginuserdata[0].loginId;
      loginpassword.text = getx.loginuserdata[0].password;
    }
    formfieldsize = Platform.isIOS ? 300 : formfieldsize;
    getCountrycodeListFunction().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  getUserid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    loginemail.text = prefs.getString("LoginId") ?? '';
  }

  Future getCountrycodeListFunction() async {
    countryCode.value = await getCountryId();
  }

  AnimatedButtonController animatedButtonController =
      AnimatedButtonController();
  var key = '0';
  double height = 4;
  notification() async {
    await localNotifier.setup(
      appName: 'local_notifier_example',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );

    LocalNotification notification = LocalNotification(
      title: "local_notifier_example",
      body: "hello flutter!",
    );
    notification.onShow = () {};
    notification.onClose = (closeReason) {
      switch (closeReason) {
        case LocalNotificationCloseReason.userCanceled:
          break;
        case LocalNotificationCloseReason.timedOut:
          break;
        default:
      }
    };
    notification.onClick = () {
      print('onClick ${notification.identifier}');
      Get.to(transition: Transition.cupertino, () => DthLmsLogin());
    };
    notification.onClickAction = (actionIndex) {
      print('onClickAction ${notification.identifier} - $actionIndex');
      Get.to(transition: Transition.cupertino, () => DthLmsLogin());
    };

    notification.show();
  }

  int selectedCountryCodePh = 1;
  int selectedCountryCodeWa = 1;

  RxList<Map<String, dynamic>> countryCode = <Map<String, dynamic>>[
    {"value": 1, "label": "91 - India"},
    {"value": 2, "label": "93 - Afghanistan"},
  ].obs;

// Widget? x
  @override
  Widget build(BuildContext context) {
    late RxDouble screenwidth = MediaQuery.of(context).size.width.obs;
    return GestureDetector(
      onPanStart: (details) {
        print(details.globalPosition.toString());
      },
      child: Material(
        child: Scaffold(
            body: _isVisible && Platform.isWindows
                ? Container(
                    // decoration: BoxDecoration(
                    //     gradient: LinearGradient(colors: [
                    //       const Color.fromARGB(255, 250, 246, 247),
                    //       const Color.fromARGB(255, 238, 243, 247)
                    //     ]),
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.sizeOf(context).height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/Black and Red Minimalist Modern Registration Gym Website Prototype (1).jpg'),
                          fit: BoxFit.fill),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: screenwidth.value > 850 ? true : false,
                          child: Expanded(
                            child: Column(
                              children: [
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            fit: BoxFit.contain,
                                            'assets/loginimg2.png',
                                            height: MediaQuery.sizeOf(context)
                                                    .height -
                                                100,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // color: Colors.red,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // SizedBox(
                                  //   height: 100,
                                  // ),
                                  Card(
                                    elevation: 10,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 30),
                                      width: 500,
                                      // height: 1000,
                                      decoration: BoxDecoration(
                                          color: ColorPage.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      alignment: Alignment.center,
                                      child: Obx(
                                        () => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 100,
                                                  width: 250,
                                                  child: Image.asset(
                                                    logopath,
                                                    scale: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 400,
                                                  child: AnimatedButtonBar(
                                                    controller:
                                                        animatedButtonController
                                                          ..setIndex(getxController
                                                              .ButtonControllerIndex
                                                              .value),
                                                    radius: 32.0,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 227, 228, 228),
                                                    foregroundColor: Colors
                                                        .blueGrey.shade300,
                                                    elevation: 4,
                                                    curve: Curves.linear,
                                                    borderColor:
                                                        ColorPage.white,
                                                    borderWidth: 2,
                                                    innerVerticalPadding: 16,
                                                    children: [
                                                      ButtonBarEntry(
                                                          onTap: () {
                                                            getxController.show
                                                                .value = false;
                                                            getxController
                                                                .ButtonControllerIndex
                                                                .value = 0;
                                                          },
                                                          child: Text(
                                                            'Log in',
                                                            style: FontFamily
                                                                .font
                                                                .copyWith(
                                                                    fontSize:
                                                                        fontsize -
                                                                            2),
                                                            // fontSize:
                                                            //                   fontsize,
                                                          )),
                                                      ButtonBarEntry(
                                                          onTap: () {
                                                            getxController.show
                                                                .value = true;
                                                            getxController
                                                                .ButtonControllerIndex
                                                                .value = 1;
                                                          },
                                                          child: Text(
                                                            'Sign up',
                                                            style: FontFamily
                                                                .font
                                                                .copyWith(
                                                                    fontSize:
                                                                        fontsize -
                                                                            2),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            getxController.show.value
                                                ? getxController.isSignup.value
                                                    ? Form(
                                                        key: desktop_key1,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      formfieldsize /
                                                                          2.1,
                                                                  child: Text(
                                                                    'First Name',
                                                                    style:
                                                                        FontFamily
                                                                            .font,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      formfieldsize /
                                                                          2.1,
                                                                  child: Text(
                                                                    'Last Name',
                                                                    style:
                                                                        FontFamily
                                                                            .font,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    width:
                                                                        formfieldsize /
                                                                            2,
                                                                    child:
                                                                        TextFormField(
                                                                      autovalidateMode:
                                                                          AutovalidateMode
                                                                              .onUserInteraction,
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                      validator:
                                                                          (value) {
                                                                        if (value!
                                                                            .isEmpty) {
                                                                          return 'Cannot be blank';
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      },
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .name,
                                                                      controller:
                                                                          signupfirstname,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'First Name',
                                                                        fillColor: Color.fromARGB(
                                                                            255,
                                                                            247,
                                                                            246,
                                                                            246),
                                                                        filled:
                                                                            true,
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            width:
                                                                                0.5,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                196,
                                                                                194,
                                                                                194),
                                                                          ),
                                                                          gapPadding:
                                                                              20,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            width:
                                                                                0.5,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                196,
                                                                                194,
                                                                                194),
                                                                          ),
                                                                          gapPadding:
                                                                              20,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                      ),
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter.allow(
                                                                            RegExp(r'[a-zA-Z]')),
                                                                      ],
                                                                    )),
                                                                SizedBox(
                                                                  width:
                                                                      height +
                                                                          5,
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        formfieldsize /
                                                                            2.1,
                                                                    child:
                                                                        TextFormField(
                                                                      autovalidateMode:
                                                                          AutovalidateMode
                                                                              .onUserInteraction,
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                      validator:
                                                                          (value) {
                                                                        if (value!
                                                                            .isEmpty) {
                                                                          return 'Cannot be blank';
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      },
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .name,
                                                                      controller:
                                                                          signuplastname,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Last Name',
                                                                        fillColor: Color.fromARGB(
                                                                            255,
                                                                            247,
                                                                            246,
                                                                            246),
                                                                        filled:
                                                                            true,
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            width:
                                                                                0.5,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                196,
                                                                                194,
                                                                                194),
                                                                          ),
                                                                          gapPadding:
                                                                              20,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            width:
                                                                                0.5,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                196,
                                                                                194,
                                                                                194),
                                                                          ),
                                                                          gapPadding:
                                                                              20,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                      ),
                                                                      inputFormatters: [
                                                                        FilteringTextInputFormatter.allow(
                                                                            RegExp(r'[a-zA-Z]')),
                                                                      ],
                                                                    ))
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            // Continue with existing code...
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      formfieldsize,
                                                                  child: Text(
                                                                    'Email',
                                                                    style:
                                                                        FontFamily
                                                                            .font,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    width:
                                                                        formfieldsize,
                                                                    child:
                                                                        TextFormField(
                                                                      autovalidateMode:
                                                                          AutovalidateMode
                                                                              .onUserInteraction,
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                      validator:
                                                                          (value) {
                                                                        if (value!
                                                                            .isEmpty) {
                                                                          return 'Cannot be blank';
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      },
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .emailAddress,
                                                                      controller:
                                                                          signupemail,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Enter your email',
                                                                        fillColor: Color.fromARGB(
                                                                            255,
                                                                            247,
                                                                            246,
                                                                            246),
                                                                        filled:
                                                                            true,
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            width:
                                                                                0.5,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                196,
                                                                                194,
                                                                                194),
                                                                          ),
                                                                          gapPadding:
                                                                              20,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            width:
                                                                                0.5,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                196,
                                                                                194,
                                                                                194),
                                                                          ),
                                                                          gapPadding:
                                                                              20,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
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
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      formfieldsize,
                                                                  child: Text(
                                                                    'Contact Number',
                                                                    style:
                                                                        FontFamily
                                                                            .font,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: 100,
                                                                  child:
                                                                      DropdownButton<
                                                                          int>(
                                                                    menuWidth:
                                                                        200,
                                                                    isExpanded:
                                                                        true,
                                                                    isDense:
                                                                        true,
                                                                    value:
                                                                        selectedCountryCodePh,
                                                                    onChanged:
                                                                        (newValue) {
                                                                      setState(
                                                                          () {
                                                                        selectedCountryCodePh =
                                                                            newValue!;
                                                                        phoneNumberCountryId.text =
                                                                            newValue.toString();
                                                                      });
                                                                    },
                                                                    items: countryCode
                                                                        .map<DropdownMenuItem<int>>(
                                                                            (item) {
                                                                      return DropdownMenuItem<
                                                                          int>(
                                                                        value: item[
                                                                            "value"],
                                                                        child: Text(
                                                                            item["label"]!),
                                                                      );
                                                                    }).toList(),
                                                                    dropdownColor:
                                                                        ColorPage
                                                                            .white,
                                                                    style: TextStyle(
                                                                        color: ColorPage
                                                                            .colorgrey),
                                                                    underline:
                                                                        Container(),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                SizedBox(
                                                                  width: 290,
                                                                  child: Obx(() =>
                                                                      TextFormField(
                                                                        controller:
                                                                            signupphno,
                                                                        autovalidateMode:
                                                                            AutovalidateMode.onUserInteraction,
                                                                        obscureText: getx
                                                                            .forgetpassword1
                                                                            .value,
                                                                        textInputAction:
                                                                            TextInputAction.next,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          prefixIcon:
                                                                              Icon(Icons.phone),
                                                                          filled:
                                                                              true,
                                                                          fillColor: Color.fromARGB(
                                                                              255,
                                                                              247,
                                                                              246,
                                                                              246),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              width: 0.5,
                                                                              color: Color.fromARGB(255, 196, 194, 194),
                                                                            ),
                                                                            gapPadding:
                                                                                20,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              width: 0.5,
                                                                              color: Color.fromARGB(255, 196, 194, 194),
                                                                            ),
                                                                            gapPadding:
                                                                                20,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          hintStyle:
                                                                              const TextStyle(color: ColorPage.colorgrey),
                                                                          labelStyle:
                                                                              GoogleFonts.outfit(),
                                                                          labelText:
                                                                              'Contact no',
                                                                        ),
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.allow(
                                                                              RegExp(r'[0-9]')),
                                                                        ],
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Contact number is required';
                                                                          }

                                                                          if (!RegExp(r'^[0-9]+$')
                                                                              .hasMatch(value)) {
                                                                            return 'Phone number must contain only digits';
                                                                          }
                                                                          if (value.length > 10 &&
                                                                              selectedCountryCodePh.toString().startsWith('1')) {
                                                                            return "The number must be 10 digits.";
                                                                          }
                                                                          return null;
                                                                        },
                                                                      )),
                                                                ),
                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      formfieldsize,
                                                                  child: Text(
                                                                    'Whatsapp Number',
                                                                    style:
                                                                        FontFamily
                                                                            .font,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height,
                                                            ),

                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: 100,
                                                                  child:
                                                                      DropdownButton<
                                                                          int>(
                                                                    menuWidth:
                                                                        200,
                                                                    isExpanded:
                                                                        true,
                                                                    isDense:
                                                                        true,
                                                                    value:
                                                                        selectedCountryCodeWa,
                                                                    onChanged:
                                                                        (newValue) {
                                                                      setState(
                                                                          () {
                                                                        selectedCountryCodeWa =
                                                                            newValue!;
                                                                        whatsAppNumberCountryId.text =
                                                                            newValue.toString();
                                                                      });
                                                                    },
                                                                    items: countryCode
                                                                        .map<DropdownMenuItem<int>>(
                                                                            (item) {
                                                                      return DropdownMenuItem<
                                                                          int>(
                                                                        value: item[
                                                                            "value"],
                                                                        child: Text(
                                                                            item["label"]!),
                                                                      );
                                                                    }).toList(),
                                                                    dropdownColor:
                                                                        ColorPage
                                                                            .white,
                                                                    style: TextStyle(
                                                                        color: ColorPage
                                                                            .colorgrey),
                                                                    underline:
                                                                        Container(),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                SizedBox(
                                                                  width: 290,
                                                                  child: Obx(() =>
                                                                      TextFormField(
                                                                        controller:
                                                                            signupwaphno,
                                                                        autovalidateMode:
                                                                            AutovalidateMode.onUserInteraction,
                                                                        obscureText: getx
                                                                            .forgetpassword1
                                                                            .value,
                                                                        textInputAction:
                                                                            TextInputAction.next,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          prefixIcon:
                                                                              Icon(Icons.phone),
                                                                          filled:
                                                                              true,
                                                                          fillColor: Color.fromARGB(
                                                                              255,
                                                                              247,
                                                                              246,
                                                                              246),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              width: 0.5,
                                                                              color: Color.fromARGB(255, 196, 194, 194),
                                                                            ),
                                                                            gapPadding:
                                                                                20,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              width: 0.5,
                                                                              color: Color.fromARGB(255, 196, 194, 194),
                                                                            ),
                                                                            gapPadding:
                                                                                20,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          hintStyle:
                                                                              const TextStyle(color: ColorPage.colorgrey),
                                                                          labelStyle:
                                                                              GoogleFonts.outfit(),
                                                                          labelText:
                                                                              'Whatsapp Number',
                                                                        ),
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.allow(
                                                                              RegExp(r'[0-9]')),
                                                                        ],
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Whatsapp Number is required';
                                                                          }

                                                                          if (!RegExp(r'^[0-9]+$')
                                                                              .hasMatch(value)) {
                                                                            return 'Whatsapp Number must contain only digits';
                                                                          }
                                                                          return null;
                                                                        },
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      formfieldsize,
                                                                  child: Text(
                                                                    'Password',
                                                                    style:
                                                                        FontFamily
                                                                            .font,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Obx(
                                                                  () => SizedBox(
                                                                      width: formfieldsize,
                                                                      child: TextFormField(
                                                                          style: TextStyle(fontSize: 14),
                                                                          obscureText: getx.signuppasswordshow.value,
                                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                          textInputAction: TextInputAction.next,
                                                                          validator: (value) {
                                                                            if (value!
                                                                                .isEmpty) {
                                                                              return 'Password cannot be blank';
                                                                            } else if (value.length <
                                                                                8) {
                                                                              return 'Password must be at least 9 characters long';
                                                                            } else if (!RegExp(r'^(?=.*[A-Z])').hasMatch(
                                                                                value)) {
                                                                              return 'Password must contain at least one uppercase letter';
                                                                            } else if (!RegExp(r'^(?=.*[a-z])').hasMatch(
                                                                                value)) {
                                                                              return 'Password must contain at least one lowercase letter';
                                                                            } else if (!RegExp(r'^(?=.*\d)').hasMatch(
                                                                                value)) {
                                                                              return 'Password must contain at least one number';
                                                                            } else if (!RegExp(r'^(?=.*[\W_])').hasMatch(
                                                                                value)) {
                                                                              return 'Password must contain at least one special character';
                                                                            } else if (RegExp(r'[a-zA-Z]').allMatches(value).length <
                                                                                5) {
                                                                              return 'Password must contain at least 5 alphabetic characters (both uppercase and lowercase)';
                                                                            }
                                                                            return null;
                                                                          },
                                                                          keyboardType: TextInputType.visiblePassword,
                                                                          controller: signuppassword,
                                                                          decoration: InputDecoration(
                                                                            hintText:
                                                                                'Password',
                                                                            fillColor: Color.fromARGB(
                                                                                255,
                                                                                247,
                                                                                246,
                                                                                246),
                                                                            filled:
                                                                                true,
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                width: 0.5,
                                                                                color: Color.fromARGB(255, 196, 194, 194),
                                                                              ),
                                                                              gapPadding: 20,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                width: 0.5,
                                                                                color: Color.fromARGB(255, 196, 194, 194),
                                                                              ),
                                                                              gapPadding: 20,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            suffixIcon: IconButton(
                                                                                onPressed: () {
                                                                                  getx.signuppasswordshow.value = !getx.signuppasswordshow.value;
                                                                                },
                                                                                icon: getx.signuppasswordshow.value ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
                                                                          ))),
                                                                )
                                                              ],
                                                            ),

                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      formfieldsize,
                                                                  child: Text(
                                                                    'Confirm Password',
                                                                    style:
                                                                        FontFamily
                                                                            .font,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Obx(
                                                                  () => SizedBox(
                                                                      width: formfieldsize,
                                                                      child: TextFormField(
                                                                          style: TextStyle(fontSize: 14),
                                                                          obscureText: getx.signuppasswordshow.value,
                                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                          textInputAction: TextInputAction.next,
                                                                          validator: (value) {
                                                                            if (value!
                                                                                .isEmpty) {
                                                                              return 'Confirm Password cannot be blank';
                                                                            } else if (value.length <
                                                                                8) {
                                                                              return 'Confirm Password must be at least 9 characters long';
                                                                            } else if (!RegExp(r'^(?=.*[A-Z])').hasMatch(
                                                                                value)) {
                                                                              return 'Confirm Password must contain at least one uppercase letter';
                                                                            } else if (!RegExp(r'^(?=.*[a-z])').hasMatch(
                                                                                value)) {
                                                                              return 'Confirm Password must contain at least one lowercase letter';
                                                                            } else if (!RegExp(r'^(?=.*\d)').hasMatch(
                                                                                value)) {
                                                                              return 'Confirm Password must contain at least one number';
                                                                            } else if (!RegExp(r'^(?=.*[\W_])').hasMatch(
                                                                                value)) {
                                                                              return 'Confirm Password must contain at least one special character';
                                                                            } else if (RegExp(r'[a-zA-Z]').allMatches(value).length <
                                                                                5) {
                                                                              return 'Confirm Password must contain at least 5 alphabetic characters (both uppercase and lowercase)';
                                                                            }
                                                                            return null;
                                                                          },
                                                                          keyboardType: TextInputType.visiblePassword,
                                                                          controller: signupconfirmpassword,
                                                                          decoration: InputDecoration(
                                                                            hintText:
                                                                                'Confirm Password',
                                                                            fillColor: Color.fromARGB(
                                                                                255,
                                                                                247,
                                                                                246,
                                                                                246),
                                                                            filled:
                                                                                true,
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                width: 0.5,
                                                                                color: Color.fromARGB(255, 196, 194, 194),
                                                                              ),
                                                                              gapPadding: 20,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                width: 0.5,
                                                                                color: Color.fromARGB(255, 196, 194, 194),
                                                                              ),
                                                                              gapPadding: 20,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            suffixIcon: IconButton(
                                                                                onPressed: () {
                                                                                  getx.signuppasswordshow.value = !getx.signuppasswordshow.value;
                                                                                },
                                                                                icon: getx.signuppasswordshow.value ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
                                                                          ))),
                                                                )
                                                              ],
                                                            ),

                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      formfieldsize,
                                                                  child: Text(
                                                                    'Activation Key (Optional)',
                                                                    style:
                                                                        FontFamily
                                                                            .font,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Obx(
                                                                  () => SizedBox(
                                                                      width: formfieldsize,
                                                                      child: TextFormField(
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                        obscureText: getx
                                                                            .activationkeyshow
                                                                            .value,
                                                                        textInputAction:
                                                                            TextInputAction.next,
                                                                        keyboardType:
                                                                            TextInputType.visiblePassword,
                                                                        controller:
                                                                            activationkey,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              'Activation key',
                                                                          fillColor: Color.fromARGB(
                                                                              255,
                                                                              247,
                                                                              246,
                                                                              246),
                                                                          filled:
                                                                              true,
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              width: 0.5,
                                                                              color: Color.fromARGB(255, 196, 194, 194),
                                                                            ),
                                                                            gapPadding:
                                                                                20,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              width: 0.5,
                                                                              color: Color.fromARGB(255, 196, 194, 194),
                                                                            ),
                                                                            gapPadding:
                                                                                20,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                        ),
                                                                        inputFormatters: [
                                                                          FilteringTextInputFormatter.allow(
                                                                              RegExp(r'[a-zA-Z0-9]')),
                                                                        ],
                                                                      )),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          20),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                      width:
                                                                          formfieldsize,
                                                                      child:
                                                                          MaterialButton(
                                                                        shape: ContinuousRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20)),
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            bottom:
                                                                                20),
                                                                        color: ColorPage
                                                                            .color1,
                                                                        onPressed:
                                                                            () async {
                                                                          if (desktop_key1.currentState!.validate() &&
                                                                              GetUtils.isEmail(signupemail.text) &&
                                                                              signupconfirmpassword.text == signuppassword.text) {
                                                                            print("section 1 shubha");
                                                                            print(activationkey.text);
                                                                            await checkUserBeforeRegister(context, signupemail.text, signupphno.text, activationkey.text.toString()).then((activationKey) {
                                                                              if (activationKey != '') {
                                                                                print("section 2 shubha");

                                                                                activationkey.text = activationKey;

                                                                                desktop_key1.currentState!.save();
                                                                                Get.to(() => OTPScreen(signupphno.text, signupfirstname.text, signuplastname.text, signupemail.text, signuppassword.text, signupphno.text, signupwaphno.text, activationkey.text, phoneNumberCountryId.text, whatsAppNumberCountryId.text), transition: Transition.leftToRight);
                                                                              }
                                                                            });
                                                                          } else {
                                                                            Get.snackbar("Error",
                                                                                "Please enter valid details",
                                                                                colorText: ColorPage.white);
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Sign Up',
                                                                          style: TextStyle(
                                                                              fontSize: fontsize,
                                                                              color: ColorPage.white),
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
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Already a member ?',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          ClsFontsize
                                                                              .ExtraSmall),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    width:
                                                                        formfieldsize,
                                                                    child:
                                                                        MaterialButton(
                                                                      shape: ContinuousRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20)),
                                                                      onPressed:
                                                                          () {
                                                                        getxController
                                                                            .show
                                                                            .value = false;
                                                                        getxController
                                                                            .ButtonControllerIndex
                                                                            .value = 0;
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Login',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              ClsFontsize.ExtraSmall,
                                                                        ),
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        child: Text(
                                                            "Sign up is Disable by Admin!"),
                                                      )
                                                : Form(
                                                    key: desktop_key2,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  formfieldsize,
                                                              child: Text(
                                                                'Username/Email/Phone',
                                                                style:
                                                                    FontFamily
                                                                        .font,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                width:
                                                                    formfieldsize,
                                                                child:
                                                                    TextFormField(
                                                                  autovalidateMode:
                                                                      AutovalidateMode
                                                                          .onUserInteraction,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                        .isEmpty) {
                                                                      return 'Cannot be blank';
                                                                    }
                                                                    return null;
                                                                  },
                                                                  controller:
                                                                      loginemail,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .emailAddress,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText: origin ==
                                                                            "com.dthlms.pro"
                                                                        ? 'Enter Your User name'
                                                                        : 'Enter Your Username or Email or Phone',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            247,
                                                                            246,
                                                                            246),
                                                                    filled:
                                                                        true,
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        width:
                                                                            0.5,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            196,
                                                                            194,
                                                                            194),
                                                                      ),
                                                                      gapPadding:
                                                                          20,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        width:
                                                                            0.5,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            196,
                                                                            194,
                                                                            194),
                                                                      ),
                                                                      gapPadding:
                                                                          20,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  formfieldsize,
                                                              child: Text(
                                                                'Password',
                                                                style:
                                                                    FontFamily
                                                                        .font,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                width:
                                                                    formfieldsize,
                                                                child: Obx(
                                                                  () =>
                                                                      TextFormField(
                                                                    onFieldSubmitted:
                                                                        (value) async {
                                                                      if (desktop_key2
                                                                          .currentState!
                                                                          .validate()) {
                                                                        desktop_key2
                                                                            .currentState!
                                                                            .save();
                                                                        await loginApi(
                                                                          context,
                                                                          loginemail
                                                                              .text,
                                                                          loginpassword
                                                                              .text,
                                                                          loginotp
                                                                              .text,
                                                                        );
                                                                      }
                                                                    },
                                                                    obscureText: getx
                                                                        .loginpasswordshow
                                                                        .value,
                                                                    autovalidateMode:
                                                                        AutovalidateMode
                                                                            .onUserInteraction,
                                                                    textInputAction:
                                                                        TextInputAction
                                                                            .next,
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return 'Cannot be blank';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    controller:
                                                                        loginpassword,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .visiblePassword,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          '************',
                                                                      fillColor: Color.fromARGB(
                                                                          255,
                                                                          247,
                                                                          246,
                                                                          246),
                                                                      filled:
                                                                          true,
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          width:
                                                                              0.5,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              196,
                                                                              194,
                                                                              194),
                                                                        ),
                                                                        gapPadding:
                                                                            20,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          width:
                                                                              0.5,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              196,
                                                                              194,
                                                                              194),
                                                                        ),
                                                                        gapPadding:
                                                                            20,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      suffixIcon: IconButton(
                                                                          onPressed: () {
                                                                            getx.loginpasswordshow.value =
                                                                                !getx.loginpasswordshow.value;
                                                                          },
                                                                          icon: getx.loginpasswordshow.value ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
                                                                    ),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),

                                                        SizedBox(
                                                          height: height + 30,
                                                        ),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                  width:
                                                                      formfieldsize,
                                                                  child:
                                                                      MaterialButton(
                                                                    shape:
                                                                        ContinuousRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            18),
                                                                    color: ColorPage
                                                                        .color1,
                                                                    onPressed:
                                                                        () async {
                                                                      if (desktop_key2
                                                                          .currentState!
                                                                          .validate()) {
                                                                        desktop_key2
                                                                            .currentState!
                                                                            .save();
                                                                        await loginApi(
                                                                          context,
                                                                          loginemail
                                                                              .text,
                                                                          loginpassword
                                                                              .text,
                                                                          loginotp
                                                                              .text,
                                                                        );
                                                                      }
                                                                      // notification();
                                                                      // if (!desktop_key2
                                                                      //     .currentState!
                                                                      //     .validate())
                                                                      // Get.to(() =>
                                                                      //     ChangePassword());

                                                                      // {
                                                                      //   desktop_key2
                                                                      //       .currentState!
                                                                      //       .save();
                                                                      //   await loginApi(
                                                                      //       context,
                                                                      //       'TeacherAbhoy',
                                                                      //       'Abhimallik123@',
                                                                      //       '1234');
                                                                      // }
                                                                    },
                                                                    child: Text(
                                                                      'Login',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              fontsize,
                                                                          color:
                                                                              ColorPage.white),
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                          width: 200,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: Divider(
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                  thickness: 1,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                child: Text(
                                                                  'OR',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          600]),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Divider(
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                  thickness: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),

                                                        // Forget Password Text
                                                        GestureDetector(
                                                          onTap: () {
                                                            Get.to(
                                                                transition:
                                                                    Transition
                                                                        .cupertino,
                                                                () =>
                                                                    ForgotScreenPC());
                                                          },
                                                          child:
                                                              const Text.rich(
                                                            TextSpan(
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                                // style: TextStyle(color: Colors.blu),
                                                                text:
                                                                    'Recover your password ? ',
                                                                children: [
                                                                  TextSpan(
                                                                      text:
                                                                          'FORGET PASSWORD',
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration
                                                                              .underline,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              44,
                                                                              27,
                                                                              197),
                                                                          fontWeight:
                                                                              FontWeight.w400))
                                                                ]),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 100),
                                    child: Text("Version :${getx.appVersion}"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Platform.isIOS
                    ? const Mobilelogin()
                    : Container(
                        color: ColorPage.colorblack,
                      )),
      ),
    );
  }
}
