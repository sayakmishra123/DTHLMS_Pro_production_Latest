import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/mobile_pdf_viewer.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/podcastPlayerMobile.dart';
// import 'package:dthlms/MOBILE/HOMEPAGE/homepage_mobile.dart';
import 'package:dthlms/MOBILE/VIDEO/mobilevideoplay.dart';
import 'package:dthlms/PC/STUDYMATERIAL/pdfViewer.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<int, CancelToken> cancelTokens =
    {}; // Map to hold CancelTokens for each download
RxList<double> downloadProgress = List.filled(1000, 0.0).obs;

class MobilePodCastDashBoard extends StatefulWidget {
  const MobilePodCastDashBoard({super.key});

  @override
  State<MobilePodCastDashBoard> createState() => _MobilePodCastDashBoardState();
}

class _MobilePodCastDashBoardState extends State<MobilePodCastDashBoard> {
  late ScrollController _scrollController;
  bool _showLeftButton = false;
  bool _showRightButton = true;
  List<dynamic> filteredChapterDetails = [];

  @override
  void initState() {
    filteredChapterDetails = [
      ...getx.alwaysShowChapterDetailsOfVideo,
    ];
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    getListStructure().whenComplete(() {
      setState(() {});
    });
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

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  void cancelAllDownloads() {
    cancelTokens.forEach((index, cancelToken) {
      cancelToken.cancel();
      print('Download for index $index cancelled.');
    });

    // Clear the cancelTokens map after canceling
    cancelTokens.clear();
    downloadProgress.value = List.filled(1000, 0.0);
  }

  void _scrollListener() {
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showLeftButton = false;
      });
    } else {
      setState(() {
        _showLeftButton = true;
      });
    }
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showRightButton = false;
      });
    } else {
      setState(() {
        _showRightButton = true;
      });
    }
  }

  Getx getx = Get.put(Getx());

  // Future getListStructure() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   getx.isFolderview.value = prefs.getBool("folderview") ?? false;
  // }
  Future getListStructure() async {
    print('object541541541541');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    getx.isFolderview.value = prefs.getBool("folderview") ?? false;
    int startParentId = 0;
    if (getx.selectedPackageId.value > 0) {
      startParentId = await getStartParentId(getx.selectedPackageId.value);
    } else {
      print("abhoy is null");
    }

    //  getMainChapter(getx.selectedPackageId.value);

    // print(getx.subjectDetails[0]['SubjectName'] + "sayak");

    await getChapterContents(startParentId);
    getChapterFiles(
        parentId: startParentId,
        "Podcast",
        getx.selectedPackageId.value.toString());

    // getx.isFolderviewVideo.value = prefs.getBool("folderviewVideo")!;
  }

  void scrollGridView(bool isLeft) {
    double scrollAmount = 300.0;

    double newOffset = isLeft
        ? _scrollController.offset - scrollAmount
        : _scrollController.offset + scrollAmount;

    if (newOffset < _scrollController.position.minScrollExtent) {
      newOffset = _scrollController.position.minScrollExtent;
    } else if (newOffset > _scrollController.position.maxScrollExtent) {
      newOffset = _scrollController.position.maxScrollExtent;
    }

    _scrollController.animateTo(
      newOffset,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: ColorPage.white),
          backgroundColor: ColorPage.mainBlue,
          title: Obx(
            () => Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                  getx.subjectDetails.isNotEmpty
                      ? getx.subjectDetails[0]["SubjectName"]
                      : "Subject Name",
                  style: FontFamily.style.copyWith(color: Colors.white)),
            ),
          ),
        ),
        body: Obx(
          () => Column(
            children: [
              // new added
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => SingleChildScrollView(
                        scrollDirection:
                            Axis.horizontal, // Enables horizontal scrolling
                        child: Row(
                          children: [
                            for (var i = 0; i < getx.navigationList.length; i++)
                              getx.navigationList.isEmpty
                                  ? Text("Blank")
                                  : InkWell(
                                      onTap: () {
                                        // resetTblLocalNavigationByOrder(i);
                                        // insertTblLocalNavigation(navigationtype, navigationId, navigationName)
                                        if (i == 0) {
                                          //nothing
                                        }

                                        if (i == 1) {
                                          print('press in video');

                                          resetTblLocalNavigationByOrder(2);

                                          getStartParentId(int.parse(
                                                  getx.navigationList[1]
                                                      ['NavigationId']))
                                              .then((value) {
                                            print(value);
                                            getChapterContents(
                                                int.parse(value.toString()));
                                            getChapterFiles(
                                                parentId:
                                                    int.parse(value.toString()),
                                                'Podcast',
                                                getx.selectedPackageId.value
                                                    .toString());
                                          });
                                          getLocalNavigationDetails();
                                        }
                                        if (i == 2) {
                                          print('press in video');

                                          resetTblLocalNavigationByOrder(2);

                                          getStartParentId(int.parse(
                                                  getx.navigationList[1]
                                                      ['NavigationId']))
                                              .then((value) {
                                            print(value);
                                            getChapterContents(
                                                int.parse(value.toString()));
                                            getChapterFiles(
                                                parentId:
                                                    int.parse(value.toString()),
                                                'Podcast',
                                                getx.selectedPackageId.value
                                                    .toString());
                                          });
                                          getLocalNavigationDetails();
                                        }
                                        if (i > 2) {
                                          resetTblLocalNavigationByOrder(i);

                                          insertTblLocalNavigation(
                                            "ParentId",
                                            getx.navigationList[i]
                                                ['NavigationId'],
                                            getx.navigationList[i]
                                                ["NavigationName"],
                                          );

                                          getChapterContents(int.parse(
                                              getx.navigationList[i]
                                                  ['NavigationId']));
                                          getChapterFiles(
                                              parentId: int.parse(
                                                  getx.navigationList[i]
                                                      ['NavigationId']),
                                              'Podcast',
                                              getx.selectedPackageId.value
                                                  .toString());
                                          getLocalNavigationDetails();
                                        }

                                        print(getx
                                            .alwaysShowChapterDetailsOfVideo
                                            .length);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(children: [
                                          if (i != 0) ...[
                                            ClipPath(
                                              clipper: NavigationClipper1(),
                                              child: Container(
                                                height: 30,
                                                width: 20,
                                                color: i ==
                                                        getx.navigationList
                                                                .length -
                                                            1
                                                    ? Colors.blue
                                                    : Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 50),
                                              ),
                                            ),
                                            ClipPath(
                                              child: Container(
                                                width: (() {
                                                  int nameLength = getx
                                                      .navigationList[i]
                                                          ["NavigationName"]
                                                      .length;

                                                  if (nameLength >= 16) {
                                                    return 210.0;
                                                  } else if (nameLength >= 13) {
                                                    return 190.0;
                                                  } else if (nameLength >= 10) {
                                                    return 170.0;
                                                  } else if (nameLength >= 7) {
                                                    return 150.0;
                                                  } else {
                                                    return 100.0;
                                                  }
                                                })(),

                                                decoration: BoxDecoration(
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
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        getx.navigationList[i]
                                                            ["NavigationName"],
                                                        style: FontFamily.styleb.copyWith(
                                                            fontSize: 14,
                                                            color: i ==
                                                                    getx.navigationList
                                                                            .length -
                                                                        1
                                                                ? Colors.white
                                                                : Colors
                                                                    .black54)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ClipPath(
                                              clipper: NavigationClipper(),
                                              child: Container(
                                                height: 30,
                                                width: 20,
                                                color: i ==
                                                        getx.navigationList
                                                                .length -
                                                            1
                                                    ? Colors.blue
                                                    : Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 50),
                                              ),
                                            ),
                                          ],
                                        ]),
                                      ),
                                    ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Contents",
                      style: FontFamily.font,
                    ),
                    Row(
                      children: [
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
                              )),
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
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 9,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
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
                            child: getx.isFolderview.value
                                ? Container(
                                    padding: EdgeInsets.all(10),
                                    child: Obx(() {
                                      if (getx.alwaysShowChapterDetailsOfVideo
                                          .isEmpty) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.folder_open_outlined,
                                                size: 30,
                                                color: Colors.grey[600],
                                              ),
                                              Text(
                                                'Empty',
                                                style: FontFamily.style
                                                    .copyWith(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      return GridView.builder(
                                        itemCount: getx
                                            .alwaysShowChapterDetailsOfVideo
                                            .length,
                                        scrollDirection: Axis.vertical,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              getx.isCollapsed.value ? 5 : 4,
                                          childAspectRatio: 1.0,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                        ),
                                        itemBuilder: (context, index) {
                                          return buildGridViewItem(
                                            index,
                                          );
                                        },
                                      );
                                    }),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(10),
                                    child: Obx(() {
                                      if (getx.alwaysShowChapterDetailsOfVideo
                                          .isEmpty) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.folder_open_outlined,
                                                size: 30,
                                                color: Colors.grey[600],
                                              ),
                                              Text(
                                                'Empty',
                                                style: FontFamily.style
                                                    .copyWith(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      return ListView.builder(
                                        itemCount: getx
                                            .alwaysShowChapterDetailsOfVideo
                                            .length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return buildListViewItem(index);
                                          //updated
                                        },
                                      );
                                    }),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      "Podcasts",
                      style: FontFamily.font,
                    ),
                  ],
                ),
              ),

              // new
              // bottom videos part

              Expanded(
                flex: 11,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(top: 7, right: 10, left: 10),
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
                          child: PodCastListLeft(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Expanded(
              //   flex: 11,
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
              //     child: Container(
              //       decoration: BoxDecoration(
              //         boxShadow: [
              //           BoxShadow(
              //             blurRadius: 3,
              //             color: Color.fromARGB(255, 192, 191, 191),
              //             offset: Offset(0, 0),
              //           ),
              //         ],
              //         color: Colors.white,
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(10),
              //         ),
              //       ),
              //       child: Container(
              //         padding: EdgeInsets.all(10),
              //         child: ListView.builder(
              //             itemCount: 10,
              //             itemBuilder: (context, index) {
              //               return Container(
              //                   margin: EdgeInsets.all(5),
              //                   decoration: BoxDecoration(
              //                     boxShadow: [
              //                       BoxShadow(
              //                         blurRadius: 3,
              //                         color:
              //                             Color.fromARGB(255, 192, 191, 191),
              //                         offset: Offset(0, 0),
              //                       ),
              //                     ],
              //                     borderRadius: BorderRadius.all(
              //                       Radius.circular(10),
              //                     ),
              //                     color: Color.fromARGB(255, 255, 255, 255),
              //                   ),
              //                   child: MaterialButton(
              //                     onPressed: () {
              //                       Get.to(()=>MobileVideoPlayer());
              //                     },
              //                     child: ListTile(
              //                       subtitle: Text(
              //                         "This in New Video",
              //                         overflow: TextOverflow.ellipsis,
              //                       ),
              //                       leading: Image.asset(
              //                         "assets/video2.png",
              //                         color: ColorPage.colorbutton,
              //                         width: 25,
              //                       ),
              //                       title: Text("Videos no - ${index + 1}",
              //                           style: FontFamily.font4.copyWith(
              //                               fontWeight: FontWeight.bold)),
              //                       trailing: Text("25:30 min"),
              //                     ),
              //                   ));
              //             }),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListViewItem(
    int index,
  ) {
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
          cancelAllDownloads();

          insertTblLocalNavigation(
                  "ParentId",
                  getx.alwaysShowChapterDetailsOfVideo[index]
                      ['SectionChapterId'],
                  getx.alwaysShowChapterDetailsOfVideo[index]
                      ['SectionChapterName'])
              .whenComplete(
            () {
              getLocalNavigationDetails();
            },
          );

          // getx.isVideoDashBoard.value=false;
          getChapterContents(int.parse(
              getx.alwaysShowChapterDetailsOfVideo[index]['SectionChapterId']));
          getChapterFiles(
              parentId: int.parse(getx.alwaysShowChapterDetailsOfVideo[index]
                  ['SectionChapterId']),
              'Podcast',
              getx.selectedPackageId.value.toString());

          selectedIndex = index;

          setState(() {});
        },
        child: ListTile(
          leading: Image.asset(
            "assets/folder8.png",
            width: 30,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_sharp,
            size: 16,
            color:
                selectedIndex == index ? ColorPage.white : ColorPage.colorblack,
          ),
          title: Text(
            getx.alwaysShowChapterDetailsOfVideo[index]['SectionChapterName'],
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

  Widget buildGridViewItem(int index) {
    return InkWell(
      enableFeedback: true,
      overlayColor: WidgetStatePropertyAll(Colors.red),
      onTap: () {
        cancelAllDownloads();

        insertTblLocalNavigation(
                "ParentId",
                getx.alwaysShowChapterDetailsOfVideo[index]['SectionChapterId'],
                getx.alwaysShowChapterDetailsOfVideo[index]
                    ['SectionChapterName'])
            .whenComplete(
          () {
            getLocalNavigationDetails();
          },
        );

        // getx.isVideoDashBoard.value=false;
        getChapterContents(int.parse(
            getx.alwaysShowChapterDetailsOfVideo[index]['SectionChapterId']));
        getChapterFiles(
            parentId: int.parse(getx.alwaysShowChapterDetailsOfVideo[index]
                ['SectionChapterId']),
            'Podcast',
            getx.selectedPackageId.value.toString());

        selectedIndex = index;

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
              Image.asset(
                "assets/folder5.png",
                scale: 16,
              ),
              AutoSizeText(
                getx.alwaysShowChapterDetailsOfVideo[index]
                    ['SectionChapterName'],
                overflow: TextOverflow.ellipsis,
                style: FontFamily.font9.copyWith(color: ColorPage.colorblack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PodCastListLeft extends StatefulWidget {
  PodCastListLeft({
    super.key,
  });

  @override
  State<PodCastListLeft> createState() => _PodCastListLeftState();
}

class _PodCastListLeftState extends State<PodCastListLeft> {
  late final Dio dio;

  int lastTapVideoIndex = -1; // Track the last tapped item index
  DateTime lastTapvideoTime = DateTime.now();
  var color = Color.fromARGB(255, 102, 112, 133);
  Getx getx = Get.put(Getx());

  int flag = 2;
  int selectedVideoIndex = -1;
  int selectedvideoListIndex = -1;

  RxMap<int, double> downloadProgress = <int, double>{}.obs;
  RxSet<int> downloadingIndexes = <int>{}.obs;
  String? playingPodcastPath;
  Player? audioPlayer;

  @override
  void initState() {
    dio = Dio();

    super.initState();
  }

  @override
  void dispose() {
    cancelAllDownloads();
    if (audioPlayer != null) {
      audioPlayer!.dispose();
    }
    super.dispose();
  }

  @override
  void handleTap(int index) {
    DateTime now = DateTime.now();
    if (index == lastTapVideoIndex &&
        now.difference(lastTapvideoTime) < Duration(seconds: 1)) {
      print('Double tapped on folder: $index');
    }
    lastTapVideoIndex = index;
    lastTapvideoTime = now;
  } // Track the selected list tile

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Obx(
          () => ListView.builder(
            itemCount: getx.podcastFileList.length,
            itemBuilder: (context, index) {
              final podcast = getx.podcastFileList[index];
              final isDownloaded = File(
                      getx.userSelectedPathForDownloadFile.isEmpty
                          ? getx.defaultPathForDownloadFile +
                              '/Podcast/${podcast['FileIdName']}'
                          : getx.userSelectedPathForDownloadFile.value +
                              '/Podcast/${podcast['FileIdName']}')
                  .existsSync();

              print(getx.userSelectedPathForDownloadFile.isEmpty
                  ? getx.defaultPathForDownloadFile +
                      '/Podcast/${podcast['FileIdName']}'
                  : getx.userSelectedPathForDownloadFile.value +
                      '/Podcast/${podcast['FileIdName']}');
              print(getx.userSelectedPathForDownloadFile.isEmpty
                  ? getx.defaultPathForDownloadFile +
                      '/Podcast/${podcast['FileIdName']}'
                  : getx.userSelectedPathForDownloadFile.value +
                      '/Podcast/${podcast['FileIdName']}');
              // print(isDownloaded.toString());

              return Card(
                child: ListTile(
                  leading: Icon(Icons.audiotrack),
                  title: Text(podcast['FileIdName']),
                  subtitle: isDownloaded
                      ? Text(
                          'Ready to play',
                          style: TextStyle(color: Colors.green),
                        )
                      : null,
                  trailing: downloadingIndexes.contains(index)
                      ? Obx(
                          () => CircularPercentIndicator(
                            radius: 20.0,
                            lineWidth: 4.0,
                            percent: (downloadProgress[index] ?? 0.0) / 100,
                            center: Text(
                                '${(downloadProgress[index] ?? 0.0).toInt()}%'),
                          ),
                        )
                      : File(getx.userSelectedPathForDownloadFile.isEmpty
                                  ? getx.defaultPathForDownloadFile +
                                      '/Podcast/${podcast['FileIdName']}'
                                  : getx.userSelectedPathForDownloadFile.value +
                                      '/Podcast/${podcast['FileIdName']}')
                              .existsSync()
                          ? IconButton(
                              icon: Icon(Icons.play_arrow),
                              onPressed: () {
                                setState(() {
                                  playingPodcastPath = getx
                                          .userSelectedPathForDownloadFile
                                          .isEmpty
                                      ? getx.defaultPathForDownloadFile +
                                          '/Podcast/${podcast['FileIdName']}'
                                      : getx.userSelectedPathForDownloadFile
                                              .value +
                                          '/Podcast/${podcast['FileIdName']}';

                                  Get.to(() => PodCastPlayerMobile(
                                        musicPaths: makeDownloadPodCastList(),
                                        initialIndex: findCurrentPodcastIndex(
                                            makeDownloadPodCastList(),
                                            playingPodcastPath!),
                                      ));
                                  // _playPodcast(playingPodcastPath!);
                                });
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.download),
                              onPressed: () {
                                if (podcast['DocumentPath'] != "0" &&
                                    getx.isInternet.value) {
                                  _downloadPodcast(
                                    podcast['DocumentPath'],
                                    '${podcast['FileIdName']}',
                                    index,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 2),
                                          content:
                                              Text('Something Went Wrong !!')));
                                }
                              },
                            ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<String> makeDownloadPodCastList() {
    List<String> downloadedPodcastPath = [];

    if (getx.podcastFileList.length != 0) {
      for (var item in getx.podcastFileList) {
        if (File(getx.userSelectedPathForDownloadFile.isEmpty
                ? getx.defaultPathForDownloadFile +
                    '/Podcast/${item['FileIdName']}'
                : getx.userSelectedPathForDownloadFile.value +
                    '/Podcast/${item['FileIdName']}')
            .existsSync()) {
          downloadedPodcastPath.add(getx.userSelectedPathForDownloadFile.isEmpty
              ? getx.defaultPathForDownloadFile +
                  '/Podcast/${item['FileIdName']}'
              : getx.userSelectedPathForDownloadFile.value +
                  '/Podcast/${item['FileIdName']}');
        }
      }
      return downloadedPodcastPath;
    } else {
      return [];
    }
  }

  int findCurrentPodcastIndex(List pathList, String path) {
    if (pathList.length != 0) {
      for (int i = 0; i < pathList.length; i++) {
        if (pathList[i] == path) {
          return i;
        }
      }
    }
    return 0;
  }

  Future<void> _downloadPodcast(String url, String fileName, int index) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    var prefs = await SharedPreferences.getInstance();
    Directory dthLmsDir = Directory('${appDocDir.path}/$origin');

    getx.defaultPathForDownloadFile.value = dthLmsDir.path;
    prefs.setString("DefaultDownloadpathOfFile", dthLmsDir.path);

    String savePath = getx.userSelectedPathForDownloadFile.isEmpty
        ? dthLmsDir.path + '/Podcast/$fileName'
        : getx.userSelectedPathForDownloadFile.value + '/Podcast/$fileName';

    try {
      setState(() {
        downloadingIndexes.add(index);
        downloadProgress[index] = 0.0;
      });

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadProgress[index] = (received / total * 100);
            });
          }
        },
      );
      print(savePath);
      print(savePath + "it is save path");
      print(File(savePath).existsSync());

      getx.podcastFileList[index]['DownloadedPath'] = savePath;
    } catch (e) {
      print('Download error: $e');
    } finally {
      downloadingIndexes.remove(index);
      downloadProgress.remove(index);
    }
  }

  void _playPodcast(String filePath) {
    if (File(filePath).existsSync()) {
      audioPlayer!.open(Media(filePath));
    } else {
      Get.snackbar(
        "Error",
        "The selected podcast file does not exist.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  String? _videoFilePath;

  bool isDownloading = false;
  // double downloadProgress = 0.0;
//  Future<void> _startDownload(int index) async {
//     setState(() {
//       isDownloading = true;
//       selectedVideoIndex = index;
//       downloadProgress = 0.0; // Initialize progress to 0
//     });

//     // Simulate a download delay with progress
//     for (int i = 1; i <= 100; i++) {
//       await Future.delayed(Duration(milliseconds: 30)); // Simulate time delay for each percentage
//       setState(() {
//         downloadProgress = i / 100; // Update progress
//       });
//     }

//     setState(() {
//       isDownloading = false;
//       // selectedVideoIndex = null; // Reset index after download
//       downloadProgress = 0.0; // Reset progress after download
//     });
//   }
  Future<void> startDownload(int index, String Link, String title) async {
    if (Link == "0") {
      print("ZVideo link is $Link");
      return;
    }

    final appDocDir;
    final cancelToken =
        CancelToken(); // Create a new CancelToken for this download
    cancelTokens[index] =
        cancelToken; // Store the token to allow cancellation later

    try {
      var prefs = await SharedPreferences.getInstance();
      final path = await getApplicationDocumentsDirectory();
      appDocDir = path.path;

      getx.defaultPathForDownloadVideo.value =
          appDocDir + '/$origin' + '/Downloaded_videos';
      prefs.setString("DefaultDownloadpathOfVieo",
          appDocDir + '/$origin' + '/Downloaded_videos');
      print(getx.userSelectedPathForDownloadVideo.value +
          " it is user selected path");

      String savePath = getx.userSelectedPathForDownloadVideo.isEmpty
          ? appDocDir + '/$origin' + '/Downloaded_videos' + '/$title'
          : getx.userSelectedPathForDownloadVideo.value + '/$title';

      String tempPath = appDocDir + '/temp' + '/$title';

      await Directory(appDocDir + '/temp').create(recursive: true);

      // Set a timeout duration (e.g., 60 seconds) for the download process
      const downloadTimeout = Duration(seconds: 60);
      int previousProgress = 0;
      DateTime lastProgressUpdate = DateTime.now();

      await dio.download(
        Link,
        tempPath,
        cancelToken: cancelToken, // Pass the CancelToken to the download method
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total * 100);
            setState(() {
              downloadProgress[index] = progress;
            });

            // Track the last time progress was updated
            if (progress != previousProgress) {
              lastProgressUpdate = DateTime.now();
              previousProgress = progress.toInt();
            }
          }
        },
      ).timeout(downloadTimeout, onTimeout: () {
        // If the download took longer than the timeout
        cancelToken.cancel(); // Cancel the download
        return Future.error('Download Timeout');
      });

      // Check if the download progress got stuck (e.g., progress hasn't updated in the last 10 seconds)
      if (DateTime.now().difference(lastProgressUpdate) >
          Duration(seconds: 30)) {
        cancelToken.cancel(); // Cancel the download
        showErrorDialog(context, 'Download Stuck',
            'The download seems to be stuck. Please try again.');
        return;
      }

      // After download is complete, copy the file to the final location
      final tempFile = File(tempPath);
      final finalFile = File(savePath);

      await finalFile.parent.create(recursive: true);
      await tempFile.copy(savePath);
      await tempFile.delete();

      // Success case: Update the progress to 100% and set the video file path
      setState(() {
        downloadProgress[index] = 100.0; // Mark the download as completed
        _videoFilePath = savePath;
        getx.playingVideoId.value =
            getx.alwaysShowChapterfilesOfVideo[index]["FileId"];
      });

      print('$savePath video saved to this location');

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
      writeToFile(e, "startDownload");
      if (e is DioException && CancelToken.isCancel(e)) {
        print("Download canceled for index $index");
      } else {
        print(e.toString() + " error on download");
        setState(() {
          // Reset progress to 0 if there's an error
          downloadProgress[index] = 0;
        });
        // Only show error dialog if there's a failure in the download process
        showErrorDialog(context, 'Download Failed',
            'An error occurred during the download. Please try again.');
      }
    } finally {
      cancelTokens.remove(
          index); // Remove the CancelToken when the download completes or fails
    }
  }

// Method to show an error dialog
  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void cancelAllDownloads() {
    cancelTokens.forEach((index, cancelToken) {
      cancelToken.cancel();
      print('Download for index $index cancelled.');
    });

    // Clear the cancelTokens map after canceling
    cancelTokens.clear();
  }

  void cancelDownload(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cancel Download?'),
            content: Text('Are you sure you want to cancel the download?'),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(width: 2, color: Colors.red)))),
                onPressed: () {
                  // Cancel the download (implement logic here)
                  if (cancelTokens.containsKey(index)) {
                    cancelTokens[index]?.cancel(); // Cancel the download
                    print("Download canceled for index $index");
                  } else {
                    print("No ongoing download for index $index");
                  }
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Download Cancelled')));
                  setState(() {
                    downloadProgress[index] = 0;
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Don't cancel the download, close the dialog
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ],
          );
        });
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
