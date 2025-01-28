import 'dart:developer';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/PC/MCQ/PRACTICE/termandcondition.dart';
import 'package:dthlms/PC/PROFILE/userProfilePage.dart';
import 'package:dthlms/PC/testresult/test_result_page.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../LOCAL_DATABASE/dbfunction/dbfunction.dart';
// import 'MOCKTEST/resultmocktest.dart';
// import 'MOCKTEST/termandcondition.dart'; 

class TheoryExamPapes extends StatefulWidget {
  Map paperNames = {};
  RxList mcqSetList;
  bool istype;
  TheoryExamPapes(this.paperNames, this.mcqSetList, this.istype, {super.key});

  @override
  State<TheoryExamPapes> createState() => _TheoryExamPapesState();
}

class _TheoryExamPapesState extends State<TheoryExamPapes> {
  RxList filteredList = [].obs;

  RxList theoryPaperList = [].obs;

  @override
  void initState() {
    getData();

    super.initState();
  }

  getData() async {
    // log(widget.paperNames['ServicesTypeName'] + "kjhukhu");
    theoryPaperList.clear();
    theoryPaperList.value = 
        await fetchTheoryPapertList(widget.paperNames['SetId']);
    // log(theoryPaperList.toString() + " type");
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine the number of items per row based on screen width
    int itemsPerRow = 2; // Default for small screens (phones)
    if (screenWidth > 600) {
      itemsPerRow = 3; // Medium screens (small tablets)
    }
    if (screenWidth > 1200) {
      itemsPerRow = 6; // Large screens (tablets or desktops) set to 6
    }

    // Calculate the width for each item in the row
    double itemWidth = (screenWidth - 20) / itemsPerRow; // 20 is for padding

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: Text('Theory Papers', style: FontFamily.styleb,),
      ),
      body: Obx(
        () => theoryPaperList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  spacing: 10, // Horizontal space between items
                  runSpacing: 10, // Vertical space between rows
                  children: List.generate(theoryPaperList.length, (index) {
                    return InkWell(
                      onTap: () async {
                        if (getx.isInternet.value) {

                          
                        var examcode = await getExamStatus(
                            context, getx.loginuserdata[0].token, theoryPaperList[index]['PaperId']
                                        .toString());
                        if (examcode == 200) {
                          Get.to(
                              transition: Transition.cupertino,
                              () => TheoryExamTermAndCondition(
                                    termAndCondition: theoryPaperList[index]
                                            ['TermAndCondition']
                                        .toString(),
                                    documnetPath: theoryPaperList[index] 
                                            ['DocumentUrl'] 
                                        .toString(),
                                        
                                    duration: theoryPaperList[index]['Duration']
                                        .toString(),
                                    paperName: theoryPaperList[index]
                                            ['PaperName']
                                        .toString(),
                                    sheduletime: theoryPaperList[index]
                                            ['StartTime']
                                        .toString(),
                                    paperId: theoryPaperList[index]['PaperId']
                                        .toString(), 
                                        isEncrypted: false,
                                  ));
                        }
                        if (examcode == 250) {
                          Get.to(
                              transition: Transition.cupertino,
                              () =>  TheoryExamTermAndCondition(
                                    termAndCondition: theoryPaperList[index]
                                            ['TermAndCondition']
                                        .toString(),
                                    documnetPath: theoryPaperList[index] 
                                            ['DocumentUrl'] 
                                        .toString(),
                                        
                                    duration: theoryPaperList[index]['Duration']
                                        .toString(),
                                    paperName: theoryPaperList[index]
                                            ['PaperName']
                                        .toString(),
                                    sheduletime: theoryPaperList[index]
                                            ['StartTime']
                                        .toString(),
                                    paperId: theoryPaperList[index]['PaperId']
                                        .toString(), 
                                        isEncrypted: false,
                                  ));
                        }
                        if (examcode == 300) {
                          _showDialogSubmited(context, "Already Submited!",
                              "your exam is already submited.", () {
                            Navigator.pop(context);
                          }, () {
                            if (getx.isInternet.value) {
                              Navigator.pop(context);
                              getTheryExamResultForIndividual(context,
                                      getx.loginuserdata[0].token, theoryPaperList[index]['PaperId']
                                        .toString())
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
                                            examId: theoryPaperList[index]['PaperId']
                                        .toString(),
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
                        if (examcode == 400) {
                          _showDialogoferror(context, "Time is Over!",
                              "your exam is already ended.", () {
                            Navigator.pop(context);
                          }, false);
                        }






















                          // Get.to(
                          //     transition: Transition.cupertino,
                          //     () => TheoryExamTermAndCondition(
                          //           termAndCondition: theoryPaperList[index]
                          //                   ['TermAndCondition']
                          //               .toString(),
                          //           documnetPath: theoryPaperList[index] 
                          //                   ['DocumentUrl'] 
                          //               .toString(),
                                        
                          //           duration: theoryPaperList[index]['Duration']
                          //               .toString(),
                          //           paperName: theoryPaperList[index]
                          //                   ['PaperName']
                          //               .toString(),
                          //           sheduletime: theoryPaperList[index]
                          //                   ['StartTime']
                          //               .toString(),
                          //           paperId: theoryPaperList[index]['PaperId']
                          //               .toString(), 
                          //               isEncrypted: false,
                          //         ));
                        } else {
                          _onNoInternetConnection(context);
                        }
                      },
                      child: Container(
                        width: itemWidth,
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('assets/mcq_set.png'),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  theoryPaperList[index]['PaperName'] ??
                                      'Unnamed Paper',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Start Exam: ${formatDateWithOrdinal(theoryPaperList[index]['PaperStartDate'])}",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  "End Exam: ${formatDateWithOrdinal(theoryPaperList[index]['PaperEndDate'])}",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  "Duration: ${theoryPaperList[index]['Duration']} min",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              )
            : Center(
                child: Text(
                  "No Papers Available",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
      ),
    );
  }

  _onNoInternetConnection(context) async {
    // Alert(
    //   context: context,
    //   type: AlertType.error,
    //   style: AlertStyle(
    //     titleStyle: TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
    //     descStyle: FontFamily.font6,
    //     isCloseButton: false,
    //   ),
    //   title: "!! No internet!!",
    //   desc: "Make sure you have a proper internet Connection.  ",
    //   buttons: [
    //     DialogButton(
    //       child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
    //       highlightColor: Color.fromRGBO(3, 77, 59, 1),
    //       onPressed: () {
    //       Get.back();
    //       },
    //       color: Color.fromRGBO(9, 89, 158, 1),
    //     ),
    //   ],
    // ).show();
    await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
            // denyButtonText: "Cancel",
            title: '!! No internet!!',
            text: "Make sure you have a proper internet Connection.  ",
            // showCancelBtn: false,
            confirmButtonText: "Ok",
            onConfirm: () {
              Get.back();
            },
            confirmButtonColor: Colors.red,

            // onCancel: onCancelTap,
            type: ArtSweetAlertType.danger));
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
}

