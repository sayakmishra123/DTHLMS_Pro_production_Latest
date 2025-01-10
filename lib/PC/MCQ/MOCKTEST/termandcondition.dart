import 'dart:io';

import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/PC/MCQ/EXAM/RankedCompetitionMcqPc.dart';
import 'package:dthlms/PC/MCQ/EXAM/comprehansive_exam.dart';
import 'package:dthlms/PC/MCQ/MOCKTEST/mcqPage.dart';
import 'package:dthlms/PC/MCQ/PRACTICE/practiceMcqPage.dart';
import 'package:dthlms/PC/MCQ/finalexampage.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class MockMcqTermAndCondition extends StatefulWidget {
  final String termAndCondition;
  final String paperName;
  final String startTime;
  final String totalMarks;
  final String duration;
  final String paperId;
  final String type;
  final bool isAnswerSheetShow;
  final String startDate;
  final Map<int, List<int>> userAnswer;
  final String endDate;

  MockMcqTermAndCondition({
    super.key,
    required this.termAndCondition,
    required this.paperName,
    required this.startTime,
    required this.totalMarks,
    required this.paperId,
    required this.duration,
    required this.type,
    required this.isAnswerSheetShow,
    required this.startDate,
    required this.userAnswer,
    required this.endDate,
  });

  @override
  State<MockMcqTermAndCondition> createState() =>
      _MockMcqTermAndConditionState();
}

class _MockMcqTermAndConditionState extends State<MockMcqTermAndCondition> {
  RxList mcqdata = [].obs;
  RxBool showWarning = false.obs;
  RxList answerdata = [].obs;
  Getx getx = Get.put(Getx());
  Future<List<Map<String, dynamic>>> creatMCQlist(String paperId) async {
    List<Map<String, dynamic>> mcqList = [];
    try {
      print("Paper id" + paperId);
      // Fetch the list of sections for the paper
      List sectionData = await fetchMCQSectonList(paperId);

      for (var section in sectionData) {
        String sectionId = section['SectionId'].toString();
        print("section id" + sectionId);
        String sectionName = section["SectionName"]
            .toString(); // Adjust based on your data structure

        // Fetch questions for each section
        List questionData = await fetchTblMCQQuestionList(sectionId);

        for (var question in questionData) {
          String questionId = question['QuestionId'].toString();
          print("question id" +
              questionId); // Adjust based on your data structure

          // Fetch options for each question
          List optionsData = await fetchTblMCQOptionList(questionId);

          // Construct the question map
          Map<String, dynamic> questionMap = {
            "questionid": question['QuestionId'].toString(),
            "isMultiple": question['isMultiple'].toString(),
            "MCQQuestionType": question["MCQQuestionType"].toString(),
            "Question": question['McqQuestion'].toString(),
            "SectionId": sectionId,
            "SectionName": sectionName,
            "options": optionsData,
            "documentUrl": question['documentUrl'],
            "AnswerExplanation": question['AnswerExplanation'],
            "AnswerLink": question['AnswerLink'],
            "AnswerDocumentId": question['AnswerDocumentId'],
            "AnswerDocumentUrl": question['AnswerDocumentUrl'],
            "PassageDocumentUrl": question['PassageDocumentUrl'],
            "PassageLink": question['PassageLink'],
            "PassageDocumentId": question['PassageDocumentId'],
            "MCQQuestionDocumentId": question['MCQQuestionDocumentId'],
            "MCQQuestionUrl": question['MCQQuestionUrl'],
            "MCQQuestionTag": question['MCQQuestionTag'],
            "MCQQuestionMarks": question['MCQQuestionMarks'],
            "PassageDetails":question["PassageDetails"],
            // List of options for the question
          };

          // Add the question map to the main list
          mcqList.add(questionMap);
        }
      }
    } catch (e) {
      writeToFile(e, "creatMCQlist");
      print(e.toString() + "error on fetch mcq data");
    }
    answerdata.value = formatAnswers(mcqList);
    return mcqList;
  }

  Future getMCQDATA() async {
    mcqdata.value = await creatMCQlist(widget.paperId);

    print(mcqdata.value.toString() + "list");
  }

  List formatAnswers(List questions) {
    List<Map<int, List<int>>> answer = [];

    for (var question in questions) {
      int questionId = int.parse(question['questionid']);
      List<int> correctOptionIds = [];

      for (var option in question['options']) {
        if (option['IsCorrect'] == "true") {
          correctOptionIds.add(int.parse(option['OptionId'].toString()));
        }
      }

      // For single-choice questions, keep only the first correct option if any
      if (question['isMultiple'] == "false" && correctOptionIds.isNotEmpty) {
        correctOptionIds = [correctOptionIds.first];
      }

      answer.add({questionId: correctOptionIds});
    }

    return answer;
  }

  // bool windowsddevice = Platform.isWindows ? true : false;

  RxBool checkbox = false.obs;

  @override
  void initState() {
    print("hello");
    getMCQDATA();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorPage.white),
        automaticallyImplyLeading: true,
        // toolbarHeight: 80,
        backgroundColor: ColorPage.appbarcolor,
        // leading: Image.asset(
        //   'assets/2.png',
        // ),
        // title: Text(
        //   widget.paperName,
        //   style: FontFamily.font5,
        // ),
        actions: [
          Text(
            "Start at : ${formatDateWithOrdinal(widget.startTime)}",
            style: TextStyle(
                color: ColorPage.white,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          SizedBox(
            width: 50,
          )
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.home,
          //       color: ColorPage.white,
          //     )),
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.person_3_rounded,
          //       color: ColorPage.white,
          //     ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Platform.isAndroid ? 30 : 100, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width - 200,
                    child: Text(
                      'Please read the following instructions carefully',
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
                      child: widget.termAndCondition.isNotEmpty
                          ? HtmlWidget(widget.termAndCondition)
                          : Text(
                              textAlign: TextAlign.justify,
                              "No instructions here!!", // 'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Sequi officia doloribus veritatis facere autem necessitatibus, similique asperiores consectetur aliquam excepturi dolor error reiciendis beatae? Reprehenderit ducimus, voluptate facilis eveniet autem ab fuga accusantium suscipit labore obcaecati amet voluptatibus corporis numquam. Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolor accusantium voluptatibus, aliquam ratione exercitationem aut debitis quos saepe nemo atque, odio magni architecto sapiente voluptate! Dolores voluptate sapiente voluptatibus explicabo beatae, praesentium necessitatibus. Alias et perspiciatis fugiat est? Explicabo, neque vel est numquam quam similique ullam soluta veritatis dolores, quas ut cumque porro, eaque accusantium odio? Ad id officiis quis ducimus dolorem eum nobis dignissimos maxime! Porro id ratione quam deserunt eum adipisci, similique, qui placeat nisi voluptatem ullam nemo accusantium laudantium quas quidem voluptatum eveniet laboriosam. Iusto, adipisci, deleniti ullam possimus exercitationem at cum, illum maxime eius iure ipsam? Lorem ipsum, dolor sit amet consectetur adipisicing elit. Sequi officia doloribus veritatis facere autem necessitatibus, similique asperiores consectetur aliquam excepturi dolor error reiciendis beatae? Reprehenderit ducimus, voluptate facilis eveniet autem ab fuga accusantium suscipit labore obcaecati amet voluptatibus corporis numquam. Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolor accusantium voluptatibus, aliquam ratione exercitationem aut debitis quos saepe nemo atque, odio magni architecto sapiente voluptate! Dolores voluptate sapiente voluptatibus explicabo beatae, praesentium necessitatibus. Alias et perspiciatis fugiat est? Explicabo, neque vel est numquam quam similique ullam soluta veritatis dolores, quas ut cumque porro, eaque accusantium odio? Ad id officiis quis ducimus dolorem eum nobis dignissimos maxime! Porro id ratione quam deserunt eum adipisci, similique, qui placeat nisi voluptatem ullam nemo accusantium laudantium quas quidem voluptatum eveniet laboriosam. Iusto, adipisci, deleniti ullam possimus exercitationem at cum, illum maxime eius iure ipsam? Lorem ipsum, dolor sit amet consectetur adipisicing elit. Sequi officia doloribus veritatis facere autem necessitatibus, similique asperiores consectetur aliquam excepturi dolor error reiciendis beatae? Reprehenderit ducimus, voluptate facilis eveniet autem ab fuga accusantium suscipit labore obcaecati amet voluptatibus corporis numquam. Lorem ipsum dolor sit amet consectetur adipisicing elit. Dolor accusantium voluptatibus, aliquam ratione exercitationem aut debitis quos saepe nemo atque, odio magni architecto sapiente voluptate! Dolores voluptate sapiente voluptatibus explicabo beatae, praesentium necessitatibus. Alias et perspiciatis fugiat est? Explicabo, neque vel est numquam quam similique ullam soluta veritatis dolores, quas ut cumque porro, eaque accusantium odio? Ad id officiis quis ducimus dolorem eum nobis dignissimos maxime! Porro id ratione quam deserunt eum adipisci, similique, qui placeat nisi voluptatem ullam nemo accusantium laudantium quas quidem voluptatum eveniet laboriosam. Iusto, adipisci, deleniti ullam possimus exercitationem at cum, illum maxime eius iure ipsam? Dolor accusantium voluptatibus, aliquam ratione exercitationem aut debitis quos saepe nemo atque, odio magni architecto sapiente voluptate! Dolores voluptate sapiente voluptatibus explicabo beatae, praesentium necessitatibus. Alias et perspiciatis fugiat est? Explicabo, neque vel est numquam quam similique ullam soluta veritatis dolores, quas ut cumque porro, eaque accusantium odio? Ad id officiis quis ducimus dolorem eum nobis dignissimos maxime! Porro id ratione quam deserunt eum adipisci, similique, qui placeat nisi voluptatem ullam nemo accusantium laudantium quas quidem voluptatum eveniet laboriosam. Iusto, adipisci, deleniti ullam possimus exercitationem at cum, illum maxime eius iure ipsam?',
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
                    'Name : ${widget.paperName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaler: TextScaler.linear(1.4),
                  ),
                  // Text(
                  //   'Total Questions : 60',
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  //   textScaler:TextScaler.linear(1.4),
                  // )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Type : Multiple Choice',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaler: TextScaler.linear(1.4),
                  ),
                  Text(
                    'Total Duration :${(double.parse(widget.duration).toInt())~/60} minutes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaler: TextScaler.linear(1.4),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Marks : ${widget.totalMarks}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textScaler: TextScaler.linear(1.4),
                  ),
                ],
              ),

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
                      // if(mcqdata.isEmpty)
                      if (checkbox.value) {
                        if (mcqdata.isNotEmpty && answerdata.isNotEmpty) {
                          String attempt = DateTime.now().toString();

                          if (widget.type == "Quick Practice") {
                            await inserTblMCQhistory(
                                    widget.paperId,
                                    'Quick Practice',
                                    widget.paperName,
                                    '',
                                    '',
                                    attempt,
                                    "0")
                                .then((_) {
                              // Get.to(() => PracticeMcqExamPage());
                              Get.to(() => RankedCompetitionMcqPc(
                                totalMarks: widget.totalMarks,
                                    examStartTime: widget.startTime,
                                    paperId: widget.paperId,
                                    mcqlist: mcqdata,
                                    answerList: answerdata,
                                    paperName: widget.paperName,
                                    duration: widget.duration,
                                    attempt: attempt,
                                    examType:"Quick Practice" ,
                                    isAnswerSheetShow: false,
                                    totalDuration:widget.duration ,
                                    userAnswer:{} ,

                                  ));
                            });
                          }

                          if (widget.type == "Comprehensive") {
                            if(isTimeExpiredofComprehensive(widget.startTime,widget.endDate)=="true"){
                              





                            await inserTblMCQhistory(
                                    widget.paperId,
                                    'Comprehensive',
                                    widget.paperName,
                                    '',
                                    '',
                                    attempt,
                                    "0")
                                .then((_) {
                              Get.off(() => RankedCompetitionMcqPc(
                                    totalMarks: widget.totalMarks,
                                    examStartTime: widget.startTime,
                                    paperId: widget.paperId,
                                    mcqlist: mcqdata,
                                    answerList: answerdata,
                                    paperName: widget.paperName,
                                    duration: widget.duration,
                                    attempt: attempt,
                                    isAnswerSheetShow: true,
                                    examType:"Comprehensive" ,
                                    totalDuration:widget.duration ,
                                    userAnswer: {},
                                  ));
                            });
                            }
                            else if(isTimeExpiredofComprehensive(widget.startTime,widget.endDate)=="expire"){
                               _onTermDeniey(context, "Exam Time Expired",
                                    "Your exam has expired");


                            }
                            else{
                                _onTermDeniey(context, "Exam Not Started",
                                    "Your exam is yet to begin");

                            }



                          }
                          if (widget.type == "Ranked Competition") {
                            if (getx.isInternet.value) {
                              String examStatus = widget.duration;
                              
                              
                              // isTimeExpired(
                              //     widget.startTime, double.parse(widget.duration).toInt());

                              if (examStatus == "false") {
                                _onTermDeniey(context, "Exam Not Started",
                                    "Your exam is yet to begin");
                              } else if (examStatus == "expire") {
                                _onTermDeniey(context, "Exam Time Expired",
                                    "Your exam has expired");
                              } else {
                                await inserTblMCQhistory(
                                        widget.paperId,
                                        'Ranked Competition',
                                        widget.paperName,
                                        '',
                                        '',
                                        attempt,
                                        "0")
                                    .then((_) {
                                  Get.off(() => RankedCompetitionMcqPc(
                                    totalMarks: widget.totalMarks,
                                        examStartTime: widget.startTime,
                                        paperId: widget.paperId,
                                        mcqlist: mcqdata,
                                        answerList: answerdata,
                                        paperName: widget.paperName,
                                        duration:widget.duration,
                                        attempt: attempt,
                                        totalDuration: widget.duration,
                                        userAnswer: widget.userAnswer,
                                        isAnswerSheetShow:
                                            widget.isAnswerSheetShow,
                                           examType:  'Ranked Competition'
                                      ));
                                });
                              }
                            } else {
                              _onTermDeniey(context, "No Internet",
                                  "You don't have any internet connection!");
                            }
                          }

                          // Get.to(() => PracticeMcq(
                          //       mcqlist: mcqdata,
                          //       answerList: answerdata,
                          //     ));
                          //  Get.to(() => McqExamPage(
                          //     mcqlist: mcqdata,
                          //     answerList: answerdata,
                          //   ));
                        } else {
                          _onTermDeniey(context, "Paper Not Found!!", "");
                        }
                      } else {
                        showWarning.value = true;
                        _onTermDeniey(context, "Term Not Accepted !!",
                            "Please agree with our Term & condition of Exam. \n Fill the check box After reading the term & condition.");
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
              ),
              Obx(() => showWarning.value
                  ? Row(
                      children: [
                        Text(
                          "  *Click on the Checkbox to accept the Term & condition",
                          style: TextStyle(color: ColorPage.red, fontSize: 12),
                        )
                      ],
                    )
                  : SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  _onTermDeniey(context, String title, String desc) {
    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
        titleStyle:
            TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
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
            Navigator.pop(context);
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }
}
String isTimeExpiredofComprehensive(String timestamp, String expiryTimestamp) {
  // Parse the given timestamp and expiryTimestamp into DateTime objects
  DateTime originalTime = DateTime.parse(timestamp);
  print("Original Timestamp (Start Time): $originalTime");

  DateTime expiryTime = DateTime.parse(expiryTimestamp);
  print("Expiry Timestamp: $expiryTime");

  // Get the current time
  DateTime now = DateTime.now();
  print("Current Time: $now");

  // Check if the current time is between the start time and expiry time
  bool isCurrentInRange = now.isAfter(originalTime) && now.isBefore(expiryTime);

  print("Is Current Time in Range? $isCurrentInRange");

  // Determine the result based on conditions
  if (isCurrentInRange) {
    print("Condition met: Current Time is within range, returning true.");
    return "true";
  } else if (now.isBefore(originalTime)) {
    print("Condition met: Current Time is before Start Time, returning false.");
    return "false";
  } else {
    print("Condition met: Current Time is after Expiry Time, returning expire.");
    return "expire";
  }
}




String isTimeExpired(String timestamp, int duration) {
  // Parse the given timestamp into a DateTime object
  DateTime originalTime = DateTime.parse(timestamp);
  print("Original Timestamp: $originalTime");

  // Add the specified number of minutes to the original time
  DateTime expiryTime = originalTime.add(Duration(seconds: duration));
  print("Expiry Time (Original Time + $duration minutes): $expiryTime");

  // Get the current time
  DateTime now = DateTime.now();
  print("Current Time: $now");

  // Check if the expiry time is before the current time
  bool isOriginalAfterNow = originalTime.isBefore(now);
  bool isExpiryBeforeNow = expiryTime.isAfter(now);

  print("Is Original Time after Current Time? $isOriginalAfterNow");
  print("Is Expiry Time before Current Time? $isExpiryBeforeNow");

  // Determine the result based on conditions
  if (isOriginalAfterNow && isExpiryBeforeNow) {
    print(
        "Condition met: $expiryTime Time is after $now Time and Expiry Time is before Current Time.    ${expiryTime.difference(now).inMinutes.toString()}");
    return expiryTime.difference(now).inSeconds.toString();
    // return 3600.toString();




  } else if (expiryTime.isBefore(now)) {
    print("Condition met: Expiry Time is after Current Time.");
    return "expire";
  } else {
    print("Condition met: None of the above, returning false.");
    return "false";
  }
}
