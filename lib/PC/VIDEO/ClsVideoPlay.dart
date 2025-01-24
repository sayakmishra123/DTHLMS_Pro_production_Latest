import 'dart:developer';
import 'dart:io';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayClass {
  late final Player player= Player();
  late final VideoController controller;
  late Duration totalPlayTimeofVideo;
  late DateTime lastPlayTime;
  late DateTime startclocktime;
  late DateTime endclocktime;
  late bool _isPlaying;
  late double _lastPlaybackRate;
    late String videoLink;
  VideoPlayClass() {
    try {

      totalPlayTimeofVideo = Duration.zero;
      lastPlayTime = DateTime.now();
      _lastPlaybackRate = 1.0;
      _isPlaying = false;
      startclocktime = DateTime.now();
      endclocktime = DateTime.now();
      // player = Player();
      controller = VideoController(player);
  
// log(videoLink);
      player.open(
        Media(
           !File(videoLink).existsSync()?"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4":videoLink),
        play: false,
      );
    } catch (e) {}
  }
  Future<void> playVideo() async {
    await player.play();
    // log(totalPlayTimeofVideo.inSeconds.toString());
  }

   void updateVideoLink(String newLink) {
    videoLink = newLink;

    player.open(
      
      // Playlist(),
      Media(
        
        
        
        
          !File(videoLink).existsSync()
          ? "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
          : videoLink),
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
      totalPlayTimeofVideo += playedTime ;
      _isPlaying = false;
      endclocktime = DateTime.now();
    }
    return playedTime;
  }

  Duration get totalPlayTime {
    if (_isPlaying) {
      Duration playedTime = DateTime.now().difference(lastPlayTime);
      return totalPlayTimeofVideo + (playedTime );
    }
    return totalPlayTimeofVideo;
  }

  void seekTo(Duration position) {
    player.seek(position);
    print("goto $position");
  }
}
