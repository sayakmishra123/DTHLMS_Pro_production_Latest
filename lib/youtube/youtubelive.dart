import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeLive extends StatefulWidget {
  final String? link;
  final String? username;

  const YoutubeLive(this.link, this.username, {Key? key}) : super(key: key);

  @override
  _YoutubeLiveState createState() => _YoutubeLiveState();
}

class _YoutubeLiveState extends State<YoutubeLive> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();

    // Extract YouTube Video ID from the provided link
    final videoId = YoutubePlayer.convertUrlToId(widget.link ?? '') ?? '';
    _controller = YoutubePlayerController( 
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        showLiveFullscreenButton: true,

        autoPlay: true,
        mute: false,
        isLive: true, // Set this to true if playing a live video
        disableDragSeek: false,
        enableCaption: false,
        useHybridComposition: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        // aspectRatio: 50,

        width: MediaQuery.of(context).size.width-40,
        controller: _controller,

        showVideoProgressIndicator: true,

        progressIndicatorColor: Colors.red,
        onReady: () {
          debugPrint('YouTube Player is ready.');
        },
        onEnded: (metaData) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Video Ended')),
          );
        },
      ),
      builder: (context, player) {
        return Container(
          height:orientation==Orientation.portrait? MediaQuery.of(context).size.height / 1.7:MediaQuery.of(context).size.height / 1.7,
          child: player,
        );
      },
    );
  }
}
