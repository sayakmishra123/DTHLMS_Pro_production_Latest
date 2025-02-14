import 'dart:developer';
import 'dart:io';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayClass {
  late final Player player = Player();
  late final VideoController controller;
  late Duration totalPlayTimeofVideo;
  late DateTime lastPlayTime;
  late DateTime startclocktime;
  late DateTime endclocktime;
  late bool _isPlaying;
  late double _lastPlaybackRate;
  late String videoLink;
  VideoPlayClass({List<dynamic> videoList = const []}) {
    try {
      totalPlayTimeofVideo = Duration.zero;
      lastPlayTime = DateTime.now();
      _lastPlaybackRate = 1.0;
      _isPlaying = false;
      startclocktime = DateTime.now();
      endclocktime = DateTime.now();
      // player = Player();
      controller = VideoController(player);
      log(videoList[0]['DownloadedPath']);
// log(videoLink);
      player.open(
        // videoList.length > 1
        //     ?
        Playlist(
          // for (int i = 0; i < videoList.length; i++) ...[
          // Media(videoList[0]['DownloadedPath']),
          // Media(videoList[0]['DownloadedPath'])
          // ]

          [
            Media(
                'https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4'),
            Media(
                'https://user-images.githubusercontent.com/28951144/229373709-603a7a89-2105-4e1b-a5a5-a6c3567c9a59.mp4'),
            Media(
                'https://user-images.githubusercontent.com/28951144/229373716-76da0a4e-225a-44e4-9ee7-3e9006dbc3e3.mp4'),
            Media(
                'https://user-images.githubusercontent.com/28951144/229373718-86ce5e1d-d195-45d5-baa6-ef94041d0b90.mp4'),
            Media(
                'https://user-images.githubusercontent.com/28951144/229373720-14d69157-1a56-4a78-a2f4-d7a134d7c3e9.mp4'),

            // Declare the starting position.
          ],
          index: 0,
        ),
        // : Media(
        //     !File(videoLink).existsSync()
        //         ? "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        //         : videoLink,
        //   ),
        play: true,
      );
    } catch (e) {}
  }
  Future<void> playVideo() async {
    await player.play();
  }

  void updateVideoLink(String newLink, List videoList) {
    videoLink = newLink;
    log(videoList.toString() + "dsfsd");
    player.open(
      videoList.length == 1
          ? Playlist(
              [
                for (int i = 0; i < videoList.length; i++) ...[
                  Media(videoList[i]),

                  // ]
                ],
                // [
                //   Media(
                //       'https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4'),
                //   Media(
                //       'https://user-images.githubusercontent.com/28951144/229373709-603a7a89-2105-4e1b-a5a5-a6c3567c9a59.mp4'),
                //   Media(
                //       'https://user-images.githubusercontent.com/28951144/229373716-76da0a4e-225a-44e4-9ee7-3e9006dbc3e3.mp4'),
                //   Media(
                //       'https://user-images.githubusercontent.com/28951144/229373718-86ce5e1d-d195-45d5-baa6-ef94041d0b90.mp4'),
                //   Media(
                //       'https://user-images.githubusercontent.com/28951144/229373720-14d69157-1a56-4a78-a2f4-d7a134d7c3e9.mp4'),

                //   // Declare the starting position.
              ],
              index: 0,
            )
          :
          // Playlist(),
          Media( videoLink),
      play: false,
    );
  }

  Future<void> pauseVideo() async {
    await player.pause();
    // log(totalPlayTime.inSeconds.toString());
  }

  Future<void> playOrPause() async {
    await player.playOrPause();
  }

  String startTrackingPlayTime() {
    if (!_isPlaying) {
      lastPlayTime = DateTime.now();
      _lastPlaybackRate = player.state.rate;
      _isPlaying = true;
      startclocktime = DateTime.now();
    }
    return lastPlayTime.toString();
  }

  Duration stopTrackingPlayTime() {
    Duration playedTime = Duration();
    if (_isPlaying) {
      playedTime = DateTime.now().difference(lastPlayTime);
      totalPlayTimeofVideo += playedTime;
      _isPlaying = false;
      endclocktime = DateTime.now();
    }
    return playedTime;
  }

  Duration get totalPlayTime {
    if (_isPlaying) {
      Duration playedTime = DateTime.now().difference(lastPlayTime);
      return totalPlayTimeofVideo + (playedTime);
    }
    return totalPlayTimeofVideo;
  }

  void seekTo(Duration position) {
    player.seek(position);
    print("goto $position");
  }
}
