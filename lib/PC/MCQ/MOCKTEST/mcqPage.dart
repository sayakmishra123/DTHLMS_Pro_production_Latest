// import 'dart:async';
import 'dart:async';
import 'dart:convert';

import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/PC/MCQ/MOCKTEST/resultMcqTest.dart';
import 'package:dthlms/PC/MCQ/modelclass.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';

import 'package:dthlms/GLOBAL_WIDGET/mybutton.dart';
import 'package:dthlms/utctime.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:collection/collection.dart';

import '../../../API/ALL_FUTURE_FUNTIONS/all_functions.dart';

class MockTestMcqExamPage extends StatefulWidget {
  final List mcqlist; 
  final List answerList;
  final String paperId;
  final String examStartTime;
  final String paperName;
  final String duration;
  final String totalmarks;
  final String attempt;
  final bool isAnswerSheetShow;

  const MockTestMcqExamPage(
      {super.key,
      required this.mcqlist,
      required this.answerList,
      required this.paperId,
      required this.totalmarks,
      required this.examStartTime,
      required this.paperName,
      required this.duration, 
      required this.attempt, required this.isAnswerSheetShow});

  @override
  State<MockTestMcqExamPage> createState() => _MockTestMcqExamPageState();
}

class _MockTestMcqExamPageState extends State<MockTestMcqExamPage> {
  // Store correct answers, allowing multiple answers for a question
// List<Map<int, List<int>>> answer = [
//     {270: [880]},
//     {272: [888]},
//     {271: [884]},
//   ];

  List<Map<String, dynamic>> submitedData = [];

  List answer = [];
  // Store user answers, allowing multiple answers for each question
  Map<int, List<int>> userAns = {};

  late Timer _timer;
  Getx getx_obj = Get.put(Getx());
  RxBool buttonshow = false.obs;
  RxInt _start = 100.obs;

  Future<void> getdata() async {
    print(widget.mcqlist);
    // Assuming widget.mcqlist is a valid JSON string
    String jsonData = jsonEncode(widget.mcqlist);

    List<dynamic> parsedJson = jsonDecode(jsonData);
    List<McqItem> mcqDatalist =
        parsedJson.map((json) => McqItem.fromJson(json)).toList();
    mcqData = mcqDatalist;
  }

  // Future getdata() async {
  //   String jsonData ='''
  //   ${widget.mcqlist}
 
  //   ''';

  //   List<dynamic> parsedJson = jsonDecode(jsonData);
  //   List<McqItem> mcqDatalist =
  //       parsedJson.map((json) => McqItem.fromJson(json)).toList();
  //   mcqData = mcqDatalist;
  // }

  Map<int, int> sectionOffsets = {};

  @override
  void initState() {
    _start.value= int.parse(widget.duration)*60;
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
    startTimer();
  }

  List sectionWiseQuestionIdList = [];
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start.value == 0) {
          timer.cancel();
          _onTimeUp(context);
        } else {
          _start.value--;
        }
      },
    );
  }
 
  String get timerText {
    int hours = _start.value ~/ 3600;
    int minutes = (_start.value % 3600) ~/ 60;
    int seconds = _start.value % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String groupname = 'Group A';

  List<int> reviewlist = [];

  RxInt qindex = 0.obs;
  int selectedIndex = -1;
  RxBool isSubmitted = false.obs;
  RxInt score = 0.obs;

  List<McqItem> mcqData = [];
  String lastattemp="";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Obx(() => Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            iconTheme: IconThemeData(color: ColorPage.white),
            automaticallyImplyLeading: true,
            centerTitle: false,
            backgroundColor: ColorPage.appbarcolor,
            title: Text(
              widget.paperName,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        'Remaining Time ',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                      Icon(
                        Icons.watch_later_outlined,
                        color: ColorPage.white,
                      ),
                      Text(
                        ' $timerText',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  isSubmitted.value
                      ? Row(
                          children: [
                            MyButton(
                                btncolor: Colors.white,
                                onPressed: () async {
                                  print(widget.mcqlist.toString() + "555");
                                  print("mcq data\n\n\n");
                                  print(userAns);
                                  print("user ans\n\n\n");
                                  print(answer); 
                                  print("answer \n\n\n");
                                  List rankdata = await getRankDataOfMockTest(
                                      context,
                                      getx.loginuserdata[0].token,
                                      widget.paperId);
                                  Navigator.pop(context);
                                  Get.off(() => MockTestresult(
                                        totalmarks: widget.totalmarks,
                                        paperId: widget.paperId,
                                        questionData: submitedData,
                                        type: "Comprehensive",
                                        submitedOn: DateTime.now().toString(),
                                        paperName: widget.paperName,
                                        isAnswerSheetShow: widget.isAnswerSheetShow,
                                      ));
                                },
                                mychild: 'Result',
                                mycolor: Colors.orangeAccent),
                            SizedBox(width: 20),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ],
          ),
          body: Obx(() => SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: SizedBox(
                          height: height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: ListView.builder(
                                  itemCount:
                                      mcqData[qindex.value].options.length,
                                  itemBuilder: (context, index) {
                                    String optionId = mcqData[qindex.value]
                                        .options[index]
                                        .optionId;
                                    String questionId =
                                        mcqData[qindex.value].questionId;

                                    // Check if the option is selected
                                    bool isSelected = userAns.containsKey(
                                            int.parse(questionId)) &&
                                        userAns[int.parse(questionId)]!
                                            .contains(int.parse(optionId));

                                    // Check if the option is correct
                                    bool isCorrect = answer.any(
                                      (map) =>
                                          map.containsKey(
                                              int.parse(questionId)) &&
                                          map[int.parse(questionId)]!
                                              .contains(int.parse(optionId)),
                                    );

                                    Color tileColor;
                                    if (isSubmitted.value) {
                                      if (isCorrect) {
                                        tileColor = Colors.green;
                                      } else if (isSelected && !isCorrect) {
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 600),
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
                                                      int.parse(questionId))) {
                                                    if (mcqData[qindex.value]
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
                                                        int.parse(optionId)
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
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
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
                                                    overflow:
                                                        TextOverflow.visible,
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
                                  MaterialButton(
                                    height: 40,
                                    color: ColorPage.appbarcolorcopy,
                                    padding: EdgeInsets.all(16),
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    onPressed: () {
                                      if (qindex.value < mcqData.length - 1) {
                                        qindex.value++;
                                      } else if (qindex.value == 
                                              mcqData.length - 1 && 
                                          !isSubmitted.value) {
                                        _onSubmitComprehensiveExam(context);
                                      }
                                    }, 
                                    child: Text(
                                      !isSubmitted.value &&
                                              qindex.value == mcqData.length - 1
                                          ? 'Submit'
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                                                ((widget.mcqlist.length ~/ 4) +
                                                    1) +
                                            sectionWiseQuestionIdList.length *
                                                110,
                                        child: ListView.builder(
                                            itemCount: sectionWiseQuestionIdList
                                                .length,
                                            itemBuilder: (context, index) {
// print(sectionWiseQuestionIdList.length);
// String rawdata=jsonEncode(sectionWiseQuestionIdList[index]);
                                              Map<int, List<int>> data =
                                                  sectionWiseQuestionIdList[
                                                      index];
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
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            fetchSectionName(
                                                                data.keys
                                                                    .toString()
                                                                    .replaceAll(
                                                                        "(", "")
                                                                    .replaceAll(
                                                                        ")",
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
                                                        itemCount:
                                                            indexList.length,
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    4),
                                                        itemBuilder:
                                                            (context, ind) {
                                                          // Get section ID and cumulative offset
                                                          int sectionId =
                                                              data.keys.first;
                                                          int offset =
                                                              sectionOffsets[
                                                                  sectionId]!;

                                                          return SingleChildScrollView(
                                                            child:
                                                                MaterialButton(
                                                              height: 55,
                                                              color: reviewlist.contains(
                                                                          offset +
                                                                              ind) &&
                                                                      !isSubmitted
                                                                          .value
                                                                  ? Colors.amber
                                                                  : userAns.containsKey(
                                                                          indexList[
                                                                              ind])
                                                                      ? isSubmitted
                                                                              .value
                                                                          ? answer.any((map) => map.values.any((List<int> list) => list.any((item) => userAns[indexList[ind]]!.contains(item))))
                                                                              ? Colors.green
                                                                              : Colors.red
                                                                          : Colors.blue
                                                                      : qindex.value == offset + ind
                                                                          ? Color.fromARGB(255, 13, 32, 79)
                                                                          : Colors.white,
                                                              shape: CircleBorder(
                                                                  side: BorderSide(
                                                                      width: qindex.value ==
                                                                              offset +
                                                                                  ind
                                                                          ? 4
                                                                          : 1,
                                                                      color: qindex.value ==
                                                                              offset +
                                                                                  ind
                                                                          ? ColorPage
                                                                              .white
                                                                          : Colors
                                                                              .black12)),
                                                              onPressed: () {
                                                                qindex.value =
                                                                    offset +
                                                                        ind;
                                                              },
                                                              child: Text(
                                                                (ind + 1)
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: qindex.value ==
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
                                    // Container(
                                    //   height: 400,
                                    //   child: GridView.builder(
                                    //     itemCount: mcqData.length,
                                    //     gridDelegate:
                                    //         SliverGridDelegateWithFixedCrossAxisCount(
                                    //             crossAxisCount: 4),
                                    //     itemBuilder: (context, index) {
                                    //       return SingleChildScrollView(
                                    //         child: MaterialButton(
                                    //           height: 55,
                                    //           color: reviewlist.contains(index)
                                    //               ? Colors.amber
                                    //               : userAns.containsKey(index + 1)
                                    //                   ? isSubmitted.value
                                    //                       ? answer.any((map) =>
                                    //                               map[index + 1]!.contains(userAns[index + 1]!))
                                    //                           ? Colors.green
                                    //                           : Colors.red
                                    //                       : Colors.blue
                                    //                   : qindex.value == index
                                    //                       ? Color.fromARGB(
                                    //                           255, 13, 32, 79)
                                    //                       : Colors.white,
                                    //           shape: CircleBorder(
                                    //               side: BorderSide(
                                    //                   width: qindex.value == index
                                    //                       ? 4
                                    //                       : 1,
                                    //                   color: qindex.value == index
                                    //                       ? ColorPage.white
                                    //                       : Colors.black12)),
                                    //           onPressed: () {
                                    //             qindex.value = index;
                                    //           },
                                    //           child: Text(
                                    //             (index + 1).toString(),
                                    //             style: TextStyle(
                                    //                 color: qindex.value == index
                                    //                     ? Colors.white
                                    //                     : Colors.black),
                                    //           ),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                isSubmitted.value ? false : buttonshow.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  height: 40,
                                  color: Colors.orange,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  onPressed: () {
                                    print(qindex.value);
                                    if (!reviewlist.contains(qindex.value)) {
                                      reviewlist.add(qindex.value);
                                    }
                                  },
                                  child: Text(
                                    'Mark for Review',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                MaterialButton(
                                  height: 40,
                                  color: Colors.blueGrey,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  onPressed: () {
                                    reviewlist.remove(qindex.value);
                                  },
                                  child: Text(
                                    'Clear Response',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )

                    // Container(
                    //   child: Column(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             vertical: 5, horizontal: 15),
                    //         child: Container(
                    //           width: 270,
                    //           child: ClipRRect(
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(10)),
                    //             child:

                    //              ExpansionTile(
                    //               onExpansionChanged: (Value) {
                    //                 buttonshow.value = Value;
                    //               },
                    //               shape: Border.all(color: Colors.transparent),
                    //               backgroundColor: ColorPage.white,
                    //               collapsedBackgroundColor: ColorPage.white,
                    //               title: Text("All Questions"),
                    //               children: [
                    //                 Container(
                    //                   height: 400,
                    //                   child: GridView.builder(
                    //                     itemCount: mcqData.length,
                    //                     gridDelegate:
                    //                         SliverGridDelegateWithFixedCrossAxisCount(
                    //                             crossAxisCount: 4),
                    //                     itemBuilder: (context, index) {
                    //                       return SingleChildScrollView(
                    //                         child: MaterialButton(
                    //                           height: 55,
                    //                           color: reviewlist.contains(index)
                    //                               ? Colors.amber
                    //                               : userAns.containsKey(index + 1)
                    //                                   ? isSubmitted.value
                    //                                       ? answer.any((map) =>
                    //                                               map[index + 1]!.contains(userAns[index + 1]!))
                    //                                           ? Colors.green
                    //                                           : Colors.red
                    //                                       : Colors.blue
                    //                                   : qindex.value == index
                    //                                       ? Color.fromARGB(
                    //                                           255, 13, 32, 79)
                    //                                       : Colors.white,
                    //                           shape: CircleBorder(
                    //                               side: BorderSide(
                    //                                   width: qindex.value == index
                    //                                       ? 4
                    //                                       : 1,
                    //                                   color: qindex.value == index
                    //                                       ? ColorPage.white
                    //                                       : Colors.black12)),
                    //                           onPressed: () {
                    //                             qindex.value = index;
                    //                           },
                    //                           child: Text(
                    //                             (index + 1).toString(),
                    //                             style: TextStyle(
                    //                                 color: qindex.value == index
                    //                                     ? Colors.white
                    //                                     : Colors.black),
                    //                           ),
                    //                         ),
                    //                       );
                    //                     },
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),

                    //           ),
                    //         ),
                    //       ),
                    //       Visibility(
                    //         visible: isSubmitted.value ? false : buttonshow.value,
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             MaterialButton(
                    //               height: 40,
                    //               color: Colors.orange,
                    //               padding: EdgeInsets.symmetric(
                    //                   horizontal: 15, vertical: 5),
                    //               shape: ContinuousRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(12)),
                    //               onPressed: () {
                    //                 if (!reviewlist.contains(qindex.value)) {
                    //                   reviewlist.add(qindex.value);
                    //                 }
                    //               },
                    //               child: Text(
                    //                 'Mark for Review',
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               width: 30,
                    //             ),
                    //             MaterialButton(
                    //               height: 40,
                    //               color: Colors.blueGrey,
                    //               padding: EdgeInsets.symmetric(
                    //                   horizontal: 15, vertical: 5),
                    //               shape: ContinuousRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(12)),
                    //               onPressed: () {
                    //                 reviewlist.remove(qindex.value);
                    //               },
                    //               child: Text(
                    //                 'Clear Response',
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              )),
        ));
  }

//  void _onSubmitExam(BuildContext context) {

//   // Show the dialog with the answer summary if needed
//   // showAnswerSummaryDialog(context, resultJsonData);
// }

  _onSubmitComprehensiveExam(context) {


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

    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
        isOverlayTapDismiss: false,
        animationType: AnimationType.fromLeft,
        titleStyle:
            TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "Are You Sure?",
      desc:
          "Once You submit, You can't Change your Sheet \n If you are sure then Click on 'Yes' Button",
      buttons: [
        DialogButton(
          child: Text("Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromRGBO(77, 3, 3, 1),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(158, 9, 9, 1),
        ),
        DialogButton(
          child:
              Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromRGBO(77, 3, 3, 1),
          onPressed: () async {

                                           
                                               
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
              List<String> userSelectedAnswerTexts = selectedOptionIds
                      .isNotEmpty
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
                  selectedOptionIds.isNotEmpty
                      ? selectedOptionIds.toString()
                      : "[]",
                  userSelectedAnswerTexts.toString(),
                  "",
                  "",
                  "").then((_){

                  });
            }
            updateTblUserResultDetails(
                "true", widget.paperId, UtcTime().utctime().toString());
                

            // Log or display JSON data as needed
            print("Result JSON Data: ");
            print(resultJsonData);
//hello
            submitedData = resultJsonData;
            double totalMarks = calculateTotalMarks(resultJsonData);
    updateTblMCQhistory(widget.paperId, widget.attempt, totalMarks.toString(), DateTime.now().toString(), context);

        //  if(getx.isInternet.value){
        //      sendmarksToCalculateLeaderboard(
        //         context,
        //         getx.loginuserdata[0].token,
        //         totalMarks.toString(), 
        //         widget.paperId);
        //  }
            _timer.cancel();
            score.value = correctAnswers;
            isSubmitted.value = true;
            List rankdata = await getRankDataOfMockTest( 
                context, getx.loginuserdata[0].token, widget.paperId);
            Get.back();
            Get.off(() => MockTestresult(
                  paperId: widget.paperId,
                  questionData: submitedData,
                  totalmarks: widget.totalmarks,
                  type: "Comprehansive",
                  submitedOn: DateTime.now().toString(),
                  paperName: widget.paperName,
                  isAnswerSheetShow: widget.isAnswerSheetShow,
                ));
            // Navigator.pop(context);
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }
  double calculatePercentage(Map<int, List<int>> userAns, List<dynamic> answer) {
try{
    int correctAnswers = 0;
  int totalQuestions = userAns.length;

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

  // Calculate the percentage (handle case where totalQuestions might be 0)
  double percentage = totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0.0;

  return percentage;
}catch(e){
  return 0.0;
}
}

  _onTimeUp(context) {
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

    Alert(
      context: context,
      onWillPopActive: false,
      type: AlertType.info,
      style: AlertStyle(
        isOverlayTapDismiss: false,
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
            score.value = correctAnswers;
            isSubmitted.value = true;
            Navigator.pop(context);
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
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

  void showAnswerSummaryDialog(
      BuildContext context, List<Map<String, dynamic>> resultSummary) {
    Alert(
      context: context,
      type: AlertType.none,
      style: AlertStyle(
        isOverlayTapDismiss: false,
        animationType: AnimationType.fromTop,
        titleStyle:
            TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "Review Your Answers",
      content: Container(
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            children: resultSummary.map((result) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Q: ${result['questionText']}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Your Answer: ${result['userAnswer']}",
                        style: TextStyle(color: Colors.blue)),
                    Text("Correct Answer: ${result['correctAnswer']}",
                        style: TextStyle(color: Colors.green)),
                    Divider(),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      buttons: [
        DialogButton(
          child: Text("Close",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () {
            Navigator.pop(context);
            isSubmitted.value = true;
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }
}
