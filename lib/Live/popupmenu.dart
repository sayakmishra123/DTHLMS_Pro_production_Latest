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
        // title:  Text('Options ${sessionId} / ${userid}'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              // log(sessionId.toString());
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SafeArea(
                    child: Material(
                  color: Colors.transparent,
                  child: ChatUi(
                    sessionId, userid, username, meeting: meeting,

                    // username
                  ),
                ));
              }));
              // Navigator.pop(context);
            },
            child: const Text('Chat'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              // log(sessionId.toString());
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SafeArea(
                    child: Material(
                  color: Colors.transparent,
                  child: StudentPollPage(
                      sessionId: sessionId, teacherName: '', meeting: meeting),
                  // child: ChatUi(
                  //   sessionId, userid, username, meeting: meeting,
                  //
                  //   // username
                  // ),
                ));
              }));
              // Navigator.pop(context);
            },
            child: const Text('Management'),
          ),
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
