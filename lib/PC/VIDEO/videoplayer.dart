import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/API/URL/api_url.dart';
import 'package:dthlms/CUSTOMDIALOG/customdialog.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/PC/LOGIN/login.dart';
import 'package:dthlms/PC/VIDEO/ClsVideoPlay.dart';
import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants/constants.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart' as img;
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as p;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

class VideoPlayer extends StatefulWidget {
  final String videoLink;

  const VideoPlayer(this.videoLink, {super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  void dispose() {
    _timer?.cancel();

    // TODO: implement dispose
    super.dispose();
  }

  var color = Color.fromARGB(255, 102, 112, 133);

  late final Dio dio;
  double _progress = 0.0;
  String? _videoFilePath;

  int flag = 2;
  int selectedIndexOfVideoList = 0;
  int? selectedListIndex = -1; // Track the selected list tile
  List<double> downloadProgress = List.filled(1000, 0.0);
  int selectedIndex = -1;
  // Getx getx = Get.put(Getx());

  late final player = Player();
  late final controller = VideoController(player);
  final List<double> speeds = [0.5, 1.0, 1.5, 2.0];
  double selectedSpeed = 1.0;
  late VideoPlayClass videoPlay;
  bool isPlaying = false;
  TextEditingController timeController = TextEditingController();
  Timer? _timer;
  RxBool expanded = false.obs;

  List<Map<String, dynamic>> VideoPlayInfoDetails = [];

  @override
  void initState() {
    videoPlay = VideoPlayClass();
    page = [
      Pdf(),
      Mcq(),
      Tags(videoPlay: videoPlay), // Pass videoPlay instance here
      AskDoubt()
    ];
    videoPlay.updateVideoLink(getx.playLink.value);
    initialFunctionOfRightPlayer();
    // initialFunctionOfRightPlayer();
    dio = Dio();

    super.initState();
  }
  //   getVideoPlayInfo() async {
  //   VideoPlayInfoDetails = await getPlayInfo();
  //   log("${VideoPlayInfoDetails} shubha video played info get shubha");
  // }

  List<Widget> page = [];

  // bool isDownloadPathExitsOnVideoList() {
  //   for (var element in getx.alwaysShowChapterfilesOfVideo) {
  //     if (File(getx.userSelectedPathForDownloadVideo.isEmpty
  //             ? getx.defaultPathForDownloadVideo.value +
  //                 '\\' +
  //                 element['FileIdName']
  //             : getx.userSelectedPathForDownloadVideo.value +
  //                 '\\' +
  //                 element['FileIdName'])
  //         .existsSync()) {
  //       getx.playLink.value = getx.userSelectedPathForDownloadVideo.isEmpty
  //           ? getx.defaultPathForDownloadVideo.value +
  //               '\\' +
  //               element['FileIdName']
  //           : getx.userSelectedPathForDownloadVideo.value +
  //               '\\' +
  //               element['FileIdName'];

  //       return File(getx.userSelectedPathForDownloadVideo.isEmpty
  //               ? getx.defaultPathForDownloadVideo.value +
  //                   '\\' +
  //                   element['FileIdName']
  //               : getx.userSelectedPathForDownloadVideo.value +
  //                   '\\' +
  //                   element['FileIdName'])
  //           .existsSync();
  //     }
  //   }
  //   return false;
  // }

  initialFunctionOfRightPlayer() {
    videoPlay.player.stream.playing.listen((bool playing) {
      if (mounted) {
        setState(() {
          isPlaying = playing;

          if (playing) {
            // log('playing');
            videoPlay.startTrackingPlayTime();

            // Cancel any existing timer to avoid multiple timers running
            _timer?.cancel();

            // Start a new timer that triggers every 5 seconds
            _timer = Timer.periodic(Duration(seconds: 5), (timer) {
              // log(videoPlay.totalPlayTime.inSeconds.toString());

              // insertVideoplayInfo(
              //   int.parse(getx.playingVideoId.value),
              //   videoPlay.player.state.position.toString(),
              //   videoPlay.totalPlayTime.inSeconds.toString(),
              //   videoPlay.player.state.rate.toString(),
              //   videoPlay.startclocktime.toString(),
              // );
              updateVideoConsumeDuration(
                getx.playingVideoId.value,
                getx.selectedPackageId.value.toString(),
                videoPlay.totalPlayTime.inSeconds.toString(),
              );

              readTblvideoPlayInfo();
            });
          } else {
            // Stop tracking and cancel the timer when video stops playing
            videoPlay.stopTrackingPlayTime();
            // videoInfo(
            //     context,
            //     videoPlay.player.state.position.toString(),
            //     getx.playingVideoId.value,
            //     videoPlay.totalPlayTime.inSeconds.toString(),
            //     videoPlay.player.state.rate.toString(),
            //     videoPlay.startclocktime.toString(),
            //     getx.loginuserdata[0].token);

            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (getx.navigationList.length - 3 == 1) {
                  print('press in video');
                  resetTblLocalNavigationByOrder(2);

                  getStartParentId(
                          int.parse(getx.navigationList[1]['NavigationId']))
                      .then((value) {
                    print(value);
                    getChapterContents(int.parse(value.toString()));
                    getChapterFiles(
                        parentId: int.parse(value.toString()),
                        'Video',
                        getx.selectedPackageId.value.toString());
                    getChapterFiles(
                        parentId: int.parse(value.toString()),
                        'PDF',
                        getx.selectedPackageId.value.toString());
                  });
                  getLocalNavigationDetails();
                }
                if (getx.navigationList.length - 3 == 2) {
                  print('press in video');
                  resetTblLocalNavigationByOrder(3);

                  getStartParentId(
                          int.parse(getx.navigationList[1]['NavigationId']))
                      .then((value) {
                    print(value);
                    getChapterContents(int.parse(value.toString()));
                    getChapterFiles(
                        parentId: int.parse(value.toString()),
                        'Video',
                        getx.selectedPackageId.value.toString());
                    getChapterFiles(
                        parentId: int.parse(value.toString()),
                        'PDF',
                        getx.selectedPackageId.value.toString());
                  });
                  getLocalNavigationDetails();
                }
                if (getx.navigationList.length - 2 > 3) {
                  resetTblLocalNavigationByOrder(
                      getx.navigationList.length - 2);

                  // insertTblLocalNavigation(
                  //     "ParentId",
                  //     getx.navigationList[getx.navigationList.length-2]
                  //         ['NavigationId'],
                  //     getx.navigationList[getx.navigationList.length-2]
                  //         ["NavigationName"]);

                  getChapterContents(int.parse(
                      getx.navigationList[getx.navigationList.length - 2]
                          ['NavigationId']));
                  getChapterFiles(
                      parentId: int.parse(
                          getx.navigationList[getx.navigationList.length - 2]
                              ['NavigationId']),
                      'Video',
                      getx.selectedPackageId.value.toString());
                  getChapterFiles(
                    parentId: int.parse(
                        getx.navigationList[getx.navigationList.length - 2]
                            ['NavigationId']),
                    'PDF',
                    getx.selectedPackageId.value.toString(),
                  );

                  getLocalNavigationDetails();
                }

                Get.back();
              }),
          elevation: 0,
          shadowColor: Colors.grey,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.grey.shade200,
          title: Padding(
            padding: const EdgeInsets.only(
              bottom: 7,
            ),
            child: Container(
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
                                              // if (i == 0) {
                                              //   // nothing
                                              // }
                                              // if (i == 1) {
                                              //   print('press in video');
                                              //   resetTblLocalNavigationByOrder(
                                              //       2);
                                              //   getStartParentId(int.parse(
                                              //           getx.navigationList[
                                              //                   1][
                                              //               'NavigationId']))
                                              //       .then((value) {
                                              //     print(value);
                                              //     getChapterContents(
                                              //         int.parse(value
                                              //             .toString()));
                                              //     getChapterFiles(
                                              //         parentId: int.parse(
                                              //             value.toString()),
                                              //         'PDF',
                                              //         getx.selectedPackageId
                                              //             .value
                                              //             .toString());
                                              //     getChapterFiles(
                                              //         parentId: int.parse(
                                              //             value.toString()),
                                              //         'Video',
                                              //         getx.selectedPackageId
                                              //             .value
                                              //             .toString());
                                              //   });
                                              //   getLocalNavigationDetails();
                                              // }
                                              // if (i == 2) {
                                              //   print('press in video');
                                              //   resetTblLocalNavigationByOrder(
                                              //       2);
                                              //   getStartParentId(int.parse(
                                              //           getx.navigationList[
                                              //                   1][
                                              //               'NavigationId']))
                                              //       .then((value) {
                                              //     print(value);
                                              //     getChapterContents(
                                              //         int.parse(value
                                              //             .toString()));
                                              //     getChapterFiles(
                                              //         parentId: int.parse(
                                              //             value.toString()),
                                              //         'PDF',
                                              //         getx.selectedPackageId
                                              //             .value
                                              //             .toString());
                                              //     getChapterFiles(
                                              //         parentId: int.parse(
                                              //             value.toString()),
                                              //         'Video',
                                              //         getx.selectedPackageId
                                              //             .value
                                              //             .toString());
                                              //   });
                                              //   getLocalNavigationDetails();
                                              // }
                                              // if (i > 2) {
                                              //   resetTblLocalNavigationByOrder(
                                              //       i);
                                              //   getChapterContents(int.parse(
                                              //       getx.navigationList[i]
                                              //           ['NavigationId']));
                                              //   getChapterFiles(
                                              //       parentId: int.parse(getx
                                              //               .navigationList[
                                              //           i]['NavigationId']),
                                              //       'PDF',
                                              //       getx.selectedPackageId
                                              //           .value
                                              //           .toString());
                                              //   getLocalNavigationDetails();
                                              //   getChapterFiles(
                                              //       parentId: int.parse(getx
                                              //               .navigationList[
                                              //           i]['NavigationId']),
                                              //       'Video',
                                              //       getx.selectedPackageId
                                              //           .value
                                              //           .toString());
                                              //   getLocalNavigationDetails();
                                              // }
                                              // print(getx
                                              //     .alwaysShowChapterDetailsOfVideo
                                              //     .length);
                                            },
                                            child: Row(
                                              children: [
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
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10),
                                                        child: Text(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            getx.navigationList[
                                                                    i][
                                                                "NavigationName"],
                                                            style: FontFamily
                                                                .styleb
                                                                .copyWith(
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 50),
                                                  ),
                                                ),
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

          // title: Row(
          //   children: [

          //     // for (var i = 0; i < getx.navigationList.length; i++)
          //     //   getx.navigationList.isEmpty
          //     //       ? Text("Blank")
          //     //       : InkWell(
          //     //           onTap: () {},
          //     //           child: Text(
          //     //               getx.navigationList[i]["NavigationName"] + ' > '),
          //     //         )
          //   ],
          // ),
          actions: [],
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // getx.isIconSideBarVisible.value
            //     ? Expanded(
            //         flex: 1,
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: 10, vertical: 10),
            //           child: IconSidebar(
            //             selecteIndex: -1,
            //           ),
            //         ),
            //       ) // Hidden sidebar
            //     : Container(width: 0),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: Color.fromARGB(255, 143, 141, 141),
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: videoPlayerLeft()),
                ),
              ),
            ),
            Obx(
              () => Expanded(
                  flex: 6,
                  child: expanded.value
                      ? SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
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
                                  child: page[selectedIndexOfVideoList],
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
                        )),
            ),
          ],
        ),
      ),
    );
  }

//  int selectedListIndex = -1;
  Widget videoPlayerLeft() {
    return Column(
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

                          return ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context)
                                .copyWith(scrollbars: false),
                            child: ListView.builder(
                              shrinkWrap: true,
                              // Removed NeverScrollableScrollPhysics to allow natural scrolling
                              itemCount:
                                  getx.alwaysShowChapterfilesOfVideo.length,
                              itemBuilder: (context, index) {
                                int duration = int.parse(
                                        getx.alwaysShowChapterfilesOfVideo[
                                            index]['AllowDuration']) -
                                    int.parse(getLastEndDuration(int.parse(
                                        getx.alwaysShowChapterfilesOfVideo[
                                            index]['FileId'])));
                                bool isMatchingVideo = snapshot.data!.any(
                                    (videoInfo) =>
                                        videoInfo['VideoId'].toString() ==
                                        getx.alwaysShowChapterfilesOfVideo[
                                                index]['FileId']
                                            .toString());

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ExpansionTile(
                                      collapsedBackgroundColor: isMatchingVideo
                                          ? Colors.blue[50]
                                          : Colors.white,
                                      enabled: File(getx.userSelectedPathForDownloadVideo
                                                              .isEmpty
                                                          ? getx.defaultPathForDownloadVideo
                                                                  .value +
                                                              '\\' +
                                                              getx.alwaysShowChapterfilesOfVideo[index]
                                                                  ['FileIdName']
                                                          : getx.userSelectedPathForDownloadVideo
                                                                  .value +
                                                              '\\' +
                                                              getx.alwaysShowChapterfilesOfVideo[index]
                                                                  [
                                                                  'FileIdName'])
                                                      .existsSync() ==
                                                  false &&
                                              !expanded.value
                                          ? false
                                          : true,
                                      backgroundColor: selectedListIndex ==
                                              index
                                          ? ColorPage.white.withOpacity(0.5)
                                          : Color.fromARGB(255, 255, 255, 255),
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
                                      subtitle: Row(
                                        children: [
                                          Text(
                                            'Duration:' + duration.toString(),
                                            style: TextStyle(
                                              color: ColorPage.grey,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        getx.alwaysShowChapterfilesOfVideo[
                                                index]["FileIdName"] +
                                            ' - ${index + 1}.mp4',
                                        style: GoogleFonts.inter().copyWith(
                                          fontWeight: FontWeight.w800,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: selectedListIndex == index
                                              ? 20
                                              : null,
                                        ),
                                      ),
                                      trailing: SizedBox(
                                        width: 170,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            File(getx.userSelectedPathForDownloadVideo
                                                                    .isEmpty
                                                                ? getx.defaultPathForDownloadVideo
                                                                        .value +
                                                                    '\\' +
                                                                    getx.alwaysShowChapterfilesOfVideo[index][
                                                                        'FileIdName']
                                                                : getx.userSelectedPathForDownloadVideo
                                                                        .value +
                                                                    '\\' +
                                                                    getx.alwaysShowChapterfilesOfVideo[index]
                                                                        [
                                                                        'FileIdName'])
                                                            .existsSync() ==
                                                        false &&
                                                    getVideoPlayModeFromPackageId(
                                                            getx.selectedPackageId
                                                                .value
                                                                .toString()) ==
                                                        "true"
                                                ? Tooltip(
                                                    message: "Play Online",
                                                    child: IconButton(
                                                      onPressed: () {
                                                        getx.playLink.value =
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

                                                        if (getx
                                                            .isInternet.value) {
                                                          // List unUploadedeVideoinfo =await   fetchUploadableVideoInfo();
                                                          fetchUploadableVideoInfo()
                                                              .then(
                                                                  (valueList) async {
                                                            print(valueList);

                                                            if (getx.isInternet
                                                                .value) {
                                                              await unUploadedVideoInfoInsert(
                                                                  context,
                                                                  valueList,
                                                                  getx
                                                                      .loginuserdata[
                                                                          0]
                                                                      .token);
                                                            }
                                                            getx.playingVideoId
                                                                    .value =
                                                                getx.alwaysShowChapterfilesOfVideo[
                                                                        index]
                                                                    ['FileId'];
                                                            videoPlay
                                                                .updateVideoLink(
                                                                    getx.playLink
                                                                        .value);
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
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                                duration:
                                                                    const Duration(
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
                                                        Icons.play_circle_fill,
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
                                                                    getx.alwaysShowChapterfilesOfVideo[index][
                                                                        'FileIdName']
                                                                : getx.userSelectedPathForDownloadVideo
                                                                        .value +
                                                                    '\\' +
                                                                    getx.alwaysShowChapterfilesOfVideo[index][
                                                                        'FileIdName'])
                                                            .existsSync() ==
                                                        false
                                                ? IconButton(
                                                    onPressed: () {
                                                      if (getx
                                                          .isInternet.value) {
                                                        cancelToken =
                                                            CancelToken();

                                                        startDownload2(
                                                            index,
                                                            getx.alwaysShowChapterfilesOfVideo[
                                                                    index][
                                                                'DocumentPath'],
                                                            getx.alwaysShowChapterfilesOfVideo[
                                                                    index]
                                                                ['FileIdName'],
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
                                                      color:
                                                          ColorPage.colorbutton,
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
                                                              Future.delayed(
                                                                      Duration(
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
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : IconButton(
                                                        onPressed: () async {
                                                          getx.playLink.value = getx
                                                                  .userSelectedPathForDownloadVideo
                                                                  .isEmpty
                                                              ? getx.defaultPathForDownloadVideo
                                                                      .value +
                                                                  '\\' +
                                                                  getx.alwaysShowChapterfilesOfVideo[
                                                                          index]
                                                                      [
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
                                                                      getx.alwaysShowChapterfilesOfVideo[
                                                                              index]
                                                                          [
                                                                          'FileIdName']
                                                                  : getx.userSelectedPathForDownloadVideo
                                                                          .value +
                                                                      '\\' +
                                                                      getx.alwaysShowChapterfilesOfVideo[
                                                                              index]
                                                                          [
                                                                          'FileIdName'])
                                                              .existsSync()) {
                                                            // List unUploadedeVideoinfo =await   fetchUploadableVideoInfo();
                                                            fetchUploadableVideoInfo()
                                                                .then(
                                                                    (valueList) async {
                                                              print(valueList);

                                                              if (getx
                                                                  .isInternet
                                                                  .value) {
                                                                await unUploadedVideoInfoInsert(
                                                                    context,
                                                                    valueList,
                                                                    getx
                                                                        .loginuserdata[
                                                                            0]
                                                                        .token);
                                                              }
                                                              getx.playingVideoId
                                                                      .value =
                                                                  getx.alwaysShowChapterfilesOfVideo[
                                                                          index]
                                                                      [
                                                                      'FileId'];
                                                              videoPlay
                                                                  .updateVideoLink(getx
                                                                      .playLink
                                                                      .value);
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
                                                                  duration:
                                                                      const Duration(
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
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons
                                                        .keyboard_arrow_down_outlined,
                                                color: ColorPage.colorbutton,
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
                                                      BorderRadius.circular(8),
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
                                );
                              },
                            ),
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
    );
  }

  deleteVideo() {
    deleteWarning();
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
          OnConfirm: () {
            Navigator.of(context).pop();
          },
          btn1: 'Cancel',
          btn2: 'Delete',
          linkText: 'Learn more about deleting videos',
        );
      },
    );
  }

  static Future<bool> isProcessRunning(String processName) async {
    final result = await Process.run('tasklist', []);
    return result.stdout.toString().contains(processName);
  }

  Future<bool> checkFileExists(String path) async {
    final file = File(path);
    return await file.exists();
  }

  Future<String> getVideosDirectoryPath() async {
    final String userHomeDir =
        Platform.environment['USERPROFILE'] ?? 'C:\\Users\\Default';

    final String videosDirPath = p.join(userHomeDir, 'Videos');

    print('Videos Directory Path: $videosDirPath');

    return videosDirPath;
  }

  CancelToken cancelToken = CancelToken();

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
        videoPlay.updateVideoLink(savePath);
        setState(() {});

        fetchUploadableVideoInfo().then((valueList) async {
          print(valueList);
          if (getx.isInternet.value) {
            unUploadedVideoInfoInsert(
                context, valueList, getx.loginuserdata[0].token);
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

// Cancel the download
  void cancelDownload(CancelToken cancelToken) {
    cancelToken.cancel("Download canceled by user.");
    print("Download canceled");
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

  Widget videoPlayerRight() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton.filled(
                        tooltip: 'Previous',
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(ColorPage.colorbutton)),
                        onPressed: () {},
                        icon: Icon(
                          Icons.fast_rewind,
                        )),
                  ),
                  isPlaying
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton.filled(
                              tooltip: 'Pause',
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      ColorPage.colorbutton)),
                              onPressed: () {
                                setState(() {
                                  videoPlay.pauseVideo();
                                });
                                // log(videoPlay.totalPlayTime.inSeconds
                                //     .toString());
                              },
                              icon: Icon(
                                Icons.pause,
                              )),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton.filled(
                              tooltip: 'Play',
                              style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      ColorPage.colorbutton)),
                              onPressed: () {
                                setState(() {
                                  videoPlay.playVideo();
                                });
                              },
                              icon: Icon(
                                Icons.play_arrow,
                              )),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton.filled(
                        tooltip: 'Next',
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(ColorPage.colorbutton)),
                        onPressed: () {},
                        icon: Icon(
                          Icons.fast_forward,
                        )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton.filled(
                        tooltip: 'Tag',
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(ColorPage.colorbutton)),
                        onPressed: () {
                          addTag(context);
                        },
                        icon: Icon(
                          Icons.edit_note,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton.filled(
                        tooltip: 'Speed',
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(ColorPage.colorbutton)),
                        onPressed: () {
                          showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(10, 118, 0, 10),
                              items: speeds.map((speed) {
                                return PopupMenuItem<double>(
                                  value: speed,
                                  child: Row(
                                    children: [
                                      Radio<double>(
                                        value: speed,
                                        groupValue: selectedSpeed,
                                        onChanged: (double? value) {
                                          setState(() {
                                            selectedSpeed = value!;
                                            videoPlay.player
                                                .setRate(selectedSpeed);
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                      Text('${speed}x'),
                                    ],
                                  ),
                                );
                              }).toList());
                        },
                        icon: Icon(Icons.slow_motion_video)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton.filled(
                        tooltip: 'GOTO',
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(ColorPage.colorbutton)),
                        onPressed: () {
                          showGotoDialog(context);
                        },
                        icon: Icon(Icons.drag_indicator)),
                  )
                ],
              ),
            ],
          ),
          Card(
            surfaceTintColor: Colors.white,
            color: Colors.white,
            elevation: 0.0,
            child: MaterialDesktopVideoControlsTheme(
              normal: MaterialDesktopVideoControlsThemeData(
                controlsHoverDuration: Duration(seconds: 5),
                primaryButtonBar: [
                  MaterialDesktopSkipPreviousButton(
                    iconSize: 80,
                    iconColor: ColorPage.red,
                  ),
                  MaterialDesktopPlayOrPauseButton(
                    iconSize: 80,
                  ),
                ],
                seekBarThumbColor: ColorPage.colorbutton,
                seekBarPositionColor: ColorPage.colorbutton,
                toggleFullscreenOnDoublePress: false,
              ),
              fullscreen: MaterialDesktopVideoControlsThemeData(),
              child: Container(
                height: 670,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.only(bottom: 40),
                child: Video(controller: videoPlay.controller),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void showGotoDialog(BuildContext context) {
    double hours = 0;
    double minutes = 0;
    double seconds = 0;

    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      alertPadding: EdgeInsets.only(top: 200),
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey),
      ),
      titleStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      constraints: BoxConstraints.expand(width: 500),
      overlayColor: Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center,
    );

    Alert(
      context: context,
      style: alertStyle,
      title: "Go to Time",
      content: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text("Hours",
                          style: FontFamily.font9
                              .copyWith(color: ColorPage.colorblack)),
                      SpinBox(
                        min: 0,
                        max: 23,
                        value: hours,
                        onChanged: (value) {
                          hours = value;
                        },
                        decrementIcon: Icon(Icons.arrow_left_sharp),
                        incrementIcon: Icon(Icons.arrow_right_sharp),
                        spacing: 8.0,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Text("Minutes",
                          style: FontFamily.font9
                              .copyWith(color: ColorPage.colorblack)),
                      SpinBox(
                        min: 0,
                        max: 59,
                        value: minutes,
                        onChanged: (value) {
                          minutes = value;
                        },
                        decrementIcon: Icon(Icons.arrow_left_sharp),
                        incrementIcon: Icon(Icons.arrow_right_sharp),
                        spacing: 8.0,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Text("Seconds",
                          style: FontFamily.font9
                              .copyWith(color: ColorPage.colorblack)),
                      SpinBox(
                        min: 0,
                        max: 59,
                        value: seconds,
                        onChanged: (value) {
                          seconds = value;
                        },
                        decrementIcon: Icon(Icons.arrow_left_sharp),
                        incrementIcon: Icon(Icons.arrow_right_sharp),
                        spacing: 8.0,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () {
            Get.back();
          },
          color: Colors.red,
          radius: BorderRadius.circular(5.0),
        ),
        DialogButton(
          child: Text(
            "Go",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () {
            final Duration position = Duration(
              hours: hours.toInt(),
              minutes: minutes.toInt(),
              seconds: seconds.toInt(),
            );

            videoPlay.seekTo(position); // Seek to the calculated position
            Get.back();
          },
          color: Colors.blue,
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
  }

  addTag(context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      alertPadding: EdgeInsets.only(top: 200),
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.grey),
      ),
      titleStyle: TextStyle(color: ColorPage.blue, fontWeight: FontWeight.bold),
      constraints: BoxConstraints.expand(width: 350),
      overlayColor: Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center,
    );

    Alert(
      context: context,
      style: alertStyle,
      title: "Contribute your own tag",
      content: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('Write your tag here.....',
                      style: FontFamily.font
                          .copyWith(fontSize: ClsFontsize.ExtraSmall)),
                ),
              ],
            ),
            Card(
              child: SizedBox(
                  child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Typing something...'),
                maxLines: 5,
              )),
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
          child: Text("Cancel",
              style: TextStyle(color: Colors.white, fontSize: 15)),
          onPressed: () {
            Get.back();
          },
          color: ColorPage.red,
          radius: BorderRadius.circular(5.0),
        ),
        DialogButton(
          child:
              Text("Save", style: TextStyle(color: Colors.white, fontSize: 15)),
          onPressed: () {
            Get.back();
          },
          color: ColorPage.colorbutton,
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
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

// class Pdf extends StatefulWidget {

//   const Pdf({super.key});

//   @override
//   State<Pdf> createState() => _PdfState();
// }

// class _PdfState extends State<Pdf> {
//   String encryptionKey = '';
//   @override
//   void initState() {

//       encryptionKey = getEncryptionKeyFromTblSetting();

//         getPdf().whenComplete(() {});

//     // TODO: implement initState
//     super.initState();
//   }

//   Future getPdf() async {
//     if (getx.pdfListOfVideo.isNotEmpty) {

//       if( getx.pdfListOfVideo[0]['Encrypted'].toString() =="true"){
//           getx.encryptedpdffile.value = await downloadAndSavePdf(
//           getx.pdfListOfVideo[0]['DocumentURL'],
//           getx.pdfListOfVideo[0]['Names'],
//           getx.pdfListOfVideo[0]['PackageId'],
//           getx.pdfListOfVideo[0]['DocumentId'],
//           getx.pdfListOfVideo[0]['VideoId'],
//           getx.pdfListOfVideo[0]['Catagory']);

//       }
//       else{
//           getx.unEncryptedPDFfile.value = await downloadAndSavePdf(
//           getx.pdfListOfVideo[0]['DocumentURL'],
//           getx.pdfListOfVideo[0]['Names'],
//           getx.pdfListOfVideo[0]['PackageId'],
//           getx.pdfListOfVideo[0]['DocumentId'],
//           getx.pdfListOfVideo[0]['VideoId'],
//           getx.pdfListOfVideo[0]['Catagory']);
//       }

//     }
//   }

//   Future downloadAndSavePdf(String pdfUrl, String title,
//       String packageId, String documentId, String fileId, String type) async {
//     final data = getDownloadedPathOfFileOfVideo(
//         getx.   pdfListOfVideo [0]['PackageId'],
//         getx.pdfListOfVideo[0]['VideoId'],
//         getx.pdfListOfVideo[0]['Catagory'],
//         getx.pdfListOfVideo[0]['DocumentId']);

//     if (!File(data).existsSync()) {
//       try {
//         // Get the application's document directory
//         Directory appDocDir = await getApplicationDocumentsDirectory();

//         // Create the folder structure: com.si.dthLive/notes
//         Directory dthLmsDir =
//             Directory('${appDocDir.path}/$origin/notes');
//         if (!await dthLmsDir.exists()) {
//           await dthLmsDir.create(recursive: true);
//         }
//         var prefs = await SharedPreferences.getInstance();
//         getx.defaultPathForDownloadFile.value = dthLmsDir.path;
//         prefs.setString("DefaultDownloadpathOfFile", dthLmsDir.path);

//         // Correct file path to save the PDF
//         String filePath = getx.userSelectedPathForDownloadFile.isEmpty
//             ? '${dthLmsDir.path}/$title'
//             : getx.userSelectedPathForDownloadFile.value +
//                 "/$title"; // Make sure to add .pdf extension if needed

//         // Download the PDF using Dio
//         Dio dio = Dio();
//         await dio.download(pdfUrl, filePath,
//             onReceiveProgress: (received, total) {
//           if (total != -1) {
//             print(
//                 'Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
//           }
//         });
//         insertDownloadedFileDataOfVideo(
//             packageId, fileId, documentId, filePath, type, title);
//         insertPdfDownloadPath(fileId, packageId, filePath, documentId, context);

//         print('PDF downloaded and saved to: $filePath');
//         getx.pdfFilePath.value = filePath;
//        if( getx.pdfListOfVideo[0]['Encrypted'].toString()=="true"){
//          final encryptedBytes = await readEncryptedPdfFromFile(filePath);
//         final decryptedPdfBytes = aesDecryptPdf(encryptedBytes, encryptionKey);

//         return decryptedPdfBytes;
//        }
//        else{
//         return filePath;

//        }
//       } catch (e) {
//         writeToFile(e, "downloadAndSavePdf");
//         print('Error downloading or saving the PDF: $e');
//         return  getx.pdfListOfVideo[0]['Encrypted']=="true"? Uint8List(0):'';
//       }
//     } else {
//      if( getx.pdfListOfVideo[0]['Encrypted'].toString()=="true"){
//        getx.pdfFilePath.value = data;

//       final encryptedBytes = await readEncryptedPdfFromFile(data);
//       final decryptedPdfBytes = aesDecryptPdf(encryptedBytes, encryptionKey);
//       return decryptedPdfBytes;
//      }
//      else{
//       return data;
//      }
//     }
//   }

//   Future<Uint8List> readEncryptedPdfFromFile(String filePath) async {
//     final file = File(filePath);
//     return file.readAsBytes();
//   }

//   Uint8List aesDecryptPdf(Uint8List encryptedData, String key) {
//     final keyBytes = encrypt.Key.fromUtf8(key.padRight(16)); // 128-bit key
//     final iv = encrypt.IV(encryptedData.sublist(0, 16)); // Extract IV
//     final encrypter =
//         encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

//     final encryptedBytes =
//         encryptedData.sublist(16); // Extract actual encrypted data
//     final decrypted =
//         encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

//     return Uint8List.fromList(decrypted);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  getx.pdfListOfVideo [0]['Encrypted'].toString()=="true"?   Obx(
//       () => SizedBox(
//         height: MediaQuery.of(context).size.height * 0.9,
//         child: getx.pdfListOfVideo.isEmpty
//             ? Center(
//                 child: Text(
//                   "No PDF Here",
//                   style: FontFamily.font,
//                 ),
//               )
//             : getx.encryptedpdffile.value.isNotEmpty
//                 ? SfPdfViewer.memory(getx.encryptedpdffile.value)
//                 : Center(child: CircularProgressIndicator()),
//       ),
//     ):Obx(
//       () => SizedBox(
//         height: MediaQuery.of(context).size.height * 0.9,
//         child: getx.pdfListOfVideo.isEmpty
//             ? Center(
//                 child: Text(
//                   "No PDF Here",
//                   style: FontFamily.font,
//                 ),
//               )
//             : File(getx.unEncryptedPDFfile.value).existsSync()
//                 ? SfPdfViewer.file( File(getx.unEncryptedPDFfile.value))
//                 : Center(child: CircularProgressIndicator()),
//       ),
//     );;
//   }
// }

class Pdf extends StatefulWidget {
  const Pdf({super.key});

  @override
  State<Pdf> createState() => _PdfState();
}

class _PdfState extends State<Pdf> with SingleTickerProviderStateMixin {
  String encryptionKey = '';
  late TabController _tabController;

  @override
  void initState() {
    encryptionKey = getEncryptionKeyFromTblSetting();
    _tabController = TabController(
      length: getx.pdfListOfVideo.length, // Number of tabs
      vsync: this,
    );

    // Set up a listener to handle tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        getPdf(_tabController.index).whenComplete(() {
          setState(() {});
        });
      }
    });

    getPdf(0); // Load the first PDF by default
    super.initState();
  }

  Future getPdf(int index) async {
    if (getx.pdfListOfVideo.isNotEmpty) {
      // print("////////////////////////////////////////////////////////////////"+getx.pdfListOfVideo.length.toString());
      final pdfDetails = getx.pdfListOfVideo[index];
      if (pdfDetails['Encrypted'].toString() == "true") {
        getx.encryptedpdffile.value = await downloadAndSavePdf(
            pdfDetails['DocumentURL'],
            pdfDetails['Names'],
            pdfDetails['PackageId'],
            pdfDetails['DocumentId'],
            pdfDetails['VideoId'],
            pdfDetails['Catagory'],
            pdfDetails['Encrypted']);
      } else {
        getx.unEncryptedPDFfile.value = await downloadAndSavePdf(
            pdfDetails['DocumentURL'],
            pdfDetails['Names'],
            pdfDetails['PackageId'],
            pdfDetails['DocumentId'],
            pdfDetails['VideoId'],
            pdfDetails['Catagory'],
            pdfDetails['Encrypted']);
      }
    }
  }

  String getDownloadedPathOfPDFfileofVideo(String name, String folderName) {
    // Get the first result

    final downloadedPath = getx.userSelectedPathForDownloadFile.isEmpty
        ? getx.defaultPathForDownloadFile.value + '\\$folderName\\' + name
        : getx.userSelectedPathForDownloadFile.value + '\\$folderName\\' + name;

    print('downloadpath : $downloadedPath');

    if (downloadedPath != '0') {
      return downloadedPath;
    }
    return '0';
  }

  Future downloadAndSavePdf(String pdfUrl, String title, String packageId,
      String documentId, String fileId, String type, String isEncrypted) async {
    final data = getDownloadedPathOfPDFfileofVideo(title, "notes");
    print(data);

    if (!File(data).existsSync()) {
      try {
        // Get the application's document directory
        Directory appDocDir = await getApplicationDocumentsDirectory();

        // Create the folder structure: com.si.dthLive/notes
        Directory dthLmsDir = Directory('${appDocDir.path}\\$origin');
        if (!await dthLmsDir.exists()) {
          await dthLmsDir.create(recursive: true);
        }
        var prefs = await SharedPreferences.getInstance();
        getx.defaultPathForDownloadFile.value = dthLmsDir.path;
        prefs.setString("DefaultDownloadpathOfFile", dthLmsDir.path);

        // Correct file path to save the PDF
        String filePath = getx.userSelectedPathForDownloadFile.isEmpty
            ? '${dthLmsDir.path}\\notes\\$title'
            : getx.userSelectedPathForDownloadFile.value +
                "\\notes\\$title"; // Make sure to add .pdf extension if needed

        // Download the PDF using Dio
        Dio dio = Dio();
        await dio.download(pdfUrl, filePath,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
                'Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        });
        insertDownloadedFileDataOfVideo(
            packageId, fileId, documentId, filePath, type, title);
        insertPdfDownloadPath(fileId, packageId, filePath, documentId, context);

        print('PDF downloaded and saved to: $filePath');
        getx.pdfFilePath.value = filePath;
        if (isEncrypted.toString() == "true") {
          final encryptedBytes = await readEncryptedPdfFromFile(filePath);
          final decryptedPdfBytes =
              aesDecryptPdf(encryptedBytes, encryptionKey);

          return decryptedPdfBytes;
        } else {
          return filePath;
        }
      } catch (e) {
        writeToFile(e, "downloadAndSavePdf");
        print('Error downloading or saving the PDF: $e');
        return isEncrypted == "true" ? Uint8List(0) : '';
      }
    } else {
      if (isEncrypted == "true") {
        getx.pdfFilePath.value = data;

        final encryptedBytes = await readEncryptedPdfFromFile(data);
        final decryptedPdfBytes = aesDecryptPdf(encryptedBytes, encryptionKey);
        return decryptedPdfBytes;
      } else {
        return data;
      }
    }
  }

  Future<Uint8List> readEncryptedPdfFromFile(String filePath) async {
    final file = File(filePath);
    return file.readAsBytes();
  }

  Uint8List aesDecryptPdf(Uint8List encryptedData, String key) {
    final keyBytes = encrypt.Key.fromUtf8(key.padRight(16)); // 128-bit key
    final iv = encrypt.IV(encryptedData.sublist(0, 16)); // Extract IV
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));

    final encryptedBytes =
        encryptedData.sublist(16); // Extract actual encrypted data
    final decrypted =
        encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

    return Uint8List.fromList(decrypted);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          // TabBar
          Obx(() => TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: getx.pdfListOfVideo
                    .map((pdf) => Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Tab(height: 25, text: pdf['Names']),
                        )))
                    .toList(),
              )),
          SizedBox(
            height: 20,
          ),
          // PDF Viewer
          Expanded(
            child: Obx(() {
              if (getx.pdfListOfVideo.isEmpty) {
                return Center(
                  child: Text(
                    "No PDF Here",
                    style: FontFamily.font,
                  ),
                );
              }

              final currentPdf = getx.pdfListOfVideo[_tabController.index];
              if (currentPdf['Encrypted'].toString() == "true") {
                return getx.encryptedpdffile.value.isNotEmpty
                    ? SfPdfViewer.memory(getx.encryptedpdffile.value)
                    : Center(child: CircularProgressIndicator());
              } else {
                return File(getx.unEncryptedPDFfile.value).existsSync()
                    ? SfPdfViewer.file(File(getx.unEncryptedPDFfile.value))
                    : Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class AskDoubt extends StatefulWidget {
  // final int videoId;
  const AskDoubt({super.key});

  @override
  State<AskDoubt> createState() => _AskDoubtState();
}

class _AskDoubtState extends State<AskDoubt> {
  // Dummy data for chat messages (Initial State)
  Getx getx = Get.put(Getx());

  TextEditingController msgController = TextEditingController();
  RxBool isLoading =
      false.obs; // For showing loading indicator while fetching data

  // Function to send message to API and get a response
  // Declare a list to store the result
  List<Map<String, dynamic>> answersList = [];

  final img.ImagePicker _picker = img.ImagePicker(); // Initialize image picker
  File? _selectedImage; // Variable to store the selected image

  // Method to pick an image
  Future<void> pickImage() async {
    try {
      final img.XFile? image = await _picker.pickImage(
        source: img.ImageSource.gallery,
      ); // Open image picker

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar("Error", "Could not select image");
    }
  }

  // Declare a list to store the parsed result

  Future<void> sendMessage(int videoId, String msg) async {
    // if (msgController.text.trim().isEmpty) return; // Check for empty message

    isLoading.value = true; // Show loading indicator

    try {
      var response = await http.post(
        Uri.https(ClsUrlApi.mainurl, ClsUrlApi.askDoubteQuestion),
        headers: {
          'accept': 'text/plain',
          'Authorization': 'Bearer ${getx.loginuserdata[0].token}',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "tblQuestion": {"VideoId": videoId, "Question": msg}
        }),
      );
      print(response.toString());
      if (response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);

        print(jsonResponse);

        // Extract and parse the result string into a list
        if (jsonResponse['result'] is String) {
          List<dynamic> rawList = json.decode(jsonResponse['result']);
          answersList =
              rawList.map((item) => Map<String, dynamic>.from(item)).toList();
        }
        if (getx.askDoubtanswermessages.isNotEmpty) {
          getx.askDoubtanswermessages.clear();
        }
        // Debug print to check the parsed list
        answersList.forEach((answer) {
          print('Answer: ${answer['Answer']}');

          Map<String, String> data = {
            "AnswerId": answer['Answer'].toString(),
            "Answer": answer['Answer'].toString(),
            "QuestionId": answer['QuestionId'].toString(),
            "Question": answer['Question'].toString(),
            "VideoId": answer['VideoId'].toString(),
            "IsApprove": answer['IsApprove'].toString(),
            "AnswerByFacultyName": answer['AnswerByFacultyName'].toString(),
            "AnswerDocumentUrl": answer['AnswerDocumentUrl'].toString(),
            "QuestionDocumentUrl": answer["QuestionDocumentUrl"].toString()
          };
          getx.askDoubtanswermessages.add(data);
        });

        isLoading.value = false; // Hide loading indicator
      } else if (response.statusCode == 401) {
        _onTokenExpire(context);
      } else {
        print('Failed with status: ${response.statusCode}');
        print(response.body);
        isLoading.value = false; // Hide loading indicator
      }
    } catch (e) {
      writeToFile(e, "sendMessage");
      getx.askDoubtmessages.add({
        'sender': 'Bot',
        'message': 'An error occurred. Please check your connection. $e'
      });
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

  @override
  void initState() {
    sendMessage(int.parse(getx.playingVideoId.value), "").whenComplete(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: getx.askDoubtanswermessages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(0)),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: SizedBox(
                                width: 200,
                                child: Text(
                                  getx.askDoubtanswermessages[index]
                                      ['Question']!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        getx.askDoubtanswermessages[index]["Answer"] != "null"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.amber[200],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(20)),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: SizedBox(
                                        width: 200,
                                        child: HtmlWidget(
                                            getx.askDoubtanswermessages[index]
                                                        ["Answer"] ==
                                                    "null"
                                                ? "<P>Answer pending!</p>"
                                                : getx.askDoubtanswermessages[
                                                        index]['Answer'] ??
                                                    "<P>Answer pending </p>")),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (isLoading.value) CircularProgressIndicator(),

            if (_selectedImage != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.file(
                    _selectedImage!,
                    width: Platform.isAndroid ? 150 : 500,
                    height: Platform.isAndroid ? 150 : 300,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      isLoading.value = true;
                      String key = await getUploadAccessKey(
                          context, getx.loginuserdata[0].token);
                      if (key != "") {
                        uploadSheet(_selectedImage!,
                                getx.loginuserdata[0].token, key, "AskDoubt")
                            .then((documentId) {
                          if (documentId == "") {
                            setState(() {
                              isLoading.value = false;
                            });
                          } else {
                            setState(() {
                              isLoading.value = false;
                              _selectedImage = null;
                              sendMessage(int.parse(getx.playingVideoId.value),
                                  documentId.toString());
                            });
                          }
                        });
                      }
                    },
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            // if (isLoading.value) const CircularProgressIndicator(),

            // Show loading indicator
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onFieldSubmitted: (value) {
                        sendMessage(int.parse(getx.playingVideoId.value),
                            msgController.text);
                      },
                      controller: msgController,
                      decoration: InputDecoration(
                        suffixIcon: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    pickImage();
                                  },
                                  icon:
                                      Icon(Icons.add_photo_alternate_rounded)),
                              IconButton(
                                  onPressed: () {
                                    sendMessage(
                                        int.parse(getx.playingVideoId.value),
                                        msgController.text);
                                  },
                                  icon: Icon(Icons.send)),
                            ],
                          ),
                        ),
                        alignLabelWithHint: true,
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 2)),
                      ),
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

  _onTokenExpire(context) {
    Alert(
      context: context,
      type: AlertType.warning,
      style: AlertStyle(
        titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "SESSION EXPIRE!!",
      desc: "Your session is expire! need to re login",
      buttons: [
        DialogButton(
          child:
              Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: ColorPage.blue,
          onPressed: () {
            Navigator.pop(context);
            Get.offAll(() => DthLmsLogin(), arguments: {
              'loginid': getx.loginuserdata[0].loginId,
              'password': getx.loginuserdata[0].password
            });
          },
          color: const Color.fromARGB(255, 207, 43, 43),
        ),
      ],
    ).show();
  }
}

class Tags extends StatefulWidget {
  final VideoPlayClass videoPlay;
  const Tags({super.key, required this.videoPlay});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  late VideoPlayClass videoPlay;
  @override
  void initState() {
    videoPlay = widget.videoPlay;
    // TODO: implement in
    // itState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.builder(
          itemCount: getx.tagListOfVideo.length,
          itemBuilder: (context, index) {
            return Material(
              color: Colors.transparent,
              child: ListTile(
                onTap: () {
                  videoPlay.seekTo(
                      parseDuration(getx.tagListOfVideo[index]['VideoTime']));
                },
                title: Text(
                  getx.tagListOfVideo[index]['TagName'],
                  style: FontFamily.styleb
                      .copyWith(fontSize: 16, color: Colors.grey[700]),
                ),
                subtitle: Text(
                  getx.tagListOfVideo[index]['VideoTime'],
                  style: FontFamily.styleb
                      .copyWith(fontSize: 14, color: Colors.grey[500]),
                ),
                leading: Icon(
                  Icons.timeline,
                  size: 18,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Duration parseDuration(String timeString) {
    // Split the string by the colon
    List<String> parts = timeString.split(':');

    // Initialize variables for hours, minutes, and seconds
    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    // Determine the format based on the number of parts
    if (parts.length == 2) {
      // Format is "minutes:seconds"
      minutes = int.parse(parts[0]);
      seconds = int.parse(parts[1]);
    } else if (parts.length == 3) {
      // Format is "hours:minutes:seconds"
      hours = int.parse(parts[0]);
      minutes = int.parse(parts[1]);
      seconds = int.parse(parts[2]);
    }
    print(Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    ));
    // Create and return a Duration object based on the parsed values
    return Duration(
      hours: hours.toInt(),
      minutes: minutes.toInt(),
      seconds: seconds.toInt(),
    );
  }
}

// class HideScrollbarBehavior extends ScrollBehavior {
//   @override
//   // Widget buildOverscrollIndicator(
//   //     BuildContext context, Widget child, AxisDirection axisDirection) {
//   //   return child;
//   // }
// }

// Dummy class for LinearBorder
class LinearBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return LinearBorder();
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:convert'; // For JSON parsing
// import 'package:rflutter_alert/rflutter_alert.dart'; // For alert dialogs
class Mcq extends StatefulWidget {
  const Mcq({super.key});

  @override
  State<Mcq> createState() => _McqState();
}

class _McqState extends State<Mcq> {
  List<Map<String, String>> answer = [];
  Map<int, int> userAns =
      {}; // Store selected answer as the index of the option

  PageController _pageController = PageController();

  List<McqItem> mcqData = [];
  RxBool isSubmitted = false.obs;

  @override
  void initState() {
    super.initState();
    fetchMCQData();
  }

  Future<void> fetchMCQData() async {
    await getdata();
    generateAnswerList();
    setState(() {});
  }

  Future<void> getdata() async {
    String jsonData = jsonEncode(getx.mcqListOfVideo);
    print(jsonData);
    List<dynamic> parsedJson = jsonDecode(jsonData);
    List<McqItem> mcqDatalist = parsedJson
        .map((json) => McqItem.fromJson(json))
        .toList()
        .cast<McqItem>();
    mcqData = mcqDatalist;
    print(mcqData.length);
  }

  void generateAnswerList() {
    answer = mcqData.map((item) => {item.mcqId: item.answer}).toList();
  }

  List alreadyAnswer = [];
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String groupname = 'All Questions';
  List<int> reviewlist = [];
  RxInt qindex = 0.obs;
  int selectedIndex = -1;
  RxInt score = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          qindex.value = index;
        },
        itemCount: mcqData.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    children: [
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
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Column(
                                children: [
                                  SizedBox(width: 20),
                                  Text(
                                    textAlign: TextAlign.center,
                                    mcqData[index].mcqQuestion,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    color: Colors.black26,
                                    height: 3,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "${index + 1} / ${mcqData.length}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Answer options container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: SizedBox(
                    height: 600,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            physics: mcqData[index].options.length < 5
                                ? NeverScrollableScrollPhysics()
                                : AlwaysScrollableScrollPhysics(),
                            itemCount: mcqData[index].options.length,
                            itemBuilder: (context, optionIndex) {
                              String optionName = mcqData[index]
                                  .options[optionIndex]
                                  .optionName;
                              int questionId = int.parse(mcqData[index].mcqId);

                              // Get the correct answer index (converting from String to int)
                              int correctAnswerIndex = int.parse(
                                      answer.firstWhere(
                                          (map) => map.containsKey(
                                              mcqData[index].mcqId),
                                          orElse: () => {
                                                mcqData[index].mcqId: "0"
                                              })[mcqData[index].mcqId]!) -
                                  1; // Convert to zero-based index

                              bool isSelected = userAns[questionId] ==
                                  optionIndex; // Check if selected index matches
                              bool isCorrect =
                                  optionIndex == correctAnswerIndex;
                              // Correct if the index matches the correct answer
                              bool isAnswered = userAns.containsKey(questionId);

                              // Determine the color of each tile based on the selection and correctness
                              Color tileColor;
                              if (isAnswered) {
                                if (isSelected && isCorrect) {
                                  tileColor = Colors.green;
                                } else if (isSelected && !isCorrect) {
                                  tileColor = Colors.red;
                                } else if (isCorrect) {
                                  tileColor = Colors.green;
                                } else {
                                  tileColor = Colors.white; // default color
                                }
                              } else {
                                tileColor = Colors.white; // default color
                              }

                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: tileColor,
                                    borderRadius: BorderRadius.circular(8),
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
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () {
                                        setState(() {
                                          if (!userAns
                                              .containsKey(questionId)) {
                                            userAns[questionId] =
                                                optionIndex; // Store the index of the selected answer
                                          }
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              optionName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
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
                        // Previous, Next and Submit/Reset buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              height: 40,
                              color: Colors.blue,
                              padding: EdgeInsets.all(16),
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              onPressed: () {
                                if (index > 0) {
                                  _pageController.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: Text(
                                'Previous',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            MaterialButton(
                              height: 40,
                              color: Colors.blue,
                              padding: EdgeInsets.all(16),
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              onPressed: () {
                                if (index < mcqData.length - 1) {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else if (index == mcqData.length - 1) {
                                  _resetQuiz();
                                }
                              },
                              child: Text(
                                index == mcqData.length - 1 ? 'Reset' : 'Next',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      userAns.clear();
      isSubmitted.value = false;
      _pageController.jumpToPage(0);
    });
  }
}

class McqItem {
  final String mcqId;
  final String mcqType;
  final String mcqQuestion;
  final String answer;
  final List<Option> options;

  McqItem({
    required this.mcqId,
    required this.mcqType,
    required this.mcqQuestion,
    required this.answer,
    required this.options,
  });

  factory McqItem.fromJson(Map<String, dynamic> json) {
    return McqItem(
      mcqId: json['mcqId'],
      mcqType: json['mcqType'],
      mcqQuestion: json['mcqQuestion'],
      answer: json['answer'],
      options: (json['options'] as List<dynamic>)
          .map((option) => Option.fromJson(option))
          .toList(),
    );
  }
}

class Option {
  final String optionName;

  Option({
    required this.optionName,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionName: json['optionName'],
    );
  }
}

Future<void> run_Video_Player_exe(
  String videoPath,
  String token,
  String videoId,
  String pckageID,
  String dbPath,
) async {
  late String exePath;

  exePath = "exefiles/VideoPlayer/dthlmspro_video_player.exe";

  //  print("///////////////////////////////////////////");
  // print(videoPath);
  // print(token);
  // print(videoId);
  // print(pckageID);
  // print(dbPath);
  //    print("///////////////////////////////////////////");

  if (exePath.isNotEmpty) {
    await Process.run(
      'cmd',
      ['/c', 'start', exePath, videoPath, videoId, pckageID, token, dbPath],
      runInShell: true,
    );
  }
}
