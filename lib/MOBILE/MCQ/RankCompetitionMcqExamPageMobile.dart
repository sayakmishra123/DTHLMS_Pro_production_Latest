import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/equality.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/MCQ/McqTestRank.dart';
import 'package:dthlms/MOBILE/MCQ/practiceMcq.dart';
import 'package:dthlms/PC/MCQ/PRACTICE/practiceMcqPage.dart';
import 'package:dthlms/PC/MCQ/modelclass.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';
import 'package:dthlms/math_equation.dart';
import 'package:dthlms/utctime.dart';
import 'package:dthlms/youtube/youtubelive.dart';
import 'package:flutter/gestures.dart';
// import 'package:dthlms/android/MCQ/mockTestRank.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:youtube_quality_player/youtube_quality_player.dart';

import '../../API/ALL_FUTURE_FUNTIONS/all_functions.dart';

import '../../PC/MCQ/EXAM/RankedCompetitionMcqPc.dart';
import '../../PC/MCQ/EXAM/VideoPlayerMcq.dart';
import '../../PC/MCQ/MOCKTEST/resultMcqTest.dart';
// import 'package:audioplayers/audioplayers.dart' as audio;

class RankCompetitionMcqExamPageMobile extends StatefulWidget {
  final List mcqlist;
  final List answerList;
  final String paperId;
  final String examStartTime;
  final String paperName;

  final String duration;
  final String attempt;
  final String totalMarks;

  final String totalDuration;
  final Map<int, List<int>> userAnswer;
  final bool isAnswerSheetShow;
  final String examType;
  const RankCompetitionMcqExamPageMobile(
      {super.key,
      required this.mcqlist,
      required this.answerList,
      required this.paperId,
      required this.examType,
      required this.examStartTime,
      required this.paperName,
      required this.duration,
      required this.attempt,
      required this.totalDuration,
      required this.userAnswer,
      required this.isAnswerSheetShow,
      required this.totalMarks});

  @override
  State<RankCompetitionMcqExamPageMobile> createState() =>
      _RankCompetitionMcqExamPageMobileState();
}

class _RankCompetitionMcqExamPageMobileState
    extends State<RankCompetitionMcqExamPageMobile> {
  List answer = [];
  List<Map<String, dynamic>> submitedData = [];
  Map<int, List<int>> userAns = {};
  late final videoplayer = Player();
  late final videocontroller = VideoController(videoplayer);
  // final audioplayer = audio.AudioPlayer();

  TextEditingController oneWordController = TextEditingController();

  OnlineAudioPlayerController audioController =
      Get.find<OnlineAudioPlayerController>();

  Map<String, String> onewordAnswerList = {};

  late Timer _timer;
  Getx getx_obj = Get.put(Getx());
  RxBool buttonshow = false.obs;
  RxInt _start = 5.obs;
  RxInt totalDuration = 5.obs;
  //  RxInt totalDuration = 0.obs;
  String lastattemp = "";
  BuildContext? globalContext;
  RxBool showAnswerExplenetion = false.obs;

  PageController _pageController = PageController();
  RxString videoHtmlContent = ''.obs;

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

  String _extractYouTubeId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    }
    return '';
  }

  Map<int, int> sectionOffsets = {};
  List sectionWiseQuestionIdList = [];
  @override
  void initState() {
    if (widget.userAnswer.length != 0) {
      userAns = widget.userAnswer;
    }
    answer = widget.answerList;
    print(answer);

    sectionWiseQuestionIdList = groupQuestionsBySection(widget.mcqlist);
    _start.value = double.parse(widget.duration).toInt();

    // Calculate offsets for each section
    int cumulativeIndex = 0;
    for (var sectionMap in sectionWiseQuestionIdList) {
      int sectionId = sectionMap.keys.first;
      sectionOffsets[sectionId] = cumulativeIndex;
      cumulativeIndex += (sectionMap[sectionId]!.length as int);
    }

    getdata();
    if (widget.examType != "Quick Practice") {
      startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.examType != "Quick Practice") {
      _timer.cancel();
    }
    _pageController.dispose();
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
              : _onimeUp(globalContext);
          // _onimeUp(globalContext);
          // Future.delayed(Duration(seconds: 2)).whenComplete(() {
          //   submitExamFunction();
          // });

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

  String groupname = ' All Questions';

  RxList<int> reviewlist = <int>[].obs;

  RxInt qindex = 0.obs;
  int selectedIndex = -1;
  RxBool isSubmitted = false.obs;
  RxInt score = 0.obs;

  List<McqItem> mcqData = [];

  pageExitConfirmationBox(context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      alertPadding: EdgeInsets.only(top: 200),
      descStyle: TextStyle(),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.grey),
      ),
      titleStyle: TextStyle(
          color: const Color.fromARGB(255, 243, 33, 33),
          fontWeight: FontWeight.bold),
      constraints: BoxConstraints.expand(width: 350),
      overlayColor: Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center,
    );

    Alert(
      context: context,
      type: AlertType.warning,
      style: alertStyle,
      title: "Are you sure you want to Exit?",
      buttons: [
        DialogButton(
          width: 150,
          child: Text("Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromARGB(255, 203, 46, 46),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromARGB(255, 139, 19, 19),
        ),
        DialogButton(
          width: 150,
          highlightColor: Color.fromARGB(255, 2, 2, 60),
          child:
              Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () async {
            Navigator.pop(context);
            Navigator.pop(context);
            // Navigator.pop(context);
          },
          color: const Color.fromARGB(255, 1, 12, 31),
        ),
      ],
    ).show();
  }

  RxBool isPractice = true.obs;

  @override
  Widget build(BuildContext context) {
    globalContext = context;

    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Obx(
        () => isPractice.value
            ? Scaffold(
                backgroundColor: Colors.grey[200],
                appBar: AppBar(
                  iconTheme: IconThemeData(color: ColorPage.white),
                  leading: IconButton(
                      onPressed: () {
                        pageExitConfirmationBox(context);
                      },
                      icon: Icon(Icons.arrow_back)),
                  centerTitle: false,
                  backgroundColor: ColorPage.appbarcolor,
                  title: Text(
                    widget.paperName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.examType != "Quick Practice"
                            ? Row(
                                children: [
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.alarm_outlined,
                                    color: ColorPage.white,
                                  ),
                                  Obx(
                                    () => Text(
                                      ' $timerText',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: 50,
                              ),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) => DraggableScrollableSheet(
                                  expand: false,
                                  builder: (context, scrollController) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      color: ColorPage.bgcolor,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            Container(
                                                height: 58 *
                                                        ((widget.mcqlist
                                                                    .length ~/
                                                                4) +
                                                            1) +
                                                    sectionWiseQuestionIdList
                                                            .length *
                                                        110,
                                                child: ListView.builder(
                                                    itemCount:
                                                        sectionWiseQuestionIdList
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
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
                                                                        .all(
                                                                        20.0),
                                                                child: Text(fetchSectionName(data
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
                                                            height: 100 *
                                                                ((indexList.length ~/
                                                                        4) +
                                                                    1),
                                                            child: GridView
                                                                .builder(
                                                                    itemCount:
                                                                        indexList
                                                                            .length,
                                                                    gridDelegate:
                                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                                            crossAxisCount:
                                                                                3),
                                                                    itemBuilder:
                                                                        (context,
                                                                            ind) {
                                                                      // Get section ID and cumulative offset
                                                                      int sectionId = data
                                                                          .keys
                                                                          .first;
                                                                      int offset =
                                                                          sectionOffsets[
                                                                              sectionId]!;

                                                                      return SingleChildScrollView(
                                                                        child:
                                                                            MaterialButton(
                                                                          height:
                                                                              55,
                                                                          color: reviewlist.contains(offset + ind) && !isSubmitted.value
                                                                              ? Colors.amber
                                                                              : userAns.containsKey(indexList[ind])
                                                                                  ? widget.examType == "Quick Practice"
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
                                                                          shape:
                                                                              CircleBorder(side: BorderSide(width: qindex.value == offset + ind ? 4 : 1, color: qindex.value == offset + ind ? ColorPage.white : Colors.black12)),
                                                                          onPressed:
                                                                              () async {
                                                                            audioController.stop();

                                                                            //                   audioplayer
                                                                            // .pause();
                                                                            qindex.value =
                                                                                offset + ind; // Update the current question index
                                                                            _pageController.jumpToPage(qindex.value);

                                                                            Get.back();
                                                                            oneWordController.text =
                                                                                onewordAnswerList[mcqData[qindex.value].questionId] ?? "";

                                                                            if (widget.examType ==
                                                                                "Quick Practice") {
                                                                              showAnswerExplenetion.value = userAns.containsKey(int.parse(mcqData[qindex.value].questionId));
                                                                            }
                                                                            // if (mcqData[qindex
                                                                            //             .value]
                                                                            //         .mCQQuestionType ==
                                                                            //     "Video Based Answer") {
                                                                            //   _initWebViewContent(
                                                                            //       mcqData[qindex.value]
                                                                            //           .mCQQuestionUrl);
                                                                            // }
                                                                            if (mcqData[qindex.value].mCQQuestionType ==
                                                                                "Audio Based Answer") {
                                                                              intializeAudioLink(mcqData[qindex.value].documnetUrl);
                                                                            }

                                                                            mcqData[qindex.value].questionText.contains('<?xml')
                                                                                ? await _sendMathMLToJS(mathml: mcqData[qindex.value].questionText)
                                                                                : null;
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            (ind + 1).toString(),
                                                                            style:
                                                                                TextStyle(color: qindex.value == offset + ind ? Colors.white : Colors.black),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                        ],
                                                      );
                                                    }))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(FontAwesome.gear))
                      ],
                    ),
                  ],
                ),
                body: Stack(
                  children: [
                    PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      // pageSnapping: false,

                      controller: _pageController,
                      onPageChanged: (index) async {
                        qindex.value = index;
                        oneWordController.text = onewordAnswerList[
                                mcqData[qindex.value].questionId] ??
                            "";

                        if (widget.examType == "Quick Practice") {
                          showAnswerExplenetion.value = userAns.containsKey(
                              int.parse(mcqData[qindex.value].questionId));
                        }
                        // if (mcqData[qindex
                        //             .value]
                        //         .mCQQuestionType ==
                        //     "Video Based Answer") {
                        //   _initWebViewContent(
                        //       mcqData[qindex.value]
                        //           .mCQQuestionUrl);
                        // }
                        if (mcqData[qindex.value].mCQQuestionType ==
                            "Audio Based Answer") {
                          intializeAudioLink(mcqData[qindex.value].documnetUrl);
                        }

                        mcqData[qindex.value].questionText.contains('<?xml')
                            ? await _sendMathMLToJS(
                                mathml: mcqData[qindex.value].questionText)
                            : null;
                        mcqData[qindex.value]
                                .answerExplanation
                                .contains('<?xml')
                            ? await _sendMathMLToJS(
                                mathml: mcqData[qindex.value].answerExplanation)
                            : null;
                      },
                      itemCount: mcqData.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              mcqData[index].sectionName,
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Column(
                                              children: [
                                                mcqData[qindex.value]
                                                        .questionText
                                                        .contains('<?xml')
                                                    ? Container(
                                                        height: 100,
                                                        child: mcqData[qindex
                                                                    .value]
                                                                .questionText
                                                                .contains(
                                                                    '<?xml')
                                                            ? InAppWebView(
                                                                initialSettings:
                                                                    InAppWebViewSettings(
                                                                  javaScriptEnabled:
                                                                      true,
                                                                  useOnLoadResource:
                                                                      true,
                                                                  textZoom: 60,
                                                                  defaultFontSize:
                                                                      60,
                                                                  minimumFontSize:
                                                                      60,
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
                                                                    callback:
                                                                        (args) {
                                                                      return null;
                                                                    },
                                                                  );

                                                                  webViewController!
                                                                      .evaluateJavascript(
                                                                          source:
                                                                              '''
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
                                                                        url) async {
                                                                  controller
                                                                      .evaluateJavascript(
                                                                          source:
                                                                              '''
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
      });
    ''');
                                                                  debugPrint(
                                                                      "WebView stopped loading: $url");
                                                                  // Send MathML to JS once the page is loaded
                                                                  await _sendMathMLToJS(
                                                                      mathml: mcqData[
                                                                              qindex.value]
                                                                          .questionText);
                                                                },
                                                                onJsAlert:
                                                                    (controller,
                                                                        jsAlertRequest) async {
                                                                  await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                      title: const Text(
                                                                          'Alert'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          child:
                                                                              const Text('OK'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                  return JsAlertResponse(
                                                                    handledByClient:
                                                                        true,
                                                                    action: JsAlertResponseAction
                                                                        .CONFIRM,
                                                                  );
                                                                },
                                                              )
                                                            : Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                mcqData[qindex
                                                                        .value]
                                                                    .questionText,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        20),
                                                              ),
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
                                                if (mcqData[qindex.value]
                                                            .mCQQuestionType ==
                                                        "Passage Based Answer" &&
                                                    getx.isInternet.value)
                                                  mcqData[qindex.value]
                                                              .passageDetails !=
                                                          "null"
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: HtmlWidget(
                                                              mcqData[qindex
                                                                      .value]
                                                                  .passageDetails),
                                                        )
                                                      : Center(
                                                          child: Text(
                                                              "no image Found"),
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
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: Image.network(
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                            return Text(
                                                                'No image');
                                                          },
                                                              mcqData[qindex
                                                                      .value]
                                                                  .passageDocumentUrl),
                                                        )
                                                      : Center(
                                                          child: Text(
                                                              "no image Found"),
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
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: Image.network(
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                            return const Text(
                                                                'No image');
                                                          },
                                                              mcqData[qindex
                                                                      .value]
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
                                                      width:
                                                          MediaQuery.of(context)
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
                                                              mcqData[qindex
                                                                      .value]
                                                                  .documnetUrl)
                                                          : Center(
                                                              child: Text(
                                                                  "No PDF Found"),
                                                            )),
                                                if (mcqData[qindex.value]
                                                            .mCQQuestionType ==
                                                        "Video Based Answer" &&
                                                    getx.isInternet.value)
                                                  Container(
                                                      height: 280,
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          1,
                                                      margin: EdgeInsets.symmetric(
                                                          vertical: 20),
                                                      child: mcqData[qindex.value]
                                                                  .mCQQuestionUrl ==
                                                              ""
                                                          ? Center(
                                                              child: Text(
                                                                  "No video Found"))
                                                          : isYouTubeUrl(
                                                                  mcqData[qindex.value]
                                                                      .mCQQuestionUrl)
                                                              ? Container(
                                                                  // child: YoutubeLive(mcqData[qindex.value].mCQQuestionUrl, getx.loginuserdata[0].firstName, false)
                                                                  child: YoutubeLive(link:mcqData[qindex.value].mCQQuestionUrl ),

                                                                  // YQPlayer(
                                                                  //   key: ValueKey( mcqData[qindex.value]
                                                                  //                                                           .mCQQuestionUrl),

                                                                  //   videoLink: mcqData[qindex.value]
                                                                  //                                                           .mCQQuestionUrl,
                                                                  //   primaryColor: Colors.blue,
                                                                  //   secondaryColor: Colors.redAccent,
                                                                  // ),
                                                                  )
                                                              : VideoPlayerMcq(mcqData[qindex.value].mCQQuestionUrl)),
                                                if (mcqData[qindex.value]
                                                            .mCQQuestionType ==
                                                        "Audio Based Answer" &&
                                                    getx.isInternet.value)
                                                  mcqData[qindex.value]
                                                              .documnetUrl ==
                                                          ""
                                                      ? Container(
                                                          child: Center(
                                                              child: Text(
                                                                  "No Audio found")))
                                                      : Container(
                                                          // height: 400,
                                                          // width: MediaQuery.of(context).size.width/3,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 20),
                                                          child:
                                                              OnlineAudioPlayer(
                                                            url: mcqData[qindex
                                                                    .value]
                                                                .documnetUrl,
                                                          ),
                                                          //  Container(

                                                          //     child: PlayerWidget(

                                                          //         audioplayer: audioplayer,)),
                                                        ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 20,
                                                      horizontal: 10),
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
                              mcqData[qindex.value].mCQQuestionType ==
                                      "One Word Answer"
                                  ? Row(
                                      children: [
                                        Text("    Write your answer here",
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
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: SizedBox(
                                  height: height,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 20),
                                      SizedBox(
                                        height: mcqData[qindex.value]
                                                    .mCQQuestionType ==
                                                "One Word Answer"
                                            ? 200
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: mcqData[qindex.value]
                                              .options
                                              .length,
                                          key: ValueKey(qindex.value),
                                          itemBuilder: (context, index) {
                                            String optionId =
                                                mcqData[qindex.value]
                                                    .options[index]
                                                    .optionId;
                                            String questionId =
                                                mcqData[qindex.value]
                                                    .questionId;

                                            // Check if the option is selected
                                            bool isSelected = userAns
                                                    .containsKey(int.parse(
                                                        questionId)) &&
                                                userAns[int.parse(questionId)]!
                                                    .contains(
                                                        int.parse(optionId));
                                            List<int>
                                                correctAnswersForQuestion =
                                                answer
                                                    .firstWhere((map) => map
                                                        .containsKey(int.parse(
                                                            questionId)))[
                                                        int.parse(questionId)]!
                                                    .toList();
                                            bool isCorrect;
                                            // Check if the option is correct
                                            if (mcqData[qindex.value]
                                                    .mCQQuestionType ==
                                                "One Word Answer") {
                                              isCorrect =
                                                  getOneWordAnswerFromQuestionId(
                                                              questionId
                                                                  .toString())
                                                          .replaceAll(" ", "")
                                                          .toLowerCase() ==
                                                      getOneWordAnswerFromQuestionIdofStudent(
                                                              questionId
                                                                  .toString())
                                                          .replaceAll(" ", "")
                                                          .toLowerCase();
                                            } else {
                                              isCorrect = answer.any(
                                                (map) =>
                                                    map.containsKey(int.parse(
                                                        questionId)) &&
                                                    map[int.parse(questionId)]!
                                                        .contains(int.parse(
                                                            optionId)),
                                              );
                                            }

                                            Color tileColor;
                                            if (widget.examType ==
                                                "Quick Practice") {
                                              if (isSelected) {
                                                tileColor = isCorrect
                                                    ? Colors.green
                                                    : Colors.red;
                                              } else if (userAns.containsKey(
                                                      int.parse(questionId)) &&
                                                  userAns[int.parse(
                                                              questionId)]!
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
                                              if (isSubmitted.value) {
                                                if (isCorrect) {
                                                  tileColor = Colors.green;
                                                } else if (isSelected &&
                                                    !isCorrect) {
                                                  tileColor = Colors.red;
                                                } else {
                                                  tileColor = Colors
                                                      .white; // default color
                                                }
                                              } else {
                                                tileColor = isSelected
                                                    ? Colors.blue
                                                    : Colors
                                                        .white; // default color
                                              }
                                            }
                                            bool isSelectionDisabled = false;

                                            if (widget.examType ==
                                                "Quick Practice") {
                                              isSelectionDisabled = userAns
                                                      .containsKey(int.parse(
                                                          questionId)) &&
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

                                            return mcqData[qindex.value]
                                                        .mCQQuestionType ==
                                                    "One Word Answer"
                                                ? Column(
                                                    children: [
                                                      Container(
                                                        // color: Colors.red,
                                                        child: SizedBox(
                                                            child:
                                                                TextFormField(
                                                          readOnly: userAns
                                                                  .containsKey(
                                                                      int.parse(
                                                                          questionId)) &&
                                                              widget.examType ==
                                                                  "Quick Practice",
                                                          onSaved: (value) {
                                                            print(value
                                                                .toString());

                                                            if (!isSubmitted
                                                                .value) {
                                                              if (oneWordController
                                                                      .text !=
                                                                  "") {
                                                                userAns[int.parse(
                                                                    questionId)] = [
                                                                  int.parse(
                                                                      optionId)
                                                                ];
                                                              }

                                                              userAns[int.parse(
                                                                  questionId)] = [
                                                                int.parse(
                                                                    optionId)
                                                              ];
                                                              print(
                                                                  "update calling");

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
                                                            print(value
                                                                .toString());

                                                            if (!isSubmitted
                                                                .value) {
                                                              if (oneWordController
                                                                      .text !=
                                                                  "") {
                                                                userAns[int.parse(
                                                                    questionId)] = [
                                                                  int.parse(
                                                                      optionId)
                                                                ];
                                                              }

                                                              print(
                                                                  "update calling");

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
                                                          onTapOutside:
                                                              (value) {
                                                            print(value
                                                                .toString());

                                                            if (!isSubmitted
                                                                .value) {
                                                              if (oneWordController
                                                                      .text !=
                                                                  "") {
                                                                userAns[int.parse(
                                                                    questionId)] = [
                                                                  int.parse(
                                                                      optionId)
                                                                ];
                                                              }

                                                              print(
                                                                  "update calling");

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
                                                              TextInputAction
                                                                  .next,
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                          keyboardType:
                                                              TextInputType
                                                                  .name,
                                                          controller:
                                                              oneWordController,
                                                          decoration:
                                                              InputDecoration(
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            filled: true,
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 0.5,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        141,
                                                                        139,
                                                                        139),
                                                              ),
                                                              gapPadding: 20,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 0.5,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        196,
                                                                        194,
                                                                        194),
                                                              ),
                                                              gapPadding: 20,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
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
                                                                        vertical:
                                                                            10),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            15),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            10)),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black12,
                                                                        offset: Offset(
                                                                            8,
                                                                            8),
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 200),
                                                      curve: Curves.easeInOut,
                                                      // height: 60,
                                                      decoration: BoxDecoration(
                                                        color: tileColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 10,
                                                            offset:
                                                                Offset(0, 5),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          onTap: () {
                                                            setState(() {
                                                              if (widget
                                                                      .examType ==
                                                                  "Quick Practice") {
                                                                // Skip if selection is disabled
                                                                if (isSelectionDisabled)
                                                                  return;

                                                                if (mcqData[qindex
                                                                            .value]
                                                                        .isMultiple ==
                                                                    'true') {
                                                                  // Multi-select option with limit check
                                                                  if (userAns.containsKey(
                                                                      int.parse(
                                                                          questionId))) {
                                                                    if (userAns[int.parse(
                                                                            questionId)]!
                                                                        .contains(
                                                                            int.parse(optionId))) {
                                                                      // Prevent unselecting a chosen option
                                                                      return;
                                                                    } else {
                                                                      userAns[int.parse(
                                                                              questionId)]!
                                                                          .add(int.parse(
                                                                              optionId));
                                                                    }
                                                                  } else {
                                                                    userAns[int
                                                                        .parse(
                                                                            questionId)] = [
                                                                      int.parse(
                                                                          optionId)
                                                                    ];
                                                                  }

                                                                  // Check if maximum selections have been made for multi-select
                                                                  if (userAns[int.parse(
                                                                              questionId)]!
                                                                          .length ==
                                                                      correctAnswersForQuestion
                                                                          .length) {
                                                                    // Automatically reveal answers if max selection is reached
                                                                    setState(
                                                                        () {
                                                                      // Set `isSelectionDisabled` to true to prevent further changes
                                                                      isSelectionDisabled =
                                                                          true;
                                                                      showAnswerExplenetion
                                                                              .value =
                                                                          true;
                                                                    });
                                                                  }
                                                                } else {
                                                                  // Single selection, replace existing answer
                                                                  userAns[int.parse(
                                                                      questionId)] = [
                                                                    int.parse(
                                                                        optionId)
                                                                  ];
                                                                  showAnswerExplenetion
                                                                      .value = userAns.containsKey(int.parse(mcqData[
                                                                          qindex
                                                                              .value]
                                                                      .questionId));
                                                                }
                                                              }
                                                              // print("question id $questionId");
                                                              // print("optin Id $optionId");
                                                              // print("ismultiple ${mcqData[qindex.value]
                                                              //             .isMultiple}");

                                                              if (widget.examType ==
                                                                      "Ranked Competition" ||
                                                                  widget.examType ==
                                                                      "Comprehensive") {
                                                                if (!isSubmitted
                                                                    .value) {
                                                                  if (userAns.containsKey(
                                                                      int.parse(
                                                                          questionId))) {
                                                                    if (mcqData[qindex.value]
                                                                            .isMultiple ==
                                                                        'true') {
                                                                      // Toggle option for multi-select
                                                                      if (userAns[int.parse(
                                                                              questionId)]!
                                                                          .contains(
                                                                              int.parse(optionId))) {
                                                                        userAns[int.parse(questionId)]!
                                                                            .remove(int.parse(optionId));
                                                                      } else {
                                                                        userAns[int.parse(questionId)]!
                                                                            .add(int.parse(optionId));
                                                                      }
                                                                    } else {
                                                                      // Single answer
                                                                      userAns[int
                                                                          .parse(
                                                                              questionId)] = [
                                                                        int.parse(
                                                                            optionId)
                                                                      ];
                                                                    }
                                                                  } else {
                                                                    userAns[int
                                                                        .parse(
                                                                            questionId)] = [
                                                                      int.parse(
                                                                          optionId)
                                                                    ];
                                                                  }
                                                                }
                                                              }
                                                            });
                                                          },
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16,
                                                                        vertical:
                                                                            16),
                                                                child: mcqData[qindex
                                                                            .value]
                                                                        .options[
                                                                            index]
                                                                        .optionText
                                                                        .contains(
                                                                            '<?xml')
                                                                    ? MathEquation(
                                                                        mathMl: mcqData[qindex.value]
                                                                            .options[index]
                                                                            .optionText,
                                                                      )
                                                                    : Text(
                                                                        mcqData[qindex.value]
                                                                            .options[index]
                                                                            .optionText,
                                                                        style:
                                                                            TextStyle(
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          // fontSize: 15,
                                                                        ),
                                                                        softWrap:
                                                                            true,
                                                                        overflow:
                                                                            TextOverflow.visible,
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
                                              widget.examType ==
                                                  "Quick Practice" &&
                                              mcqData[qindex.value]
                                                      .answerExplanation !=
                                                  "0"
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 200,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            offset:
                                                                Offset(8, 8),
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
                                                                defaultFontSize:
                                                                    60,
                                                                minimumFontSize:
                                                                    60,
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
                                                                  callback:
                                                                      (args) {
                                                                    return null;
                                                                  },
                                                                );

                                                                webViewController!
                                                                    .evaluateJavascript(
                                                                        source:
                                                                            '''
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
                                                                      url) async {
                                                                controller
                                                                    .evaluateJavascript(
                                                                        source:
                                                                            '''
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
      });
    ''');
                                                                debugPrint(
                                                                    "WebView stopped loading: $url");
                                                                // Send MathML to JS once the page is loaded
                                                                await _sendMathMLToJS(
                                                                    mathml: mcqData[
                                                                            qindex.value]
                                                                        .answerExplanation);
                                                              },
                                                              onJsAlert:
                                                                  (controller,
                                                                      jsAlertRequest) async {
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title: const Text(
                                                                        'Alert'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        child: const Text(
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
                                                            child: HtmlWidget(
                                                                mcqData[qindex
                                                                        .value]
                                                                    .answerExplanation)),
                                                  ),
                                                )
                                              ],
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (qindex.value > 0)
                                            Flexible(
                                              child: MaterialButton(
                                                height: 40,
                                                color:
                                                    ColorPage.appbarcolorcopy,
                                                padding: EdgeInsets.all(16),
                                                shape:
                                                    ContinuousRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                onPressed: () async {
                                                  if (qindex.value > 0) {
                                                    // audioplayer.pause();
                                                    audioController.stop();
                                                    qindex.value--;
                                                    oneWordController.text =
                                                        onewordAnswerList[mcqData[
                                                                    qindex
                                                                        .value]
                                                                .questionId] ??
                                                            "";
                                                    if (widget.examType ==
                                                        "Quick Practice") {
                                                      showAnswerExplenetion
                                                              .value =
                                                          userAns.containsKey(
                                                              int.parse(mcqData[
                                                                      qindex
                                                                          .value]
                                                                  .questionId));
                                                    }
                                                    // if (mcqData[qindex.value]
                                                    //         .mCQQuestionType ==
                                                    //     "Video Based Answer") {
                                                    //   _initWebViewContent(
                                                    //       mcqData[qindex.value]
                                                    //           .mCQQuestionUrl);
                                                    // }
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

                                                    _pageController.jumpToPage(
                                                        qindex
                                                            .value); // Navigate to the previous page
                                                  }
                                                  //     mcqData[qindex.value]
                                                  //     .questionText
                                                  //     .contains('<?xml')
                                                  // ? await _sendMathMLToJS(
                                                  //     mathml: mcqData[qindex.value]
                                                  //         .questionText)
                                                  // : null;

                                                  //   mcqData[qindex
                                                  //                                 .value]
                                                  //                             .answerExplanation
                                                  //                             .contains(
                                                  //                                 '<?xml')
                                                  //                         ? await _sendMathMLToJS(
                                                  //                             mathml:
                                                  //                                 mcqData[qindex.value].answerExplanation)
                                                  //                         : null;
                                                },
                                                child: Text(
                                                  'Previous',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          Visibility(
                                            visible: widget.examType !=
                                                "Quick Practice",
                                            child: Obx(
                                              () => Flexible(
                                                child: MaterialButton(
                                                  height: 40,
                                                  color: !reviewlist.contains(
                                                          qindex.value)
                                                      ? Colors.orange
                                                      : Colors.blueGrey,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 10),
                                                  shape:
                                                      ContinuousRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                  onPressed: () {
                                                    print(qindex.value);
                                                    if (!reviewlist.contains(
                                                        qindex.value)) {
                                                      reviewlist
                                                          .add(qindex.value);
                                                      print("add on list");
                                                    } else if (reviewlist
                                                        .contains(
                                                            qindex.value)) {
                                                      reviewlist
                                                          .remove(qindex.value);
                                                      print(
                                                          "remove from on list");
                                                    }
                                                  },
                                                  child: Text(
                                                    !reviewlist.contains(
                                                            qindex.value)
                                                        ? 'Mark for Review'
                                                        : "Clear response",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (qindex.value < mcqData.length)
                                            Flexible(
                                              child: MaterialButton(
                                                height: 40,
                                                color:
                                                    ColorPage.appbarcolorcopy,
                                                padding: EdgeInsets.all(16),
                                                shape:
                                                    ContinuousRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                onPressed: () async {
                                                  if (widget.examType ==
                                                      "Quick Practice") {
                                                    if (qindex.value <
                                                        mcqData.length - 1) {
                                                      // audioplayer.pause();
                                                      audioController.stop();
                                                      qindex.value++;

                                                      oneWordController
                                                          .text = onewordAnswerList[
                                                              mcqData[qindex
                                                                      .value]
                                                                  .questionId] ??
                                                          "";
                                                      _pageController
                                                          .jumpToPage(
                                                              qindex.value);
                                                      showAnswerExplenetion
                                                              .value =
                                                          userAns.containsKey(
                                                              int.parse(mcqData[
                                                                      qindex
                                                                          .value]
                                                                  .questionId));

                                                      // if (mcqData[qindex.value]
                                                      //         .mCQQuestionType ==
                                                      //     "Video Based Answer") {
                                                      //   _initWebViewContent(
                                                      //       mcqData[qindex.value]
                                                      //           .mCQQuestionUrl);

                                                      //   // videoplayer.open(Media(
                                                      //   //     mcqData[qindex.value]
                                                      //   //         .mCQQuestionUrl)

                                                      //   //         );
                                                      // }
                                                      if (mcqData[qindex.value]
                                                              .mCQQuestionType ==
                                                          "Audio Based Answer") {
                                                        // final player = AudioPlayer();
                                                        intializeAudioLink(
                                                            mcqData[qindex
                                                                    .value]
                                                                .documnetUrl);
                                                      }

                                                      // final player = AudioPlayer();
                                                    } else if (qindex.value ==
                                                        mcqData.length - 1) {
                                                      onExitexmPage(context,
                                                          () {
                                                        Navigator.pop(context);
                                                        updateTblMCQhistory(
                                                                widget.paperId,
                                                                lastattemp != ""
                                                                    ? lastattemp
                                                                    : widget
                                                                        .attempt,
                                                                calculatePercentage(
                                                                        userAns,
                                                                        answer)
                                                                    .toString(),
                                                                DateTime.now()
                                                                    .toString(),
                                                                context)
                                                            .then((_) {
                                                          userAns.clear();
                                                          onewordAnswerList
                                                              .clear();
                                                          oneWordController
                                                              .text = "";
                                                          setState(() {
                                                            lastattemp =
                                                                DateTime.now()
                                                                    .toString();
                                                            inserTblMCQhistory(
                                                                widget.paperId,
                                                                'Quick Practice',
                                                                widget
                                                                    .paperName,
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
                                                                : widget
                                                                    .attempt,
                                                            calculatePercentage(
                                                                    userAns,
                                                                    answer)
                                                                .toString(),
                                                            DateTime.now()
                                                                .toString(),
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
                                                      audioController.stop();
                                                      // audioplayer.pause();
                                                      audioController.stop();
                                                      qindex.value++;
                                                      _pageController
                                                          .jumpToPage(
                                                              qindex.value);
                                                      if (mcqData[qindex.value]
                                                              .mCQQuestionType ==
                                                          "One Word Answer") {
                                                        setState(() {
                                                          oneWordController
                                                              .text = onewordAnswerList[
                                                                  mcqData[qindex
                                                                          .value]
                                                                      .questionId] ??
                                                              "";
                                                        });
                                                      }
                                                      oneWordController
                                                          .text = onewordAnswerList[
                                                              mcqData[qindex
                                                                      .value]
                                                                  .questionId] ??
                                                          "";

                                                      // if (mcqData[qindex.value]
                                                      //         .mCQQuestionType ==
                                                      //     "Video Based Answer") {
                                                      //   _initWebViewContent(
                                                      //       mcqData[qindex.value]
                                                      //           .mCQQuestionUrl);
                                                      // }
                                                      if (mcqData[qindex.value]
                                                              .mCQQuestionType ==
                                                          "Audio Based Answer") {
                                                        // final player = AudioPlayer();
                                                        intializeAudioLink(
                                                            mcqData[qindex
                                                                    .value]
                                                                .documnetUrl);
                                                      }
                                                    } else if (qindex.value ==
                                                            mcqData.length -
                                                                1 &&
                                                        !isSubmitted.value) {
                                                      _onSubmitComprehensiveExam(
                                                          context);
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
                                                            mcqData[qindex
                                                                    .value]
                                                                .questionId
                                                                .toString(),
                                                            userAns[int.parse(mcqData[
                                                                        qindex
                                                                            .value]
                                                                    .questionId)] ??
                                                                [],
                                                            mcqData[qindex
                                                                    .value]
                                                                .mCQQuestionType);
                                                    //

                                                    List<String>
                                                        userSelectedAnswerTexts =
                                                        userAns[int.parse(mcqData[qindex.value].questionId)] !=
                                                                null
                                                            ? userAns[int.parse(
                                                                    mcqData[qindex.value]
                                                                        .questionId)]!
                                                                .map((id) => mcqData[qindex.value]
                                                                    .options
                                                                    .firstWhere((opt) =>
                                                                        opt.optionId ==
                                                                        id.toString())
                                                                    .optionText)
                                                                .toList()
                                                            : ["Not Answered"];
                                                    //
                                                    List<int> correctAnswerIds = answer
                                                            .firstWhere((map) =>
                                                                map.containsKey(
                                                                    int.parse(
                                                                        mcqData[qindex.value]
                                                                            .questionId)))[int.parse(
                                                            mcqData[qindex.value]
                                                                .questionId)] ??
                                                        [].toList();
                                                    List<String>
                                                        correctAnswerTexts =
                                                        correctAnswerIds
                                                            .map((id) => mcqData[
                                                                    qindex
                                                                        .value]
                                                                .options
                                                                .firstWhere((opt) =>
                                                                    opt.optionId ==
                                                                    id.toString())
                                                                .optionText)
                                                            .toList();

                                                    //
                                                    print(userAns[int.parse(
                                                                mcqData[qindex
                                                                        .value]
                                                                    .questionId)]
                                                            .toString() +
                                                        "///////////////////////////////////////////////////cvvvcgvchvcgcvds");
                                                    Map questionanswerList = {
                                                      "MCQQuestionId":
                                                          mcqData[qindex.value]
                                                              .questionId,
                                                      "MCQOptionId": userAns[int
                                                                  .parse(mcqData[
                                                                          qindex
                                                                              .value]
                                                                      .questionId)] !=
                                                              null
                                                          ? userAns[int.parse(
                                                                  mcqData[qindex
                                                                          .value]
                                                                      .questionId)]
                                                              .toString()
                                                              .replaceAll(
                                                                  "[", "")
                                                              .replaceAll(
                                                                  "]", "")
                                                          : "0",
                                                      "MCQPaperId":
                                                          widget.paperId,
                                                      "Marks": obtainmarks
                                                          .toString(),
                                                      "IsCorrect":
                                                          obtainmarks > 0
                                                              ? true
                                                              : false,
                                                      "OneWordAnswer":
                                                          oneWordController
                                                              .text,
                                                    };
                                                    inserUserTblMCQAnswer(
                                                        widget.paperId,
                                                        mcqData[qindex.value]
                                                            .questionId
                                                            .toString(),
                                                        mcqData[qindex.value]
                                                            .questionText
                                                            .toString(),
                                                        correctAnswerIds
                                                            .toString(),
                                                        correctAnswerTexts
                                                            .toString(),
                                                        userAns[int.parse(mcqData[
                                                                        qindex
                                                                            .value]
                                                                    .questionId)] !=
                                                                null
                                                            ? userAns[int.parse(
                                                                    mcqData[qindex
                                                                            .value]
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
                                                      if (getx
                                                          .isInternet.value) {
                                                        fetchTblMCQHistory("")
                                                            .then(
                                                                (mcqhistoryList) {
                                                          unUploadedMcQHistoryInfoInsert(
                                                              context,
                                                              mcqhistoryList,
                                                              getx
                                                                  .loginuserdata[
                                                                      0]
                                                                  .token);
                                                        });
                                                        senddatatoRankedmcqtest(
                                                                context,
                                                                getx
                                                                    .loginuserdata[
                                                                        0]
                                                                    .token,
                                                                [
                                                                  questionanswerList
                                                                ],
                                                                (totalDuration
                                                                            .value -
                                                                        (_start
                                                                            .value))
                                                                    .toString())
                                                            .then(
                                                                (value) async {
                                                          if (value) {
                                                            // audioplayer.pause();
                                                            audioController
                                                                .stop();
                                                            qindex.value++;
                                                            _pageController
                                                                .jumpToPage(
                                                                    qindex
                                                                        .value);
                                                            oneWordController
                                                                .text = onewordAnswerList[
                                                                    mcqData[qindex
                                                                            .value]
                                                                        .questionId] ??
                                                                "";
                                                            //
                                                            if (mcqData[qindex
                                                                        .value]
                                                                    .mCQQuestionType ==
                                                                "Audio Based Answer") {
                                                              // final player = AudioPlayer();
                                                              intializeAudioLink(
                                                                  mcqData[qindex
                                                                          .value]
                                                                      .documnetUrl);
                                                            }
                                                          } else {
                                                            onSaveFaild(context,
                                                                () {
                                                              Get.back();
                                                            });
                                                          }
                                                        });
                                                      } else {
                                                        onNoInternetConnection(
                                                            context, () {
                                                          Get.back();
                                                        });
                                                      }

                                                      // qindex.value++;
                                                    } else if (qindex.value ==
                                                            mcqData.length -
                                                                1 &&
                                                        !isSubmitted.value) {
                                                      _onSubmitExam(
                                                          context, true, () {
                                                        Navigator.pop(context);

                                                        if (getx
                                                            .isInternet.value) {
                                                          senddatatoRankedmcqtest(
                                                                  context,
                                                                  getx
                                                                      .loginuserdata[
                                                                          0]
                                                                      .token,
                                                                  [
                                                                    questionanswerList
                                                                  ],
                                                                  (totalDuration
                                                                              .value -
                                                                          (_start
                                                                              .value))
                                                                      .toString())
                                                              .then((value) {
                                                            if (value) {
                                                              _timer.cancel();

                                                              isSubmitted
                                                                  .value = true;
                                                              Get.back();
                                                            } else {
                                                              onSaveFaild(
                                                                  context, () {
                                                                Get.back();
                                                              });
                                                            }
                                                          });
                                                        } else {
                                                          onNoInternetConnection(
                                                              context, () {
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
                                                            mathml: mcqData[
                                                                    qindex
                                                                        .value]
                                                                .questionText)
                                                        : null;
                                                  }

                                                  print(
                                                      'object jdsfhfjsvfvdsfvsgfvhgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdgsdf');
                                                  mcqData[qindex.value]
                                                          .questionText
                                                          .contains('<?xml')
                                                      ? await _sendMathMLToJS(
                                                          mathml: mcqData[
                                                                  qindex.value]
                                                              .questionText)
                                                      : null;
                                                  mcqData[qindex.value]
                                                          .answerExplanation
                                                          .contains('<?xml')
                                                      ? await _sendMathMLToJS(
                                                          mathml: mcqData[
                                                                  qindex.value]
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
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ))
            : SizedBox(),
      ),
    );
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
            Get.to(
                transition: Transition.cupertino,
                () => RankPage(
                      totalmarks: widget.totalMarks,
                      paperId: widget.paperId,
                      questionData: submitedData,
                      frompaper: false,
                      isMcq: false,
                      type: "Comprehensive",
                      paperName: widget.paperName,
                      submitedOn: DateTime.now().toString(),
                      isAnswerSheetShow: true,
                    ));
            // Navigator.pop(context);
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }

  Future intializeAudioLink(String url) async {
    // url= "https://www2.cs.uic.edu/~i101/SoundFiles/BabyElephantWalk60.wav";
    try {
      // final player = AudioPlayer();
      // await audioplayer.play(audio.UrlSource(url));
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
      senddatatoRankedmcqtest(
          context,
          getx.loginuserdata[0].token,
          questionAnswerListofStudent,
          (totalDuration.value - (_start.value / 60)).toString());
    }
    updateTblUserResultDetails(
        "true", widget.paperId, UtcTime().utctime().toString());

    updateTblMCQhistory(widget.paperId, widget.attempt, totalmarks.toString(),
        DateTime.now().toString(), context);
    if (getx.isInternet.value) {
      fetchTblMCQHistory("").then((mcqhistoryList) {
        unUploadedMcQHistoryInfoInsert(
            context, mcqhistoryList, getx.loginuserdata[0].token);
      });
    }
    print("Result JSON Data: ");
    print(resultJsonData);
    submitedData = resultJsonData;
  }

  // _onSubmitExam(context) {
  //   int correctAnswers = 0;
  //   userAns.forEach((questionId, selectedOptionId) {
  //     if (answer.any((map) => map[questionId] == selectedOptionId)) {
  //       correctAnswers++;
  //     }
  //   });
  //   print(correctAnswers.toString());

  //   Alert(
  //     context: context,
  //     type: AlertType.info,
  //     style: AlertStyle(
  //       animationType: AnimationType.fromLeft,
  //       titleStyle:
  //           TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
  //       descStyle: FontFamily.font6,
  //       isCloseButton: false,
  //     ),
  //     title: "Are You Sure?",
  //     desc:
  //         "Once You submit, You can't Change your Sheet \n If you are sure then Click on 'Yes' Button",
  //     buttons: [
  //       DialogButton(
  //         child: Text("Cancel",
  //             style: TextStyle(color: Colors.white, fontSize: 18)),
  //         highlightColor: Color.fromRGBO(77, 3, 3, 1),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         color: Color.fromRGBO(158, 9, 9, 1),
  //       ),
  //       DialogButton(
  //         child:
  //             Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
  //         highlightColor: Color.fromRGBO(77, 3, 3, 1),
  //         onPressed: () {
  //           _timer.cancel();
  //           score.value = correctAnswers;

  //           isSubmitted.value = true;
  //           Navigator.pop(context);
  //           Get.toNamed("/Mocktestrankpagemobile",arguments:{"mcqData":mcqData,"correctAnswers":answer,"userAns":userAns,'totalnumber':correctAnswers});
  //         },
  //         color: Color.fromRGBO(9, 89, 158, 1),
  //       ),
  //     ],
  //   ).show();
  // }

  _onimeUp(context) {
    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
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
            Navigator.pop(context);
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }

  _onSubmitExam2(context) {
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
            submitFunction();

            // sendmarksToCalculateLeaderboard(context,getx.loginuserdata[0].token,totalMarks.toString(),widget.paperId);
            // _timer.cancel();
            // score.value = correctAnswers;
            // isSubmitted.value = true;
            // Navigator.pop(context);

            _timer.cancel();
            score.value = correctAnswers;
            isSubmitted.value = true;
            Navigator.pop(context);
            Navigator.pop(context);
          },
          color: Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }
}

class OnlineAudioPlayerController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxBool isPlaying = false.obs;
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;

  void initialize(String url) {
    _audioPlayer.onDurationChanged.listen((duration) {
      totalDuration.value = duration;
    });

    _audioPlayer.onPositionChanged.listen((position) {
      currentPosition.value = position;
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _audioPlayer.seek(Duration.zero);
      isPlaying.value = false;
    });
  }

  void togglePlayPause(String url) async {
    if (isPlaying.value) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(url));
    }
    isPlaying.toggle();
  }

  void stop() async {
    await _audioPlayer.stop();
    isPlaying.value = false;
    currentPosition.value = Duration.zero;
  }

  void seek(double value) {
    final position = Duration(seconds: value.toInt());
    _audioPlayer.seek(position);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}

class OnlineAudioPlayer extends StatelessWidget {
  final String url;
  final OnlineAudioPlayerController controller =
      Get.put(OnlineAudioPlayerController());

  OnlineAudioPlayer({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.initialize(url);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => IconButton(
                    icon: Icon(
                      controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 45,
                    ),
                    onPressed: () => controller.togglePlayPause(url),
                  )),
              // IconButton(
              //   icon: Icon(Icons.stop),
              //   onPressed: controller.stop,
              // ),

              Obx(() => Slider(
                    min: 0,
                    max: controller.totalDuration.value.inSeconds.toDouble(),
                    value:
                        controller.currentPosition.value.inSeconds.toDouble(),
                    onChanged: controller.seek,
                  )),
            ],
          ),
          Obx(() => Text(
                "${_formatDuration(controller.currentPosition.value)} / ${_formatDuration(controller.totalDuration.value)}",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              )),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
