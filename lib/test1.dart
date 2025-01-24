import 'dart:developer';

import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:flutter/material.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:get/get.dart';

import 'API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'PC/MCQ/MOCKTEST/resultMcqTest.dart';
import 'PC/MCQ/MOCKTEST/termandcondition.dart';
import 'PC/MCQ/mcqpaperDetails.dart';

class McqList extends StatelessWidget {
  final RxList mcqSetList;
  final String type;
  final String img;
  bool istype;
  McqList(this.mcqSetList, this.type, this.img, this.istype, {super.key});
  RxList filteredList = [].obs;
  RxList mcqPaperList = [].obs;
  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine crossAxisCount based on screen width
    int crossAxisCount = screenWidth > 1200
        ? 6
        : screenWidth > 800
            ? 5
            : 4; // Adjust the number of grid items per row based on screen width.

    // Filter the mcqSetList to only include "Quick Practice"
    filteredList.value =
        mcqSetList.where((item) => item["ServicesTypeName"] == type).toList();
    // log(filteredList.toString());
    return SizedBox(
      height: screenHeight * 0.8, // Make it responsive to screen height.
      child: Column(
        children: [
          if (filteredList.isNotEmpty)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredList.length, // Use filtered list count
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.9, // Adjust aspect ratio for grid items.
                ),
                itemBuilder: (context, index) {
                  final mcqItem = filteredList[index];
                  return InkWell(
                    onTap: () async {
                      //                   mcqPaperList.clear();
                      // mcqPaperList.value = await fetchMCQPapertList(paperNames['SetId']);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => McqPaperDetails(
                              mcqItem,
                              mcqSetList,
                              istype,
                            ),
                          ));

                      // _showPaperListDialog(context, mcqItem);
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorPage.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  img,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          mcqItem["SetName"] ?? 'Question', // Use dynamic title
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          else
            Expanded(
              child: Center(
                child: const Text(
                  "No Quick Practice Papers Found",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPaperListDialog(BuildContext context, final paperNames) async {
    // log(paperNames!.first.toString());
    mcqPaperList.clear();
    mcqPaperList.value = await fetchMCQPapertList(paperNames['SetId']);
    // log(mcqPaperList.string);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width:
                MediaQuery.of(context).size.width * 0.2, // 40% of screen width
            height: MediaQuery.of(context).size.height *
                0.3, // 30% of screen height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog Title
                const Text(
                  "Available Papers",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                const SizedBox(height: 8.0),
                // Paper List
                Expanded(
                  child: mcqPaperList.isNotEmpty
                      ? ListView.builder(
                          itemCount: mcqPaperList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 0,
                              // color: const Color.fromARGB(255, 187, 225, 250),
                              child: ListTile(
                                onTap: () async {
                                  Get.back();
                                  bool checking = await checkIsSubmited(
                                      mcqPaperList[index]['PaperId']
                                          .toString());
                                  if (checking) {
                                    print("quickpractice ");
                                    List rankdata = await getRankDataOfMockTest(
                                        context,
                                        getx.loginuserdata[0].token,
                                        mcqPaperList[index]['PaperId']
                                            .toString());
                                    Get.to(
                                      transition: Transition.cupertino,
                                      () => MockTestresult(
                                        totalmarks: mcqPaperList[index]
                                            ['TotalMarks'],
                                        type: "Ranked Competition",
                                        paperId: mcqPaperList[index]['PaperId']
                                            .toString(),
                                        questionData: fetchResultOfStudent(
                                            mcqPaperList[index]['PaperId']
                                                .toString()),
                                        submitedOn: "",
                                        paperName: mcqPaperList[index]
                                            ['PaperName'],
                                        isAnswerSheetShow: mcqPaperList[index]
                                                        ['IsAnswerSheetShow']
                                                    .toString() ==
                                                "true"
                                            ? true
                                            : false,
                                      ),
                                    );
                                  } else {
                                    Get.to(
                                      transition: Transition.cupertino,
                                      () => MockMcqTermAndCondition(
                                        termAndCondition: mcqPaperList[index]
                                            ['TermAndCondition'],
                                        endDate: mcqPaperList[index]
                                            ['MCQPaperEndDate'],
                                        paperName: mcqPaperList[index]
                                            ['PaperName'],
                                        startDate: mcqPaperList[index]
                                            ['MCQPaperStartDate'],
                                        startTime: mcqPaperList[index]
                                            ['MCQStartTime'],
                                        totalMarks: mcqPaperList[index]
                                            ['TotalMarks'],
                                        duration: mcqPaperList[index]
                                            ['Duration'],
                                        paperId: mcqPaperList[index]['PaperId'],
                                        type: mcqSetList[index]
                                            ["ServicesTypeName"],
                                        isAnswerSheetShow: mcqPaperList[index]
                                                        ['IsAnswerSheetShow']
                                                    .toString() ==
                                                "true"
                                            ? true
                                            : false,
                                        userAnswer: {},
                                      ),
                                    );
                                  }
                                },
                                leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/mcq_set.png')),
                                title: Text(
                                  mcqPaperList[index]['PaperName'] ??
                                      'Unnamed Paper',
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            "No Papers Available",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 8.0),
                // Close Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 248, 23, 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BeautifulMcqUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic cross-axis count for responsiveness
    int crossAxisCount = screenWidth > 1200
        ? 5
        : screenWidth > 800
            ? 4
            : 2;

    return Scaffold(
      backgroundColor: Colors.blue.shade50, // Light background color
      appBar: AppBar(
        title: const Text(
          "Theory Exam Paper List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 3, // Example item count
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // Add your on-tap functionality here
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/mcq_img.png', // Your image asset
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(15.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        child: Text(
                          'Test ${index + 1}', // Dynamic test name
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
