import 'dart:async';
import 'dart:developer';
// import 'package:dlpencryptor_live/Mobile/popupmenu.dart';
// import 'package:dlpencryptor_live/widget/remote_stream_widget.dart';
// import 'package:dthlms/MOBILE/live/local_sdk/inapi_core_sdk/lib/src/enums/participant_roles.dart';
// import 'package:dthlms/MOBILE/live/local_sdk/inapi_core_sdk/lib/src/inmeet_implementations.dart';
// import 'package:dthlms/MOBILE/live/getx.dart';

import 'package:dthlms/ACTIVATION_WIDGET/enebelActivationcode.dart';
import 'package:dthlms/Live/chatwidget.dart';
import 'package:dthlms/Live/popupmenu.dart';
import 'package:dthlms/constants/constants.dart';
import 'package:dthlms/log.dart';
import 'package:dthlms/youtube/youtubelive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:get/state_manager.dart';
// import 'package:inapi_core_sdk/inapi_core_sdk.dart';
// import 'package:intl/intl.dart';
// import 'package:dlpencryptor_live/createtopic.dart';
// import 'package:dlpencryptor_live/fullscreen.dart';
// import 'package:dlpencryptor_live/getx.dart';
// import 'package:dlpencryptor_live/vc_controller.dart';
// import 'package:dlpencryptor_live/widget/chatwidget.dart';
// import 'package:dlpencryptor_live/widget/teacherpoll.dart';
// import 'package:dlpencryptor_live/widget/titlebar/title_bar.dart';
// import 'widget/remote_stream_widget.dart';
import 'dart:ui';

import 'package:inapi_core_sdk/inapi_core_sdk.dart';

import 'mobilegetx.dart';
import 'peer_model.dart';
import 'vc_controller.dart';
import 'vc_methods.dart';
import 'widget/remote_stream_widget.dart';

class GlassBox extends StatelessWidget {
  final child;
  const GlassBox({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        ),
      ),
    );
  }
}

enum Menu { camera, mic, management, chat, video }

enum AnimationStyles { defaultStyle, custom, none }

const List<(AnimationStyles, String)> animationStyleSegments =
    <(AnimationStyles, String)>[
  (AnimationStyles.defaultStyle, 'Default'),
  (AnimationStyles.custom, 'Custom'),
  (AnimationStyles.none, 'None'),
];

class MobileMeetingPage extends StatefulWidget {
  // String? sessionId;

  // String userid;
  // String username;
  // String packageName;
  String projectId;
  String? sessionId;
  String userid;
  String username;
  String packageName;
  // List<String> args;
  String videoCategory;
  String? link = '';

  MobileMeetingPage(this.projectId, this.sessionId, this.userid, this.username,
      this.packageName, this.link,
      {this.videoCategory = "YouTube", super.key});

  @override
  State<MobileMeetingPage> createState() => _MobileMeetingPageState();
}

class _MobileMeetingPageState extends State<MobileMeetingPage> {
  Timer? timer;

  List img = [
    'assets/image9.jpg',
    'assets/image8.jpg',
    'assets/image7.jpg',
    'assets/image6.jpg',
    'assets/image5.jpg',
    'assets/image4.jpg',
    'assets/image3.jpg',
    'assets/image2.jpg',
    'assets/image9.jpg'
  ];

// Styles
  Color deviderColors = const Color.fromARGB(255, 90, 90, 92);
  Color scaffoldColor = const Color(0xff1B1A1D);
  Color topTextColor = const Color(0xffDFDEDF);
  Color topTextClockColor = const Color(0xffB3B6B5);
  Color timerBoxColor = const Color(0xff2B2D2E);
  Color searchBoxColor = const Color(0xff27292D);
  Color searchBoxTextColor = const Color(0xff747677);
  Color bottomBoxColor = const Color(0xff27292B);
  Color micOffColor = const Color(0xffD95140);

  TextEditingController c = TextEditingController();
  String? selectedAudioOutputDevice;
  String? selectedVideoOutputDevice;

  RxBool pollOption = false.obs;

  Future<void> playSound() async {
    // Path to the .opus file in the assets folder
    final soundPath = 'sound.mp3';

    try {
      // Load and play the .opus sound from the assets   await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      writeToFile(e, "mobileVc screen");
      print(soundPath);
      print('Error playing sound: $e');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await InMeetClient.instance.getAvailableDeviceInfo();
      Get.find<VcController>().assigningRenderer();
    });
    onUserJoinMeeting();

    super.initState();
  }

  void onUserJoinMeeting() async {
    if (widget.videoCategory == "YouTube") {
    } else {
      vcController.inMeetClient.init(
        socketUrl: 'wss://wriety.inmeet.ai',
        projectId: widget.projectId, // Project ID from args
        userName: widget.username, // Username from args
        userId: widget.userid, //
        listener: VcEventsAndMethods(vcController: vcController),
      );

      await vcController.inMeetClient
          .join(sessionId: widget.sessionId.toString());

      log(widget.sessionId.toString());
      log(widget.userid.toString());
      log(widget.username.toString());

      await MeetingService.joinMeeting(widget.sessionId.toString(),
          widget.userid.toString(), widget.username);
      print(
          "User ${widget.username} (${widget.userid}) joined the meeting with session ID ${widget.sessionId}.");
    }

    await MeetingService.joinMeeting(
        widget.sessionId.toString(), widget.userid.toString(), widget.username);
  }

  @override
  void dispose() {
    if (widget.videoCategory == "YouTube") {
    } else {
      timer?.cancel();
      if (vcController.selfRole.contains(ParticipantRoles.moderator)) {
        inMeetClient.endMeetingForAll();
        inMeetClient.endBreakoutRooms();
        vcController.isBreakoutStarted = false;
      } else {
        inMeetClient.exitMeeting();
        inMeetClient.disableWebcam();

        print('object');
      }
    }

    super.dispose();
  }

  final inMeetClient = InMeetClient.instance;
  VcController vcController = Get.put(VcController());

  RxString time = ''.obs;

  // Styles
  Color leftBackgroundColor = const Color(0Xff161B21);
  Color rightBackgroundColor = const Color(0Xff1F272F);
  Color greencolor = const Color(0Xff15E8D8);
  Color btnColor = const Color(0Xff2D3237);
  Color chatConColor = const Color(0XffD9D9D9);
  Color chatSelectedColor = const Color(0Xff2D3237);
  Color chatUnSelectedColor = const Color(0XffFFFFFF);
  Color chatBoxColor = const Color(0XffC9E1FF);

  var rightBorderRadious = const Radius.circular(20);
  RxInt rightBarIndex = 0.obs;
  RxBool chatMood = true.obs;
  RxBool topicChecValue = true.obs;

  // String _selectedValue = 'Option 1'; // Default selected value
  // List<String> _dropdownItems = ['Option 1', 'Option 2', 'Option 3'];

  Widget showDropdown({
    required BuildContext context,
    required List<String> items,
    required String selectedValue,
    required void Function(String?) onChanged,
  }) {
    return DropdownButton<String>(
      value: selectedValue,
      icon: const Icon(CupertinoIcons.down_arrow),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  AnimationStyle? _animationStyle;
  Future back() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomLogoutDialog(
              title: "You're close the meeting...\nAre you sure?",
              description: '',
              ok: () {
                if (vcController.selfRole
                    .contains(ParticipantRoles.moderator)) {
                  inMeetClient.endMeetingForAll();
                  inMeetClient.endBreakoutRooms();
                  vcController.isBreakoutStarted = false;
                } else {
                  inMeetClient.exitMeeting();
                  inMeetClient.disableWebcam();

                  print('object');
                }
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle rightBarTopTextStyle = const TextStyle(
        fontFamily: 'ocenwide', color: Colors.white, fontSize: 16);

    final offButtonTheme = IconButton.styleFrom(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    );

    return WillPopScope(
      onWillPop: () async {
        return await back();
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(widget.packageName.toString(),
                style: const TextStyle(
                    fontSize: 20, fontFamily: 'ocenwide', color: Colors.black)),
            leading: Image.asset(
              logopath,
              height: 40,
            ),
          ),
          body: GetBuilder<VcController>(builder: (vcController) {
            if (!vcController.isRoomJoined.value &&
                widget.videoCategory == 'Live1') {
              return Material(
                color: Colors.transparent,
                child: const Center(
                  child: Text(
                    'Wait for a moment',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              );
              // playSound();
            }
            return SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // right side main screen
                        Positioned.fill(
                            // top: 30,
                            child: Row(
                          children: [
                            // Left main screen content

                            Expanded(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center vertically
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          widget.videoCategory == "YouTube"
                                              ? YoutubeLive(widget.link,
                                                  widget.username, true)
                                              : Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        // Adjust the flex value as needed
                                                        child: Container(

                                                            // ),
                                                            child: Center(
                                                          child: Stack(
                                                            children: [
                                                              // Use a Column to stack widgets vertically
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center, // Center content vertically
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child: GetBuilder<
                                                                        VcController>(
                                                                      builder:
                                                                          (vcController) {
                                                                        // Combine peers and screen-sharing peers
                                                                        List<Peer>
                                                                            allPeers =
                                                                            [];

                                                                        // Add peers who are not screen-sharing
                                                                        allPeers.addAll(vcController
                                                                            .peersList
                                                                            .values
                                                                            .where((peer) {
                                                                          return !(vcController
                                                                              .screenShareList
                                                                              .contains(peer));
                                                                        }));

                                                                        // Add screen-sharing peers
                                                                        allPeers
                                                                            .addAll(vcController.screenShareList);

                                                                        if (allPeers
                                                                            .isEmpty) {
                                                                          // No peers to display
                                                                          return Center(
                                                                            child:
                                                                                Text(
                                                                              'No video available',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 18,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }

                                                                        // Build the list of RemoteStreamWidgets
                                                                        return ListView
                                                                            .builder(
                                                                          // shrinkWrap: true,
                                                                          itemCount:
                                                                              allPeers.length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            final peer =
                                                                                allPeers[index];
                                                                            final isScreenShare =
                                                                                vcController.screenShareList.contains(peer);

                                                                            return RemoteStreamWidget(
                                                                              peer: peer,
                                                                              isScreenShare: isScreenShare,
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                        // const SizedBox(
                                                        //   width: 25,
                                                        // )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                          //  widget.videoCategory == "YouTube"?SizedBox()  :
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 25,
                                              horizontal: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                widget.videoCategory ==
                                                        "YouTube"
                                                    ? SizedBox()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 0),
                                                        child: IconButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.red[400],
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              8)),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder: (context) =>
                                                                  CustomLogoutDialog(
                                                                title:
                                                                    "You're close the meeting...\nAre you sure?",
                                                                description: '',
                                                                ok: () {},
                                                              ),
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.phone,
                                                            color: Colors.white,
                                                          ),
                                                        ),

                                                        // CupertinoButton(
                                                        //   color: CupertinoColors.systemRed,
                                                        //   padding: EdgeInsets.symmetric(horizontal: 3),
                                                        //     // style: TextButton.styleFrom(
                                                        //     //   backgroundColor:
                                                        //     //   Colors.red[400],
                                                        //     //   shape:
                                                        //     //   const RoundedRectangleBorder(
                                                        //     //     borderRadius:
                                                        //     //     BorderRadius.all(
                                                        //     //         Radius.circular(8)),
                                                        //     //   ),
                                                        //     // ),
                                                        //     onPressed: () {
                                                        //       // turned off by shubha
                                                        //       // showDialog(
                                                        //       //   barrierDismissible: false,
                                                        //       //   context: context,
                                                        //       //   builder: (context) =>
                                                        //       //       CustomLogoutDialog(
                                                        //       //           index: 0),
                                                        //       // ).then((value) =>
                                                        //       // value['id'] == 1
                                                        //       //     ? Navigator.pop(context)
                                                        //       //     : null);
                                                        //     },
                                                        //     child: Icon(CupertinoIcons.phone)),
                                                        //
                                                      ),

                                                Row(
                                                  children: [
                                                    widget.videoCategory ==
                                                            "YouTube"
                                                        ? SizedBox()
                                                        : Row(
                                                            children: [
                                                              PopupMenuButton<
                                                                  String>(
                                                                popUpAnimationStyle:
                                                                    _animationStyle,
                                                                icon:
                                                                    const Icon(
                                                                  CupertinoIcons
                                                                      .chevron_down,
                                                                  size: 12,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                onSelected: (String
                                                                    selectedItem) {
                                                                  // Handle the selected item
                                                                  print(
                                                                      'Selected: $selectedItem');
                                                                },
                                                                itemBuilder:
                                                                    (BuildContext
                                                                        context) {
                                                                  // Create a list of PopupMenuEntry
                                                                  List<PopupMenuEntry<String>>
                                                                      menuItems =
                                                                      [];

                                                                  // Add the audio output items
                                                                  menuItems.addAll(
                                                                      vcController
                                                                          .audioOutput
                                                                          .map(
                                                                              (e) {
                                                                    return PopupMenuItem<
                                                                        String>(
                                                                      value: e,
                                                                      child:
                                                                          Text(
                                                                        e,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                'ocenwide',
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    );
                                                                  }).toList());

                                                                  return menuItems;
                                                                },
                                                              ),
                                                            ],
                                                          ),

                                                    widget.videoCategory ==
                                                            "YouTube"
                                                        ? SizedBox()
                                                        : Row(
                                                            children: [
                                                              // Display the small FloatingActionButton if there are audio input or output options
                                                              if (vcController
                                                                      .audioInput
                                                                      .isNotEmpty ||
                                                                  vcController
                                                                      .audioOutput
                                                                      .isNotEmpty)
                                                                FloatingActionButton(
                                                                    mini: true,
                                                                    heroTag:
                                                                        'mic',
                                                                    backgroundColor:
                                                                        btnColor,
                                                                    onPressed:
                                                                        () {
                                                                      try {
                                                                        if (vcController.micStreamStatus == ButtonStatus.off &&
                                                                            vcController
                                                                                .audioInput.isNotEmpty) {
                                                                          vcController
                                                                              .changeMicSreamStatus(ButtonStatus.loading);
                                                                          inMeetClient
                                                                              .unmuteMic(vcController.selectedAudioInputDeviceId);
                                                                        } else if (vcController
                                                                            .audioInput
                                                                            .isNotEmpty) {
                                                                          vcController
                                                                              .changeMicSreamStatus(ButtonStatus.loading);
                                                                          inMeetClient
                                                                              .muteMic();
                                                                        }
                                                                      } catch (e) {
                                                                        writeToFile(
                                                                            e,
                                                                            "mobile vc Screen");
                                                                        // Handle any exceptions here, e.g., show an error message
                                                                        print(
                                                                            'Error: $e');
                                                                      }
                                                                    },
                                                                    child: vcController.micStreamStatus ==
                                                                            ButtonStatus.on
                                                                        ? Image(
                                                                            image:
                                                                                AssetImage(
                                                                              'assets/microphone.png',
                                                                            ),
                                                                            height:
                                                                                20,
                                                                            // width: 15,
                                                                          )
                                                                        : Image(
                                                                            image:
                                                                                AssetImage('assets/mute.png'),
                                                                            height:
                                                                                20,
                                                                          ))
                                                              // Otherwise, display the regular FloatingActionButton
                                                              else
                                                                FloatingActionButton(
                                                                  mini: true,
                                                                  onPressed:
                                                                      () {
                                                                    try {
                                                                      if (vcController.micStreamStatus ==
                                                                              ButtonStatus
                                                                                  .off &&
                                                                          vcController
                                                                              .audioInput
                                                                              .isNotEmpty) {
                                                                        vcController
                                                                            .changeMicSreamStatus(ButtonStatus.loading);
                                                                        inMeetClient
                                                                            .unmuteMic(vcController.selectedAudioInputDeviceId);
                                                                      } else if (vcController
                                                                          .audioInput
                                                                          .isNotEmpty) {
                                                                        vcController
                                                                            .changeMicSreamStatus(ButtonStatus.loading);
                                                                        inMeetClient
                                                                            .muteMic();
                                                                      }
                                                                    } catch (e) {
                                                                      writeToFile(
                                                                          e,
                                                                          "mobile VC Screen");
                                                                      // Handle any exceptions here, e.g., show an error message
                                                                      print(
                                                                          'Error: $e');
                                                                    }
                                                                  },
                                                                  backgroundColor:
                                                                      btnColor,
                                                                  heroTag:
                                                                      'btn2',
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/microphone.png',
                                                                    height: 20,
                                                                    filterQuality:
                                                                        FilterQuality
                                                                            .medium,
                                                                    scale: 1,
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                    Row(
                                                      children: [
                                                        widget.videoCategory ==
                                                                "YouTube"
                                                            ? SizedBox()
                                                            : PopupMenuButton<
                                                                String>(
                                                                icon: Icon(
                                                                  CupertinoIcons
                                                                      .chevron_down,
                                                                  size: 12,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                onSelected: (String
                                                                    selectedItem) {
                                                                  // Update the selected video output device
                                                                  selectedVideoOutputDevice =
                                                                      selectedItem;
                                                                  vcController.selectDevice(
                                                                      DeviceType
                                                                          .videoInput,
                                                                      selectedVideoOutputDevice!);
                                                                },
                                                                itemBuilder:
                                                                    (BuildContext
                                                                        context) {
                                                                  // Generate the menu items from vcController.videoInputs
                                                                  return vcController
                                                                      .videoInputs
                                                                      .map((e) {
                                                                    return PopupMenuItem<
                                                                        String>(
                                                                      value: e,
                                                                      child:
                                                                          Text(
                                                                        e,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'ocenwide',
                                                                          color:
                                                                              Colors.black, // You can adjust the color as needed
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).toList();
                                                                },
                                                              ),
                                                        widget.videoCategory ==
                                                                "YouTube"
                                                            ? SizedBox()
                                                            : FloatingActionButton(
                                                                mini: true,
                                                                onPressed:
                                                                    () async {
                                                                  try {
                                                                    log(vcController
                                                                        .videoInputs
                                                                        .toString());
                                                                    vcController
                                                                        .changeCameraSreamStatus(
                                                                            ButtonStatus.loading);
                                                                    if (vcController
                                                                            .localRenderer ==
                                                                        null) {
                                                                      await inMeetClient
                                                                          .enableWebcam();
                                                                    } else {
                                                                      await inMeetClient
                                                                          .disableWebcam();
                                                                      vcController
                                                                              .localRenderer =
                                                                          null;
                                                                    }
                                                                  } catch (e) {
                                                                    writeToFile(
                                                                        e,
                                                                        "mobile vc Screen");
                                                                  }
                                                                },
                                                                backgroundColor:
                                                                    btnColor,
                                                                heroTag: 'btn3',
                                                                child: vcController
                                                                            .localRenderer ==
                                                                        null
                                                                    ? Image.asset(
                                                                        'assets/video-call.png',
                                                                        height:
                                                                            15,
                                                                        filterQuality:
                                                                            FilterQuality
                                                                                .medium,
                                                                        scale:
                                                                            1)
                                                                    : Image.asset(
                                                                        'assets/video.png',
                                                                        height:
                                                                            15,
                                                                        filterQuality:
                                                                            FilterQuality
                                                                                .medium,
                                                                        scale:
                                                                            1)),
                                                      ],
                                                    ),
                                                    // const SizedBox(
                                                    //   width: 15,
                                                    // ),
                                                    widget.videoCategory ==
                                                            "YouTube"
                                                        ? SizedBox()
                                                        : FloatingActionButton
                                                            .small(
                                                            onPressed: () {
                                                              vcController
                                                                  .raiseHandSelf(
                                                                      !vcController
                                                                          .selfHandRaised);
                                                            },
                                                            backgroundColor:
                                                                btnColor,
                                                            heroTag: 'btn4',
                                                            child: Icon(
                                                              vcController
                                                                      .selfHandRaised
                                                                  ? Icons
                                                                      .do_not_touch
                                                                  : Icons
                                                                      .pan_tool_outlined,
                                                              color:
                                                                  Colors.white,
                                                              weight: 5,
                                                            ),
                                                          ),

                                                    //                   if (vcController
                                                    //                       .screenShareStatus !=
                                                    //                       ButtonStatus.off)
                                                    //                     Row(
                                                    //                       children: [
                                                    //                         FloatingActionButton(
                                                    //
                                                    // mini: true,
                                                    //                           onPressed: vcController
                                                    //                               .screenShareStatus ==
                                                    //                               ButtonStatus.loading
                                                    //                               ? null
                                                    //                               : () {
                                                    //                             try {
                                                    //                               vcController
                                                    //                                   .stopScreenShare();
                                                    //                             } catch (e) {
                                                    //                               // Handle the error (e.g., log it)
                                                    //                               print(
                                                    //                                   "Error stopping screen share: $e");
                                                    //                             }
                                                    //                           },
                                                    //                           backgroundColor: Colors.red,
                                                    //                           heroTag: 'btn4',
                                                    //                           child: Image.asset(
                                                    //                             'assets/screen.png',
                                                    //                             height: 20,
                                                    //                             filterQuality:
                                                    //                             FilterQuality.medium,
                                                    //                             scale: 1,
                                                    //                           ),
                                                    //                         ),
                                                    //                       ],
                                                    //                     )
                                                    //                   else
                                                    //                     Row(
                                                    //                       children: [
                                                    //                         FloatingActionButton(
                                                    //                           mini:true,
                                                    //                           onPressed: vcController
                                                    //                               .screenShareStatus ==
                                                    //                               ButtonStatus.loading
                                                    //                               ? null
                                                    //                               : () {
                                                    //                             try {
                                                    //                               vcController
                                                    //                                   .screenShare();
                                                    //                             } catch (e) {
                                                    //                               // Handle the error (e.g., log it)
                                                    //                               print(
                                                    //                                   "Error starting screen share: $e");
                                                    //                             }
                                                    //                           },
                                                    //                           backgroundColor: btnColor,
                                                    //                           heroTag: 'btn4',
                                                    //                           child: Image.asset(
                                                    //                             'assets/screen.png',
                                                    //                             height: 20,
                                                    //                             filterQuality:
                                                    //                             FilterQuality.medium,
                                                    //                             scale: 1,
                                                    //                           ),
                                                    //                         ),
                                                    //                       ],
                                                    //                     ),
                                                    //                   const SizedBox(
                                                    //                     width: 15,
                                                    //                   ),

                                                    widget.videoCategory ==
                                                            "YouTube"
                                                        ? FloatingActionButton
                                                            .small(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                return SafeArea(
                                                                    child:
                                                                        Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child: ChatUi(
                                                                      widget
                                                                          .sessionId
                                                                          .toString(),
                                                                      widget
                                                                          .userid,
                                                                      widget
                                                                          .username

                                                                      // username

                                                                      ),
                                                                ));
                                                              }));
                                                            },
                                                            backgroundColor:
                                                                btnColor,
                                                            heroTag: 'btn5',
                                                            child: Icon(
                                                              Icons.chat,
                                                              color:
                                                                  Colors.white,
                                                              weight: 5,
                                                            ),
                                                          )
                                                        : MyCupertinoPopupMenu(
                                                            inMeetClient:
                                                                vcController
                                                                    .inMeetClient,
                                                            sessionId: widget
                                                                .sessionId
                                                                .toString(),
                                                            userid:
                                                                widget.userid,
                                                            username:
                                                                widget.username,
                                                            vcController:
                                                                vcController,
                                                          ),
                                                  ],
                                                ),
                                                // const Expanded(
                                                //     flex: 3, child: SizedBox())
                                              ],
                                            ),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),

                        // Expanded(child: TitleBar()),

                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 45,
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
            );
          }

              // SizedBox(
              //   height: 80,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //           const SizedBox(width: 20),
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           if (vcController.audioOutput.isNotEmpty)
              //             Container(
              //               decoration: BoxDecoration(
              //                 color: Colors.blue,
              //                 borderRadius: BorderRadius.circular(8),
              //               ),
              //               padding: const EdgeInsets.symmetric(horizontal: 8),
              //               child:
              // DropdownButton<String>(
              //                 iconEnabledColor: Colors.white,
              //                 style: TextStyle(color: Colors.white),
              //                 dropdownColor: Colors.black,
              //                 value: selectedAudioOutputDevice,
              //                 underline:
              //                     Container(), // This removes the underline
              //                 items: vcController.audioOutput
              //                     .map((e) => DropdownMenuItem(
              //                           value: e,
              //                           child: Text(
              //                             e,
              //                             style: TextStyle(
              //                                 color: Colors.white,
              //                                 fontWeight: FontWeight.bold),
              //                           ),
              //                         ))
              //                     .toList(),
              //                 onChanged: (value) {
              //                   setState(() {
              //                     selectedAudioOutputDevice = value;
              //                   });
              //                   vcController.inMeetClient
              //                       .changeAudioOutput(value!);
              //                 },
              //               ),
              //             ),
              //           const SizedBox(width: 12),
              // if (vcController.audioInput.isNotEmpty ||
              //     vcController.audioOutput.isNotEmpty)
              //   FloatingActionButton.small(
              //     shape: ContinuousRectangleBorder(
              //         borderRadius: BorderRadius.circular(12)),
              //     heroTag: 'mic',
              //     backgroundColor: micOffColor,
              //     onPressed: () {
              //       try {
              //         if (vcController.micStreamStatus ==
              //                 ButtonStatus.off &&
              //             vcController.audioInput.isNotEmpty) {
              //           vcController
              //               .changeMicSreamStatus(ButtonStatus.loading);
              //           inMeetClient.unmuteMic(
              //               vcController.selectedAudioInputDeviceId);
              //         } else if (vcController.audioInput.isNotEmpty) {
              //           vcController
              //               .changeMicSreamStatus(ButtonStatus.loading);
              //           inMeetClient.muteMic();
              //         }
              //       } catch (e) {}
              //     },
              //     child: Icon(
              //       vcController.micStreamStatus == ButtonStatus.on
              //           ? Icons.mic_outlined
              //           : Icons.mic_off_outlined,
              //       color: Colors.white,
              //     ),
              //   ),
              //           const SizedBox(width: 12),
              //           if (vcController.videoInputs.isNotEmpty)
              //             Container(
              //               decoration: BoxDecoration(
              //                 color: Colors.blue,
              //                 borderRadius: BorderRadius.circular(8),
              //               ),
              //               padding: const EdgeInsets.symmetric(horizontal: 8),
              //               child:
              // DropdownButton<String>(
              //                 iconEnabledColor: Colors.white,
              //                 style: const TextStyle(color: Colors.white),
              //                 dropdownColor: Colors.black,
              //                 value: selectedVideoOutputDevice,
              //                 underline:
              //                     Container(), // This removes the underline
              //                 items: vcController.videoInputs.map((e) {
              //                   return DropdownMenuItem<String>(
              //                     value: e,
              //                     child: Text(
              //                       e,
              //                       style: const TextStyle(
              //                         color: Colors.white,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   );
              //                 }).toList(),
              //                 onChanged: (value) {
              // setState(() {
              //   selectedVideoOutputDevice = value;
              // });
              // vcController.selectDevice(DeviceType.videoInput,
              //     selectedVideoOutputDevice.toString());
              //                 },
              //               ),
              //             ),

              //           // FloatingActionButton.small(
              //           //   shape: ContinuousRectangleBorder(
              //           //       borderRadius: BorderRadius.circular(12)),
              //           //   heroTag: 'video',
              //           //   backgroundColor:
              //           //       vcController.cameraStreamStatus == ButtonStatus.off
              //           //           ? Colors.red
              //           //           : bottomBoxColor,
              //           //   onPressed: () async {
              //     // try {
              //     //   log(vcController.videoInputs.toString());
              //     //   vcController
              //     //       .changeCameraSreamStatus(ButtonStatus.loading);
              //     //   if (vcController.localRenderer == null) {
              //     //     await inMeetClient.enableWebCam(
              //     //         vcController.selectedVideoInputDeviceId);
              //     //   } else {
              //     //     await inMeetClient.disableWebcam();
              //     //     vcController.localRenderer = null;
              //     //   }
              //     // } catch (e) {}
              //           //   },
              //           //   child:
              //           // ),
              //           const SizedBox(width: 12),
              //           if (vcController.screenShareStatus != ButtonStatus.off)
              //             FloatingActionButton.small(
              //               shape: ContinuousRectangleBorder(
              //                   borderRadius: BorderRadius.circular(12)),
              //               heroTag: 'screen',
              //               backgroundColor: bottomBoxColor,
              //               onPressed: vcController.screenShareStatus ==
              //                       ButtonStatus.loading
              //                   ? null
              //                   : () {
              //                       try {
              //                         vcController.stopScreenShare();
              //                       } catch (e) {}
              //                     },
              //               child: const Icon(Icons.stop_screen_share,
              //                   color: Colors.white),
              //             )
              //           else
              //             FloatingActionButton.small(
              //               shape: ContinuousRectangleBorder(
              //                   borderRadius: BorderRadius.circular(12)),
              //               heroTag: 'screen',
              //               backgroundColor: bottomBoxColor,
              //               onPressed: vcController.screenShareStatus ==
              //                       ButtonStatus.loading
              //                   ? null
              //                   : () {
              //                       try {
              //                         vcController.screenShare();
              //                       } catch (e) {}
              //                     },
              //               child: const Icon(Icons.screen_share_outlined,
              //                   color: Colors.white),
              //             ),
              //           const SizedBox(width: 12),
              //           FloatingActionButton.small(
              //             shape: ContinuousRectangleBorder(
              //                 borderRadius: BorderRadius.circular(12)),
              //             heroTag: 'more',
              //             backgroundColor: bottomBoxColor,
              //             onPressed: () {},
              //             child: const Icon(Icons.more_horiz_rounded,
              //                 color: Colors.white),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 20),
              //             child: SizedBox(
              //               width: 100,
              //               height: 45,
              //               child: FloatingActionButton(
              //                 heroTag: 'End Meeting',
              //                 shape: ContinuousRectangleBorder(
              //                     borderRadius:
              //                         BorderRadiusDirectional.circular(12)),
              //                 onPressed: () {
              //                   try {
              //                     if (vcController.selfRole
              //                         .contains(ParticipantRoles.moderator)) {
              //                       inMeetClient.endMeetingForAll();
              //                       inMeetClient.endBreakoutRooms();
              //                       vcController.isBreakoutStarted = false;
              //                     } else {
              //                       inMeetClient.exitMeeting();
              //                     }
              //                     Get.delete<VcController>(force: true);
              //                     Get.back();
              //                   } catch (e) {}
              //                 },
              //                 backgroundColor: micOffColor,
              //                 child: const Text(
              //                   'End Meeting',
              //                   style: TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 13,
              //                     fontWeight: FontWeight.w400,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           )
              //         ],
              //       )
              //     ],
              //   ),
              // ),
              //     ],
              //   );
              // }),

              )),
    );
  }
}

// class CustomExpansionTile extends StatefulWidget {
//   final String title;
//   final Widget child;
//   final bool initiallyExpanded;
//
//   CustomExpansionTile({
//     required this.title,
//     required this.child,
//     this.initiallyExpanded = false,
//   });
//
//   @override
//   _CustomExpansionTileState createState() => _CustomExpansionTileState();
// }
//
// class _CustomExpansionTileState extends State<CustomExpansionTile> {
//   bool _isExpanded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _isExpanded = widget.initiallyExpanded;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: const Color.fromARGB(255, 49, 48, 48),
//         ),
//         child: ExpansionTile(
//           initiallyExpanded: _isExpanded,
//           shape: const Border.fromBorderSide(BorderSide.none),
//           title: Text(
//             widget.title,
//             style: const TextStyle(color: Colors.white),
//           ),
//           children: [
//             widget.child,
//           ],
//           onExpansionChanged: (bool expanded) {
//             setState(() {
//               _isExpanded = expanded;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
