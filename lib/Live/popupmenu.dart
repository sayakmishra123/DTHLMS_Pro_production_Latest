import 'package:dthlms/MODEL_CLASS/Meettingdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inapi_core_sdk/inapi_core_sdk.dart';
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
  final MeetingDeatils? meeting;

  const MyCupertinoPopupMenu({
    Key? key,
    required this.inMeetClient,
    required this.vcController,
    required this.username,
    required this.sessionId,
    required this.userid, 
    this.meeting,
    
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
          //   onPressed: () {
          //     Navigator.pop(context);
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       return SafeArea(
          //         child: Material(
          //           color: Colors.transparent,
          //           child: StudentPollPage(
          //             teacherName: username,
          //             sessionId: sessionId,
          //           ),
          //         ),
          //       );
          //     }));
          //     // Navigator.pop(context);
          //   },
          //   child: const Text('Management'),
          // ),
          CupertinoActionSheetAction(
            onPressed: () {
              // log(sessionId.toString());
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
<<<<<<< HEAD
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
=======
                return SafeArea( 
>>>>>>> c48a9f5ea1866b566c042f9f3c1d6880101f88a7
                    child: Material(
                  color: Colors.transparent,
                  child: ChatUi(sessionId, userid, username,meeting: meeting,

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
