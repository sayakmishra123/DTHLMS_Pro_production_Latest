import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/PC/testresult/indicator.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../math_equation.dart';

class MockTestresult extends StatefulWidget {
  final String paperId;
  final List questionData;
  final String totalmarks;
  final String type;
  final String submitedOn;
  final String paperName;
  final bool isAnswerSheetShow;

  const MockTestresult({
    required this.paperId,
    required this.questionData,
    required this.totalmarks,
    required this.type,
    required this.submitedOn,
    required this.paperName,
    required this.isAnswerSheetShow,
  });
  @override
  State<MockTestresult> createState() => _MockTestresultState();
}

class _MockTestresultState extends State<MockTestresult>
    with SingleTickerProviderStateMixin {
  bool _isLottieVisible = true;
  late AnimationController _animationController;
  Getx getxController = Get.put(Getx());
  bool isPass = false;

  // RxMap userRankDetails = {}.obs;

  var rankStyle = TextStyle(fontSize: 16);
  int totalMarks = 0;
  String totalRequiredMarks = "";

  @override
  void initState() {
    super.initState();

    // print(widget.type+"shubha this is the type of result moctest");

    print(widget.isAnswerSheetShow.toString() + "/////////////////////////");
    totalRequiredMarks = getRequiredMarksForPaperId(widget.paperId);
    super.initState();
    getRankDataOfMockTest2(context, getx.loginuserdata[0].token, widget.paperId)
        .whenComplete(() {});

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isLottieVisible = false;
          });
        }
      });

    double.parse(totalRequiredMarks) < calculateTotalMarks(widget.questionData)
        ? _animationController.forward()
        : null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int touchedIndex = -1;

  TextStyle headerStyle = TextStyle(color: Colors.blue, fontSize: 20);
  TextStyle studentTitleStyle = TextStyle(fontSize: 20, color: Colors.black);
  TextStyle studentNameStyle = TextStyle(fontSize: 20, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    String usermarks = calculateTotalMarks(widget.questionData) < 0
        ? "0"
        : calculateTotalMarks(widget.questionData).toString();

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        actions: [
          Padding(
            padding: EdgeInsets.only(right: width / 4),
            child: Text("QNA", style: FontFamily.font),
          )
        ],

        // iconTheme: IconThemeData(color: ColorPage.white),
        backgroundColor: ColorPage.white,
        title: Text(
          "ScoreBoard",
          style: FontFamily.font,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                // padding: EdgeInsets.all(8),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ColorPage
                                  .colorbutton, // Main purple background color
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatColumn(Icons.numbers_outlined,
                                    'Total Marks', widget.totalmarks),
                                _buildDivider(),
                                _buildStatColumn(
                                    Icons.star,
                                    'Your Marks',
                                    widget.type == "Ranked Competition"
                                        ? '${getx.userRankDetails["TotalMarks"]}'
                                        : usermarks),
                                _buildDivider(),
                                _buildStatColumn(
                                    Icons.question_mark_sharp,
                                    'Total Question',
                                    '${widget.questionData.length}'),
                              ],
                            ),
                          ),
                          widget.type == "Comprehansive"
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        // Calculate half the width dynamically
                                        double halfWidth =
                                            constraints.maxWidth / 2 - 11;

                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: halfWidth,
                                              height: 310,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(20),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .person_outline_rounded,
                                                                  size: 30,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      'Basic Info',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blue,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: RichText(
                                                                text: TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text:
                                                                              'Name: ',
                                                                          style:
                                                                              studentTitleStyle),
                                                                      TextSpan(
                                                                          text: getx.loginuserdata[0].firstName +
                                                                              " " +
                                                                              getx.loginuserdata[0].lastName,
                                                                          style: studentNameStyle),
                                                                    ]),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: RichText(
                                                                text: TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text:
                                                                              'Submitted on: ',
                                                                          style:
                                                                              studentTitleStyle),
                                                                      TextSpan(
                                                                          text: formatDate(widget
                                                                              .submitedOn),
                                                                          style:
                                                                              studentNameStyle),
                                                                    ]),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                RichText(
                                                                  text: TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                            text:
                                                                                'Status: ',
                                                                            style:
                                                                                TextStyle(fontSize: 18, color: Colors.black)),
                                                                        TextSpan(
                                                                            text: double.parse(totalRequiredMarks) < calculateTotalMarks(widget.questionData)
                                                                                ? "Pass"
                                                                                : "Fail",
                                                                            style:
                                                                                TextStyle(fontSize: 18, color: double.parse(totalRequiredMarks) < calculateTotalMarks(widget.questionData) ? Colors.green : Colors.redAccent))
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
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: halfWidth,
                                              height: 310,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 25),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          height: 200,
                                                          width: 200,
                                                          child: PieChart(
                                                            PieChartData(
                                                              pieTouchData:
                                                                  PieTouchData(
                                                                touchCallback:
                                                                    (FlTouchEvent
                                                                            event,
                                                                        pieTouchResponse) {
                                                                  setState(() {
                                                                    if (!event
                                                                            .isInterestedForInteractions ||
                                                                        pieTouchResponse ==
                                                                            null ||
                                                                        pieTouchResponse.touchedSection ==
                                                                            null) {
                                                                      touchedIndex =
                                                                          -1;
                                                                      return;
                                                                    }
                                                                    touchedIndex =
                                                                        pieTouchResponse
                                                                            .touchedSection!
                                                                            .touchedSectionIndex;
                                                                  });
                                                                },
                                                              ),
                                                              borderData:
                                                                  FlBorderData(
                                                                      show:
                                                                          false),
                                                              sectionsSpace: 0,
                                                              centerSpaceRadius:
                                                                  40,
                                                              sections:
                                                                  showingSections(),
                                                            ),
                                                          ),
                                                        ),
                                                        halfWidth > 400
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <Widget>[
                                                                  Indicator(
                                                                    color: AppColors
                                                                        .contentColorBlue,
                                                                    text:
                                                                        'Remaining Marks',
                                                                    isSquare:
                                                                        true,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Indicator(
                                                                    color: AppColors
                                                                        .contentColorYellow,
                                                                    text:
                                                                        'Obtain Marks',
                                                                    isSquare:
                                                                        true,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                ],
                                                              )
                                                            : SizedBox()
                                                      ],
                                                    ),
                                                    halfWidth < 400
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <Widget>[
                                                                  Indicator(
                                                                    color: AppColors
                                                                        .contentColorBlue,
                                                                    text:
                                                                        'Remaining Marks',
                                                                    isSquare:
                                                                        true,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Indicator(
                                                                    color: AppColors
                                                                        .contentColorYellow,
                                                                    text:
                                                                        'Obtain Marks',
                                                                    isSquare:
                                                                        true,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        : SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
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
                                                    DataCell(
                                                        Text(widget.paperName)),
                                                    DataCell(Text(
                                                        widget.totalmarks)),
                                                    DataCell(Text(
                                                        calculateTotalMarks(widget
                                                                .questionData)
                                                            .toString())),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  20), // Space between the table and the row
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          'Total Marks Required: ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black)),
                                                  TextSpan(
                                                      text: totalRequiredMarks,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.blue)),
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          widget.type == "Ranked Competition"
                              ? Container(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            'Rank',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Score',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          widget.type == "Ranked Competition"
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .6,
                                  child: Obx(
                                    () => ListView.builder(
                                      // addSemanticIndexes: true,
                                      itemCount: getx.rankerList.length,
                                      itemBuilder: (context, index) {
                                        print(
                                            getx.rankerList.length.toString());

                                        return Card(
                                          elevation: 0,
                                          surfaceTintColor: Colors.transparent,
                                          color: Colors.white,

                                          // color: Colors.white,

                                          // surfaceTintColor: Colors.blue,
                                          shape: ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: ListTile(
                                            leading: getx.rankerList[index]
                                                        ['Rank'] ==
                                                    1
                                                ? SizedBox(
                                                    height: 35,
                                                    child: Image.asset(
                                                        'assets/rank1.png'))
                                                : getx.rankerList[index]
                                                            ['Rank'] ==
                                                        2
                                                    ? SizedBox(
                                                        height: 35,
                                                        child: Image.asset(
                                                            'assets/rank2.png'))
                                                    : getx.rankerList[index]
                                                                ['Rank'] ==
                                                            3
                                                        ? SizedBox(
                                                            height: 35,
                                                            child: Image.asset(
                                                                'assets/rank3.png'))
                                                        : Text(
                                                            '#${getx.rankerList[index]['Rank']}',
                                                            style: GoogleFonts
                                                                .inter(
                                                              textStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                          ),
                                            title: Center(
                                              child: Text(
                                                '${getx.rankerList[index]['StudentName']}',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            trailing: Text(
                                              '${getx.rankerList[index]['TotalMarks']}',
                                              style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                  color: Colors.red[400],
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    widget.type == "Ranked Competition"
                        ? Positioned(
                            bottom: 20,
                            left: 5,
                            right: 5,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: ColorPage.appbarcolorcopy,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Obx(
                                  () => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          getx.userRankDetails["Rank"]
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Text(
                                          getx.userRankDetails["StudentName"]
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Text(
                                          getx.userRankDetails["TotalMarks"]
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Visibility(
                      visible: _isLottieVisible,
                      child: Positioned(
                        left: 5,
                        right: 5,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: LottieBuilder.asset(
                              'assets/C2.json',
                              repeat: false,
                              controller: _animationController,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                  child: widget.isAnswerSheetShow
                      ? ListView.builder(
                          itemCount: widget.questionData.length,
                          itemBuilder: (context, index) {
                            totalMarks = 0;
                            bool isCorrect = widget.questionData[index]
                                    ['correctanswerId']
                                .toSet()
                                .containsAll(widget.questionData[index]
                                    ['userselectedanswer id']);
                            // int marks = isCorrect ? 1 : 0;
                            // totalMarks += marks;
                            print(totalMarks.toString());
                            return Container(
                              margin: EdgeInsets.only(top: 10),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: widget.questionData[index]
                                              ['question name']
                                          .toString()
                                          .contains('<?xml')
                                      ? MathEquation(
                                          mathMl:
                                              '${index + 1}. ${widget.questionData[index]['question name']}',
                                        )
                                      : Text(
                                          '${index + 1}. ${widget.questionData[index]['question name']}',
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                ),
                                subtitle: Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Your Answer :",
                                          style: TextStyle(
                                            color: Colors
                                                .blue, // Choose your preferred color
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        widget.questionData[index]
                                                    ['userselectedanswer']
                                                .toString()
                                                .contains('<?xml')
                                            ? MathEquation(
                                                mathMl: widget
                                                    .questionData[index]
                                                        ['userselectedanswer']
                                                    .join(","),
                                              )
                                            : RichText(
                                                text: TextSpan(
                                                  text:
                                                      '${widget.questionData[index]['userselectedanswer'].join(", ")}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Correct Answer: ",
                                          style: TextStyle(
                                            color: Colors
                                                .green, // Choose your preferred color
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        widget.questionData[index]
                                                    ['correctanswer']
                                                .toString()
                                                .contains('<?xml')
                                            ? MathEquation(
                                                mathMl: widget
                                                    .questionData[index]
                                                        ['correctanswer']
                                                    .join(","),
                                              )
                                            : RichText(
                                                text: TextSpan(
                                                  text: getQuestionTypeFromId(widget
                                                              .questionData[
                                                                  index]
                                                                  ['questionid']
                                                              .toString()) ==
                                                          "One Word Answer"
                                                      ? getOneWordAnswerFromQuestionId(
                                                          widget.questionData[
                                                                  index]
                                                                  ['questionid']
                                                              .toString())
                                                      : '${widget.questionData[index]['correctanswer'].join(", ")}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.type == "Ranked Competition"
                                        ? widget.questionData[index]
                                                ['ObtainMarks']
                                            .toString()
                                        : calculateTotalMarkOfQuestion(
                                                widget.questionData[index]
                                                        ['questionid']
                                                    .toString(),
                                                widget.questionData[index]
                                                    ['userselectedanswer id'],
                                                getQuestionTypeFromId(widget
                                                    .questionData[index]
                                                        ['questionid']
                                                    .toString()))
                                            .toString(),
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 71, 71, 71),
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                            );
                          })
                      : Center(
                          child: Text(
                              " The answer sheet is not authorized for display "),
                        )),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double remainingMarks = double.parse(widget.totalmarks) -
        calculateTotalMarks(widget.questionData);

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
            value: calculateTotalMarks(widget.questionData),
            title: calculateTotalMarks(widget.questionData).toString(),
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

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 150,
      color: Colors.white.withOpacity(0.5),
      margin: EdgeInsets.symmetric(horizontal: 10),
    );
  }

  Widget _buildStatColumn(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30),
        Icon(icon, color: Colors.white, size: 34),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 60),
      ],
    );
  }
}

double calculateTotalMarkOfQuestion(
    String questionId, List userSelectedQuestionId, String type) {
  double totalMark = 0.0;
  // print(userSelectedQuestionId.length.toString()+"///////////////////////////////////////////////////////");
  if (userSelectedQuestionId.length != 0) {
    if (type == "One Word Answer") {
      String answer = getOneWordAnswerFromQuestionId(questionId.toString())
          .replaceAll(" ", "");
      print(answer);
      String userAns =
          getOneWordAnswerFromQuestionIdofStudent(questionId.toString())
              .replaceAll(" ", "");
      print(userAns);
      if (answer.toLowerCase() == userAns.toLowerCase()) {
        totalMark += fetchMCQPartialCorrectMarks(
            userSelectedQuestionId[0].toString(), questionId);
      } else {
        totalMark += fetchMCQPartialNegativeMarks(
            userSelectedQuestionId[0].toString(), questionId);
      }
      double negetiveMarks =
          fetchnagetivemarksFromsection(fetchsectionIdfromquestion(questionId));
      return negetiveMarks * -1 > totalMark ? negetiveMarks * -1 : totalMark;
    } else {
      for (var i = 0; i < userSelectedQuestionId.length; i++) {
        totalMark += fetchMCQPartialCorrectMarks(
                userSelectedQuestionId[i].toString(), questionId) -
            fetchMCQPartialNegativeMarks(
                userSelectedQuestionId[i].toString(), questionId);
      }

      double negetiveMarks =
          fetchnagetivemarksFromsection(fetchsectionIdfromquestion(questionId));

      return negetiveMarks * -1 > totalMark ? negetiveMarks * -1 : totalMark;
    }
  }
  return 0.0;
}

double calculateTotalMarks(List questionData) {
  double totalMarks = 0.0;
  for (var data in questionData) {
    totalMarks += calculateTotalMarkOfQuestion(
        data['questionid'].toString(),
        data['userselectedanswer id'],
        getQuestionTypeFromId(data['questionid'].toString()));
  }
  return totalMarks;
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
