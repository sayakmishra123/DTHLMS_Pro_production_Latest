
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';


class FullScreenVideoView extends StatelessWidget {
  // final VcController vcController;
  RTCVideoRenderer   renderer;
  FullScreenVideoView({required this.renderer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onDoubleTap: () {
            Get.back();
          },
          child: RTCVideoView(
            mirror: false,
            renderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
          ),
        ),
      ),
    );
  }
}
