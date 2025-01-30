import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dthlms/PC/VIDEO/ClsVideoPlay.dart';
import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';

// import 'package:dthlmspro_video_player/VIDEO_PLAYER/getxController.dart';
// import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
// import 'package:dthlms/API/URL/api_url.dart';
// import 'package:/getxController.dart';
// import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
// import 'package:dthlms/PC/LOGIN/login.dart';
// import 'package:dthlms/PC/VIDEO/ClsVideoPlay.dart';
// import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
// import 'package:dthlms/THEME_DATA/color/color.dart';
// import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

class VideoPlayerMcq extends StatefulWidget {
  final String videoLink;
  const VideoPlayerMcq(this.videoLink, {super.key});

  @override
  State<VideoPlayerMcq> createState() => _VideoPlayerMcqState();
}

class _VideoPlayerMcqState extends State<VideoPlayerMcq> {
  void dispose() {
    print("close the app");

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
  int selectedListIndex = -1; // Track the selected list tile
  List<double> downloadProgress = List.filled(20, 0.0);
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
  int playno = 0;
  var utcTime = DateTime.now();

  @override
  void initState() {
    videoPlay = VideoPlayClass();

    //   FlutterWindowClose.setWindowShouldCloseHandler(() async {

    //       // insertVideoplayInfo(
    //       //     int.parse(getx.playingVideoId.value),
    //       //         videoPlay.player.state.position.toString(),
    //       //         videoPlay.totalPlayTime.inSeconds.toString(),
    //       //         videoPlay.player.state.rate.toString(),
    //       //         videoPlay.startclocktime.toString(),
    //       //       utcTime.millisecondsSinceEpoch,

    //       //       );
    //       //        updateVideoConsumeDuration(getx.playingVideoId.value,getx.selectedPackageId.value.toString(), videoPlay.totalPlayTime.inSeconds.toString(),);

    //  return true;

    //   });
    videoPlay.updateVideoLink(widget.videoLink, []);
    initialFunctionOfRightPlayer();
    // initialFunctionOfRightPlayer();
    dio = Dio();

    // TODO: implement initState
    super.initState();
  }

  List<Widget> page = [];

  initialFunctionOfRightPlayer() {
    // creatTableVideoplayInfo();

    videoPlay.player.stream.playing.listen((bool playing) {
      if (mounted) {
        setState(() {
          isPlaying = playing;

          if (playing) {
            // log('playing');

            print(utcTime.millisecondsSinceEpoch);
            videoPlay.startTrackingPlayTime();

            // Cancel any existing timer to avoid multiple timers running
            // _timer?.cancel();
          } else {
            videoPlay.stopTrackingPlayTime();

            // if(getx.isInternet.value){
            //       videoInfo(
            //                   context,
            //                   videoPlay.player.state.position.toString(),
            //                  getx.playingVideoId.value,
            //                   videoPlay.totalPlayTime.inSeconds.toString(),
            //                   videoPlay.player.state.rate.toString(),
            //                   videoPlay.startclocktime.toString(),
            //                   getx.token.value,
            //                   utcTime.millisecondsSinceEpoch);

            // }

            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: videoPlayerRightMcq());
  }

  Widget videoPlayerRightMcq() {
    return Container(
      child: Column(
        children: [
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
                seekBarHeight: 5,
                // buttonBarHeight: 10,
                seekBarMargin: EdgeInsets.all(10),
                toggleFullscreenOnDoublePress: false,
              ),
              fullscreen: MaterialDesktopVideoControlsThemeData(),
              child: Container(
                height: Platform.isIOS ? 280 : 390,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.only(bottom: 10),
                child: Video(controller: videoPlay.controller),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
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
            Navigator.pop(context);
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






// Getx getx=Get.put(Getx());