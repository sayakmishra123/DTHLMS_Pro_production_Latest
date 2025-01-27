import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController emailcode = TextEditingController();
  TextEditingController phno = TextEditingController();
  TextEditingController emailid = TextEditingController();
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
      fillColor: Color.fromARGB(255, 248, 249, 252)
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
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    // });
    // getx.forgetpageshow.value=false;

    super.initState();
  }

  @override
  void dispose() {
    getx.forgetpageshow.value = false;
    getx.forgetpassword1.value = false;
    getx.forgetpassword2.value = false;
    getx.forgetpasswordemailcode.value = false;

    // TODO: implement dispose
    super.dispose();
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
                                              getx.forgetpageshow.value = true;
                                              Get.back();
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getx.forgetpageshow.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Card(
                                      elevation: 80,
                                      // color: Colors.white,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: ColorPage.white,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 70, horizontal: 100),
                                        child: Form(
                                          key: key,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 50),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Reset Password',
                                                      style: FontFamily.font,
                                                      textScaler:
                                                          const TextScaler
                                                              .linear(1.4),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: SizedBox(
                                                  // height: 400,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                          width: 300,
                                                          child: TextFormField(
                                                              controller:
                                                                  emailid,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              style:
                                                                  const TextStyle(),
                                                              decoration:
                                                                  email))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        width: 300,
                                                        child: TextFormField(
                                                            controller: phno,
                                                            obscureText: getx
                                                                .forgetpassword1
                                                                .value,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            decoration:
                                                                InputDecoration(
                                                              prefixIcon: Icon(
                                                                  Icons.phone),
                                                              filled: true,
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      248,
                                                                      249,
                                                                      252),
                                                              hintStyle: const TextStyle(
                                                                  color: ColorPage
                                                                      .colorgrey),
                                                              labelStyle:
                                                                  GoogleFonts
                                                                      .outfit(),
                                                              // hintText: '',
                                                              labelText:
                                                                  'Phone no',
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 300,
                                                      child: TextFormField(
                                                          controller: password,
                                                          obscureText: getx
                                                              .forgetpassword1
                                                              .value,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          decoration:
                                                              InputDecoration(
                                                            filled: true,
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    248,
                                                                    249,
                                                                    252),
                                                            hintStyle: const TextStyle(
                                                                color: ColorPage
                                                                    .colorgrey),
                                                            labelStyle:
                                                                GoogleFonts
                                                                    .outfit(),
                                                            // hintText: '',
                                                            labelText:
                                                                'Password',
                                                            suffixIcon: IconButton(
                                                                onPressed: () {
                                                                  getx.forgetpassword1
                                                                          .value =
                                                                      !getx
                                                                          .forgetpassword1
                                                                          .value;
                                                                },
                                                                icon: getx.forgetpassword1.value
                                                                    ? const Icon(
                                                                        Icons
                                                                            .visibility,
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .visibility_off,
                                                                      )),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 300,
                                                      child: TextFormField(
                                                          controller:
                                                              confirmpassword,
                                                          obscureText: getx
                                                              .forgetpassword1
                                                              .value,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          decoration:
                                                              InputDecoration(
                                                            filled: true,
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    248,
                                                                    249,
                                                                    252),
                                                            hintStyle: const TextStyle(
                                                                color: ColorPage
                                                                    .colorgrey),
                                                            labelStyle:
                                                                GoogleFonts
                                                                    .outfit(),
                                                            // hintText: '',
                                                            labelText:
                                                                'Confirm Password',
                                                            suffixIcon: IconButton(
                                                                onPressed: () {
                                                                  getx.forgetpassword1
                                                                          .value =
                                                                      !getx
                                                                          .forgetpassword1
                                                                          .value;
                                                                },
                                                                icon: getx.forgetpassword1.value
                                                                    ? const Icon(
                                                                        Icons
                                                                            .visibility,
                                                                      )
                                                                    : const Icon(
                                                                        Icons
                                                                            .visibility_off,
                                                                      )),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 40),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5),
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              padding: const WidgetStatePropertyAll(
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          60,
                                                                      vertical:
                                                                          15)),
                                                              backgroundColor:
                                                                  WidgetStatePropertyAll(
                                                                      ColorPage
                                                                          .buttonColor),
                                                              shape: WidgetStatePropertyAll(
                                                                  ContinuousRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)))),
                                                          onPressed: () async {
                                                            resetPassword(
                                                                context,
                                                                emailid.text,
                                                                phno.text,
                                                                password.text,
                                                                confirmpassword
                                                                    .text,
                                                                resetcode);
                                                          },
                                                          // confirm pass
                                                          child: Text(
                                                            'Submit',
                                                            style: FontFamily
                                                                .font3,
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Card(
                                      elevation: 80,
                                      // color: Colors.white,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: ColorPage.white,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 70, horizontal: 100),
                                        child: Form(
                                          key: key,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 50),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Forgot your password',
                                                      style: FontFamily.font,
                                                      textScaler:
                                                          const TextScaler
                                                              .linear(1.4),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: SizedBox(
                                                  // height: 400,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                          width: 300,
                                                          child: TextFormField(
                                                              controller:
                                                                  emailid,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              style:
                                                                  const TextStyle(),
                                                              decoration:
                                                                  email))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                          width: 300,
                                                          child: Obx(() =>
                                                              TextFormField(
                                                                  controller:
                                                                      phno,
                                                                  obscureText: getx
                                                                      .forgetpassword1
                                                                      .value,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    prefixIcon:
                                                                        Icon(Icons
                                                                            .phone),
                                                                    filled:
                                                                        true,
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            248,
                                                                            249,
                                                                            252),
                                                                    hintStyle: const TextStyle(
                                                                        color: ColorPage
                                                                            .colorgrey),
                                                                    labelStyle:
                                                                        GoogleFonts
                                                                            .outfit(),
                                                                    // hintText: '',
                                                                    labelText:
                                                                        'Phone no',
                                                                    suffixIcon: IconButton(
                                                                        onPressed: () {
                                                                          getx.forgetpassword1.value = !getx
                                                                              .forgetpassword1
                                                                              .value;
                                                                        },
                                                                        icon: getx.forgetpassword1.value
                                                                            ? const Icon(
                                                                                Icons.visibility,
                                                                              )
                                                                            : const Icon(
                                                                                Icons.visibility_off,
                                                                              )),
                                                                  ))))
                                                    ]),
                                              ),
                                              Visibility(
                                                visible: getx
                                                    .forgetpasswordemailcode
                                                    .value,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 300,
                                                        child: TextFormField(
                                                            onFieldSubmitted:
                                                                (value) {
                                                              print(forgetkey);

                                                              forgetPassword(
                                                                      context,
                                                                      emailid
                                                                          .text,
                                                                      forgetkey,
                                                                      emailcode
                                                                          .text)
                                                                  .then((value) =>
                                                                      resetcode =
                                                                          value);
                                                            },
                                                            controller:
                                                                emailcode,
                                                            obscureText: getx
                                                                .forgetpassword1
                                                                .value,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .next,
                                                            decoration:
                                                                InputDecoration(
                                                              filled: true,
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      248,
                                                                      249,
                                                                      252),
                                                              hintStyle: const TextStyle(
                                                                  color: ColorPage
                                                                      .colorgrey),
                                                              labelStyle:
                                                                  GoogleFonts
                                                                      .outfit(),
                                                              // hintText: '',
                                                              labelText:
                                                                  'Email code',
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 40),
                                                child: Container(
                                                  // width:
                                                  //     MediaQuery.sizeOf(context)
                                                  //         .width,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child:
                                                            getx.forgetpasswordemailcode
                                                                    .value
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            50),
                                                                    child: MaterialButton(
                                                                        color: ColorPage.color1,
                                                                        onPressed: () async {
                                                                          print(
                                                                              forgetkey);

                                                                          forgetPassword(context, emailid.text, forgetkey, emailcode.text).then((value) =>
                                                                              resetcode = value);
                                                                        },
                                                                        child: Text(
                                                                          'Submit',
                                                                          style:
                                                                              FontFamily.font3,
                                                                        )),
                                                                  )
                                                                : Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            50),
                                                                    child: MaterialButton(
                                                                        color: ColorPage.color1,
                                                                        onPressed: () async {
                                                                          print(
                                                                              forgetkey);

                                                                          // forgetgenerateCode(context, phno.text, emailid.text).then((value) =>
                                                                          //     forgetkey = value);
                                                                        },
                                                                        child: Text(
                                                                          'Submit',
                                                                          style:
                                                                              FontFamily.font3,
                                                                        )),
                                                                  ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
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
}
