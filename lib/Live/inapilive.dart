// import 'dart:convert';

// // import 'package:appinapi/sessionmodel.dart';
// import 'package:dthlms/Live/sessionmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_windows/webview_windows.dart';
// import 'dart:async';
// // import 'package:webview_windows/webview_windows.dart';
// import 'package:window_manager/window_manager.dart';
// import 'package:http/http.dart' as http;

// class InApiLivePage extends StatefulWidget {
//   const InApiLivePage({super.key});

//   @override
//   State<InApiLivePage> createState() => _InApiLivePageState();
// }

// class SessionProvider {
//   // Fetch session data from an API
//   Future<SessionDeatils> fetchSession(sessionid) async {
//     String encodedCredentials = base64Encode(utf8.encode(credentials));
//     // String sessionId = "66ab7329caf580d445877b07";
//     final url =
//         Uri.parse('https://api.inapi.vc/publicuser/v2/session/$sessionid');
//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Basic $encodedCredentials',
//       },
//     );

//     // not for the latest but this code is more efficient for
//     final Map<String, dynamic> jsonResponse = json.decode(response.body);
//     print(jsonResponse);
//     if (response.statusCode == 200) {
//       print(jsonResponse);
//       // final Map<String, dynamic> jsonResponse1 = json.decode(response.body);
//       return SessionDeatils.fromJson(jsonResponse['data']);
//     } else {
//       return SessionDeatils.fromJson(jsonResponse['data']);
//       // throw Exception('Failed to load data');
//     }
//   }
// }

// class _InApiLivePageState extends State<InApiLivePage> {
//   final SessionProvider sessionProvider = SessionProvider();
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
//     super.initState();
//   }

//   String sessionId = "66b0bb53c862f884f18f6c00";
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('HTTP Request Example'),
//         ),
//         body: Center(
//             child: ElevatedButton(
//                 onPressed: () async {
//                   String participantuid =
//                       base64Encode(utf8.encode("15464sdfkjsfn44486as6d"));
//                   String appUserId = '121ba4jhhb454a132d121s';
//                   SessionDeatils sessionDeatils =
//                       await sessionProvider.fetchSession(sessionId);
//                   String link =
//                       "https://$subdomen.invc.vc/${sessionDeatils.id}?projectId={$appId}&uid={$participantuid}&appUserId={$appUserId}";
//                   print(link);
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => ExampleBrowser(link)));
//                 },
//                 child: const Text('Join'))),
//       ),
//     );
//   }
// }

// String appId = "66b0a5089d3ecf5ac2a8dee7";
// String appKey = "M9i6X1KRuvCe2kg";
// String credentials = '$appId:$appKey';
// String subdomen = "aswinbajaj";

// class ExampleBrowser extends StatefulWidget {
//   String link;
//   ExampleBrowser(this.link);

//   @override
//   State<ExampleBrowser> createState() => _ExampleBrowserState();
// }

// class _ExampleBrowserState extends State<ExampleBrowser> {
//   final _controller = WebviewController();
//   final _textController = TextEditingController();
//   bool _isWebviewSuspended = false;
//   // final List<StreamSubscription> _subscriptions = [];

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebView();
//   }

//   Future<void> _initializeWebView() async {
//     try {
//       await _controller.initialize();
//       await _controller.setBackgroundColor(Colors.transparent);
//       await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
//       await _controller.loadUrl(widget.link);

//       _controller.loadingState.listen((event) {
//         if (event == LoadingState.navigationCompleted) {
//           // _controller.executeScript(
//           //     "var style = document.createElement('style');"
//           //     "style.innerHTML = '.flexRow.pdngSM.justifyBtwn.alignCntr.joinHdr{ display: none !important; }';"
//           //     "document.head.appendChild(style);");

//           _controller.executeScript(
//               "var style = document.createElement('style');"
//               "style.innerHTML = '.flexRow.pdngSM.justifyBtwn.alignCntr.joinHdr, .flexMinWidthCol.pdngRSM, .flexCol.alignCntr.joinFooter { display: none !important; }';"
//               "document.head.appendChild(style);");
//         }
//       });

//       if (!mounted) return;
//       setState(() {});
//     } catch (e) {
//       _showErrorDialog(e.toString());
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             child: const Text('Continue'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             Image.network('https://videoencryptor.com/assets/images/logo.png'),
//       ),
//       body: Center(
//         child: _controller.value.isInitialized
//             ? Webview(_controller)
//             : const Text(
//                 'Not Initialized',
//                 style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//               ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
