import 'dart:async';
import 'dart:convert';
// import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/GLOBAL_WIDGET/loader.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';

import 'package:dthlms/PC/VIDEO/ClsVideoPlay.dart';
import 'package:dthlms/PC/VIDEO/videoplayer.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants/constants.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:get/get.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dthlms/key/key.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
// import 'package:motion_tab_bar/MotionBadgeWidget.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../API/ALL_FUTURE_FUNTIONS/all_functions.dart';

class MobileVideoPlayer extends StatefulWidget {
  final int Videoindex;
  final String videoLink;
  final String? packageId;
  final String? fileId;

  MobileVideoPlayer(
      {required this.videoLink,
      required this.Videoindex,
      super.key,
      this.packageId,
      this.fileId});

  @override
  State<MobileVideoPlayer> createState() => _MobileVideoPlayerState();
}

class _MobileVideoPlayerState extends State<MobileVideoPlayer>
    with TickerProviderStateMixin {
  late final Dio dio;

  Getx getx = Get.put(Getx());

  MotionTabBarController? _motionTabBarController;
  late final player = Player();

  late final controller = VideoController(player);
  var utcTime = DateTime.now();

  setDataForLastPlayed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('videoindex', widget.Videoindex.toString());
  }

  Map<String, dynamic> videoDetails = {};

  @override
  void initState() {
    getx.playLink.value = widget.videoLink;
    //  log(getx.playLink.value);
    print(widget.videoLink + '///////////////////');
    videoPlay = VideoPlayClass();
    videoPlay.updateVideoLink(getx.playLink.value);
    initialFunctionOfRightPlayer();
    // initialFunctionOfRightPlayer();
    dio = Dio();

    super.initState();

   

    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );

    if (widget.packageId != null && widget.fileId != null) {
      getMCQListOfVideo(
        widget.packageId.toString(),
        widget.fileId.toString(),
      );

      getPDFlistOfVideo(
        widget.packageId.toString(),
        widget.fileId.toString(),
      );

      getTaglistOfVideo(
        widget.packageId.toString(),
        widget.fileId.toString(),
      );
      functionVideoDetails(widget.fileId, widget.packageId);
    } else {
      getMCQListOfVideo(
          getx.alwaysShowChapterfilesOfVideo[widget.Videoindex]["PackageId"],
          getx.alwaysShowChapterfilesOfVideo[widget.Videoindex]["FileId"]);
          getReviewQuestionListOfVideo(
          getx.alwaysShowChapterfilesOfVideo[widget.Videoindex]["PackageId"],
          getx.alwaysShowChapterfilesOfVideo[widget.Videoindex]["FileId"]);



      getPDFlistOfVideo(
          getx.alwaysShowChapterfilesOfVideo[widget.Videoindex]["PackageId"],
          getx.alwaysShowChapterfilesOfVideo[widget.Videoindex]["FileId"]);

      getTaglistOfVideo(
          getx.alwaysShowChapterfilesOfVideo[widget.Videoindex]["PackageId"],
          getx.alwaysShowChapterfilesOfVideo[widget.Videoindex]["FileId"]);

      functionVideoDetails(
          getx.alwaysShowChapterfilesOfVideo[widget.Videoindex]["FileId"],
          getx.alwaysShowChapterfilesOfVideo[widget.Videoindex]["PackageId"]);
    }

    permission();
    setDataForLastPlayed();
  }

  functionVideoDetails(fileId, packageId) async {
    videoDetails = await getVideoDetails(fileId, packageId);

    setState(() {});
  }

  bool isPlaying = false;
  Timer? _timer;
initialFunctionOfRightPlayer() {
  creatTableVideoplayInfo();

  videoPlay.player.stream.playing.listen((bool playing) {
    if (mounted) {
      setState(() {
        isPlaying = playing;
      });
    }

    if (playing) {
      videoPlay.startTrackingPlayTime();

      // Cancel any existing timer to avoid multiple timers running
      _timer?.cancel();

      // Start a new timer that triggers every 5 seconds
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        // Insert video play information
        insertVideoplayInfo(
          int.parse(getx.playingVideoId.value),
          videoPlay.player.state.position.toString(),
          videoPlay.totalPlayTime.inSeconds.toString(),
          videoPlay.player.state.rate.toString(),
          videoPlay.startclocktime.toString(),
          utcTime.millisecondsSinceEpoch,
          0,
        );

        updateVideoConsumeDuration(
          getx.playingVideoId.value,
          getx.selectedPackageId.value.toString(),
          videoPlay.totalPlayTime.inSeconds.toString(),
        );
      });
    } else {
      videoPlay.stopTrackingPlayTime();

      // Stop the timer when the video is paused/stopped
      _timer?.cancel();
    }
  });

  // Listen for video completion (i.e., when the video ends)
  videoPlay.player.stream.completed.listen((completed) {
    if (completed) {
      // Show the feedback dialog only when the video is completed
      showFeedbackDialog(context,getx.reviewQuestionListOfVideo
      
//       [
//   {
//     "question": "What is your favorite color?",
//     "options": ["Red", "Blue", "Green", "Yellow"],
//   },
//   {
//     "question": "How often do you watch videos?",
//     "options": ["Daily", "Weekly", "Rarely"],
//   },

//    {
//     "question": "How often do you watch videos?2",
//     "options": ["Daily", "Weekly", "Rarely"],
//   },
//    {
//     "question": "How often do you watch videos?3",
//     "options": ["Daily", "Weekly", "Rarely"],
//   },
//   // More questions...
// ]

);
    }
  });
}


  @override
  void dispose() {
    _timer?.cancel();
    // dio.d;

    videoPlay.controller.player.dispose();
    _motionTabBarController!.dispose();
    super.dispose();
  }

  List<String> tabfield = const ["PDF", "MCQ", "TAG", "Ask doubt"];
  // Getx getx = Get.put(Getx());


  String pdflink = '';

  final List<double> speeds = [0.5, 1.0, 1.5, 2.0];
  double selectedSpeed = 1.0;

  late VideoPlayClass videoPlay;
  int t = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (getx.navigationList.length - 2 == 1) {
          print('press in video');
          resetTblLocalNavigationByOrder(1);

          getStartParentId(int.parse(getx.navigationList[1]['NavigationId']))
              .then((value) {
            print(value);
            getChapterContents(int.parse(value.toString()));
            getChapterFiles(
                parentId: int.parse(value.toString()),
                'Video',
                getx.selectedPackageId.value.toString());
          });
          getLocalNavigationDetails();
        }
        if (getx.navigationList.length - 2 >= 1) {
          resetTblLocalNavigationByOrder(getx.navigationList.length - 2);

          // insertTblLocalNavigation(
          //     "ParentId",
          //     getx.navigationList[getx.navigationList.length-2]
          //         ['NavigationId'],
          //     getx.navigationList[getx.navigationList.length-2]
          //         ["NavigationName"]);

          getChapterContents(int.parse(getx
              .navigationList[getx.navigationList.length - 2]['NavigationId']));
          getChapterFiles(
              parentId: int.parse(
                  getx.navigationList[getx.navigationList.length - 2]
                      ['NavigationId']),
              'Video',
              getx.selectedPackageId.value.toString());
          getLocalNavigationDetails();
        }

        // Get.back();
        return true;
      },
      child: Scaffold(

        body: SafeArea(
         
          child: MaterialVideoControlsTheme(
            normal: MaterialVideoControlsThemeData(
              controlsHoverDuration: Duration(seconds: 15),
              primaryButtonBar: [
                MaterialSkipPreviousButton(
                  iconSize: 80,
                ),
                MaterialPlayOrPauseButton(
                  iconSize: 80,
                ),
              ],
              seekBarThumbSize: 20,
              brightnessGesture: true,
              seekBarMargin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
              buttonBarButtonSize: 20,
              seekBarThumbColor: Colors.blue,
              seekBarPositionColor: Colors.blue,
            
              topButtonBar: [
                Obx(
                  () => MaterialCustomButton(
                    onPressed: () {
                      getx.videoplaylock.value = !getx.videoplaylock.value;
                      print(getx.videoplaylock.value);
                    },
                    icon: getx.videoplaylock.value
                        ? Icon(Icons.lock)
                        : Icon(Icons.lock_open),
                  ),
                ),
                const Spacer(),
                MaterialCustomButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shadowColor: ColorPage.white,
                          backgroundColor: ColorPage.white,
                          surfaceTintColor: ColorPage.white,
                          content: Card(
                            child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Typing somthing...',
                                ),
                                maxLines: 5,
                              ),
                            ),
                          ),
                          title: Text(
                            'Write your tag',
                            style: FontFamily.font,
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                'Cancel',
                                style: FontFamily.font3,
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(ColorPage.red),
                                shape: WidgetStatePropertyAll(
                                  ContinuousRectangleBorder(),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                'Save',
                                style: FontFamily.font3,
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(ColorPage.color1),
                                shape: WidgetStatePropertyAll(
                                    ContinuousRectangleBorder()),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit_note),
                ),
                MaterialCustomButton(
                  onPressed: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(10, 20, 0, 10),
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
                                    videoPlay.stopTrackingPlayTime();
                                    insertVideoplayInfo(
                                        int.parse(getx.playingVideoId.value),
                                        videoPlay.player.state.position
                                            .toString(),
                                        videoPlay.totalPlayTime.inSeconds
                                            .toString(),
                                        videoPlay.player.state.rate.toString(),
                                        videoPlay.startclocktime.toString(),
                                        utcTime.millisecondsSinceEpoch,
                                        0);
                                    videoPlay.totalPlayTimeofVideo =
                                        Duration.zero;
                                    // videoPlay.startTrackingPlayTime();

                                    selectedSpeed = value!;

                                    utcTime = DateTime.now();
                                    videoPlay.player.setRate(selectedSpeed);
                                    Navigator.pop(context);

                                    // videoPlay.startTrackingPlayTime();
                                  });
                                  videoPlay.startTrackingPlayTime();

                               
                                },
                              ),
                              Text('${speed}x'),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                  icon: Icon(Icons.slow_motion_video),
                ),
                MaterialCustomButton(
                  onPressed: () {
                    showGotoDialog(context);
                  },
                  icon: Text(
                    'GOTO',
                    style: FontFamily.font3,
                  ),
                ),
              ],
            ),
            fullscreen:
                const MaterialVideoControlsThemeData(seekOnDoubleTap: true),
            child: Container(
              //  color: Colors.red,
              child: Column(
                children: [
                  Container(
                    height: 300,
                    color: Colors.black,
                    child: Center(
                      child: Video(controller: videoPlay.controller),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text("${videoDetails["FileIdName"]}",
                                      style: FontFamily.style
                                          .copyWith(fontSize: 18))),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                    
                          Row(
                            children: [
                              Text("Uploaded on: ",
                                  style: FontFamily.style.copyWith(
                                      fontSize: 13, color: Colors.green)),
                              Text(
                                  "${formatDate(videoDetails["ScheduleOn"].toString())}",
                                  style: FontFamily.style.copyWith(
                                      fontSize: 13,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        child: DefaultTabController(
                          length: 4,
                          child: Expanded(
                            child: MotionTabBar(
                              controller: _motionTabBarController,
                              initialSelectedTab: "PDF",
                              labels: tabfield,
                              icons: const [
                                Icons.picture_as_pdf,
                                Icons.question_answer,
                                Icons.tag,
                                Icons.reviews
                              ],
                              tabSize: 40,
                              tabBarHeight: 45,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              tabIconColor: Colors.blue[600],
                              tabIconSize: 28.0,
                              tabIconSelectedSize: 26.0,
                              tabSelectedColor: Colors.blue[900],
                              tabIconSelectedColor: Colors.white,
                              onTabItemSelected: (int value) {
                                setState(() {
                                  _motionTabBarController!.index = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _motionTabBarController,
                      children: [
                        Pdf(),
                        Mcq(),
                        Tags(),
                        AskDoubt(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  bool x = false;
  @override


  late Directory filelocationpath;
//

  Future permission() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt) >= 33) {
      } else {}
    } else {}
  }

  void showGotoDialog(BuildContext context) {
    TextEditingController hoursController = TextEditingController();
    TextEditingController minutesController = TextEditingController();
    TextEditingController secondsController = TextEditingController();

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
                  child: Column(
                    children: [
                      Text("Hours",
                          style: FontFamily.font9
                              .copyWith(color: ColorPage.colorblack)),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: hoursController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Text("Minutes",
                          style: FontFamily.font9
                              .copyWith(color: ColorPage.colorblack)),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Text("Seconds",
                          style: FontFamily.font9
                              .copyWith(color: ColorPage.colorblack)),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: secondsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
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
            final int hours = int.tryParse(hoursController.text) ?? 0;
            final int minutes = int.tryParse(minutesController.text) ?? 0;
            final int seconds = int.tryParse(secondsController.text) ?? 0;

            final Duration position = Duration(
              hours: hours,
              minutes: minutes,
              seconds: seconds,
            );

            videoPlay.seekTo(position);
            Get.back();
          },
          color: Colors.blue,
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
  }





}

class Tags extends StatefulWidget {
  const Tags({super.key});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  @override
  void initState() {
    print('${getx.tagListOfVideo.length} shubha');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: getx.tagListOfVideo.length == 0
              ? Center(
                  child: Text("No tag here"),
                )
              : ListView.builder(
                  itemCount: getx.tagListOfVideo.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () {},
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
      ],
    );
  }
}



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
    encryptionKey = getEncryptionKeyFromTblSetting('EncryptionKey');
    print(encryptionKey);
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



  Future<Directory> getDeviceDocumentDirectory() async {
    try {
      // Get the external storage directory
      Directory? externalStorageDir = await getExternalStorageDirectory();
      //  Directory? externalStorageDir = await get();

      if (externalStorageDir != null) {
        // Navigate to the "Documents" folder if it exists, otherwise return the external storage path
        Directory documentsDir =
            Directory('${externalStorageDir.path}/Documents');

        // Ensure the directory exists
        if (await documentsDir.exists()) {
          return documentsDir;
        } else {
          // Optionally create the Documents directory if it does not exist
          await documentsDir.create(recursive: true);
          return documentsDir;
        }
      } else {
        print("External storage is not accessible.");
      }
    } catch (e) {
      print("Error accessing device document directory: $e");
    }

    return getApplicationDocumentsDirectory(); // Return null if directory is not accessible
  }

  String getDownloadedPathOfPDFfileofVideo(String name, String folderName) {
    // Get the first result

    final downloadedPath = getx.userSelectedPathForDownloadFile.isEmpty
        ? getx.defaultPathForDownloadFile.value +
            '/$folderName/' +
            name +
            ".pdf"
        : getx.userSelectedPathForDownloadFile.value +
            '/$folderName/' +
            name +
            ".pdf";

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

        Directory appDocDir = await getDeviceDocumentDirectory();

        // Create the folder structure: com.si.dthLive/notes
        Directory dthLmsDir = Directory('${appDocDir.path}/$origin');
        if (!await dthLmsDir.exists()) {
          await dthLmsDir.create(recursive: true);
        }
        var prefs = await SharedPreferences.getInstance();
        getx.defaultPathForDownloadFile.value = dthLmsDir.path;
        prefs.setString("DefaultDownloadpathOfFile", dthLmsDir.path);

        // Correct file path to save the PDF
        String filePath = getx.userSelectedPathForDownloadFile.isEmpty
            ? '${dthLmsDir.path}/notes/$title.pdf'
            : getx.userSelectedPathForDownloadFile.value +
                "/notes/$title.pdf"; // Make sure to add .pdf extension if needed

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
    print("this is key of ncryption: $key");
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

//  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    const Color borderColor = Colors.grey;
    const double borderRadiusValue = 5.0;
    const EdgeInsetsGeometry tabMargin = EdgeInsets.symmetric(vertical: 5.0);
    const EdgeInsetsGeometry tabPadding = EdgeInsets.symmetric(horizontal: 8.0);
    const double tabHeight = 25.0;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Stack(children: [
        Column(
          children: [
            // TabBar
            Obx(() => TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabAlignment: TabAlignment.start,
                  tabs: getx.pdfListOfVideo.map((pdf) {
                    // Safely retrieve the name, providing a default if null
                    final String tabName =
                        pdf['Names']?.toString() ?? 'Untitled';

                    return Container(
                      margin: tabMargin,
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                      ),
                      child: Padding(
                        padding: tabPadding,
                        child: Tab(
                          height: tabHeight,
                          text: tabName,
                        ),
                      ),
                    );
                  }).toList(),
                )),
            SizedBox(
              height: 10,
            ),
            // PDF Viewer
            Expanded(
              child: Obx(() {
                if (getx.pdfListOfVideo.length == 0) {
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
        Positioned(
            bottom: 30,
            right: 10,
            // right: 0,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => showFullscreenPdf(),
                );
              },
              icon: Icon(
                Icons.fullscreen,
                color: Colors.white,
              ),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(ColorPage.blue)),
            ))
      ]),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget showFullscreenPdf() {
    final currentPdf = getx.pdfListOfVideo[_tabController.index];
    if (currentPdf['Encrypted'].toString() == "true") {
      return Dialog.fullscreen(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: getx.encryptedpdffile.value.isNotEmpty
              ? SfPdfViewer.memory(getx.encryptedpdffile.value)
              : Center(child: CircularProgressIndicator()),
        ),
      );
    } else {
      return Dialog.fullscreen(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: File(getx.unEncryptedPDFfile.value).existsSync()
              ? SfPdfViewer.file(File(getx.unEncryptedPDFfile.value))
              : Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // return ;
  }
}

class FullscreenPdfDialog extends StatelessWidget {
  final bool isEncrypted;
  final Uint8List? encryptedPdfBytes;
  final String? unEncryptedPdfPath;

  const FullscreenPdfDialog({
    Key? key,
    required this.isEncrypted,
    this.encryptedPdfBytes,
    this.unEncryptedPdfPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget pdfViewer;

    if (isEncrypted) {
      if (encryptedPdfBytes != null && encryptedPdfBytes!.isNotEmpty) {
        pdfViewer = SfPdfViewer.memory(encryptedPdfBytes!);
      } else {
        pdfViewer = Center(child: CircularProgressIndicator());
      }
    } else {
      if (unEncryptedPdfPath != null &&
          File(unEncryptedPdfPath!).existsSync()) {
        pdfViewer = SfPdfViewer.file(File(unEncryptedPdfPath!));
      } else {
        pdfViewer = Center(child: CircularProgressIndicator());
      }
    }

    return Dialog(
      insetPadding: EdgeInsets.zero, // Remove default padding
      backgroundColor: Colors.transparent, // Make background transparent
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.white,
            tooltip: 'Close',
          ),
        ),
        body: pdfViewer,
      ),
    );
  }
}

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
    return mcqData.length == 0
        ? Center(
            child: Text("No MCQ Found"),
          )
        : Container(
            height: 800,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                    int questionId =
                                        int.parse(mcqData[index].mcqId);

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
                                    bool isAnswered =
                                        userAns.containsKey(questionId);

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
                                        tileColor =
                                            Colors.white; // default color
                                      }
                                    } else {
                                      tileColor = Colors.white; // default color
                                    }

                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 600),
                                        curve: Curves.easeInOut,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: tileColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            onTap: () {
                                              setState(() {
                                                if (!isSubmitted.value) {
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
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MaterialButton(
                                    height: 40,
                                    color: Colors.blue,
                                    padding: EdgeInsets.all(16),
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                                      index == mcqData.length - 1
                                          ? 'Reset'
                                          : 'Next',
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



class FeedbackController extends GetxController {
  RxInt currentQuestionIndex = 0.obs;
  RxList<String?> selectedAnswers = <String?>[].obs;
  TextEditingController feedbackController = TextEditingController();

  // Initialize selectedAnswers based on the number of questions.
  void initializeAnswers(int questionCount) {
    selectedAnswers.value = List.generate(questionCount, (index) => null);
     currentQuestionIndex.value = 0;
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < selectedAnswers.length ) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  void updateAnswer(String? answer) {
    selectedAnswers[currentQuestionIndex.value] = answer;
  }

  void submitFeedback() {
    String feedback = feedbackController.text;
    print("Feedback: $feedback");
    feedbackController.text="";
    print("Selected Answers: ${selectedAnswers.join(', ')}");
    Get.back(); // Close the dialog after submission
  }
}


class QuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final FeedbackController controller;

  QuestionWidget({required this.question, required this.controller});

  @override
  Widget build(BuildContext context) {
    List<String> options = List<String>.from(question["options"]);
    return Obx(()=>
       Column(
        children: [
          Text(
            question["question"],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ...options.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: controller.selectedAnswers[controller.currentQuestionIndex.value],
              onChanged: (value) {
                controller.updateAnswer(value);
                print("Selected Answer: $value");
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}


class PersonalFeedbackWidget extends StatelessWidget {
  final FeedbackController controller;

  PersonalFeedbackWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Text(
          "Write your feedback...",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controller.feedbackController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "Your comments...",
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
      ],
    );
  }
}

void showFeedbackDialog(BuildContext context, List<Map<String, dynamic>> questions) {
  final feedbackController = Get.put(FeedbackController());


 
  feedbackController.initializeAnswers(questions.length);

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
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
    title: "Feedback",
    content: Obx(() {
      int currentIndex = feedbackController.currentQuestionIndex.value;

      // Show the question widget or feedback form based on current index
      if (currentIndex < questions.length) {
        return QuestionWidget(
          question: questions[currentIndex],
          controller: feedbackController,
        );
      } else {
        return PersonalFeedbackWidget(controller: feedbackController);
      }
    }),
    buttons: [
      DialogButton(
        child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 15)),
        onPressed: () {
          Get.back(); // Close the dialog
        },
        color: Colors.red,
        radius: BorderRadius.circular(5.0),
      ),
      // Show Next button if there are more questions
     
        DialogButton(
          child: Obx(()=> Text(feedbackController.currentQuestionIndex.value < questions.length ?"Next":"Submit", style: TextStyle(color: Colors.white, fontSize: 15))),
          onPressed: () {
           feedbackController.currentQuestionIndex.value < questions.length? feedbackController.nextQuestion(): feedbackController.submitFeedback();
          },
          color: Colors.blue,
          radius: BorderRadius.circular(5.0),
        )
    
    ],
  ).show();
}
