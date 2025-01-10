 
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/resultpage/test_result_mobile.dart';
import 'package:dthlms/PC/PROFILE/userProfilePage.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamHistoryMobile extends StatefulWidget {
  const ExamHistoryMobile({super.key});

  @override
  State<ExamHistoryMobile> createState() => _ExamHistoryMobileState();
}

class _ExamHistoryMobileState extends State<ExamHistoryMobile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TextEditingController _searchController = TextEditingController();
  Getx getx = Get.put(Getx());
  String pageTitle = 'Quick Test';
  RxList mcqSetList = [].obs;
  RxList mcqPaperList = [].obs;

  @override
  void initState() {
    getMCQSetList();
    super.initState();

    _tabController =
        TabController(length: 4, vsync: this); // Updated length to 3

    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            pageTitle = 'Quick Test';
            break;
          case 1:
            pageTitle = 'Comprehensive';
            break;
          case 2:
            pageTitle = 'Ranked Competition';
            break;
          case 3:
            pageTitle = 'Theory Exam';
            break;
        }
      });
    });
  }

  // Future initialfunction() async {
  //  getx.data.value = await getMcqDataForTest(context, getx.loginuserdata[0].token,
  //       getx.selectedPackageId.value.toString());
  // }

  Future getMCQSetList() async {
    mcqSetList.value =
        await fetchMCQSetList(getx.selectedPackageId.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorPage.mainBlue,
        title: Text(
          'Exam History',
          style: FontFamily.style.copyWith(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: TabBar(
  controller: _tabController,
  labelColor: Colors.black,
  unselectedLabelColor: Colors.grey,
  indicatorColor: Colors.blue,
  indicatorWeight: 4.0,
  labelStyle: const TextStyle(
    fontSize: 12, 
    fontWeight: FontWeight.bold
  ),
  unselectedLabelStyle: const TextStyle(fontSize: 12),
  tabs: [
    const Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Quick', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text('Practice', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
     Tab(
      text: 'Comprehensive',  
    ),
    const Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Ranked', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text('Competition', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
    const Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Theory', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text('Exam', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  ],
)

            ),
      
            // Tab Bar View for Showing Content
            Container(
              // height: 700,
              height: MediaQuery.of(context).size.height * 0.8,
              // width: 700,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // First Tab Widget
                  quickPractice(),
                  Comprehensive(),
                  rankedCompetition(),
                  theoryExam(context), 
      
                  // QuickPracticeWidget(),
                  // Second Tab Widget
                  // ComprehensiveWidget(),
                  // Third Tab Widget
                  // RankedCompetitionWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
   Widget rankedCompetition() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        _buildHeadingbarOfRankedCompetition(),
        SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          child: _buildRankedCompetitionExamDetailsList(),
        ),
      ],
    );
  }

   Widget _buildRankedCompetitionExamDetailsList() {  
    return FutureBuilder(
      future: fetchTblMCQHistory("Ranked Competition"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          print( snapshot.data!.length.toString()+"gfdghdsgysdghdsgcydsgdhg dc sdcuhd dch jhdsgnd vdshvdsjb");
          return ListView.builder(
            shrinkWrap: true,
            // physics:
            //     NeverScrollableScrollPhysics(), // Allows scrolling within this widget
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 249, 249),
                        border: Border.all(color: Colors.grey, width: 0.2)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width / 6,
                            child: Center(
                                child: Text(
                                    "${snapshot.data![index]['ExamName']}"))),
                        Container(
                            width: MediaQuery.of(context).size.width / 6,
                            child: Center(
                                child: Text(snapshot.data![index]
                                            ["SubmitDate"] !=
                                        ""
                                    ? "${formatDateWithOrdinal(snapshot.data![index]["SubmitDate"])}"
                                    : formatDateWithOrdinal(snapshot.data![index]["AttemptDate"])))),
                        Container(
                            width: MediaQuery.of(context).size.width / 6,
                            child: Center(
                                child: Text(
                                    snapshot.data![index]["SubmitDate"] != ""
                                        ? snapshot.data![index]["ObtainMarks"].toString()
                                        : "Attempted but not submitted")))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }


    Widget _buildHeadingbarOfRankedCompetition() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: SizedBox(
        //     width: 40,
        //   ),
        // ),
        SizedBox(width: 100, child: _buildHeadingButton('Exam Name')),
        SizedBox(width: 100, child: _buildHeadingButton('Date')),
        SizedBox(width: 100, child: _buildHeadingButton('Marks')),

        // _buildHeadingButton('')
      ],
    );
  }

  Widget quickPractice() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        _buildHeadingbarOfMcq(),
        SizedBox( 
          height: MediaQuery.of(context).size.height - 300,
          child: _buildQuickPracticeExamDetailsList(), 
        ),
      ],
    );
  }

   Widget Comprehensive() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        _buildHeadingbarOfComprehensive(),   
        SizedBox( 
          height: MediaQuery.of(context).size.height - 300,
          child: _buildComprehensiveExamDetailsList(),
        ),
      ],
    );
  }
    Widget _buildHeadingbarOfComprehensive() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: SizedBox(
        //     width: 40,
        //   ),
        // ),
        SizedBox(width: 100, child: _buildHeadingButton('Exam Name')),
        SizedBox(width: 100, child: _buildHeadingButton('Date')),
        SizedBox(width: 100, child: _buildHeadingButton('Obtain Marks')),

        // _buildHeadingButton('')
      ],
    );
  }
    Widget _buildComprehensiveExamDetailsList() {
    return FutureBuilder(
      future: fetchTblMCQHistory("Comprehensive"),  
      builder: (context, snapshot) { 
        if (snapshot.hasData) {

          print( snapshot.data!.length.toString()+"gfdghdsgysdghdsgcydsgdhg dc sdcuhd dch jhdsgnd vdshvdsjb");
          return ListView.builder(
            shrinkWrap: true,
            // physics:
            //     NeverScrollableScrollPhysics(), // Allows scrolling within this widget
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 249, 249),
                        border: Border.all(color: Colors.grey, width: 0.2)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width / 6,
                            child: Center(
                                child: Text(
                                    "${snapshot.data![index]['ExamName']}"))),
                        Container(
                            width: MediaQuery.of(context).size.width / 6,
                            child: Center(
                                child: Text(snapshot.data![index]
                                            ["SubmitDate"] !=
                                        ""
                                    ? "${formatDateWithOrdinal(snapshot.data![index]["SubmitDate"])}"
                                    : formatDateWithOrdinal(snapshot.data![index]["AttemptDate"])))),
                        Container(
                            width: MediaQuery.of(context).size.width / 6,
                            child: Center(
                                child: Text(
                                    snapshot.data![index]["SubmitDate"] != ""
                                        ? snapshot.data![index]["ObtainMarks"].toString()
                                        : "Attempted but not submitted")))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget theoryExam(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        _buildHeadingbarOfTheoryExam(),
        SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          child: _buildTheoryExamDetailsList(context),
        ),
      ],
    );
  }

  Widget _buildHeadingbarOfMcq() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: SizedBox(
        //     width: 40,
        //   ),
        // ),
        SizedBox(width: 100, child: _buildHeadingButton('Exam Name')),
        SizedBox(width: 100, child: _buildHeadingButton('Date')),
        SizedBox(width: 100, child: _buildHeadingButton('Success Rate')),

        // _buildHeadingButton('')
      ],
    );
  }

  Widget _buildHeadingbarOfTheoryExam() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: SizedBox(
        //     width: 40,
        //   ),
        // ),
        SizedBox(width: 90, child: _buildHeadingButton('Exam Name')),
        SizedBox(width: 90, child: _buildHeadingButton('Date')),
        SizedBox(width: 90, child: _buildHeadingButton('Status')),
        SizedBox(width: 90, child: _buildHeadingButton('Result')),

        // _buildHeadingButton('')
      ],
    );
  }

  Widget _buildHeadingButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 200,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          )),
        ),
      ),
    );
  }

  Widget _buildQuickPracticeExamDetailsList() {
    return FutureBuilder(
      future: fetchTblMCQHistory("Quick Practice"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          print( snapshot.data!.length.toString()+"gfdghdsgysdghdsgcydsgdhg dc sdcuhd dch jhdsgnd vdshvdsjb");
          return ListView.builder(
            shrinkWrap: true,
            // physics:
            //     NeverScrollableScrollPhysics(), // Allows scrolling within this widget
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 249, 249),
                        border: Border.all(color: Colors.grey, width: 0.2)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: 100,
                            child: Center(
                                child: Text(
                                    "${snapshot.data![index]['ExamName']}"))),
                        Container(
                            width: 100,
                            child: Center(
                                child: Text(snapshot.data![index]
                                            ["SubmitDate"] !=
                                        ""
                                    ? "${formatDateWithOrdinal(snapshot.data![index]["SubmitDate"])}"
                                    : formatDateWithOrdinal(snapshot.data![index]["AttemptDate"])))),
                        Container(
                            width: 100,
                            child: Center(
                                child: Text(
                                    snapshot.data![index]["SubmitDate"] != ""
                                        ? snapshot.data![index]["ObtainMarks"].toString()+"%"
                                        : "Attempted but not submitted")))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Widget _buildTheoryExamDetailsList(BuildContext context) {
  return FutureBuilder(
    future: getTheryExamHistoryList(context, getx.loginuserdata[0].token),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
            shrinkWrap: true,
            // physics:
            //     NeverScrollableScrollPhysics(), // Allows scrolling within this widget
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // print(snapshot.data![index]['TheoryExamName'].toString()+"hellollllllllllllllllllllllllll");

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 249, 249),
                        border: Border.all(color: Colors.grey, width: 0.2)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: 90,
                            child: Center(
                                child: Text(
                                    "${snapshot.data![index]['TheoryExamName']}"))),
                        Container(
                            width: 90,
                            child: Center(
                                child: Text(snapshot.data![index]
                                            ["isSubmitted"] ==
                                        1
                                    ? "${formatDateTime(snapshot.data![index]["SubmitedOn"])} "
                                    : snapshot.data![index]["isAttempt"] == 1 &&
                                            snapshot.data![index]
                                                    ["isSubmitted"] ==
                                                0
                                        ? "${snapshot.data![index]["AttamptOn"]} "
                                        : "----"))),
                        Container(
                            width: 90,
                            child: Center(
                                child: Text(snapshot.data![index]
                                            ["isSubmitted"] ==
                                        1
                                    ? "Submited"
                                    : snapshot.data![index]["isAttempt"] == 1 &&
                                            snapshot.data![index]
                                                    ["isSubmitted"] ==
                                                0
                                        ? " Attampt "
                                        : "Not attempt"))),
                        Container(
                            width: 90,
                            child: Center(
                                child: snapshot.data![index]
                                            ["IsResultPublished"] == 1
                                    ? MaterialButton(
                                        color: ColorPage.blue,
                                        child: Text(
                                          "See result", 
                                          style:
                                              TextStyle(color: ColorPage.white,fontSize: 12),
                                        ),
                                        onPressed: () async{
                                        
                                          Get.to(() => TestResultPageMobile( 
                                               studentName: getx
                                                        .loginuserdata[0]
                                                        .firstName +
                                                    " " +
                                                    getx.loginuserdata[0] 
                                                        .lastName,
                                                examName: snapshot.data![index]['TheoryExamName'],
                                                resultPublishedOn:
                                                    formatDateTime(snapshot.data![index]['ReportPublishDate']),
                                                submitedOn: formatDateTime(snapshot.data![index]["SubmitedOn"]),
                                                obtain: snapshot.data![index]['TotalReCheckedMarks']!= null?  snapshot.data![index]['TotalReCheckedMarks']:  snapshot.data![index]['TotalCheckedMarks'],
                                                
                                                totalMarks: double.parse(snapshot.data![index]['TotalMarks'].toString()) , 
                                                totalMarksRequired: double.parse( snapshot.data![index]['PassMarks'].toString())
                                             
                                                
                                              ));
                                        })
                                    : Text("Result not publish ")))
                      ],
                    ),
                  ),
                ),
              );
            });
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}