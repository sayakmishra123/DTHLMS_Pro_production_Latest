// import 'package:dthlms/PC/MCQ/mathmlGetx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
// import 'math_equation_controller.dart'; // Import the controller

class MathEquation extends StatefulWidget {
  final String mathMl;
  MathEquation({required this.mathMl, super.key});

  @override
  State<MathEquation> createState() => _MathEquationState();
}

class _MathEquationState extends State<MathEquation> {
  InAppWebViewController? webViewController;

  // // Instantiate the controller with GetX
  // final MathEquationController mathEquationController =
  //     Get.put(MathEquationController());

  Future<void> _sendMathMLToJS({required String mathml}) async {
    // Escape backticks and backslashes in the MathML string to prevent syntax errors
    String escapedMathML = mathml
        .replaceAll('\\', '\\\\')
        .replaceAll('', '\\')
        .replaceAll('\$', '\\\$');

    String jsCode = """
      receiveMathML($escapedMathML);
    """;

    await webViewController?.evaluateJavascript(source: jsCode);
  }

  @override
  void initState() {
    super.initState();
  }

  call() async {
    await _sendMathMLToJS(mathml: widget.mathMl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          child: InAppWebView(
            initialFile: "assets/youtubehtml/equation_solution.html",
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useOnLoadResource: true,
              textZoom: 80,
              defaultFontSize: 100,
              minimumFontSize: 100,
              // loadWithOverviewMode: true
              // crossPlatform: InAppWebViewOptions(
              //     javaScriptEnabled: true,
              //     useOnLoadResource: true,
              //     minimumFontSize: 200,
              //     supportZoom: true),
            ),
            onWebViewCreated: (controller) async {
              webViewController = controller;

              // Add a JavaScript handler to receive data from JS
              webViewController!.addJavaScriptHandler(
                handlerName: 'disableRightClick',
                callback: (args) {
                  return null;
                },
              );
              webViewController!.evaluateJavascript(source: '''
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
      });
    ''');
            },
            onLoadStart: (controller, url) {
              debugPrint("WebView started loading: $url");
            },
            onLoadStop: (controller, url) async {
              controller.evaluateJavascript(source: '''
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
      });
    ''');
              debugPrint("WebView stopped loading: $url");
              // Send MathML to JS once the page is loaded
              await _sendMathMLToJS(mathml: widget.mathMl);
            },
            onJsAlert: (controller, jsAlertRequest) async {
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Alert'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              return JsAlertResponse(
                handledByClient: true,
                action: JsAlertResponseAction.CONFIRM,
              );
            },
          ),
        ),

        // Use GetX to automatically rebuild the widget when the result changes
        // Obx(() {
        //   return Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Text(
        //       "Result from JS: ${mathEquationController.resultFromJS.value}",
        //       style: const TextStyle(fontSize: 16, color: Colors.blue),
        //     ),
        //   );
        // }),
      ],
    );
  }
}