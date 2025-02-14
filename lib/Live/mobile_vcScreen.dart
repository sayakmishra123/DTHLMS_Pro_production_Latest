import 'dart:async';
import 'dart:developer';

import 'package:dthlms/ACTIVATION_WIDGET/enebelActivationcode.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/GLOBAL_WIDGET/loader.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/Live/chatwidget.dart';
import 'package:dthlms/Live/popupmenu.dart';
import 'package:dthlms/MODEL_CLASS/Meettingdetails.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:dthlms/youtube/youtubelive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'package:inapi_core_sdk/inapi_core_sdk.dart';
// import 'package:path/path.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:y_player/y_player.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import 'mobilegetx.dart';
import 'peer_model.dart';
import 'vc_controller.dart';
import 'vc_methods.dart';
import 'widget/remote_stream_widget.dart';

// ignore: must_be_immutable
class MobileMeetingPage extends StatefulWidget {
  MeetingDeatils? meeting;
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
      {this.videoCategory = "YouTube", required this.meeting, super.key});

  @override
  State<MobileMeetingPage> createState() => _MobileMeetingPageState(meeting);
}

class _MobileMeetingPageState extends State<MobileMeetingPage> {
  Timer? timer;
  MeetingDeatils? meeting;

  String? selectedVideoOutputDevice;

  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://www.youtube.com/'));

  Future<void> initializeWebView() async {
    try {
      log(widget.meeting!.groupChat!);
      controller.loadRequest(Uri.parse(
          widget.meeting!.groupChat!)); // Assuming widget.personchat is a URL
      getx.isloadChatUrl.value = true;
    } catch (e) {
      debugPrint('Error initializing WebView: $e');
    }
  }

  Future<void> playSound() async {
    try {} catch (e) {
      writeToFile(e, "mobileVc screen");

      print('Error playing sound: $e');
    }
  }

  @override
  void initState() {
    if (widget.videoCategory != 'YouTube') {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await InMeetClient.instance.getAvailableDeviceInfo();
        Get.find<VcController>().assigningRenderer();
      });
    }
    initializeWebView();

    onUserJoinMeeting();
    super.initState();
  }

  var startTime = DateTime.now().toString();
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

      print(
          "User ${widget.username} (${widget.userid}) joined the meeting with session ID ${widget.sessionId}.");
    }

    await unUploadedVideoInfoInsert(
            context,
            [
              {
                'VideoId': int.parse(
                    widget.meeting!.videoId.toString().replaceAll(",", "")),
                'StartDuration': "0",
                'TimeSpend': "0",
                "Speed": "0",
                "StartTime": startTime.substring(0, startTime.length - 3),
                "PlayNo": int.parse(getx.loginuserdata[0].phoneNumber),
              }
            ],
            getx.loginuserdata[0].token,
            true)
        .then((value) {
      insertVideoplayInfo(
          int.parse(widget.meeting!.videoId.toString().replaceAll(",", "")),
          "0",
          "0",
          "0",
          startTime.substring(0, startTime.length - 3),
          int.parse(getx.loginuserdata[0].phoneNumber),
          value ? 1 : 0,
          type: "live");
    });
  }

  @override
  void dispose() {
    if (widget.videoCategory == "YouTube") {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          getx.isloadChatUrl.value = false;
        },
      );
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

  Color btnColor = const Color(0Xff2D3237);

  RxInt rightBarIndex = 0.obs;

  Getx getx = Get.put(Getx());
  AnimationStyle? _animationStyle;

  _MobileMeetingPageState(this.meeting);
  Future back() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomLogoutDialog(
              title: "You're close the meeting...\nAre you sure?",
              description: '',
              ok: () async {
                await unUploadedVideoInfoInsert(
                        context,
                        [
                          {
                            'VideoId': int.parse(widget.meeting!.videoId
                                .toString()
                                .replaceAll(",", "")),
                            'StartDuration': "0",
                            'TimeSpend': "0",
                            "Speed": "0",
                            "StartTime":
                                startTime.substring(0, startTime.length - 3),
                            "PlayNo":
                                int.parse(getx.loginuserdata[0].phoneNumber),
                          }
                        ],
                        getx.loginuserdata[0].token,
                        true)
                    .then((value) {
                  insertVideoplayInfo(
                      int.parse(widget.meeting!.videoId
                          .toString()
                          .replaceAll(",", "")),
                      "0",
                      "0",
                      "0",
                      startTime.substring(0, startTime.length - 3),
                      int.parse(getx.loginuserdata[0].phoneNumber),
                      value ? 1 : 0,
                      type: "live");
                });

                if (widget.videoCategory != "YouTube") {
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
                }

                Get.back();
                Get.back();
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await back();
      },
      child: Obx(
        () => Scaffold(
            backgroundColor: Colors.black,
            appBar: getx.isFullscreen.value
                ? null
                : AppBar(
                    title: Text(widget.packageName.toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'ocenwide',
                            color: Colors.black)),
                    leading: Image.asset(
                      logopath,
                      height: 40,
                    ),
                  ),
            body: widget.videoCategory == "YouTube"
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        YoutubeLive(widget.link, widget.username, true),
                        SizedBox(
                          height: 30,
                        ),
                        Obx(
                          () => SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.7,
                            child: Center(
                              child: getx.isloadChatUrl.value
                                  ? WebViewWidget(controller: controller)
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : GetBuilder<VcController>(builder: (vcController) {
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
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
                                                                            return !(vcController.screenShareList.contains(peer));
                                                                          }));

                                                                          // Add screen-sharing peers
                                                                          allPeers
                                                                              .addAll(vcController.screenShareList);

                                                                          if (allPeers
                                                                              .isEmpty) {
                                                                            // No peers to display
                                                                            return Center(
                                                                              child: Text(
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
                                                                              final peer = allPeers[index];
                                                                              final isScreenShare = vcController.screenShareList.contains(peer);

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
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 25,
                                                      horizontal: 5,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        widget.videoCategory ==
                                                                "YouTube"
                                                            ? SizedBox()
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            0),
                                                                child:
                                                                    IconButton(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors.red[
                                                                            400],
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(8)),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      ()async  {
                                                                        await back();
                                                                    // showDialog(
                                                                    //   barrierDismissible:
                                                                    //       false,
                                                                    //   context:
                                                                    //       context,
                                                                    //   builder:
                                                                    //       (context) =>
                                                                    //           CustomLogoutDialog(
                                                                    //     title:
                                                                    //         "You're close the meeting...\nAre you sure?",
                                                                    //     description:
                                                                    //         '',
                                                                    //     ok: () {
                                                                    //       Navigator.pop(
                                                                    //           context);
                                                                    //     },
                                                                    //   ),
                                                                    // );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.phone,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
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
                                                                          size:
                                                                              12,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        onSelected:
                                                                            (String
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
                                                                          menuItems.addAll(vcController
                                                                              .audioOutput
                                                                              .map((e) {
                                                                            return PopupMenuItem<String>(
                                                                              value: e,
                                                                              child: Text(
                                                                                e,
                                                                                style: TextStyle(fontSize: 14, fontFamily: 'ocenwide', color: Colors.black),
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
                                                                            mini:
                                                                                true,
                                                                            heroTag:
                                                                                'mic',
                                                                            backgroundColor:
                                                                                btnColor,
                                                                            onPressed:
                                                                                () {
                                                                              try {
                                                                                if (vcController.micStreamStatus == ButtonStatus.off && vcController.audioInput.isNotEmpty) {
                                                                                  vcController.changeMicSreamStatus(ButtonStatus.loading);
                                                                                  inMeetClient.unmuteMic(vcController.selectedAudioInputDeviceId);
                                                                                } else if (vcController.audioInput.isNotEmpty) {
                                                                                  vcController.changeMicSreamStatus(ButtonStatus.loading);
                                                                                  inMeetClient.muteMic();
                                                                                }
                                                                              } catch (e) {
                                                                                writeToFile(e, "mobile vc Screen");
                                                                                // Handle any exceptions here, e.g., show an error message
                                                                                print('Error: $e');
                                                                              }
                                                                            },
                                                                            child: vcController.micStreamStatus == ButtonStatus.on
                                                                                ? Image(
                                                                                    image: AssetImage(
                                                                                      'assets/microphone.png',
                                                                                    ),
                                                                                    height: 20,
                                                                                    // width: 15,
                                                                                  )
                                                                                : Image(
                                                                                    image: AssetImage('assets/mute.png'),
                                                                                    height: 20,
                                                                                  ))
                                                                      // Otherwise, display the regular FloatingActionButton
                                                                      else
                                                                        FloatingActionButton(
                                                                          mini:
                                                                              true,
                                                                          onPressed:
                                                                              () {
                                                                            try {
                                                                              if (vcController.micStreamStatus == ButtonStatus.off && vcController.audioInput.isNotEmpty) {
                                                                                vcController.changeMicSreamStatus(ButtonStatus.loading);
                                                                                inMeetClient.unmuteMic(vcController.selectedAudioInputDeviceId);
                                                                              } else if (vcController.audioInput.isNotEmpty) {
                                                                                vcController.changeMicSreamStatus(ButtonStatus.loading);
                                                                                inMeetClient.muteMic();
                                                                              }
                                                                            } catch (e) {
                                                                              writeToFile(e, "mobile VC Screen");
                                                                              // Handle any exceptions here, e.g., show an error message
                                                                              print('Error: $e');
                                                                            }
                                                                          },
                                                                          backgroundColor:
                                                                              btnColor,
                                                                          heroTag:
                                                                              'btn2',
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/microphone.png',
                                                                            height:
                                                                                20,
                                                                            filterQuality:
                                                                                FilterQuality.medium,
                                                                            scale:
                                                                                1,
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
                                                                        icon:
                                                                            Icon(
                                                                          CupertinoIcons
                                                                              .chevron_down,
                                                                          size:
                                                                              12,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        onSelected:
                                                                            (String
                                                                                selectedItem) {
                                                                          // Update the selected video output device
                                                                          selectedVideoOutputDevice =
                                                                              selectedItem;
                                                                          vcController.selectDevice(
                                                                              DeviceType.videoInput,
                                                                              selectedVideoOutputDevice!);
                                                                        },
                                                                        itemBuilder:
                                                                            (BuildContext
                                                                                context) {
                                                                          // Generate the menu items from vcController.videoInputs
                                                                          return vcController
                                                                              .videoInputs
                                                                              .map((e) {
                                                                            return PopupMenuItem<String>(
                                                                              value: e,
                                                                              child: Text(
                                                                                e,
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontFamily: 'ocenwide',
                                                                                  color: Colors.black, // You can adjust the color as needed
                                                                                  fontWeight: FontWeight.bold,
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
                                                                        mini:
                                                                            true,
                                                                        onPressed:
                                                                            () async {
                                                                          try {
                                                                            // log(vcController.videoInputs.toString());
                                                                            vcController.changeCameraSreamStatus(ButtonStatus.loading);
                                                                            if (vcController.localRenderer ==
                                                                                null) {
                                                                              await inMeetClient.enableWebcam();
                                                                            } else {
                                                                              await inMeetClient.disableWebcam();
                                                                            }
                                                                          } catch (e) {
                                                                            writeToFile(e,
                                                                                "mobile vc Screen");
                                                                          }
                                                                        },
                                                                        backgroundColor:
                                                                            btnColor,
                                                                        heroTag:
                                                                            'btn3',
                                                                        child: vcController.localRenderer ==
                                                                                null
                                                                            ? Image.asset('assets/video-call.png',
                                                                                height: 15,
                                                                                filterQuality: FilterQuality.medium,
                                                                                scale: 1)
                                                                            : Image.asset('assets/video.png', height: 15, filterQuality: FilterQuality.medium, scale: 1)),
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
                                                                    onPressed:
                                                                        () {
                                                                      vcController
                                                                          .raiseHandSelf(
                                                                              !vcController.selfHandRaised);
                                                                    },
                                                                    backgroundColor:
                                                                        btnColor,
                                                                    heroTag:
                                                                        'btn4',
                                                                    child: Icon(
                                                                      vcController.selfHandRaised
                                                                          ? Icons
                                                                              .do_not_touch
                                                                          : Icons
                                                                              .pan_tool_outlined,
                                                                      color: Colors
                                                                          .white,
                                                                      weight: 5,
                                                                    ),
                                                                  ),

                                                            if (widget
                                                                    .videoCategory !=
                                                                "YouTube")
                                                              MyCupertinoPopupMenu(
                                                                inMeetClient:
                                                                    vcController
                                                                        .inMeetClient,
                                                                sessionId: widget
                                                                    .sessionId
                                                                    .toString(),
                                                                userid: widget
                                                                    .userid,
                                                                username: widget
                                                                    .username,
                                                                vcController:
                                                                    vcController,
                                                                meeting:
                                                                    meeting,
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
                  })),
      ),
    );
  }
}
