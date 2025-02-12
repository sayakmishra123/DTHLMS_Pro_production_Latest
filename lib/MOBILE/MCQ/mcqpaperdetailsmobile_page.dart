import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/MOBILE/MCQ/mcqCondition.dart';
import 'package:dthlms/MOBILE/MCQ/McqTestRank.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../LOCAL_DATABASE/dbfunction/dbfunction.dart';

class McqPaperDetailsMobile extends StatefulWidget {
  final Map paperNames;
  final RxList mcqSetList;
  final bool istype;
  McqPaperDetailsMobile(this.paperNames, this.mcqSetList, this.istype,
      {super.key});

  @override
  State<McqPaperDetailsMobile> createState() => _McqPaperDetailsMobileState();
}

class _McqPaperDetailsMobileState extends State<McqPaperDetailsMobile> {
  RxList filteredList = [].obs;

  RxList mcqPaperList = [].obs;



  @override
  void initState() {
    getData();
    super.initState();
  }



  getData() async {
    mcqPaperList.clear();
    mcqPaperList.value = await fetchMCQPapertList(widget.paperNames['SetId']);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double itemWidth = (screenWidth - 20);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: Text('MCQ Papers',
            style: FontFamily.styleb.copyWith(color: Colors.blueGrey)),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => mcqPaperList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Column(
                      //     children: [
                      //       Row( 
                      //         children: [
                      //           Text('Exams Compleated',
                      //               style: FontFamily.styleb
                      //                   .copyWith(color: Colors.grey)),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: 5,
                      //       ),
                      //       FAProgressBar(
                      //         animatedDuration: Duration(milliseconds: 1000),
                      //         currentValue:
                      //             ((mcqPaperList.length - submitedExamsCount) /
                      //                     mcqPaperList.length) *
                      //                 100, // Calculate percentage
                      //         displayText: '%',
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Wrap(
                        spacing: 10, // Horizontal space between items
                        runSpacing: 10, // Vertical space between rows
                        children: List.generate(mcqPaperList.length, (index) {
                          return InkWell(
                            onTap: () async {
                              if (getx.isInternet.value) {
                                fetchTblMCQHistory("").then((mcqhistoryList) {
                                  unUploadedMcQHistoryInfoInsert(
                                      context,
                                      mcqhistoryList,
                                      getx.loginuserdata[0].token);
                                });
                              }

                              if (widget.istype) {
                                await checkMCQRankStatus(
                                        context,
                                        getx.loginuserdata[0].token,
                                        mcqPaperList[index]['PaperId']
                                            .toString())
                                    .then((checking) {
                                  if (checking.isNotEmpty) {
                                    if (checking['StatusCode'] == 220) {
                                      print(checking['UserAnswerList']
                                              .toString() +
                                          "///////////////////////");

                                      Get.to(
                                        transition: Transition.cupertino,
                                        () => McqTermAndConditionmobile(
                                            termAndCondition: mcqPaperList[index]
                                                ['TermAndCondition'],
                                            paperName: mcqPaperList[index]
                                                ['PaperName'],
                                            startTime: mcqPaperList[index]
                                                ['MCQStartTime'],
                                            startDate: mcqPaperList[index]
                                                ['MCQPaperStartDate'],
                                            totalMarks: mcqPaperList[index]
                                                ['TotalMarks'],
                                            duration:
                                                checking['RemainingTimeInSeconds']
                                                    .toString(),
                                            paperId: mcqPaperList[index]
                                                ['PaperId'],
                                            type: widget
                                                .paperNames['ServicesTypeName'],
                                            url: "",
                                            isAnswerSheetShow: mcqPaperList[index][
                                                            'IsAnswerSheetShow']
                                                        .toString() ==
                                                    "true"
                                                ? true
                                                : false,
                                            endDate: mcqPaperList[index]
                                                ['MCQPaperEndDate'],
                                            userAnswer:
                                                checking['UserAnswerList']),
                                      );
                                    } else if (checking['StatusCode'] == 400) {
                                      _onAlredySubmited(context, "Submited!!",
                                          "Your exam is already Submited, Please wait for result",
                                          () async {
                                        Get.back();
                                        //
                                      }, () {
                                        Get.back();
                                      });
                                    } else if (checking['StatusCode'] == 440) {
                                      _onAlredySubmited(context, "Submited!!",
                                          "Your exam is already Submited, Check Your result",
                                          () async {
                                        List resultdata =
                                            await getMCQRankresultForIndividual(
                                                context,
                                                getx.loginuserdata[0].token,
                                                mcqPaperList[index]['PaperId']
                                                    .toString());
                                        //  checkMCQRankStatus(context,getx.loginuserdata[0].token,mcqPaperList[index]['PaperId'].toString());

                                        // getMCQRankresultForIndividual(context,getx.loginuserdata[0].token, mcqPaperList[index]['PaperId'].toString());
                                        Get.back();

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RankPage(
                                                frompaper: true,
                                                isMcq: true,
                                                type: "Ranked Competition",
                                                totalmarks: mcqPaperList[index]
                                                    ['TotalMarks'],
                                                paperId: mcqPaperList[index]
                                                        ['PaperId']
                                                    .toString(),
                                                questionData: resultdata,
                                                submitedOn: "",
                                                paperName: mcqPaperList[index]
                                                    ['PaperName'],
                                                isAnswerSheetShow: mcqPaperList[
                                                                    index][
                                                                'IsAnswerSheetShow']
                                                            .toString() ==
                                                        "true"
                                                    ? true
                                                    : true,
                                              ),
                                            ));
                                        //
                                      }, () {
                                        Get.back();
                                      });
                                    } else {
                                      onSweetAleartDialog(context, () {
                                        Get.back();
                                      }, "Something went wrong !!", "",false);
                                    }
                                  } else {
                                    if (isExpired(mcqPaperList[index]
                                        ['MCQPaperEndDate'])) {
                                      _onExamExpire(context, "Expired!!",
                                          "Your exam time is Over.");
                                    } else {
                                      Get.to(
                                        transition: Transition.cupertino,
                                        () => McqTermAndConditionmobile(
                                            termAndCondition:
                                                mcqPaperList[index]
                                                    ['TermAndCondition'],
                                            paperName: mcqPaperList[index]
                                                ['PaperName'],
                                            startTime: mcqPaperList[index]
                                                ['MCQStartTime'],
                                            startDate: mcqPaperList[index]
                                                ['MCQPaperStartDate'],
                                            url: "",
                                            totalMarks: mcqPaperList[index]
                                                ['TotalMarks'],
                                            duration: mcqPaperList[index]
                                                ['Duration'],
                                            paperId: mcqPaperList[index]
                                                ['PaperId'],
                                            type: widget
                                                .paperNames['ServicesTypeName'],
                                            isAnswerSheetShow: mcqPaperList[
                                                                index][
                                                            'IsAnswerSheetShow']
                                                        .toString() ==
                                                    "true"
                                                ? true
                                                : false,
                                            userAnswer: {},
                                            endDate: mcqPaperList[index]
                                                ['MCQPaperEndDate']),
                                      );
                                    }
                                  }
                                });
                              } else {
                                if (isExpired(
                                    mcqPaperList[index]['MCQPaperEndDate'])) {
                                  _onExamExpire(context, "Expired!!",
                                      "Your exam time is Over.");
                                } else {
                                  Get.to(
                                    transition: Transition.cupertino,
                                    () => McqTermAndConditionmobile(
                                      termAndCondition: mcqPaperList[index]
                                          ['TermAndCondition'],
                                      paperName: mcqPaperList[index]
                                          ['PaperName'],
                                      startTime: mcqPaperList[index]
                                          ['MCQStartTime'],
                                      startDate: mcqPaperList[index]
                                          ['MCQPaperStartDate'],
                                      totalMarks: mcqPaperList[index]
                                          ['TotalMarks'],
                                      duration: mcqPaperList[index]['Duration'],
                                      paperId: mcqPaperList[index]['PaperId'],
                                      type:
                                          widget.paperNames['ServicesTypeName'],
                                      isAnswerSheetShow: mcqPaperList[index]
                                                      ['IsAnswerSheetShow']
                                                  .toString() ==
                                              "true"
                                          ? true
                                          : false,
                                      url: "",
                                      userAnswer: {},
                                      endDate: mcqPaperList[index]
                                          ['MCQPaperEndDate'],
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              width: itemWidth,
                              child: Card(
                                elevation: 4,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.indigo),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              AssetImage('assets/mcq_set.png'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              mcqPaperList[index]
                                                      ['PaperName'] ??
                                                  'Unnamed Paper',
                                              style: FontFamily.styleb
                                                  .copyWith(fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                                "Start: ${formatDateWithOrdinal1(mcqPaperList[index]['MCQPaperStartDate'])}",
                                                style: FontFamily.style
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color: Colors.amber)),
                                            Text(
                                                "End: ${formatDateWithOrdinal1(mcqPaperList[index]['MCQPaperEndDate'])}",
                                                style: FontFamily.style
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color:
                                                            Colors.deepOrange)),
                                            Text(
                                                "Duration: ${int.parse(mcqPaperList[index]['Duration'].toString()) / 60} min",
                                                style: FontFamily.style
                                                    .copyWith(fontSize: 14)),
                                          ],
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
                    ],
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
      ),
    );
  }

  String formatDateWithOrdinal1(String dateTimeString) {
    print(dateTimeString);
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);

      // Get the day of the month to add the ordinal suffix
      int day = dateTime.day;
      String dayWithSuffix = _getDayWithSuffix1(day);

      // Formatting the month and year
      String formattedMonthYear = DateFormat('MMM, yyyy').format(dateTime);

      // Formatting the time
      String formattedTime = DateFormat('HH:mm').format(dateTime);

      // Combining the parts together
      return '$dayWithSuffix $formattedMonthYear, $formattedTime';
    } catch (e) {
      writeToFile(e, "formatDateWithOrdinal");
      return "No datetime found";
    }
  }

  String _getDayWithSuffix1(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }


  _onAlredySubmited(context, String title, String desc, VoidCallback ontap,
      VoidCallback onCancelTap) async {
    await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Cancel",
            title: title,
            text: desc,
            confirmButtonText: "Ok",
            onConfirm: ontap,
            onDeny: onCancelTap,
            // onCancel: onCancelTap,
            type: ArtSweetAlertType.info));
  }

  bool isExpired(String expirationDateStr) {
    // Parse the expiration date string into a DateTime object
    DateTime expirationDate = DateTime.parse(expirationDateStr);

    // Get the current time
    DateTime currentTime = DateTime.now();

    // Compare the expiration date with the current time
    return expirationDate.isBefore(currentTime);
  }

  _onExamExpire(context, String title, String desc) {
    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
        titleStyle: TextStyle(
            color: const Color.fromARGB(255, 193, 25, 25),
            fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          child:
              Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromRGBO(3, 77, 59, 1),
          onPressed: () {
            Get.back();
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }
}
