import 'dart:async';
import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:collection/equality.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/MCQ/exit_page_dialog.dart';
import 'package:dthlms/MOBILE/MCQ/McqTestRank.dart';
import 'package:dthlms/PC/MCQ/PRACTICE/practiceMcqPage.dart';
import 'package:dthlms/PC/MCQ/modelclass.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/utctime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import '../../PC/MCQ/MOCKTEST/resultMcqTest.dart';

class MockTestMcqExamPageMobile extends StatefulWidget {
  final List mcqlist;
  final List answerList;
  final String paperId;
  final String examStartTime;
  final String paperName;
  final String totalMarks;
  final String duration;
  final String attempt;
  final String type;
  const MockTestMcqExamPageMobile({
    super.key,
    required this.mcqlist,
    required this.answerList,
    required this.paperId,
    required this.totalMarks,
    required this.examStartTime,
    required this.paperName,
    required this.duration,
    required this.attempt,
    required this.type,
  });

  @override
  State<MockTestMcqExamPageMobile> createState() =>
      _MockTestMcqExamPageMobileState();
}

class _MockTestMcqExamPageMobileState extends State<MockTestMcqExamPageMobile> {
  List answer = [];
  List<Map<String, dynamic>> submitedData = [];
  Map<int, List<int>> userAns = {};
  BuildContext? globalContext;

  late Timer _timer;
  Getx getx_obj = Get.put(Getx());
  RxBool buttonshow = false.obs;
  RxInt _start = 1800.obs;

  PageController _pageController = PageController();

  Future<void> getdata() async {
    print(widget.mcqlist);
    // Assuming widget.mcqlist is a valid JSON string
    String jsonData = jsonEncode(widget.mcqlist);

    List<dynamic> parsedJson = jsonDecode(jsonData);
    List<McqItem> mcqDatalist =
        parsedJson.map((json) => McqItem.fromJson(json)).toList();
    mcqData = mcqDatalist;
  }

  Map<int, int> sectionOffsets = {};
  List sectionWiseQuestionIdList = [];
  @override
  void initState() {
    answer = widget.answerList;
    print(answer);
    super.initState();
    _start.value = int.parse(widget.duration) * 60;
    sectionWiseQuestionIdList = groupQuestionsBySection(widget.mcqlist);

    // Calculate offsets for each section
    int cumulativeIndex = 0;
    for (var sectionMap in sectionWiseQuestionIdList) {
      int sectionId = sectionMap.keys.first;
      sectionOffsets[sectionId] = cumulativeIndex;
      cumulativeIndex += (sectionMap[sectionId]!.length as int);
    }

    getdata().whenComplete(() => setState(() {}));
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start.value == 0) {
          timer.cancel();
          _onimeUp(globalContext!);
          Future.delayed(Duration(seconds: 3)).whenComplete(() {
            _submitExam();
          });
        } else {
          _start.value--;
        }
      },
    );
  }

  Future<void> _submitExam() async {
    int correctAnswers = 0;
    userAns.forEach((questionId, selectedOptionIds) {
      // Get the list of correct answers for the current question
      List<int> correctAnswersForQuestion = answer
          .firstWhere((map) => map.containsKey(questionId))[questionId]!
          .toList();

      // Check if the selected options match the correct answers
      if (ListEquality().equals(selectedOptionIds, correctAnswersForQuestion)) {
        correctAnswers++;
      }
    });

    List<Map<String, dynamic>> resultJsonData = [];

    // Loop through all questions in mcqData to ensure each question is processed
    for (var question in mcqData) {
      int questionId = int.parse(question.questionId);
      String questionText = question.questionText;

      // Get correct answer IDs and texts
      List<int> correctAnswerIds = answer
          .firstWhere((map) => map.containsKey(questionId))[questionId]!
          .toList();
      List<String> correctAnswerTexts = correctAnswerIds
          .map((id) => question.options
              .firstWhere((opt) => opt.optionId == id.toString())
              .optionText)
          .toList();

      // Check if the user provided an answer; if not, set "Not Answered"
      List<int> selectedOptionIds = userAns[questionId] ?? [];
      List<String> userSelectedAnswerTexts = selectedOptionIds.isNotEmpty
          ? selectedOptionIds
              .map((id) => question.options
                  .firstWhere((opt) => opt.optionId == id.toString())
                  .optionText)
              .toList()
          : ["Not Answered"];

      resultJsonData.add({
        "questionid": questionId,
        "question name": questionText,
        "correctanswerId": correctAnswerIds,
        "correctanswer": correctAnswerTexts,
        "userselectedanswer id":
            selectedOptionIds.isNotEmpty ? selectedOptionIds : [-1],
        "userselectedanswer": userSelectedAnswerTexts,
      });

      // Insert into your database or perform necessary actions
      inserUserTblMCQAnswer(
          widget.paperId,
          questionId.toString(),
          questionText.toString(),
          correctAnswerIds.toString(),
          correctAnswerTexts.toString(),
          selectedOptionIds.isNotEmpty ? selectedOptionIds.toString() : "[]",
          userSelectedAnswerTexts.toString(),
          "",
          "",
          "");
    }
    updateTblUserResultDetails(
        "true", widget.paperId, UtcTime().utctime().toString());

    submitedData = resultJsonData;
    double totalMarks = calculateTotalMarks(resultJsonData);
    sendmarksToCalculateLeaderboard(globalContext!, getx.loginuserdata[0].token,
        totalMarks.toString(), widget.paperId);
    _timer.cancel();
    score.value = correctAnswers;
    isSubmitted.value = true;
    List rankdata = await getRankDataOfMockTest(
        globalContext!, getx.loginuserdata[0].token, widget.paperId);

    Get.to(
        transition: Transition.cupertino,
        () => RankPage(
              totalmarks: widget.totalMarks,
              paperId: widget.paperId,
              questionData: submitedData,
              frompaper: false,
              isMcq: false,
              type: widget.type,
              paperName: widget.paperName,
              submitedOn: DateTime.now().toString(),
              isAnswerSheetShow: true,
            ));
  }

  String get timerText {
    int hours = _start.value ~/ 3600;
    int minutes = (_start.value % 3600) ~/ 60;
    int seconds = _start.value % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String groupname = 'Section name';

  RxList<int> reviewlist = <int>[].obs;

  RxInt qindex = 0.obs;
  int selectedIndex = -1;
  RxBool isSubmitted = false.obs;
  RxInt score = 0.obs;

  List<McqItem> mcqData = [];

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    double height = MediaQuery.of(context).size.height;
    return Obx(() => SafeArea(
          child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                automaticallyImplyLeading: false,
                iconTheme: IconThemeData(color: ColorPage.white),
                centerTitle: false,
                backgroundColor: ColorPage.appbarcolor,
                leading: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ExitPageDialog(),
                      );
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded)),
                title: Text(
                  '${widget.paperName}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Icon(
                            Icons.alarm_outlined,
                            color: ColorPage.white,
                          ),
                          Text(
                            ' $timerText',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            bottomSheet();
                          },
                          icon: Icon(FontAwesome.gear))
                    ],
                  ),
                ],
              ),
              body: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      qindex.value = index;
                    },
                    itemCount: mcqData.length,
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(8, 8),
                                                blurRadius: 10,
                                              )
                                            ],
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            mcqData[qindex.value].sectionName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(8, 8),
                                                  blurRadius: 10,
                                                )
                                              ]),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Column(
                                            children: [
                                              Text(
                                                textAlign: TextAlign.center,
                                                mcqData[index].questionText,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20),
                                              ),
                                              // if (mcqData[index].imageUrl !=
                                              //     null)
                                              //   Padding(
                                              //     padding: const EdgeInsets.all(
                                              //         15),
                                              //     child: Image.network(
                                              //         mcqData[index].imageUrl!),
                                              //   ),
                                              // if (mcqData[index].videoUrl !=
                                              //     null)
                                              //   Container(
                                              //     margin: EdgeInsets.symmetric(
                                              //         vertical: 20),
                                              //     child: AspectRatio(
                                              //       aspectRatio: 16 / 9,
                                              //     ),
                                              //   ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 10),
                                                color: Colors.black26,
                                                height: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            mcqData[qindex.value].isMultiple == 'true'
                                ? Row(
                                    children: [
                                      Text(
                                          "  * Multiple selection available for this question.",
                                          style: TextStyle(
                                            color: ColorPage.green,
                                          ))
                                    ],
                                  )
                                : SizedBox(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: SizedBox(
                                height: height,
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: ListView.builder(
                                        itemCount: mcqData[qindex.value]
                                            .options
                                            .length,
                                        itemBuilder: (context, index) {
                                          String optionId =
                                              mcqData[qindex.value]
                                                  .options[index]
                                                  .optionId;
                                          String questionId =
                                              mcqData[qindex.value].questionId;

                                          // Check if the option is selected
                                          bool isSelected = userAns.containsKey(
                                                  int.parse(questionId)) &&
                                              userAns[int.parse(questionId)]!
                                                  .contains(
                                                      int.parse(optionId));

                                          // Check if the option is correct
                                          bool isCorrect = answer.any(
                                            (map) =>
                                                map.containsKey(
                                                    int.parse(questionId)) &&
                                                map[int.parse(questionId)]!
                                                    .contains(
                                                        int.parse(optionId)),
                                          );

                                          Color tileColor;
                                          if (isSubmitted.value) {
                                            if (isCorrect) {
                                              tileColor = Colors.green;
                                            } else if (isSelected &&
                                                !isCorrect) {
                                              tileColor = Colors.red;
                                            } else {
                                              tileColor =
                                                  Colors.white; // default color
                                            }
                                          } else {
                                            tileColor = isSelected
                                                ? Colors.blue
                                                : Colors.white; // default color
                                          }

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              curve: Curves.easeInOut,
                                              // height: 60,
                                              decoration: BoxDecoration(
                                                color: tileColor,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 5),
                                                  ),
                                                ],
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  onTap: () {
                                                    setState(() {
                                                      // print("question id $questionId");
                                                      // print("optin Id $optionId");
                                                      // print("ismultiple ${mcqData[qindex.value]
                                                      //             .isMultiple}");
                                                      if (!isSubmitted.value) {
                                                        if (userAns.containsKey(
                                                            int.parse(
                                                                questionId))) {
                                                          if (mcqData[qindex
                                                                      .value]
                                                                  .isMultiple ==
                                                              'true') {
                                                            // Toggle option for multi-select
                                                            if (userAns[int.parse(
                                                                    questionId)]!
                                                                .contains(int.parse(
                                                                    optionId))) {
                                                              userAns[int.parse(
                                                                      questionId)]!
                                                                  .remove(int.parse(
                                                                      optionId));
                                                            } else {
                                                              userAns[int.parse(
                                                                      questionId)]!
                                                                  .add(int.parse(
                                                                      optionId));
                                                            }
                                                          } else {
                                                            // Single answer
                                                            userAns[int.parse(
                                                                questionId)] = [
                                                              int.parse(
                                                                  optionId)
                                                            ];
                                                          }
                                                        } else {
                                                          userAns[int.parse(
                                                              questionId)] = [
                                                            int.parse(optionId)
                                                          ];
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16,
                                                                vertical: 20),
                                                        child: Text(
                                                          mcqData[qindex.value]
                                                              .options[index]
                                                              .optionText,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            // fontSize: 15,
                                                          ),
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .visible,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (qindex.value > 0)
                                          MaterialButton(
                                            height: 40,
                                            color: ColorPage.appbarcolorcopy,
                                            padding: EdgeInsets.all(16),
                                            shape: ContinuousRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            onPressed: () {
                                              if (qindex.value > 0) {
                                                qindex.value--;
                                                _pageController.jumpToPage(qindex
                                                    .value); // Navigate to the previous page
                                              }
                                            },
                                            child: Text(
                                              'Previous',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        Visibility(
                                          visible: true,
                                          child: Obx(
                                            () => MaterialButton(
                                              height: 40,
                                              color: !reviewlist
                                                      .contains(qindex.value)
                                                  ? Colors.orange
                                                  : Colors.blueGrey,
                                              padding: EdgeInsets.all(16),
                                              shape: ContinuousRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              onPressed: () {
                                                print(qindex.value);
                                                if (!reviewlist
                                                    .contains(qindex.value)) {
                                                  reviewlist.add(qindex.value);
                                                  print("add on list");
                                                } else if (reviewlist
                                                    .contains(qindex.value)) {
                                                  reviewlist
                                                      .remove(qindex.value);
                                                  print("remove from on list");
                                                }
                                              },
                                              child: Text(
                                                !reviewlist
                                                        .contains(qindex.value)
                                                    ? 'Mark for Review'
                                                    : "Clear response",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (qindex.value < mcqData.length)
                                          MaterialButton(
                                            height: 40,
                                            color: ColorPage.appbarcolorcopy,
                                            padding: EdgeInsets.all(16),
                                            shape: ContinuousRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            onPressed: () {
                                              if (qindex.value <
                                                  mcqData.length - 1) {
                                                qindex.value++;
                                                _pageController.jumpToPage(qindex
                                                    .value); // Navigate to the next page
                                              } else {
                                                _onSubmitExam2(
                                                  context,
                                                );
                                                // Reset to the first page
                                              }
                                            },
                                            child: Text(
                                              qindex.value == mcqData.length - 1
                                                  ? 'Submit'
                                                  : 'Next',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Positioned(

                  //     child: InkWell(
                  //       onTap: () {

                  //       },
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //             color: ColorPage.appbarcolorcopy,
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(5))),
                  //         padding: EdgeInsets.all(5),
                  //         child: Icon(
                  //           Icons.list_alt,
                  //           color: ColorPage.white,
                  //         ),
                  //       ),
                  //     ))
                ],
              )),
        ));
  }

  // _onSubmitExam(context) {
  //   int correctAnswers = 0;
  //   userAns.forEach((questionId, selectedOptionId) {
  //     if (answer.any((map) => map[questionId] == selectedOptionId)) {
  //       correctAnswers++;
  //     }
  //   });
  //   print(correctAnswers.toString());

  //   Alert(
  //     context: context,
  //     type: AlertType.info,
  //     style: AlertStyle(
  //       animationType: AnimationType.fromLeft,
  //       titleStyle:
  //           TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
  //       descStyle: FontFamily.font6,
  //       isCloseButton: false,
  //     ),
  //     title: "Are You Sure?",
  //     desc:
  //         "Once You submit, You can't Change your Sheet \n If you are sure then Click on 'Yes' Button",
  //     buttons: [
  //       DialogButton(
  //         child: Text("Cancel",
  //             style: TextStyle(color: Colors.white, fontSize: 18)),
  //         highlightColor: Color.fromRGBO(77, 3, 3, 1),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         color: Color.fromRGBO(158, 9, 9, 1),
  //       ),
  //       DialogButton(
  //         child:
  //             Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
  //         highlightColor: Color.fromRGBO(77, 3, 3, 1),
  //         onPressed: () {
  //           _timer.cancel();
  //           score.value = correctAnswers;

  //           isSubmitted.value = true;
  //           Navigator.pop(context);
  //           Get.toNamed("/Mocktestrankpagemobile",arguments:{"mcqData":mcqData,"correctAnswers":answer,"userAns":userAns,'totalnumber':correctAnswers});
  //         },
  //         color: Color.fromRGBO(9, 89, 158, 1),
  //       ),
  //     ],
  //   ).show();
  // }

  _onimeUp(context) {
    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
        animationType: AnimationType.fromTop,
        titleStyle:
            TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "Your Time is Up !!",
      desc: "Sorry! But Your time is over. \n Your Exam has been submitted.",
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

  _onincompleteSubmission(context) {
    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
        animationType: AnimationType.fromLeft,
        titleStyle:
            TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "Your Sheet is Incomplete",
      desc:
          "Your Answer sheet is Incomplete. \n Are you Sure to Submit then Click on Yes Button.  ",
      buttons: [
        DialogButton(
          child: Text("Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromRGBO(77, 3, 3, 1),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(177, 58, 58, 1),
        ),
        DialogButton(
          child:
              Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromRGBO(3, 77, 59, 1),
          onPressed: () {
            setState(() {
              isSubmitted.value = true;
            });
            Navigator.pop(context);
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }

  _onSubmitExam2(BuildContext context) async {
    int correctAnswers = 0;
    userAns.forEach((questionId, selectedOptionIds) {
      // Get the list of correct answers for the current question
      List<int> correctAnswersForQuestion = answer
          .firstWhere((map) => map.containsKey(questionId))[questionId]!
          .toList();

      // Check if the selected options match the correct answers
      if (ListEquality().equals(selectedOptionIds, correctAnswersForQuestion)) {
        correctAnswers++;
      }
    });

//     Alert(
//       context: context,
//       type: AlertType.info,
//       style: AlertStyle(
//         isOverlayTapDismiss: false,
//         animationType: AnimationType.fromLeft,
//         titleStyle:
//             TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
//         descStyle: FontFamily.font6,
//         isCloseButton: false,
//       ),
//       title: "Are You Sure?",
//       desc:
//           "Once You submit, You can't Change your Sheet \n If you are sure then Click on 'Yes' Button",
//       buttons: [
//         DialogButton(
//           child: Text("Cancel",
//               style: TextStyle(color: Colors.white, fontSize: 18)),
//           highlightColor: Color.fromRGBO(77, 3, 3, 1),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           color: Color.fromRGBO(158, 9, 9, 1),
//         ),
//         DialogButton(
//           child:
//               Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
//           highlightColor: Color.fromRGBO(77, 3, 3, 1),
//           onPressed: () async {
//             List<Map<String, dynamic>> resultJsonData = [];

//             // Loop through all questions in mcqData to ensure each question is processed
//             for (var question in mcqData) {
//               int questionId = int.parse(question.questionId);
//               String questionText = question.questionText;

//               // Get correct answer IDs and texts
//               List<int> correctAnswerIds = answer
//                   .firstWhere((map) => map.containsKey(questionId))[questionId]!
//                   .toList();
//               List<String> correctAnswerTexts = correctAnswerIds
//                   .map((id) => question.options
//                       .firstWhere((opt) => opt.optionId == id.toString())
//                       .optionText)
//                   .toList();

//               // Check if the user provided an answer; if not, set "Not Answered"
//               List<int> selectedOptionIds = userAns[questionId] ?? [];
//               List<String> userSelectedAnswerTexts = selectedOptionIds
//                       .isNotEmpty
//                   ? selectedOptionIds
//                       .map((id) => question.options
//                           .firstWhere((opt) => opt.optionId == id.toString())
//                           .optionText)
//                       .toList()
//                   : ["Not Answered"];

//               // If no answers selected, set user-selected IDs to [-1] to indicate no response
//               resultJsonData.add({
//                 "questionid": questionId,
//                 "question name": questionText,
//                 "correctanswerId": correctAnswerIds,
//                 "correctanswer": correctAnswerTexts,
//                 "userselectedanswer id":
//                     selectedOptionIds.isNotEmpty ? selectedOptionIds : [-1],
//                 "userselectedanswer": userSelectedAnswerTexts,
//               });

//               inserUserTblMCQAnswer(
//                   widget.paperId,
//                   questionId.toString(),
//                   questionText.toString(),
//                   correctAnswerIds.toString(),
//                   correctAnswerTexts.toString(),
//                   selectedOptionIds.isNotEmpty
//                       ? selectedOptionIds.toString()
//                       : "[]",
//                   userSelectedAnswerTexts.toString(),
//                   "",
//                   "",
//                   "");
//             }
//             updateTblUserResultDetails(
//                 "true", widget.paperId, UtcTime().utctime().toString());

//             // Log or display JSON data as needed
//             print("Result JSON Data: ");
//             print(resultJsonData);
// //hello
//             submitedData = resultJsonData;
//             double totalMarks = calculateTotalMarks(resultJsonData);
//             updateTblMCQhistory(widget.paperId, widget.attempt,
//                 totalMarks.toString(), DateTime.now().toString(), context);

//             sendmarksToCalculateLeaderboard(
//                 context,
//                 getx.loginuserdata[0].token,
//                 totalMarks.toString(),
//                 widget.paperId);
//             _timer.cancel();
//             score.value = correctAnswers;
//             isSubmitted.value = true;
//             List rankdata = await getRankDataOfMockTest(
//                 context, getx.loginuserdata[0].token, widget.paperId);

//             Get.to(
//                 transition: Transition.cupertino,
//                 () => RankPage(
//                       totalmarks: widget.totalMarks,
//                       paperId: widget.paperId,
//                       questionData: submitedData,
//                       frompaper: false,
//                       isMcq: false,
//                       type: widget.type,
//                       paperName: widget.paperName,
//                       submitedOn: DateTime.now().toString(),
//                     ));
//             // Navigator.pop(context);
//           },
//           color: Color.fromRGBO(9, 89, 158, 1),
//         ),
//       ],
//     ).show();

    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        denyButtonText: "Cancel",
        title: "Are You Sure?",
        text: "Once You submit, You can't Change your Sheet",
        confirmButtonText: "Submit",
        type: ArtSweetAlertType.question,
      ),
    );

    if (response == null) {
      return;
    }

    if (response.isTapConfirmButton) {
      List<Map<String, dynamic>> resultJsonData = [];

      // Loop through all questions in mcqData to ensure each question is processed
      for (var question in mcqData) {
        int questionId = int.parse(question.questionId);
        String questionText = question.questionText;

        // Get correct answer IDs and texts
        List<int> correctAnswerIds = answer
            .firstWhere((map) => map.containsKey(questionId))[questionId]!
            .toList();
        List<String> correctAnswerTexts = correctAnswerIds
            .map((id) => question.options
                .firstWhere((opt) => opt.optionId == id.toString())
                .optionText)
            .toList();

        // Check if the user provided an answer; if not, set "Not Answered"
        List<int> selectedOptionIds = userAns[questionId] ?? [];
        List<String> userSelectedAnswerTexts = selectedOptionIds.isNotEmpty
            ? selectedOptionIds
                .map((id) => question.options
                    .firstWhere((opt) => opt.optionId == id.toString())
                    .optionText)
                .toList()
            : ["Not Answered"];

        // If no answers selected, set user-selected IDs to [-1] to indicate no response
        resultJsonData.add({
          "questionid": questionId,
          "question name": questionText,
          "correctanswerId": correctAnswerIds,
          "correctanswer": correctAnswerTexts,
          "userselectedanswer id":
              selectedOptionIds.isNotEmpty ? selectedOptionIds : [-1],
          "userselectedanswer": userSelectedAnswerTexts,
        });

        inserUserTblMCQAnswer(
            widget.paperId,
            questionId.toString(),
            questionText.toString(),
            correctAnswerIds.toString(),
            correctAnswerTexts.toString(),
            selectedOptionIds.isNotEmpty ? selectedOptionIds.toString() : "[]",
            userSelectedAnswerTexts.toString(),
            "",
            "",
            "");
      }
      updateTblUserResultDetails(
          "true", widget.paperId, UtcTime().utctime().toString());

      // Log or display JSON data as needed
      print("Result JSON Data: ");
      print(resultJsonData);
//hello
      submitedData = resultJsonData;
      double totalMarks = calculateTotalMarks(resultJsonData);
      updateTblMCQhistory(widget.paperId, widget.attempt, totalMarks.toString(),
          DateTime.now().toString(), context);

      sendmarksToCalculateLeaderboard(context, getx.loginuserdata[0].token,
          totalMarks.toString(), widget.paperId);
      _timer.cancel();
      score.value = correctAnswers;
      isSubmitted.value = true;
      List rankdata = await getRankDataOfMockTest(
          context, getx.loginuserdata[0].token, widget.paperId);

      Get.to(
          transition: Transition.cupertino,
          () => RankPage(
                totalmarks: widget.totalMarks,
                paperId: widget.paperId,
                questionData: submitedData,
                frompaper: false,
                isMcq: false,
                type: widget.type,
                paperName: widget.paperName,
                submitedOn: DateTime.now().toString(),
                isAnswerSheetShow: true,
              ));

      return;
    }
  }

  bottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: ColorPage.bgcolor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                      height: 55 * ((widget.mcqlist.length ~/ 4) + 1) +
                          sectionWiseQuestionIdList.length * 110,
                      child: ListView.builder(
                          itemCount: sectionWiseQuestionIdList.length,
                          itemBuilder: (context, index) {
// print(sectionWiseQuestionIdList.length);
// String rawdata=jsonEncode(sectionWiseQuestionIdList[index]);
                            Map<int, List<int>> data =
                                sectionWiseQuestionIdList[index];
                            List<int> indexList = data.values.first;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(fetchSectionName(data.keys
                                          .toString()
                                          .replaceAll("(", "")
                                          .replaceAll(")", ""))),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 100 * ((indexList.length ~/ 4) + 1),
                                  child: GridView.builder(
                                      itemCount: indexList.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4),
                                      itemBuilder: (context, ind) {
                                        // Get section ID and cumulative offset
                                        int sectionId = data.keys.first;
                                        int offset = sectionOffsets[sectionId]!;

                                        return SingleChildScrollView(
                                          child: MaterialButton(
                                            height: 55,
                                            color: reviewlist.contains(
                                                        offset + ind) &&
                                                    !isSubmitted.value
                                                ? Colors.amber
                                                : userAns.containsKey(
                                                        indexList[ind])
                                                    ? isSubmitted.value
                                                        ? answer.any((map) => map
                                                                .values
                                                                .any((List<int>
                                                                        list) =>
                                                                    list.any(
                                                                        (item) =>
                                                                            userAns[indexList[ind]]!.contains(item))))
                                                            ? Colors.green
                                                            : Colors.red
                                                        : Colors.blue
                                                    : qindex.value == offset + ind
                                                        ? Color.fromARGB(255, 13, 32, 79)
                                                        : Colors.white,
                                            shape: CircleBorder(
                                                side: BorderSide(
                                                    width: qindex.value ==
                                                            offset + ind
                                                        ? 4
                                                        : 1,
                                                    color: qindex.value ==
                                                            offset + ind
                                                        ? ColorPage.white
                                                        : Colors.black12)),
                                            onPressed: () {
                                              qindex.value = offset +
                                                  ind; // Update the current question index
                                              _pageController
                                                  .jumpToPage(qindex.value);
                                              Get.back();
                                            },
                                            child: Text(
                                              (ind + 1).toString(),
                                              style: TextStyle(
                                                  color: qindex.value ==
                                                          offset + ind
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            );
                          }))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
