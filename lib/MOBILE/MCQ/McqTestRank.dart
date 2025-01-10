import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/MCQ/mockTestAns.dart';
import 'package:dthlms/PC/MCQ/MOCKTEST/resultMcqTest.dart';
import 'package:dthlms/PC/testresult/indicator.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:dthlms/THEME_DATA/font/font_family.dart';
// import 'package:dthlms/android/MCQ/mockTestAns.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../API/ALL_FUTURE_FUNTIONS/all_functions.dart';
// import 'package:path/path.dart';

class RankPage extends StatefulWidget {
  final String paperId;
  final List questionData;
  final String totalmarks;
  final bool frompaper;
  final bool isMcq;
  final String type;
  final String submitedOn;
  final String paperName;
  final bool isAnswerSheetShow;

  const RankPage(
      {required this.paperId,
      required this.questionData,
      required this.totalmarks,
      required this.frompaper,
      required this.isMcq,
      required this.type,
      required this.submitedOn,
      required this.paperName,
      required this.isAnswerSheetShow});
  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage>
    with SingleTickerProviderStateMixin {
  Getx getx = Get.put(Getx());
  // final List<McqItem> mcqData = Get.arguments['mcqData'];
  // final Map<int, int> userAns = Get.arguments['userAns'];
  // final List<Map<int, int>> correctAnswers = Get.arguments['correctAnswers'];
  // final int totalnomber = Get.arguments['totalnumber'];

  bool _isLottieVisible = true;
  late AnimationController _animationController;

  int totalMarks = 0;
  String totalRequiredMarks = "";

  void initState() {
    super.initState();
    totalRequiredMarks = getRequiredMarksForPaperId(widget.paperId);
    getRankDataOfMockTest2(
              context, getx.loginuserdata[0].token, widget.paperId)
          .whenComplete(() {});
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 8), // Adjust this duration to match your Lottie animation
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
    // Dispose of the AnimationController to free up resources
    _animationController.dispose();
    super.dispose();
  }

  var rankStyle = TextStyle(fontSize: 16);
  int touchedIndex = -1;

  TextStyle headerStyle = TextStyle(color: Colors.blue, fontSize: 14);
  TextStyle studentTitleStyle = TextStyle(fontSize: 20, color: Colors.black);
  TextStyle studentNameStyle = TextStyle(fontSize: 20, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
  String usermarks= calculateTotalMarks(widget.questionData)<0?"0":calculateTotalMarks(widget.questionData).toString();


    return WillPopScope(
      onWillPop: () async {
        if (!widget.frompaper) {
          Navigator.pop(context);
          Navigator.pop(context);
          // Navigator.pop(context);
          // Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
        // Navigator.pop(context);
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            bottomOpacity: 0.99,
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: ColorPage.appbarcolorcopy,
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  if (widget.isMcq) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.arrow_back_ios_new_outlined)),
            title: Text(
              'Scoreboard',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(
                        transition: Transition.cupertino,
                        () => MocktestAnswer(
                              paperId: widget.paperId,
                              questionData: widget.questionData,
                              type: widget.type,
                            ));
                  },
                  icon: Icon(Icons.list_alt_rounded))
            ],
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn(Icons.numbers_outlined,
                              'Total Marks', '${widget.totalmarks}'),
                          _buildDivider(),
                          _buildStatColumn(Icons.star, 'Your Marks', widget.type=="Ranked Competition"?'${  getx.userRankDetails["TotalMarks"]}':usermarks),

                          _buildDivider(),
                          _buildStatColumn(
                              Icons.question_mark_sharp,
                              'Total Question',
                              '${widget.questionData.length}'),
                        ],
                      ),
                    ),
                    widget.type == "Ranked Competition"
                        ? Column(
                            children: [
                              // Container(
                              //   decoration:
                              //       BoxDecoration(color: ColorPage.appbarcolorcopy),
                              //   width: MediaQuery.of(context).size.width / 2,
                              //   height: 200,
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: 130, vertical: 10),
                              //   child: Container(
                              //     color: const Color.fromARGB(0, 209, 29, 29),
                              //     child: Stack(
                              //       alignment: Alignment.topCenter,
                              //       children: [
                              //         Positioned(
                              //           top: 40,
                              //           left: 20,
                              //           child: Container(
                              //             padding: EdgeInsets.all(4),
                              //             decoration: BoxDecoration(
                              //               gradient: LinearGradient(
                              //                 begin: Alignment.topLeft,
                              //                 end: Alignment.bottomRight,
                              //                 colors: [
                              //                   Colors.white,
                              //                   Colors.white,
                              //                 ],
                              //               ),
                              //               borderRadius: BorderRadius.circular(4),
                              //             ),
                              //             child: SizedBox(
                              //               height: 80,
                              //               width: 80,
                              //               child: Image.asset(
                              //                 'assets/sorojda.png',
                              //                 fit: BoxFit.cover,
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //         Positioned(
                              //           left: 20,
                              //           top: 90,
                              //           child: SizedBox(
                              //             height: 80,
                              //             child: Image.asset('assets/rank2.png'),
                              //           ),
                              //         ),
                              //         Container(
                              //           padding: EdgeInsets.all(4),
                              //           decoration: BoxDecoration(
                              //             gradient: LinearGradient(
                              //               begin: Alignment.topLeft,
                              //               end: Alignment.bottomRight,
                              //               colors: [
                              //                 Colors.amber.shade300,
                              //                 Colors.amber.shade800,
                              //               ],
                              //             ),
                              //             borderRadius: BorderRadius.circular(4),
                              //           ),
                              //           child: SizedBox(
                              //             height: 80,
                              //             width: 80,
                              //             child: Image.asset(
                              //               'assets/sorojda.png',
                              //               fit: BoxFit.cover,
                              //             ),
                              //           ),
                              //         ),
                              //         Positioned(
                              //           top: 50,
                              //           child: SizedBox(
                              //             height: 80,
                              //             child: Image.asset('assets/rank1.png'),
                              //           ),
                              //         ),
                              //         Positioned(
                              //           right: 20,
                              //           top: 40,
                              //           child: Container(
                              //             padding: EdgeInsets.all(4),
                              //             decoration: BoxDecoration(
                              //               gradient: LinearGradient(
                              //                 begin: Alignment.topLeft,
                              //                 end: Alignment.bottomRight,
                              //                 colors: [
                              //                   Colors.white,
                              //                   Colors.white,
                              //                 ],
                              //               ),
                              //               borderRadius: BorderRadius.circular(4),
                              //             ),
                              //             child: SizedBox(
                              //               height: 80,
                              //               width: 80,
                              //               child: Image.asset(
                              //                 'assets/sorojda.png',
                              //                 fit: BoxFit.cover,
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //         Positioned(
                              //           right: 20,
                              //           top: 90,
                              //           child: SizedBox(
                              //             height: 80,
                              //             child: Image.asset('assets/rank3.png'),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              Column(
                                children: [
                                  Container(
                                    // color: Colors.blue,
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
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Obx(
                                      () => ListView.builder(
                                        // addSemanticIndexes: true,
                                        itemCount: getx.rankerList.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            elevation: 0,
                                            surfaceTintColor:
                                                Colors.transparent,
                                            color: Colors.white,

                                            // color: Colors.white,

                                            // surfaceTintColor: Colors.blue,
                                            shape: ContinuousRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: ListTile(
                                              leading: getx.rankerList[index]
                                                          ['RankWithSuffix'] ==
                                                      "1st"
                                                  ? SizedBox(
                                                      height: 35,
                                                      child: Image.asset(
                                                          'assets/rank1.png'))
                                                  : getx.rankerList[index][
                                                              'RankWithSuffix'] ==
                                                          "2nd"
                                                      ? SizedBox(
                                                          height: 35,
                                                          child: Image.asset(
                                                              'assets/rank2.png'))
                                                      : getx.rankerList[index][
                                                                  'RankWithSuffix'] ==
                                                              "3rd"
                                                          ? SizedBox(
                                                              height: 35,
                                                              child:
                                                                  Image.asset('assets/rank3.png'))
                                                          : Text(
                                                              '#${getx.rankerList[index]['RankWithSuffix']}',
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
                                                '${getx.rankerList[index]['Marks']}',
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
                                  ),
                                ],
                              )
                            ],
                          )
                        : SizedBox(),
                    widget.type == "Comprehensive"
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 220,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
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
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 20),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text: 'Name: ',
                                                          style:
                                                              studentTitleStyle),
                                                      TextSpan(
                                                          text: getx
                                                                  .loginuserdata[
                                                                      0]
                                                                  .firstName +
                                                              " " +
                                                              getx
                                                                  .loginuserdata[
                                                                      0]
                                                                  .lastName,
                                                          style:
                                                              studentNameStyle),
                                                    ]),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text:
                                                              'Submitted on: ',
                                                          style:
                                                              studentTitleStyle),
                                                      TextSpan(
                                                          text: formatDate(
                                                              widget
                                                                  .submitedOn),
                                                          style:
                                                              studentNameStyle),
                                                    ]),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                            text: 'Status: ',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black)),
                                                        TextSpan(
                                                            text: double.parse(
                                                                        totalRequiredMarks) <
                                                                    calculateTotalMarks(
                                                                        widget
                                                                            .questionData)
                                                                ? "Pass"
                                                                : "Fail",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: double.parse(
                                                                            totalRequiredMarks) <
                                                                        calculateTotalMarks(widget
                                                                            .questionData)
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .redAccent))
                                                      ]),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 300,
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0),
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
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 200,
                                                  width: 200,
                                                  child: PieChart(
                                                    PieChartData(
                                                      pieTouchData:
                                                          PieTouchData(
                                                        touchCallback:
                                                            (FlTouchEvent event,
                                                                pieTouchResponse) {
                                                          setState(() {
                                                            if (!event
                                                                    .isInterestedForInteractions ||
                                                                pieTouchResponse ==
                                                                    null ||
                                                                pieTouchResponse
                                                                        .touchedSection ==
                                                                    null) {
                                                              touchedIndex = -1;
                                                              return;
                                                            }
                                                            touchedIndex =
                                                                pieTouchResponse
                                                                    .touchedSection!
                                                                    .touchedSectionIndex;
                                                          });
                                                        },
                                                      ),
                                                      borderData: FlBorderData(
                                                          show: false),
                                                      sectionsSpace: 0,
                                                      centerSpaceRadius: 40,
                                                      sections:
                                                          showingSections(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Indicator(
                                                      color: AppColors
                                                          .contentColorBlue,
                                                      text: 'Remaining Marks',
                                                      isSquare: true,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Indicator(
                                                      color: AppColors
                                                          .contentColorYellow,
                                                      text: 'Obtain Marks',
                                                      isSquare: true,
                                                    ),
                                                    SizedBox(height: 4),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 240,
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
                                                  'Paper\nName',
                                                  style: headerStyle,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Total\nMarks',
                                                  style: headerStyle,
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  'Obtain\nMarks',
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
                                                DataCell(
                                                    Text(widget.totalmarks)),
                                                DataCell(Text(
                                                    calculateTotalMarks(
                                                            widget.questionData)
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
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                          )
                        : SizedBox()
                  ],
                ),

             if(widget.type=="Ranked Competition")   Positioned(
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
                      child: Obx(()=>
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                getx.userRankDetails["Rank"].toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text(
                              getx.userRankDetails["StudentName"].toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                getx.userRankDetails["TotalMarks"].toString(),
                                // calculateTotalMarks(widget.questionData).toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
          )),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 150,
      color: Colors.white.withOpacity(0.5),
      margin: EdgeInsets.symmetric(horizontal: 5),
    );
  }

  Widget _buildStatColumn(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30),
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 60),
      ],
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
