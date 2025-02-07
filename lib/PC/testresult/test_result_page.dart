import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/MOBILE/resultpage/test_result_mobile.dart';
import 'package:dthlms/PC/testresult/indicator.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';
// import 'package:dthlms/constants/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../CUSTOMDIALOG/customdialog.dart';
import '../../globalfunction/downloadsheet.dart';

class TestResultPage extends StatefulWidget {
  final String studentName;
  final String examName;
  final String submitedOn;
  final String resultPublishedOn;
  final double totalMarks;
  final double obtain;
  final double totalMarksRequired;
  final String theoryExamAnswerId;
  final String examId;

  final String pdfurl;
  String? questionanswersheet = '';

  TestResultPage(
      {super.key,
      required this.pdfurl,
      required this.studentName,
      required this.examName,
      required this.submitedOn,
      required this.resultPublishedOn,
      required this.totalMarks,
      required this.obtain,
      required this.totalMarksRequired,
      required this.theoryExamAnswerId,
      required this.examId,
      required this.questionanswersheet});

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {
  int touchedIndex = -1;
  // RxBool isDownloading = false.obs;
  // CancelToken cancelToken = CancelToken();
  String downloadedFilePath = '';

//  TextStyle _textStyle = TextStyle(fontSize: 25);
  TextStyle headerStyle = TextStyle(color: Colors.blue, fontSize: 20);
  TextStyle studentTitleStyle = TextStyle(fontSize: 20, color: Colors.black);
  TextStyle studentNameStyle = TextStyle(fontSize: 20, color: Colors.blue);

  Getx getx = Get.find<Getx>();

  Future<String?> getSavePath() async {
    // Open a file picker dialog
    String? result = await FilePicker.platform.saveFile(
      dialogTitle: "Save Answer Sheet",
      fileName: "answer_sheet.pdf", // default file name
    );

    if (result != null) {
      return result; // Return the file path selected by the user
    }
    return null; // Return null if the user cancels the file picker
  }

  // Future<void> downloadAnswerSheet(String url, String examId,
  //     {String examName = ""}) async {
  //   Dio dio = Dio();
  //   Directory appDocDir = await getApplicationDocumentsDirectory();

  //   Directory dthLmsDir = Directory('${appDocDir.path}\\$origin');
  //   if (!await dthLmsDir.exists()) {
  //     await dthLmsDir.create(recursive: true);
  //   }

  //   var prefs = await SharedPreferences.getInstance();
  //   getx.defaultPathForDownloadFile.value = dthLmsDir.path;
  //   prefs.setString("DefaultDownloadpathOfFile", dthLmsDir.path);
  //   String? filePath = getx.userSelectedPathForDownloadFile.value.isEmpty
  //       ? '${dthLmsDir.path}\\$examId $examName'
  //       : getx.userSelectedPathForDownloadFile.value + "\\$examId $examName";
  //   if (filePath == null) {
  //     debugPrint("No file path selected. Cancelling download.");
  //     return;
  //   }

  //   try {
  //     isDownloading.value = true;

  //     await dio.download(
  //       url.replaceAll('"', ''),
  //       filePath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           downloadProgress = received / total;
  //         }
  //       },
  //       cancelToken: cancelToken,
  //     );

  //     isDownloading.value = false;
  //     debugPrint("Download complete: $filePath");

  //     showDownloadCompleteDialog(examName);
  //   } catch (e) {
  //     isDownloading.value = false;
  //     debugPrint("Error downloading file: $e");
  //     // showErrorDialog("Download Failed", "An error occurred while downloading the file.");
  //   }
  // }

  // void cancelDownload() {
  //   cancelToken.cancel();
  //   setState(() {
  //     isDownloading.value = false;
  //   });
  // }

  // void showDownloadCompleteDialog(String examName) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text("Download Complete"),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Text("The answer sheet has been downloaded."),
  //           SizedBox(height: 10),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Navigator.of(context).pop();
  //               Get.off(() => ShowResultPage(
  //                     filePath: getx
  //                             .userSelectedPathForDownloadFile.value.isEmpty
  //                         ? '${getx.defaultPathForDownloadFile.value}\\${widget.examId} $examName'
  //                         : getx.userSelectedPathForDownloadFile.value +
  //                             "/${widget.examId} $examName",
  //                     // filePath: downloadedFilePath,
  //                     isnet: false,
  //                   ));
  //               // showPdfDialog(downloadedFilePath);
  //             },
  //             child: Text("Show Sheet"),
  //           ),
  //         ],
  //       ),
  //       actions: <Widget>[
  //         TextButton(
  //           child: Text("Close"),
  //           onPressed: () => Navigator.of(context).pop(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Show the PDF in a dialog using spfpdfviewer
  void showPdfDialog(String filePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.9,
          child: SfPdfViewer.file(
              File(filePath)), // Using spfpdfviewer to display PDF
        ),
      ),
    );
  }

  void recheckAnswerSheetAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Recheck Answer Sheet',
          description:
              'Are you sure you want to submit the answer sheet for rechecking?',
          OnCancell: () {
            Navigator.of(context).pop();
          },
          OnConfirm: () {
            // Navigator.of(context).pop();
            requestForRecheckAnswerSheet(
                    context, getx.loginuserdata[0].token, widget.examId, '')
                .then((value) {
              if (value) {
                onActionDialogBox("Requested", "Request send Successfully!",
                    () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }, context, true);
              } else {
                onActionDialogBox("Request Failed!!", "", () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }, context, false);
              }
            });
            // recheckAnswerSheetRequest(context,getx.loginuserdata[0].token,widget.theoryExamAnswerId);
          },
          btn1: 'Cancel',
          btn2: 'Submit',
          linkText: 'Learn more about rechecking',
        );
      },
    );
  }

  void DownloadAnswerSheetAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Download Answer Sheet',
          description:
              'Are you sure you want to download your answer sheet? Please note that downloading may require a stable internet connection.',
          OnCancell: () {
            Navigator.of(context).pop();
          },
          OnConfirm: () {
            Navigator.of(context).pop();
            // Add logic for downloading the answer sheet
          },
          btn1: 'Cancel',
          btn2: 'Download',
          linkText: 'Learn more about downloading',
        );
      },
    );
  }

  void DownloadQuestionPaperAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Download Question Paper',
          description:
              'Are you sure you want to download the question paper? Please note that downloading may require a stable internet connection.',
          OnCancell: () {
            Navigator.of(context).pop();
          },
          OnConfirm: () {
            Navigator.of(context).pop();
            // Add logic for downloading the question paper
          },
          btn1: 'Cancel',
          btn2: 'Download',
          linkText: 'Learn more about question papers',
        );
      },
    );
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter =
        DateFormat('d MMM yyyy'); // "17 Jul 2023" format
    return formatter.format(dateTime);
  }

  String pass = '';
  bool isPass = false;

  @override
  void initState() {
    checkIfPass();
    super.initState();
  }

  checkIfPass() {
    if (widget.obtain >= widget.totalMarksRequired) {
      pass = "Pass";
      isPass = true;
    } else {
      isPass = false;
      pass = "Fail";
    }
  }

  Downloadsheet downloadsheet = Downloadsheet();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEEE),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Result',
          style: FontFamily.styleb.copyWith(fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 600,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  //  SizedBox(
                                  //    height: 80,
                                  //    width: 80,
                                  //    child: Image(image: AssetImage('assets/person.png')),
                                  //  ),
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.blue,
                                        child: Text(
                                          widget.studentName[0].toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 80,
                                  )
                                ],
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person_outline_rounded,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Basic Info',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: 'Name: ',
                                                  style: studentTitleStyle),
                                              TextSpan(
                                                  text: widget.studentName,
                                                  style: studentNameStyle),
                                            ]),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: 'Exam Name: ',
                                                  style: studentTitleStyle),
                                              TextSpan(
                                                  text: widget.examName,
                                                  style: studentNameStyle),
                                            ]),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: 'Submitted on: ',
                                                  style: studentTitleStyle),
                                              TextSpan(
                                                  text: widget.submitedOn,
                                                  style: studentNameStyle),
                                            ]),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: 'Result published on: ',
                                                  style: studentTitleStyle),
                                              TextSpan(
                                                  text:
                                                      widget.resultPublishedOn,
                                                  style: studentNameStyle),
                                            ]),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 30,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        width: 400,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback:
                                        (FlTouchEvent event, pieTouchResponse) {
                                      setState(() {
                                        if (!event
                                                .isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection ==
                                                null) {
                                          touchedIndex = -1;
                                          return;
                                        }
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  sections: showingSections(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Indicator(
                                  color: AppColors.contentColorYellow,
                                  text: 'Obtain Marks',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Indicator(
                                  color: AppColors.contentColorBlue,
                                  text: 'emaining Marks',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 240,
                    width: 1000,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            columns: <DataColumn>[
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Paper Name',
                                    style: headerStyle,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Date',
                                    style: headerStyle,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Total Marks',
                                    style: headerStyle,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Obtain Marks',
                                    style: headerStyle,
                                  ),
                                ),
                              ),
                            ],
                            rows: <DataRow>[
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(widget.examName)),
                                  DataCell(Text(widget.submitedOn)),
                                  DataCell(Text(widget.totalMarks.toString())),
                                  DataCell(Text(widget.obtain.toString())),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: 20), // Space between the table and the row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Total Marks Required: ',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                                TextSpan(
                                    text: widget.totalMarksRequired.toString(),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blue)),
                              ]),
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Total Marks Obtain: ',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                                TextSpan(
                                    text: widget.obtain.toString(),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blue)),
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Status: ',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black)),
                                TextSpan(
                                    text: pass,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: isPass
                                            ? Colors.green
                                            : Colors.amber))
                              ]),
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 15)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        Colors.amber[700])),
                                onPressed: () {
                                  recheckAnswerSheetAlert();
                                },
                                child: Text(
                                  'Recheck Answersheet',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ]),
                SizedBox(height: 150),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton(
                        //     style: ButtonStyle(
                        //         padding: WidgetStatePropertyAll(
                        //             EdgeInsets.symmetric(
                        //                 vertical: 15, horizontal: 15)),
                        //         backgroundColor:
                        //             WidgetStatePropertyAll(Colors.blueGrey)),
                        //     onPressed: () {
                        //       DownloadQuestionPaperAlert();
                        //     },
                        //     child: Text(
                        //       'Download Question Paper',
                        //       style: TextStyle(color: Colors.white),
                        //     )),
                        // SizedBox(
                        //   width: 30,
                        // ),
                        widget.pdfurl != ''
                            ? ElevatedButton(
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 15)),
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.blue)),
                                onPressed: downloadsheet
                                        .getx.isDownloading.value
                                    ? null
                                    : () async {
                                        if (File(getx
                                                    .userSelectedPathForDownloadFile
                                                    .value
                                                    .isEmpty
                                                ? '${getx.defaultPathForDownloadFile.value}\\${widget.examId} '
                                                : getx.userSelectedPathForDownloadFile
                                                        .value +
                                                    "\\${widget.examId} ")
                                            .existsSync()) {
                                          Get.to(() => ShowResultPage(
                                                filePath: getx
                                                        .userSelectedPathForDownloadFile
                                                        .value
                                                        .isEmpty
                                                    ? '${getx.defaultPathForDownloadFile.value}\\${widget.examId} '
                                                    : getx.userSelectedPathForDownloadFile
                                                            .value +
                                                        "\\${widget.examId} ",
                                                isnet: false,
                                              ));
                                        } else {
                                          if (widget.pdfurl.isNotEmpty) {
                                            downloadsheet.downloadAnswerSheet(
                                                widget.pdfurl, widget.examId,
                                                context: context);
                                          }
                                        }
                                      },
                                // DownloadAnswerSheetAlert();

                                child: Text(
                                  File(getx.userSelectedPathForDownloadFile
                                                  .value.isEmpty
                                              ? '${getx.defaultPathForDownloadFile}\\${widget.examId} '
                                              : getx.userSelectedPathForDownloadFile
                                                      .value +
                                                  "\\${widget.examId} ")
                                          .existsSync()
                                      ? "Show Answer Sheet"
                                      : 'Download Answer Sheet',
                                  style: TextStyle(color: Colors.white),
                                ))
                            : SizedBox(),
                      ],
                    ),
                    if (downloadsheet.getx.isDownloading.value)
                      Column(
                        children: [
                          LinearProgressIndicator(
                              value: downloadsheet.downloadProgress),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: downloadsheet.cancelDownload,
                            child: Text("Cancel Download"),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    widget.questionanswersheet != ''
                        ? ElevatedButton(
                            style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10)),
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.blue)),
                            onPressed: downloadsheet.getx.isDownloading.value
                                ? null
                                : () async {
                                    if (File(getx
                                                .userSelectedPathForDownloadFile
                                                .value
                                                .isEmpty
                                            ? '${getx.defaultPathForDownloadFile.value}\\${widget.examId} ${widget.examName}'
                                            : getx.userSelectedPathForDownloadFile
                                                    .value +
                                                "\\${widget.examId} ${widget.examName}")
                                        .existsSync()) {
                                      Get.to(() => ShowResultPage(
                                            filePath: getx
                                                    .userSelectedPathForDownloadFile
                                                    .value
                                                    .isEmpty
                                                ? '${getx.defaultPathForDownloadFile.value}\\${widget.examId} ${widget.examName}'
                                                : getx.userSelectedPathForDownloadFile
                                                        .value +
                                                    "\\${widget.examId} ${widget.examName}",
                                            isnet: false,
                                          ));
                                    } else {
                                      if (widget.questionanswersheet
                                          .toString()
                                          .isNotEmpty) {
                                        print(widget.questionanswersheet
                                            .toString());
                                        downloadsheet.downloadAnswerSheet(
                                            widget.questionanswersheet
                                                .toString(),
                                            widget.examId,
                                            examName: widget.examName,
                                            context: context);
                                      }
                                    }

                                    // showDownloadCompleteDialog();
                                    // await  getAnswerSheetURLforStudent(context,getx.loginuserdata[0].token,widget.examId).then((answerUrl){
                                    //   print(answerUrl);
                                    //   print(answerUrl);

                                    // });
                                  },
                            child: Text(
                              File(getx.userSelectedPathForDownloadFile.value
                                              .isEmpty
                                          ? '${getx.defaultPathForDownloadFile.value}\\${widget.examId} ${widget.examName}'
                                          : getx.userSelectedPathForDownloadFile
                                                  .value +
                                              "\\${widget.examId} ${widget.examName}")
                                      .existsSync()
                                  ? "Show Question Sample Sheet"
                                  : 'Download Question Sample Sheet',
                              style: TextStyle(color: Colors.white),
                            ))
                        : SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            // Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            width: 170,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0xff5DF9E8),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Go Back',
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double remainingMarks = widget.totalMarks - widget.obtain;

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: remainingMarks,
            title: remainingMarks.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.contentColorYellow,
            value: widget.obtain,
            title: widget.obtain.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );

        default:
          throw Error();
      }
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

onActionDialogBox(
    String title, String subtitle, VoidCallback ontap, context, bool type) {
  Alert(
    context: context,
    type: type ? AlertType.success : AlertType.warning,
    style: AlertStyle(
      titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      descStyle: FontFamily.font6,
      isCloseButton: false,
    ),
    title: title,
    desc: subtitle,
    buttons: [
      DialogButton(
        child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
        highlightColor: ColorPage.blue,
        onPressed: ontap,
        color: type ? Colors.green : const Color.fromARGB(255, 207, 43, 43),
      ),
    ],
  ).show();
}
