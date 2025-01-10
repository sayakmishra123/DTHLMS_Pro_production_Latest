import 'dart:async';
import 'dart:convert';

import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/MCQ/exit_page_dialog.dart';
import 'package:dthlms/PC/MCQ/PRACTICE/practiceMcqPage.dart';
import 'package:dthlms/PC/MCQ/modelclass.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';
// import 'package:dthlms/android/MCQ/mockTestRank.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

class PracticeMcqMobile extends StatefulWidget {
  final List mcqlist;
  final List answerList;

  final String paperId;
  final String examStartTime;
  final String paperName;
  final String duration;
  final String attemp;
  const PracticeMcqMobile(
      {super.key,
      required this.mcqlist,
      required this.answerList,
      required this.duration,
      required this.attemp,
      required this.examStartTime,
      required this.paperId,
      required this.paperName});

  @override
  State<PracticeMcqMobile> createState() => _PracticeMcqMobileState();
}

class _PracticeMcqMobileState extends State<PracticeMcqMobile> {
  List answer = [];
  Map<int, List<int>> userAns = {};
  String lastattemp="";

  Getx getx_obj = Get.put(Getx());
  RxBool buttonshow = false.obs;

  PageController _pageController = PageController();
  List sectionWiseQuestionIdList = [];

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

  @override
  void initState() {
    answer = widget.answerList;
    print(answer);
    super.initState();
    sectionWiseQuestionIdList = groupQuestionsBySection(widget.mcqlist);

    // Calculate offsets for each section
    int cumulativeIndex = 0;
    for (var sectionMap in sectionWiseQuestionIdList) {
      int sectionId = sectionMap.keys.first;
      sectionOffsets[sectionId] = cumulativeIndex;
      cumulativeIndex += (sectionMap[sectionId]!.length as int);
    }

    getdata().whenComplete(() => setState(() {}));
    // startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String groupname = 'All Questions';

  List<int> reviewlist = [];

  RxInt qindex = 0.obs;
  int selectedIndex = -1;
  RxBool isSubmitted = false.obs;
  RxInt score = 0.obs;

  List<McqItem> mcqData = [];

  bottomSheet(){
     showModalBottomSheet(
                                        context: context,
                                        isDismissible: true,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (context) =>
                                            DraggableScrollableSheet(
                                          expand: false,
                                          builder:
                                              (context, scrollController) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              color: ColorPage.bgcolor,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            child: SingleChildScrollView(
                                              controller: scrollController,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 5,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2.5),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                    Container(
                                                        height: 55 *
                                                                ((widget.mcqlist
                                                                            .length ~/
                                                                        4) +
                                                                    1) +
                                                            sectionWiseQuestionIdList
                                                                    .length *
                                                                110,
                                                        child: ListView.builder(
                                                            itemCount:
                                                                sectionWiseQuestionIdList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
// print(sectionWiseQuestionIdList.length);
// String rawdata=jsonEncode(sectionWiseQuestionIdList[index]);
                                                              Map<int,
                                                                      List<int>>
                                                                  data =
                                                                  sectionWiseQuestionIdList[
                                                                      index];
                                                              List<int>
                                                                  indexList =
                                                                  data.values
                                                                      .first;
                                                              return Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child: Text(fetchSectionName(data
                                                                            .keys
                                                                            .toString()
                                                                            .replaceAll("(",
                                                                                "")
                                                                            .replaceAll(")",
                                                                                ""))),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    height: 80 *
                                                                        ((indexList.length ~/
                                                                                4) +
                                                                            1),
                                                                    child: GridView.builder(
                                                                        itemCount: indexList.length,
                                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                                                                        itemBuilder: (context, ind) {
                                                                          // Get section ID and cumulative offset
                                                                          int sectionId = data
                                                                              .keys
                                                                              .first;
                                                                          int offset =
                                                                              sectionOffsets[sectionId]!;
                                                                          print(
                                                                              answer);
                                                                          print(
                                                                              userAns[indexList[ind]]);

                                                                          return SingleChildScrollView(
                                                                            child:
                                                                                MaterialButton(
                                                                              height: 55,
                                                                              color: reviewlist.contains(offset + ind)
                                                                                  ? Colors.amber
                                                                                  : userAns.containsKey(indexList[ind])
                                                                                      ? answer.any((map) => map.values.any((List<int> list) => list.any((item) => userAns[indexList[ind]]!.contains(item))))
                                                                                          ? Colors.green
                                                                                          : Colors.red
                                                                                      : qindex.value == offset + ind
                                                                                          ? Color.fromARGB(255, 13, 32, 79)
                                                                                          : Colors.white,
                                                                              shape: CircleBorder(side: BorderSide(width: qindex.value == offset + ind ? 4 : 1, color: qindex.value == offset + ind ? ColorPage.white : Colors.black12)),
                                                                              onPressed: () {
                                                                                Get.back();
                                                                                qindex.value = offset + ind; // Update the current question index
                                                                                _pageController.jumpToPage(qindex.value);
                                                                              },
                                                                              child: Text(
                                                                                (ind + 1).toString(),
                                                                                style: TextStyle(color: qindex.value == offset + ind ? Colors.white : Colors.black),
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){
            showDialog(
                        context: context,
                        builder: (context) => ExitPageDialog(),
                      );
          }, icon: Icon(Icons.arrow_back_ios_new_rounded)),
          iconTheme: IconThemeData(color: ColorPage.white),
          // leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
          centerTitle: false,
          backgroundColor: ColorPage.appbarcolor,
          title: Text(
            widget.paperName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 20,
                ),
              ],
            ),
              IconButton(onPressed: (){
                                              bottomSheet();

                    }, icon: Icon(FontAwesome.gear))
          ],
        ),
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  qindex.value =
                      index; // Synchronize qindex with the current page
                });
              },
              itemCount: mcqData.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                       mcqData[index].sectionName,
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
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          mcqData[index].questionText,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),
                                        // if (mcqData[index].imageUrl != null)
                                        //   Padding(
                                        //     padding: const EdgeInsets.all(15),
                                        //     child: Image.network(
                                        //         mcqData[index].imageUrl!),
                                        //   ),
                                        // if (mcqData[index].videoUrl != null)
                                        //   Container(
                                        //     margin: EdgeInsets.symmetric(
                                        //         vertical: 20),
                                        //     child: AspectRatio(
                                        //       aspectRatio: 16 / 9,
                                        //     ),
                                        //   ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: SizedBox(
                          height: height,
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 400,
                                  child: ListView.builder(
                                    itemCount:
                                        mcqData[qindex.value].options.length,
                                    itemBuilder: (context, index) {
                                      String optionId = mcqData[qindex.value]
                                          .options[index]
                                          .optionId;
                                      String questionId =
                                          mcqData[qindex.value].questionId;

                                      // Get the correct answers for the current question
                                      List<int> correctAnswersForQuestion =
                                          answer
                                              .firstWhere((map) =>
                                                  map.containsKey(
                                                      int.parse(questionId)))[
                                                  int.parse(questionId)]!
                                              .toList();

                                      // Check if the option is selected
                                      bool isSelected = userAns.containsKey(
                                              int.parse(questionId)) &&
                                          userAns[int.parse(questionId)]!
                                              .contains(int.parse(optionId));

                                      // Check if the option is correct
                                      bool isCorrect = correctAnswersForQuestion
                                          .contains(int.parse(optionId));

                                      // Determine the color of the tile
                                      Color tileColor;
                                      if (isSelected) {
                                        tileColor = isCorrect
                                            ? Colors.green
                                            : Colors.red;
                                      } else if (userAns.containsKey(
                                              int.parse(questionId)) &&
                                          userAns[int.parse(questionId)]!
                                                  .length >=
                                              correctAnswersForQuestion
                                                  .length) {
                                        // Reveal correct answers in green after max selections
                                        tileColor = isCorrect
                                            ? Colors.green
                                            : Colors.white;
                                      } else {
                                        tileColor = Colors.white;
                                      }

                                      // Determine if selection should be disabled
                                      bool isSelectionDisabled = userAns
                                              .containsKey(
                                                  int.parse(questionId)) &&
                                          ((mcqData[qindex.value].isMultiple ==
                                                      'true' &&
                                                  userAns[int.parse(
                                                              questionId)]!
                                                          .length >=
                                                      correctAnswersForQuestion
                                                          .length) ||
                                              mcqData[qindex.value]
                                                      .isMultiple ==
                                                  'false');

                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          height: 60,
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
                                                  // Skip if selection is disabled
                                                  if (isSelectionDisabled)
                                                    return;

                                                  if (mcqData[qindex.value]
                                                          .isMultiple ==
                                                      'true') {
                                                    // Multi-select option with limit check
                                                    if (userAns.containsKey(
                                                        int.parse(
                                                            questionId))) {
                                                      if (userAns[int.parse(
                                                              questionId)]!
                                                          .contains(int.parse(
                                                              optionId))) {
                                                        // Prevent unselecting a chosen option
                                                        return;
                                                      } else {
                                                        userAns[int.parse(
                                                                questionId)]!
                                                            .add(int.parse(
                                                                optionId));
                                                      }
                                                    } else {
                                                      userAns[int.parse(
                                                          questionId)] = [
                                                        int.parse(optionId)
                                                      ];
                                                    }

                                                    // Check if maximum selections have been made for multi-select
                                                    if (userAns[int.parse(
                                                                questionId)]!
                                                            .length ==
                                                        correctAnswersForQuestion
                                                            .length) {
                                                      // Automatically reveal answers if max selection is reached
                                                      setState(() {
                                                        // Set `isSelectionDisabled` to true to prevent further changes
                                                        isSelectionDisabled =
                                                            true;
                                                      });
                                                    }
                                                  } else {
                                                    // Single selection, replace existing answer
                                                    userAns[int.parse(
                                                        questionId)] = [
                                                      int.parse(optionId)
                                                    ];
                                                  }
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: Container(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Text(
                                                          mcqData[qindex.value]
                                                              .options[index]
                                                              .optionText,
                                                          style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            // fontSize: 15,
                                                          ),
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .visible,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                              Row(
                                mainAxisAlignment: qindex.value > 0
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.end,
                                children: [
                                  if (qindex.value > 0)
                                    MaterialButton(
                                      height: 40,
                                      color: ColorPage.appbarcolorcopy,
                                      padding: EdgeInsets.all(16),
                                      shape: ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  if (qindex.value < mcqData.length)
                                    MaterialButton(
                                      height: 40,
                                      color: ColorPage.appbarcolorcopy,
                                      padding: EdgeInsets.all(16),
                                      shape: ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      onPressed: () {
                                        if (qindex.value < mcqData.length - 1) {
                                          qindex.value++;
                                          _pageController.jumpToPage(qindex
                                              .value); // Navigate to the next page
                                        } else {
                                          onExitexmPage(context,(){
                                         Navigator.pop(context);
                                          updateTblMCQhistory(widget.paperId, lastattemp!=""?lastattemp:widget.attemp, calculatePercentage(userAns,answer).toString(), DateTime.now().toString(), context).then((_){
                                            userAns.clear();
                                    setState(() {
                                      lastattemp=DateTime.now().toString();
                                        inserTblMCQhistory(widget.paperId,'Quick Practice',widget.paperName,'','',lastattemp,"0");
                                      qindex.value = 0;
                                    });


                                        });

                                      },(){
                                           updateTblMCQhistory(widget.paperId, lastattemp!=""?lastattemp:widget.attemp, calculatePercentage(userAns,answer).toString(), DateTime.now().toString(), context);
                                        Navigator.pop(context);
                                           Navigator.pop(context);


                                      });
                                          // Reset to the first page
                                        }
                                      },
                                      child: Text(
                                        qindex.value == mcqData.length - 1
                                            ? 'Submit & Reset'
                                            : 'Next',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
           
          ],
        ),
      ),
    );
  }

 onExitexmPage(context, VoidCallback ontap,VoidCallback onCanceltap) {
  Alert(
    context: context,
    type: AlertType.info,
    style: AlertStyle(
      titleStyle: TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
      descStyle: FontFamily.font6,
      isCloseButton: false,
    ),
    title: "Are you sure you ?",
    desc: "You can Restart the Practice.",
    buttons: [
      DialogButton(
        child:
            Text("Exit", style: TextStyle(color: Colors.white, fontSize: 18)),
        highlightColor: Color.fromRGBO(3, 77, 59, 1),
        onPressed: onCanceltap,
        color: Colors.red,
      ),
      DialogButton(
        child: Text("Restart", style: TextStyle(color: Colors.white, fontSize: 18)),
        highlightColor: Color.fromRGBO(3, 77, 59, 1),
        onPressed: ontap,
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
            setState(() {});
            Navigator.pop(context);
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }
}

double calculatePercentage(Map<int, List<int>> userAns, List<dynamic> answer) {
  try {
    int correctAnswers = 0; // To count the number of correct answers
    int totalAnsweredQuestions = 0; // To count how many questions have been attempted
    int totalQuestions = answer.length; // Total questions in the quiz
    double totalScore = 0.0; // To calculate the total score percentage

    userAns.forEach((questionId, selectedOptionIds) {
      // Get the list of correct answers for the current question
      List<int> correctAnswersForQuestion = answer
          .firstWhere((map) => map.containsKey(questionId))[questionId]!
          .toList();

      // Skip if the question was not attempted (i.e., no options selected)
      if (selectedOptionIds.isEmpty) {
        return;
      }

      // Calculate how many correct answers were selected by the user
      int correctSelected = 0;
      selectedOptionIds.forEach((selectedOptionId) {
        if (correctAnswersForQuestion.contains(selectedOptionId)) {
          correctSelected++; // Count the correct selected answers
        }
      });

      // Partial score for this question: correctSelected / total possible correct answers
      double questionScore = (correctSelected / correctAnswersForQuestion.length) * 100;

      // Add to the total score
      totalScore += questionScore;

      // Increment the number of answered questions
      totalAnsweredQuestions++;

      // Increment correct answers if all selected options were correct
      if (correctSelected == correctAnswersForQuestion.length) {
        correctAnswers++;
      }
    });

    // If no questions were answered, return 0% to prevent division by zero
    if (totalAnsweredQuestions == 0) {
      return 0.0;
    }

    // Calculate the percentage based on total score of attempted questions
    double percentage = totalScore / totalAnsweredQuestions;

    // Adjust the total percentage to the total number of questions (normalize)
    double finalPercentage = (percentage * totalAnsweredQuestions) / totalQuestions;

    print("Total Answered Questions: $totalAnsweredQuestions");
    print("Correct Answers: $correctAnswers");
    print("Final Percentage: $finalPercentage%");

    return finalPercentage;
  } catch (e) {
    writeToFile(e,"calculatePercentage" );
    print("Error calculating percentage: $e");
    return 0.0;
  }
}
