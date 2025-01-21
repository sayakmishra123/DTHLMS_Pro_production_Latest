// import 'package:dthlms/GETXCONTROLLER/getxController.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// // import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class YoutubeLive extends StatefulWidget {
//   final String? link;
//   final String? username;
//   final bool isLive;

//   const YoutubeLive(this.link, this.username, this.isLive, {Key? key})
//       : super(key: key);

//   @override
//   _YoutubeLiveState createState() => _YoutubeLiveState();
// }

// class _YoutubeLiveState extends State<YoutubeLive> {
//   // late YoutubePlayerController _controller;
//   final _controller = YoutubePlayerController.fromVideoId(
//     videoId: 'KBYSpR8N6pc',
//     params: YoutubePlayerParams(
//       mute: false,
//       showControls: true,
//       showFullscreenButton: true,
//     ),
//   );
//   @override
//   void initState() {
//     super.initState();

//     // Extract YouTube Video ID from the provided link
//     // final videoId = YoutubePlayer.convertUrlToId(widget.link ?? '') ?? '';
//     // _controller = YoutubePlayerController(
//     //   initialVideoId: videoId,
//     //   flags: YoutubePlayerFlags(
//     //     showLiveFullscreenButton: true,

//     //     autoPlay: true,
//     //     mute: false,
//     //     isLive: widget.isLive, // Set this to true if playing a live video
//     //     disableDragSeek: false,
//     //     enableCaption: false,
//     //     useHybridComposition: true,
//     //   ),
//     // );
//   }

//   @override
//   void dispose() {
//     // _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final orientation = MediaQuery.of(context).orientation;

//     return YoutubePlayerScaffold(
//       controller: _controller,
//       aspectRatio: 16 / 9,
//       builder: (context, player) {
//         return Expanded(
//           child: Column(
//             children: [
//               player,
//               Text('Youtube Player'),
//             ],
//           ),
//         );
//       },
//     );
//     // YoutubePlayerBuilder(
//     //   player: YoutubePlayer(
//     //     // aspectRatio: 50,

//     //     width: MediaQuery.of(context).size.width - 40,
//     //     controller: _controller,

//     //     showVideoProgressIndicator: true,

//     //     progressIndicatorColor: Colors.red,
//     //     onReady: () {
//     //       debugPrint('YouTube Player is ready.');
//     //     },
//     //     onEnded: (metaData) {
//     //       ScaffoldMessenger.of(context).showSnackBar(
//     //         SnackBar(content: Text('Video Ended')),
//     //       );
//     //     },
//     //   ),
//     //   builder: (context, player) {
//     //     return Container(
//     //       height: orientation == Orientation.portrait
//     //           ? MediaQuery.of(context).size.height / 1.7
//     //           : MediaQuery.of(context).size.height / 1.7,
//     //       child: player,
//     //     );
//     //   },
//     // );
//   }
// }

// // class YoutubeLive extends StatefulWidget {
// //   final String? link;
// //   final String? username;
// //   final bool isLive;

// //   const YoutubeLive(this.link, this.username, this.isLive, {Key? key})
// //       : super(key: key);

// //   @override
// //   _YoutubeLiveState createState() => _YoutubeLiveState();
// // }

// // class _YoutubeLiveState extends State<YoutubeLive> {
// //   // late YoutubePlayerController _controller;
// //   Getx getx = Get.put(Getx());

// //   @override
// //   void initState() {
// //     super.initState();
// //     final videoId = YoutubePlayer.convertUrlToId(widget.link ?? '') ?? '';
// //     _controller = YoutubePlayerController(
// //       initialVideoId: videoId,
// //       flags: YoutubePlayerFlags(
// //         showLiveFullscreenButton: true,
// //         autoPlay: true,
// //         mute: false,
// //         isLive: widget.isLive, // true if this is a live stream
// //         disableDragSeek: false,
// //         enableCaption: false,
// //         useHybridComposition: true,
// //         loop: true,
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     // Important to dispose the controller
// //     _controller.dispose();
// //     // Restore overlays & orientation if needed
// //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
// //     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
// //     super.dispose();
// //   }

// //   YoutubePlayerController _controller = YoutubePlayerController(
// //     initialVideoId: 'iLnmTe5Q2Qw',
// //     flags: YoutubePlayerFlags(
// //       autoPlay: true,
// //       mute: true,
// //     ),
// //   );

// //   @override
// //   Widget build(BuildContext context) {
// //     final orientation = MediaQuery.of(context).orientation;

// //     return YoutubePlayerBuilder(
// //         player: YoutubePlayer(
// //           controller: _controller,
// //         ),
// //         builder: (context, player) {
// //           return Column(
// //             children: [
// //               // some widgets
// //               player,
// //               //some other widgets
// //             ],
// //           );
// //         });

// //     //  YoutubePlayerBuilder(
// //     //   // Called when user presses the plugin's fullscreen button:
// //     //   onEnterFullScreen: () {
// //     //     setState(() => getx.isFullscreen.value = true);
// //     //     // Hide status bar & nav bar:
// //     //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
// //     //         overlays: []);
// //     //     // Force landscape orientation:
// //     //     SystemChrome.setPreferredOrientations([
// //     //       DeviceOrientation.landscapeLeft,
// //     //       DeviceOrientation.landscapeRight,
// //     //     ]);
// //     //   },
// //     //   // Called when user exits fullscreen:
// //     //   onExitFullScreen: () {
// //     //     setState(() => getx.isFullscreen.value = false);
// //     //     // Restore system overlays:
// //     //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
// //     //     // Allow all orientations again:
// //     //     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
// //     //   },
// //     //   player: YoutubePlayer(
// //     //     controller: _controller,
// //     //     showVideoProgressIndicator: true,
// //     //     progressIndicatorColor: Colors.red,
// //     //     onReady: () {
// //     //       debugPrint('YouTube Player is ready.');
// //     //     },
// //     //     onEnded: (metaData) {
// //     //       ScaffoldMessenger.of(context).showSnackBar(
// //     //         const SnackBar(content: Text('Video Ended')),
// //     //       );
// //     //     },
// //     //   ),
// //     //   builder: (context, player) {
// //     //     // If in fullscreen, just return the player so it fills the entire screen:
// //     //     if (getx.isFullscreen.value)
// //     //       return SizedBox(height: 250, child: player);

// //     //     // Otherwise, display player in a Container/SizedBox of your choice:
// //     //     return SizedBox(
// //     //       height: orientation == Orientation.portrait
// //     //           ? MediaQuery.of(context).size.height / 1.7
// //     //           : MediaQuery.of(context).size.height / 1.7,
// //     //       child: player,
// //     //     );
// //     //   },
// //     // );
// //   }
// // }

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeLive extends StatefulWidget {
  final String? link;
  final String username;
  final bool isLive;

  YoutubeLive(this.link, this.username, this.isLive);

  @override
  _YoutubeLiveState createState() => _YoutubeLiveState();
}

class _YoutubeLiveState extends State<YoutubeLive> {
  late final WebViewController _webViewController;
  String videoHtmlContent = '';

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..enableZoom(true)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint("Loading progress: $progress%");
          },
          onPageStarted: (String url) {
            debugPrint("Page started loading: $url");
          },
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("Web resource error: ${error.description}");
          },
          onHttpError: (HttpResponseError error) {
            // debugPrint("HTTP error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    _initWebViewContent(widget.link ?? '');
  }

  String _extractYouTubeId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    }
    return '';
  }

  Future<void> _initWebViewContent(String youtubeUrl) async {
    final videoId = _extractYouTubeId(youtubeUrl);

    // Load the HTML content and replace placeholders
    final htmlContent =
        await rootBundle.loadString('assets/youtubehtml/video_player.html');
    videoHtmlContent = htmlContent
        .replaceAll('{SOURCE_ID}', videoId)
        .replaceAll('{USERNAME}', widget.username);

    // Load the HTML content in the WebView
    _webViewController.loadHtmlString(videoHtmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AspectRatio(
        aspectRatio: 12 / 9,
        child: WebViewWidget(
          controller: _webViewController,
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
              () => ScaleGestureRecognizer(), // Enables pinch-to-zoom
            ),
          },
        ),
      ),
    );
  }
}
