import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/API/URL/api_url.dart';
import 'package:dthlms/CUSTOMDIALOG/customdialog.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/Package_Video_dashboard.dart';
import 'package:dthlms/MODEL_CLASS/Meettingdetails.dart';
import 'package:dthlms/PC/HOMEPAGE/homepage.dart';
import 'package:dthlms/PC/PACKAGEDETAILS/book_list_page.dart';
import 'package:dthlms/PC/PACKAGEDETAILS/podcastPage.dart';
import 'package:dthlms/PC/STUDYMATERIAL/pdfViewer.dart';
import 'package:dthlms/PC/VIDEO/ClsVideoPlay.dart';
import 'package:dthlms/PC/VIDEO/videoplayer.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/THEORY_EXAM/theorySetList.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:dthlms/test1.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackageDetailsPage extends StatefulWidget {
  final String packageName;
  final int packageId;
  final String ExpiryDate;

  PackageDetailsPage(this.packageName, this.packageId,
      {super.key, required this.ExpiryDate});

  @override
  State<PackageDetailsPage> createState() => _PackageDetailsPageState();
}

class _PackageDetailsPageState extends State<PackageDetailsPage> {
  @override
  void initState() {
    getx.isVideoDashBoard.value = false;
    getx.isLiveDashBoard.value = false;
    getx.isTheoryDashBoard.value = false;
    getx.isBookDashBoard.value = false;
    getx.isMCQDashBoard.value = false;
    getx.isPDFDashBoard.value = false;
    getx.isBackupDashBoard.value = false;
    super.initState();
  }

  Getx getx = Get.put(Getx());
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getx.isCollapsed.value
                ? Container(width: 0) // Hidden sidebar
                : Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: SizedBox(
                      width: 230,
                      child: SlideBarPackageDetails(
                        packageId: widget.packageId,
                        selectedIndex: selectedIndex,
                        headname: widget.packageName,
                        onItemSelected: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        ExpiryDate: widget.ExpiryDate,
                      ),
                    ),
                  ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Obx(
                    () => Expanded(
                      child: getx.isVideoDashBoard.value
                          ? Padding(
                              padding: !getx.isCollapsed.value
                                  ? EdgeInsets.only(top: 10, right: 10)
                                  : EdgeInsets.all(0),
                              child: VideoDashboardVDRight(),
                            )
                          : getx.isLiveDashBoard.value
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, right: 10),
                                  child: LiveDashboardUI(),
                                )
                              : getx.isBookDashBoard.value
                                  ? BookListPagePc()
                                  : getx.isBackupDashBoard.value
                                      ? SizedBox()
                                      :
                                      // : Mcq()
                                      getx.isMCQDashBoard.value
                                          ? McqDashboard()
                                          : getx.isTheoryDashBoard.value
                                              ? TheoryExamPaperList()
                                              : getx.isPodcastDashboard.value
                                                  ? PodcastDashBoard()
                                                  : DefaultDashBoardRight(),
                    ),
                  ), // Main content area
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilePathWidget extends StatelessWidget {
  final List<String> path;

  FilePathWidget({required this.path});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        // spacing: 1.0,
        children: path.map((part) {
          return GestureDetector(
            onTap: () {
              // Implement onTap functionality if needed
              print('Tapped on: $part');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  part,
                  style: TextStyle(
                    color: ColorPage.colorblack,
                  ),
                ),
                if (part != path.last)
                  Text(' > ',
                      style: TextStyle(
                        color: Colors.grey,
                      )),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SlideBarPackageDetails extends StatefulWidget {
  final int packageId;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String headname;
  final String ExpiryDate;

  const SlideBarPackageDetails({
    super.key,
    required this.packageId,
    required this.headname,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.ExpiryDate,
  });

  @override
  State<SlideBarPackageDetails> createState() => _SlideBarPackageDetailsState();
}

class _SlideBarPackageDetailsState extends State<SlideBarPackageDetails> {
  Getx getx = Get.find<Getx>();
  int hoverIndex = -1;

  String pagename = '';

  paging(String pageName) {
    switch (pageName) {
      case 'Video':
        getx.isVideoDashBoard.value = true;
        getx.isLiveDashBoard.value = false;
        getx.isTheoryDashBoard.value = false;
        getx.isBookDashBoard.value = false;
        getx.isMCQDashBoard.value = false;
        getx.isBackupDashBoard.value = false;
        getx.isPDFDashBoard.value = false;
        getx.isPodcastDashboard.value = false;

        break;
      case 'Podcast':
        getx.isVideoDashBoard.value = false;
        getx.isLiveDashBoard.value = false;
        getx.isTheoryDashBoard.value = false;
        getx.isBookDashBoard.value = false;
        getx.isMCQDashBoard.value = false;
        getx.isBackupDashBoard.value = false;
        getx.isPDFDashBoard.value = false;
        getx.isPodcastDashboard.value = true;

        break;

      case 'PDF':
        getx.isVideoDashBoard.value = false;
        getx.isLiveDashBoard.value = false;
        getx.isTheoryDashBoard.value = false;
        getx.isBookDashBoard.value = false;
        getx.isMCQDashBoard.value = false;
        getx.isBackupDashBoard.value = false;
        getx.isPDFDashBoard.value = true;
        getx.isPodcastDashboard.value = false;

        break;
      case 'Live':
        getx.isVideoDashBoard.value = false;

        getx.isLiveDashBoard.value = true;
        getx.isTheoryDashBoard.value = false;
        getx.isBookDashBoard.value = false;
        getx.isMCQDashBoard.value = false;
        getx.isBackupDashBoard.value = false;
        getx.isPDFDashBoard.value = false;
        getx.isPodcastDashboard.value = false;
        break;
      case 'VideosBackup':
        getx.isVideoDashBoard.value = false;

        getx.isLiveDashBoard.value = false;
        getx.isTheoryDashBoard.value = false;
        getx.isBookDashBoard.value = false;
        getx.isMCQDashBoard.value = false;
        getx.isBackupDashBoard.value = true;
        getx.isPDFDashBoard.value = false;
        getx.isPodcastDashboard.value = false;
        break;
      case 'MCQ':
        getx.isVideoDashBoard.value = false;

        getx.isLiveDashBoard.value = false;
        getx.isTheoryDashBoard.value = false;
        getx.isBookDashBoard.value = false;
        getx.isMCQDashBoard.value = true;
        getx.isBackupDashBoard.value = false;
        getx.isPDFDashBoard.value = false;
        getx.isPodcastDashboard.value = false;
        break;
      case 'Book':
        getx.isVideoDashBoard.value = false;
        getx.isLiveDashBoard.value = false;
        getx.isTheoryDashBoard.value = false;
        getx.isBookDashBoard.value = true;
        getx.isMCQDashBoard.value = false;
        getx.isBackupDashBoard.value = false;
        getx.isPDFDashBoard.value = false;
        getx.isPodcastDashboard.value = false;

        break;

      case "Test":
        getx.isVideoDashBoard.value = false;
        getx.isLiveDashBoard.value = false;

        getx.isTheoryDashBoard.value = true;
        getx.isBookDashBoard.value = false;
        getx.isMCQDashBoard.value = false;
        getx.isBackupDashBoard.value = false;
        getx.isPDFDashBoard.value = false;
        getx.isPodcastDashboard.value = false;
        // Get.toNamed("/Theoryexampage");
        break;
      default:
        print("null page");
    }
  }

  getPodcast() async {
    podcastCount = await fetchPodcast(widget.packageId.toString(), 'Podcast');
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

  @override
  void initState() {
    initializeData();
    globalContext = context;
    super.initState();
  }

  List<Map<String, dynamic>> podcastCount = [];
  RxList mcqSetList = [].obs;
  RxList mcqPaperList = [].obs;
  RxInt mcqTotalLength = 0.obs;
  late BuildContext globalContext;

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
        await getAllPackageDetailsForBooksCount(widget.packageId.toString());

    if (data.isNotEmpty) {
      setState(() {
        booksCountData.value = data.length;
      });
    }
    print(booksCountData);
  }

  section() {
    getSectionListOfPackage(widget.packageId).whenComplete(
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
    var data =
        await getAllPackageDetailsForVideoCount(widget.packageId.toString());
    if (data.isNotEmpty) {
      hasData.value = false;
      for (var i in data) {
        if (i['AllowDuration'] != "") {
          allowedDuration.value =
              allowedDuration.value + int.parse(i['AllowDuration']);
          videoCountData.value = data.length;
          getx.totalVideocount.value = data.length;

          int seconds = allowedDuration.value;
          getx.totalAllowDurationinSeconds.value = allowedDuration.value;
          int minutes = seconds ~/ 60;
          int hours = minutes ~/ 60;

          formattedDuration.value =
              hours > 0 ? "$hours hr ${minutes % 60} min" : "$minutes min";
          getx.totalAllowDuration.value =
              hours > 0 ? "$hours hr ${minutes % 60} min" : "$minutes min";
        }
        print(videoCountData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                color: ColorPage.white,
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 3,
                //     color: Color.fromARGB(255, 192, 191, 191),
                //     offset: Offset(0, 0),
                //   ),
                // ],
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 12, right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  onExitPage(context, () {
                                    getx.alwaysShowChapterfilesOfVideo.clear();
                                    getx.alwaysShowFileDetailsOfpdf.clear();
                                    getx.liveList.clear();
                                    getx.alwaysShowChapterDetailsOfVideo
                                        .clear();
                                    print(getx
                                        .alwaysShowChapterfilesOfVideo.length);
                                    print(getx.alwaysShowChapterDetailsOfVideo
                                        .length);

                                    Get.offAll(
                                        transition: Transition.leftToRight,
                                        () => DthDashboard());
                                  }, () {
                                    Navigator.pop(context);
                                  });
                                },
                                icon: Icon(Icons.arrow_back)),

                            // ),
                            IconButton(
                                onPressed: () {
                                  getx.isCollapsed.value =
                                      !getx.isCollapsed.value;
                                },
                                icon: Icon(Icons.close))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              image:
                                  DecorationImage(image: AssetImage(logopath))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                textAlign: TextAlign.start,
                                widget.headname,
                                style: FontFamily.font.copyWith(fontSize: 17),
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          // IconButton(
                          //     onPressed: () {
                          //       getx.isCollapsed.value =
                          //           !getx.isCollapsed.value;
                          //     },
                          //     icon: Icon(Icons.close))
                        ],
                      ),
                      getx.sectionListOfPackage.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: getx.sectionListOfPackage.length,
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
                                              widget.packageId.toString())
                                      .length;

                                  return getx.sectionListOfPackage[index]
                                                  ["section"] ==
                                              "PDF" ||
                                          getx.sectionListOfPackage[index]
                                                  ["section"] ==
                                              "YouTube"
                                      ? SizedBox()
                                      : Obx(
                                          () => buttonWidget(() {
                                            if (widget.selectedIndex != index) {
                                              resetTblLocalNavigationByOrderOnsection(
                                                  1);
                                              print(getx.sectionListOfPackage[
                                                      index]['section'] +
                                                  "wow mc");

                                              insertTblLocalNavigation(
                                                      "Section",
                                                      widget.packageId
                                                          .toString(),
                                                      getx.sectionListOfPackage[
                                                          index]["section"])
                                                  .whenComplete(() => null);

                                              getMainChapter(widget.packageId);

                                              getLocalNavigationDetails();

                                              getx.selectedPackageId.value =
                                                  widget.packageId;
                                              widget.onItemSelected(index);

                                              paging(getx.sectionListOfPackage[
                                                  index]["section"]);
                                            }
                                          },
                                              widget.selectedIndex == index,
                                              hoverIndex == index,
                                              index,
                                              getx.sectionListOfPackage[index]
                                                  ["section"],
                                              videoCountData.toString(),
                                              liveCount.toString(),
                                              booksCountData.toString(),
                                              theorySetList.length.toString(),
                                              mcqSetList.length.toString(),
                                              podcastCount.length.toString()),
                                        );
                                },
                              ),
                            )
                          : Center(
                              child: Text("No section found"),
                            ),
                      Opacity(
                        opacity: 0.6,
                        child: Column(
                          children: [
                            // Image.asset(
                            //   logopath,
                            //   height: 30,
                            // ),
                            Text(
                              'Expiry Date:\n${formatDate(widget.ExpiryDate)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600),
                            ),

                            const SizedBox(height: 5),
                            Text(
                              "Version ${getx.appVersion.value}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget buttonWidget(
    void Function()? onTap,
    bool isActive,
    bool isHover,
    int index,
    String foldername,
    String videoCount,
    String liveCount,
    String bookCount,
    String testCount,
    String mcqCount,
    String podcustCount,
  ) {
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

    List<Color> gradientColorsList(String foldername) {
      final iconData = folderIcons.firstWhere(
        (item) => item['section'] == foldername,
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

    Color backgroundColor =
        isActive ? Colors.blue.withOpacity(0.1) : Colors.white;

    Color selectColor = isActive || isHover
        ? const Color.fromARGB(255, 12, 0, 78)
        : const Color.fromARGB(115, 5, 0, 51);
    Color selectColoricon = isActive || isHover
        ? const Color.fromARGB(255, 12, 0, 78)
        : Colors.grey;

    Icon getFolderIcon(String foldername) {
      switch (foldername) {
        case "Video":
          return Icon(Icons.video_library, color: Colors.blue);
        case "Live":
          return Icon(Icons.live_tv, color: Colors.red);
        case "VideosBackup":
          return Icon(Icons.backup, color: Colors.orange);
        case "MCQ":
          return Icon(Icons.question_answer, color: Colors.green);
        case "Theory":
          return Icon(Icons.book, color: Colors.purple);
        case "Book":
          return Icon(Icons.library_books, color: Colors.brown);
        case "Test":
          return Icon(Icons.book, color: const Color.fromARGB(255, 27, 31, 78));
        case "Podcast":
          return Icon(Icons.podcasts,
              color: const Color.fromARGB(255, 41, 207, 171));
        default:
          return Icon(Icons.folder, color: Colors.blue);
      }
    }

    getCountDetailsForAllFolder(String foldername) {
      double fontSize = 16.0;
      switch (foldername) {
        case "Video":
          return Text(
            videoCount,
            style: FontFamily.style.copyWith(
              fontSize: fontSize,
            ),
          );
        case "Live":
          return Text(
            liveCount,
            style: FontFamily.style.copyWith(fontSize: fontSize),
          );
        case "VideosBackup":
          return null;
        case "MCQ":
          // return null;
          return Text(
            mcqCount,
            style: FontFamily.style.copyWith(fontSize: fontSize),
          );
        case "Theory":
          return null;
        case "Book":
          return Text(
            bookCount,
            style: FontFamily.style.copyWith(
              fontSize: fontSize,
            ),
          );
        case "Test":
          // return null;
          return Text(
            testCount,
            style: FontFamily.style.copyWith(fontSize: fontSize),
          );
        case "Podcast":
          return Text(
            podcustCount,
            style: FontFamily.style.copyWith(fontSize: fontSize),
          );
        default:
          return null;
      }
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoverIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          hoverIndex = -1;
        });
      },
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColorsList(foldername)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: ListTile(
                leading: getFolderIcon(foldername),
                trailing: getCountDetailsForAllFolder(foldername),
                title: Text(
                  foldername,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: selectColoricon),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class VideoListLeft extends StatefulWidget {
//   VideoListLeft({
//     super.key,
//   });

//   @override
//   State<VideoListLeft> createState() => _VideoListLeftState();
// }

// class _VideoListLeftState extends State<VideoListLeft> {
//   int lastTapVideoIndex = -1; // Track the last tapped item index
//   DateTime lastTapvideoTime = DateTime.now();
//   var color = Color.fromARGB(255, 102, 112, 133);
//   Getx getx = Get.put(Getx());

//   int flag = 2;
//   int selectedVideoIndex = -1;
//   int selectedvideoListIndex = -1;
//   @override
//   void handleTap(int index) {
//     DateTime now = DateTime.now();
//     if (index == lastTapVideoIndex &&
//         now.difference(lastTapvideoTime) < Duration(seconds: 1)) {
//       print('Double tapped on folder: $index');
//     }
//     lastTapVideoIndex = index;
//     lastTapvideoTime = now;
//   } // Track the selected list tile

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.sizeOf(context).width;
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: ColorPage.white,
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 3,
//             color: Color.fromARGB(255, 192, 191, 191),
//             offset: Offset(0, 0),
//           ),
//         ],
//       ),
//       child: Obx(()=>
//          Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           child: ListView.builder(
//             shrinkWrap: true,
//             // physics: NeverScrollableScrollPhysics(),
//             itemCount: getx.alwaysShowChapterfiles.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onDoubleTap: () {
//                   Get.to(() => VideoPlayer());

//                   print("object find");
//                 },
//                 onTap: () {
//                   setState(() {
//                     selectedVideoIndex = index;
//                   });

//                   handleTap(index);
//                 },
//                 child: Card(
//                   color: selectedVideoIndex == index
//                       ? ColorPage.colorbutton.withOpacity(0.9)
//                       : Color.fromARGB(255, 245, 243, 248),
//                   child: ListTile(
//                     leading: Image.asset(
//                       "assets/video2.png",
//                       scale: 19,
//                       color: selectedVideoIndex == index
//                           ? ColorPage.white.withOpacity(0.85)
//                           : ColorPage.colorbutton,
//                     ),
//                     subtitle: Text(
//                       'Duration: ${getx.alwaysShowChapterfiles[index]['AllowDuration']}',
//                       style: TextStyle(
//                         color: selectedVideoIndex == index
//                             ? ColorPage.white.withOpacity(0.9)
//                             : ColorPage.grey,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     title: Text(
//                       getx.alwaysShowChapterfiles[index]['FileIdName'],
//                       style: GoogleFonts.inter().copyWith(
//                         color: selectedVideoIndex == index
//                             ? ColorPage.white
//                             : ColorPage.colorblack,
//                         fontWeight: FontWeight.w800,
//                         fontSize: selectedvideoListIndex == index ? 20 : null,
//                         // color: selectedListIndex == index
//                         //     ? Colors.amber[900]
//                         //     : Colors.black,
//                       ),
//                     ),
//                     trailing: SizedBox(

//                       child: IconButton(
//                           onPressed: () {
//                             getx.path3.value =
//                                 'Dthlms Video no- ${index + 1}.mp4';

//                             Get.to(() => VideoPlayer());
//                           },
//                           icon: Icon(
//                             Icons.play_circle,
//                             color: selectedVideoIndex == index
//                                 ? ColorPage.white
//                                 : ColorPage.colorbutton,
//                           )),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class VideoDashboardVDRight extends StatefulWidget {
  const VideoDashboardVDRight({super.key});

  @override
  State<VideoDashboardVDRight> createState() => _VideoDashboardVDRightState();
}

class _VideoDashboardVDRightState extends State<VideoDashboardVDRight> {
  int selectedIndex = -1; // Track the selected item index
  int lastTapIndex = -1;
  int selectedVideoIndex = -1;
  int selectedvideoListIndex = -1;
  // Track the last tapped item index
  DateTime lastTapTime = DateTime.now(); // Track the last tap time
  Getx getx = Get.put(Getx());

  RxBool expanded = false.obs;
  int? selectedListIndex = -1;
  int selectedIndexOfVideoList = 0;
  String? _videoFilePath;
  CancelToken cancelToken = CancelToken();
  late VideoPlayClass videoPlay;
  List<double> downloadProgress = List.filled(1000, 0.0);
  // int selectedIndex = -1;
  TextEditingController searchController = TextEditingController();
  List<dynamic> filteredChapterDetails = [];
  List<dynamic> filteredFileDetails = [];

  late final Dio dio;
  List<Widget> page = [];
  // List to store filtered items

  @override
  void initState() {
    getx.isVideoPlayer.value = false;
    videoPlay = VideoPlayClass();
    dio = Dio();
    page = [
      Pdf(),
      Mcq(),
      Tags(), // Pass videoPlay instance here
      AskDoubt()
    ];

    super.initState();
    getListStructure();

    filteredChapterDetails = getx.alwaysShowChapterDetailsOfVideo;
    filteredFileDetails =
        getx.alwaysShowChapterfilesOfVideo; // Initialize with full list
    int callCount = 0;

    Timer.periodic(Duration(seconds: 1), (timer) {
      // Increment the counter
      callCount++;

      // Call the function
      getLocalNavigationDetails();

      // Check if the counter has reached 5
      if (callCount >= 5) {
        // Cancel the timer
        timer.cancel();
      }
    });
  }

  Future getListStructure() async {
    print('object541541541541');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    getx.isFolderview.value = prefs.getBool("folderview") ?? true;
    int startParentId = 0;
    if (getx.selectedPackageId.value > 0) {
      await getStartParentId(getx.selectedPackageId.value).then((value) async {
        print("complete startparent Id");

        await getChapterContents(value).then((onValue) {
          print("complete chapter content");
          getChapterFiles(
              parentId: value,
              "Video",
              getx.selectedPackageId.value.toString());
          getChapterFiles(
              parentId: value, "PDF", getx.selectedPackageId.value.toString());
        });
      });
    } else {
      print("Packageapter  is null");
    }
  }

  // void filterSearchResults(String query) {
  //   if (query.isEmpty) {
  //     setState(() {
  //       filteredChapterDetails = [
  //         ...getx.alwaysShowChapterDetailsOfVideo,
  //         ...getx.alwaysShowFileDetailsOfpdf
  //       ];
  //       // filteredChapterDetails = getx.alwaysShowChapterDetailsOfVideo;
  //       filteredFileDetails =
  //           getx.alwaysShowChapterfilesOfVideo; // Show full list
  //     });
  //   } else {
  //     setState(() {
  //       filteredChapterDetails = getx.alwaysShowChapterDetailsOfVideo
  //           .where((chapter) => chapter['SectionChapterName']
  //               .toLowerCase()
  //               .contains(query.toLowerCase()))
  //           .toList();
  //       filteredFileDetails = getx.alwaysShowChapterfilesOfVideo
  //           .where((chapter) => chapter['FileIdName']
  //               .toLowerCase()
  //               .contains(query.toLowerCase()))
  //           .toList(); // Filtered list based on search query
  //     });
  //   }
  // }
  bool isColorBlue = false;

  Future<String> getVideosDirectoryPath() async {
    final String userHomeDir =
        Platform.environment['USERPROFILE'] ?? 'C:\\Users\\Default';

    final String videosDirPath = p.join(userHomeDir, 'Videos');

    print('Videos Directory Path: $videosDirPath');

    return videosDirPath;
  }

  void cancelDownload(CancelToken cancelToken) {
    cancelToken.cancel("Download canceled by user.");
    print("Download canceled");
  }

  void deleteWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Delete Video',
          description:
              'Are you sure you want to delete this video? This action is permanent and cannot be undone.',
          OnCancell: () {
            Navigator.of(context).pop();
          },
          OnConfirm: (String reason) {
            Navigator.of(context).pop();
          },
          btn1: 'Cancel',
          btn2: 'Delete',
          linkText: 'Learn more about deleting videos',
          isTextfeild: false,
        );
      },
    );
  }

  deleteVideo() {
    deleteWarning();
  }

  Future<void> startDownload2(int index, String Link, String title,
      CancelToken cancelToken // Optional CancelToken
      ) async {
    if (Link == "0") {
      print("Video link is $Link");
      return;
    }

    final appDocDir;
    try {
      var prefs = await SharedPreferences.getInstance();
      if (Platform.isAndroid) {
        final path = await getApplicationDocumentsDirectory();
        appDocDir = path.path;
      } else {
        appDocDir = await getVideosDirectoryPath();
      }

      getx.defaultPathForDownloadVideo.value =
          appDocDir + '\\$origin' + '\\Downloaded_videos';
      prefs.setString("DefaultDownloadpathOfVieo",
          appDocDir + '\\$origin' + '\\Downloaded_videos');
      print(getx.userSelectedPathForDownloadVideo.value +
          " it is user selected path");

      String savePath = getx.userSelectedPathForDownloadVideo.isEmpty
          ? appDocDir + '\\$origin' + '\\Downloaded_videos' + '\\$title'
          : getx.userSelectedPathForDownloadVideo.value + '\\$title';

      String tempPath = appDocDir + '\\temp' + '\\$title';

      // Ensure the temporary directory exists
      await Directory(appDocDir + '\\temp').create(recursive: true);

      // Start downloading the video
      await dio.download(
        Link,
        tempPath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total * 100);
            setState(() {
              downloadProgress[index] = progress;
            });
          }
        },
      );

      // After the download is complete, copy the file to the final location
      final tempFile = File(tempPath);
      final finalFile = File(savePath);

      // Ensure the final directory exists
      await finalFile.parent.create(recursive: true);

      // Copy the file to the final path
      await tempFile.copy(savePath);

      // Delete the temporary file
      await tempFile.delete();

      setState(() {
        _videoFilePath = savePath;
        getx.playingVideoId.value =
            getx.alwaysShowChapterfilesOfVideo[index]["FileId"];
        videoPlay.updateVideoLink(savePath, []);
        setState(() {});
        onSweetAleartDialogwithDeny(
            context,
            () {
              Get.back();

              fetchUploadableVideoInfo().then((valueList) async {
                print(valueList);
                if (getx.isInternet.value) {
                  unUploadedVideoInfoInsert(
                      context, valueList, getx.loginuserdata[0].token, false);
                }
                if (await isProcessRunning("dthlmspro_video_player") == false) {
                  run_Video_Player_exe(
                      savePath,
                      getx.loginuserdata[0].token,
                      getx.playingVideoId.value,
                      getx.selectedPackageId.value.toString(),
                      getx.dbPath.value);
                }
                if (await isProcessRunning("dthlmspro_video_player") == true) {
                  Get.showSnackbar(GetSnackBar(
                    isDismissible: true,
                    shouldIconPulse: true,
                    icon: const Icon(
                      Icons.video_chat,
                      color: Colors.white,
                    ),
                    snackPosition: SnackPosition.TOP,
                    title: 'Player is already open',
                    message: 'Please check your taskbar.',
                    mainButton: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    duration: const Duration(seconds: 3),
                  ));
                }
              });
            },
            "Downloaded",
            "Do you want to Play the Video?",
            () {
              Get.back();
            });
      });

      print('$savePath video saved to this location');

      // Insert the downloaded file data into the database
      await insertDownloadedFileData(
          getx.alwaysShowChapterfilesOfVideo[index]["PackageId"],
          getx.alwaysShowChapterfilesOfVideo[index]["FileId"],
          savePath,
          'Video',
          title);

      insertVideoDownloadPath(
        getx.alwaysShowChapterfilesOfVideo[index]["FileId"],
        getx.alwaysShowChapterfilesOfVideo[index]["PackageId"],
        savePath,
        context,
      );
    } catch (e) {
      writeToFile(e, "startDownload2");
      if (e is DioException && e.type == DioExceptionType.cancel) {
        print("Download was canceled");
      } else {
        print(e.toString() + " error on download");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: !getx.isCollapsed.value ? 5 : 0,
      ),
      child: Obx(
        () => Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                  getx.subjectDetails.isNotEmpty
                                      ? getx.subjectDetails[0]["SubjectName"]
                                      : "Subject Name",
                                  style: FontFamily.font),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text.rich(TextSpan(
                                  text: 'Total Videos :',
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: "  ${getx.totalVideocount.value}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ])),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text.rich(TextSpan(
                                  text: 'Total Duration :',
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: " ${getx.totalAllowDuration.value}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ])),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text.rich(TextSpan(
                                  text: 'Consume Duration :',
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text:
                                          " ${breakSecondIntoHourAndMinute(getLocalConsumeDurationOfPackage(getx.selectedPackageId.toString()))}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ])),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text.rich(TextSpan(
                                  text: 'Remaining Durations :',
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text:
                                          "${breakSecondIntoHourAndMinute(getx.totalAllowDurationinSeconds.value - getLocalConsumeDurationOfPackage(getx.selectedPackageId.toString()))}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ])),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  pickVideoFile();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .blueAccent, // Button background color
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Rounded corners
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: 12, // Font size
                                    fontWeight: FontWeight.w700, // Font weight
                                  ),
                                ),
                                child: Text(
                                  "Browse",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Tooltip(
                                message: "Folder View",
                                child: IconButton(
                                  onPressed: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool("folderview", true);

                                    getx.isFolderview.value = true;
                                  },
                                  icon: Icon(
                                    Icons.grid_view_rounded,
                                    color: getx.isFolderview.value
                                        ? ColorPage.colorbutton
                                        : ColorPage.colorblack,
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: "List View",
                                child: IconButton(
                                  onPressed: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool("folderview", false);
                                    getx.isFolderview.value = false;
                                  },
                                  icon: Icon(
                                    Icons.view_list,
                                    color: !getx.isFolderview.value
                                        ? ColorPage.colorbutton
                                        : ColorPage.colorblack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 7,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //     blurRadius: 3,
                      //     color: Color.fromARGB(255, 192, 191, 191),
                      //     offset: Offset(0, 0),
                      //   ),
                      // ],
                      // color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              getx.isCollapsed.value
                                  ? IconButton(
                                      icon: Icon(Icons.list),
                                      onPressed: () {
                                        getx.isCollapsed.value =
                                            !getx.isCollapsed.value;
                                      },
                                    )
                                  : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Obx(
                                  () => SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (var i = 0;
                                            i < getx.navigationList.length;
                                            i++)
                                          getx.navigationList.isEmpty
                                              ? Text("Blank")
                                              : InkWell(
                                                  onTap: () {
                                                    getx.isVideoPlayer.value =
                                                        false;
                                                    if (i == 0) {
                                                      // nothing
                                                    }
                                                    if (i == 1) {
                                                      print('press in video');
                                                      resetTblLocalNavigationByOrder(
                                                          2);
                                                      getStartParentId(int.parse(
                                                              getx.navigationList[
                                                                      1][
                                                                  'NavigationId']))
                                                          .then((value) {
                                                        print(value);
                                                        getChapterContents(
                                                            int.parse(value
                                                                .toString()));
                                                        getChapterFiles(
                                                            parentId: int.parse(
                                                                value
                                                                    .toString()),
                                                            'PDF',
                                                            getx.selectedPackageId
                                                                .value
                                                                .toString());
                                                        getChapterFiles(
                                                            parentId: int.parse(
                                                                value
                                                                    .toString()),
                                                            'Video',
                                                            getx.selectedPackageId
                                                                .value
                                                                .toString());
                                                      });
                                                      getLocalNavigationDetails();
                                                    }
                                                    if (i == 2) {
                                                      print('press in video');
                                                      resetTblLocalNavigationByOrder(
                                                          2);
                                                      getStartParentId(int.parse(
                                                              getx.navigationList[
                                                                      1][
                                                                  'NavigationId']))
                                                          .then((value) {
                                                        print(value);
                                                        getChapterContents(
                                                            int.parse(value
                                                                .toString()));
                                                        getChapterFiles(
                                                            parentId: int.parse(
                                                                value
                                                                    .toString()),
                                                            'PDF',
                                                            getx.selectedPackageId
                                                                .value
                                                                .toString());
                                                        getChapterFiles(
                                                            parentId: int.parse(
                                                                value
                                                                    .toString()),
                                                            'Video',
                                                            getx.selectedPackageId
                                                                .value
                                                                .toString());
                                                      });
                                                      getLocalNavigationDetails();
                                                    }
                                                    if (i > 2) {
                                                      resetTblLocalNavigationByOrder(
                                                          i);
                                                      getChapterContents(int.parse(
                                                          getx.navigationList[i]
                                                              [
                                                              'NavigationId']));
                                                      getChapterFiles(
                                                          parentId: int.parse(
                                                              getx.navigationList[
                                                                      i][
                                                                  'NavigationId']),
                                                          'PDF',
                                                          getx.selectedPackageId
                                                              .value
                                                              .toString());
                                                      getLocalNavigationDetails();
                                                      getChapterFiles(
                                                          parentId: int.parse(
                                                              getx.navigationList[
                                                                      i][
                                                                  'NavigationId']),
                                                          'Video',
                                                          getx.selectedPackageId
                                                              .value
                                                              .toString());
                                                      getLocalNavigationDetails();
                                                    }
                                                    print(getx
                                                        .alwaysShowChapterDetailsOfVideo
                                                        .length);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      ClipPath(
                                                        clipper:
                                                            NavigationClipper1(),
                                                        child: Container(
                                                          height: 30,
                                                          width: 20,
                                                          color: i ==
                                                                  getx.navigationList
                                                                          .length -
                                                                      1
                                                              ? Colors.blue
                                                              : Colors.white,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      50),
                                                        ),
                                                      ),

                                                      ClipPath(
                                                        child: Container(
                                                          width: (() {
                                                            int nameLength = getx
                                                                .navigationList[
                                                                    i][
                                                                    "NavigationName"]
                                                                .length;

                                                            if (nameLength >=
                                                                16) {
                                                              return 210.0;
                                                            } else if (nameLength >=
                                                                13) {
                                                              return 190.0;
                                                            } else if (nameLength >=
                                                                10) {
                                                              return 170.0;
                                                            } else if (nameLength >=
                                                                7) {
                                                              return 150.0;
                                                            } else {
                                                              return 100.0;
                                                            }
                                                          })(),

                                                          decoration:
                                                              BoxDecoration(
                                                            color: i ==
                                                                    getx.navigationList
                                                                            .length -
                                                                        1
                                                                ? Colors.blue
                                                                : Colors.white,

                                                            // border: Border.all(color: Colors.amber)
                                                          ),
                                                          height: 30,
                                                          // width: 150,

                                                          child: Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child: Text(
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  getx.navigationList[
                                                                          i][
                                                                      "NavigationName"],
                                                                  style: FontFamily.styleb.copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: i ==
                                                                              getx.navigationList.length -
                                                                                  1
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black54)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      ClipPath(
                                                        clipper:
                                                            NavigationClipper(),
                                                        child: Container(
                                                          height: 30,
                                                          width: 20,
                                                          color: i ==
                                                                  getx.navigationList
                                                                          .length -
                                                                      1
                                                              ? Colors.blue
                                                              : Colors.white,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      50),
                                                        ),
                                                      ),

                                                      // Padding(
                                                      //   padding: const EdgeInsets
                                                      //       .symmetric(
                                                      //       horizontal: 1),
                                                      //   child: Icon(
                                                      //     Icons.chevron_right,
                                                      //     color: Colors.grey,
                                                      //     size: 20,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                      ],
                                    ),
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
              ),
            ),
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              color: Color.fromARGB(255, 192, 191, 191),
                              offset: Offset(0, 0),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Obx(
                          () => Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: getx.isVideoPlayer.value
                                    ? videoPlayerLeft()
                                    : getx.isFolderview.value
                                        ? buildGridView()
                                        : buildListView(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 11,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 7, right: getx.isCollapsed.value ? 10 : 0),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color.fromARGB(255, 192, 191, 191),
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: getx.isVideoPlayer.value
                                  ? videoPlayerRight(expanded.value)
                                  : buildFileList(),
                            ),
                          ),
                        ),
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
  }

  Widget buildGridView() {
    return Container(
      padding: EdgeInsets.all(10),
      child: filteredChapterDetails.isNotEmpty ||
              getx.alwaysShowFileDetailsOfpdf.isNotEmpty
          ? GridView.builder(
              itemCount: filteredChapterDetails.length +
                  getx.alwaysShowFileDetailsOfpdf.length,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getx.isCollapsed.value ? 5 : 4,
                childAspectRatio: 1.0,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                if (filteredChapterDetails.length +
                        getx.alwaysShowFileDetailsOfpdf.length ==
                    0) {
                  getx.isVideoPlayer.value = true;
                }
                if (filteredChapterDetails.length > index)
                  return buildGridItem(index, false);
                else
                  return buildGridItem(index, true);
                // else
              },
            )
          : Center(
              child: Text('No Data found'),
            ),
    );
  }

  Widget buildGridItem(int index, bool ispdf) {
    return InkWell(
      onTap: () {
        if (ispdf) {
          Get.to(
              transition: Transition.cupertino,
              () => ShowChapterPDF(
                    pdfUrl: getx.alwaysShowFileDetailsOfpdf[
                        index - filteredChapterDetails.length]["DocumentPath"],
                    title: getx.alwaysShowFileDetailsOfpdf[
                        index - filteredChapterDetails.length]["FileIdName"],
                    folderName: getPackagDataFieldValuebyId(
                        getx.alwaysShowFileDetailsOfpdf[index -
                                filteredChapterDetails.length]["PackageId"]
                            .toString(),
                        "PackageName"),
                    isEncrypted: getx.alwaysShowFileDetailsOfpdf[index -
                                filteredChapterDetails.length]["IsEncrypted"] ==
                            "1"
                        ? true
                        : false,
                  ));

          // selectedIndex = index;
        } else {
          insertTblLocalNavigation(
            "ParentId",
            filteredChapterDetails[index]['SectionChapterId'],
            filteredChapterDetails[index]['SectionChapterName'],
          ).whenComplete(() {
            getLocalNavigationDetails();
          });
          print(filteredChapterDetails[index]['SectionChapterId']);

          try {
            print(filteredChapterDetails[index]['SectionChapterId']);

            getChapterContents(
                int.parse(filteredChapterDetails[index]['SectionChapterId']));

            getChapterFiles(
                parentId: int.parse(
                    filteredChapterDetails[index]['SectionChapterId']),
                'PDF',
                getx.selectedPackageId.value.toString());
            getChapterFiles(
                parentId: int.parse(
                    filteredChapterDetails[index]['SectionChapterId']),
                'Video',
                getx.selectedPackageId.value.toString());
          } catch (e) {
            writeToFile(e, "buildGridItem");
            print(e.toString() + " ---$index");
          }
          // selectedIndex = index;
        }
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            color: selectedIndex == index
                ? ColorPage.blue.withOpacity(0.3)
                : Colors.transparent,
          ),
          child: Column(
            children: [
              !ispdf
                  ? Image.asset(
                      "assets/folder5.png",
                      scale: 8,
                    )
                  : Image.asset(
                      "assets/pdf5.png",
                      scale: 8,
                    ),
              AutoSizeText(
                ispdf
                    ? getx.alwaysShowFileDetailsOfpdf[
                        index - filteredChapterDetails.length]["FileIdName"]
                    : filteredChapterDetails[index]['SectionChapterName'],
                overflow: TextOverflow.ellipsis,
                style: FontFamily.font9.copyWith(color: ColorPage.colorblack),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListView() {
    return Container(
      padding: EdgeInsets.all(10),
      child: filteredChapterDetails.isNotEmpty ||
              getx.alwaysShowFileDetailsOfpdf.isNotEmpty
          ? ListView.builder(
              itemCount: filteredChapterDetails.length +
                  getx.alwaysShowFileDetailsOfpdf.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (filteredChapterDetails.length +
                        getx.alwaysShowFileDetailsOfpdf.length ==
                    0) {
                  getx.isVideoPlayer.value = true;
                }
                if (filteredChapterDetails.length > index)
                  return buildListItem(index, false);
                else
                  return buildListItem(index, true);
              },
            )
          : Center(
              child: Text('No data found'),
            ),
    );
  }

  Widget buildListItem(int index, bool ispdf) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Color.fromARGB(255, 192, 191, 191),
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: selectedIndex == index ? ColorPage.colorbutton : ColorPage.white,
      ),
      child: MaterialButton(
        onPressed: () {
          if (ispdf) {
            Get.to(
                transition: Transition.cupertino,
                () => ShowChapterPDF(
                      pdfUrl: getx.alwaysShowFileDetailsOfpdf[index -
                          filteredChapterDetails.length]["DocumentPath"],
                      title: getx.alwaysShowFileDetailsOfpdf[
                          index - filteredChapterDetails.length]["FileIdName"],
                      folderName: getPackagDataFieldValuebyId(
                          getx.alwaysShowFileDetailsOfpdf[index -
                                  filteredChapterDetails.length]["PackageId"]
                              .toString(),
                          "PackageName"),
                      isEncrypted: getx.alwaysShowFileDetailsOfpdf[
                                      index - filteredChapterDetails.length]
                                  ["IsEncrypted"] ==
                              "1"
                          ? true
                          : false,
                    ));
          } else {
            insertTblLocalNavigation(
              "ParentId",
              filteredChapterDetails[index]['SectionChapterId'],
              filteredChapterDetails[index]['SectionChapterName'],
            ).whenComplete(() {
              getLocalNavigationDetails();
            });
            print(filteredChapterDetails[index]['SectionChapterId']);

            try {
              print(filteredChapterDetails[index]['SectionChapterId']);

              getChapterContents(
                  int.parse(filteredChapterDetails[index]['SectionChapterId']));

              getChapterFiles(
                  parentId: int.parse(
                      filteredChapterDetails[index]['SectionChapterId']),
                  'PDF',
                  getx.selectedPackageId.value.toString());
              getChapterFiles(
                  parentId: int.parse(
                      filteredChapterDetails[index]['SectionChapterId']),
                  'Video',
                  getx.selectedPackageId.value.toString());
            } catch (e) {
              writeToFile(e, "buildListItem");
              print(e.toString() + " ---$index");
            }
          }
          setState(() {});
        },
        child: ListTile(
          leading: ispdf
              ? Image.asset(
                  "assets/pdf5.png",
                  width: 30,
                )
              : Image.asset(
                  "assets/folder8.png",
                  width: 30,
                ),
          trailing: Icon(
            Icons.arrow_forward_ios_sharp,
            size: 20,
            color:
                selectedIndex == index ? ColorPage.white : ColorPage.colorblack,
          ),
          title: Text(
            ispdf
                ? getx.alwaysShowFileDetailsOfpdf[
                    index - filteredChapterDetails.length]["FileIdName"]
                : filteredChapterDetails[index]['SectionChapterName'],
            style: FontFamily.font9.copyWith(
              fontWeight: FontWeight.bold,
              color: selectedIndex == index
                  ? ColorPage.white
                  : ColorPage.colorblack,
            ),
          ),
        ),
      ),
    );
  }

  Widget tabbarbutton(String name, int tabIndex, selectedindex) {
    bool isActive = selectedIndexOfVideoList == tabIndex;
    Color backgroundColor = isActive ? ColorPage.colorbutton : Colors.white;
    Color textColor = isActive ? Colors.white : Colors.black;

    return Expanded(
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            // hoverIndex = tabIndex;
          });
        },
        onExit: (_) {
          setState(() {
            // hoverIndex = -1;
          });
        },
        child: InkWell(
          onTap: () {
            setState(() {
              selectedIndexOfVideoList = tabIndex;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5, color: Color.fromARGB(255, 150, 145, 145)),
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget videoPlayerRight(bool expanded) {
    return expanded
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Color.fromARGB(255, 143, 141, 141),
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child:
                        // videoPlayerRight()

                        page[selectedIndexOfVideoList],
                  )

                  // child: isDownloadPathExitsOnVideoList()
                  //     ? videoPlayerRight()
                  //     : Column(
                  //         children: [
                  //           Container(
                  //               constraints:
                  //                   BoxConstraints(maxHeight: 500),
                  //               child: Center(
                  //                   child: Text(
                  //                 "No Video Downloaded",
                  //                 style: FontFamily.style,
                  //               ))),
                  //         ],
                  //       )
                  ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  logopath,
                  scale: 1.5,
                )
              ],
            ),
          );
  }

  Widget videoPlayerLeft() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorPage.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Color.fromARGB(255, 192, 191, 191),
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Video List",
                            style: FontFamily.font
                                .copyWith(color: ColorPage.colorbutton),
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder(
                        future: getPlayInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // print("${snapshot.data!} shubha snapshot data");

                            return ListView.builder(
                              shrinkWrap: true,
                              // Removed NeverScrollableScrollPhysics to allow natural scrolling
                              itemCount:
                                  getx.alwaysShowChapterfilesOfVideo.length,
                              itemBuilder: (context, index) {
                                // int duration = int.parse(
                                //         getx.alwaysShowChapterfilesOfVideo[
                                //             index]['AllowDuration']) -
                                //     int.parse(getLastEndDuration(int.parse(
                                //         getx.alwaysShowChapterfilesOfVideo[
                                //             index]['FileId'])));
                                bool isMatchingVideo = snapshot.data!.any(
                                    (videoInfo) =>
                                        videoInfo['VideoId'].toString() ==
                                        getx.alwaysShowChapterfilesOfVideo[
                                                index]['FileId']
                                            .toString());

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      ExpansionTile(
                                          collapsedBackgroundColor: isMatchingVideo
                                              ? Colors.blue[50]
                                              : Colors.white,
                                          enabled: File(getx.userSelectedPathForDownloadVideo.isEmpty ? getx.defaultPathForDownloadVideo.value + '\\' + getx.alwaysShowChapterfilesOfVideo[index]['FileIdName'] : getx.userSelectedPathForDownloadVideo.value + '\\' + getx.alwaysShowChapterfilesOfVideo[index]['FileIdName'])
                                                          .existsSync() ==
                                                      false &&
                                                  !expanded.value &&
                                                  getVideoPlayModeFromPackageId(getx
                                                          .selectedPackageId
                                                          .value
                                                          .toString()) ==
                                                      "false"
                                              ? false
                                              : true,
                                          backgroundColor: selectedListIndex == index
                                              ? ColorPage.white.withOpacity(0.5)
                                              : Color.fromARGB(
                                                  255, 255, 255, 255),
                                          onExpansionChanged: (isExpanded) {
                                            expanded.value = isExpanded;
                                            setState(() {
                                              selectedListIndex =
                                                  isExpanded ? index : -1;
                                              if (isExpanded) {
                                                getx.playingVideoId.value =
                                                    getx.alwaysShowChapterfilesOfVideo[
                                                        index]["FileId"];
                                                getMCQListOfVideo(
                                                    getx.alwaysShowChapterfilesOfVideo[
                                                        index]["PackageId"],
                                                    getx.alwaysShowChapterfilesOfVideo[
                                                        index]["FileId"]);

                                                getPDFlistOfVideo(
                                                    getx.alwaysShowChapterfilesOfVideo[
                                                        index]["PackageId"],
                                                    getx.alwaysShowChapterfilesOfVideo[
                                                        index]["FileId"]);

                                                getTaglistOfVideo(
                                                    getx.alwaysShowChapterfilesOfVideo[
                                                        index]["PackageId"],
                                                    getx.alwaysShowChapterfilesOfVideo[
                                                        index]["FileId"]);
                                              }
                                            });
                                          },
                                          leading: Image.asset(
                                            "assets/video2.png",
                                            scale: 19,
                                            color: ColorPage.colorbutton,
                                          ),
                                          subtitle: getPackagDataFieldValuebyId(
                                                      getx.selectedPackageId.toString(),
                                                      "isTotal") !=
                                                  "0"
                                              ? Text(
                                                  'Video duration:  ${breakSecondIntoHourAndMinute(int.parse(filteredFileDetails[index]['VideoDuration'].toString()))}',
                                                  style: TextStyle(
                                                    color: ColorPage.grey,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Video duration:  ${breakSecondIntoHourAndMinute(int.parse(filteredFileDetails[index]['VideoDuration'].toString()))}',
                                                          style: TextStyle(
                                                            color:
                                                                ColorPage.grey,
                                                            fontSize: 10,
                                                            // fontWeight: FontWeight.w800,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        SizedBox(
                                                          width: 90,
                                                          child: Text(
                                                            'Limit:  ${breakSecondIntoHourAndMinute(int.parse(filteredFileDetails[index]['AllowDuration'].toString()))}',
                                                            style: TextStyle(
                                                              color: ColorPage
                                                                  .grey,
                                                              fontSize: 10,
                                                              // fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Consume:  ${breakSecondIntoHourAndMinute(getTotalConsumeDurationOfVideo(filteredFileDetails[index]['FileId'].toString(), int.parse(filteredFileDetails[index]['ConsumeDuration'].toString())))}',
                                                          style: TextStyle(
                                                            color:
                                                                ColorPage.grey,
                                                            fontSize: 10,
                                                            // fontWeight: FontWeight.w800,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          'Remaining :  ${breakSecondIntoHourAndMinute(int.parse(filteredFileDetails[index]['AllowDuration'].toString()) - getTotalConsumeDurationOfVideo(filteredFileDetails[index]['FileId'].toString(), int.parse(filteredFileDetails[index]['ConsumeDuration'].toString())))}',
                                                          style: TextStyle(
                                                            color:
                                                                ColorPage.grey,
                                                            fontSize: 10,

                                                            // fontWeight: FontWeight.w800,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                          title: Text(
                                            getx.alwaysShowChapterfilesOfVideo[
                                                index]["FileIdName"],
                                            style: GoogleFonts.inter().copyWith(
                                              fontWeight: FontWeight.w800,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize:
                                                  selectedListIndex == index
                                                      ? 20
                                                      : null,
                                            ),
                                          ),
                                          trailing: SizedBox(
                                            width: 130,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                File(getx.userSelectedPathForDownloadVideo
                                                                        .isEmpty
                                                                    ? getx.defaultPathForDownloadVideo
                                                                            .value +
                                                                        '\\' +
                                                                        getx.alwaysShowChapterfilesOfVideo[index]
                                                                            [
                                                                            'FileIdName']
                                                                    : getx.userSelectedPathForDownloadVideo
                                                                            .value +
                                                                        '\\' +
                                                                        getx.alwaysShowChapterfilesOfVideo[index]
                                                                            [
                                                                            'FileIdName'])
                                                                .existsSync() ==
                                                            false &&
                                                        getVideoPlayModeFromPackageId(getx
                                                                .selectedPackageId
                                                                .value
                                                                .toString()) ==
                                                            "true"
                                                    ? Tooltip(
                                                        message: "Play Online",
                                                        child: IconButton(
                                                          onPressed: () {
                                                            getx.playLink
                                                                    .value =
                                                                getx.alwaysShowChapterfilesOfVideo[
                                                                        index][
                                                                    'DocumentPath'];

                                                            print(getx.alwaysShowChapterfilesOfVideo[
                                                                        index][
                                                                    'DocumentPath'] +
                                                                "////////");
                                                            print(getx.playLink
                                                                    .value +
                                                                "////////////");

                                                            if (getx.isInternet
                                                                .value) {
                                                              // List unUploadedeVideoinfo =await   fetchUploadableVideoInfo();
                                                              fetchUploadableVideoInfo()
                                                                  .then(
                                                                      (valueList) async {
                                                                print(
                                                                    valueList);

                                                                if (getx
                                                                    .isInternet
                                                                    .value) {
                                                                  await unUploadedVideoInfoInsert(
                                                                      context,
                                                                      valueList,
                                                                      getx
                                                                          .loginuserdata[
                                                                              0]
                                                                          .token,
                                                                      false);
                                                                }
                                                                getx.playingVideoId
                                                                        .value =
                                                                    getx.alwaysShowChapterfilesOfVideo[
                                                                            index]
                                                                        [
                                                                        'FileId'];
                                                                videoPlay.updateVideoLink(
                                                                    getx.playLink
                                                                        .value,
                                                                    []);
                                                                if (await isProcessRunning(
                                                                        "dthlmspro_video_player") ==
                                                                    false) {
                                                                  run_Video_Player_exe(
                                                                      getx.playLink
                                                                          .value,
                                                                      getx
                                                                          .loginuserdata[
                                                                              0]
                                                                          .token,
                                                                      getx.playingVideoId
                                                                          .value,
                                                                      getx.selectedPackageId
                                                                          .value
                                                                          .toString(),
                                                                      getx.dbPath
                                                                          .value);
                                                                }
                                                                if (await isProcessRunning(
                                                                        "dthlmspro_video_player") ==
                                                                    true) {
                                                                  Get.showSnackbar(
                                                                      GetSnackBar(
                                                                    isDismissible:
                                                                        true,
                                                                    shouldIconPulse:
                                                                        true,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .video_chat,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .TOP,
                                                                    title:
                                                                        'Player is already open',
                                                                    message:
                                                                        'Please check your taskbar.',
                                                                    mainButton:
                                                                        TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Ok',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            3),
                                                                  ));
                                                                }
                                                              });
                                                            } else {
                                                              onNoInternetConnection(
                                                                  context, () {
                                                                Get.back();
                                                              });
                                                            }
                                                          },
                                                          icon: Icon(
                                                            Icons
                                                                .play_circle_fill,
                                                            color: ColorPage
                                                                .colorbutton,
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                downloadProgress[index] == 0 &&
                                                        File(getx.userSelectedPathForDownloadVideo
                                                                        .isEmpty
                                                                    ? getx.defaultPathForDownloadVideo
                                                                            .value +
                                                                        '\\' +
                                                                        getx.alwaysShowChapterfilesOfVideo[index]
                                                                            [
                                                                            'FileIdName']
                                                                    : getx.userSelectedPathForDownloadVideo
                                                                            .value +
                                                                        '\\' +
                                                                        getx.alwaysShowChapterfilesOfVideo[index]
                                                                            [
                                                                            'FileIdName'])
                                                                .existsSync() ==
                                                            false
                                                    ? IconButton(
                                                        onPressed: () {
                                                          if (getx.isInternet
                                                              .value) {
                                                            cancelToken =
                                                                CancelToken();

                                                            startDownload2(
                                                                index,
                                                                getx.alwaysShowChapterfilesOfVideo[
                                                                        index][
                                                                    'DocumentPath'],
                                                                getx.alwaysShowChapterfilesOfVideo[
                                                                        index][
                                                                    'FileIdName'],
                                                                cancelToken);
                                                          } else {
                                                            onNoInternetConnection(
                                                                context, () {
                                                              Get.back();
                                                            });
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons.download,
                                                          color: ColorPage
                                                              .colorbutton,
                                                        ),
                                                      )
                                                    : downloadProgress[index] <
                                                                100 &&
                                                            downloadProgress[index] >
                                                                0
                                                        ? Row(
                                                            children: [
                                                              CircularPercentIndicator(
                                                                radius: 15.0,
                                                                lineWidth: 4.0,
                                                                percent:
                                                                    downloadProgress[
                                                                            index] /
                                                                        100,
                                                                center: Text(
                                                                  "${downloadProgress[index].toInt()}%",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10.0),
                                                                ),
                                                                progressColor:
                                                                    ColorPage
                                                                        .colorbutton,
                                                              ),
                                                              IconButton(
                                                                onPressed: () {
                                                                  cancelDownload(
                                                                      cancelToken);
                                                                  Future.delayed(Duration(
                                                                          seconds:
                                                                              1))
                                                                      .then(
                                                                    (value) {
                                                                      downloadProgress[
                                                                          index] = 0;
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                  );
                                                                },
                                                                icon: Icon(
                                                                  Icons.cancel,
                                                                  color: Colors
                                                                      .orange,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : IconButton(
                                                            onPressed:
                                                                () async {
                                                              getx.playLink
                                                                  .value = getx
                                                                      .userSelectedPathForDownloadVideo
                                                                      .isEmpty
                                                                  ? getx.defaultPathForDownloadVideo
                                                                          .value +
                                                                      '\\' +
                                                                      getx.alwaysShowChapterfilesOfVideo[
                                                                              index][
                                                                          'FileIdName']
                                                                  : getx.userSelectedPathForDownloadVideo
                                                                          .value +
                                                                      '\\' +
                                                                      getx.alwaysShowChapterfilesOfVideo[
                                                                              index]
                                                                          ['FileIdName'];
                                                              if (File(getx
                                                                          .userSelectedPathForDownloadVideo
                                                                          .isEmpty
                                                                      ? getx.defaultPathForDownloadVideo
                                                                              .value +
                                                                          '\\' +
                                                                          getx.alwaysShowChapterfilesOfVideo[index]
                                                                              [
                                                                              'FileIdName']
                                                                      : getx.userSelectedPathForDownloadVideo
                                                                              .value +
                                                                          '\\' +
                                                                          getx.alwaysShowChapterfilesOfVideo[index]
                                                                              [
                                                                              'FileIdName'])
                                                                  .existsSync()) {
                                                                // List unUploadedeVideoinfo =await   fetchUploadableVideoInfo();
                                                                fetchUploadableVideoInfo()
                                                                    .then(
                                                                        (valueList) async {
                                                                  print(
                                                                      valueList);

                                                                  if (getx
                                                                      .isInternet
                                                                      .value) {
                                                                    await unUploadedVideoInfoInsert(
                                                                        context,
                                                                        valueList,
                                                                        getx.loginuserdata[0]
                                                                            .token,
                                                                        false);
                                                                  }
                                                                  getx.playingVideoId
                                                                      .value = getx
                                                                              .alwaysShowChapterfilesOfVideo[
                                                                          index]
                                                                      [
                                                                      'FileId'];
                                                                  videoPlay.updateVideoLink(
                                                                      getx.playLink
                                                                          .value,
                                                                      []);
                                                                  if (await isProcessRunning(
                                                                          "dthlmspro_video_player") ==
                                                                      false) {
                                                                    run_Video_Player_exe(
                                                                        getx.playLink
                                                                            .value,
                                                                        getx
                                                                            .loginuserdata[
                                                                                0]
                                                                            .token,
                                                                        getx.playingVideoId
                                                                            .value,
                                                                        getx.selectedPackageId
                                                                            .value
                                                                            .toString(),
                                                                        getx.dbPath
                                                                            .value);
                                                                  }
                                                                  if (await isProcessRunning(
                                                                          "dthlmspro_video_player") ==
                                                                      true) {
                                                                    Get.showSnackbar(
                                                                        GetSnackBar(
                                                                      isDismissible:
                                                                          true,
                                                                      shouldIconPulse:
                                                                          true,
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .video_chat,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .TOP,
                                                                      title:
                                                                          'Player is already open',
                                                                      message:
                                                                          'Please check your taskbar.',
                                                                      mainButton:
                                                                          TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'Ok',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                      duration: const Duration(
                                                                          seconds:
                                                                              3),
                                                                    ));
                                                                  }
                                                                });
                                                              }

                                                              setState(() {});
                                                            },
                                                            icon: Icon(
                                                              Icons.play_circle,
                                                              color: ColorPage
                                                                  .colorbutton,
                                                            ),
                                                          ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    selectedListIndex == index
                                                        ? Icons
                                                            .keyboard_arrow_up
                                                        : Icons
                                                            .keyboard_arrow_down_outlined,
                                                    color:
                                                        ColorPage.colorbutton,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // initiallyExpanded: selectedListIndex == index,
                                          children: selectedListIndex == index
                                              ? [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Color.fromARGB(
                                                          255, 243, 243, 243),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5,
                                                          horizontal: 10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              tabbarbutton(
                                                                  'PDF',
                                                                  0,
                                                                  selectedListIndex ==
                                                                      index),
                                                              tabbarbutton(
                                                                  'MCQ',
                                                                  1,
                                                                  selectedListIndex ==
                                                                      index),
                                                              tabbarbutton(
                                                                  'TAG',
                                                                  2,
                                                                  selectedListIndex ==
                                                                      index),
                                                              tabbarbutton(
                                                                  'Ask doubt',
                                                                  3,
                                                                  selectedListIndex ==
                                                                      index),
                                                              IconButton(
                                                                tooltip:
                                                                    'Delete this video',
                                                                onPressed: () {
                                                                  deleteVideo();
                                                                },
                                                                icon: Icon(
                                                                  FontAwesome
                                                                      .trash_o,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          253,
                                                                          29,
                                                                          13),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          // page[selectedIndexOfVideoList],
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]
                                              : []),
                                      if (true)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: LinearProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.green),
                                            backgroundColor:
                                                Colors.green.withOpacity(0.3),
                                            value: calculateVideoWatchProgress(
                                                getTotalConsumeDurationOfVideo(
                                                    filteredFileDetails[index]
                                                            ['FileId']
                                                        .toString(),
                                                    int.parse(filteredFileDetails[
                                                                index]
                                                            ['ConsumeDuration']
                                                        .toString())),
                                                int.parse(filteredFileDetails[
                                                        index]['VideoDuration']
                                                    .toString())), // Progress value
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return CircularPercentIndicator(radius: 2);
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFileList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorPage.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Color.fromARGB(255, 192, 191, 191),
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Obx(
        () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: filteredFileDetails.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredFileDetails.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onDoubleTap: () async {
                          print(filteredFileDetails[index]['DocumentPath'] +
                              "  this is video link");
                          Get.to(
                            transition: Transition.cupertino,
                            () => VideoPlayer(
                              filteredFileDetails[index]['DocumentPath'],
                            ),
                          );
                          print("object find");
                        },
                        onTap: () {
                          setState(() {
                            selectedVideoIndex = index;
                          });
                          handleTap(index);
                        },
                        child: Card(
                          color: selectedVideoIndex == index
                              ? ColorPage.colorbutton.withOpacity(0.9)
                              : Color.fromARGB(255, 245, 243, 248),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Image.asset(
                                  "assets/video2.png",
                                  scale: 19,
                                  color: selectedVideoIndex == index
                                      ? ColorPage.white.withOpacity(0.85)
                                      : ColorPage.colorbutton,
                                ),
                                subtitle: getPackagDataFieldValuebyId(
                                            getx.selectedPackageId.toString(),
                                            "isTotal") !=
                                        "0"
                                    ? Text(
                                        'Video duration:  ${breakSecondIntoHourAndMinute(int.parse(filteredFileDetails[index]['VideoDuration'].toString()))}',
                                        style: TextStyle(
                                          color: selectedVideoIndex == index
                                              ? ColorPage.white.withOpacity(0.9)
                                              : ColorPage.grey,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Video duration:  ${breakSecondIntoHourAndMinute(int.parse(filteredFileDetails[index]['VideoDuration'].toString()))}',
                                                style: TextStyle(
                                                  color: selectedVideoIndex ==
                                                          index
                                                      ? ColorPage.white
                                                          .withOpacity(0.9)
                                                      : ColorPage.grey,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Text(
                                                'Total limit:  ${breakSecondIntoHourAndMinute(int.parse(filteredFileDetails[index]['AllowDuration'].toString()))}',
                                                style: TextStyle(
                                                  color: selectedVideoIndex ==
                                                          index
                                                      ? ColorPage.white
                                                          .withOpacity(0.9)
                                                      : ColorPage.grey,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Consume:  ${breakSecondIntoHourAndMinute(getTotalConsumeDurationOfVideo(filteredFileDetails[index]['FileId'].toString(), int.parse(filteredFileDetails[index]['ConsumeDuration'].toString())))}',
                                                style: TextStyle(
                                                  color: selectedVideoIndex ==
                                                          index
                                                      ? ColorPage.white
                                                          .withOpacity(0.9)
                                                      : ColorPage.grey,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Text(
                                                'Remaining limit:  ${breakSecondIntoHourAndMinute(int.parse(filteredFileDetails[index]['AllowDuration'].toString()) - getTotalConsumeDurationOfVideo(filteredFileDetails[index]['FileId'].toString(), int.parse(filteredFileDetails[index]['ConsumeDuration'].toString())))}',
                                                style: TextStyle(
                                                  color: selectedVideoIndex ==
                                                          index
                                                      ? ColorPage.white
                                                          .withOpacity(0.9)
                                                      : ColorPage.grey,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                title: Text(
                                  overflow: TextOverflow.ellipsis,
                                  filteredFileDetails[index]['DisplayName'] ??
                                      "Video Name",
                                  style: GoogleFonts.inter().copyWith(
                                    color: selectedVideoIndex == index
                                        ? ColorPage.white
                                        : ColorPage.colorblack,
                                    fontWeight: FontWeight.w800,
                                    fontSize: selectedvideoListIndex == index
                                        ? 20
                                        : null,
                                  ),
                                ),
                                trailing: SizedBox(
                                  child: IconButton(
                                    onPressed: () {
                                      getx.isVideoPlayer.value = true;
                                      // Get.to(
                                      //   transition: Transition.cupertino,
                                      //   () => VideoPlayer(
                                      //     filteredFileDetails[index]['FileIdName'],
                                      //   ),
                                      // );
                                    },
                                    icon: Icon(
                                      Icons.play_circle,
                                      color: selectedVideoIndex == index
                                          ? ColorPage.white
                                          : ColorPage.colorbutton,
                                    ),
                                  ),
                                ),
                              ),
                              // Linear progress bar
                              if (true)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.green),
                                    backgroundColor:
                                        Colors.green.withOpacity(0.3),
                                    value: calculateVideoWatchProgress(
                                        getTotalConsumeDurationOfVideo(
                                            filteredFileDetails[index]['FileId']
                                                .toString(),
                                            int.parse(filteredFileDetails[index]
                                                    ['ConsumeDuration']
                                                .toString())),
                                        int.parse(filteredFileDetails[index]
                                                ['VideoDuration']
                                            .toString())), // Progress value
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text('No data found'),
                  )),
      ),
    );
  }

  void handleTap(int index) {
    DateTime now = DateTime.now();
    if (index == lastTapIndex &&
        now.difference(lastTapTime) < Duration(seconds: 1)) {
      print('Double tapped on folder: $index');
    }
    lastTapIndex = index;
    lastTapTime = now;
  }
}

class NavigationClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class NavigationClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class LiveDashboardUI extends StatefulWidget {
  @override
  _LiveDashboardUIState createState() => _LiveDashboardUIState();
}

class _LiveDashboardUIState extends State<LiveDashboardUI>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String pageTitle = "Today's Classes ";

  TextEditingController _searchController = TextEditingController();
  final MeetingController meetingController = Get.put(MeetingController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getMeetingList(context);
    });

    _tabController = TabController(length: 1, vsync: this);

    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            pageTitle = "Today's Classes";
            break;
        }
      });
    });

    // Listen to the search input and filter meetings accordingly
    _searchController.addListener(() {
      meetingController.filterMeetings(_searchController.text);
    });

    // Load initial meetings into the controller (replace this with your actual data loading)
    meetingController.loadMeetings(getx.todaymeeting);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: getx.isCollapsed.value
            ? IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  getx.isCollapsed.value = false;
                })
            : SizedBox(),
        elevation: 0,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          "Live Dashboard",
          style: FontFamily.styleb,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: 300,
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                    ),
                    suffixIconColor: Color.fromARGB(255, 103, 103, 103),
                    hintText: 'Search',
                    hintStyle:
                        FontFamily.font9.copyWith(color: ColorPage.brownshade),
                    fillColor: Color.fromARGB(255, 237, 237, 238),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(40))),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeaderRow(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMeetingList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            pageTitle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color.fromARGB(255, 3, 6, 223),
        isScrollable: true, // Makes the TabBar scrollable if needed
        tabs: [
          Tab(text: 'Today Meetings'),
        ],
      ),
    );
  }

  Widget _buildMeetingList() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (meetingController.filteredMeetings.isEmpty) {
            return Center(child: Text('No meetings found'));
          }
          return _buildWrapView();
        }),
      ),
    );
  }

  Widget _buildWrapView() {
    List mettinglist = [];
    for (var item in meetingController.filteredMeetings) {
      if (item.packageId
          .split(',')
          .contains(getx.selectedPackageId.value.toString())) {
        mettinglist.add(item);
      }
    }

    return Wrap(
      spacing: 10, // Horizontal space between items
      runSpacing: 10, // Vertical space between rows
      children: List.generate(mettinglist.length, (index) {
        MeetingDeatils meeting = mettinglist[index];
        return _buildCard(index, meeting);
      }),
    );
  }

  Widget _buildCard(int index, MeetingDeatils meeting) {
    return Container(
      width:
          MediaQuery.of(context).size.width * 0.20, // Use 20% of screen width
      height:
          MediaQuery.of(context).size.height * 0.25, // Use 25% of screen height
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          image: AssetImage('assets/live_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: InkWell(
        onTap: () {
          runLiveExe(meeting);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Name
              Row(
                children: [
                  Expanded(
                    child: Text(
                      meeting.videoName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontFamily.styleb.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  meeting.videoCategory == "YouTube"
                      ? Image.asset(
                          "assets/youtube.png",
                          scale: 100,
                        )
                      : SizedBox(),
                ],
              ),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 1.5,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5),

              // Package Info
              Flexible(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: 'Package: ',
                    style: FontFamily.styleb
                        .copyWith(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '${meeting.packageName}',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 5),

              // Topic Info
              Flexible(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: 'TopicName: ',
                    style: FontFamily.styleb
                        .copyWith(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '${meeting.topicName}',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 5),

              // Duration Info
              Flexible(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: 'Duration: ',
                    style: FontFamily.styleb
                        .copyWith(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '${meeting.videoDuration}',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(child: SizedBox()),

              // Join Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    color: ColorPage.blue,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "Join",
                        style: FontFamily.font2,
                      ),
                    ),
                    onPressed: () {
                      print("calling");
                      runLiveExe(meeting);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  runLiveExe(MeetingDeatils meeting) async {
    ExeRun ob = ExeRun();
    print("call inside runexe");
    ob.runingExelive(meeting);
  }
}

class ExeRun {
  static Process? _process;

  String exeFilePath = '';

  Future<void> runingExelive(MeetingDeatils meetingDeatils) async {
    final exePath = "exefiles/live/abc.exe";

    // Extracting user details dynamically
    var user = getx.loginuserdata[0];

    List<String> arguments = [
      meetingDeatils.packageId.toString(),
      "${user.firstName} ${user.lastName}",
      user.nameId.toString(),
      meetingDeatils.sessionId.toString(),
      meetingDeatils.topicName.toString(),
      meetingDeatils.liveUrl.toString(),
      meetingDeatils.videoCategory.toString(),
      getx.dbPath.value, // Database path
      meetingDeatils.videoId.toString(),
      user.phoneNumber.toString(),
      user.token,
      origin,
      "https://${ClsUrlApi.mainurl}${ClsUrlApi.insertvideoTimeDetails}",
      meetingDeatils.groupChat ?? "",
      meetingDeatils.personalChat ?? "",
      meetingDeatils.poolURL ?? "",
      meetingDeatils.topicURL ?? "",
    ];

    try {
      print("Running EXE: $exePath with arguments: $arguments");

      ProcessResult result = await Process.run(exePath, arguments);

      print("Exit Code: ${result.exitCode}");
      print("Output: ${result.stdout}");
      print("Error: ${result.stderr}");
    } catch (e) {
      print("Error running executable: $e");
    }
  }

  static Future<bool> isProcessRunning(String processName) async {
    final result = await Process.run('tasklist', []);
    return result.stdout.toString().contains(processName);
  }
}

class DefaultDashBoardRight extends StatefulWidget {
  DefaultDashBoardRight({
    super.key,
  });

  @override
  State<DefaultDashBoardRight> createState() => _DefaultDashBoardRightState();
}

class _DefaultDashBoardRightState extends State<DefaultDashBoardRight> {
  TextStyle style = TextStyle(fontFamily: 'AltoneRegular', fontSize: 20);
  TextStyle styleb = TextStyle(fontFamily: 'AltoneBold', fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Flexible(
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          automaticallyImplyLeading: true,
                          leading: getx.isCollapsed.value
                              ? IconButton(
                                  icon: Icon(Icons.list),
                                  onPressed: () {
                                    getx.isCollapsed.value =
                                        !getx.isCollapsed.value;
                                  },
                                )
                              : SizedBox(),

                          // title: Container(
                          //   width: 400,
                          //   child: TextFormField(
                          //     decoration: InputDecoration(
                          //       hintText: 'Search',
                          //       hintStyle: TextStyle(color: ColorPage.grey),
                          //       fillColor: ColorPage.white,
                          //       filled: true,
                          //       border: OutlineInputBorder(
                          //         borderSide: BorderSide.none,
                          //         borderRadius: BorderRadius.circular(40),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          actions: [
                            //                           InkWell(
                            //                             onTap: () {
                            //                               showFullImageDialog();
                            //                             },
                            //                             child: Container(
                            //                               padding: EdgeInsets.only(right: 20),
                            //                               decoration: BoxDecoration(
                            //                                 shape: BoxShape.circle,
                            //                                 color: Colors.white.withOpacity(0.1),
                            //                               ),
                            //                               child: Stack(
                            //                                   alignment: Alignment.center,
                            //                                   children: [
                            //                                     ClipOval(

                            //                                         child: Container(
                            //                                       color: Color.fromARGB(255, 1, 119, 255),
                            //                                       height: 45,
                            //                                       width: 45,
                            //                                       child: SizedBox(),
                            //                                     )),
                            //                                     Padding(
                            //                                       padding: const EdgeInsets.all(8.0),
                            //                                       child: ClipOval(

                            //                                         child: Image.network(
                            //                                          "https://via.placeholder.com/215x215.png?text=${getx.loginuserdata[0].firstName} ${getx.loginuserdata[0].lastName}+Image",
                            //                                           fit: BoxFit.cover,
                            //                                           // width: 50,
                            //                                         ),
                            //                                       ),
                            //                                     ),
                            //                                   ]),
                            //                             ),
                            //                           ),
                            //                           Column(
                            //                             crossAxisAlignment: CrossAxisAlignment.start,
                            //                             children: [
                            //                               InkWell(
                            //                                 onTap: () {
                            //                                   Get.to(() => ProfilePage());
                            // // _showCustomLogoutDialog(context,'Privacy info','this is description','linkText',(){},(){});

                            //                                 },
                            //                                 child: Text(
                            //                                   getx.loginuserdata[0].firstName +
                            //                                       " " +
                            //                                       getx.loginuserdata[0].lastName,
                            //                                   style: styleb.copyWith(),
                            //                                 ),
                            //                               ),
                            //                               InkWell(
                            //                                 onTap: () {
                            //                                   Get.to(() => ProfilePage());
                            //                                 },
                            //                                 child: Text(getx.loginuserdata[0].email,
                            //                                     style: style.copyWith(
                            //                                         fontSize: 16,
                            //                                         color: Colors.grey[600])),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                           Padding(
                            //                             padding: const EdgeInsets.only(
                            //                                 bottom: 50, left: 10, right: 10),
                            //                             child: Icon(
                            //                               Icons.notifications_rounded,
                            //                               color: Colors.black,
                            //                               weight: 5,
                            //                             ),
                            //                           )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                HeadingBox(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //   flex: 4,
                //       child: HeadingBox()),
                //     TipsAndTricks(),

                //   ],
                // ),

                Row(
                  children: [
                    Expanded(
                        child: CalendarWidget(
                            packageId:
                                getx.selectedPackageId.value.toString())),
                    // Expanded(child: NewsNotifications())
                  ],
                ),
              ],
            ),
          ),
          // GlobalDialog(getx.token.value)
        ],
      ),
    );
  }

  Widget learningGoalButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 50, top: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: MaterialButton(
          hoverColor: Color.fromARGB(255, 237, 235, 246),
          onPressed: () {},
          color: ColorPage.white,
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
            child: Text(
              "Learning Goal",
              style: FontFamily.font2.copyWith(
                  color: ColorPage.colorbutton, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void showFullImageDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    iconTheme: IconThemeData(color: ColorPage.white),
                    elevation: 0,
                  ),
                ),
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 80),
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      "https://via.placeholder.com/215x215.png?text=${getx.loginuserdata[0].firstName} ${getx.loginuserdata[0].lastName}+Image",
                      fit: BoxFit.cover,
                    ),
                    // child: Image.network(
                    //   MyUrl.fullurl + MyUrl.imageurl + user.Image,
                    //   fit: BoxFit.cover,
                    // ),
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

class MeetingController extends GetxController {
  var meetings = <MeetingDeatils>[].obs; // All meetings
  var filteredMeetings =
      <MeetingDeatils>[].obs; // Filtered meetings for the search

  // Method to filter meetings based on search query
  void filterMeetings(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      filteredMeetings.value = meetings; // Show all if query is empty
    } else {
      filteredMeetings.value = meetings.where((meeting) {
        return meeting.videoName.toLowerCase().contains(query) ||
            meeting.packageName.toLowerCase().contains(query);
      }).toList();
    }
  }

  // Load meetings (you can replace this with your API call or data source)
  void loadMeetings(List<MeetingDeatils> meetingList) {
    meetings.value = meetingList;
    filteredMeetings.value = meetingList; // Initially show all meetings
  }
}

class McqDashboard extends StatefulWidget {
  const McqDashboard({super.key});

  @override
  State<McqDashboard> createState() => _McqDashboardState();
}

class _McqDashboardState extends State<McqDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TextEditingController _searchController = TextEditingController();
  Getx getx = Get.put(Getx());
  // String pageTitle = 'Quick Test';
  RxList mcqSetList = [].obs;
  RxList mcqPaperList = [].obs;
  late BuildContext globalContext;

  @override
  void initState() {
    getMCQSetList();
    super.initState();
  }

  RxList uniqueServicesList = [].obs;
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
    Set<String> uniqueServices =
        mcqSetList.map((item) => item['ServicesTypeName'] as String).toSet();

// Convert Set to List if needed
    uniqueServicesList.value = uniqueServices.toList();

// Print the unique services
    print(uniqueServicesList);
    _tabController =
        TabController(length: uniqueServicesList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Obx(
      () => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: getx.isCollapsed.value
                ? IconButton(
                    icon: Icon(Icons.list),
                    onPressed: () {
                      getx.isCollapsed.value = false;
                    })
                : SizedBox(),
            elevation: 0,
            shadowColor: Colors.grey,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: Text("MCQ Series", style: FontFamily.styleb),
          ),
          body: getx.mcqdataList.value && uniqueServicesList.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: const Color.fromARGB(255, 0, 0, 0),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Color.fromARGB(255, 3, 6, 223),
                        isScrollable: true,
                        tabs: [
                          for (int i = 0; i < uniqueServicesList.length; i++)
                            Tab(
                              text: uniqueServicesList[i],
                            ),
                          // Tab(text: 'Comprehensive'),
                          // Tab(text: 'Ranked Competition'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          for (int i = 0; i < uniqueServicesList.length; i++)
                            _buildTabContent(uniqueServicesList[i],
                                istype: 'Ranked Competition' ==
                                        uniqueServicesList[i]
                                    ? true
                                    : false),
                          // _buildTabContent('Comprehensive'),
                          // _buildTabContent('Ranked Competition', istype: true),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text("No Data Found"),
                )),
    );
  }

  Widget _buildTabContent(String tabTitle, {bool istype = false}) {
    return Obx(
      () => mcqSetList.isNotEmpty
          ? Navigator(
              onGenerateRoute: (RouteSettings settings) {
                // Check which route is being requested within this tab
                if (settings.name == '/$tabTitle') {
                  // If the mcqSetList is not empty, show the McqList, else show "No Set Found"
                  return MaterialPageRoute(
                    builder: (_) {
                      // Check for the list data to display
                      // if (mcqSetList.isNotEmpty) {
                      return McqList(
                          mcqSetList, tabTitle, 'assets/quick.png', istype);
                      // } else {
                      // return ; // Show "No Set Found" if the list is empty
                      // }
                    },
                  );
                }
                return null;

                // Default route to show if the tab is first loaded or navigated to
              },
              initialRoute:
                  '/$tabTitle', // This ensures that the default route is set when first shown
            )
          : _noSetFound(),
    );
  }

// Helper widget to display "No Set Found" message
  Widget _noSetFound() {
    return Center(
      child: Text("No Set Found"),
    );
  }
}

class TheoryExamPaperList extends StatefulWidget {
  @override
  State<TheoryExamPaperList> createState() => _TheoryExamPaperListState();
}

class _TheoryExamPaperListState extends State<TheoryExamPaperList>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> testWrittenExamList = getx.testWrittenExamList
      .where(
          (row) => row['PackageId'] == getx.selectedPackageId.value.toString())
      .toList();
  RxList theorySetList = [].obs;
  RxList theoryPaperList = [].obs;
  late TabController _tabController;

  RxList uniqueServicesList = [].obs;

  // Fetch theory set list and unique services
  Future getTheorySetList() async {
    theorySetList.value =
        await fetchTheorySetList(getx.selectedPackageId.value.toString());
    Set<String> uniqueServices =
        theorySetList.map((item) => item['ServicesTypeName'] as String).toSet();
    uniqueServicesList.value = uniqueServices.toList();

    // Initialize the TabController with the number of unique services
    setState(() {
      _tabController =
          TabController(length: uniqueServicesList.length, vsync: this);
    });
  }

  @override
  void initState() {
    super.initState();
    getTheorySetList(); // Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: getx.isCollapsed.value
                ? IconButton(
                    icon: Icon(Icons.list),
                    onPressed: () {
                      getx.isCollapsed.value = false;
                    })
                : SizedBox(),
            elevation: 0,
            shadowColor: Colors.grey,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: Text(
              "Test Series",
              style: FontFamily.styleb,
            ),
          ),
          body: getx.mcqdataList.value && uniqueServicesList.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: const Color.fromARGB(255, 0, 0, 0),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Color.fromARGB(255, 3, 6, 223),
                        isScrollable: true,
                        tabs: [
                          for (int i = 0; i < uniqueServicesList.length; i++)
                            Tab(
                              text: uniqueServicesList[i],
                            ),
                          // Tab(text: 'Comprehensive'),
                          // Tab(text: 'Ranked Competition'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          for (int i = 0; i < uniqueServicesList.length; i++)
                            _buildTabContent(
                              uniqueServicesList[i],
                            ),
                          // _buildTabContent('Comprehensive'),
                          // _buildTabContent('Ranked Competition', istype: true),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text("No Data Found"),
                )),
    );
  }

  Widget _buildTabContent(
    String tabTitle,
  ) {
    return Obx(
      () => theorySetList.isNotEmpty
          ? Navigator(
              onGenerateRoute: (RouteSettings settings) {
                // Check which route is being requested within this tab
                if (settings.name == '/$tabTitle') {
                  // If the mcqSetList is not empty, show the McqList, else show "No Set Found"
                  return MaterialPageRoute(
                    builder: (_) {
                      // Check for the list data to display
                      // if (mcqSetList.isNotEmpty) {
                      return TheoryPaperList(
                          theorySetList, tabTitle, 'assets/mcq_img.png', true);
                      // } else {
                      // return ; // Show "No Set Found" if the list is empty
                      // }
                    },
                  );
                }
                return null;

                // Default route to show if the tab is first loaded or navigated to
              },
              initialRoute:
                  '/$tabTitle', // This ensures that the default route is set when first shown
            )
          : _noSetFound(),
    );
  }

// Helper widget to display "No Set Found" message
  Widget _noSetFound() {
    return Center(
      child: Text("No Set Found"),
    );
  }
}

// _onNoInternetConnection(context) {
//   Alert(
//     context: context,
//     type: AlertType.error,
//     style: AlertStyle(
//       titleStyle: TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
//       descStyle: FontFamily.font6,
//       isCloseButton: false,
//     ),
//     title: "!! No internet found !!",
//     desc: "Make sure you have a proper internet Connection.  ",
//     buttons: [
//       DialogButton(
//         child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
//         highlightColor: Color.fromRGBO(3, 77, 59, 1),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         color: Color.fromRGBO(9, 89, 158, 1),
//       ),
//     ],
//   ).show();
// }

_onNoInternetConnection(context) {
  Alert(
    context: context,
    type: AlertType.error,
    style: AlertStyle(
      titleStyle: TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
      descStyle: FontFamily.font6,
      isCloseButton: false,
    ),
    title: "!! No internet!!",
    desc: "Make sure you have a proper internet Connection.  ",
    buttons: [
      DialogButton(
        child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
        highlightColor: Color.fromRGBO(3, 77, 59, 1),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Color.fromRGBO(9, 89, 158, 1),
      ),
    ],
  ).show();
}

onExitPage(context, VoidCallback ontap, VoidCallback onCanceltap) async {
  ArtDialogResponse response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
          denyButtonText: "Cancel",
          title: "Are you sure?",
          text: "you want to exit this page!",
          confirmButtonText: "Ok",
          onConfirm: ontap,
          type: ArtSweetAlertType.warning));

  // if (response.isTapConfirmButton) {
  //   Get.back();
  //   log(response.isTapConfirmButton.toString());
  //   return ontap;
  // }

  // Alert(
  //   context: context,
  //   type: AlertType.info,
  //   style: AlertStyle(
  //     titleStyle: TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
  //     descStyle: FontFamily.font6,
  //     isCloseButton: false,
  //   ),
  //   title: "Are you sure ?\n you want to exit this page",
  //   buttons: [
  //     DialogButton(
  //       child:
  //           Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18)),
  //       highlightColor: Color.fromRGBO(3, 77, 59, 1),
  // onPressed: onCanceltap,
  //       color: Colors.red,
  //     ),
  //     DialogButton(
  //       child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
  //       highlightColor: Color.fromRGBO(3, 77, 59, 1),
  // onPressed: ontap,
  //       color: Color.fromRGBO(9, 89, 158, 1),
  //     ),
  //   ],
  // ).show();
}

String breakSecondIntoHourAndMinute(int seconds) {
  int minutes = seconds ~/ 60;
  int hours = minutes ~/ 60;

  if (minutes < 1) {
    return "$seconds s";
  }

  return hours > 0 ? "$hours h ${minutes % 60} m " : "$minutes m";
}

double calculateVideoWatchProgress(int consume, int videoduration) {
  double consumeDuration = consume.toDouble();
  double videoDuration = videoduration.toDouble();

  double watchPercentage = (consumeDuration / videoDuration) * 100;
  if (watchPercentage > 100) {
    return 1.0;
  } else {
    return watchPercentage / 100;
  }
}

// int getTotalConsumeDurationOfVideo(int consumeduration, int localConsumeduration){
//   return consumeduration+localConsumeduration;

// }

Future<void> pickVideoFile() async {
  // Pick a file with the video type filter
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'avi', 'mkv', 'mov', 'dthf']);

  // Check if the user picked a file
  if (result != null) {
    String? filePath = result.files.single.path;
    if (filePath != null) {
      // Print the file path
      print("Selected Video Path: $filePath");
    }
  } else {
    // If no file was selected
    print("No file selected");
  }
}
