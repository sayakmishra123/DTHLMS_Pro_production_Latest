import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/MOBILE/resultpage/test_result_mobile.dart';
import 'package:dthlms/PC/MCQ/PRACTICE/termandcondition.dart';
import 'package:dthlms/PC/PROFILE/userProfilePage.dart';
import 'package:dthlms/PC/testresult/test_result_page.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../LOCAL_DATABASE/dbfunction/dbfunction.dart';

class TheoryExamPapes extends StatefulWidget {
  final Map paperNames ;
  final RxList mcqSetList;
  final bool istype;
  TheoryExamPapes(this.paperNames, this.mcqSetList, this.istype, {super.key});

  @override
  State<TheoryExamPapes> createState() => _TheoryExamPapesState();
}

class _TheoryExamPapesState extends State<TheoryExamPapes> {


  RxList theoryPaperList = [].obs;

  @override
  void initState() {
    getData();

    super.initState();
  }

  getData() async { 
    theoryPaperList.clear();
    theoryPaperList.value = 
        await fetchTheoryPapertList(widget.paperNames['SetId']);
  }
  bool _isExamExpired(String? endDateString) {
  if (endDateString == null || endDateString.isEmpty) {
    return false; // Treat missing dates as non-expired
  }

  try {
    // Parse the date from string
    DateTime endDate = DateTime.parse(endDateString);

    // Compare with the current date
    return endDate.isBefore(DateTime.now());
  } catch (e) {
    print("Error parsing date: $e");
    return false; // If parsing fails, assume it's not expired
  }
}
String _formatDuration(dynamic duration) {
  if (duration == null) return "Unknown Duration";

  int totalMinutes;

  // Ensure duration is an integer
  try {
    totalMinutes = int.parse(duration.toString());
  } catch (e) {
    print("Invalid duration format: $duration");
    return "Unknown Duration";
  }

  int hours = totalMinutes ~/ 60; // Get hours
  int minutes = totalMinutes % 60; // Get remaining minutes

  // Build duration string dynamically
  if (hours > 0 && minutes > 0) {
    return "$hours hours $minutes minutes";
  } else if (hours > 0) {
    return "$hours hours";
  } else {
    return "$minutes minutes";
  }
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
        title: Text(
          'Theory Papers', 
          style: FontFamily.styleb,
        ),
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
                              context,
                              getx.loginuserdata[0].token,
                              theoryPaperList[index]['PaperId'].toString());
                             var decodedResponse = jsonDecode(examcode);
                          if (decodedResponse['statusCode'] == 200) {
                            log('hello');
                            Get.to(
                                transition: Transition.cupertino,
                                () => TheoryExamTermAndCondition(
                                      termAndCondition: theoryPaperList[index]
                                              ['TermAndCondition']
                                          .toString(),
                                      documnetPath: theoryPaperList[index]
                                              ['DocumentUrl']
                                          .toString(),
                                      duration: theoryPaperList[index]
                                              ['Duration']
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
                          if (decodedResponse['statusCode'] == 250) {
                            Get.to(
                                transition: Transition.cupertino,
                                () => TheoryExamTermAndCondition(
                                      termAndCondition: theoryPaperList[index]
                                              ['TermAndCondition']
                                          .toString(),
                                      documnetPath: theoryPaperList[index]
                                              ['DocumentUrl']
                                          .toString(),
                                      duration: theoryPaperList[index]
                                              ['Duration']
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
                          if (decodedResponse['statusCode'] == 300) { 
                            if (getx.isInternet.value) { 
                                    getTheryExamResultForIndividual(
                                      context,
                                      getx.loginuserdata[0].token,
                                      theoryPaperList[index]['PaperId']
                                          .toString())
                                  .then((value) {
                                print(value);

                                if (value.isEmpty) { 
                                 _showDialogoferror(
                                        context,
                                        "Not publish!!",
                                        "The result is not published yet.",
                                        () {},
                                        false,
                                        answersheet: decodedResponse['result'],
                                        paperid: theoryPaperList[index]
                                                ['PaperId']
                                            .toString());
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
                                            examId: theoryPaperList[index]
                                                    ['PaperId']
                                                .toString(),
                                            pdfurl: value['CheckedDocumentUrl']
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
                            // _showDialogSubmited(context, "Already Submited!",
                            //     "your exam is already submited.", () {
                            //   Navigator.pop(context);
                            // }, () {
                            // });
                          }
                          if (decodedResponse['statusCode'] == 400) {
                            _showDialogoferror(context, "Time is Over!",
                                "your exam is already ended.", () {
                              // Navigator.pop(context);
                            }, false);
                          }
                        } else {
                          _onNoInternetConnection(context);
                        }
                      },
                      child: Container(
                        width: itemWidth,
                         
                        child: Card(
                         elevation: 20,
                         shadowColor: _isExamExpired(theoryPaperList[index]['PaperEndDate'])
    ? Colors.red
    : Colors.green,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, 
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image(image: AssetImage('assets/myexam.png'),),
                                      )
                                          
                                    ),
                                     _isExamExpired(theoryPaperList[index]['PaperEndDate']) ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  
                                ),
                                child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                                child: Text('Expired',style: TextStyle(color: Colors.white),),
                              )) : SizedBox()
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  theoryPaperList[index]['PaperName'] ??
                                      'Unnamed Paper',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Start Exam: ${formatDateWithOrdinal(theoryPaperList[index]['PaperStartDate'])}",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  "End Exam: ${formatDateWithOrdinal(theoryPaperList[index]['PaperEndDate'])}",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                                    child: Text(
"Duration: ${_formatDuration(theoryPaperList[index]['Duration'])}",
                                      style: TextStyle(
                                        color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
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
    void showDownloadCompleteDialog(filePath) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Download Complete"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("The answer sheet has been downloaded."),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Get.off(() => ShowResultPage(
                      filePath: filePath,
                      isnet: false,
                    ));
                // showPdfDialog(downloadedFilePath);
              },
              child: Text("Show Sheet"),
            ),
          ],
        ),
        // actions: <Widget>[
        //   TextButton(
        //     child: Text("Close"),
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),
        // ],
      ),
    );
  }
    RxBool isDownloading = false.obs;
  CancelToken cancelToken = CancelToken();
  String downloadedFilePath = '';
  double downloadProgress = 0.0;
  Future<void> testDioDowwnload(path) async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    Dio dio = Dio();
    String testUrl = path.toString().replaceAll('"', '');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath =
        '${appDocDir.path}/test_download.pdf'; // Test download path

    try {
      await dio.download(testUrl, filePath);
      debugPrint("Download complete: $filePath");
      Get.back();
      showDownloadCompleteDialog(filePath);
    } catch (e) {
      Get.back();
      debugPrint("Error downloading file: $e");
    }
  }

  _showDialogoferror(context, String title, String desc, VoidCallback ontap,
      bool iscancelbutton,
      {String answersheet = "", String paperid = ""}) async {
    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        customColumns: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 15, horizontal: 15)),
                    backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                onPressed: isDownloading.value
                    ? null
                    : () async {
                        Get.back();
                        if (File(getx
                                    .userSelectedPathForDownloadFile.value.isEmpty
                                ? '${getx.defaultPathForDownloadFile.value}\\${paperid}'
                                : getx.userSelectedPathForDownloadFile.value +
                                    "\\${paperid}")
                            .existsSync()) {
                          Get.to(() => ShowResultPage(
                                filePath: getx.userSelectedPathForDownloadFile
                                        .value.isEmpty
                                    ? '${getx.defaultPathForDownloadFile.value}\\${paperid}'
                                    : getx.userSelectedPathForDownloadFile.value +
                                        "\\${paperid}",
                                isnet: false,
                              ));
                        } else {
                          if (answersheet.isNotEmpty) {
                            testDioDowwnload(answersheet);
                            // downloadAnswerSheet(answersheet, paperid);
                          }
                        }
                      },
                // DownloadAnswerSheetAlert();
            
                child: Text(
                  File(getx.userSelectedPathForDownloadFile.value.isEmpty
                              ? '${getx.defaultPathForDownloadFile}\\${paperid}'
                              : getx.userSelectedPathForDownloadFile.value +
                                  "\\${paperid}")
                          .existsSync()
                      ? "Show Answer Sheet"
                      : 'Download Answer Sheet',
                  style: TextStyle(color: Colors.white),
                )),
          ), 

          // ElevatedButton(
          //     style: ButtonStyle(
          //         padding: WidgetStatePropertyAll(
          //             EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
          //         backgroundColor: WidgetStatePropertyAll(Colors.blue)),
          //     onPressed: () {
          //       Get.to(() => ShowResultPage(
          //             filePath: answersheet,
          //             isnet: true,
          //           ));
          //     },
          //     child: Text(
          //       'Download Answer Sheet',
          //       style: TextStyle(color: Colors.white),
          //     ))
        ],
        title: title,
        text: desc,
        confirmButtonText: "ok",
        type: ArtSweetAlertType.info,
        // denyButtonColor: Colors.green,
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
