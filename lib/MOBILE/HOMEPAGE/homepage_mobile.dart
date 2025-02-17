import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/Live/details.dart';
import 'package:dthlms/Live/mobile_vcScreen.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/backup_videos_page.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/bannerInfoPage.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/chat/chat_page.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/fab_visibility.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/forumn_page.dart';
import 'package:dthlms/MOBILE/LOGIN/loginpage_mobile.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/package_List.dart';
import 'package:dthlms/MOBILE/PROFILE/account.dart';
import 'package:dthlms/MOBILE/VIDEO/mobilevideoplay.dart';
import 'package:dthlms/MODEL_CLASS/Meettingdetails.dart';
import 'package:dthlms/PC/PROFILE/userProfilePage.dart';
import 'package:dthlms/PC/VIDEO/scrollbarhide.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:dthlms/notifications_screen.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_infinite_marquee/flutter_infinite_marquee.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:dthlms/MOBILE/store/list/ListviewPackage.dart';
import 'package:dthlms/PC/HOMEPAGE/homepage.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../store/storemodelclass/storemodelclass.dart';
import 'package:package_info_plus/package_info_plus.dart' as pinfo;

ScrollController _scrollController = ScrollController();

class DashBoardMobile extends StatefulWidget {
  DashBoardMobile({
    super.key,
  });

  @override
  State<DashBoardMobile> createState() => _DashBoardMobileState();
}

class _DashBoardMobileState extends State<DashBoardMobile> {
  TextEditingController activationfield = TextEditingController();
  FabVisibility _fabVisibility = Get.put(FabVisibility());

  int selectedIndex = -1;

  enterActivationKey(context, String token) {
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: true,
        alertPadding: const EdgeInsets.only(top: 300),
        descStyle: const TextStyle(fontWeight: FontWeight.bold),
        animationDuration: const Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle:
            const TextStyle(color: ColorPage.blue, fontWeight: FontWeight.bold),
        constraints: const BoxConstraints.expand(width: 600),
        //First to chars "55" represents transparency of color
        overlayColor: const Color(0x55000000),
        alertElevation: 0,
        alertAlignment: Alignment.center);

    // Alert dialog using custom alert style
    Alert(
      context: context,
      style: alertStyle,
      // type: AlertType.info,
      title: "ACTIVATION CODE",
      content: Form(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 13),
                child: Text(
                  'Please fill field *',
                  style: TextStyle(color: ColorPage.red, fontSize: 12),
                ),
              ),
            ],
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextFormField(
                controller: activationfield,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'cannot blank';
                  }
                  return null;
                },
                obscureText: getx.passvisibility.value,
                obscuringCharacter: '*',
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Enter Activation Code',
                    // hintText: 'Enter Activation Code',

                    filled: true,
                    focusColor: ColorPage.white),
              ),
            ),
          ),
        ],
      )),
      buttons: [
        DialogButton(
          width: MediaQuery.of(context).size.width / 1.3,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () {
            Get.back();
            packactivationKey(context, activationfield.text, token);
          },
          color: ColorPage.colorgrey,
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
  }

  _showDeveloperDialog(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.info,
      style: const AlertStyle(
        isOverlayTapDismiss: false,
        animationType: AnimationType.fromTop,
        titleStyle: TextStyle(
          color: Colors.red, // Set your custom color for the title
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(fontSize: 16), // Customize description text style
        isCloseButton: false, // Disable close button
      ),
      title: "Developer Mode Detected",
      desc:
          "Developer mode is on in your device! Please turn it off and try again!",
      buttons: [
        DialogButton(
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            exit(0); // Close the dialog
          },
          color: const Color.fromRGBO(9, 89, 158, 1), // Set button color
          highlightColor:
              const Color.fromRGBO(3, 77, 59, 1), // Set highlight color
        ),
      ],
    ).show();
  }

  late BuildContext globalContext;
  Getx getx = Get.put(Getx());

  Map<String, dynamic> lastVideoDetails = {};
  Map<String, dynamic> lastVideoDetailsAllPackage = {};

  String formattedDate = "";
  String franchaiseName = "";

  @override
  void initState() {
    getHomePageBannerImage(context, getx.loginuserdata[0].token);
    if (getx.isAndroidDeveloperModeEnabled.value) {
      // _showDeveloperDialog(context);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getx.isInternet.value) {
        updatePackage(globalContext, getx.loginuserdata[0].token, true, "");
      }
      isTokenValid(getx.loginuserdata[0].token);

      readPackageDetailsdata();
      getLastVideo();
    });
    franchaiseName = getFranchiseNameFromTblSetting();

    dio = Dio();
    controlScroller();
    // getIconData(context, getx.loginuserdata[0].token);
    super.initState();
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  getLastVideo() async {
    lastVideoDetails = await getLastRow();
    setState(() {});

    if (lastVideoDetails.isNotEmpty) {
      // Parse the string into DateTime
      DateTime parsedDate = DateTime.parse(
          lastVideoDetails["StartTime"]); // Convert the string to DateTime

      lastVideoDetailsAllPackage = await getAllPackageDetailsForLastRow(
        lastVideoDetails['VideoId'],
      );
      // Define the desired date format
      formattedDate = DateFormat('d MMM yyyy h:mm a').format(parsedDate);

      // Print formatted date
      print(formattedDate); // Output: 2 Dec 2024 4:18 PM
    }
    // print("${lastVideoDetails} shubha video last played info");
    // print(
    // "${lastVideoDetailsAllPackage} shubha video last played info all package details");
  }

  bool isTokenValid(String jwtToken) {
    try {
      // Decode and get the expiration time from the token
      final parts = jwtToken.split('.');
      if (parts.length != 3) {
        throw const FormatException('Invalid JWT token format');
      }

      final payload = base64Url.decode(base64Url.normalize(parts[1]));
      final payloadMap =
          json.decode(utf8.decode(payload)) as Map<String, dynamic>;

      final exp = payloadMap['exp'] as int?;
      if (exp == null) {
        throw Exception('Expiration time (exp) not found in the token');
      }
      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

      // Get the current date and time
      final now = DateTime.now();
      bool isvalid = now.isBefore(expirationDate);
      if (!isvalid) {
        onTokenExpire(context);
      }
      if (isvalid) {}

      // Compare current time with expiration time
      return isvalid;
    } catch (e) {
      writeToFile(e, "isTokenValid");
      // Handle errors (invalid token, missing exp, etc.)
      print('Error: ${e.toString()}');
      return false;
    }
  }

  String videoIndex = '';

  // Future getLastPlayedVideo() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString('videoindex') != null) {
  //     videoIndex = prefs.getString('videoindex')!;
  //     return 0;
  //   } else {
  //     print('Last played video not found');
  //     return 1;
  //   }
  // }

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

  Future<void> startDownload(String Link, String title) async {
    if (Link == "0") {
      print("ZVideo link is $Link");
      return;
    }
    final appDocDir;
    try {
      var prefs = await SharedPreferences.getInstance();
      // if (Platform.isAndroid) {
      final path = await getApplicationDocumentsDirectory();
      appDocDir = path.path;
      // }
      getx.defaultPathForDownloadVideo.value =
          appDocDir + '/$origin' + '/Downloaded_videos';
      prefs.setString("DefaultDownloadpathOfVieo",
          appDocDir + '/$origin' + '/Downloaded_videos');
      print(getx.userSelectedPathForDownloadVideo.value +
          "it is user selected path");

      String savePath = getx.userSelectedPathForDownloadVideo.isEmpty
          ? appDocDir + '/$origin' + '/Downloaded_videos' + '/$title'
          : getx.userSelectedPathForDownloadVideo.value + '/$title';

      String tempPath = appDocDir + '/temp' + '/$title';

      await Directory(appDocDir + '/temp').create(recursive: true);

      await dio.download(
        Link,
        tempPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total * 100);
            setState(() {
              downloadProgress = progress;
            });
          }
        },
      );

      // After download is complete, copy the file to the final location
      final tempFile = File(tempPath);
      final finalFile = File(savePath);

      // Ensure the final directory exists
      await finalFile.parent.create(recursive: true);

      // Copy the file to the final path
      await tempFile.copy(savePath);

      // Delete the temporary file
      await tempFile.delete();

      setState(() async {
        _videoFilePath = savePath;
        // getx.playingVideoId.value = lastVideoDetailsAllPackage["FileId"];
        // videoPlay.updateVideoLink(savePath);
        // if (await isProcessRunning("dthlmspro_video_player") == false) {
        //   run_Video_Player_exe(
        //       savePath,
        //       getx.token.value,
        //       getx.playingVideoId.value,
        //       getx.selectedPackageId.value.toString());
        // }
      });

      print('$savePath video saved to this location shubha');

      // Insert the downloaded file data into the database
      await insertDownloadedFileData(lastVideoDetailsAllPackage["PackageId"],
          lastVideoDetailsAllPackage["FileId"], savePath, 'Video', title);

      insertVideoDownloadPath(
        lastVideoDetailsAllPackage["FileId"],
        lastVideoDetailsAllPackage["PackageId"],
        savePath,
        context,
      );
    } catch (e) {
      writeToFile(e, "startDownload");
      print(e.toString() + " error on download");
    }
  }

  late final Dio dio;
  double downloadProgress = 0.0;

  int lastTapVideoIndex = -1; // Track the last tapped item index
  DateTime lastTapvideoTime = DateTime.now();
  var color = const Color.fromARGB(255, 102, 112, 133);
  // Getx getx = Get.put(Getx());

  int flag = 2;
  int selectedVideoIndex = -1;
  int selectedvideoListIndex = -1;

  @override
  void handleTap(int index) {
    DateTime now = DateTime.now();
    if (index == lastTapVideoIndex &&
        now.difference(lastTapvideoTime) < const Duration(seconds: 1)) {
      print('Double tapped on folder: $index');
    }
    lastTapVideoIndex = index;
    lastTapvideoTime = now;
  } // Track the selected list tile

  String? _videoFilePath;

  bool isDownloading = false;

  void controlScroller() {
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        // If scrolled to the top, set visibility to true
        _fabVisibility.visibility.value = false;
      } else if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // If scrolled to the bottom, set visibility to false
        _fabVisibility.visibility.value = true;
      } else {
        // Hide when scrolling in either direction
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          _fabVisibility.visibility.value = false;
        } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          _fabVisibility.visibility.value = true;
        }
      }
    });
  }

  final List<String> _itemsDefault = [
    "Welcome to ${getFranchiseNameFromTblSetting()}",
    "Powered by our Creativity"
  ];

  final List<String> _items = ['The Valuation School', 'No Risk No Story'];

  @override
  Widget build(BuildContext context) {
    globalContext = context;

    return Scaffold(
      // extendBodyBehindAppBar: true,

      extendBody: true,
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        // flexibleSpace: ClipRect(
        //   child: BackdropFilter(
        //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        //     child: Container(
        //       color: Colors.transparent,
        //     ),
        //   ),
        // ),
        iconTheme: const IconThemeData(color: Colors.white),
        // backgroundColor: Colors.blue.withAlpha(200),
        backgroundColor: const Color(0xffF5F5DC),
        title: Text(
          franchaiseName != "" ? franchaiseName : 'Dash Board',
          style: GoogleFonts.josefinSans()
              .copyWith(color: const Color.fromARGB(255, 33, 77, 153)),
        ),
        actions: [
          getx.isActivationKeySet.value
              ? IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    enterActivationKey(context, getx.loginuserdata[0].token);
                  })
              : const SizedBox(),
          IconButton(
            onPressed: () {
              Get.to(() => NotificationsPage());
            },
            icon: Obx(
              () => Badge(
                label: Text(getx.notifications.length.toString()),
                child: Icon(
                  Icons.notifications_none_outlined,
                  weight: 5,
                ),
              ),
            ),
          )
        ],
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Image(
                image: AssetImage(
                  logopath,
                ),
                height: 60,
                width: 100,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),

      drawer: HomePageDrawer(
        ontapActivation: () =>
            enterActivationKey(context, getx.loginuserdata[0].token),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: getAllTblImages(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Ensure snapshot.data is a list
                      if (snapshot.data is List) {
                        // Filter the list to include only items where 'ImageType' contains 'banner'
                        List filteredList =
                            (snapshot.data as List).where((item) {
                          if (item is Map && item['ImageType'] != null) {
                            return item['ImageType']
                                .toString()
                                .toLowerCase()
                                .contains('banner');
                          }
                          return false;
                        }).toList();

                        // Use the filtered list for further processing
                        return HeadingBox(
                          mode: 0,
                          imageUrl: filteredList,
                        );
                      } else {
                        // Handle the case where snapshot.data is not a list
                        return const Text("Data is not a list");
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: getAllTblImages(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Extract the titles into a list
                    List<dynamic> data = snapshot.data as List<dynamic>;
                    // List<String> _itemsType = data
                    //     .map((item) => item['ImageType'].toString())
                    //     .toList();
                    List<String> _items = data
                        .map((item) => item['ImageText'].toString())
                        .toList();
                    if (_items.isNotEmpty) {
                      return SizedBox(
                        height: 50,
                        child: InfiniteMarquee(
                          itemBuilder: (BuildContext context, int index) {
                            // Access   from the list
                            String item = _items[index % _items.length];
                            return GestureDetector(
                              onTap: () {
                                // Handle item tap if needed
                                // _showToast(item);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                color: Colors
                                    .primaries[index % Colors.primaries.length],
                                child: Center(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 50,
                        child: InfiniteMarquee(
                          itemBuilder: (BuildContext context, int index) {
                            // Access items from the list
                            String item =
                                _itemsDefault[index % _itemsDefault.length];
                            return GestureDetector(
                              onTap: () {
                                // Handle item tap if needed
                                // _showToast(item);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                color: Colors
                                    .primaries[index % Colors.primaries.length],
                                child: Center(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  } else {
                    return SizedBox(
                      height: 50,
                      child: InfiniteMarquee(
                        itemBuilder: (BuildContext context, int index) {
                          // Access items from the list
                          String item =
                              _itemsDefault[index % _itemsDefault.length];
                          return GestureDetector(
                            onTap: () {
                              // Handle item tap if needed
                              // _showToast(item);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors
                                  .primaries[index % Colors.primaries.length],
                              child: Center(
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),

                    lastVideoDetails.isNotEmpty &&
                            lastVideoDetailsAllPackage.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text('Start where you left',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey)),
                                  ],
                                ),
                                Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  child: ListTile(
                                      splashColor: Colors.cyan[100],
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      onTap: () {
                                        getx.playingVideoId.value =
                                            lastVideoDetailsAllPackage['FileId']
                                                .toString();

                                        getx.playLink.value = getx
                                                .userSelectedPathForDownloadVideo
                                                .isEmpty
                                            ? getx.defaultPathForDownloadVideo
                                                    .value +
                                                '/' +
                                                lastVideoDetailsAllPackage[
                                                    'FileIdName']
                                            : getx.userSelectedPathForDownloadVideo
                                                    .value +
                                                '/' +
                                                lastVideoDetailsAllPackage[
                                                    'FileIdName'];
                                        if (File(getx
                                                    .userSelectedPathForDownloadVideo
                                                    .isEmpty
                                                ? getx.defaultPathForDownloadVideo
                                                        .value +
                                                    '/' +
                                                    lastVideoDetailsAllPackage[
                                                        'FileIdName']
                                                : getx.userSelectedPathForDownloadVideo
                                                        .value +
                                                    '/' +
                                                    lastVideoDetailsAllPackage[
                                                        'FileIdName'])
                                            .existsSync()) {
                                          Get.to(() => MobileVideoPlayer(
                                            isPlayOnline: false,
                                                videoList: [],
                                                videoLink: getx.playLink.value,
                                                Videoindex: 0,
                                                packageId:
                                                    lastVideoDetailsAllPackage[
                                                        'PackageId'],
                                                fileId:
                                                    lastVideoDetailsAllPackage[
                                                        'FileId'],
                                              ));
                                        } else {
                                          print("File dose not exist");
                                        }
                                      },
                                      leading: Icon(
                                        Icons.video_library,
                                        color: ColorPage.recordedVideo,
                                      ),
                                      title: Text(
                                        lastVideoDetailsAllPackage['FileIdName']
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.blue),
                                      ),
                                      subtitle: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            const TextSpan(
                                                text: "Last played: ",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 12)),
                                            TextSpan(
                                                text: formattedDate.toString(),
                                                style: const TextStyle(
                                                    color: Colors.amber,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      trailing: downloadProgress == 0 &&
                                              File(getx.userSelectedPathForDownloadVideo
                                                              .isEmpty
                                                          ? getx.defaultPathForDownloadVideo
                                                                  .value +
                                                              '/' +
                                                              lastVideoDetailsAllPackage[
                                                                  'FileIdName']
                                                          : getx.userSelectedPathForDownloadVideo
                                                                  .value +
                                                              '/' +
                                                              lastVideoDetailsAllPackage[
                                                                  'FileIdName'])
                                                      .existsSync() ==
                                                  false
                                          ? IconButton(
                                              onPressed: () {
                                                startDownload(
                                                    lastVideoDetailsAllPackage[
                                                        'DocumentPath'],
                                                    lastVideoDetailsAllPackage[
                                                        'FileIdName']);
                                              },
                                              icon: const Icon(
                                                Icons.download,
                                                color: ColorPage.grey,
                                              ),
                                            )
                                          : downloadProgress < 100 &&
                                                  downloadProgress > 0
                                              ? CircularPercentIndicator(
                                                  radius: 15.0,
                                                  lineWidth: 4.0,
                                                  percent:
                                                      downloadProgress / 100,
                                                  center: Text(
                                                    "${downloadProgress.toInt()}%",
                                                    style: const TextStyle(
                                                        fontSize: 10.0),
                                                  ),
                                                  progressColor:
                                                      ColorPage.colorbutton,
                                                )
                                              : null),
                                ).animate().fade(),
                              ],
                            ),
                          )
                        : const SizedBox(),

                    const SizedBox(
                      height: 8,
                    ),
                    // Text('data')
                    const CalendarWidget(),
                    // NewsNotifications()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  RxBool _showTooltip = false.obs;
  Timer? _tooltipTimer;
  Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());
  RxList<Appointment> _selectedAppointments = <Appointment>[].obs;
  RxList<Appointment> appointments = <Appointment>[].obs;

  @override
  void initState() {
    super.initState();
    // _selectedDate = DateTime.now();
    loadAppointments().then(
      (value) {
        _updateSelectedAppointments();
      },
    );
    dio = Dio();
  }
// Observable to track the list of appointments

  // Observable to track the loading state
  var isLoading = true.obs;
  // Function to load appointments
  Future<void> loadAppointments() async {
    try {
      isLoading.value = true; // Set loading to true when fetching data

      // Simulate a delay to load data
      await Future.delayed(const Duration(seconds: 2));

      if (getx.calenderEvents.isNotEmpty) {
        appointments.clear(); // Clear the previous appointments

        for (var item in getx.calenderEvents) {
          final Appointment newAppointment = Appointment(
            resourceIds: [
              {
                "PackageId": item['PackageId'],
                "PackageName": item['PackageName'],
                "FileIdType": item['FileIdType'],
                "FileId": item['FileId'],
                "FileIdName": item['FileIdName'],
                "ChapterId": item['ChapterId'],
                "VideoDuration": item['VideoDuration'],
                "AllowDuration": item['AllowDuration'],
                "ConsumeDuration": item['ConsumeDuration'],
                "ConsumeNos": item['ConsumeNos'],
                "ScheduledOn": item['ScheduledOn'],
                "DocumentPath": item['DocumentPath'],
                "DownloadedPath": item['DownloadedPath'],
                "SessionId": item['SessionId'],
                'DisplayName':item['DisplayName']
              }
            ],
            startTime: DateTime.parse(item['ScheduleOn']),
            endTime: DateTime.parse(item['ScheduleOn']),
            color: item['FileIdType'] == 'Video'
                ? ColorPage.recordedVideo
                : item['FileIdType'] == 'Live'
                    ? ColorPage.recordedVideo
                    : item['FileIdType'] == 'Test'
                        ? ColorPage.testSeries
                        : ColorPage.history,
            subject: item['FileIdName'],
            notes: item['FileIdName'],
            location: item['FileIdType'],
          );

          appointments.add(newAppointment); // Add the new appointment
        }
      }
    } catch (e) {
      writeToFile(e, "loadAppointments");
      print("Error loading appointments: $e");
    } finally {
      isLoading.value = false; // Set loading to false after loading is done
    }
  }

  // Function to update selected appointments
  void _updateSelectedAppointments() {
    _selectedAppointments.value = appointments.where((appointment) {
      return appointment.startTime.year == _selectedDate.value!.year &&
          appointment.startTime.month == _selectedDate.value!.month &&
          appointment.startTime.day == _selectedDate.value!.day;
    }).toList();
  }

  // Function to toggle the tooltip
  void _toggleTooltip() {
    _showTooltip.value = !_showTooltip.value;

    if (_showTooltip.value) {
      _tooltipTimer?.cancel(); // Cancel any existing timer
      _tooltipTimer = Timer(const Duration(seconds: 5), () {
        _showTooltip.value = false;
      });
    }
  }

  late final Dio dio;
  // String? _videoFilePath;
  RxList<double> downloadProgressList = List<double>.filled(20, 0.0).obs;

  @override
  void dispose() {
    _tooltipTimer
        ?.cancel(); // Ensure the timer is canceled when the widget is disposed
    super.dispose();
  }

  // Function to handle selection change on the calendar

  // Function to get background color based on date
  Color getCellBackgroundColor(DateTime date) {
    if (date.day % 2 == 0) {
      return const Color.fromARGB(
          202, 119, 142, 182); // Even date background color
    } else {
      return const Color.fromARGB(
          0, 255, 255, 255); // Odd date background color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        // Show loading indicator while waiting for the data to load
        return buildCalendar(context);
      }

      // Once the data is loaded, display the calendar
      return buildCalendar(context);
    });
  }

  // Function to build the calendar view
  Widget buildCalendar(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isSmallScreen = screenWidth < 600;

    return Container(
      height: !_selectedAppointments.isEmpty
          ? screenHeight + 200
          : screenHeight - 400,
      margin: const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Obx(
        () => Column(
          children: [
            Expanded(
              flex: isSmallScreen ? 60 : 70,
              child: Stack(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: SfCalendar(
                      headerHeight: isSmallScreen ? 40 : 40,
                      showCurrentTimeIndicator: true,
                      viewHeaderHeight: isSmallScreen ? 30 : 50,
                      viewHeaderStyle: ViewHeaderStyle(
                        dayTextStyle: TextStyle(
                            fontFamily: 'AltoneRegular',
                            fontSize: isSmallScreen ? 14 : 18),
                      ),
                      headerStyle: CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                            fontFamily: 'AltoneBold',
                            fontSize: isSmallScreen ? 16 : 20,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.blueGrey[400]),
                      view: CalendarView.month,
                      monthCellBuilder:
                          (BuildContext context, MonthCellDetails details) {
                        final DateTime date = details.date;
                        final bool isEvenDate = date.day % 2 == 0;
                        final bool isSelectedDate =
                            _selectedDate.value != null &&
                                date.year == _selectedDate.value!.year &&
                                date.month == _selectedDate.value!.month &&
                                date.day == _selectedDate.value!.day;
                        final bool hasEvent = appointments.any((appointment) =>
                            appointment.startTime.year == date.year &&
                            appointment.startTime.month == date.month &&
                            appointment.startTime.day == date.day);

                        List<Appointment> dateAppointments = appointments
                            .where((appointment) =>
                                appointment.startTime.year == date.year &&
                                appointment.startTime.month == date.month &&
                                appointment.startTime.day == date.day)
                            .toList();

                        Set<String> eventType = {};
                        if (dateAppointments.isNotEmpty) {
                          for (var appointment in dateAppointments) {
                            eventType.add(appointment.location!);
                          }
                        }

                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: hasEvent
                                      ? const Color.fromARGB(255, 184, 215, 241)
                                      : isSelectedDate
                                          ? const Color.fromARGB(255, 219, 196,
                                              248) // Highlight color for the selected date
                                          : const Color.fromARGB(
                                              255, 255, 255, 255),
                                  border: isSelectedDate
                                      ? Border.all(
                                          color: const Color.fromARGB(
                                              255,
                                              3,
                                              29,
                                              100), // Border color for the selected date
                                          width: 2,
                                        )
                                      : Border.all(
                                          color: const Color.fromARGB(
                                              255, 231, 230, 230))),
                              child: Center(
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 18,
                                    color: Colors.black,
                                    fontWeight: isSelectedDate
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            if (eventType.isNotEmpty)
                              Positioned(
                                bottom: 5,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: eventType.map((location) {
                                    double iconSize = isSmallScreen ? 8 : 15;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: location == "Video"
                                          ? Icon(
                                              Icons.circle,
                                              color: ColorPage.recordedVideo,
                                              size: iconSize,
                                            )
                                          : location == "Live"
                                              ? Icon(Icons.circle,
                                                  color: ColorPage.live,
                                                  size: iconSize)
                                              : location == "YouTube"
                                                  ? Icon(Icons.circle,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 163, 152, 4),
                                                      size: iconSize)
                                                  // : location == "Test"
                                                  //     ? Icon(Icons.circle,
                                                  //         color: ColorPage
                                                  //             .testSeries,
                                                  //         size: iconSize)
                                                  : Icon(Icons.circle,
                                                      color: ColorPage.history,
                                                      size: iconSize),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        );
                      },
                      monthViewSettings: const MonthViewSettings(
                        dayFormat: 'EEE',
                        monthCellStyle: MonthCellStyle(
                            todayBackgroundColor:
                                Color.fromARGB(255, 148, 147, 147)),
                        agendaViewHeight: 60,
                        showTrailingAndLeadingDates: false,
                        showAgenda: false,
                      ),
                      onSelectionChanged: (details) {
                        _selectedDate.value = details.date;

                        _updateSelectedAppointments();
                        !_selectedAppointments.isEmpty
                            ? Future.delayed(const Duration(milliseconds: 300),
                                () {
                                _scrollController.animateTo(
                                  screenHeight /
                                      2.6, // Scroll to the event section
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              })
                            : null;
                      },
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.info_outline,
                          color: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: _toggleTooltip,
                    ),
                  ),
                  _showTooltip.value
                      ? Positioned(
                          top: 55,
                          right: 10,
                          child: TooltipWidgetMobile(),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            !_selectedAppointments.isEmpty
                ? Expanded(
                    flex: isSmallScreen
                        ? 100
                        : 40, // Adjust proportion based on screen size
                    child: Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 50),
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: _buildEventDetails(),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }

  Color whichColor(event) {
    switch (event) {
      case "Live":
        return ColorPage.live;
      case "Video":
        return ColorPage.recordedVideo;

      case "Test":
        return ColorPage.testSeries;
      case "History":
        return ColorPage.history;
      case "YouTube":
        return ColorPage.youtube;
      default:
        return Colors.red;
    }
  }

  Widget _buildEventDetails() {
    return Obx(() {
      if (_selectedAppointments.isEmpty) {
        return const Center(
          child: Text(
            'No events for this day.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      }

      return Scrollbar(
          thumbVisibility: true,
          interactive: true,
          thickness: 0.0,
          radius: const Radius.circular(10),
          child: ListView.builder(
            // physics: NeverScrollableScrollPhysics(),
            itemCount: _selectedAppointments.length,
            itemBuilder: (context, index) {
              Appointment appointment = _selectedAppointments[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  elevation: 10.0,
                  shadowColor: whichColor(appointment.location).withAlpha(100),
                  child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            BorderSide(color: whichColor(appointment.location)),
                      ),
                      hoverColor: const Color.fromARGB(255, 241, 241, 241),
                      tileColor: Colors.white,
                      onTap: () async {
                        if (appointment.location == "Live" ||
                            appointment.location == "YouTube") {
                          //  print( "${appointment.startTime
                          //                     } shubha appointment.startTime" );
                          // getMeetingList(context).whenComplete(() {
                          //   try {
                          //     var meeting = findLiveDtails(
                          //         (appointment.resourceIds![0]
                          //                 as Map<String, dynamic>)['SessionId']
                          //             .toString(),
                          //         getx.todaymeeting);
                          //     print(meeting!.topicName.toString() + "meeting");
                          //     if (meeting != null) {
                          //       runLiveExe(meeting);
                          //       print(meeting.topicName);
                          //     }
                          //   } catch (e) {
                          //     print(e.toString());
                          //   }
                          // });
                          DateTime(
                            appointment.startTime.year,
                            appointment.startTime.month,
                            appointment.startTime.day,
                          ).isBefore(DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ))
                              ? await ArtSweetAlert.show(
                                  barrierDismissible: false,
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                    showCancelBtn: false,
                                    title: "Live Expired",
                                    text:
                                        "The live session has expired. Please check back later.",
                                    type: ArtSweetAlertType.warning,
                                  ),
                                )
                              : null;
                        }

                        if (appointment.location == "Video") {
                          try {
                            print(fetchDownloadPathOfVideo(
                                (appointment.resourceIds![0]
                                        as Map<String, dynamic>)['FileId']
                                    .toString(),
                                (appointment.resourceIds![0] as Map<String,
                                            dynamic>)['PackageId']
                                        .toString() +
                                    "did"));

                            getx.playLink.value = getx
                                    .userSelectedPathForDownloadVideo.isEmpty
                                ? getx.defaultPathForDownloadVideo.value +
                                    '/' +
                                    (appointment.resourceIds![0] as Map<String,
                                            dynamic>)['FileIdName']
                                        .toString()
                                : getx.userSelectedPathForDownloadVideo.value +
                                    '/' +
                                    (appointment.resourceIds![0] as Map<String,
                                            dynamic>)['FileIdName']
                                        .toString();
                            if (File(getx.userSelectedPathForDownloadVideo
                                        .isEmpty
                                    ? getx.defaultPathForDownloadVideo.value +
                                        '/' +
                                        (appointment.resourceIds![0] as Map<
                                                String, dynamic>)['FileIdName']
                                            .toString()
                                    : getx.userSelectedPathForDownloadVideo
                                            .value +
                                        '/' +
                                        (appointment.resourceIds![0] as Map<
                                                String, dynamic>)['FileIdName']
                                            .toString())
                                .existsSync()) {
                              getx.playingVideoId.value =
                                  (appointment.resourceIds![0]
                                          as Map<String, dynamic>)['FileId']
                                      .toString();

                              Get.to(() => MobileVideoPlayer(
                                isPlayOnline: false,
                                    videoList: [],
                                    videoLink: getx.playLink.value,
                                    Videoindex: 0,
                                    packageId: (appointment.resourceIds![0]
                                                as Map<String, dynamic>)[
                                            'PackageId']
                                        .toString(),
                                    fileId: (appointment.resourceIds![0]
                                            as Map<String, dynamic>)['FileId']
                                        .toString(),
                                  ));

                              // if (await isProcessRunning(
                              //         "dthlmspro_video_player") ==
                              //     false) {
                              //   run_Video_Player_exe(
                              //       getx.playLink.value,
                              //       getx.loginuserdata[0].token,
                              //       getx.playingVideoId.value,
                              //       (appointment.resourceIds![0] as Map<String,
                              //               dynamic>)['PackageId']
                              //           .toString());
                              // }
                            } else {
                              if (getx.isInternet.value) {
                                _onDownloadVideo(
                                    context,
                                    (appointment.resourceIds![0] as Map<String,
                                            dynamic>)['DocumentPath']
                                        .toString(),
                                    (appointment.resourceIds![0] as Map<String,
                                            dynamic>)['FileIdName']
                                        .toString(),
                                    (appointment.resourceIds![0] as Map<String,
                                            dynamic>)['PackageId']
                                        .toString(),
                                    (appointment.resourceIds![0]
                                            as Map<String, dynamic>)['FileId']
                                        .toString(),
                                    index);
                              } else {
                                onNoInternetConnection(context, () {
                                  Get.back();
                                });
                              }
                            }

                            // run_Video_Player_exe(
                            //     fetchDownloadPathOfVideo(
                            //         (appointment.resourceIds![0]
                            //                 as Map<String, dynamic>)['FileId']
                            //             .toString(),
                            //         (appointment.resourceIds![0]
                            //                 as Map<String, dynamic>)['PackageId']
                            //             .toString()),
                            //     getx.loginuserdata[0].token,
                            //     (appointment.resourceIds![0]
                            //             as Map<String, dynamic>)['FileId']
                            //         .toString(),
                            //     (appointment.resourceIds![0]
                            //             as Map<String, dynamic>)['PackageId']
                            //         .toString());
                          } catch (e) {
                            writeToFile(e, "_buildEventDetails");
                            print(e.toString());
                          }
                        }
                      },
                      leading: whichIcon(appointment.location),
                      trailing: appointment.location == "Live" ||
                              appointment.location == "YouTube"
                          ? TextButton(
                              style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                  backgroundColor:
                                      WidgetStatePropertyAll(DateTime(
                                    appointment.startTime.year,
                                    appointment.startTime.month,
                                    appointment.startTime.day,
                                  ).isBefore(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                  ))
                                          ? Color.fromARGB(255, 255, 106, 95)
                                          : Colors.amberAccent)),
                              onPressed: () async {
                                if (getx.isInternet.value) {
                                  getMeetingList(context).whenComplete(() {
                                    var meeting = findLiveDtails(
                                        (appointment.resourceIds![0] as Map<
                                                String, dynamic>)['SessionId']
                                            .toString(),
                                        getx.todaymeeting);
                                    if (meeting != null &&
                                        !DateTime(
                                          appointment.startTime.year,
                                          appointment.startTime.month,
                                          appointment.startTime.day,
                                        ).isBefore(DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                        ))) {
                                      Get.to(
                                          transition: Transition.cupertino,
                                          () => MobileMeetingPage(
                                                meeting: meeting,
                                                meeting!.projectId.toString(),
                                                meeting.sessionId.toString(),
                                                getx.loginuserdata[0].nameId,
                                                "${getx.loginuserdata[0].firstName} ${getx.loginuserdata[0].lastName}",
                                                meeting.topicName,
                                                meeting.liveUrl,
                                                videoCategory:
                                                    meeting.videoCategory,
                                              ));
                                    } else {
                                      ArtSweetAlert.show(
                                        barrierDismissible: false,
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          showCancelBtn: false,
                                          title: "Live Expired",
                                          text:
                                              "The live session has expired. Please check back later.",
                                          type: ArtSweetAlertType.warning,
                                        ),
                                      );
                                    }
                                  });
                                } else {
                                  onNoInternetConnection(context, () {
                                    Get.back();
                                  });
                                }
                              },
                              child: DateTime(
                                appointment.startTime.year,
                                appointment.startTime.month,
                                appointment.startTime.day,
                              ).isBefore(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                              ))
                                  ? Text(
                                      "Expired",
                                      style: style.copyWith(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    )
                                  : Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ))
                          : null,
                      title: Text( appointment.location == "Video"? (appointment.resourceIds![0] as Map<
                                                  String,
                                                  dynamic>)['DisplayName']
                                              .toString():  appointment.subject,
                          overflow: TextOverflow.ellipsis,
                          style: FontFamily.style.copyWith(
                              color: ColorPage.colorblack,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      subtitle: appointment.location == "Live"
                          ? Text(
                              appointment.startTime != null
                                  ? "" +
                                      DateFormat('d MMM y h:mm a')
                                          .format(appointment.startTime)
                                  : 'Start at: No details available.',
                              style: FontFamily.style.copyWith(
                                fontSize: 12,
                                color: ColorPage.grey,
                              ),
                            )
                          : appointment.location == "Video"
                              ? Text(
                                  "Duration : ${formatDuration(int.parse((appointment.resourceIds![0] as Map<String, dynamic>)['VideoDuration']))}",
                                  style: FontFamily.style.copyWith(
                                      fontSize: 12, color: ColorPage.grey),
                                )
                              : const SizedBox()),
                ),
              );
            },
          ));
    });
  }

  String formatDuration(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  Icon? whichIcon(String? location) {
    double iconSize = 20;

    switch (location) {
      case "Live":
        return Icon(Icons.live_tv, color: ColorPage.live, size: iconSize);
      case "Video":
        return Icon(
          Icons.video_library,
          color: ColorPage.recordedVideo,
          size: iconSize,
        );
      case "Test":
        return Icon(Icons.book, color: ColorPage.testSeries, size: iconSize);
      case "History":
        return Icon(Icons.history, color: ColorPage.history, size: iconSize);
      case "YouTube":
        return Icon(Icons.live_tv, color: ColorPage.youtube, size: iconSize);
      default:
        return Icon(Icons.warning_amber_rounded,
            color: Colors.red, size: iconSize);
    }
  }

  MeetingDeatils? findLiveDtails(
      String sessionId, List<MeetingDeatils> mettingList) {
    MeetingDetails liveDetails;
    print(sessionId);
    for (var item in mettingList) {
      print(mettingList.length);
      print(item.sessionId);
      if (item.sessionId == sessionId) {
        print(item.sessionId.toString() + "item");
        return item;
      }
    }
  }

  Future<String> getVideosDirectoryPath() async {
    final String userHomeDir =
        Platform.environment['USERPROFILE'] ?? 'C:\\Users\\Default';

    final String videosDirPath = p.join(userHomeDir, 'Videos');

    print('Videos Directory Path: $videosDirPath');

    return videosDirPath;
  }

  // Future<void> startDownloadvideoOnCalender(int index, String Link,
  //     String title, String packageId, String fileid) async {
  //   if (Link == "0") {
  //     print("Video link is $Link");
  //     return;
  //   }
  //   final appDocDir;
  //   try {
  //     var prefs = await SharedPreferences.getInstance();
  //     if (Platform.isAndroid) {
  //       final path = await getApplicationDocumentsDirectory();
  //       appDocDir = path.path;
  //     } else {
  //       appDocDir = await getVideosDirectoryPath();
  //     }
  //     getx.defaultPathForDownloadVideo.value =
  //         appDocDir + '/$origin' + '/Downloaded_videos';
  //     prefs.setString("DefaultDownloadpathOfVieo",
  //         appDocDir + '/$origin' + '/Downloaded_videos');
  //     print(getx.userSelectedPathForDownloadVideo.value +
  //         " it is user selected path");

  //     String savePath = getx.userSelectedPathForDownloadVideo.isEmpty
  //         ? appDocDir + '/$origin' + '/Downloaded_videos' + '/$title'
  //         : getx.userSelectedPathForDownloadVideo.value + '\\$title';

  //     String tempPath = appDocDir + '/temp' + '\\$title';

  //     await Directory(appDocDir + '/temp').create(recursive: true);

  //     await dio.download(
  //       Link,
  //       tempPath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           double progress = (received / total * 100);
  //           downloadProgress[index] = progress;
  //           // No need for setState here since downloadProgress is an RxList
  //         }
  //       },
  //     );

  //     // After download is complete, copy the file to the final location
  //     final tempFile = File(tempPath);
  //     final finalFile = File(savePath);

  //     // Ensure the final directory exists
  //     await finalFile.parent.create(recursive: true);

  //     // Copy the file to the final path
  //     await tempFile.copy(savePath);

  //     // Delete the temporary file
  //     await tempFile.delete();

  //     // Update reactive variables directly
  //     getx.playingVideoId.value = fileid;
  //     getx.playLink.value = savePath;

  //     print('$savePath video saved to this location');

  //     // Insert the downloaded file data into the database
  //     await insertDownloadedFileData(
  //         packageId, fileid, savePath, 'Video', title);

  //     insertVideoDownloadPath(
  //       fileid,
  //       packageId,
  //       savePath,
  //       context,
  //     );
  //   } catch (e) {
  //     writeToFile(e, "startDownload2");
  //     print(e.toString() + " error on download");
  //   }
  // }
  CancelToken cancelToken = CancelToken();
  RxDouble downloadProgress = 0.0.obs;

  Future<void> startDownloadvideoOnCalender(int index, String link,
      String title, String packageId, String fileid) async {
    if (link == "0") {
      print("Video link is $link");
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
          appDocDir + '/$origin' + '/Downloaded_videos';
      prefs.setString("DefaultDownloadpathOfVieo",
          appDocDir + '/$origin' + '/Downloaded_videos');
      print(getx.userSelectedPathForDownloadVideo.value +
          " it is user selected path");

      String savePath = getx.userSelectedPathForDownloadVideo.isEmpty
          ? appDocDir + '/$origin' + '/Downloaded_videos' + '/$title'
          : getx.userSelectedPathForDownloadVideo.value + '\\$title';

      String tempPath = appDocDir + '/temp' + '\\$title';

      await Directory(appDocDir + '/temp').create(recursive: true);

      cancelToken = CancelToken();
      downloadProgress.value = 0.0;

      await dio.download(
        link,
        tempPath,
        cancelToken: cancelToken, // Pass the CancelToken here
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total * 100);
            downloadProgress.value = progress;
          }
        },
      );

      // Remove the CancelToken after completion
      // cancelTokens.remove(index);

      // After download is complete, copy the file to the final location
      final tempFile = File(tempPath);
      final finalFile = File(savePath);

      // Ensure the final directory exists
      await finalFile.parent.create(recursive: true);

      // Copy the file to the final path
      await tempFile.copy(savePath);

      // Delete the temporary file
      await tempFile.delete();

      // Update reactive variables directly
      getx.playingVideoId.value = fileid;
      getx.playLink.value = savePath;

      print('$savePath video saved to this location');

      // Insert the downloaded file data into the database
      await insertDownloadedFileData(
          packageId, fileid, savePath, 'Video', title);

      insertVideoDownloadPath(
        fileid,
        packageId,
        savePath,
        context,
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        print("Download canceled!");
      } else {
        writeToFile(e, "startDownload2");
        print(e.toString() + " error on download");
      }
    } catch (e) {
      // Handle any other exceptions that are not DioException
      print(e.toString() + " unexpected error on download");
    }
  }

  void cancelDownload(CancelToken cancelToken) {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel("Download canceled by user.");
      print("Download canceled.");
      setState(() {
        downloadProgress.value = 0.0;
      });
      Get.back();
    } else {
      print("Download was already canceled.");
      setState(() {
        downloadProgress.value = 0.0;
      });
      Get.back();
    }
  }

  _onDownloadVideo(context, String link, String title, String packageId,
      String fileId, int index) {
    RxBool isDownloading = false.obs;
    Alert(
      context: context,
      // type: AlertType.info,
      style: AlertStyle(
        titleStyle: const TextStyle(color: Color.fromARGB(255, 54, 105, 244)),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      image: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Obx(() {
          if (downloadProgress.value < 100 && downloadProgress.value > 0) {
            return CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 12.0,
              percent: downloadProgress.value / 100,
              center: Text(
                "${downloadProgress.value.toInt()}%",
                style: const TextStyle(fontSize: 10.0),
              ),
              progressColor: ColorPage.colorbutton,
            );
          } else if (downloadProgress.value == 100) {
            return Icon(
              Icons.download_done,
              size: 100,
              color: ColorPage.colorbutton,
            );
          } else {
            return Icon(
              Icons.download,
              size: 100,
              color: ColorPage.colorbutton,
            );
          }
        }),
      ),

      title: "Download Video",
      desc:
          "This Video is not Download yet!\n Click Download button & Play it.",
      buttons: [
        DialogButton(
          child: const Text("Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: ColorPage.appbarcolor,
          onPressed: () {
            // Navigator.pop(context);
            cancelDownload(cancelToken);
            // _pickImage();
          },
          color: const Color.fromARGB(255, 243, 33, 33),
        ),
        DialogButton(
          child: Obx(
            () => Text(downloadProgress.value == 100 ? "Play" : "Download",
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
          highlightColor: ColorPage.appbarcolor,
          onPressed: () async {
            if (downloadProgress.value == 100) {
              print("hello");
              Get.back();

              Get.to(() => MobileVideoPlayer(
                isPlayOnline: false,
                    videoList: [],
                    videoLink: getx.playLink.value,
                    Videoindex: 0,
                    packageId: packageId,
                    fileId: fileId,
                  ));

              // if (await isProcessRunning("dthlmspro_video_player") == false) {
              //   run_Video_Player_exe(
              //       getx.playLink.value,
              //       getx.loginuserdata[0].token,
              //       fileId,
              //       packageId);
              // }
            } else {
              startDownloadvideoOnCalender(
                  index, link, title, packageId, fileId);
            }
          },
          color: ColorPage.blue,
        ),
      ],
    ).show();
  }
}

class TooltipWidgetMobile extends StatelessWidget {
  double iconSize = 15;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            const BoxShadow(
              blurRadius: 10,
              color: Colors.black26,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: iconSize,
                  color: ColorPage.live,
                ),
                const SizedBox(width: 8),
                const Text('Live Class'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: iconSize,
                  color: ColorPage.youtube,
                ),
                const SizedBox(width: 8),
                const Text('YouTube Live Class'),
              ],
            ),
            // const SizedBox(height: 8),
            // Row(
            //   children: [
            //     Icon(
            //       Icons.circle,
            //       size: iconSize,
            //       color: ColorPage.testSeries,
            //     ),
            //     const SizedBox(width: 8),
            //     const Text('Test Series'),
            //   ],
            // ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: iconSize,
                  color: ColorPage.recordedVideo,
                ),
                const SizedBox(width: 8),
                const Text('Recorded Video'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.circle,
                  size: iconSize,
                  color: ColorPage.history,
                ),
                const SizedBox(width: 8),
                const Text('History'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewsNotifications extends StatefulWidget {
  const NewsNotifications({super.key});

  @override
  State<NewsNotifications> createState() => _NewsNotificationsState();
}

class _NewsNotificationsState extends State<NewsNotifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height / 1.9,
      // width: double.infinity,
      // margin: EdgeInsets.only(left: 20),
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('News & Notifications',
                  style:
                      FontFamily.style.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                      Icons.newspaper), // or any other icon you prefer
                  title: Text('News Title',
                      style: FontFamily.style.copyWith(fontSize: 18)),
                  subtitle: const Text('News Description'), // optional
                  trailing: IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {}, // handle notification press
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

learningGoals(context) {
  Alert(
    context: context,
    type: AlertType.none,
    buttons: [],
    style: AlertStyle(
      titleStyle: const TextStyle(color: ColorPage.red),
      descStyle: FontFamily.font6,
      isButtonVisible: false,
      isCloseButton: false,
    ),
    content: ScrollConfiguration(
      behavior: HideScrollbarBehavior(),
      child: SingleChildScrollView(
        // clipBehavior: HideScrollbarBehavior(),
        // reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorPage.colorbutton,
                borderRadius: const BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              padding: const EdgeInsets.all(15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Flutter Certification Exam',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '2024-08-15',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.video_library,
                            size: 30, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        const Text('10 ',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('Videos',
                            style: FontFamily.font3.copyWith(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: ClsFontsize.DoubleExtraSmall)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 1),
                      child: Text("15 Hours",
                          style: FontFamily.font3.copyWith(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: ClsFontsize.DoubleExtraSmall)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.picture_as_pdf,
                            size: 30, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        const Text('5 ',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        Text('PDFs',
                            style: FontFamily.font3.copyWith(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: ClsFontsize.DoubleExtraSmall)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 1),
                      child: Text("10 Hours",
                          style: FontFamily.font3.copyWith(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: ClsFontsize.DoubleExtraSmall)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.question_answer,
                            size: 30, color: Colors.blueAccent),
                        const SizedBox(width: 10),
                        const Text('50 ',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        Text('MCQs',
                            style: FontFamily.font3.copyWith(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: ClsFontsize.DoubleExtraSmall)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 1),
                      child: Text(
                        "5 Hours",
                        style: FontFamily.font3.copyWith(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: ClsFontsize.DoubleExtraSmall),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Total Study Time: 30 hours',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Total Remaining Day: 15',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Avg Time/Day: 2 hours',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
  ).show();
}

class HomePageDrawer extends StatefulWidget {
  final Function() ontapActivation;
  const HomePageDrawer({super.key, required this.ontapActivation});

  @override
  State<HomePageDrawer> createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  @override
  void initState() {
    super.initState();
  }

  // RxString version = "".obs;

  logOut() async {
    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        denyButtonText: "Cancel",
        title: "Are you sure?",
        text: "Are you sure you want to log out?",
        confirmButtonText: "Yes, log out",
        type: ArtSweetAlertType.question,
      ),
    );

    if (response == null) {
      return;
    }

    // onPressed: () async {

    //             },

    if (response.isTapConfirmButton) {
      Navigator.pop(context);

      if (getx.isInternet.value) {
        handleLogoutProcess(context);
      } else {
        onNoInternetConnection(context, () {
          Get.back();
        });
      }

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorPage.bgcolor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: ColorPage.gradientHeadingBox)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 33,
                        backgroundColor: ColorPage.white,
                        child: CircleAvatar(
                          radius: 30,
                          child: Text(
                            '${getx.loginuserdata[0].firstName[0]}${getx.loginuserdata[0].lastName[0]}'
                                .toUpperCase(),
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          // backgroundImage: AssetImage('assets/sorojda.png'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                            Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                getx.loginuserdata[0].firstName +
                                    " " +
                                    getx.loginuserdata[0].lastName,
                                style: FontFamily.style
                                    .copyWith(color: Colors.white)),
                            Expanded(
                              child: Text(getx.loginuserdata[0].email,
                                  overflow: TextOverflow.ellipsis,
                                  style: FontFamily.style.copyWith(
                                      color: Colors.white54, fontSize: 20)),
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
          Expanded(
            child: ListView(
              controller: ScrollController(),
              padding: EdgeInsets.zero,
              children: [
                drawerItem(
                    title: "Profile",
                    onTap: () {
                      // Get.to(MyAccountScreen());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyAccountScreen(
                                    fromDrawer: true,
                                  )));
                    },
                    leading: const Icon(
                      Icons.account_circle_outlined,
                      color: ColorPage.colorblack,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Colors.grey,
                    )),
                drawerItem(
                    title: "Packages",
                    onTap: () {
                      Get.to(
                        const Mobile_Package_List(),
                      );
                    },
                    leading: const Icon(Icons.work_outline_rounded,
                        color: ColorPage.colorblack),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Colors.grey,
                    )),
                drawerItem(
                    title: "Store",
                    onTap: () {
                      Get.to(
                        ListviewPackage(),
                      );
                    },
                    leading: const Icon(Icons.add_shopping_cart_rounded,
                        color: ColorPage.colorblack),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Colors.grey,
                    )),
                drawerItem(
                    title: "Package Activation",
                    onTap: () {
                      // enterActivationKey(context, getx.loginuserdata[0].token);
                      widget.ontapActivation();
                    },
                    leading: const Icon(Icons.ads_click_sharp,
                        color: ColorPage.colorblack),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Colors.grey,
                    )),
                drawerItem(
                    title: "Help Chat",
                    onTap: () {
                      Get.to(() => ChatPage(
                            // meeting!.sessionId.toString(),
                            getx.loginuserdata[0].nameId,
                            "${getx.loginuserdata[0].firstName} ${getx.loginuserdata[0].lastName}",
                          ));
                    },
                    leading:
                        const Icon(Icons.chat, color: ColorPage.colorblack),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Colors.grey,
                    )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(27),
                    child: ListTile(
                      onTap: logOut,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(27)),
                      tileColor: const Color.fromARGB(255, 255, 212, 199),
                      leading: const Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          color: ColorPage.colorblack,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      dense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              child: Column(
                children: [
                  Text(
                    'Follow Us On Social Media',
                    style: TextStyle(
                        fontSize: 18, // Adjust the size as needed
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400),
                  ),
                  const SizedBox(
                      height:
                          4), // Add some spacing between the text and the line
                  Divider(
                    thickness: 2, // Adjust the thickness of the line
                    color: Colors.grey
                        .shade200, // Change the color of the line if needed
                  ),
                  const SizedBox(
                      height: 8), // Add spacing before the content below

                  FutureBuilder(
                      future: getSocialMediaIcons(
                          context, getx.loginuserdata[0].token),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(
                                snapshot.data!.length,
                                (index) => InkWell(
                                  onTap: () async {
                                    final Uri url =
                                        Uri.parse(snapshot.data![index].link);

                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    } else {
                                      cantLaunchUrlAlert(context);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            snapshot.data!.length > 4 ? 20 : 25,
                                        width:
                                            snapshot.data!.length > 4 ? 20 : 25,
                                        child: SvgPicture.string(
                                            snapshot.data![index].icon),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        snapshot.data![index].servicesTypeName,
                                        style: FontFamily.style.copyWith(
                                            fontSize: 14,
                                            color: Colors.black87),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                ],
              ),
            ),
          ),
          Obx(
            () => Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: Image(
                        image: AssetImage(logopath),
                        height: 30,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "version ${getx.appVersion.value}",
                      style: FontFamily.style
                          .copyWith(color: Colors.grey, fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  _logoutConfirmetionBox(context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      alertPadding: const EdgeInsets.only(top: 200),
      descStyle: const TextStyle(),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(color: Colors.grey),
      ),
      titleStyle: const TextStyle(
          color: Color.fromARGB(255, 243, 33, 33), fontWeight: FontWeight.bold),
      constraints: const BoxConstraints.expand(width: 350),
      overlayColor: const Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center,
    );
    Alert(
      context: context,
      type: AlertType.warning,
      style: alertStyle,
      title: "Are you sure ?",
      desc:
          "Once you are logout your all data will be cleared and you should login again!",
      buttons: [
        DialogButton(
          width: 150,
          child: const Text("Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: const Color.fromARGB(255, 203, 46, 46),
          onPressed: () {
            Navigator.pop(context);
          },
          color: const Color.fromARGB(255, 139, 19, 19),
        ),
        DialogButton(
          width: 150,
          highlightColor: const Color.fromARGB(255, 2, 2, 60),
          child: const Text("Yes",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () async {
            await logoutFunction(context, getx.loginuserdata[0].token);
            Navigator.pop(context);
            await logoutFunction(context, getx.loginuserdata[0].token);
            await clearSharedPreferencesExcept([
              'SelectedDownloadPathOfVieo',
              'SelectedDownloadPathOfFile',
              'DefaultDownloadpathOfFile',
              'DefaultDownloadpathOfVieo'
            ]);

            getx.loginuserdata.clear();

            Get.offAll(() => const Mobilelogin());
          },
          color: const Color.fromARGB(255, 1, 12, 31),
        ),
      ],
    ).show();
  }

  Future<void> clearSharedPreferencesExcept(List<String> keysToKeep) async {
    final prefs = await SharedPreferences.getInstance();

    final allKeys = prefs.getKeys();

    for (String key in allKeys) {
      if (!keysToKeep.contains(key)) {
        await prefs.remove(key);
      }
    }
  }

  Widget drawerItem(
      {required String title,
      required VoidCallback onTap,
      required Widget leading,
      Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.circular(20),
        child: ListTile(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          onTap: onTap,
          leading: leading,
          trailing: trailing,
          title: Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}

// Future<void> clearSharedPreferencesExcept(List<String> keysToKeep) async {
//   final prefs = await SharedPreferences.getInstance();

//   final allKeys = prefs.getKeys();

//   for (String key in allKeys) {
//     if (!keysToKeep.contains(key)) {
//       await prefs.remove(key);
//     }
//   }
// }

class HeadingBox extends StatefulWidget {
  List<dynamic> imageUrl;
  int mode;
  List<PremiumPackage> package;

  HeadingBox({
    required this.mode,
    required this.imageUrl,
    this.package = const [], // Default value as an empty list
  });

  @override
  State<HeadingBox> createState() => _HeadingBoxState();
}

class _HeadingBoxState extends State<HeadingBox> {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  RxInt currentIndex = 0.obs;
  RxList list = [].obs;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //  getx.bannerImageList.isNotEmpty
        widget.mode == 0
            ? Container(
                height: 110,
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: CarouselSlider(
                      items: widget.imageUrl.map((item) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => BannerDetailsPage(
                                  index: currentIndex.value,
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                                // padding: EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    // borderRadius: BorderRadius.circular(20),
                                    // gradient: LinearGradient(
                                    //   begin: Alignment.centerLeft,
                                    //   end: Alignment.centerRight,
                                    //   // colors: ColorPage.gradientHeadingBox,
                                    // ),
                                    ),
                                child: item["BannerImagePosition"] == "middle"
                                    ? File(item['ImageUrl']).existsSync()
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              File(item['ImageUrl']!),
                                              fit: BoxFit.fill,
                                              width: double.infinity,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Center(
                                                  child: Text(
                                                    'Image failed',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : const Center(
                                            child: Text('Image not found'),
                                          )
                                    : HeadingBoxContent(
                                        imagePath: item['ImageUrl']!,
                                        imagePosition:
                                            item["BannerImagePosition"],
                                        isImage: true,
                                        title: item["BannerContent"],
                                      )),
                          ),
                        );
                      }).toList(),
                      carouselController: carouselController,
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        aspectRatio: 2,
                        viewportFraction: 0.98,
                        onPageChanged: (index, reason) {
                          currentIndex.value = index;
                        },
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: CarouselSlider(
                      items: widget.package.map((item) {
                        print(item.documentUrl);
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                              // padding: EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  // borderRadius: BorderRadius.circular(20),
                                  // gradient: LinearGradient(
                                  //   begin: Alignment.centerLeft,
                                  //   end: Alignment.centerRight,
                                  //   // colors: ColorPage.gradientHeadingBox,
                                  // ),
                                  ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.documentUrl,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                              )),
                        );
                      }).toList(),
                      carouselController: carouselController,
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        aspectRatio: 2,
                        viewportFraction: 0.98,
                        onPageChanged: (index, reason) {
                          currentIndex.value = index;
                        },
                      ),
                    ),
                  ),
                ),
              ),
        Obx(
          () => list.isEmpty
              ? Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.package.isEmpty
                        ? widget.imageUrl.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () =>
                                  carouselController.animateToPage(entry.key),
                              child: Container(
                                width: currentIndex == entry.key ? 18 : 10,
                                height: 7,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                    color: currentIndex == entry.key
                                        ? ColorPage.blue
                                        : ColorPage.white),
                              ),
                            );
                          }).toList()
                        : widget.package.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () =>
                                  carouselController.animateToPage(entry.key),
                              child: Container(
                                width: currentIndex == entry.key ? 18 : 10,
                                height: 7,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                    color: currentIndex == entry.key
                                        ? ColorPage.blue
                                        : ColorPage.white),
                              ),
                            );
                          }).toList(),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}

class HeadingBoxContent extends StatelessWidget {
  final String? date;
  final String? title;
  final String? desc;
  final Widget? trailing;
  final String imagePath;
  final String imagePosition;
  final bool isImage;
  const HeadingBoxContent({
    super.key,
    this.date,
    this.title,
    this.desc,
    required this.imagePosition,
    this.trailing,
    required this.isImage,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        const TextStyle(fontFamily: 'AltoneRegular', fontSize: 20);
    TextStyle styleb = const TextStyle(fontFamily: 'AltoneBold', fontSize: 20);
    return LayoutBuilder(builder: (context, constraints) {
      return isImage && imagePosition == 'right'
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text at the start
                Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Container(
                      child: HtmlWidget(title!),
                    )),

                // Image at the end
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width / 2.5,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width / 2.5,
                  ),
                ),
                // Text at the start

                Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Container(
                      child: HtmlWidget(
                        title ?? "",
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                    )),

                // Image at the end
              ],
            );
    });
  }
}

class HomePageMobile extends StatefulWidget {
  @override
  _HomePageMobileState createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  RxInt _currentIndex = 0.obs;

  String? token;

  List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    Getx getx = Get.put(Getx());
//bottombar list
    _children = [
      DashBoardMobile(),
      const Mobile_Package_List(),
      ListviewPackage(),
      ForumPage(),
      MyAccountScreen(
        fromDrawer: false,
      ),
    ];
    // getIconData(context, getx.loginuserdata[0].token);
    notificationsCall();
  }

  notificationsCall() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? notificationCounter = prefs.getInt('notificationCounter');

    if (notificationCounter != null) {
      // log("${notificationCounter} notification counter");
      if (notificationCounter <= 2) {
        var status = await Permission.notification.status;
        if (status.isDenied) {
          Future.delayed(const Duration(seconds: 5)).then((v) {
            notificationPermissionRequest(context);
          });
          await prefs.setInt('notificationCounter', notificationCounter + 1);
        }
      }
    } else {
      var status = await Permission.notification.status;
      if (status.isDenied) {
        Future.delayed(const Duration(seconds: 5)).then((v) {
          notificationPermissionRequest(context);
        });
        await prefs.setInt('notificationCounter', 1);
      }
    }
  }

  notificationPermissionRequest(context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 15),
      showCloseIcon: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Get notified!",
                style: FontFamily.styleb.copyWith(color: Colors.amber),
              ),
            ],
          ),
          Text(
            'Get all the Notification and updates.',
            style: FontFamily.style.copyWith(fontSize: 12),
          )
        ],
      ),
      actionOverflowThreshold: 0.4,
      action: SnackBarAction(
          textColor: Colors.blueAccent,
          label: 'Allow',
          onPressed: () async {
            var status = await Permission.notification.status;
            if (status.isDenied) {
              await Permission.notification.request().then((v) {
                v.isDenied
                    ? showErrorDialog(context, "Notification Permission",
                        "Your notification permission is Denied, turn on in app setings")
                    : null;
              });
            }
// You can also directly ask permission about its status.
            if (await Permission.location.isRestricted) {
              // The OS restricts access, for example, because of parental controls.
              showErrorDialog(context, "Notification Permission",
                  "Your notification permission is restricted, turn on in app setings");
            }
          }),
      margin: const EdgeInsets.all(10),
    ));
  }

  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            message,
            style: FontFamily.style.copyWith(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                openAppSettings();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  FabVisibility _fabVisibility = Get.put(FabVisibility());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBody: true,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: _currentIndex.value == 0
            ? _fabVisibility.visibility.value
                ? Visibility(
                    visible: _fabVisibility.visibility.value,
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.amber.shade100,
                      heroTag: 'arrow-up',
                      onPressed: () {
                        _scrollController.animateTo(
                          -1000, // Scroll to the event section
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Icon(Icons.keyboard_arrow_up_rounded),
                    ),
                  )
                : Visibility(
                    visible: !_fabVisibility.visibility.value,
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.amber.shade100,
                      heroTag: 'arrow-down',
                      onPressed: () {
                        _scrollController.animateTo(
                          1000, // Scroll to the event section
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  )
            : _currentIndex.value == 1
                ? Visibility(
                    visible: true,
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.amber.shade300,
                      label: Text(
                        'Back Up',
                        style: TextStyle(color: Colors.black87),
                      ),
                      icon: Icon(
                        Icons.backup_table,
                        color: Colors.black87,
                      ),
                      elevation: 0,
                      heroTag: 'backup-video',
                      onPressed: () {
                        Get.to(() => BackupVideosPage());
                      },
                      tooltip: 'Back Up Videos',
                    ),
                  )
                : null,
        body: _children[_currentIndex.value],
        // bottomNavigationBar: CurvedNavigationBar(
        //   backgroundColor: Colors.transparent,
        //   color: ColorPage.white,
        //   onTap: onTabTapped,
        //   items: [
        //     Icon(Icons.home, size: 30, color: ColorPage.colorbutton),
        //     Icon(Icons.movie_filter_outlined,
        //         size: 30, color: ColorPage.colorbutton),
        //     Icon(Icons.person, size: 30, color: ColorPage.colorbutton),
        //   ],
        // ),

        bottomNavigationBar: Container(
          // decoration: const BoxDecoration(border: Border(top: BorderSide(width: 1,color: Colors.black45))),
          child: Obx(
            () => NavigationBar(
              elevation: 5,
              backgroundColor: const Color.fromARGB(255, 255, 254, 252),
              onDestinationSelected: (int newIndex) async {
                if (getx.isInsidePackage.value) {
                  if (_currentIndex.value == 1 && newIndex != 1) {
                    ArtSweetAlert.show(
                      barrierDismissible: false,
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                        showCancelBtn: true,
                        title: "Are you sure?",
                        text: "Do you want to leave the Page?",
                        confirmButtonText: "Yes",
                        cancelButtonText: "No",
                        onConfirm: () {
                          getx.isInsidePackage.value = false;
                          Navigator.pop(context); // Close dialog
                          _currentIndex.value = newIndex; // Update index
                        },
                        onCancel: () {
                          Navigator.pop(context); // Just close dialog
                        },
                        type: ArtSweetAlertType.warning,
                      ),
                    );
                  } else {
                    // Change index if not at 1 or not switching from 1
                    _currentIndex.value = newIndex;
                  }
                } else {
                  // Change index if not at 1 or not switching from 1
                  _currentIndex.value = newIndex;
                }
              },
              indicatorColor: Colors.amberAccent.withAlpha(200),
              selectedIndex: _currentIndex.value,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home_rounded),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.work),
                  icon: Icon(Icons.work_outline),
                  label: 'Packages',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.shopping_cart),
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: 'Store',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.forum_rounded),
                  icon: Icon(Icons.forum_outlined),
                  label: 'Forum',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.person),
                  icon: Icon(Icons.person_outline_outlined),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
