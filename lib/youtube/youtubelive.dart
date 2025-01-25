// import 'package:flutter/material.dart';
// import 'package:pod_player/pod_player.dart';

// class YoutubeLive extends StatefulWidget {
//   final String link;  // Video URL

//   YoutubeLive({required this.link});

//   @override
//   _YoutubeLiveState createState() => _YoutubeLiveState();
// }

// class _YoutubeLiveState extends State<YoutubeLive> {
//   late PodPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//      _controller = PodPlayerController(
//     playVideoFrom: PlayVideoFrom.youtube(widget.link),
//     podPlayerConfig: const PodPlayerConfig(
//       autoPlay: true,
//       isLooping: false,
     
//     )
//   )..initialise();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();  // Dispose the controller to free resources
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       body: Center(
//         child: Container(
//           width: double.infinity,
//           height: 300,
//           child:PodVideoPlayer(controller: _controller)
//         ),
//       ),
//     );
//   }
// }




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
