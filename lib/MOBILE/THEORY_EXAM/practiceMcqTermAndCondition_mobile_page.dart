import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/MOBILE/THEORY_EXAM/TheoryExamPageMobile.dart';
import 'package:dthlms/MOBILE/THEORY_EXAM/theory_exam_page_mobile.dart';
import 'package:dthlms/MOBILE/resultpage/test_result_mobile.dart';
import 'package:dthlms/PC/PROFILE/userProfilePage.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class TheoryExamTermAndConditionMobile extends StatelessWidget {
  final String paperName;
  final String termAndCondition;
  final String duration;
  final String sheduletime;
  final String documnetPath;
  final String paperId;

  bool windowsddevice = Platform.isWindows ? true : false;

  TheoryExamTermAndConditionMobile(
      {super.key,
      required this.documnetPath,
      required this.termAndCondition,
      required this.paperName,
      required this.duration,
      required this.sheduletime,
      required this.paperId});
  RxBool checkbox = false.obs;

  String formatDateString(String dateString, String type) {
    print(dateString + "////" + type);
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
      writeToFile(e, "formatDateString");
      print("${e.toString()}");
      return "no date found";
    }
  }

  double textScale = 1.2;

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
          style: FontFamily.styleb.copyWith(color: Colors.white),
        ),
        // actions: [

        // ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 80,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Platform.isAndroid ? 30 : 100, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          formatDateString(sheduletime, "date"),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          textScaler: TextScaler.linear(1.5),
                        ),
                      ],
                    ),
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
                            textScaler: TextScaler.linear(textScale),
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
                            width: MediaQuery.of(context).size.width - 120,
                            child: termAndCondition != ""
                                ? HtmlWidget(
                                    termAndCondition.toString(),
                                  )
                                : Text(
                                    textAlign: TextAlign.justify,
                                    'No instructions here!',
                                    // "sjdhfiuahidfh wef as df ww ef  wefaswdf awsdf a sdfawefas fwargyaw s fertfh dsfsfhsrfwsdha efgawhres fgawegaw gvaewrgawe rgweafg ef wef wa g awg er g serg ",
                                    style: GoogleFonts.poppins(
                                        textStyle:
                                            TextStyle(color: ColorPage.grey)),
                                    textScaler: TextScaler.linear(1.2),
                                  ))
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Name : $paperName',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaler: TextScaler.linear(1.2),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Time : ${formatDateString(sheduletime, "time")}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaler: TextScaler.linear(textScale),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Type : Written Exam',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaler: TextScaler.linear(textScale),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Total Duration :$duration min',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaler: TextScaler.linear(textScale),
                        ),
                      ],
                    )
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
                  ],
                ),

                //For Windows

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
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
                          Expanded(
                            child: Text(
                              'I have read the instructions carefully',
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (checkbox.value) {
                          var examcode = await getExamStatus(
                              context, getx.loginuserdata[0].token, paperId);
                          if (examcode == 200) {
                            Get.to(
                                transition: Transition.cupertino,
                                () => TheoryExamPageMobile(
                                      documentPath: documnetPath,
                                      title: paperName,
                                      duration: duration,
                                      paperId: paperId,
                                      issubmit: true,
                                    ));
                          }
                          if (examcode == 250) {
                            Get.to(
                                transition: Transition.cupertino,
                                () => TheoryExamPageMobile(
                                      documentPath: documnetPath,
                                      title: paperName,
                                      duration: duration,
                                      paperId: paperId,
                                      issubmit: true,
                                    ));
                          }
                          if (examcode == 300) {
                            _showDialogoferror(context, "Already Submited!",
                                "your exam is already submited.", () {
                              if (getx.isInternet.value) {
                                // Navigator.pop(context);
                                getTheryExamResultForIndividual(context,
                                        getx.loginuserdata[0].token, paperId)
                                    .then((value) {
                                  print(value);

                                  if (value.isEmpty) {
                                    _showDialogoferror(context, "Not publish!!",
                                        "The result is not published yet.", () {
                                      Navigator.pop(context);
                                    }, false);
                                  } else {
                                    Get.to(
                                        transition: Transition.cupertino,
                                        () => TestResultPageMobile(
                                              examName: value["TheoryExamName"],
                                              obtain: value[
                                                          'TotalReCheckedMarks'] !=
                                                      null
                                                  ? double.parse(value[
                                                          'TotalReCheckedMarks']
                                                      .toString())
                                                  : double.parse(
                                                      value['TotalObtainMarks']
                                                          .toString()),
                                              resultPublishedOn: formatDateTime(
                                                  value['ReportPublishDate']),
                                              studentName: getx.loginuserdata[0]
                                                      .firstName +
                                                  " " +
                                                  getx.loginuserdata[0]
                                                      .lastName,
                                              submitedOn: formatDateTime(
                                                  value["SubmitedOn"]),
                                              totalMarks: double.parse(
                                                  value['TotalMarks']
                                                      .toString()),
                                              totalMarksRequired: double.parse(
                                                  value['PassMarks']
                                                      .toString()),
                                              // theoryExamAnswerId: '12',
                                              examId: paperId,
                                              pdfUrl:
                                                  value['CheckedDocumentUrl']
                                                      .toString(),
                                              questionanswersheet:
                                                  examcode['result'] ?? '',
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
                            }, false);
                          }
                          if (examcode == 400) {
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
                          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40)),
                          shape: WidgetStatePropertyAll(
                              ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          backgroundColor: WidgetStatePropertyAll(
                              ColorPage.appbarcolorcopy)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialogoferror(context, String title, String desc, VoidCallback ontap,
      bool iscancelbutton) async {
    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        title: title,
        text: desc,
        confirmButtonText: "ok",
        type: ArtSweetAlertType.info,
      ),
    );

    if (response == null) {
      return;
    }

    if (response.isTapConfirmButton) {
      ontap();

      return;
    }
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
