import 'dart:developer';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/THEORY_EXAM/theoryexamPaperList.dart';
import 'package:flutter/material.dart';
// import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:get/get.dart';

class TheoryPaperList extends StatefulWidget {
  final RxList theorylist;
  final String type;
  final String img;
  final bool istype;
  TheoryPaperList(this.theorylist, this.type, this.img, this.istype,
      {super.key});

  @override
  State<TheoryPaperList> createState() => _TheoryPaperListState();
}

class _TheoryPaperListState extends State<TheoryPaperList> {
  RxList filteredList = [].obs;

  RxList mcqPaperList = [].obs;

  Map<String, List<dynamic>> fetchedDataMap = {};

  Future<void> getData(Map<String, dynamic> paperNames) async {
    final setId = paperNames['SetId']; 
    if (!fetchedDataMap.containsKey(setId)) {
      fetchedDataMap[setId] = await fetchTheoryPapertList(setId);
      setState(() {});
    }
  }

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
    filteredList.value = widget.theorylist
        .where((item) => item["ServicesTypeName"] == widget.type)
        .toList();
    log(filteredList.toString());
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
                  final theoryItem = filteredList[index];
                  final setId = theoryItem['SetId'];

                  // Fetch data only if not already fetched
                  if (!fetchedDataMap.containsKey(setId)) {
                    getData(theoryItem);
                  }

                  final currentDataLength = fetchedDataMap[setId]?.length ?? 0;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      bool showSupportingText = constraints.maxWidth > 180;
                      int calculatedMaxLines = (constraints.maxHeight ~/ 55)
                          .clamp(1, 6); // Adjust dynamically

                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TheoryExamPapes(
                                theoryItem,
                                widget.theorylist,
                                widget.istype,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        const Color.fromARGB(255, 126, 197, 255),
                                    radius: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset('assets/exam.png'),
                                    ),
                                  ),
                                                                Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          Colors.pink.withAlpha(50),
                                      radius: 15.0,
                                      child: Text(
                                        currentDataLength.toString(),
                                        style: FontFamily.style
                                            .copyWith(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                ],
                              ),
                         
                              Text(
                                theoryItem["SetName"] ??
                                    'Question', // Use dynamic title
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (showSupportingText)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'MCQ exams test your knowledge with objective questions, requiring critical thinking and quick decision-making. '
                                    'They help assess understanding across various topics efficiently.',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines:
                                        calculatedMaxLines, // Dynamic maxLines
                                    softWrap: true,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),

                            ],
                          ),
                        ),
                      );
                    },
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
    log(mcqPaperList.string);
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
                                  // bool checking = await checkIsSubmited(
                                  //     mcqPaperList[index]['PaperId']
                                  //         .toString());
                                  // if (checking) {
                                  //   print("quickpractice ");
                                  //   List rankdata = await getRankDataOfMockTest(
                                  //       context,
                                  //       getx.loginuserdata[0].token,
                                  //       mcqPaperList[index]['PaperId']
                                  //           .toString());
                                  //   Get.to(
                                  //     () => MockTestresult(
                                  //         totalmarks: mcqPaperList[index]
                                  //             ['TotalMarks'],
                                  //         paperId: mcqPaperList[index]
                                  //                 ['PaperId']
                                  //             .toString(),
                                  //         questionData: fetchResultOfStudent(
                                  //             mcqPaperList[index]['PaperId']
                                  //                 .toString())),
                                  //   );
                                  // } else {
                                  //   Get.to(
                                  //     () => MockMcqTermAndCondition(
                                  //       termAndCondition: mcqPaperList[index]
                                  //           ['TermAndCondition'],
                                  //       paperName: mcqPaperList[index]
                                  //           ['PaperName'],
                                  //       startTime: mcqPaperList[index]
                                  //           ['MCQPaperStartDate'],
                                  //       totalMarks: mcqPaperList[index]
                                  //           ['TotalMarks'],
                                  //       duration: mcqPaperList[index]
                                  //           ['Duration'],
                                  //       paperId: mcqPaperList[index]['PaperId'],
                                  //       type: mcqSetList[index]
                                  //           ["ServicesTypeName"],
                                  //     ),
                                  //   );
                                  // }
                                },
                                leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/mcq_img.png')),
                                title: Text(
                                  // mcqPaperList[index]['PaperName'] ??
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
