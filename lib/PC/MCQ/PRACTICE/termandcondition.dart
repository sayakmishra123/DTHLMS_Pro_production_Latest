import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/THEORY_EXAM/theoryexampage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../PROFILE/userProfilePage.dart';
import '../../testresult/test_result_page.dart';

// ignore: must_be_immutable
class TheoryExamTermAndCondition extends StatelessWidget {
  final String paperName;
  final String termAndCondition;
  final String duration;
  final String sheduletime;
  final String documnetPath;
  final String paperId;
  final bool isEncrypted;

  // bool windowsddevice = Platform.isWindows ? true : false;

  TheoryExamTermAndCondition(
      {super.key,
      required this.documnetPath,
      required this.termAndCondition,
      required this.paperName,
      required this.duration,
      required this.sheduletime,
      required this.paperId,
      required this.isEncrypted});
  RxBool checkbox = false.obs;

  String formatDateString(String dateString, String type) {
    print(dateString + "//" + type);
    // Parse the input string into a DateTime object
    try {
      DateTime dateTime = DateTime.parse(dateString);

      String formattedOutput;

      if (type == 'time') {
        // Format time only
        formattedOutput = DateFormat('hh:mm a').format(dateTime);
      } else if (type == 'date') {
        // Format date only
        formattedOutput = DateFormat('dd MMM, yyyy').format(dateTime);
      } else if (type == 'datetime') {
        // Format both date and time
        formattedOutput = DateFormat('hh:mm a, dd MMM, yyyy').format(dateTime);
      } else {
        throw ArgumentError(
            'Invalid type. Expected "time", "date", or "datetime".');
      }

      return formattedOutput;
    } catch (e) {
      print("${e.toString()}");
      return "no date mentioned";
    }
  }

  String formatDateStringforStartTime(String dateString, String type) {
    print(dateString + "//" + type);
    try {
      DateTime dateTime;

      // Check if the input is just time (e.g., "22:33" or "00:00:00")
      if (dateString.contains(":")) {
        // Ensure that the input string is formatted correctly
        if (dateString.split(':').length == 2) {
          // Time in format "HH:mm" (e.g., "22:33")
          dateTime = DateFormat("HH:mm").parse(dateString);
        } else if (dateString.split(':').length == 3) {
          // Time in format "HH:mm:ss" (e.g., "00:00:00")
          dateTime = DateFormat("HH:mm:ss").parse(dateString);
        } else {
          throw ArgumentError('Invalid time format.');
        }
      } else {
        // Assume the input is a full datetime string (e.g., "2025-01-17T22:33:00")
        dateTime = DateTime.parse(dateString);
      }

      String formattedOutput;

      if (type == 'time') {
        // Format time only in 12-hour format with AM/PM
        formattedOutput = DateFormat('hh:mm a').format(dateTime);
      } else if (type == 'date') {
        // Format date only
        formattedOutput = DateFormat('dd MMM, yyyy').format(dateTime);
      } else if (type == 'datetime') {
        // Format both date and time
        formattedOutput = DateFormat('hh:mm a, dd MMM, yyyy').format(dateTime);
      } else {
        throw ArgumentError(
            'Invalid type. Expected "time", "date", or "datetime".');
      }

      return formattedOutput;
    } catch (e) {
      print("${e.toString()}");
      return "no date mentioned";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: ColorPage.white),
        // toolbarHeight: 80,
        backgroundColor: ColorPage.appbarcolor,
        // leading: Image.asset(
        //   'assets/2.png',
        // ),
        title: Text(
          paperName,
          style: FontFamily.font5,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 100),
            child: Text(
              formatDateString(sheduletime, "date"),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              textScaler: TextScaler.linear(1.5),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Platform.isIOS ? 30 : 100, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  // Text(
                  //   '* Math Test',
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold, color: ColorPage.green),
                  //   textScaler: TextScaler.linear(1.5),
                  // )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width - 200,
                    child: Text(
                      'Please read the following instructions carefully ',
                      style: TextStyle(
                        // decoration: TextDecoration.underline,
                        decorationColor: ColorPage.appbarcolor,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaler: TextScaler.linear(1.4),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      // alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 200,
                      child: termAndCondition != ""
                          ? HtmlWidget(
                              termAndCondition.toString(),
                            )
                          : Text(
                              textAlign: TextAlign.justify,
                              'No instructions here!',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(color: ColorPage.grey)),
                              textScaler: TextScaler.linear(1.2),
                            ))
                ],
              ),
              SizedBox(
                height: 150,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Name : $paperName',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaler: TextScaler.linear(1.4),
                  ),
                  Text(
                    'Time : ${formatDateString(sheduletime, "time")}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaler: TextScaler.linear(1.4),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Type : Written Exam',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaler: TextScaler.linear(1.4),
                  ),
                  Text(
                    'Total Duration :$duration min',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaler: TextScaler.linear(1.4),
                  )
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Marks : 60',
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //      textScaler:TextScaler.linear(1.4),
              //     ),
              //   ],
              // ),

              //For Windows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => SizedBox(
                            // width: 100,
                            child: Checkbox(
                          // fillColor: MaterialStatePropertyAll(ColorPage.blue),
                          value: checkbox.value,
                          onChanged: (v) {
                            checkbox.value = !checkbox.value;
                          },
                        )),
                      ),
                      Container(
                          // width: 300,
                          child: Text(
                        'I have read the instructions carefully',
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (checkbox.value) {
                        var examcode = await getExamStatus(
                            context, getx.loginuserdata[0].token, paperId);
                        var decodedResponse = jsonDecode(examcode);
                        if (decodedResponse['statusCode'] == 200) {
                          Get.to(
                              transition: Transition.cupertino,
                              () => TheoryExamPage(
                                    documentPath: documnetPath,
                                    title: paperName,
                                    duration: duration,
                                    paperId: paperId,
                                    issubmit: true,
                                    isEncrypted: isEncrypted,
                                  ));
                        }
                        if (decodedResponse['statusCode'] == 250) {
                          Get.to(
                              transition: Transition.cupertino,
                              () => TheoryExamPage(
                                    documentPath: documnetPath,
                                    title: paperName,
                                    duration: duration,
                                    paperId: paperId,
                                    issubmit: false,
                                    isEncrypted: isEncrypted,
                                  ));
                        }
                        if (decodedResponse['statusCode'] == 300) {
                          _showDialogSubmited(context, "Already Submited!",
                              "your exam is already submited.", () {
                            Navigator.pop(context);
                          }, () {
                            if (getx.isInternet.value) {
                              Navigator.pop(context);
                              getTheryExamResultForIndividual(context,
                                      getx.loginuserdata[0].token, paperId)
                                  .then((value) {
                                print(value);

                                if (value.isEmpty) {
                                  _showDialogoferror(context, "Not publish!!",
                                      "The result is not published yet.", () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }, false);
                                } else {
                                  Get.to(
                                      transition: Transition.cupertino,
                                      () => TestResultPage(
                                            examName: value["TheoryExamName"],
                                            obtain: value[
                                                        'TotalReCheckedMarks'] !=
                                                    null
                                                ? double.parse(
                                                    value['TotalReCheckedMarks']
                                                        .toString())
                                                : double.parse(
                                                    value['TotalObtainMarks']
                                                        .toString()),
                                            resultPublishedOn: formatDateTime(
                                                value['ReportPublishDate']),
                                            studentName: getx.loginuserdata[0]
                                                    .firstName +
                                                " " +
                                                getx.loginuserdata[0].lastName,
                                            submitedOn: formatDateTime(
                                                value["SubmitedOn"]),
                                            totalMarks: double.parse(
                                                value['TotalMarks'].toString()),
                                            totalMarksRequired: double.parse(
                                                value['PassMarks'].toString()),
                                            theoryExamAnswerId: '12',
                                            examId: paperId,
                                            pdfurl: "no",
                                            questionanswersheet:
                                                decodedResponse['result'] ?? '',
                                          ));
                                }
                              });
                            } else {
                              _showDialogoferror(context, "Not internet!!",
                                  "No internet Connected.", () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }, false);
                            }
                          });
                        }
                        if (decodedResponse['statusCode'] == 400) {
                          _showDialogoferror(context, "Time is Over!",
                              "your exam is already ended.", () {
                            Navigator.pop(context);
                          }, false);
                        }
                      } else {
                        _onTermDeniey(context);
                      }
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
                        shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor:
                            WidgetStatePropertyAll(ColorPage.appbarcolorcopy)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _showDialogSubmited(
    context,
    String title,
    String desc,
    VoidCallback ontap,
    VoidCallback onsubmited,
  ) async {
    // Alert(
    //   context: context,
    //   onWillPopActive: false,
    //   type: AlertType.info,
    //   style: AlertStyle(
    //     isOverlayTapDismiss: false,
    //     animationType: AnimationType.fromTop,
    //     titleStyle:
    //         TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
    //     descStyle: FontFamily.font6,
    //     isCloseButton: false,
    //   ),
    //   title: title,
    //   desc: desc,
    //   buttons: [
    //      DialogButton(
    //       child:
    //           Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18)),
    //       highlightColor: Color.fromRGBO(3, 77, 59, 1),
    //       onPressed: ontap,
    //       color: ColorPage.red,
    //     ),
    //     DialogButton(
    //       child:
    //           Text("See result", style: TextStyle(color: Colors.white, fontSize: 18)),
    //       highlightColor: Color.fromRGBO(3, 77, 59, 1),
    //       onPressed: onsubmited,
    //       color: Color.fromRGBO(9, 89, 158, 1),
    //     ),
    //   ],
    // ).show();

    await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
            // denyButtonText: "Cancel",
            onDeny: ontap,
            title: title,
            text: desc,
            showCancelBtn: false,
            confirmButtonText: "Ok",
            onConfirm: onsubmited,
            confirmButtonColor: Colors.green,

            // onCancel: onCancelTap,
            type: ArtSweetAlertType.info));
  }

  _showDialogoferror(context, String title, String desc, VoidCallback ontap,
      bool iscancelbutton) async {
    // Alert(
    //   context: context,
    //   onWillPopActive: false,
    //   type: AlertType.info,
    //   style: AlertStyle(
    //     isOverlayTapDismiss: false,
    //     animationType: AnimationType.fromTop,
    //     titleStyle:
    //         TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
    //     descStyle: FontFamily.font6,
    //     isCloseButton: false,
    //   ),
    //   title: title,
    //   desc: desc,
    //   buttons: [
    //     DialogButton(
    //       child:
    //           Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
    //       highlightColor: Color.fromRGBO(3, 77, 59, 1),
    //       onPressed: ontap,
    //       color: Color.fromRGBO(9, 89, 158, 1),
    //     ),
    //   ],
    // ).show();
    await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
            // denyButtonText: "Cancel",
            title: title,
            text: desc,
            showCancelBtn: false,
            confirmButtonText: "Ok",
            onConfirm: ontap,
            confirmButtonColor: Colors.red,

            // onCancel: onCancelTap,
            type: ArtSweetAlertType.info));
  }

  _onTermDeniey(context) {
    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
        titleStyle:
            TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "Term Not Accepted !!",
      desc:
          "Please agree with our Term & condition of Exam. \n Fill the check box After reading the term & condition.  ",
      buttons: [
        DialogButton(
          child:
              Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromRGBO(3, 77, 59, 1),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }
}
