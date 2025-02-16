import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/EMPTY_PAGE/emptypage.dart';
import 'package:dthlms/MOBILE/MCQ/MCQTYPE/mcqtypepage.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/Package_Video_dashboard.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/live_page.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/podCastDashboard.dart';
import 'package:dthlms/MOBILE/THEORY_EXAM/examPaperList.dart';
import 'package:dthlms/PC/PACKAGEDETAILS/book_list_page.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../constants.dart';

class Mobile_Package_content extends StatefulWidget {
  final int packageid;
  final packagename;
  const Mobile_Package_content(
      {super.key, required this.packageid, this.packagename});

  @override
  State<Mobile_Package_content> createState() => _Mobile_Package_contentState();
}

class _Mobile_Package_contentState extends State<Mobile_Package_content> {
  Getx getx = Get.put(Getx());

  paging(String pageName) {
    switch (pageName) {
      case 'Video':
        Get.to(
          transition: Transition.cupertino, 
          () => MobilePackageVideoDashboard(),
        );

        break;
      case 'Live':
        Get.to(
          transition: Transition.cupertino,
          () => LivePage(
            todayLiveClassList: filterMeetingListByPackage(),
          ),
        );

        break;
      case 'VideosBackup':
        Get.to(
          transition: Transition.cupertino,
          () => EmptyPage(),
        );
        break;
      case 'MCQ':
        Get.to(
          transition: Transition.cupertino,
          () => MCQtypePage(),
        );
        break;
      case 'Book':
        Get.to(
          transition: Transition.cupertino,
          () => BookListPagePc(),
        );
        break;
      case 'Podcast':
        Get.to(
          transition: Transition.cupertino,
          () => MobilePodCastDashBoard(),
        );
        break;

      case "Test":
        Get.to(
            transition: Transition.cupertino,
            () => TheoryExamPaperListofMobile());
        break;
      default:
        print("null");
    }
  }

  String pagename = '';
  int submitedExamsCount = 0;

    RxList mcqSetList = [].obs;
  RxList mcqPaperList = [].obs;
  late BuildContext globalContext;

  @override
  void initState() {
    initializeData();
    callData();
    globalContext = context;
    super.initState();
  }



  getPodcast() async { 
    podcastCount = await fetchPodcast(widget.packageid.toString(), 'Podcast');
  }

  void initializeData() async {
    await section();
    await getVideoCount();
    await getBooksCount();
    await getTheorySetList();
    await getMCQSetList();
    await getPodcast();
    getMeetingList(context);
    

  }

  RxBool hasData = false.obs;
  RxInt videoCountData = 0.obs;
  RxInt booksCountData = 0.obs;

  RxInt allowedDuration = 0.obs;
  RxString formattedDuration = ''.obs;

  RxList theorySetList = [].obs;
  RxList uniqueServicesList = [].obs;

  List<Map<String, dynamic>> podcastCount = [];

  RxInt mcqTotalLength = 0.obs;

  RxList uniqueServicesList2 = [].obs;
  Future getMCQSetList() async {
    if (getx.isInternet.value) {
      fetchTblMCQHistory("").then((mcqhistoryList) {
        unUploadedMcQHistoryInfoInsert(
            globalContext, mcqhistoryList, getx.loginuserdata[0].token);
      });
    }

    mcqSetList.value =
        await fetchMCQSetList(getx.selectedPackageId.value.toString());
    print(mcqSetList.toString());
    Set<String> uniqueServices2 =
        mcqSetList.map((item) => item['ServicesTypeName'] as String).toSet();

// Convert Set to List if needed
    uniqueServicesList2.value = uniqueServices2.toList();
  }

  Future getTheorySetList() async {
    theorySetList.value =
        await fetchTheorySetList(getx.selectedPackageId.value.toString());
    Set<String> uniqueServices =
        theorySetList.map((item) => item['ServicesTypeName'] as String).toSet();
    uniqueServicesList.value = uniqueServices.toList();
  }

  getBooksCount() async {
    var data =
        await getAllPackageDetailsForBooksCount(widget.packageid.toString());

    if (data.isNotEmpty) {
      setState(() {
        booksCountData.value = data.length;
      });
    }
    print(booksCountData);
  }

  section() {
    getSectionListOfPackage(widget.packageid).whenComplete(
      () {
        // getMainChapter(widget.packageId);
      },
    );
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';

    try {
      // Parse the date string
      final dateTime = DateTime.parse(dateString);
      // Format it to a more readable form
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      writeToFile(e, "formatDate");
      return 'Invalid Date';
    }
  }

  getVideoCount() async { 
    var data = await getAllPackageDetailsForVideoCount(widget.packageid.toString());
    if (data.isNotEmpty) {
      hasData.value = false;
      for (var i in data) {
        if (i['AllowDuration'] != "") {
          allowedDuration.value =
              allowedDuration.value + int.parse(i['AllowDuration']);
          videoCountData.value = data.length;

          int seconds = allowedDuration.value;
          int minutes = seconds ~/ 60;
          int hours = minutes ~/ 60;

          formattedDuration.value = hours > 0
              ? "$hours hours ${minutes % 60} minutes"
              : "$minutes minutes";
        }
        print(videoCountData);
      }
    }
  }

  // Video section data
  // RxBool hasData = false.obs; 
  // int videoCountData = 0;
  // int booksCountData = 0;

  // RxInt allowedDuration = 0.obs;
  // RxString formattedDuration = ''.obs;
 
  //   getBooksCount() async {
  //   var data =
  //       await getAllPackageDetailsForBooksCount(widget.packageid.toString());

  //   if (data.isNotEmpty) {
  //    setState(() {
  //     booksCountData = data.length;
       
  //    });

  //   }
  //   print(booksCountData);
  // }

  // getVideoCount() async {
  //   var data =
  //       await getAllPackageDetailsForVideoCount(widget.packageid.toString());

  //   if (data.isNotEmpty) {
  //     hasData.value = false;
  //     for (var i in data) {
  //       if (i['AllowDuration'] != "") {
  //         allowedDuration.value =
  //             allowedDuration.value + int.parse(i['AllowDuration']);
  //       }
  //     }
  //     videoCountData = data.length;

  //     int seconds = allowedDuration.value;
  //     int minutes = seconds ~/ 60;
  //     int hours = minutes ~/ 60;

  //     formattedDuration.value = hours > 0
  //         ? "$hours hours ${minutes % 60} minutes"
  //         : "$minutes minutes";
  //   }
  //   print(videoCountData);
  // }

  callData() async {
    initialfunction(widget.packageid.toString()).whenComplete(() {
      getSectionListOfPackage(
        widget.packageid,
      );
    });
  }

  Future initialfunction(String packageid) async {
    print("caling mcqlist");

    if (getx.isInternet.value) {
       getx.mcqdataList.value = await getMcqDataForTest(
          context, getx.loginuserdata[0].token, packageid);
      getx.theoryExamvalue.value = await gettheoryExamDataForTest2(
          context, getx.loginuserdata[0].token, packageid);
      updatePackage(context, getx.loginuserdata[0].token, false, packageid);
    } else {
      getx.mcqdataList.value = true;
      getx.theoryExamvalue.value = true;
    }

  
    // Get.back();
  }

  Widget showDetails(Icon icon, {Map<String, dynamic>? foldername}) {
    infoTetch(widget.packageid.toString(), foldername?['section'] ?? 'no');
    return GetBuilder<Getx>(builder: (Getx controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue[50],
                      ),
                      child: icon)
                ],
              ),
              Row(
                children: [
                  Text(
                    foldername?['section'] ?? '',
                    style: FontFamily.font4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          Colors.grey[200], // Soft background color
                      radius: 12,
                      child: Text(
                        controller.infoFetch.isNotEmpty
                            ? controller.infoFetch.length.toString()
                            : '0', // Default to 0 for better readability
                        style: FontFamily.style.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .grey[800], // Slightly darker color for contrast
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5), // Add spacing for better readability
                if (controller
                    .infoFetch.isNotEmpty) // Conditionally render text
                  Text(
                    '${controller.infoFetch.length} Items Available', // Dynamic count text
                    style: FontFamily.style.copyWith(
                      fontSize: 12,
                      color:
                          Colors.green, // Use a consistent professional color
                      fontWeight: FontWeight.w500, // Slightly bold for emphasis
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }

  @override
  void dispose() { 
    getx.sectionListOfPackage.clear();
    getx.isInsidePackage.value = false;
    super.dispose();
  }

  final List<Map<String, dynamic>> folderIcons = [
    { 
      "section": "Video",
      "icon": Icons.video_library,
      "color": Colors.blue,
      "subtitle": "Watch recorded videos and tutorials",
      "color2": [
        // Light pink -> soft pink
        Colors.green.shade200,
        Colors.green.shade100
      ],
    },
    {
      "section": "Live",
      "icon": Icons.live_tv,
      "color": Colors.red,
      "subtitle": "Join live streaming\nsessions",
      'color2': [
        // Light orange -> peach
        const Color(0xFFFFF1D5),
        const Color(0xFFFFE0AF),
      ],
    },
    {
      "section": "Podcast",
      "icon": Icons.podcasts,
      "color": Colors.orange,
      "subtitle":
          "Listen to insightful discussions and audio episodes anytime, anywhere.",
      "color2": [
        // Light pink -> soft pink
        Colors.brown.shade200,
        Colors.brown.shade100
      ],
    },
    {
      "section": "MCQ",
      "icon": Icons.question_answer,
      "color": Colors.green,
      "subtitle": "Practice multiple-choice questions",
      'color2': [
        // Light pink -> soft pink
        Colors.blue.shade200,
        Colors.blue.shade100
      ],
    },
    {
      "section": "Test",
      "icon": Icons.book,
      "color": Colors.purple,
      "subtitle": "Read and review theoretical content",
      "color2": [
        // Light pink -> soft pink
        Colors.orange.shade200,
        Colors.orange.shade100
      ],
    },
    {
      "section": "Book",
      "icon": Icons.library_books,
      "color": Colors.brown,
      "subtitle": "Access and manage your digital library",
      "color2": [
        // Light pink -> soft pink
        const Color.fromARGB(255, 248, 177, 219),
        const Color(0xFFFDD3E7),
      ],
    },
  ];

  Icon getFolderIcon(Map<String, dynamic> foldername, int index) {
    // Find the matching icon data from the list
    final iconData = folderIcons.firstWhere(
      (item) => item['section'] == foldername['section'],
      orElse: () => {
        "icon": Icons.folder,
        "color": Colors.blue,
        "subtitle": '',
        "color2": [
          const Color(0xFFFFF1D5),
          const Color(0xFFFFE0AF),
        ]
      },
    );

    // Return the showDetails widget with the appropriate icon and foldername
    return Icon(
      iconData['icon'],
      color: iconData['color'],
    );
  }

  String getFolderSubtitle(Map<String, dynamic> foldername, int index) {
    // Find the matching icon data from the list
    final iconData = folderIcons.firstWhere(
      (item) => item['section'] == foldername['section'],
      orElse: () => {
        "icon": Icons.folder,
        "color": Colors.blue,
        "subtitle": '',
        "color2": [
          const Color(0xFFFFF1D5),
          const Color(0xFFFFE0AF),
        ]
      },
    );

    // Return the showDetails widget with the appropriate icon and foldername
    return iconData['subtitle'];
  }

  Color getFolderIconColor(Map<String, dynamic> foldername, int index) {
    // Find the matching icon data from the list
    final iconData = folderIcons.firstWhere(
      (item) => item['section'] == foldername['section'],
      orElse: () => {
        "icon": Icons.folder,
        "color": Colors.blue,
        "subtitle": '',
        "color2": [
          const Color(0xFFFFF1D5),
          const Color(0xFFFFE0AF),
        ]
      },
    );

    // Return the showDetails widget with the appropriate icon and foldername
    return iconData['color'];
  }

  List<Color> gradientColorsList(Map<String, dynamic> foldername, int index) {
    final iconData = folderIcons.firstWhere(
      (item) => item['section'] == foldername['section'],
      orElse: () => {
        "icon": Icons.folder,
        "color": Colors.blue,
        "subtitle": '',
        "color2": [
          const Color(0xFFFFF1D5),
          const Color(0xFFFFE0AF),
        ]
      },
    );

    // Return the showDetails widget with the appropriate icon and foldername
    return iconData['color2'];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorPage.white),
          backgroundColor: ColorPage.mainBlue,
          title: Text(
            widget.packagename,
            style: FontFamily.style.copyWith(color: Colors.white, fontSize: 15),
          ),
        ),
        body: getx.sectionListOfPackage.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 80),
                itemCount: getx.sectionListOfPackage
                    .where((item) =>
                        item['section'] != 'PDF' &&
                        item['section'] != 'YouTube')
                    .length,
                itemBuilder: (context, index) {
                    String todayDate = DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now());
                   int liveCount = getx.todaymeeting
                                      .where((meeting) =>
                                          meeting.scheduledOn != null &&
                                          DateFormat('yyyy-MM-dd').format(
                                                  meeting.scheduledOn) ==
                                              todayDate &&
                                          meeting.packageId ==
                                              widget.packageid.toString())
                                      .length;
                  final filteredList = getx.sectionListOfPackage
                      .where((item) =>
                          item['section'] != 'PDF' &&
                          item['section'] != 'YouTube')
                      .toList();

                  return InkWell(
                    onTap: () {
                      paging(filteredList[index]['section']);

                      if (filteredList[index]['section'] == "Video" ||
                          filteredList[index]['section'] == "PDF") {
                        resetTblLocalNavigationByOrderOnsection(1);
                        print(filteredList[index]['section'] + "wow mc");

                        insertTblLocalNavigation(
                                "Section",
                                widget.packageid.toString(),
                                filteredList[index]["section"])
                            .whenComplete(() => null);

                        getMainChapter(widget.packageid);
                        getLocalNavigationDetails();
                      }
                      getx.selectedPackageId.value = widget.packageid;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildOfferCard(   
                        packageid: widget.packageid.toString(),
                        title: filteredList[index]['section'],
                        subtitle: getFolderSubtitle(filteredList[index], index),
                        gradientColors:
                            gradientColorsList(filteredList[index], index),
                        arrowBackground: Colors.orange.shade100,
                        arrowColor: Colors.orange,
                        icon: getFolderIcon(filteredList[index], index),
                        iconcolor:
                            getFolderIconColor(filteredList[index], index),
                        liveCount: liveCount.toString(),
                        videoCount: videoCountData.toString(),
                        allowedDurationVideo: formattedDuration.value,
                        booksCount: booksCountData.toString(),
                        testCount: theorySetList.length.toString(),
                        podcastCount: podcastCount.length.toString(),
                        mcaCount:  mcqSetList.length.toString(),
                        // zipText: 'ZIP',
                        // zipTextColor: Colors.orange,
                      ),
                    ),

                    //  Container(
                    //   margin:
                    //       EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black12,
                    //         spreadRadius: 4,
                    //         blurRadius: 10,
                    //         offset: Offset(2, 2),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    // child: getFolderIcon(filteredList[index], index),
                    //   ),
                    // ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      );
    });
  }

  // static Widget _count(title, videoCount) {

  // Getx getx = Get.put(Getx());

  //   return Row(
  //     children: [
  //       title == 'Video' && videoCount != '0'
  //           ? CircleAvatar(
  //               child: Text(
  //               videoCount,
  //               style: FontFamily.style.copyWith(fontSize: 15),
  //             ))
  //           : title == 'Live'
  //               ? CircleAvatar(
  //                   child: Text(
  //                   getx.todaymeeting.length.toString(),
  //                   style: FontFamily.style.copyWith(fontSize: 15),
  //                 ))
  //               : SizedBox(),
  //       SizedBox(
  //         width: 10,
  //       ),
  //       Image.asset(logopath, width: 45),
  //     ],
  //   );
  // }

  static Widget _buildOfferCard(
      {
        required String packageid,
        required String title,
      required String subtitle,
      required List<Color> gradientColors,
      required Color arrowBackground,
      required Color arrowColor,
      required Icon icon,
      required Color iconcolor,
      required String liveCount,
      required String videoCount,
      required String booksCount,
      required String testCount,
      required String podcastCount,
      required String mcaCount,

      required String allowedDurationVideo}) {
        
    getCountDetailsForAllFolder<Widget>(String foldername) {
      double fontSize = 16.0;
      switch (foldername) {
        case "Video":
          return videoCount != '0' ?  CircleAvatar(
                          child: Text(
                          videoCount,
                          style: FontFamily.style.copyWith(fontSize: 15),
                        )) : SizedBox();
        case "Live":
          return Obx(() {
    Getx getx = Get.put(Getx());

                              String todayDate = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now());

                              int liveCount = getx.todaymeeting
                                  .where((meeting) =>
                                      meeting.scheduledOn != null &&
                                      DateFormat('yyyy-MM-dd')
                                              .format(meeting.scheduledOn) ==
                                          todayDate && meeting.packageId == packageid.toString())
                                  .length;

                              return Stack(
                                clipBehavior: Clip
                                    .none, // Ensures the Positioned widget is not clipped
                                children: [
                                  // Live Animation
                                  if (liveCount >= 1)
                                  Lottie.asset(
                                    'assets/liveanimation.json',
                                    width: 70,
                                    height: 70,
                                  ), 

                                  // Only show if liveCount is greater than 1
                                  if (liveCount > 1)
                                    Positioned(
                                      top:
                                          0, // Position it slightly above the animation
                                      right: 0, // Align it to the right corner
                                      child: CircleAvatar(
                                        radius:
                                            15.0, // Reduced radius for better proportion
                                        backgroundColor: Colors
                                            .white, // Light background for visibility
                                        child: Text(
                                          '+${liveCount - 1}', // Show remaining count
                                          style: TextStyle(
                                            color: Colors
                                                .red, // Red to indicate urgency/attention
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                12, // Reduced font size for better fit
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            });
        case "VideosBackup":
          return null;
        case "MCQ":
          // return null;
          return CircleAvatar(
            child: Text(
              mcaCount,
              style: FontFamily.style.copyWith(fontSize: fontSize),
            ),
          );
        case "Theory":
         return CircleAvatar(
           child: Text(
              testCount,
              style: FontFamily.style.copyWith(fontSize: fontSize),
            ),
         );
        case "Book":
        return CircleAvatar(
                                  child: Text( 
                                    booksCount.toString(),
                                    style:
                                        FontFamily.style.copyWith(fontSize: 15),
                                  ));
        case "Test":
          // return null;
          return CircleAvatar(
            child: Text(
              testCount,
              style: FontFamily.style.copyWith(fontSize: fontSize),
            ),
          );
        case "Podcast":
          return CircleAvatar(
            child: Text(
              podcastCount,
              style: FontFamily.style.copyWith(fontSize: fontSize),
            ),
          );
        default:
          return null;
      }
    }

    return Container( 
      width: 100,
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            icon.icon,
                            color: iconcolor,
                          )),
                      Text(
                        title == 'Video' ? 'Recorded' : title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // Title
                  SizedBox(
                    height: 8,
                  ),
                  title == 'Video'
                      ? Text(
                          'Duration: ${allowedDurationVideo}',
                          style: FontFamily.style.copyWith(fontSize: 12),
                        )
                      : SizedBox(),
                  // SizedBox(
                  //   height: 4,
                  // ),
                  // title == 'Video' ? Text('View Time: 20 hours',style: FontFamily.style.copyWith(fontSize: 12),) :  SizedBox()
                ],
              ),
              Row(
                children: [

SizedBox(
  child: getCountDetailsForAllFolder(title),
),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(logopath, width: 45),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Subtitle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 49, 49, 49).withAlpha(170),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: arrowBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: arrowColor,
                  size: 20,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

List filterMeetingListByPackage() {
  List mettinglist = [];
  for (var item in getx.todaymeeting) {
    if (item.packageId
        .split(',')
        .contains(getx.selectedPackageId.value.toString())) {
      mettinglist.add(item);
    }
  }
  return mettinglist;
}
