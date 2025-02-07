import 'dart:convert'; // Import jsonEncode
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart'; // Ensure GetX is properly imported

// Import the controller if you want to use GetX (uncomment if needed)
// import 'math_equation_controller.dart';

class MathEquation extends StatefulWidget {
  final String mathMl;
  MathEquation({required this.mathMl, super.key});

  @override
  State<MathEquation> createState() => _MathEquationState();
}

class _MathEquationState extends State<MathEquation> {
  InAppWebViewController? webViewController;

  // If using GetX, instantiate the controller here (uncomment if needed)
  // final MathEquationController mathEquationController = Get.put(MathEquationController());

  // Function to send MathML to JS safely
  Future<void> _sendMathMLToJS({required String mathml}) async {
    // Safely encode the MathML string to prevent issues with special characters
    String escapedMathML = jsonEncode(mathml); // Safely escape the string for JS

    String jsCode = """
      receiveMathML($escapedMathML); // Assuming the JS function 'receiveMathML' is defined
    """;

    try {
      await webViewController?.evaluateJavascript(source: jsCode);
    } catch (e) {
      debugPrint("Error sending MathML to JS: $e");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: Platform.isAndroid?true:  false,
      child: Column(
        children: [
          Container(
            height: 60,
            child: InAppWebView(
              initialFile: "assets/youtubehtml/equation_solution.html", // Path to the HTML file
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useOnLoadResource: true,
                textZoom: 100,
                defaultFontSize: Platform.isAndroid?  30:80,
                minimumFontSize:  Platform.isAndroid?30:80,
              ),
              onWebViewCreated: (controller) async {
                webViewController = controller;
      
                // Inject JS to disable right-clicking in the web view
                await webViewController!.evaluateJavascript(source: '''
                  document.addEventListener('contextmenu', function(e) {
                    e.preventDefault(); 
                  });
                ''');
              },
              onLoadStart: (controller, url) {
                debugPrint("WebView started loading: $url");
              },
              onLoadStop: (controller, url) async {
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
          // If you're using GetX to manage state (e.g., showing results from JS), you can uncomment the following:
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
      ),
    );
  }
}
