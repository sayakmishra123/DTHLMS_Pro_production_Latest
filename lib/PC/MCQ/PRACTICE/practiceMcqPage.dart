import 'dart:async';
import 'dart:convert';

import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/PC/MCQ/modelclass.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PracticeMcq extends StatefulWidget {
  final List mcqlist;
  final List answerList;
  final String attempt;

  final String paperId;
  final String examStartTime;
  final String paperName;
  final String duration;

  const PracticeMcq(
      {super.key,
      required this.mcqlist,
      required this.attempt,
      required this.answerList,
      required this.duration,
      required this.examStartTime,
      required this.paperId,
      required this.paperName});

  @override
  State<PracticeMcq> createState() => _PracticeMcqState();
}

class _PracticeMcqState extends State<PracticeMcq> {
  List answer = [];
  // Store user answers, allowing multiple answers for each question
  Map<int, List<int>> userAns = {};

  Getx getx_obj = Get.put(Getx());
  RxBool buttonshow = false.obs;
  String lastattemp = "";

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
  }

  List sectionWiseQuestionIdList = [];
  @override
  void dispose() {
    super.dispose();
  }



  List<int> reviewlist = [];

  RxInt qindex = 0.obs;
  int selectedIndex = -1;
  RxBool isSubmitted = false.obs;
  RxInt score = 0.obs;

  List<McqItem> mcqData = [];
  List correctAnswerListOfStudent = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorPage.white),
        automaticallyImplyLeading: true,
        centerTitle: false,
        backgroundColor: ColorPage.appbarcolor,
        title: Text(
          widget.paperName,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: Obx(() => SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SizedBox(
                      height: height,
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
                                  padding: EdgeInsets.symmetric(vertical: 15),
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
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    children: [
                                      Text(
                                        textAlign: TextAlign.center,
                                        mcqData[qindex.value].questionText,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                      if (mcqData[qindex.value]
                                              .mCQQuestionType ==
                                          "ImageBasedAnswer")
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Image.network(
                                              mcqData[qindex.value]
                                                  .documnetUrl),
                                        ),
                                      if (mcqData[qindex.value]
                                              .mCQQuestionType ==
                                          "VideoBasedAnswer")
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                          ),
                                        ),
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
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SizedBox(
                      height: height,
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
                                      ]),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'Options',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
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
                          SizedBox(
                              height: MediaQuery.of(context).size.height - 200,
                              child: ListView.builder(
                                itemCount: mcqData[qindex.value].options.length,
                                itemBuilder: (context, index) {
                                  String optionId = mcqData[qindex.value]
                                      .options[index]
                                      .optionId;
                                  String questionId =
                                      mcqData[qindex.value].questionId;

                                  // Get the correct answers for the current question
                                  List<int> correctAnswersForQuestion = answer
                                      .firstWhere((map) =>
                                          map.containsKey(
                                              int.parse(questionId)))[
                                          int.parse(questionId)]!
                                      .toList();

                                  // Check if the option is selected
                                  bool isSelected = userAns
                                          .containsKey(int.parse(questionId)) &&
                                      userAns[int.parse(questionId)]!
                                          .contains(int.parse(optionId));

                                  // Check if the option is correct
                                  bool isCorrect = correctAnswersForQuestion
                                      .contains(int.parse(optionId));

                                  // Determine the color of the tile
                                  Color tileColor;
                                  if (isSelected) {
                                    tileColor =
                                        isCorrect ? Colors.green : Colors.red;
                                  } else if (userAns
                                          .containsKey(int.parse(questionId)) &&
                                      userAns[int.parse(questionId)]!.length >=
                                          correctAnswersForQuestion.length) {
                                    // Reveal correct answers in green after max selections
                                    tileColor =
                                        isCorrect ? Colors.green : Colors.white;
                                  } else {
                                    tileColor = Colors.white;
                                  }

                                  // Determine if selection should be disabled
                                  bool isSelectionDisabled = userAns
                                          .containsKey(int.parse(questionId)) &&
                                      ((mcqData[qindex.value].isMultiple ==
                                                  'true' &&
                                              userAns[int.parse(questionId)]!
                                                      .length >=
                                                  correctAnswersForQuestion
                                                      .length) ||
                                          mcqData[qindex.value].isMultiple ==
                                              'false');

                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: tileColor,
                                        borderRadius: BorderRadius.circular(8),
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
                                              if (isSelectionDisabled) return;

                                              if (mcqData[qindex.value]
                                                      .isMultiple ==
                                                  'true') {
                                                // Multi-select option with limit check
                                                if (userAns.containsKey(
                                                    int.parse(questionId))) {
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
                                                  userAns[
                                                      int.parse(questionId)] = [
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
                                                    isSelectionDisabled = true;
                                                  });
                                                }
                                              } else {
                                                // Single selection, replace existing answer
                                                userAns[int.parse(questionId)] =
                                                    [int.parse(optionId)];
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Text(
                                                      mcqData[qindex.value]
                                                          .options[index]
                                                          .optionText,
                                                      style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        // fontSize: 15,
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.visible,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MaterialButton(
                                height: 40,
                                color: ColorPage.appbarcolorcopy,
                                padding: EdgeInsets.all(16),
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                onPressed: () {
                                  if (qindex.value > 0) {
                                    qindex.value--;
                                  }
                                },
                                child: Text(
                                  'Previous',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              MaterialButton(
                                height: 40,
                                color: ColorPage.appbarcolorcopy,
                                padding: EdgeInsets.all(16),
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                onPressed: () {
                                  if (qindex.value < mcqData.length - 1) {
                                    qindex.value++;
                                  } else if (qindex.value ==
                                      mcqData.length - 1) {
                                    onExitexmPage(context, () {
                                      Navigator.pop(context);
                                      updateTblMCQhistory(
                                              widget.paperId,
                                              lastattemp != ""
                                                  ? lastattemp
                                                  : widget.attempt,
                                              calculatePercentage(
                                                      userAns, answer)
                                                  .toString(),
                                              DateTime.now().toString(),
                                              context)
                                          .then((_) {
                                        userAns.clear();
                                        setState(() {
                                          lastattemp =
                                              DateTime.now().toString();
                                          inserTblMCQhistory(
                                              widget.paperId,
                                              'Quick Practice',
                                              widget.paperName,
                                              '',
                                              '',
                                              lastattemp,
                                              "0");
                                          qindex.value = 0;
                                        });
                                      });
                                    }, () {
                                      updateTblMCQhistory(
                                          widget.paperId,
                                          lastattemp != ""
                                              ? lastattemp
                                              : widget.attempt,
                                          calculatePercentage(userAns, answer)
                                              .toString(),
                                          DateTime.now().toString(),
                                          context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });

                                    // _onSubmitExam(context);
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
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        child: Container(
                          width: 350,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              onExpansionChanged: (Value) {
                                buttonshow.value = Value;
                              },
                              shape: Border.all(color: Colors.transparent),
                              backgroundColor: ColorPage.white,
                              collapsedBackgroundColor: ColorPage.white,
                              title: Text("All Questions"),
                              children: [
                                Container(
                                    height: 55 *
                                            ((widget.mcqlist.length ~/ 4) + 1) +
                                        sectionWiseQuestionIdList.length * 110,
                                    child: ListView.builder(
                                        itemCount:
                                            sectionWiseQuestionIdList.length,
                                        itemBuilder: (context, index) {
// print(sectionWiseQuestionIdList.length);
// String rawdata=jsonEncode(sectionWiseQuestionIdList[index]);
                                          Map<int, List<int>> data =
                                              sectionWiseQuestionIdList[index];
                                          List<int> indexList =
                                              data.values.first;
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        fetchSectionName(data
                                                            .keys
                                                            .toString()
                                                            .replaceAll("(", "")
                                                            .replaceAll(
                                                                ")", ""))),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 80 *
                                                    ((indexList.length ~/ 4) +
                                                        1),
                                                child: GridView.builder(
                                                    itemCount: indexList.length,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 4),
                                                    itemBuilder:
                                                        (context, ind) {
                                                      // Get section ID and cumulative offset
                                                      int sectionId =
                                                          data.keys.first;
                                                      int offset =
                                                          sectionOffsets[
                                                              sectionId]!;
                                                      print(answer);
                                                      print(userAns[
                                                          indexList[ind]]);

                                                      return SingleChildScrollView(
                                                        child: MaterialButton(
                                                          height: 55,
                                                          color: reviewlist
                                                                  .contains(
                                                                      offset +
                                                                          ind)
                                                              ? Colors.amber
                                                              : userAns.containsKey(
                                                                      indexList[
                                                                          ind])
                                                                  ? answer.any((map) => map
                                                                          .values
                                                                          .any((List<int> list) =>
                                                                              list.any((item) => userAns[indexList[ind]]!.contains(item))))
                                                                      ? Colors.green
                                                                      : Colors.red
                                                                  : qindex.value == offset + ind
                                                                      ? Color.fromARGB(255, 13, 32, 79)
                                                                      : Colors.white,
                                                          shape: CircleBorder(
                                                              side: BorderSide(
                                                                  width: qindex
                                                                              .value ==
                                                                          offset +
                                                                              ind
                                                                      ? 4
                                                                      : 1,
                                                                  color: qindex
                                                                              .value ==
                                                                          offset +
                                                                              ind
                                                                      ? ColorPage
                                                                          .white
                                                                      : Colors
                                                                          .black12)),
                                                          onPressed: () {
                                                            qindex.value =
                                                                offset + ind;
                                                          },
                                                          child: Text(
                                                            (ind + 1)
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: qindex
                                                                            .value ==
                                                                        offset +
                                                                            ind
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
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
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

// import 'package:collection/collection.dart';  // Required for ListEquality

  double calculatePercentage(
      Map<int, List<int>> userAns, List<dynamic> answer) {
    try {
      int correctAnswers = 0; // To count the number of correct answers
      int totalAnsweredQuestions =
          0; // To count how many questions have been attempted
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
        double questionScore =
            (correctSelected / correctAnswersForQuestion.length) * 100;

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
      double finalPercentage =
          (percentage * totalAnsweredQuestions) / totalQuestions;

      print("Total Answered Questions: $totalAnsweredQuestions");
      print("Correct Answers: $correctAnswers");
      print("Final Percentage: $finalPercentage%");

      return finalPercentage;
    } catch (e) {
      writeToFile(e, "calculatePercentage");
      print("Error calculating percentage: $e");
      return 0.0;
    }
  }
}

List<Map<int, List<int>>> groupQuestionsBySection(List questions) {
  Map<int, List<int>> groupedQuestions = {};

  for (var question in questions) {
    int sectionId = int.parse(question['SectionId'].toString());
    int questionId = int.parse(question['questionid'].toString());

    if (!groupedQuestions.containsKey(sectionId)) {
      groupedQuestions[sectionId] = [];
    }

    groupedQuestions[sectionId]!.add(questionId);
  }

  // Convert the map to the desired list format
  List<Map<int, List<int>>> result = [];
  groupedQuestions.forEach((key, value) {
    result.add({key: value});
  });

  return result;
}

onExitexmPage(context, VoidCallback ontap, VoidCallback onCanceltap) {
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
        child: Text("Restart",
            style: TextStyle(color: Colors.white, fontSize: 18)),
        highlightColor: Color.fromRGBO(3, 77, 59, 1),
        onPressed: ontap,
        color: Color.fromRGBO(9, 89, 158, 1),
      ),
    ],
  ).show();
}
