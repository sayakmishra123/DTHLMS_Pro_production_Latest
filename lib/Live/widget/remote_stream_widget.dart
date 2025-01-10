// import 'package:abc/vc_controller.dart';
// import 'package:dthlms/MOBILE/live/vc_controller.dart';
import 'package:dthlms/Live/vc_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:inapi_core_sdk/inapi_core_sdk.dart';
// import '../fullscreen.dart';
import '../fullscreen.dart';
import '../peer_model.dart';

class RemoteStreamWidget extends StatefulWidget {
  const RemoteStreamWidget({
    super.key,
    required this.peer,
    required this.isScreenShare,
  });

  final Peer peer;
  final bool isScreenShare;

  @override
  State<RemoteStreamWidget> createState() => _RemoteStreamWidgetState();
}

class _RemoteStreamWidgetState extends State<RemoteStreamWidget> {
  Peer get peer => widget.peer;
  RTCVideoRenderer? renderer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!(peer.videoPaused ?? true) &&
          renderer == null &&
          !(peer.isScreenSharing ?? false)) {
        renderer =
        await InMeetClient.instance.initializeParticipantRenderer(peer.id!);
      } else if (peer.isScreenSharing ?? false) {
        renderer = peer.renderer;
      }
      setState(() {});
    });
  }

  void initialize() async {
    if (!(peer.videoPaused ?? true) && renderer == null) {
      renderer =
      await InMeetClient.instance.initializeParticipantRenderer(peer.id!);
    } else if (peer.videoPaused ?? true && (peer.isScreenSharing ?? false)) {
      renderer = null;
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant RemoteStreamWidget oldWidget) {
    initialize();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (renderer != null && !(peer.isScreenSharing ?? false)) {
      renderer!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const aspectRatio = 5 / 3;
    return GetBuilder<VcController>(builder: (controller) {
      bool isHost = peer.roles?.contains(ParticipantRoles.moderator) ?? false;

      // Show video or screen share based on peer's state
      if (!isHost && !(peer.isScreenSharing ?? false)) {
        return const SizedBox(); // If not a host and no screen sharing, return an empty widget
      }

      return GestureDetector(
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                  FullScreenVideoView(
                    renderer:
                    renderer!, // Pass the controller to the full-screen page
                  ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(255, 44, 44, 44),
                      // border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Stack(
                      children: [
                        // Show the appropriate renderer: screen share or video
                        renderer == null
                            ? Center(
                          child: Text(
                            '${peer.displayName ?? ""} ${(peer.roles?.contains(ParticipantRoles.moderator) ?? false) ? "(Host)" : ''}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        )
                            : GestureDetector(
                          onDoubleTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FullScreenVideoView(
                                      renderer:
                                      renderer!, // Pass the controller to the full-screen page
                                    ),
                              ),
                            ).then((_) {
                              // Reset to portrait when exiting the full-screen
                              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                            });

// Set the orientation to landscape before navigating
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeRight,
                              DeviceOrientation.landscapeLeft,
                            ]);
                          },
                          child: RTCVideoView(
                            mirror: false,
                            renderer!,
                            objectFit: RTCVideoViewObjectFit
                                .RTCVideoViewObjectFitContain,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Row(
                            children: [
                              if (peer.audioMuted ?? true)
                                const Icon(
                                  Icons.mic_off,
                                  color: Colors.red,
                                ),
                              const SizedBox(width: 8),
                              if (renderer != null)
                                Text(
                                  " ${peer.displayName ?? ""} (Host)", // Always show name with "Host" label
                                  style: const TextStyle(
                                      color: Colors.white,
                                      backgroundColor: Colors.black54),
                                ),
                            ],
                          ),
                        ),
                        if (peer.isHandRaised == true)
                          const Positioned(
                            left: 10,
                            bottom: 10,
                            child: Icon(
                              Icons.back_hand,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Display options only if the user has moderator rights
                  if (controller.selfRole.contains(ParticipantRoles.moderator))
                    Positioned(
                      right: 12,
                      top: 12,
                      child: PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: GetBuilder<VcController>(
                                  builder: (controller) {
                                    return SwitchListTile(
                                      value: controller.peersList[peer.id!]?.roles
                                          ?.contains(
                                          ParticipantRoles.moderator) ??
                                          false,
                                      onChanged: (value) {
                                        final inMeetClient = InMeetClient.instance;
                                        if (value) {
                                          inMeetClient.giveRoleToParticipant(
                                              peer.id!, ParticipantRoles.moderator);
                                        } else {
                                          inMeetClient.removeRoleFromParticipant(
                                              peer.id!, ParticipantRoles.moderator);
                                        }
                                      },
                                      title: const Text('Moderator'),
                                    );
                                  }),
                            ),
                            PopupMenuItem(
                              child:
                              GetBuilder<VcController>(builder: (context) {
                                return SwitchListTile(
                                  value: (controller.peersList[peer.id!]?.roles
                                      ?.contains(
                                      ParticipantRoles.presenter) ??
                                      false) ||
                                      (controller.peersList[peer.id!]?.roles
                                          ?.contains(
                                          ParticipantRoles.moderator) ??
                                          false),
                                  onChanged: (value) {
                                    final inMeetClient = InMeetClient.instance;
                                    if (value) {
                                      inMeetClient.giveRoleToParticipant(
                                          peer.id!, ParticipantRoles.presenter);
                                    } else {
                                      inMeetClient.removeRoleFromParticipant(
                                          peer.id!, ParticipantRoles.presenter);
                                    }
                                  },
                                  title: const Text('Presenter'),
                                );
                              }),
                            ),
                          ];
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}





