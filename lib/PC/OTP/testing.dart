// import 'dart:io';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:tray_icon/getxcontroller.dart';
// import 'package:tray_icon/main.dart';
// import 'package:tray_icon/notifications/notifications_api.dart';
// import 'package:tray_icon/notifications/when_to_start_notification.dart';

// import 'package:tray_icon/titlebar/title_bar.dart';
// import 'package:win32/win32.dart';
// import 'package:window_manager/window_manager.dart';

// class SelectApplication extends StatefulWidget {
//   const SelectApplication({super.key});

//   @override
//   State<SelectApplication> createState() => SelectApplicationState();
// }

// class SelectApplicationState extends State<SelectApplication> {
//   ExeRun ob = ExeRun();

//   final NotificationAllapi api = Get.put(NotificationAllapi());
//   final WhenToStartNotification start = Get.put(WhenToStartNotification());
//   @override
//   void initState() {
//     start.readNotificationsFromFileToRunExe();
//     api.getnotification();
//     // TODO: implement initState
//     super.initState();
//   }

// // to call
//   // NotificationsController controller = Get.put(NotificationsController());

//   // // Start monitoring the folder
//   // await controller.readNotificationsFromFile().whenComplete(() {
//   //   controller.showWithLargeImage();
//   // });

// // Getx getx=Get.put(Getx());
//   Future<void> createTextFile(String filename) async {
//     final directory = Directory.current;
//     // Get the current directory
//     final filePath = '${directory.path}/$filename';

//     // Create the file path

//     // Create the file and write content
//     final file = File(filePath);

//     file.writeAsStringSync("h");

//     print('File created at: $filePath');
//   }

//   void minimizeWindow() {
//     // Find the current window handle
//     final hwnd = GetForegroundWindow();

//     // Minimize the window
//     ShowWindow(hwnd, SHOW_WINDOW_CMD.SW_MINIMIZE);
//   }

//   Getx getx = Get.put(Getx());
//   @override
//   Widget build(BuildContext context) {
//     windowManager.setSize(Size(900, 500));
//     windowManager.center(animate: true);
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 224, 222, 222),
//       body: Container(
//         decoration: BoxDecoration(
//           color: Colors.black12,
//           image: DecorationImage(
//               image: AssetImage(
//                 "assets/settingsbg2.png",
//               ),
//               fit: BoxFit.cover),
//         ),
//         child: Column(
//           children: [
//             TitleBar(Getx.app_logopath.value),
//             Divider(),
//             Expanded(
//               child: Container(
//                 child: Column(
//                   children: [
//                     Column(
//                       // mainAxisAlignment: MainAxisAlignment.center,
//                       // c
//                       children: [
//                         SizedBox(
//                           height: 50,
//                           child: AnimatedTextKit(
//                             repeatForever: true,
//                             animatedTexts: [
//                               // WavyAnimatedText('Gateway',
//                               //     textStyle: TextStyle(
//                               //         fontFamily: 'AUTAS',
//                               //         fontWeight: FontWeight.w800,
//                               //         fontSize: 30)),
//                               TyperAnimatedText('Gateway',
//                                   speed: Duration(milliseconds: 200),
//                                   textStyle: TextStyle(
//                                       fontFamily: 'AUTAS',
//                                       fontWeight: FontWeight.w800,
//                                       fontSize: 30)),
//                               // FlickerAnimatedText(
//                               //     speed: Duration(milliseconds: 1000),
//                               //     'Gateway',
//                               //     textStyle: TextStyle(
//                               //         fontFamily: 'AUTAS',
//                               //         fontWeight: FontWeight.w800,
//                               //         fontSize: 30)
//                               //         ),
//                             ],
//                             onTap: () {
//                               print("Tap Event");
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             DialogButton(
//                               height: MediaQuery.of(context).size.width / 3.5,
//                               width: MediaQuery.of(context).size.width / 2.7,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.video_settings_sharp,
//                                     size: 50,
//                                     color: Colors.white,
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   Text(
//                                     "Encryptor",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontFamily: 'PlaywriteID'),
//                                   ),
//                                 ],
//                               ),
//                               onPressed: () {
//                                 // createTextFile("Eon.txt");
//                                 ob.checkEncryptorExeRunning();

//                                 setState(() {});
//                               },
//                               color: Color.fromRGBO(79, 76, 121, 1),
//                             ),
//                             DialogButton(
//                               height: MediaQuery.of(context).size.width / 3.5,
//                               width: MediaQuery.of(context).size.width / 2.7,
//                               // width: MediaQuery.of(context).size.width/2.5,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.video_chat,
//                                     size: 60,
//                                     color: Colors.white,
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   Text(
//                                     "Live",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 20,
//                                         fontFamily: 'PlaywriteID'),
//                                   ),
//                                 ],
//                               ),
//                               onPressed: () {
//                                 ob.runLiveExe();
//                               },
//                               gradient: LinearGradient(colors: [
//                                 Color.fromRGBO(37, 95, 172, 1),
//                                 Color.fromRGBO(52, 138, 199, 1.0)
//                               ]),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }