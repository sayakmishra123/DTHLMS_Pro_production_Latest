import 'dart:developer';

// import 'package:dlpencryptor_live/widget/teacherpoll.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inapi_core_sdk/inapi_core_sdk.dart';

// import '../chat/groupchat.dart';
// import '../vc_controller.dart';
// import '../widget/chatwidget.dart';
import 'chatwidget.dart';
import 'teacherpoll.dart';
import 'vc_controller.dart';

enum Menu { camera, mic, management, chat, video }

class MyCupertinoPopupMenu extends StatelessWidget {
  final InMeetClient inMeetClient;
  final VcController vcController;
  final String username;
  final String sessionId;
  final String userid;

  const MyCupertinoPopupMenu({
    Key? key,
    required this.inMeetClient,
    required this.vcController,
    required this.username,
    required this.sessionId,
    required this.userid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FloatingActionButton(
          mini: true,
          onPressed: () => _showCupertinoMenu(context),
          backgroundColor: CupertinoColors.destructiveRed,
          // heroTag: 'btn4',
          child: Icon(
            CupertinoIcons.settings,
            size: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showCupertinoMenu(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title:  Text('Options ${sessionId} / ${userid}'),
        actions: <CupertinoActionSheetAction>[
          // CupertinoActionSheetAction(
          //
          //   onPressed: () async {
          //     Navigator.pop(context);
          //     await inMeetClient.disablewebcamForAll();
          //     // Navigator.pop(context);
          //   },
          //   child: const Text('Disable Webcam'),
          // ),
          // CupertinoActionSheetAction(
          //   onPressed: () async {
          //     Navigator.pop(context);
          //     await inMeetClient.muteMicForAll();
          //     // Navigator.pop(context);
          //   },
          //   child: const Text('Mute Mic'),
          // ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SafeArea(
                  child: Material(
                    color: Colors.transparent,
                    child: StudentPollPage(
                      teacherName: username,
                      sessionId: sessionId,
                    ),
                  ),
                );
              }));
              // Navigator.pop(context);
            },
            child: const Text('Management'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              // log(sessionId.toString());
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SafeArea(
                    child: Material(
                  color: Colors.transparent,
                  child: ChatUi(sessionId, userid, username

                      // username
                      ),
                ));
              }));
              // Navigator.pop(context);
            },
            child: const Text('Chat'),
          ),
          // CupertinoActionSheetAction(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       if (vcController.peersList.isNotEmpty || vcController.screenShareList.isNotEmpty) {
          //         return SafeArea(
          //           child: Material(
          //             color: Colors.transparent,
          //             child: Column(
          //               children: [
          //                 const SizedBox(height: 40),
          //                 Row(
          //                   children: [
          //                     const SizedBox(width: 15),
          //                     Container(
          //                       height: 40,
          //                       width: 80,
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(20),
          //                         color: Colors.transparent,
          //                         border: Border.all(width: 2, color: Colors.white),
          //                       ),
          //                       child: Center(
          //                         child: Text(
          //                           vcController.peersList.length.toString(),
          //                           style: const TextStyle(
          //                             fontFamily: 'ocenwide',
          //                             fontSize: 16,
          //                             color: Colors.white,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(height: 20),
          //                 // Add other widgets for video display here
          //               ],
          //             ),
          //           ),
          //         );
          //       }
          //       else
          //         {
          //          return NoParticipantsScreen();
          //         }
          //     }));
          //     // Navigator.pop(context);
          //   },
          //   child: const Text('Participants'),
          // ),
          //
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
