import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:collection/equality.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/PC/MCQ/EXAM/VideoPlayerMcq.dart';
import 'package:dthlms/PC/MCQ/MOCKTEST/resultMcqTest.dart';
import 'package:dthlms/PC/MCQ/modelclass.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';
import 'package:dthlms/math_equation.dart';

import 'package:dthlms/utctime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:youtube_quality_player/youtube_quality_player.dart';

// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../MOBILE/MCQ/practiceMcq.dart';
import '../PRACTICE/practiceMcqPage.dart';

class RankedCompetitionMcqPc extends StatefulWidget {
  final List mcqlist;
  final List answerList;
  final String paperId;
  final String examStartTime;
  final String paperName;
  final String duration;
  final String attempt;
  final String totalDuration;
  final Map<int, List<int>> userAnswer;
  final bool isAnswerSheetShow;
  final String examType;
  final String totalMarks;
  RankedCompetitionMcqPc(
      {super.key,
      required this.answerList,
      required this.attempt,
      required this.mcqlist,
      required this.duration,
      required this.examStartTime,
      required this.paperId,
      required this.paperName,
      required this.userAnswer,
      required this.isAnswerSheetShow,
      required this.totalDuration,
      required this.examType,
      required this.totalMarks});

  @override
  State<RankedCompetitionMcqPc> createState() => _RankedCompetitionMcqPcState();
}

class _RankedCompetitionMcqPcState extends State<RankedCompetitionMcqPc> {
  List answer = [];
  List<Map<String, dynamic>> submitedData = [];
  // Store user answers, allowing multiple answers for each question
  Map<int, List<int>> userAns = {};
  late final videoplayer = Player();
  late final videocontroller = VideoController(videoplayer);
  final audioplayer = audio.AudioPlayer();
// await player.play(UrlSource('https://example.com/my-audio.wav'));

  TextEditingController oneWordController = TextEditingController();

  Map<String, String> onewordAnswerList = {};

  Timer _timer = Timer(Duration.zero, () {});
  Getx getx_obj = Get.put(Getx());
  RxBool buttonshow = false.obs;
  RxInt _start = 5.obs;
  RxInt totalDuration = 0.obs;
  String lastattemp = "";
  RxBool showAnswerExplenetion = false.obs;
  Future<void> getdata() async {
    print(widget.mcqlist);
    totalDuration.value = double.parse(widget.totalDuration).toInt() ?? 0;

    // Assuming widget.mcqlist is a valid JSON string
    String jsonData = jsonEncode(widget.mcqlist);

    List<dynamic> parsedJson = jsonDecode(jsonData);
    List<McqItem> mcqDatalist =
        parsedJson.map((json) => McqItem.fromJson(json)).toList();
    mcqData = mcqDatalist;
  }

  InAppWebViewController? webViewController;
  Future<void> _sendMathMLToJS({required String mathml}) async {
    try {
      // Escape backticks and backslashes in the MathML string to prevent syntax errors
      String escapedMathML = mathml
          .replaceAll('\\', '\\\\')
          .replaceAll('`', '\\`')
          .replaceAll('\$', '\\\$');

      String jsCode = """
      receiveMathML(`$escapedMathML`);
    """;

      await webViewController?.evaluateJavascript(source: jsCode);
    } catch (e) {
      writeToFile(e, '_sendMathMLToJS');
    }
  }

  RxString videoHtmlContent = ''.obs;

  Future<void> _initWebViewContent(String youtubeUrl) async {
    // Extract YouTube Video ID
    final videoId = _extractYouTubeId(youtubeUrl);

    // Load HTML content and replace the placeholder with the YouTube Video ID
    final htmlContent =
        await rootBundle.loadString('assets/youtubehtml/video_player.html');
    videoHtmlContent.value = htmlContent.replaceAll('{SOURCE_ID}', videoId);

    // Trigger a rebuild after loading the content
    // setState(() {});
  }

  // Function to extract YouTube Video ID
  String _extractYouTubeId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    }
    return '';
  }

  // Future getdata() async {
  //   String jsonData ='''
  //   ${widget.mcqlist}

  //   ''';

  //   List<dynamic> parsedJson = jsonDecode(jsonData);
  //   List<McqItem> mcqDatalist =
  //       parsedJson.map((json) => McqItem.fromJson(json)).toList();
  //   mcqData = mcqDatalist;
  // }

  Map<int, int> sectionOffsets = {};

  @override
  void initState() {
    if (widget.userAnswer.length != 0) {
      userAns = widget.userAnswer;
    }
    answer = widget.answerList;

// if(widget.)

    print(answer);
    _start.value = double.parse(widget.duration).toInt();
    super.initState();
    if (getx.isInternet.value) {
      fetchTblMCQHistory("").then((mcqhistoryList) {
        unUploadedMcQHistoryInfoInsert(
            context, mcqhistoryList, getx.loginuserdata[0].token);
      });
    }
    sectionWiseQuestionIdList = groupQuestionsBySection(widget.mcqlist);

    // Calculate offsets for each section
    int cumulativeIndex = 0;
    for (var sectionMap in sectionWiseQuestionIdList) {
      int sectionId = sectionMap.keys.first;
      sectionOffsets[sectionId] = cumulativeIndex;
      cumulativeIndex += (sectionMap[sectionId]!.length as int);
    }

    getdata().whenComplete(() => setState(() {}));
    if (widget.examType != "Quick Practice") {
      startTimer();
    }
  }

  List sectionWiseQuestionIdList = [];
  @override
  void dispose() {
    if (widget.examType != "Quick Practice") {
      _timer.cancel();
    }
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start.value == 0) {
          timer.cancel();

          widget.examType == "Ranked Competition"
              ? submitFunction()
              : _onTimeUp(context);
//            List<Map<String, dynamic>> resultJsonData = [];
//             List questionAnswerListofStudent = [];

//             // Loop through all questions in mcqData to ensure each question is processed
//             for (var question in mcqData) {
//               int questionId = int.parse(question.questionId);
//               String questionText = question.questionText;

//               // Get correct answer IDs and texts
//               List<int> correctAnswerIds = answer
//                   .firstWhere((map) => map.containsKey(questionId))[questionId]!
//                   .toList();
//               List<String> correctAnswerTexts = correctAnswerIds
//                   .map((id) => question.options
//                       .firstWhere((opt) => opt.optionId == id.toString())
//                       .optionText)
//                   .toList();

//               // Check if the user provided an answer; if not, set "Not Answered"
//               List<int> selectedOptionIds = userAns[questionId] ?? [];
//               List<String> userSelectedAnswerTexts = selectedOptionIds
//                       .isNotEmpty
//                   ? selectedOptionIds
//                       .map((id) => question.options
//                           .firstWhere((opt) => opt.optionId == id.toString())
//                           .optionText)
//                       .toList()
//                   : ["Not Answered"];

//               questionAnswerListofStudent.add({
//                 "MCQQuestionId ": questionId,
//                 "MCQOptionId ": selectedOptionIds.isNotEmpty
//                     ? selectedOptionIds
//                         .toString()
//                         .replaceAll("[", "")
//                         .replaceAll("]", "")
//                     : "0",
//                 "MCQPaperId ": widget.paperId
//               });

//               // If no answers selected, set user-selected IDs to [-1] to indicate no response
//               resultJsonData.add({
//                 "questionid": questionId,
//                 "question name": questionText,
//                 "correctanswerId": correctAnswerIds,
//                 "correctanswer": correctAnswerTexts,
//                 "userselectedanswer id":
//                     selectedOptionIds.isNotEmpty ? selectedOptionIds : [-1],
//                 "userselectedanswer": userSelectedAnswerTexts,
//               });

//               inserUserTblMCQAnswer(
//                   widget.paperId,
//                   questionId.toString(),
//                   questionText.toString(),
//                   correctAnswerIds.toString(),
//                   correctAnswerTexts.toString(),
//                   selectedOptionIds.isNotEmpty
//                       ? selectedOptionIds.toString()
//                       : "[]",
//                   userSelectedAnswerTexts.toString(),
//                   "",
//                   "",
//                   "");
//             }
//             updateTblUserResultDetails(
//                 "true", widget.paperId, UtcTime().utctime().toString());
//                  updateTblMCQhistory(widget.paperId, widget.attemp, "", DateTime.now().toString(), context);

//             // Log or display JSON data as needed
//             print("Result JSON Data: ");
//             print(resultJsonData);
// //hello
//             submitedData = resultJsonData;
//             //  double totalMarks=calculateTotalMarks(resultJsonData);
//           if(getx.isInternet.value){
//               senddatatoRankedmcqtest(context, getx.loginuserdata[0].token,
//                 questionAnswerListofStudent);
//           }
          // sendmarksToCalculateLeaderboard(context,getx.loginuserdata[0].token,totalMarks.toString(),widget.paperId);
          // _timer.cancel();
          // score.value = correctAnswers;
          // isSubmitted.value = true;
          // Navigator.pop(context);

          // _timer.cancel();
          // score.value = correctAnswers;
          isSubmitted.value = true;
          Navigator.pop(context);
        } else {
          _start.value--;
        }
      },
    );
  }

  String get timerText {
    int hours = _start.value ~/ 3600;
    int minutes = (_start.value % 3600) ~/ 60;
    int seconds = _start.value % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  List<int> reviewlist = [];
  RxBool isPractice = true.obs;
  RxInt qindex = 0.obs;
  int selectedIndex = -1;
  RxBool isSubmitted = false.obs;
  RxInt score = 0.obs;

  List<McqItem> mcqData = [];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Obx(() => isPractice.value
        ? Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              iconTheme: IconThemeData(color: ColorPage.white),
              automaticallyImplyLeading: true,
              centerTitle: false,
              backgroundColor: ColorPage.appbarcolor,
              title: Text(
                widget.paperName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
              actions: [
                widget.examType != "Quick Practice"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 20),
                              Text(
                                'Remaining Time ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20),
                              ),
                              Icon(
                                Icons.watch_later_outlined,
                                color: ColorPage.white,
                              ),
                              Text(
                                ' $timerText',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 50,
                          ),
//                   isSubmitted.value
//                       ? Row(
//                           children: [
//                             MyButton(
//                                 btncolor: Colors.white,
//                                 onPressed: () async{
//                                    List rankdata= await getRankDataOfMockTest(context,getx.loginuserdata[0].token,widget.paperId);
// print(widget.paperId);
// print(submitedData);

//                                  Get.off(()=>MockTestresult(paperId: widget.paperId,questionData: submitedData,));
//                                 },
//                                 mychild: 'Result',
//                                 mycolor: Colors.orangeAccent),
//                             SizedBox(width: 20),
//                           ],
//                         )
//                       : SizedBox(),
                        ],
                      )
                    : SizedBox()
              ],
            ),
            body: Obx(() => SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: SizedBox(
                            height: height,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(8, 8),
                                              blurRadius: 10,
                                            )
                                          ],
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          mcqData[qindex.value].sectionName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(8, 8),
                                                blurRadius: 10,
                                              )
                                            ]),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 60,
                                              child: mcqData[qindex.value]
                                                      .questionText
                                                      .contains('<?xml')
                                                  ?
                                                  // SizedBox()
                                                  InAppWebView(
                                                      initialFile:
                                                          "assets/youtubehtml/equation_solution.html",
                                                      initialSettings:
                                                          InAppWebViewSettings(
                                                        javaScriptEnabled: true,
                                                        useOnLoadResource: true,

                                                        // loadWithOverviewMode:
                                                        //     true
                                                        // crossPlatform: InAppWebViewOptions(
                                                        //     javaScriptEnabled: true,
                                                        //     useOnLoadResource: true,
                                                        //     minimumFontSize: 200,
                                                        //     supportZoom: true),
                                                      ),
                                                      onWebViewCreated:
                                                          (controller) async {
                                                        webViewController =
                                                            controller;

                                                        // Add a JavaScript handler to receive data from JS
                                                        webViewController!
                                                            .addJavaScriptHandler(
                                                          handlerName:
                                                              'disableRightClick',
                                                          callback: (args) {
                                                            return null;
                                                          },
                                                        );
                                                        webViewController!
                                                            .evaluateJavascript(
                                                                source: '''
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
      });
    ''');
                                                      },
                                                      onLoadStart:
                                                          (controller, url) {
                                                        debugPrint(
                                                            "WebView started loading: $url");
                                                      },
                                                      onLoadStop: (controller,
                                                          url) async {
                                                        controller
                                                            .evaluateJavascript(
                                                                source: '''
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
      });
    ''');
                                                        debugPrint(
                                                            "WebView stopped loading: $url");
                                                        // Send MathML to JS once the page is loaded
                                                        await _sendMathMLToJS(
                                                            mathml: mcqData[
                                                                    qindex
                                                                        .value]
                                                                .questionText);
                                                      },
                                                      onJsAlert: (controller,
                                                          jsAlertRequest) async {
                                                        await showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                            title: const Text(
                                                                'Alert'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                        return JsAlertResponse(
                                                          handledByClient: true,
                                                          action:
                                                              JsAlertResponseAction
                                                                  .CONFIRM,
                                                        );
                                                      },
                                                    )
                                                  : Text(
                                                      textAlign:
                                                          TextAlign.center,
                                                      mcqData[qindex.value]
                                                          .questionText,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 20),
                                                    ),
                                            ),
                                            if (mcqData[qindex.value]
                                                        .mCQQuestionType ==
                                                    "Passage Based Answer" &&
                                                getx.isInternet.value)
                                              mcqData[qindex.value]
                                                          .passageDetails !=
                                                      "null"
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: HtmlWidget(
                                                          mcqData[qindex.value]
                                                              .passageDetails),
                                                    )
                                                  : Center(
                                                      child: Text(
                                                          "no passage Found"),
                                                    ),
                                            if (mcqData[qindex.value]
                                                        .mCQQuestionType ==
                                                    "Passage Based Answer" &&
                                                getx.isInternet.value)
                                              mcqData[qindex.value]
                                                          .passageDocumentUrl !=
                                                      "null"
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: Image.network(
                                                          errorBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                        return Text('No image');
                                                      },
                                                          mcqData[qindex.value]
                                                              .passageDocumentUrl),
                                                    )
                                                  : Center(
                                                      child: Text(
                                                          "no passage image Found"),
                                                    ),
                                            if (mcqData[qindex.value]
                                                        .mCQQuestionType ==
                                                    "Image Based Answer" &&
                                                getx.isInternet.value)
                                              mcqData[qindex.value]
                                                          .documnetUrl !=
                                                      "null"
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      child: Image.network(
                                                          errorBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                        return const Text(
                                                            'No image');
                                                      },
                                                          mcqData[qindex.value]
                                                              .documnetUrl),
                                                    )
                                                  : Center(
                                                      child: Text(
                                                          "no image Found"),
                                                    ),
                                            if (mcqData[qindex.value]
                                                        .questionText ==
                                                    "Pdf question" &&
                                                getx.isInternet.value)
                                              Container(
                                                  height: 450,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: mcqData[qindex.value]
                                                              .documnetUrl !=
                                                          "null"
                                                      ? SfPdfViewer.network(
                                                          onDocumentLoadFailed:
                                                              (PdfDocumentLoadFailedDetails
                                                                  details) {
                                                          Text("No PDF");
                                                        },
                                                          mcqData[qindex.value]
                                                              .documnetUrl)
                                                      : Center(
                                                          child: Text(
                                                              "No PDF Found"),
                                                        )),
                                            if (mcqData[qindex.value]
                                                        .mCQQuestionType ==
                                                    "Video Based Answer" &&
                                                getx.isInternet.value)

                                              // VideoPlayerMcq(
                                              //     mcqData[qindex.value]
                                              //         .mCQQuestionUrl)

                                              Container(
                                                  height: 400,
                                                  child: videoHtmlContent
                                                              .value ==
                                                          ''
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator())
                                                      : InAppWebView(
                                                          key: ValueKey(
                                                            videoHtmlContent
                                                                .value,
                                                          ),
                                                          initialData:
                                                              InAppWebViewInitialData(
                                                            data:
                                                                videoHtmlContent
                                                                    .value,
                                                            mimeType:
                                                                'text/html',
                                                            encoding: 'utf-8',
                                                          ),
                                                          onWebViewCreated:
                                                              (controller) {
                                                            webViewController =
                                                                controller;
                                                            webViewController!
                                                                .addJavaScriptHandler(
                                                              handlerName:
                                                                  'disableRightClick',
                                                              callback: (args) {
                                                                return null;
                                                              },
                                                            );
                                                            webViewController!
                                                                .evaluateJavascript(
                                                                    source: '''
                                                    document.addEventListener('contextmenu', function(e) {
                                                      e.preventDefault();
                                                    });
                                                  ''');
                                                          },
                                                          onLoadStart:
                                                              (controller,
                                                                  url) {
                                                            debugPrint(
                                                                "WebView started loading: $url");
                                                          },
                                                          onLoadStop:
                                                              (controller,
                                                                  url) {
                                                            debugPrint(
                                                                "WebView stopped loading: $url");
                                                            controller
                                                                .evaluateJavascript(
                                                                    source: '''
                                                    document.addEventListener('contextmenu', function(e) {
                                                      e.preventDefault();
                                                    });
                                                  ''');
                                                          },
                                                          onLoadError:
                                                              (controller,
                                                                  url,
                                                                  code,
                                                                  message) {
                                                            debugPrint(
                                                                "WebView load error: $message");
                                                          },
                                                        )

                                                  // InAppWebView(
                                                  //   initialFile: "assets/youtubehtml/video_player.html",
                                                  //   initialOptions: InAppWebViewGroupOptions(
                                                  //     crossPlatform: InAppWebViewOptions(
                                                  //       javaScriptEnabled: true,
                                                  //       useOnLoadResource: true,
                                                  //     ),
                                                  //   ),
                                                  //   onWebViewCreated: (controller) async {
                                                  //     webViewController = controller;

                                                  //     // Add a JavaScript handler to receive data from JS
                                                  //     controller.addJavaScriptHandler(
                                                  //       handlerName: 'JSHandler',
                                                  //       callback: (args) {
                                                  //         if (args.isNotEmpty && args[0] is Map) {
                                                  //           Map<String, dynamic> data =
                                                  //               Map<String, dynamic>.from(args[0]);

                                                  //           // Use the controller to update the result
                                                  //           // mathEquationController.updateResult(
                                                  //           //     data['numeric'].toString(),
                                                  //           //     data['fraction'].toString());
                                                  //           debugPrint(
                                                  //               "Result from JS: ${data['numeric']}, ${data['fraction']}");
                                                  //         }
                                                  //         return {'status': 'Received'};
                                                  //       },
                                                  //     );
                                                  //   },
                                                  //   onLoadStart: (controller, url) {
                                                  //     debugPrint("WebView started loading: $url");
                                                  //   },
                                                  //   onLoadStop: (controller, url) async {
                                                  //     debugPrint("WebView stopped loading: $url");
                                                  //     // Send MathML to JS once the page is loaded
                                                  //     // await _sendMathMLToJS(mathml: widget.mathMl);
                                                  //   },
                                                  //   onJsAlert: (controller, jsAlertRequest) async {
                                                  //     await showDialog(
                                                  //       context: context,
                                                  //       builder: (context) => AlertDialog(
                                                  //         title: const Text('Alert'),
                                                  //         actions: [
                                                  //           TextButton(
                                                  //             onPressed: () => Navigator.pop(context),
                                                  //             child: const Text('OK'),
                                                  //           ),
                                                  //         ],
                                                  //       ),
                                                  //     );
                                                  //     return JsAlertResponse(
                                                  //       handledByClient: true,
                                                  //       action: JsAlertResponseAction.CONFIRM,
                                                  //     );
                                                  //   },
                                                  // ),
                                                  ),
                                            if (mcqData[qindex.value]
                                                        .mCQQuestionType ==
                                                    "Audio Based Answer" &&
                                                getx.isInternet.value)
                                              Container(
                                                // height: 400,
                                                // width: MediaQuery.of(context).size.width/3,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                child: Container(
                                                    child: PlayerWidget(
                                                        audioplayer:
                                                            audioplayer)),
                                              ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 20, horizontal: 10),
                                              color: Colors.black26,
                                              height: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: SizedBox(
                            height: height,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(8, 8),
                                                blurRadius: 10,
                                              )
                                            ]),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          'Options',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                mcqData[qindex.value].mCQQuestionType ==
                                        "One Word Answer"
                                    ? Row(
                                        children: [
                                          Text(" Write your answer here",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ))
                                        ],
                                      )
                                    : mcqData[qindex.value].isMultiple == 'true'
                                        ? Row(
                                            children: [
                                              Text(
                                                  "  * Multiple selection available for this question.",
                                                  style: TextStyle(
                                                    color: ColorPage.green,
                                                  ))
                                            ],
                                          )
                                        : SizedBox(),
                                SizedBox(height: 10),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 500,
                                  child: ListView.builder(
                                    key: ValueKey(qindex.value),
                                    itemCount:
                                        mcqData[qindex.value].options.length,
                                    itemBuilder: (context, index) {
                                      String optionId = mcqData[qindex.value]
                                          .options[index]
                                          .optionId;
                                      String questionId =
                                          mcqData[qindex.value].questionId;

                                      // Check if the option is selected
                                      bool isSelected = userAns.containsKey(
                                              int.parse(questionId)) &&
                                          userAns[int.parse(questionId)]!
                                              .contains(int.parse(optionId));
                                      List<int> correctAnswersForQuestion =
                                          answer
                                              .firstWhere((map) =>
                                                  map.containsKey(
                                                      int.parse(questionId)))[
                                                  int.parse(questionId)]!
                                              .toList();

                                      // Check if the option is correct
                                      bool isCorrect = answer.any(
                                        (map) =>
                                            map.containsKey(
                                                int.parse(questionId)) &&
                                            map[int.parse(questionId)]!
                                                .contains(int.parse(optionId)),
                                      );
                                      bool isCorrectforPractice =
                                          correctAnswersForQuestion
                                              .contains(int.parse(optionId));

                                      Color tileColor;

                                      if (widget.examType == "Quick Practice") {
                                        if (isSelected) {
                                          tileColor = isCorrect
                                              ? Colors.green
                                              : Colors.red;
                                        } else if (userAns.containsKey(
                                                int.parse(questionId)) &&
                                            userAns[int.parse(questionId)]!
                                                    .length >=
                                                correctAnswersForQuestion
                                                    .length) {
                                          // Reveal correct answers in green after max selections
                                          tileColor = isCorrect
                                              ? Colors.green
                                              : Colors.white;
                                        } else {
                                          tileColor = Colors.white;
                                        }
                                      } else {
                                        tileColor = isSelected
                                            ? Colors.blue
                                            : Colors.white;
                                      }
                                      bool isSelectionDisabled = false;
                                      if (widget.examType == "Quick Practice") {
                                        isSelectionDisabled = userAns
                                                .containsKey(
                                                    int.parse(questionId)) &&
                                            ((mcqData[qindex.value]
                                                            .isMultiple ==
                                                        'true' &&
                                                    userAns[int.parse(
                                                                questionId)]!
                                                            .length >=
                                                        correctAnswersForQuestion
                                                            .length) ||
                                                mcqData[qindex.value]
                                                        .isMultiple ==
                                                    'false');
                                      }

                                      // default color

                                      return mcqData[qindex.value]
                                                  .mCQQuestionType ==
                                              "One Word Answer"
                                          ? Column(
                                              children: [
                                                Container(
                                                  child: SizedBox(
                                                      child: TextFormField(
                                                    readOnly: userAns.containsKey(
                                                            int.parse(
                                                                questionId)) &&
                                                        widget.examType ==
                                                            "Quick Practice",
                                                    onSaved: (value) {
                                                      print(value.toString());

                                                      if (!isSubmitted.value) {
                                                        if (oneWordController
                                                                .text !=
                                                            "") {
                                                          userAns[int.parse(
                                                              questionId)] = [
                                                            int.parse(optionId)
                                                          ];
                                                        }

                                                        userAns[int.parse(
                                                            questionId)] = [
                                                          int.parse(optionId)
                                                        ];
                                                        print("update calling");

                                                        updateOneWordAnswerofStudent(
                                                            optionId,
                                                            questionId,
                                                            oneWordController
                                                                .text);
                                                        onewordAnswerList[
                                                                questionId] =
                                                            oneWordController
                                                                .text;
                                                      }
                                                    },
                                                    onChanged: (value) {
                                                      print(value.toString());

                                                      if (!isSubmitted.value) {
                                                        if (oneWordController
                                                                .text !=
                                                            "") {
                                                          userAns[int.parse(
                                                              questionId)] = [
                                                            int.parse(optionId)
                                                          ];
                                                        }

                                                        print("update calling");

                                                        updateOneWordAnswerofStudent(
                                                            optionId,
                                                            questionId,
                                                            oneWordController
                                                                .text);
                                                        onewordAnswerList[
                                                                questionId] =
                                                            oneWordController
                                                                .text;
                                                      }
                                                    },
                                                    onTapOutside: (value) {
                                                      print(value.toString());

                                                      if (!isSubmitted.value) {
                                                        if (oneWordController
                                                                .text !=
                                                            "") {
                                                          userAns[int.parse(
                                                              questionId)] = [
                                                            int.parse(optionId)
                                                          ];
                                                        }

                                                        print("update calling");

                                                        updateOneWordAnswerofStudent(
                                                            optionId,
                                                            questionId,
                                                            oneWordController
                                                                .text);
                                                        onewordAnswerList[
                                                                questionId] =
                                                            oneWordController
                                                                .text;
                                                      }
                                                    },
                                                    // onChanged:(value){
                                                    //   print(value);
                                                    //    if (!isSubmitted.value) {
                                                    //     userAns[
                                                    //         int.parse(questionId)] = [
                                                    //       int.parse(optionId)
                                                    //     ];
                                                    //   }
                                                    // } ,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                    keyboardType:
                                                        TextInputType.name,
                                                    controller:
                                                        oneWordController,
                                                    decoration: InputDecoration(
                                                      fillColor: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      filled: true,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: Color.fromARGB(
                                                              255,
                                                              141,
                                                              139,
                                                              139),
                                                        ),
                                                        gapPadding: 20,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: Color.fromARGB(
                                                              255,
                                                              196,
                                                              194,
                                                              194),
                                                        ),
                                                        gapPadding: 20,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                  )),
                                                ),
                                                userAns.containsKey(int.parse(
                                                            questionId)) &&
                                                        widget.examType ==
                                                            "Quick Practice"
                                                    ? Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black12,
                                                                  offset:
                                                                      Offset(
                                                                          8, 8),
                                                                  blurRadius:
                                                                      10,
                                                                )
                                                              ]),
                                                          child: Text(
                                                              "Answer : ${getOneWordAnswerFromQuestionId(questionId.toString())} "),
                                                        ))
                                                    : SizedBox()
                                              ],
                                            )
                                          : Padding(
  padding: EdgeInsets.symmetric(vertical: 10),
  child: AnimatedContainer(
    duration: Duration(milliseconds: 600),
    curve: Curves.easeInOut,
    decoration: BoxDecoration(
      color: tileColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            if (widget.examType == "Quick Practice") {
              if (isSelectionDisabled) return;

              if (mcqData[qindex.value].isMultiple == 'true') {
                // Multi-select logic
                if (userAns.containsKey(int.parse(questionId))) {
                  if (userAns[int.parse(questionId)]!.contains(int.parse(optionId))) {
                    return; // Prevent unselecting
                  } else {
                    userAns[int.parse(questionId)]!.add(int.parse(optionId));
                  }
                } else {
                  userAns[int.parse(questionId)] = [int.parse(optionId)];
                }

                if (userAns[int.parse(questionId)]!.length == correctAnswersForQuestion.length) {
                  setState(() {
                    isSelectionDisabled = true;
                    showAnswerExplenetion.value = true;
                  });
                }
              } else {
                // Single select logic
                userAns[int.parse(questionId)] = [int.parse(optionId)];
                showAnswerExplenetion.value = userAns.containsKey(int.parse(mcqData[qindex.value].questionId));
              }
            }

            if (widget.examType == "Ranked Competition" || widget.examType == "Comprehensive") {
              if (!isSubmitted.value) {
                if (userAns.containsKey(int.parse(questionId))) {
                  if (mcqData[qindex.value].isMultiple == 'true') {
                    if (userAns[int.parse(questionId)]!.contains(int.parse(optionId))) {
                      userAns[int.parse(questionId)]!.remove(int.parse(optionId));
                    } else {
                      userAns[int.parse(questionId)]!.add(int.parse(optionId));
                    }
                  } else {
                    userAns[int.parse(questionId)] = [int.parse(optionId)];
                  }
                } else {
                  userAns[int.parse(questionId)] = [int.parse(optionId)];
                }
              }
            }
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: GestureDetector(
                onTap: () {
                  
                  // Handle tap within MathEquation (if needed)
                },
                child: Container(
                  // Ensuring MathEquation widget has proper width and height
                  width: double.infinity, // Make it take full width of the parent
                  height: 80, // Adjust height based on your design
                  child: mcqData[qindex.value].options[index].optionText.contains('<?xml')
                      ?GestureDetector(
                          onTap: () {
                            print("Inside MathEquation tapped!"); // Debugging MathEquation tap
                          },
                          child: AbsorbPointer(
                            absorbing: true, // Make sure WebView doesn't block taps
                            child: MathEquation(mathMl: mcqData[qindex.value].options[index].optionText),
                          ),
                        )
                      : Text(
                          mcqData[qindex.value].options[index].optionText,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);

                                    },
                                  ),
                                ),
                                showAnswerExplenetion.value &&
                                        widget.examType == "Quick Practice" &&
                                        mcqData[qindex.value]
                                                .answerExplanation !=
                                            "0"
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 250,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      offset: Offset(8, 8),
                                                      blurRadius: 10,
                                                    )
                                                  ]),
                                              child: mcqData[qindex.value]
                                                      .answerExplanation
                                                      .contains('<?xml')
                                                  ? Container(
                                                      height: 100,
                                                      child: InAppWebView(
                                                        initialSettings:
                                                            InAppWebViewSettings(
                                                          javaScriptEnabled:
                                                              true,
                                                          useOnLoadResource:
                                                              true,
                                                          textZoom: 60,
                                                          defaultFontSize: 60,
                                                          minimumFontSize: 60,
                                                          // loadWithOverviewMode: true
                                                          // crossPlatform: InAppWebViewOptions(
                                                          //     javaScriptEnabled: true,
                                                          //     useOnLoadResource: true,
                                                          //     minimumFontSize: 200,
                                                          //     supportZoom: true),
                                                        ),
                                                        initialFile:
                                                            "assets/youtubehtml/equation_solution.html",
                                                        initialOptions:
                                                            InAppWebViewGroupOptions(
                                                          crossPlatform:
                                                              InAppWebViewOptions(
                                                            //  defaultFontSize: 120,

                                                            // minimumFontSize: 80,
                                                            // defaultFontSize: 120,

                                                            javaScriptEnabled:
                                                                true,
                                                            useOnLoadResource:
                                                                true,
                                                          ),
                                                        ),
                                                        onWebViewCreated:
                                                            (controller) async {
                                                          webViewController =
                                                              controller;

                                                          // Add a JavaScript handler to receive data from JS
                                                          webViewController!
                                                              .addJavaScriptHandler(
                                                            handlerName:
                                                                'disableRightClick',
                                                            callback: (args) {
                                                              return null;
                                                            },
                                                          );

                                                          webViewController!
                                                              .evaluateJavascript(
                                                                  source: '''
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
      });
    ''');
                                                        },
                                                        onLoadStart:
                                                            (controller, url) {
                                                          debugPrint(
                                                              "WebView started loading: $url");
                                                        },
                                                        onLoadStop: (controller,
                                                            url) async {
                                                          controller
                                                              .evaluateJavascript(
                                                                  source: '''
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
      });
    ''');
                                                          debugPrint(
                                                              "WebView stopped loading: $url");
                                                          // Send MathML to JS once the page is loaded
                                                          await _sendMathMLToJS(
                                                              mathml: mcqData[
                                                                      qindex
                                                                          .value]
                                                                  .answerExplanation);
                                                        },
                                                        onJsAlert: (controller,
                                                            jsAlertRequest) async {
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: const Text(
                                                                  'Alert'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child:
                                                                      const Text(
                                                                          'OK'),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                          return JsAlertResponse(
                                                            handledByClient:
                                                                true,
                                                            action:
                                                                JsAlertResponseAction
                                                                    .CONFIRM,
                                                          );
                                                        },
                                                      ))
                                                  : SingleChildScrollView(
                                                      child: HtmlWidget(mcqData[
                                                              qindex.value]
                                                          .answerExplanation)),
                                            ),
                                          )
                                        ],
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 50,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MaterialButton(
                                      height: 40,
                                      color: ColorPage.appbarcolorcopy,
                                      padding: EdgeInsets.all(16),
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      onPressed: () async {
                                        if (qindex.value > 0) {
                                          audioplayer.pause();
                                          qindex.value--;
                                          oneWordController.text =
                                              onewordAnswerList[
                                                      mcqData[qindex.value]
                                                          .questionId] ??
                                                  "";
                                          if (widget.examType ==
                                              "Quick Practice") {
                                            showAnswerExplenetion.value =
                                                userAns.containsKey(int.parse(
                                                    mcqData[qindex.value]
                                                        .questionId));
                                          }
                                          if (mcqData[qindex.value]
                                                  .mCQQuestionType ==
                                              "Video Based Answer") {
                                            _initWebViewContent(
                                                mcqData[qindex.value]
                                                    .mCQQuestionUrl);
                                          }
                                          if (mcqData[qindex.value]
                                                  .mCQQuestionType ==
                                              "Audio Based Answer") {
                                            // final player = AudioPlayer();
                                            intializeAudioLink(
                                                mcqData[qindex.value]
                                                    .documnetUrl);
                                            // catch(e){
                                            //   print(e.toString());
                                            // }
                                          }
                                        }

                                        mcqData[qindex.value]
                                                .questionText
                                                .contains('<?xml')
                                            ? await _sendMathMLToJS(
                                                mathml: mcqData[qindex.value]
                                                    .questionText)
                                            : null;

                                        mcqData[qindex.value]
                                                .answerExplanation
                                                .contains('<?xml')
                                            ? await _sendMathMLToJS(
                                                mathml: mcqData[qindex.value]
                                                    .answerExplanation)
                                            : null;
                                      },
                                      child: Text(
                                        'Previous',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    MaterialButton(
                                      height: 40,
                                      color: ColorPage.appbarcolorcopy,
                                      padding: EdgeInsets.all(16),
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      onPressed: () async {
                                        if (widget.examType ==
                                            "Quick Practice") {
                                          if (qindex.value <
                                              mcqData.length - 1) {
                                            audioplayer.pause();
                                            qindex.value++;
                                            oneWordController.text =
                                                onewordAnswerList[
                                                        mcqData[qindex.value]
                                                            .questionId] ??
                                                    "";
                                            showAnswerExplenetion.value =
                                                userAns.containsKey(int.parse(
                                                    mcqData[qindex.value]
                                                        .questionId));

                                            if (mcqData[qindex.value]
                                                    .mCQQuestionType ==
                                                "Video Based Answer") {
                                              _initWebViewContent(
                                                  mcqData[qindex.value]
                                                      .mCQQuestionUrl);

                                              // videoplayer.open(Media(
                                              //     mcqData[qindex.value]
                                              //         .mCQQuestionUrl)

                                              //         );
                                            }
                                            if (mcqData[qindex.value]
                                                    .mCQQuestionType ==
                                                "Audio Based Answer") {
                                              // final player = AudioPlayer();
                                              intializeAudioLink(
                                                  mcqData[qindex.value]
                                                      .documnetUrl);
                                            }

                                            // final player = AudioPlayer();
                                          } else if (qindex.value ==
                                              mcqData.length - 1) {
                                            onExitexmPage(context, () {
                                              Navigator.pop(context);
                                              updateTblMCQhistory(
                                                      widget.paperId,
                                                      lastattemp != ""
                                                          ? lastattemp
                                                          : widget.attempt,
                                                      calculatePercentage(
                                                              userAns, answer)
                                                          .toString(),
                                                      DateTime.now().toString(),
                                                      context)
                                                  .then((_) {
                                                userAns.clear();

                                                onewordAnswerList.clear();
                                                oneWordController.text = "";
                                                setState(() {
                                                  lastattemp =
                                                      DateTime.now().toString();
                                                  inserTblMCQhistory(
                                                      widget.paperId,
                                                      'Quick Practice',
                                                      widget.paperName,
                                                      '',
                                                      '',
                                                      lastattemp,
                                                      "0");
                                                  qindex.value = 0;
                                                });
                                              });
                                            }, () {
                                              updateTblMCQhistory(
                                                  widget.paperId,
                                                  lastattemp != ""
                                                      ? lastattemp
                                                      : widget.attempt,
                                                  calculatePercentage(
                                                          userAns, answer)
                                                      .toString(),
                                                  DateTime.now().toString(),
                                                  context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });

                                            // _onSubmitExam(context);
                                          }
                                        }

                                        if (widget.examType ==
                                            "Comprehensive") {
                                          if (qindex.value <
                                              mcqData.length - 1) {
                                            audioplayer.pause();
                                            qindex.value++;
                                            oneWordController.text =
                                                onewordAnswerList[
                                                        mcqData[qindex.value]
                                                            .questionId] ??
                                                    "";
                                            if (mcqData[qindex.value]
                                                    .mCQQuestionType ==
                                                "Video Based Answer") {
                                              _initWebViewContent(
                                                  mcqData[qindex.value]
                                                      .mCQQuestionUrl);
                                            }
                                            if (mcqData[qindex.value]
                                                    .mCQQuestionType ==
                                                "Audio Based Answer") {
                                              // final player = AudioPlayer();
                                              intializeAudioLink(
                                                  mcqData[qindex.value]
                                                      .documnetUrl);
                                            }
                                          } else if (qindex.value ==
                                                  mcqData.length - 1 &&
                                              !isSubmitted.value) {
                                            _onSubmitComprehensiveExam(context);
                                          }
                                        }

                                        if (widget.examType ==
                                            "Ranked Competition") {
                                          // if( mcqData[qindex.value]
                                          //                     .mCQQuestionType ==
                                          //                 "One Word Answer"){

                                          //                                          if (!isSubmitted.value) {
                                          //            userAns[int.parse(
                                          //                   mcqData[qindex.value]
                                          //                     .questionId)] = [
                                          //                 int.parse(mcqData[qindex.value]
                                          //   .options[0]
                                          //   .optionId)
                                          //               ];

                                          //                                          }
                                          //                 }
                                          print(mcqData[qindex.value]
                                              .questionId
                                              .toString());

                                          double obtainmarks =
                                              calculateTotalMarkOfQuestion(
                                                  mcqData[qindex.value]
                                                      .questionId
                                                      .toString(),
                                                  userAns[int.parse(
                                                          mcqData[qindex.value]
                                                              .questionId)] ??
                                                      [],
                                                  mcqData[qindex.value]
                                                      .mCQQuestionType);
//

                                          List<String> userSelectedAnswerTexts =
                                              userAns[int.parse(mcqData[qindex.value].questionId)] !=
                                                      null
                                                  ? userAns[int.parse(
                                                          mcqData[qindex.value]
                                                              .questionId)]!
                                                      .map((id) =>
                                                          mcqData[qindex.value]
                                                              .options
                                                              .firstWhere((opt) =>
                                                                  opt.optionId ==
                                                                  id.toString())
                                                              .optionText)
                                                      .toList()
                                                  : ["Not Answered"];
                                          //
                                          List<int> correctAnswerIds =
                                              answer.firstWhere((map) =>
                                                      map.containsKey(int.parse(
                                                          mcqData[qindex.value]
                                                              .questionId)))[int
                                                      .parse(mcqData[qindex.value]
                                                          .questionId)] ??
                                                  [].toList();
                                          List<String> correctAnswerTexts =
                                              correctAnswerIds
                                                  .map((id) =>
                                                      mcqData[qindex.value]
                                                          .options
                                                          .firstWhere((opt) =>
                                                              opt.optionId ==
                                                              id.toString())
                                                          .optionText)
                                                  .toList();

                                          //
                                          print(userAns[int.parse(
                                                      mcqData[qindex.value]
                                                          .questionId)]
                                                  .toString() +
                                              "///////////////////////////////////////////////////cvvvcgvchvcgcvds");
                                          Map questionanswerList = {
                                            "MCQQuestionId":
                                                mcqData[qindex.value]
                                                    .questionId,
                                            "MCQOptionId": userAns[int.parse(
                                                        mcqData[qindex.value]
                                                            .questionId)] !=
                                                    null
                                                ? userAns[int.parse(
                                                        mcqData[qindex.value]
                                                            .questionId)]
                                                    .toString()
                                                    .replaceAll("[", "")
                                                    .replaceAll("]", "")
                                                : "0",
                                            "MCQPaperId": widget.paperId,
                                            "Marks": obtainmarks.toString(),
                                            "IsCorrect":
                                                obtainmarks > 0 ? true : false,
                                            "OneWordAnswer":
                                                oneWordController.text,
                                          };
                                          inserUserTblMCQAnswer(
                                              widget.paperId,
                                              mcqData[qindex.value]
                                                  .questionId
                                                  .toString(),
                                              mcqData[qindex.value]
                                                  .questionText
                                                  .toString(),
                                              correctAnswerIds.toString(),
                                              correctAnswerTexts.toString(),
                                              userAns[int.parse(
                                                          mcqData[qindex.value]
                                                              .questionId)] !=
                                                      null
                                                  ? userAns[int.parse(
                                                          mcqData[qindex.value]
                                                              .questionId)]
                                                      .toString()
                                                  : "[]",
                                              userSelectedAnswerTexts
                                                  .toString(),
                                              "",
                                              "",
                                              "");

                                          if (qindex.value <
                                              mcqData.length - 1) {
                                            if (getx.isInternet.value) {
                                              fetchTblMCQHistory("")
                                                  .then((mcqhistoryList) {
                                                unUploadedMcQHistoryInfoInsert(
                                                    context,
                                                    mcqhistoryList,
                                                    getx.loginuserdata[0]
                                                        .token);
                                              });
                                              senddatatoRankedmcqtest(
                                                      context,
                                                      getx.loginuserdata[0]
                                                          .token,
                                                      [questionanswerList],
                                                      (totalDuration.value -
                                                              (_start.value))
                                                          .toString())
                                                  .then((value) async {
                                                if (value) {
                                                  audioplayer.pause();
                                                  qindex.value++;
                                                  oneWordController
                                                      .text = onewordAnswerList[
                                                          mcqData[qindex.value]
                                                              .questionId] ??
                                                      "";
                                                  if (mcqData[qindex.value]
                                                          .mCQQuestionType ==
                                                      "Video Based Answer") {
                                                    _initWebViewContent(
                                                        mcqData[qindex.value]
                                                            .mCQQuestionUrl);
                                                  }
                                                  if (mcqData[qindex.value]
                                                          .mCQQuestionType ==
                                                      "Audio Based Answer") {
                                                    // final player = AudioPlayer();
                                                    intializeAudioLink(
                                                        mcqData[qindex.value]
                                                            .documnetUrl);
                                                  }
                                                } else {
                                                  onSaveFaild(context, () {
                                                    Get.back();
                                                  });
                                                }
                                              });
                                            } else {
                                              onNoInternetConnection(context,
                                                  () {
                                                Get.back();
                                              });
                                            }

                                            // qindex.value++;
                                          } else if (qindex.value ==
                                                  mcqData.length - 1 &&
                                              !isSubmitted.value) {
                                            _onSubmitExam(context, true, () {
                                              Navigator.pop(context);

                                              if (getx.isInternet.value) {
                                                senddatatoRankedmcqtest(
                                                        context,
                                                        getx.loginuserdata[0]
                                                            .token,
                                                        [questionanswerList],
                                                        (totalDuration.value -
                                                                (_start.value))
                                                            .toString())
                                                    .then((value) {
                                                  if (value) {
                                                    _timer.cancel();

                                                    isSubmitted.value = true;
                                                    Get.back();
                                                  } else {
                                                    onSaveFaild(context, () {
                                                      Get.back();
                                                    });
                                                  }
                                                });
                                              } else {
                                                onNoInternetConnection(context,
                                                    () {
                                                  Get.back();
                                                });
                                              }

                                              submitFunction();

                                              // sendmarksToCalculateLeaderboard(context,getx.loginuserdata[0].token,totalMarks.toString(),widget.paperId);
                                              // _timer.cancel();
                                              // score.value = correctAnswers;
                                              // isSubmitted.value = true;
                                              // Navigator.pop(context);
                                            });
                                          }

                                          mcqData[qindex.value]
                                                  .questionText
                                                  .contains('<?xml')
                                              ? await _sendMathMLToJS(
                                                  mathml: mcqData[qindex.value]
                                                      .questionText)
                                              : null;
                                        }

                                        print(
                                            'object jdsfhfjsvfvdsfvsgfvhgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdf');
                                        mcqData[qindex.value]
                                                .questionText
                                                .contains('<?xml')
                                            ? await _sendMathMLToJS(
                                                mathml: mcqData[qindex.value]
                                                    .questionText)
                                            : null;

                                        log(mcqData[qindex.value].questionText +
                                            "  Sayak");

                                        mcqData[qindex.value]
                                                .answerExplanation
                                                .contains('<?xml')
                                            ? await _sendMathMLToJS(
                                                mathml: mcqData[qindex.value]
                                                    .answerExplanation)
                                            : null;

                                        setState(() {});
                                      },
                                      child: Text(
                                        !isSubmitted.value &&
                                                qindex.value ==
                                                    mcqData.length - 1
                                            ? widget.examType ==
                                                    "Quick Practice"
                                                ? "Submit & Reset"
                                                : 'Submit'
                                            : widget.examType !=
                                                    "Quick Practice"
                                                ? 'Save & Next'
                                                : "Next",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Container(
                                width: 350,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: ExpansionTile(
                                    initiallyExpanded: true,
                                    onExpansionChanged: (Value) {
                                      buttonshow.value = Value;
                                    },
                                    shape:
                                        Border.all(color: Colors.transparent),
                                    backgroundColor: ColorPage.white,
                                    collapsedBackgroundColor: ColorPage.white,
                                    title: Text("All Questions"),
                                    children: [
                                      Container(
                                          height: 55 *
                                                  ((widget.mcqlist.length ~/
                                                          4) +
                                                      1) +
                                              sectionWiseQuestionIdList.length *
                                                  110,
                                          child: ListView.builder(
                                              itemCount:
                                                  sectionWiseQuestionIdList
                                                      .length,
                                              itemBuilder: (context, index) {
                                                Map<int, List<int>> data =
                                                    sectionWiseQuestionIdList[
                                                        index];
                                                List<int> indexList =
                                                    data.values.first;
                                                return Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              fetchSectionName(data
                                                                  .keys
                                                                  .toString()
                                                                  .replaceAll(
                                                                      "(", "")
                                                                  .replaceAll(
                                                                      ")",
                                                                      ""))),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 80 *
                                                          ((indexList.length ~/
                                                                  4) +
                                                              1),
                                                      child: GridView.builder(
                                                          itemCount:
                                                              indexList.length,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      4),
                                                          itemBuilder:
                                                              (context, ind) {
                                                            // Get section ID and cumulative offset
                                                            int sectionId =
                                                                data.keys.first;
                                                            int offset =
                                                                sectionOffsets[
                                                                    sectionId]!;

                                                            return SingleChildScrollView(
                                                              child:
                                                                  MaterialButton(
                                                                height: 55,
                                                                color: reviewlist.contains(offset +
                                                                            ind) &&
                                                                        !isSubmitted
                                                                            .value
                                                                    ? Colors
                                                                        .amber
                                                                    : userAns.containsKey(indexList[
                                                                            ind])
                                                                        ? widget.examType ==
                                                                                "Quick Practice"
                                                                            ? mcqData[offset + ind].mCQQuestionType == "One Word Answer"
                                                                                ? getOneWordAnswerFromQuestionId(mcqData[offset + ind].questionId.toString()).replaceAll(" ", "").toLowerCase() == onewordAnswerList[mcqData[offset + ind].questionId.toString()].toString().replaceAll(" ", "").toLowerCase()
                                                                                    ? Colors.green
                                                                                    : Colors.red
                                                                                : answer.any((map) => map.values.any((List<int> list) => list.any((item) => userAns[indexList[ind]]!.contains(item))))
                                                                                    ? Colors.green
                                                                                    : Colors.red
                                                                            : Colors.blue
                                                                        : qindex.value == offset + ind
                                                                            ? Color.fromARGB(255, 13, 32, 79)
                                                                            : Colors.white,
                                                                shape: CircleBorder(
                                                                    side: BorderSide(
                                                                        width: qindex.value == offset + ind
                                                                            ? 4
                                                                            : 1,
                                                                        color: qindex.value ==
                                                                                offset + ind
                                                                            ? ColorPage.white
                                                                            : Colors.black12)),
                                                                onPressed:
                                                                    () async {
                                                                  audioplayer
                                                                      .pause();
                                                                  qindex.value =
                                                                      offset +
                                                                          ind;

                                                                  oneWordController
                                                                          .text =
                                                                      onewordAnswerList[
                                                                              mcqData[qindex.value].questionId] ??
                                                                          "";

                                                                  if (widget
                                                                          .examType ==
                                                                      "Quick Practice") {
                                                                    showAnswerExplenetion
                                                                        .value = userAns.containsKey(int.parse(mcqData[
                                                                            qindex.value]
                                                                        .questionId));
                                                                  }
                                                                  if (mcqData[qindex
                                                                              .value]
                                                                          .mCQQuestionType ==
                                                                      "Video Based Answer") {
                                                                    _initWebViewContent(
                                                                        mcqData[qindex.value]
                                                                            .mCQQuestionUrl);
                                                                  }
                                                                  if (mcqData[qindex
                                                                              .value]
                                                                          .mCQQuestionType ==
                                                                      "Audio Based Answer") {
                                                                    intializeAudioLink(
                                                                        mcqData[qindex.value]
                                                                            .documnetUrl);
                                                                  }

                                                                  mcqData[qindex
                                                                              .value]
                                                                          .questionText
                                                                          .contains(
                                                                              '<?xml')
                                                                      ? await _sendMathMLToJS(
                                                                          mathml:
                                                                              mcqData[qindex.value].questionText)
                                                                      : null;
                                                                  mcqData[qindex
                                                                              .value]
                                                                          .answerExplanation
                                                                          .contains(
                                                                              '<?xml')
                                                                      ? await _sendMathMLToJS(
                                                                          mathml:
                                                                              mcqData[qindex.value].answerExplanation)
                                                                      : null;
                                                                },
                                                                child: Text(
                                                                  (ind + 1)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: qindex.value ==
                                                                              offset +
                                                                                  ind
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ],
                                                );
                                              }))
                                      // Container(
                                      //   height: 400,
                                      //   child: GridView.builder(
                                      //     itemCount: mcqData.length,
                                      //     gridDelegate:
                                      //         SliverGridDelegateWithFixedCrossAxisCount(
                                      //             crossAxisCount: 4),
                                      //     itemBuilder: (context, index) {
                                      //       return SingleChildScrollView(
                                      //         child: MaterialButton(
                                      //           height: 55,
                                      //           color: reviewlist.contains(index)
                                      //               ? Colors.amber
                                      //               : userAns.containsKey(index + 1)
                                      //                   ? isSubmitted.value
                                      //                       ? answer.any((map) =>
                                      //                               map[index + 1]!.contains(userAns[index + 1]!))
                                      //                           ? Colors.green
                                      //                           : Colors.red
                                      //                       : Colors.blue
                                      //                   : qindex.value == index
                                      //                       ? Color.fromARGB(
                                      //                           255, 13, 32, 79)
                                      //                       : Colors.white,
                                      //           shape: CircleBorder(
                                      //               side: BorderSide(
                                      //                   width: qindex.value == index
                                      //                       ? 4
                                      //                       : 1,
                                      //                   color: qindex.value == index
                                      //                       ? ColorPage.white
                                      //                       : Colors.black12)),
                                      //           onPressed: () {
                                      //             qindex.value = index;
                                      //           },
                                      //           child: Text(
                                      //             (index + 1).toString(),
                                      //             style: TextStyle(
                                      //                 color: qindex.value == index
                                      //                     ? Colors.white
                                      //                     : Colors.black),
                                      //           ),
                                      //         ),
                                      //       );
                                      //     },
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isSubmitted.value
                                  ? false
                                  : widget.examType == "Quick Practice"
                                      ? false
                                      : true,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MaterialButton(
                                    height: 40,
                                    color: Colors.orange,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    onPressed: () {
                                      print(qindex.value);
                                      if (!reviewlist.contains(qindex.value)) {
                                        reviewlist.add(qindex.value);
                                      }
                                    },
                                    child: Text(
                                      'Mark for Review',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  MaterialButton(
                                    height: 40,
                                    color: Colors.blueGrey,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    shape: ContinuousRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    onPressed: () {
                                      reviewlist.remove(qindex.value);
                                    },
                                    child: Text(
                                      'Clear Response',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          )
        : SizedBox());
  }

  Future intializeAudioLink(String url) async {
    // url= "https://www2.cs.uic.edu/~i101/SoundFiles/BabyElephantWalk60.wav";
    try {
      // final player = AudioPlayer();
      await audioplayer.play(audio.UrlSource(url));
    } catch (e) {
      print(e.toString());
    }
  }

  void submitFunction() {
    List<Map<String, dynamic>> resultJsonData = [];
    List questionAnswerListofStudent = [];

    // Loop through all questions in mcqData to ensure each question is processed
    for (var question in mcqData) {
      int questionId = int.parse(question.questionId);
      String questionText = question.questionText;

      // Get correct answer IDs and texts
      List<int> correctAnswerIds = answer
          .firstWhere((map) => map.containsKey(questionId))[questionId]!
          .toList();
      List<String> correctAnswerTexts = correctAnswerIds
          .map((id) => question.options
              .firstWhere((opt) => opt.optionId == id.toString())
              .optionText)
          .toList();
//  double obtainmarks=calculateTotalMarkOfQuestion(questionId.toString(),selectedOptionIds)
      // Check if the user provided an answer; if not, set "Not Answered"
      List<int> selectedOptionIds = userAns[questionId] ?? [];
      double obtainmarks = calculateTotalMarkOfQuestion(questionId.toString(),
          selectedOptionIds, getQuestionTypeFromId(questionId.toString()));
      List<String> userSelectedAnswerTexts = selectedOptionIds.isNotEmpty
          ? selectedOptionIds
              .map((id) => question.options
                  .firstWhere((opt) => opt.optionId == id.toString())
                  .optionText)
              .toList()
          : ["Not Answered"];
      if (onewordAnswerList.containsKey(questionId.toString())) {
        questionAnswerListofStudent.add({
          "MCQQuestionId": questionId,
          "MCQOptionId": selectedOptionIds.isNotEmpty
              ? selectedOptionIds
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
              : "0",
          "MCQPaperId": widget.paperId,
          "Marks": obtainmarks.toString(),
          "IsCorrect": obtainmarks > 0 ? true : false,
          "OneWordAnswer": onewordAnswerList[questionId.toString()] ?? ""
        });
      } else {
        questionAnswerListofStudent.add({
          "MCQQuestionId": questionId,
          "MCQOptionId": selectedOptionIds.isNotEmpty
              ? selectedOptionIds
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
              : "0",
          "MCQPaperId": widget.paperId,
          "Marks": obtainmarks.toString(),
          "IsCorrect": obtainmarks > 0 ? true : false,
        });
      }

      if (getQuestionTypeFromId(questionId.toString()) == "One Word Answer") {
        updateOneWordAnswerofStudent(
            correctAnswerIds[0].toString(),
            questionId.toString(),
            onewordAnswerList.containsKey(questionId.toString())
                ? onewordAnswerList[questionId.toString()] ?? "Not answerd"
                : "Not answerd");
      }

      // If no answers selected, set user-selected IDs to [-1] to indicate no response
      resultJsonData.add({
        "questionid": questionId,
        "question name": questionText,
        "correctanswerId": correctAnswerIds,
        "correctanswer": correctAnswerTexts,
        "userselectedanswer id":
            selectedOptionIds.isNotEmpty ? selectedOptionIds : [-1],
        "userselectedanswer": getQuestionTypeFromId(questionId.toString()) ==
                "One Word Answer"
            ? onewordAnswerList.containsKey(questionId.toString())
                ? [
                    onewordAnswerList[questionId.toString()] ?? ["Not answerd"]
                  ]
                : ["Not answerd"]
            : userSelectedAnswerTexts,
      });

      inserUserTblMCQAnswer(
              widget.paperId,
              questionId.toString(),
              questionText.toString(),
              correctAnswerIds.toString(),
              correctAnswerTexts.toString(),
              selectedOptionIds.isNotEmpty
                  ? selectedOptionIds.toString()
                  : "[]",
              userSelectedAnswerTexts.toString(),
              "",
              "",
              "")
          .then((_) {});
    }

    double totalmarks = calculateTotalMarks(resultJsonData);
    if (getx.isInternet.value) {
      //  Map data ={
      //       'ExamId':widget.paperId,
      //       'ExamType':widget.examType,
      //       'ExamName': widget.paperName ,
      //       "ObtainMarks": totalmarks ,
      //       "AttemptDate": widget.attempt,

      //     };
      //     unUploadedMcQHistoryInfoInsert(context,[data],getx.loginuserdata[0].token);

      senddatatoRankedmcqtest(
          context,
          getx.loginuserdata[0].token,
          questionAnswerListofStudent,
          (totalDuration.value - (_start.value)).toString());
    }
    updateTblUserResultDetails(
        "true", widget.paperId, UtcTime().utctime().toString());

    updateTblMCQhistory(widget.paperId, widget.attempt, totalmarks.toString(),
            DateTime.now().toString(), context)
        .then((_) {
      fetchTblMCQHistory("").then((mcqhistoryList) {
        unUploadedMcQHistoryInfoInsert(
            context, mcqhistoryList, getx.loginuserdata[0].token);
      });
    });

    // Log or display JSON data as needed
    print("Result JSON Data: ");
    print(resultJsonData);
//hello
    submitedData = resultJsonData;
    //  double totalMarks=calculateTotalMarks(resultJsonData);
  }

  onSaveFaild(context, VoidCallback ontap) {
    Alert(
      context: context,
      type: AlertType.error,
      style: AlertStyle(
        titleStyle:
            TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "!! Failed to save !!",
      desc: "Something went wrong. Faild to save answre  ",
      buttons: [
        DialogButton(
          child:
              Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromRGBO(3, 77, 59, 1),
          onPressed: ontap,
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }

  _onSubmitComprehensiveExam(context) {
    int correctAnswers = 0;
    userAns.forEach((questionId, selectedOptionIds) {
      // Get the list of correct answers for the current question
      List<int> correctAnswersForQuestion = answer
          .firstWhere((map) => map.containsKey(questionId))[questionId]!
          .toList();

      // Check if the selected options match the correct answers
      if (ListEquality().equals(selectedOptionIds, correctAnswersForQuestion)) {
        correctAnswers++;
      }
    });

    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
        isOverlayTapDismiss: false,
        animationType: AnimationType.fromLeft,
        titleStyle:
            TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "Are You Sure?",
      desc:
          "Once You submit, You can't Change your Sheet \n If you are sure then Click on 'Yes' Button",
      buttons: [
        DialogButton(
          child: Text("Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromRGBO(77, 3, 3, 1),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(158, 9, 9, 1),
        ),
        DialogButton(
          child:
              Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromRGBO(77, 3, 3, 1),
          onPressed: () async {
            List<Map<String, dynamic>> resultJsonData = [];

            // Loop through all questions in mcqData to ensure each question is processed
            for (var question in mcqData) {
              int questionId = int.parse(question.questionId);
              String questionText = question.questionText;

              // Get correct answer IDs and texts
              List<int> correctAnswerIds = answer
                  .firstWhere((map) => map.containsKey(questionId))[questionId]!
                  .toList();
              List<String> correctAnswerTexts = correctAnswerIds
                  .map((id) => question.options
                      .firstWhere((opt) => opt.optionId == id.toString())
                      .optionText)
                  .toList();

              // Check if the user provided an answer; if not, set "Not Answered"
              List<int> selectedOptionIds = userAns[questionId] ?? [];
              List<String> userSelectedAnswerTexts = selectedOptionIds
                      .isNotEmpty
                  ? selectedOptionIds
                      .map((id) => question.options
                          .firstWhere((opt) => opt.optionId == id.toString())
                          .optionText)
                      .toList()
                  : ["Not Answered"];

              if (getQuestionTypeFromId(questionId.toString()) ==
                  "One Word Answer") {
                updateOneWordAnswerofStudent(
                    correctAnswerIds[0].toString(),
                    questionId.toString(),
                    onewordAnswerList.containsKey(questionId.toString())
                        ? onewordAnswerList[questionId.toString()] ??
                            "Not answerd"
                        : "Not answerd");
              }
              // If no answers selected, set user-selected IDs to [-1] to indicate no response
              resultJsonData.add({
                "questionid": questionId,
                "question name": questionText,
                "correctanswerId": correctAnswerIds,
                "correctanswer": correctAnswerTexts,
                "userselectedanswer id":
                    selectedOptionIds.isNotEmpty ? selectedOptionIds : [-1],
                "userselectedanswer":
                    getQuestionTypeFromId(questionId.toString()) ==
                            "One Word Answer"
                        ? onewordAnswerList.containsKey(questionId.toString())
                            ? [
                                onewordAnswerList[questionId.toString()] ??
                                    ["Not answerd"]
                              ]
                            : ["Not answerd"]
                        : userSelectedAnswerTexts,
              });

              inserUserTblMCQAnswer(
                      widget.paperId,
                      questionId.toString(),
                      questionText.toString(),
                      correctAnswerIds.toString(),
                      correctAnswerTexts.toString(),
                      selectedOptionIds.isNotEmpty
                          ? selectedOptionIds.toString()
                          : "[]",
                      userSelectedAnswerTexts.toString(),
                      "",
                      "",
                      "")
                  .then((_) {});
            }
            updateTblUserResultDetails(
                "true", widget.paperId, UtcTime().utctime().toString());

            // Log or display JSON data as needed
            print("Result JSON Data: ");
            print(resultJsonData);
//hello
            submitedData = resultJsonData;
            double totalMarks = calculateTotalMarks(resultJsonData);
            updateTblMCQhistory(widget.paperId, widget.attempt,
                totalMarks.toString(), DateTime.now().toString(), context);

            //  if(getx.isInternet.value){
            //      sendmarksToCalculateLeaderboard(
            //         context,
            //         getx.loginuserdata[0].token,
            //         totalMarks.toString(),
            //         widget.paperId);
            //  }
            _timer.cancel();
            score.value = correctAnswers;
            isSubmitted.value = true;
            List rankdata = await getRankDataOfMockTest(
                context, getx.loginuserdata[0].token, widget.paperId);
            Get.back();
            Get.off(() => MockTestresult(
                  paperId: widget.paperId,
                  questionData: submitedData,
                  totalmarks: widget.totalMarks,
                  type: "Comprehansive",
                  submitedOn: DateTime.now().toString(),
                  paperName: widget.paperName,
                  isAnswerSheetShow: widget.isAnswerSheetShow,
                ));
            // Navigator.pop(context);
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }

  _onSubmitExam(context, bool type, VoidCallback ontap) {
    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
        isOverlayTapDismiss: false,
        animationType: AnimationType.fromLeft,
        titleStyle:
            TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: type ? "Are You Sure?" : "Your Time is Up !!",
      desc: type
          ? "Once You submit, You can't Change your Sheet \n If you are sure then Click on 'Yes' Button"
          : "Sorry! But Your time is over. \n to submit your Paper click 'Yes' button.",
      buttons: [
        if (type)
          DialogButton(
            child: Text("Cancel",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            highlightColor: Color.fromRGBO(77, 3, 3, 1),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Color.fromRGBO(158, 9, 9, 1),
          ),
        DialogButton(
          child:
              Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromRGBO(77, 3, 3, 1),
          onPressed: ontap,
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }

  _onTimeUp(context) {
    int correctAnswers = 0;
    userAns.forEach((questionId, selectedOptionIds) {
      // Get the list of correct answers for the current question
      List<int> correctAnswersForQuestion = answer
          .firstWhere((map) => map.containsKey(questionId))[questionId]!
          .toList();

      // Check if the selected options match the correct answers
      if (ListEquality().equals(selectedOptionIds, correctAnswersForQuestion)) {
        correctAnswers++;
      }
    });

    Alert(
      context: context,
      onWillPopActive: false,
      type: AlertType.info,
      style: AlertStyle(
        isOverlayTapDismiss: false,
        animationType: AnimationType.fromTop,
        titleStyle:
            TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "Your Time is Up !!",
      desc: "Sorry! But Your time is over. \n Your Exam has been submitted.",
      buttons: [
        DialogButton(
          child:
              Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromRGBO(3, 77, 59, 1),
          onPressed: () {
            isSubmitted.value = true;

            Navigator.pop(context);
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }

  List<Map<int, List<int>>> groupQuestionsBySection(List questions) {
    Map<int, List<int>> groupedQuestions = {};

    for (var question in questions) {
      int sectionId = int.parse(question['SectionId'].toString());
      int questionId = int.parse(question['questionid'].toString());

      if (!groupedQuestions.containsKey(sectionId)) {
        groupedQuestions[sectionId] = [];
      }

      groupedQuestions[sectionId]!.add(questionId);
    }

    // Convert the map to the desired list format
    List<Map<int, List<int>>> result = [];
    groupedQuestions.forEach((key, value) {
      result.add({key: value});
    });

    return result;
  }
}

class PlayerWidget extends StatefulWidget {
  final audio.AudioPlayer audioplayer;

  const PlayerWidget({
    required this.audioplayer,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  audio.PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == audio.PlayerState.playing;

  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';

  audio.AudioPlayer get player => widget.audioplayer;

  @override
  void initState() {
    super.initState();
    _playerState = widget.audioplayer.state;

    player.getDuration().then((value) {
      if (mounted) {
        setState(() {
          _duration = value;
        });
      }
    });

    player.getCurrentPosition().then((value) {
      if (mounted) {
        setState(() {
          _position = value;
        });
      }
    });

    _initStreams();
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              key: const Key('play_pause_button'),
              onPressed: _togglePlayPause,
              iconSize: 40.0,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              color: color,
            ),
            SizedBox(
              width: 200,
              child: Slider(
                onChanged: (value) {
                  final duration = _duration;
                  if (duration == null) return;
                  final position = value * duration.inMilliseconds;
                  player.seek(Duration(milliseconds: position.round()));
                },
                value: (_position != null &&
                        _duration != null &&
                        _position!.inMilliseconds > 0 &&
                        _position!.inMilliseconds < _duration!.inMilliseconds)
                    ? _position!.inMilliseconds / _duration!.inMilliseconds
                    : 0.0,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _position != null
                  ? '$_positionText / $_durationText'
                  : _duration != null
                      ? _durationText
                      : '',
              style: const TextStyle(fontSize: 10.0),
            ),
          ],
        ),
      ],
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _positionSubscription = player.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = audio.PlayerState.stopped;
        _position = Duration.zero;
      });
      _play();
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _pause();
    } else {
      _play();
    }
  }

  void _play() {
    player.resume();
    setState(() {
      _playerState = audio.PlayerState.playing;
    });
  }

  void _pause() {
    player.pause();
    setState(() {
      _playerState = audio.PlayerState.paused;
    });
  }
}

// InAppWebViewController? webViewController;
// Future<void> _sendMathMLToJS({required String mathml}) async {
//   if (webViewController != null) {
//     try {
//       // Escape backticks and backslashes in the MathML string to prevent syntax errors
//       String escapedMathML = mathml
//           .replaceAll('\\', '\\\\')
//           .replaceAll('', '\\')
//           .replaceAll('\$', '\\\$');

//       String jsCode = """
//       receiveMathML($escapedMathML);
//     """;

//       String? result =
//           await webViewController?.evaluateJavascript(source: jsCode);
//       print(
//           "Rendered MathML: $result////////////////////////////////////////////////////////////////////////////////s");
//     } catch (e) {
//       writeToFile(e, '_sendMathMLToJS');
//     }
//   }
// }

// class YouTubePlayerContainer extends StatelessWidget {
//   final String youtubeUrl;

//   YouTubePlayerContainer({required this.youtubeUrl, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Convert the YouTube link into an embeddable URL
//     // String embedUrl = _getEmbedUrl(youtubeUrl);

//     return Container(
//       width: double.infinity,
//       height: 250.0, // Adjust to desired height
//       child: InAppWebView(
//         initialUrlRequest: URLRequest(url: WebUri(youtubeUrl)),
//         initialOptions: InAppWebViewGroupOptions(
//           crossPlatform: InAppWebViewOptions(
//             javaScriptEnabled: true,
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper function to convert YouTube links to embed format
//   // String _getEmbedUrl(String url) {
//   //   if (url.contains('youtube.com/watch?v=')) {
//   //     return url.replaceFirst('watch?v=', 'embed/');
//   //   } else if (url.contains('youtu.be/')) {
//   //     return url.replaceFirst('youtu.be/', 'www.youtube.com/embed/');
//   //   } else {
//   //     throw ArgumentError('Invalid YouTube URL');
//   //   }
//   // }
// }

bool isYouTubeUrl(String url) {
  // url="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  // Regular expression to check for YouTube URLs
  final RegExp youTubeUrlPattern = RegExp(
    r'^(https?:\/\/)?(www\.|m\.)?(youtube\.com|youtu\.be)(\/.*)?$',
    caseSensitive: false,
  );

  return youTubeUrlPattern.hasMatch(url);
}
