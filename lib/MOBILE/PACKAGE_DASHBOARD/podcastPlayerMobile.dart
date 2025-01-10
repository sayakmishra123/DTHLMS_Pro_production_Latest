import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class PodCastPlayerMobile extends StatefulWidget {
  final List<String> musicPaths;
  final int initialIndex;

  const PodCastPlayerMobile({
    Key? key,
    required this.musicPaths,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _PodCastPlayerMobileState createState() => _PodCastPlayerMobileState();
}

class PodCastPlayerController extends GetxController {
  late AudioPlayer audioPlayer;
  var currentIndex = 0.obs;
  var isPlaying = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;

  final List<String> musicPaths;

  PodCastPlayerController(this.musicPaths, int initialIndex) {
    currentIndex.value = initialIndex;
    audioPlayer = AudioPlayer();

    audioPlayer.onDurationChanged.listen((duration) {
      totalDuration.value = duration;
    });

    audioPlayer.onPositionChanged.listen((position) {
      currentPosition.value = position;
    });

    audioPlayer.onPlayerComplete.listen((_) {
      if (currentIndex.value < musicPaths.length - 1) {
        playNextSong();
      } else {
        reloadCurrentAudio();
      }
    });

    playCurrentSong();
  }

  void playCurrentSong() async {
    await audioPlayer.play(DeviceFileSource(musicPaths[currentIndex.value]));
    isPlaying.value = true;
  }

  void pauseOrResumeSong() {
    if (isPlaying.value) {
      audioPlayer.pause();
    } else {
      if (currentPosition.value >= totalDuration.value &&
          currentIndex.value >= musicPaths.length - 1) {
        reloadCurrentAudio();
      } else {
        audioPlayer.resume();
      }
    }
    isPlaying.toggle();
  }

  void playNextSong() {
    if (currentIndex.value < musicPaths.length - 1) {
      currentIndex.value++;
      playCurrentSong();
    }
  }

  void playPreviousSong() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      playCurrentSong();
    }
  }

  void seekTo(Duration position) {
    audioPlayer.seek(position);
  }

  void reloadCurrentAudio() {
    currentPosition.value = Duration.zero;
    playCurrentSong();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}

class _PodCastPlayerMobileState extends State<PodCastPlayerMobile> {
  late final PodCastPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
        PodCastPlayerController(widget.musicPaths, widget.initialIndex));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorPage.white),
        backgroundColor: ColorPage.appbarcolor,
        title: const Text('Podcast', style: TextStyle(color: ColorPage.white)),
      ),
      body: Center(
        // padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: ColorPage.white,
                    boxShadow: [
                      BoxShadow(
                        // offset: Offset(2, 2),
                        blurRadius: 2,
                        spreadRadius: 3,
                        color: const Color.fromARGB(95, 191, 191, 191),
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      radius: 70,
                      child: Icon(Icons.podcasts, size: 80),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: Obx(() => Text(
                            '${controller.musicPaths[controller.currentIndex.value].split('/').last}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                    ),
                    Obx(() => Slider(
                          value: controller.currentPosition.value.inSeconds
                              .toDouble(),
                          max: controller.totalDuration.value.inSeconds
                              .toDouble(),
                          onChanged: (value) {
                            controller.seekTo(Duration(seconds: value.toInt()));
                          },
                        )),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(_formatDuration(
                                  controller.currentPosition.value)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(_formatDuration(
                                  controller.totalDuration.value)),
                            ),
                          ],
                        )),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          iconSize: 48,
                          onPressed: controller.playPreviousSong,
                        ),
                        Obx(() => IconButton(
                              icon: Icon(controller.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow),
                              iconSize: 64,
                              onPressed: controller.pauseOrResumeSong,
                            )),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          iconSize: 48,
                          onPressed: controller.playNextSong,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$minutes:$seconds";
  }
}
