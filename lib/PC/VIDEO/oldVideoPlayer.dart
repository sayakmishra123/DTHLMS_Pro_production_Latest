// // import 'package:dthlms/Master/scrollbarhide.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
// import 'package:dthlms/GETXCONTROLLER/getxController.dart';
// import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
// import 'package:dthlms/MOBILE/MCQ/mockTestMcq.dart';
// import 'package:dthlms/PC/MCQ/modelclass.dart';
// import 'package:dthlms/PC/PACKAGEDETAILS/packagedetails.dart';
// import 'package:dthlms/PC/VIDEO/ClsVideoPlay.dart';
// import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
// import 'package:dthlms/THEME_DATA/color/color.dart';
// import 'package:dthlms/THEME_DATA/font/font_family.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_spinbox/flutter_spinbox.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// TextStyle style = TextStyle(fontFamily: 'AltoneRegular', fontSize: 20);
// TextStyle styleb = TextStyle(fontFamily: 'AltoneBold', fontSize: 20);

// class VideoPlayer extends StatefulWidget {
//   final String videoLink;
//   const VideoPlayer( this.videoLink, {super.key});

//   @override
//   State<VideoPlayer> createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State<VideoPlayer> {

  
//   int selectedIndex = -1;
//   Getx getx = Get.put(Getx());
  
//   @override
//   void initState() {
//     getx.playLink.value=getx.alwaysShowChapterfilesOfVideo[0]['DownloadedVideoPath'];
//     // TODO: implement initState
//     super.initState(); 
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           leading:
//           //  !getx.isIconSideBarVisible.value
//           //     ? IconButton(
//           //         icon: Icon(Icons.list),
//           //         onPressed: () {
//           //           getx.isIconSideBarVisible.value = true;
//           //         })
//           //     :
//                IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   onPressed: () {
//                     if(getx.navigationList.length-2==1){
//                        print('press in video');
//                                                 resetTblLocalNavigationByOrder(
//                                                     1);



//                                                 getStartParentId(int.parse(
//                                                         getx.navigationList[1]
//                                                             ['NavigationId']))
//                                                     .then((value) {
//                                                   print(value);
//                                                   getChapterContents(int.parse(
//                                                       value.toString()));
//                                                   getChapterFiles(
//                                                       int.parse(
//                                                           value.toString()),
//                                                       'Video');
//                                                 });
//                                                 getLocalNavigationDetails();
//                     }
//                      if(getx.navigationList.length-2==2){
//                        print('press in video');
//                                                 resetTblLocalNavigationByOrder(
//                                                     2);



//                                                 getStartParentId(int.parse(
//                                                         getx.navigationList[1]
//                                                             ['NavigationId']))
//                                                     .then((value) {
//                                                   print(value);
//                                                   getChapterContents(int.parse(
//                                                       value.toString()));
//                                                   getChapterFiles(
//                                                       int.parse(
//                                                           value.toString()),
//                                                       'Video');
//                                                 });
//                                                 getLocalNavigationDetails();
//                     }
//                     if(getx.navigationList.length-2>=2){
//                       resetTblLocalNavigationByOrder(
//                                                   getx.navigationList.length-2);

//                                                 // insertTblLocalNavigation(
//                                                 //     "ParentId",
//                                                 //     getx.navigationList[getx.navigationList.length-2]
//                                                 //         ['NavigationId'],
//                                                 //     getx.navigationList[getx.navigationList.length-2]
//                                                 //         ["NavigationName"]);

//                                                 getChapterContents(int.parse(
//                                                     getx.navigationList[getx.navigationList.length-2]
//                                                         ['NavigationId']));
//                                                 getChapterFiles(
//                                                     int.parse(
//                                                         getx.navigationList[getx.navigationList.length-2]
//                                                             ['NavigationId']),
//                                                     'Video');
//                                                 getLocalNavigationDetails();
//                     }
                    
//                     Get.back();
//                   }),
//           elevation: 0,
//           shadowColor: Colors.grey,
//           surfaceTintColor: Colors.white,
//           backgroundColor: Colors.white,
//           title: Row(children: [     for (var i = 0;
//                                       i < getx.navigationList.length;
//                                       i++)
//                                     getx.navigationList.isEmpty
//                                         ? Text("Blank")
//                                         : InkWell(
//                                             onTap: () {
//                                               // resetTblLocalNavigationByOrder(i);
//                                               // insertTblLocalNavigation(navigationtype, navigationId, navigationName)
//                                               // if (i == 0) {
//                                               //   //nothing
//                                               // }
//                                               // if (i == 1) {
//                                               //   print('press in video');
//                                               //   resetTblLocalNavigationByOrder(
//                                               //       i);



//                                               //   getStartParentId(int.parse(
//                                               //           getx.navigationList[1]
//                                               //               ['NavigationId']))
//                                               //       .then((value) {
//                                               //     print(value);
//                                               //     getChapterContents(int.parse(
//                                               //         value.toString()));
//                                               //     getChapterFiles(
//                                               //         int.parse(
//                                               //             value.toString()),
//                                               //         'Video');
//                                               //   });
//                                               //   getLocalNavigationDetails();
//                                               // }
//                                               // if (i > 1) {
//                                               //   resetTblLocalNavigationByOrder(
//                                               //       i);

//                                               //   insertTblLocalNavigation(
//                                               //       "ParentId",
//                                               //       getx.navigationList[i]
//                                               //           ['NavigationId'],
//                                               //       getx.navigationList[i]
//                                               //           ["NavigationName"]);

//                                               //   getChapterContents(int.parse(
//                                               //       getx.navigationList[i]
//                                               //           ['NavigationId']));
//                                               //   getChapterFiles(
//                                               //       int.parse(
//                                               //           getx.navigationList[i]
//                                               //               ['NavigationId']),
//                                               //       'Video');
//                                               //   getLocalNavigationDetails();
//                                               // }

//                                               // print(getx
//                                               //     .alwaysShowChapterDetails
//                                               //     .length);
//                                             },
//                                             child: Text(getx.navigationList[i]
//                                                     ["NavigationName"] +
//                                                 ' > '),
//                                           )],),
//           actions: [
//             // Padding(
//             //   padding: const EdgeInsets.only(right: 20),
//             //   child: Container(
//             //     margin: EdgeInsets.symmetric(vertical: 5),
//             //     width: 300,
//             //     child: TextFormField(
//             //       decoration: InputDecoration(
//             //           suffixIcon: Icon(
//             //             Icons.search,
//             //           ),
//             //           suffixIconColor: Color.fromARGB(255, 103, 103, 103),
//             //           hintText: 'Search',
//             //           hintStyle: FontFamily.font9
//             //               .copyWith(color: ColorPage.brownshade),
//             //           fillColor: Color.fromARGB(255, 237, 237, 238),
//             //           filled: true,
//             //           border: OutlineInputBorder(
//             //               borderSide: BorderSide.none,
//             //               borderRadius: BorderRadius.circular(40))),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//         body: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // getx.isIconSideBarVisible.value
//             //     ? Expanded(
//             //         flex: 1,
//             //         child: Padding(
//             //           padding: const EdgeInsets.symmetric(
//             //               horizontal: 10, vertical: 10),
//             //           child: IconSidebar(
//             //             selecteIndex: -1,
//             //           ),
//             //         ),
//             //       ) // Hidden sidebar
//             //     : Container(width: 0),
//             Expanded(
//               flex: 4,
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Color.fromARGB(255, 255, 255, 255),
//                         boxShadow: [
//                           BoxShadow(
//                             blurRadius: 3,
//                             color: Color.fromARGB(255, 143, 141, 141),
//                             offset: Offset(0, 0),
//                           ),
//                         ],
//                       ),
//                       child: VideoPlayerLeft()),
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 6,
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   child: Obx(()=>
//                      Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           color: Color.fromARGB(255, 255, 255, 255),
//                           boxShadow: [
//                             BoxShadow(
//                               blurRadius: 3,
//                               color: Color.fromARGB(255, 143, 141, 141),
//                               offset: Offset(0, 0),
//                             ),
//                           ],
//                         ),
//                         child:getx.alwaysShowChapterfilesOfVideo[0]["DownloadedVideoPath"]=='0'?Center(child:Text("No Video Downloaded")): VideoPlayerRight(getx.playLink.value)),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VideoPlayerRight extends StatefulWidget {
//   final String playLink;
//   const VideoPlayerRight(this.playLink,{super.key});

//   @override
//   State<VideoPlayerRight> createState() => _VideoPlayerRightState();
// }

// class _VideoPlayerRightState extends State<VideoPlayerRight> {
//   late final player = Player();
//   late final controller = VideoController(player);
//   final List<double> speeds = [0.5, 1.0, 1.5, 2.0];
//   double selectedSpeed = 1.0;
//   late VideoPlayClass videoPlay;
//   bool isPlaying = false;
//   TextEditingController timeController = TextEditingController();
//   Timer? _timer;
//   @override
//   void initState() {
//     videoPlay = VideoPlayClass(getx.playLink.value);
//     creatTableVideoplayInfo();
//     // if (videoPlay.player.stream.completed.isBroadcast) {
//     //   log('Completed');
//     // }
//     // videoPlay.stopTrackingPlayTime();
//     // insertVideoplayInfo(
//     //     1, '00.00', '1', videoPlay.player.state.rate.toString(), '1', 'j');
//     // readTblvideoPlayInfo();
//     // log(videoPlay.totalPlayTime.inSeconds.toString());

//     // if (videoPlay.player.state.completed) {
//     //   log('Completed');
//     // }
//     videoPlay.player.stream.playing.listen((bool playing) {
//       if (mounted) {
//         setState(() {
//           isPlaying = playing;

//           if (playing) {
//             log('playing');
//             videoPlay.startTrackingPlayTime();

//             // Cancel any existing timer to avoid multiple timers running
//             _timer?.cancel();

//             // Start a new timer that triggers every 5 seconds
//             _timer = Timer.periodic(Duration(seconds: 5), (timer) {
//               log(videoPlay.totalPlayTime.inSeconds.toString());

//               insertVideoplayInfo(
//                 1,
//                 videoPlay.player.state.position.toString(),
//                 videoPlay.totalPlayTime.inSeconds.toString(),
//                 videoPlay.player.state.rate.toString(),
//                 videoPlay.startclocktime.toString(),
//               );

//               readTblvideoPlayInfo();
//             });
//           } else { 
//             // Stop tracking and cancel the timer when video stops playing
//             videoPlay.stopTrackingPlayTime();
//             _timer?.cancel();
//           }
//         });
//       }
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: IconButton.filled(
//                         tooltip: 'Previous',
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStatePropertyAll(
//                                 ColorPage.colorbutton)),
//                         onPressed: () {},
//                         icon: Icon(
//                           Icons.fast_rewind,
//                         )),
//                   ),
//                   isPlaying
//                       ? Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: IconButton.filled(
//                               tooltip: 'Pause',
//                               style: ButtonStyle(
//                                   backgroundColor: MaterialStatePropertyAll(
//                                       ColorPage.colorbutton)),
//                               onPressed: () {
//                                 setState(() {
//                                   videoPlay.pauseVideo();
//                                 });
//                                 log(videoPlay.totalPlayTime.inSeconds
//                                     .toString());
//                               },
//                               icon: Icon(
//                                 Icons.pause,
//                               )),
//                         )
//                       : Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: IconButton.filled(
//                               tooltip: 'Play',
//                               style: ButtonStyle(
//                                   backgroundColor: MaterialStatePropertyAll(
//                                       ColorPage.colorbutton)),
//                               onPressed: () {
//                                 setState(() {
//                                   videoPlay.playVideo();
//                                 });
//                               },
//                               icon: Icon(
//                                 Icons.play_arrow,
//                               )),
//                         ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: IconButton.filled(
//                         tooltip: 'Next',
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStatePropertyAll(
//                                 ColorPage.colorbutton)),
//                         onPressed: () {},
//                         icon: Icon(
//                           Icons.fast_forward,
//                         )),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: IconButton.filled(
//                         tooltip: 'Tag',
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStatePropertyAll(
//                                 ColorPage.colorbutton)),
//                         onPressed: () {
//                           addTag(context);
//                         },
//                         icon: Icon(
//                           Icons.edit_note,
//                         )),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: IconButton.filled(
//                         tooltip: 'Speed',
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStatePropertyAll(
//                                 ColorPage.colorbutton)),
//                         onPressed: () {
//                           showMenu(
//                               context: context,
//                               position: RelativeRect.fromLTRB(10, 118, 0, 10),
//                               items: speeds.map((speed) {
//                                 return PopupMenuItem<double>(
//                                   value: speed, 
//                                   child: Row(
//                                     children: [
//                                       Radio<double>(
//                                         value: speed,
//                                         groupValue: selectedSpeed,
//                                         onChanged: (double? value) {
//                                           setState(() {
//                                             selectedSpeed = value!;
//                                             videoPlay.player
//                                                 .setRate(selectedSpeed);
//                                             Navigator.pop(context);
//                                           });
//                                         },
//                                       ),
//                                       Text('${speed}x'),
//                                     ],
//                                   ),
//                                 );
//                               }).toList());
//                         },
//                         icon: Icon(Icons.slow_motion_video)),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: IconButton.filled(
//                         tooltip: 'GOTO',
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStatePropertyAll(
//                                 ColorPage.colorbutton)),
//                         onPressed: () {
//                           // showGotoDialog(context);
//                           videoInfo(
//                               context,
//                               videoPlay.player.state.position.toString(),
//                               '1',
//                               videoPlay.totalPlayTime.inSeconds.toString(),
//                               videoPlay.player.state.rate.toString(),
//                               videoPlay.startclocktime.toString(),
//                               getx.token.toString());
//                         },
//                         icon: Icon(Icons.drag_indicator)),
//                   )
//                 ],
//               ),
//             ],
//           ),
//           Card(
//             surfaceTintColor: Colors.white,
//             color: Colors.white,
//             elevation: 0.0,
//             child: MaterialDesktopVideoControlsTheme(
//               normal: MaterialDesktopVideoControlsThemeData(
//                 controlsHoverDuration: Duration(seconds: 5),
//                 primaryButtonBar: [
//                   MaterialDesktopSkipPreviousButton(
//                     iconSize: 80,
//                     iconColor: ColorPage.red,
//                   ),
//                   MaterialDesktopPlayOrPauseButton(
//                     iconSize: 80,
//                   ),
//                 ],
//                 seekBarThumbColor: ColorPage.colorbutton,
//                 seekBarPositionColor: ColorPage.colorbutton,
//                 toggleFullscreenOnDoublePress: false,
//               ),
//               fullscreen: MaterialDesktopVideoControlsThemeData(),
//               child: Container(
//                 height: getx.isIconSideBarVisible.value ? 445 : 485,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: EdgeInsets.only(bottom: 40),
//                 child: Video(controller: videoPlay.controller),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//         ],
//       ),
//     );
//   }
// // import 'package:flutter/material.dart';
// // import 'package:flutter_spinbox/flutter_spinbox.dart';

//   void showGotoDialog(BuildContext context) {
//     double hours = 0;
//     double minutes = 0;
//     double seconds = 0;

//     var alertStyle = AlertStyle(
//       animationType: AnimationType.fromTop,
//       isCloseButton: false,
//       isOverlayTapDismiss: true,
//       alertPadding: EdgeInsets.only(top: 200),
//       descStyle: TextStyle(fontWeight: FontWeight.bold),
//       animationDuration: Duration(milliseconds: 400),
//       alertBorder: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//         side: BorderSide(color: Colors.grey),
//       ),
//       titleStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//       constraints: BoxConstraints.expand(width: 500),
//       overlayColor: Color(0x55000000),
//       alertElevation: 0,
//       alertAlignment: Alignment.center,
//     );

//     Alert(
//       context: context,
//       style: alertStyle,
//       title: "Go to Time",
//       content: Form(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(height: 30),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text("Hours",
//                           style: FontFamily.font9
//                               .copyWith(color: ColorPage.colorblack)),
//                       SpinBox(
//                         min: 0,
//                         max: 23,
//                         value: hours,
//                         onChanged: (value) {
//                           hours = value;
//                         },
//                         decrementIcon: Icon(Icons.arrow_left_sharp),
//                         incrementIcon: Icon(Icons.arrow_right_sharp),
//                         spacing: 8.0,
//                         decoration: InputDecoration(
//                           border: UnderlineInputBorder(
//                             borderSide: BorderSide(width: 2),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text("Minutes",
//                           style: FontFamily.font9
//                               .copyWith(color: ColorPage.colorblack)),
//                       SpinBox(
//                         min: 0,
//                         max: 59,
//                         value: minutes,
//                         onChanged: (value) {
//                           minutes = value;
//                         },
//                         decrementIcon: Icon(Icons.arrow_left_sharp),
//                         incrementIcon: Icon(Icons.arrow_right_sharp),
//                         spacing: 8.0,
//                         decoration: InputDecoration(
//                           border: UnderlineInputBorder(
//                             borderSide: BorderSide(width: 2),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text("Seconds",
//                           style: FontFamily.font9
//                               .copyWith(color: ColorPage.colorblack)),
//                       SpinBox(
//                         min: 0,
//                         max: 59,
//                         value: seconds,
//                         onChanged: (value) {
//                           seconds = value;
//                         },
//                         decrementIcon: Icon(Icons.arrow_left_sharp),
//                         incrementIcon: Icon(Icons.arrow_right_sharp),
//                         spacing: 8.0,
//                         decoration: InputDecoration(
//                           border: UnderlineInputBorder(
//                             borderSide: BorderSide(width: 2),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       buttons: [
//         DialogButton(
//           child: Text(
//             "Cancel",
//             style: TextStyle(color: Colors.white, fontSize: 15),
//           ),
//           onPressed: () {
//             Get.back();
//           },
//           color: Colors.red,
//           radius: BorderRadius.circular(5.0),
//         ),
//         DialogButton(
//           child: Text(
//             "Go",
//             style: TextStyle(color: Colors.white, fontSize: 15),
//           ),
//           onPressed: () {
//             final Duration position = Duration(
//               hours: hours.toInt(),
//               minutes: minutes.toInt(),
//               seconds: seconds.toInt(),
//             );

//             // Assuming videoPlay is your video player controller
//             videoPlay.seekTo(position); // Seek to the calculated position
//             Get.back();
//           },
//           color: Colors.blue,
//           radius: BorderRadius.circular(5.0),
//         ),
//       ],
//     ).show();
//   }

//   Future permission() async {
//     if (Platform.isAndroid) {
//       final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//       final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
//       if ((info.version.sdkInt) >= 33) {
//       } else {}
//     } else {}
//   }

//   addTag(context) {
//     var alertStyle = AlertStyle(
//       animationType: AnimationType.fromTop,
//       isCloseButton: false,
//       isOverlayTapDismiss: true,
//       alertPadding: EdgeInsets.only(top: 200),
//       descStyle: TextStyle(fontWeight: FontWeight.bold),
//       animationDuration: Duration(milliseconds: 400),
//       alertBorder: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.0),
//         side: BorderSide(color: Colors.grey),
//       ),
//       titleStyle: TextStyle(color: ColorPage.blue, fontWeight: FontWeight.bold),
//       constraints: BoxConstraints.expand(width: 350),
//       overlayColor: Color(0x55000000),
//       alertElevation: 0,
//       alertAlignment: Alignment.center,
//     );

//     Alert(
//       context: context,
//       style: alertStyle,
//       title: "Contribute your own tag",
//       content: Form(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Text('Write your tag here.....',
//                       style: FontFamily.font
//                           .copyWith(fontSize: ClsFontsize.ExtraSmall)),
//                 ),
//               ],
//             ),
//             Card(
//               child: SizedBox(
//                   child: TextFormField(
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Typing something...'),
//                 maxLines: 5,
//               )),
//             ),
//           ],
//         ),
//       ),
//       buttons: [
//         DialogButton(
//           child: Text("Cancel",
//               style: TextStyle(color: Colors.white, fontSize: 15)),
//           onPressed: () {
//             Get.back();
//           },
//           color: ColorPage.red,
//           radius: BorderRadius.circular(5.0),
//         ),
//         DialogButton(
//           child:
//               Text("Save", style: TextStyle(color: Colors.white, fontSize: 15)),
//           onPressed: () {
//             Get.back();
//           },
//           color: ColorPage.colorbutton,
//           radius: BorderRadius.circular(5.0),
//         ),
//       ],
//     ).show();
//   }
// }

// class Pdf extends StatelessWidget {
//   const Pdf({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 800,
//       child: SfPdfViewer.network(
//           'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf'),
//     );
//   }
// }

// class IconSidebar extends StatefulWidget {
//   int? selecteIndex;
//   IconSidebar({super.key, required this.selecteIndex});

//   @override
//   State<IconSidebar> createState() => _IconSidebarState();
// }

// class _IconSidebarState extends State<IconSidebar> {
//   int hoverIndex = -1;

//   String intToAscii(int value) {
//     if (value < 0 || value > 127) {
//       throw ArgumentError('Value must be between 0 and 127');
//     }
//     return String.fromCharCode(value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           // var entriesList = getx.packagedetailsfoldername.entries.toList();
//           Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(7),
//           color: ColorPage.white,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 3,
//               color: Color.fromARGB(255, 192, 191, 191),
//               offset: Offset(0, 0),
//             ),
//           ],
//         ),
//         child: getx.packagedetailsfoldername.isNotEmpty
//             ? SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: 5, top: 5),
//                           child: Text(
//                             "Chapters",
//                             style: FontFamily.font9.copyWith(
//                                 color: ColorPage.colorblack,
//                                 fontWeight: FontWeight.bold),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             getx.isIconSideBarVisible.value = false;
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 10, top: 5),
//                             child: Icon(
//                               Icons.close,
//                               size: 13,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: getx.alwaysShowChapterDetailsOfVideo.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 widget.selecteIndex = index;
//                               });
//                             },
//                             child: MouseRegion(
//                               cursor: SystemMouseCursors.click,
//                               onEnter: (_) {
//                                 setState(() {
//                                   hoverIndex = index;
//                                 });
//                               },
//                               onExit: (_) {
//                                 setState(() {
//                                   hoverIndex = -1;
//                                 });
//                               },
//                               child: InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     widget.selecteIndex = index;
//                                   });
//                                 },
//                                 onDoubleTap: () {
//                                   getx.path2.value =
//                                       "chapter-" + intToAscii(65 + index);
//                                   getx.path3.value = "";
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.all(5),
//                                   decoration: BoxDecoration(
//                                     color: hoverIndex == index ||
//                                             widget.selecteIndex == index
//                                         ? ColorPage.colorbutton
//                                         : Colors.transparent,
//                                     // border: Border.all(
//                                     //     width: 1,
//                                     //     color:
//                                     //         Color.fromARGB(255, 126, 124, 124)),
//                                     borderRadius: BorderRadius.all(
//                                       Radius.circular(5),
//                                     ),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                         "assets/folder.png",
//                                         scale: 12,
//                                         fit: BoxFit.contain,
//                                       ),
//                                       Text(
//                                         "chapter-" + intToAscii(65 + index),
//                                         style: FontFamily.font8.copyWith(
//                                           fontSize: 10,
//                                           color: hoverIndex == index ||
//                                                   widget.selecteIndex == index
//                                               ? ColorPage.white
//                                               : ColorPage.colorblack,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               )
//             : Container(),
//       ),
//     );
//   }
// }



// class VideoPlayerLeft extends StatefulWidget {
//   VideoPlayerLeft({super.key});

//   @override
//   State<VideoPlayerLeft> createState() => _VideoPlayerLeftState();
// }

// class _VideoPlayerLeftState extends State<VideoPlayerLeft> {
//   var color = Color.fromARGB(255, 102, 112, 133); 
//   List<Widget> page = [Pdf(), Mcq(), Tags(), Container()];

//   int flag = 2;
//   int selectedIndex = 0;
//   int selectedListIndex = -1; // Track the selected list tile
//   List<double> downloadProgress =
//       List.filled(20, 0.0); // Track download progress for each item

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return ScrollConfiguration(
//       behavior: HideScrollbarBehavior(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 0),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: ColorPage.white,
//                 boxShadow: [
//                   BoxShadow(
//                     blurRadius: 3,
//                     color: Color.fromARGB(255, 192, 191, 191),
//                     offset: Offset(0, 0),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: Text(
//                             "Titles",
//                             style: FontFamily.font
//                                 .copyWith(color: ColorPage.colorbutton),
//                           ),
//                         ),
                
//                       ],
//                     ),
//                    ScrollConfiguration(
//                     behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
//                      child: ListView.builder(
//                        shrinkWrap: true,
//                        // Removed NeverScrollableScrollPhysics to allow natural scrolling
//                        itemCount: getx.alwaysShowChapterfilesOfVideo.length,
//                        itemBuilder: (context, index) {
//                          print(   getx.alwaysShowChapterfilesOfVideo[index]["DownloadedVideoPath"] +" it is path");
//                          return ExpansionTile(
//                            backgroundColor: selectedListIndex == index
//                                ? ColorPage.white.withOpacity(0.5)
//                                : Color.fromARGB(255, 255, 255, 255),
//                            onExpansionChanged: (isExpanded) {
//                              setState(() {
//                                selectedListIndex = isExpanded ? index : -1;
//                              });
//                            },
//                            leading: Image.asset(
//                              "assets/video2.png",
//                              scale: 19,
//                              color: ColorPage.colorbutton,
//                            ),
//                            subtitle: Row(
//                              children: [
//                                Text(
//                                  'Duration: 3:04',
//                                  style: TextStyle(
//                                    color: ColorPage.grey,
//                                    fontWeight: FontWeight.w800,
//                                  ),
//                                ),
//                              ],
//                            ),
//                            title: Text(
//                              getx.alwaysShowChapterfilesOfVideo[index]["FileIdName"] +
//                                  ' - ${index + 1}.mp4',
//                              style: GoogleFonts.inter().copyWith(
//                                fontWeight: FontWeight.w800,
//                                overflow: TextOverflow.ellipsis,
//                                fontSize: selectedListIndex == index ? 20 : null,
//                              ),
//                            ),
//                            trailing: SizedBox(
//                              width: 130,
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.end,
//                                children: [
//                               downloadProgress[index] == 0 && getx.alwaysShowChapterfilesOfVideo[index]['DownloadedVideoPath']=='0'?
//                                    IconButton(
//                                      onPressed: () {
//                                        startDownload(index,getx.alwaysShowChapterfilesOfVideo[index]['DocumentPath']);
//                                      },
//                                      icon: Icon(
//                                        Icons.download,
//                                        color: ColorPage.colorbutton,
//                                      ),
//                                    )
//                                  :downloadProgress[index] < 100 && getx.alwaysShowChapterfilesOfVideo[index]['DownloadedVideoPath']=='0'?
                               
//                                    CircularPercentIndicator(
//                                      radius: 15.0,
//                                      lineWidth: 4.0,
//                                      percent: downloadProgress[index] / 100,
//                                      center: Text(
//                                        "${downloadProgress[index].toInt()}%",
//                                        style: TextStyle(fontSize: 10.0),
//                                      ),
//                                      progressColor: ColorPage.colorbutton,
//                                    )
//                                  :
//                                    IconButton(
//                                      onPressed: () {
                                      
//                                      },
//                                      icon: Icon(
//                                        Icons.play_circle,
//                                        color: ColorPage.colorbutton,
//                                      ),
//                                    ),
//                                  Padding(
//                                    padding: const EdgeInsets.all(8.0),
//                                    child: Icon(
//                                      selectedListIndex == index
//                                          ? Icons.keyboard_arrow_up
//                                          : Icons.keyboard_arrow_down_outlined,
//                                      color: ColorPage.colorbutton,
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                            children: [
//                              Container(
//                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(8),
//                                  color: Color.fromARGB(255, 243, 243, 243),
//                                ),
//                                child: Padding(
//                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                                  child: Column(
//                                    children: [
//                                      Row(
//                                        children: [
//                                          tabbarbutton('PDF', 0),
//                                          tabbarbutton('MCQ', 1),
//                                          tabbarbutton('TAG', 2),
//                                          tabbarbutton('Ask doubt', 3),
//                                          IconButton(
//                                            tooltip: 'Delete this video',
//                                            onPressed: () {},
//                                            icon: Icon(
//                                              Icons.delete_forever,
//                                              color: Color.fromARGB(255, 253, 29, 13),
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                      page[selectedIndex],
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            ],
//                          );
//                        },
//                      ),
//                    ),

//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget tabbarbutton(String name, int tabIndex) {
//     bool isActive = selectedIndex == tabIndex;
//     Color backgroundColor = isActive ? ColorPage.colorbutton : Colors.white;
//     Color textColor = isActive ? Colors.white : Colors.black;

//     return Expanded(
//       child: MouseRegion(
//         onEnter: (_) {
//           setState(() {
//             // hoverIndex = tabIndex;
//           });
//         },
//         onExit: (_) {
//           setState(() {
//             // hoverIndex = -1;
//           });
//         },
//         child: InkWell(
//           onTap: () {
//             setState(() {
//               selectedIndex = tabIndex;
//             });
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                     width: 0.5, color: Color.fromARGB(255, 150, 145, 145)),
//                 color: backgroundColor,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
//               child: Center(
//                 child: Text(
//                   name,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: textColor,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // void startDownload(int index) {
//   //   setState(() {
//   //     downloadProgress[index] = 0;
//   //   });

//   //   const duration = Duration(milliseconds: 30);
//   //   const totalSteps = 100;
//   //   for (int i = 1; i <= totalSteps; i++) {
//   //     Future.delayed(duration * i, () {
//   //       setState(() {
//   //         downloadProgress[index] = i.toDouble();
//   //       });
//   //     });
//   //   }
//   // }

//   Future <void> startDownload (int index,String Link) async {
//     if(Link=="0")
//     {
//        print("ZVideo link is $Link");
//     return;

//     }
   


//      try{
      

//       Directory appDocDir = await getApplicationDocumentsDirectory();
//     //  String applicationId = await getApplicationId();
//       String savePath = appDocDir.path + '\\com.si.dthLive' + '\\Downloaded_videos' + '\\video.mp4';
//       await dio.download(
//         Link,
//         savePath,
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             double progress = (received / total * 100);
//             setState(() {
//               downloadProgress[index] = progress;
//             });
//           }
//         },

//       );
//       setState(() {
//         _videoFilePath = savePath;
//       });
// print('${savePath} video saved to this location shubha');
// // insert

// insertVideoDownloadPath(getx.alwaysShowChapterfilesOfVideo[index]["FileId"],getx.alwaysShowChapterfilesOfVideo[index]["PackageId"],savePath);

//     }catch(e){}
//   }


// // Future<String> getApplicationId() async {
// //   try {
// //     PackageInfo packageInfo = await PackageInfo.fromPlatform();
// //     String applicationId = packageInfo.;
// //     print('${applicationId} this  is the package id shubha');

// //     return applicationId;
// //   } catch (e) {
// //     print('${e} shubha');
// //     return 'fgyuhrty';
// //   }
// // }

//     late final Dio dio;
//   double _progress = 0.0;
//   String? _videoFilePath;

//   @override
//   void initState() {
//     super.initState();
//     dio = Dio();
//   }
// }

// class Tags extends StatefulWidget {
//   const Tags({super.key});

//   @override
//   State<Tags> createState() => _TagsState();
// }

// class _TagsState extends State<Tags> {
//   @override

// List<Map<String, dynamic>> data = [
//   {"tagname": "data structure & algorithm", "tag": "00:04:12"},
//   {"tagname": "object-oriented programming", "tag": "00:03:45"},
//   {"tagname": "design patterns", "tag": "00:02:30"},
//   {"tagname": "database management", "tag": "00:05:15"},
//   {"tagname": "networking basics", "tag": "00:06:20"},
//   {"tagname": "operating systems", "tag": "00:04:50"},
//   {"tagname": "cloud computing", "tag": "00:03:10"},
//   {"tagname": "machine learning", "tag": "00:07:35"},
//   {"tagname": "artificial intelligence", "tag": "00:08:40"},
//   {"tagname": "web development", "tag": "00:02:55"},
//   {"tagname": "mobile app development", "tag": "00:04:25"},
//   {"tagname": "version control (Git)", "tag": "00:03:05"},
//   {"tagname": "cybersecurity", "tag": "00:05:40"},
//   {"tagname": "software testing", "tag": "00:04:00"},
//   {"tagname": "agile methodologies", "tag": "00:03:20"},
//   {"tagname": "DevOps practices", "tag": "00:06:00"},
//   {"tagname": "big data analytics", "tag": "00:07:50"},
//   {"tagname": "blockchain technology", "tag": "00:09:10"},
//   {"tagname": "robotics", "tag": "00:08:25"},
//   {"tagname": "Internet of Things (IoT)", "tag": "00:06:15"},
// ];



//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 800,
//       child: ScrollConfiguration(
//         behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
//         child: ListView.builder(
//           itemCount: data.length,
//           itemBuilder: (context, index) {
//           return Material(
            
//             color: Colors.transparent,
//             child: ListTile(
//               onTap: (){},

//               title: Text(data[index]['tagname'],style: styleb.copyWith(fontSize: 16,color: Colors.grey[700]),),
//               subtitle: Text(data[index]['tag'],style: styleb.copyWith(fontSize: 14,color: Colors.grey[500]),),
//               leading: Icon(Icons.timeline,size: 18,) ,
//               trailing: Icon(Icons.arrow_forward_ios_rounded,size: 15,),
//               ),
//           );
//         },),
//       ),
//     );
// }
// }

// // Dummy widgets for Pdf() and Mcq()
// // class Pdf extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //   }
// // }

// // class Mcq extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //   }
// // }

// // Dummy class for ColorPage
// // class ColorPage {
// //   static const white = Colors.white;
// //   static const colorbutton = Colors.blue;
// //   static const grey = Colors.grey;
// // }

// // // Dummy class for FontFamily
// // class FontFamily {
// //   static const font = TextStyle();
// //   static const font8 = TextStyle();
// // }

// // Dummy class for HideScrollbarBehavior
// class HideScrollbarBehavior extends ScrollBehavior {
//   @override
//   Widget buildViewportChrome(
//       BuildContext context, Widget child, AxisDirection axisDirection) {
//     return child;
//   }
// }

// // Dummy class for LinearBorder
// class LinearBorder extends ShapeBorder {
//   @override
//   EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
//     return Path();
//   }

//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     return Path();
//   }

//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

//   @override
//   ShapeBorder scale(double t) {
//     return LinearBorder();
//   }
// }

// class Mcq extends StatefulWidget {
//   const Mcq({super.key});

//   @override
//   State<Mcq> createState() => _McqState();
// }

// class _McqState extends State<Mcq> {
//   List<Map<int, int>> answer = [
//     {1: 2},
//     {2: 3},
//     {3: 2},
//     {4: 1},
//     {5: 1},
//     {6: 1},
//     {7: 2},
//     {8: 1},
//     {9: 2},
//     {10: 1},
//   ];
//   Map<int, int> userAns = {};

//   Getx getx_obj = Get.put(Getx());
//   RxBool buttonshow = false.obs;

//   PageController _pageController = PageController();

//   Future getdata() async {
//     String jsonData = '''
// [
//   {
//     "mcqId": 1,
//     "mcqType": "SimpleMcq",
//     "mcqQuestion": "Who is the leader of the Avengers?",
//     "options": [
//       {"optionId": 1, "optionName": "Iron Man"},
//       {"optionId": 2, "optionName": "Captain America"},
//       {"optionId": 3, "optionName": "Thor"},
//       {"optionId": 4, "optionName": "Hulk"}
//     ]
//   },
//   {
//     "mcqId": 2,
//     "mcqType": "SimpleMcq",
//     "mcqQuestion": "What is the name of Thor's hammer?",
//     "options": [
//       {"optionId": 1, "optionName": "Stormbreaker"},
//       {"optionId": 2, "optionName": "Mjolnir"},
//       {"optionId": 3, "optionName": "Gungnir"},
//       {"optionId": 4, "optionName": "Hofund"}
//     ]
//   },
//   {
//     "mcqId": 3,
//     "mcqType": "VideoBasedQuestion",
//     "mcqQuestion": "Which infinity stone does Vision have?",
//     "videoUrl": "https://www.youtube.com/embed/fPyGnlct1o0?si=LksYWMaAg-Oerj1D",
//     "options": [
//       {"optionId": 1, "optionName": "Mind Stone"},
//       {"optionId": 2, "optionName": "Space Stone"},
//       {"optionId": 3, "optionName": "Reality Stone"},
//       {"optionId": 4, "optionName": "Time Stone"}
//     ]
//   },
//   {
//     "mcqId": 4,
//     "mcqType": "SimpleMcq",
//     "mcqQuestion": "Who is Tony Stark's father asjdsahgdhgfuysd gczxbczhg csdfc gzjz hxgcy ugfhdb chxzgc sdfbdsc zhbch jgcbsdh gcsdy gfsdcgc fsdbvxch csdgd h cbjgcufsd?",
//     "options": [
//       {"optionId": 1, "optionName": "Howard Stark"},
//       {"optionId": 2, "optionName": "Steve Rogers"},
//       {"optionId": 3, "optionName": "Nick Fury"},
//       {"optionId": 4, "optionName": "Bruce Banner"}
//     ]
//   },
//   {
//     "mcqId": 5,
//     "mcqType": "SimpleMcq",
//     "mcqQuestion": "What is the real name of Black Panther?",
//     "options": [
//       {"optionId": 1, "optionName": "T'Challa"},
//       {"optionId": 2, "optionName": "M'Baku"},
//       {"optionId": 3, "optionName": "N'Jadaka"},
//       {"optionId": 4, "optionName": "Okoye"}
//     ]
//   },
//   {
//     "mcqId": 6,
//     "mcqType": "SimpleMcq",
//     "mcqQuestion": "Which Avenger is from Asgard?",
//     "options": [
//       {"optionId": 1, "optionName": "Thor"},
//       {"optionId": 2, "optionName": "Hulk"},
//       {"optionId": 3, "optionName": "Black Widow"},
//       {"optionId": 4, "optionName": "Hawkeye"},
//       {"optionId": 5, "optionName": "Hawkeye2"},
//       {"optionId": 6, "optionName": "Hawkeye3"}
//     ]
//   },
//   {
//     "mcqId": 7,
//     "mcqType": "SimpleMcq",
//     "mcqQuestion": "Who is the villain in 'Avengers: Infinity War'?",
//     "options": [
//       {"optionId": 1, "optionName": "Loki"},
//       {"optionId": 2, "optionName": "Thanos"},
//       {"optionId": 3, "optionName": "Ultron"},
//       {"optionId": 4, "optionName": "Red Skull"}
//     ]
//   },
//   {
//     "mcqId": 8,
//     "mcqType": "SimpleMcq",
//     "mcqQuestion": "What is the name of Black Widow?",
//     "options": [
//       {"optionId": 1, "optionName": "Natasha Romanoff"},
//       {"optionId": 2, "optionName": "Wanda Maximoff"},
//       {"optionId": 3, "optionName": "Carol Danvers"},
//       {"optionId": 4, "optionName": "Hope van Dyne"}
//     ]
//   },
//   {
//     "mcqId": 9,
//     "mcqType": "SimpleMcq",
//     "mcqQuestion": "Who is the first Avenger?",
//     "options": [
//       {"optionId": 1, "optionName": "Iron Man"},
//       {"optionId": 2, "optionName": "Captain America"},
//       {"optionId": 3, "optionName": "Thor"},
//       {"optionId": 4, "optionName": "Hulk"}
//     ]
//   },
//   {
//     "mcqId": 10,
//     "mcqType": "ImageBasedQuestion",
//     "imageUrl": "https://e0.pxfuel.com/wallpapers/778/909/desktop-wallpaper-thanos-thanos-army-darkseid-vs-thanos.jpg",
//     "mcqQuestion": "What is the name of the army led by Thanos?",
//     "options": [
//       {"optionId": 1, "optionName": "Chitauri"},
//       {"optionId": 2, "optionName": "Kree"},
//       {"optionId": 3, "optionName": "Skrulls"},
//       {"optionId": 4, "optionName": "Dark Elves"}
//     ]
//   }
// ]
// ''';

//     List<dynamic> parsedJson = jsonDecode(jsonData);
//     List<McqItem> mcqDatalist =
//         parsedJson.map((json) => McqItem.fromJson(json)).toList();
//     mcqData = mcqDatalist;
//   }

//   @override
//   void initState() {
//     super.initState();
//     getdata().whenComplete(() => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   String groupname = ' All Questions';

//   List<int> reviewlist = [];

//   RxInt qindex = 0.obs;
//   int selectedIndex = -1;
//   RxBool isSubmitted = false.obs;
//   RxInt score = 0.obs;

//   List<McqItem> mcqData = [];

//   @override
//   Widget build(BuildContext context) {
//     // double height = MediaQuery.of(context).size.height;
//     return Container(
//       height: 800,
//       child: PageView.builder(
//         controller: _pageController,
//         onPageChanged: (index) {
//           qindex.value = index;
//         },
//         itemCount: mcqData.length,
//         itemBuilder: (context, index) {
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//                   child: Column(
//                     children: [
//                       SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       offset: Offset(8, 8),
//                                       blurRadius: 10,
//                                     )
//                                   ]),
//                               padding: EdgeInsets.symmetric(vertical: 15),
//                               child: Column(
//                                 children: [
//                                   SizedBox(
//                                     width: 20,
//                                   ),
//                                   Text(
//                                     textAlign: TextAlign.center,
//                                     mcqData[index].mcqQuestion,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 20),
//                                   ),
//                                   if (mcqData[index].imageUrl != null)
//                                     Padding(
//                                       padding: const EdgeInsets.all(15),
//                                       child: Image.network(
//                                           mcqData[index].imageUrl!),
//                                     ),
//                                   if (mcqData[index].videoUrl != null)
//                                     Container(
//                                       margin:
//                                           EdgeInsets.symmetric(vertical: 20),
//                                       child: AspectRatio(
//                                         aspectRatio: 16 / 9,
//                                       ),
//                                     ),
//                                   Container(
//                                     margin: EdgeInsets.symmetric(
//                                         vertical: 20, horizontal: 10),
//                                     color: Colors.black26,
//                                     height: 3,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(right: 10),
//                                         child: Text(
//                                           "${index + 1} / ${mcqData.length}",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 12),
//                                         ),
//                                       )
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//                   child: SizedBox(
//                     height: 600,
//                     child: Column(
//                       children: [
//                         SizedBox(height: 20),
//                         Expanded(
//                           child: ListView.builder(
//                             physics: mcqData[index].options.length < 5
//                                 ? NeverScrollableScrollPhysics()
//                                 : AlwaysScrollableScrollPhysics(),
//                             itemCount: mcqData[index].options.length,
//                             itemBuilder: (context, optionIndex) {
//                               int optionId =
//                                   mcqData[index].options[optionIndex].optionId;
//                               int questionId = mcqData[index].mcqId;
//                               bool isSelected = userAns[questionId] == optionId;
//                               bool isCorrect = answer
//                                   .any((map) => map[questionId] == optionId);
//                               bool isAnswered = userAns.containsKey(questionId);
                                        
//                               Color tileColor;
//                               if (isSubmitted.value) {
//                                 if (isCorrect) {
//                                   tileColor = Colors.green;
//                                 } else if (isSelected && !isCorrect) {
//                                   tileColor = Colors.red;
//                                 } else {
//                                   tileColor = Colors.white;
//                                 }
//                               } else {
//                                 tileColor =
//                                     isSelected ? Colors.blue : Colors.white;
//                               }
                                        
//                               return Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 10),
//                                 child: AnimatedContainer(
//                                   duration: Duration(milliseconds: 600),
//                                   curve: Curves.easeInOut,
//                                   height: 60,
//                                   decoration: BoxDecoration(
//                                     color: tileColor,
//                                     borderRadius: BorderRadius.circular(8),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black12,
//                                         blurRadius: 10,
//                                         offset: Offset(0, 5),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Material(
//                                     color: Colors.transparent,
//                                     child: InkWell(
//                                       borderRadius: BorderRadius.circular(8),
//                                       onTap: () {
//                                         setState(() {
//                                           if (!isSubmitted.value) {
//                                             userAns[questionId] = optionId;
//                                           }
//                                         });
//                                       },
//                                       child: Row(
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.symmetric(
//                                                 horizontal: 16),
//                                             child: Text(
//                                               mcqData[index]
//                                                   .options[optionIndex]
//                                                   .optionName,
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             MaterialButton(
//                               height: 40,
//                               color: ColorPage.appbarcolorcopy,
//                               padding: EdgeInsets.all(16),
//                               shape: ContinuousRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               onPressed: () {
//                                 if (index > 0) {
//                                   _pageController.previousPage(
//                                     duration: Duration(milliseconds: 300),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 }
//                               },
//                               child: Text(
//                                 'Previous',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             MaterialButton(
//                               height: 40,
//                               color: ColorPage.appbarcolorcopy,
//                               padding: EdgeInsets.all(16),
//                               shape: ContinuousRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               onPressed: () {
//                                 if (index < mcqData.length - 1) {
//                                   _pageController.nextPage(
//                                     duration: Duration(milliseconds: 300),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 } else if (index == mcqData.length - 1 &&
//                                     !isSubmitted.value) {
//                                   mcqData.length - 1 == answer.length
//                                       ? _onSubmitExam(context)
//                                       : _onincompleteSubmission(context);
//                                 }
//                               },
//                               child: Text(
//                                 !isSubmitted.value &&
//                                         index == mcqData.length - 1
//                                     ? 'Submit'
//                                     : 'Next',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   _onSubmitExam(context) {
//     int correctAnswers = 0;
//     userAns.forEach((questionId, selectedOptionId) {
//       if (answer.any((map) => map[questionId] == selectedOptionId)) {
//         correctAnswers++;
//       }
//     });
//     print(correctAnswers.toString());

//     Alert(
//       context: context,
//       type: AlertType.info,
//       style: AlertStyle(
//         animationType: AnimationType.fromLeft,
//         titleStyle:
//             TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
//         descStyle: FontFamily.font6,
//         isCloseButton: false,
//       ),
//       title: "Are You Sure?",
//       desc:
//           "Once You submit, You can't Change your Sheet \n If you are sure then Click on 'Yes' Button",
//       buttons: [
//         DialogButton(
//           child: Text("Cancel",
//               style: TextStyle(color: Colors.white, fontSize: 18)),
//           highlightColor: Color.fromRGBO(77, 3, 3, 1),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           color: Color.fromRGBO(158, 9, 9, 1),
//         ),
//         DialogButton(
//           child:
//               Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
//           highlightColor: Color.fromRGBO(77, 3, 3, 1),
//           onPressed: () {
//             score.value = correctAnswers;

//             isSubmitted.value = true;
//             Navigator.pop(context);
//             // Get.toNamed("/Mocktestrankpagemobile",arguments:{"mcqData":mcqData,"correctAnswers":answer,"userAns":userAns,'totalnumber':correctAnswers});
//           },
//           color: Color.fromRGBO(9, 89, 158, 1),
//         ),
//       ],
//     ).show();
//   }

//   _onincompleteSubmission(context) {
//     Alert(
//       context: context,
//       type: AlertType.info,
//       style: AlertStyle(
//         animationType: AnimationType.fromLeft,
//         titleStyle:
//             TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
//         descStyle: FontFamily.font6,
//         isCloseButton: false,
//       ),
//       title: "Your Sheet is Incomplete",
//       desc:
//           "Your Answer sheet is Incomplete. \n Are you Sure to Submit then Click on Yes Button.  ",
//       buttons: [
//         DialogButton(
//           child: Text("Cancel",
//               style: TextStyle(color: Colors.white, fontSize: 18)),
//           highlightColor: Color.fromRGBO(77, 3, 3, 1),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           color: Color.fromRGBO(177, 58, 58, 1),
//         ),
//         DialogButton(
//           child:
//               Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
//           highlightColor: Color.fromRGBO(3, 77, 59, 1),
//           onPressed: () {
//             setState(() {
//               isSubmitted.value = true;
//             });
//             Navigator.pop(context);
//           },
//           color: Color.fromRGBO(9, 89, 158, 1),
//         ),
//       ],
//     ).show();
//   }



  
// }
