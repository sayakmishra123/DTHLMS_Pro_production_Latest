import 'dart:developer';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'MOCKTEST/resultMcqTest.dart';
import 'MOCKTEST/termandcondition.dart';

class McqPaperDetails extends StatefulWidget {
  Map paperNames = {};
  RxList mcqSetList;
  bool istype;
  McqPaperDetails(this.paperNames, this.mcqSetList, this.istype, {super.key});

  @override
  State<McqPaperDetails> createState() => _McqPaperDetailsState();
}

class _McqPaperDetailsState extends State<McqPaperDetails> {
  RxList filteredList = [].obs;

  RxList mcqPaperList = [].obs;

  bool isExpired(String expirationDateStr) {
    // Parse the expiration date string into a DateTime object
    DateTime expirationDate = DateTime.parse(expirationDateStr);

    // Get the current time
    DateTime currentTime = DateTime.now();

    // Compare the expiration date with the current time
    return expirationDate.isBefore(currentTime);
  }

//  final RxList mcqSetList;
  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    log(widget.paperNames['ServicesTypeName'] + "kjhukhu");
    mcqPaperList.clear();
    mcqPaperList.value = await fetchMCQPapertList(widget.paperNames['SetId']);
    log(mcqPaperList.toString() + " type");
    // setState(() {});
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
        title: Text('MCQ Papers', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => mcqPaperList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 10, // Horizontal space between items
                    runSpacing: 10, // Vertical space between rows
                    children: List.generate(mcqPaperList.length, (index) {
                      return InkWell(
                        onTap: () async {
                          if(getx.isInternet.value){
                             fetchTblMCQHistory("").then((mcqhistoryList) {
        unUploadedMcQHistoryInfoInsert(
            context, mcqhistoryList, getx.loginuserdata[0].token);
      });
                          }
                          // Map checking = {};

                          if (widget.istype) {
                            // checking = await checkIsSubmited(
                            //     mcqPaperList[index]['PaperId'].toString());
                           await  checkMCQRankStatus(
                                context,
                                getx.loginuserdata[0].token,
                                mcqPaperList[index]['PaperId'].toString()).then((checking){
                                      if (checking.isNotEmpty) {

                            if(checking['StatusCode']==220){
              
                  print(  checking['UserAnswerList'].toString()+"///////////////////////");
                          
                          
                           Get.to(
                                transition: Transition.cupertino,
                                () => MockMcqTermAndCondition(
                                  termAndCondition: mcqPaperList[index]
                                      ['TermAndCondition'],
                                  paperName: mcqPaperList[index]['PaperName'],
                                  startTime: mcqPaperList[index]
                                      ['MCQStartTime'],
                                  startDate: mcqPaperList[index]
                                      ['MCQPaperStartDate'],
                                  totalMarks: mcqPaperList[index]['TotalMarks'],
                                  duration: checking['RemainingTimeInSeconds'].toString(),
                                  paperId: mcqPaperList[index]['PaperId'],
                                  type: widget.paperNames['ServicesTypeName'],
                                  isAnswerSheetShow: mcqPaperList[index]
                                                  ['IsAnswerSheetShow']
                                              .toString() ==
                                          "true"
                                      ? true
                                      : false,
                                       endDate: mcqPaperList[index]
                                                  ['MCQPaperEndDate'],
                                      userAnswer: checking['UserAnswerList']
                                ),
                              );
                              
                            }
                            else if(checking['StatusCode']==400){
                                _onAlredySubmited(context, "Submited!!",
                                "Your exam is already Submited, Please wait for result", () async {
                             Get.back();
                              //
                            }, () {
                              Get.back();
                            });
                            }
                            else if(checking['StatusCode']==440){


                              
                                _onAlredySubmited(context, "Submited!!",
                                "Your exam is already Submited, Check Your result", () async {
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
                                    builder: (context) => MockTestresult(
                                      type: "Ranked Competition",
                                      totalmarks: mcqPaperList[index]
                                          ['TotalMarks'],
                                      paperId: mcqPaperList[index]['PaperId']
                                          .toString(),
                                      questionData: resultdata,
                                      submitedOn: "",
                                      paperName: mcqPaperList[index]
                                          ['PaperName'],
                                      isAnswerSheetShow: mcqPaperList[index]
                                                      ['IsAnswerSheetShow']
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
                            }
                            
                            
                            else{
                              onSweetAleartDialog(context,(){Get.back();},"Something went wrong !!","");
                            }
                            // List rankData = await getRankDataOfMockTest(
                            //   context,
                            //   getx.loginuserdata[0].token,
                            //   mcqPaperList[index]['PaperId'].toString(),
                            // );

                          
                          } else {
                            if (isExpired(
                                mcqPaperList[index]['MCQPaperEndDate'])) {
                              _onExamExpire(context, "Expired!!",
                                  "Your exam time is Over.");
                            } else {
                              Get.to(
                                transition: Transition.cupertino,
                                () => MockMcqTermAndCondition(
                                  termAndCondition: mcqPaperList[index]
                                      ['TermAndCondition'],
                                  paperName: mcqPaperList[index]['PaperName'],
                                  startTime: mcqPaperList[index]
                                      ['MCQStartTime'],
                                  startDate: mcqPaperList[index]
                                      ['MCQPaperStartDate'],
                                  totalMarks: mcqPaperList[index]['TotalMarks'],
                                  duration: mcqPaperList[index]['Duration'],
                                  paperId: mcqPaperList[index]['PaperId'],
                                  type: widget.paperNames['ServicesTypeName'],
                                  isAnswerSheetShow: mcqPaperList[index]
                                                  ['IsAnswerSheetShow']
                                              .toString() ==
                                          "true"
                                      ? true
                                      : false,
                                      userAnswer: {},
                                       endDate: mcqPaperList[index]
                                                  ['MCQPaperEndDate']
                                ),
                              );
                            }
                          }
                    
                                  

                                });
                          }
                                else{
                                   if (isExpired(
                                mcqPaperList[index]['MCQPaperEndDate'])) {
                              _onExamExpire(context, "Expired!!",
                                  "Your exam time is Over.");
                            } else {
                              Get.to(
                                transition: Transition.cupertino,
                                () => MockMcqTermAndCondition(
                                  termAndCondition: mcqPaperList[index]
                                      ['TermAndCondition'],
                                  paperName: mcqPaperList[index]['PaperName'],
                                  startTime: mcqPaperList[index]
                                      ['MCQStartTime'],
                                  startDate: mcqPaperList[index]
                                      ['MCQPaperStartDate'],
                                  totalMarks: mcqPaperList[index]['TotalMarks'],
                                  duration: mcqPaperList[index]['Duration'],
                                  paperId: mcqPaperList[index]['PaperId'],
                                  type: widget.paperNames['ServicesTypeName'],
                                  isAnswerSheetShow: mcqPaperList[index]
                                                  ['IsAnswerSheetShow']
                                              .toString() ==
                                          "true"
                                      ? true
                                      : false,
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
                                    mcqPaperList[index]['PaperName'] ??
                                        'Unnamed Paper',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Start Exam: ${formatDateWithOrdinal(mcqPaperList[index]['MCQPaperStartDate'])}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    "End Exam: ${formatDateWithOrdinal(mcqPaperList[index]['MCQPaperEndDate'])}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    "Duration: ${int.parse(mcqPaperList[index]['Duration'].toString())/60} min",
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
      ),
    );
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
  // Alert(
  //   context: context,
  //   type: AlertType.info,
  //   style: AlertStyle(
  //     titleStyle:
  //         TextStyle(color: const Color.fromARGB(255, 193, 25, 25), fontWeight: FontWeight.bold),
  //     descStyle: FontFamily.font6,
  //     isCloseButton: false,
  //   ),
  //   title:title,
  //   desc:
  //       desc,
  //   buttons: [
  //       DialogButton(
  //       child:
  //           Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18)),
  //       highlightColor: Color.fromRGBO(3, 77, 59, 1),
  //       onPressed: onCancelTap,
  //       color: Color.fromRGBO(158, 9, 9, 1),
  //     ),
  //     DialogButton(
  //       child:
  //           Text("See result", style: TextStyle(color: Colors.white, fontSize: 18)),
  //       highlightColor: Color.fromRGBO(3, 77, 59, 1),
  //       onPressed: ontap,
  //       color: Color.fromRGBO(9, 89, 158, 1),
  //     ),

  //   ],
  // ).show();
}

_onExamExpire(context, String title, String desc) async {
  await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
          // denyButtonText: "Cancel",
          title: title,
          text: desc,
          showCancelBtn: false,
          confirmButtonText: "Ok",
          onConfirm: () {
            Get.back();
          },
          confirmButtonColor: Colors.red,

          // onCancel: onCancelTap,
          type: ArtSweetAlertType.danger));
  // Alert(
  //   context: context,
  //   type: AlertType.info,
  //   style: AlertStyle(
  //     titleStyle:
  //         TextStyle(color: const Color.fromARGB(255, 193, 25, 25), fontWeight: FontWeight.bold),
  //     descStyle: FontFamily.font6,
  //     isCloseButton: false,
  //   ),
  //   title:title,
  //   desc:
  //       desc,
  //   buttons: [
  //     DialogButton(
  //       child:
  //           Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
  //       highlightColor: Color.fromRGBO(3, 77, 59, 1),
  //       onPressed: () {

  //       Get.back();
  //       },
  //       color: Color.fromRGBO(9, 89, 158, 1),
  //     ),
  //   ],
  // ).show();
}
