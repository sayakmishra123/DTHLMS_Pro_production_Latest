import 'dart:developer';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/THEORY_EXAM/theoryexampapersmobile_page.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TheoryPaperListMobile extends StatefulWidget {
  final RxList theorylist;
  final String type;
  final String img;
  bool istype;
  TheoryPaperListMobile(this.theorylist, this.type, this.img, this.istype,
      {super.key});

  @override
  State<TheoryPaperListMobile> createState() => _TheoryPaperListMobileState();
}

class _TheoryPaperListMobileState extends State<TheoryPaperListMobile> {
  RxList filteredList = [].obs;

  RxList mcqPaperList = [].obs;

  RxList theoryPaperList = [].obs;

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    filteredList.value = widget.theorylist
        .where((item) => item["ServicesTypeName"] == widget.type)
        .toList();
    // log(filteredList.toString());

    return SizedBox(
      height: screenHeight,
      child: Column(
        children: [
          if (filteredList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredList.length, // Use filtered list count
                itemBuilder: (context, index) {
                  final theoryItem = filteredList[index];
                  final setId = theoryItem['SetId'];
                  if (!fetchedDataMap.containsKey(setId)) {
                    getData(theoryItem);
                  }
                  final currentDataLength = fetchedDataMap[setId]?.length ?? 0;

                  getData(theoryItem);

                  // log(theoryItem.toString());
                  return InkWell(
                    onTap: () async {
                      //                   mcqPaperList.clear();
                      // mcqPaperList.value = await fetchMCQPapertList(paperNames['SetId']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TheoryExamPapesMobile(
                            theoryItem,
                            widget.theorylist,
                            widget.istype,
                          ),
                        ),
                      );
                    },
                    child: Container( 
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.orange.withAlpha(200)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color:
                                    const Color.fromARGB(255, 192, 169, 255)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Image.asset(
                                widget.img,
                                fit: BoxFit.contain,
                                height: 35,
                                width: 35,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15, left: 5),
                            height: 80,
                            width: 2,
                            color: Colors.grey.shade200,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          theoryItem["SetName"] ??
                                              'Question', // Use dynamic title
                                          style: FontFamily.styleb
                                              .copyWith(fontSize: 16)),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      //   Text(
                                      // maxLines: 2,
                                      // overflow: TextOverflow.ellipsis,
                                      //   theoryItem["SetName"] ??
                                      //       'Question', // Use dynamic title
                                      //   style: FontFamily.style.copyWith(fontSize: 14,color: Colors.grey)),
                                    ],
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
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
