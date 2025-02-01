import 'dart:async';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/MOBILE/THEORY_EXAM/selectexampapers.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../THEORY_EXAM/ShowQuestionPaper.dart';

class TheoryExamPageMobile extends StatefulWidget {
  final String documentPath;
  final String title;
  final String duration;
  final String paperId;
  final bool issubmit;
  TheoryExamPageMobile(
      {super.key,
      required this.documentPath,
      required this.title,
      required this.duration,
      required this.paperId,
      required this.issubmit});

  @override
  State<TheoryExamPageMobile> createState() => _TheoryExamPageMobileState();
}

class _TheoryExamPageMobileState extends State<TheoryExamPageMobile> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  String? _localPdfPath;
  BuildContext? globalContext;

  TextEditingController sheetController = TextEditingController();
  Getx getx = Get.put(Getx());

  Timer? _timer;
  RxInt _start = 1800.obs;
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start.value == 0) {
          timer.cancel();
          _onTimeUp(globalContext);
          Future.delayed(Duration(seconds: 2)).whenComplete(() {
            Get.to(
                transition: Transition.cupertino,
                () => SelectExamPapers(
                      paperId: widget.paperId,
                    ));
          });

          //  _onimeUp(globalContext!);
        } else {
          _start.value--;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _start.value = int.parse(widget.duration) * 60;
    _downloadPdf();
  }

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    alertPadding: EdgeInsets.only(top: 300),
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 600),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(color: Colors.grey),
    ),
    titleStyle: TextStyle(color: ColorPage.blue, fontWeight: FontWeight.bold),
    constraints: BoxConstraints.expand(width: 350),
    overlayColor: Color(0x55000000),
    alertElevation: 0,
    alertAlignment: Alignment.center,
  );

  Future<void> _downloadPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.documentPath));
      if (response.statusCode == 200) {
        final directory = await getApplicationSupportDirectory();
        print(directory.toString());
        final filePath = '${directory.path}/QuestionPaper.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          _localPdfPath = filePath;
          print(filePath + "hhhh");
          startTimer();
        });
      } else {
        print('Failed to download PDF.');
      }
    } catch (e) {
      writeToFile(e, "_downloadPdf");
      print(e.toString());
    }
  }

  String get timerText {
    int hours = _start.value ~/ 3600;
    int minutes = (_start.value % 3600) ~/ 60;
    int seconds = _start.value % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // void _openFullScreenPdf(int pageNumber) {
  //   final PdfViewerController fullScreenController = PdfViewerController();
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Scaffold(
  //         appBar: AppBar(
  //           iconTheme: IconThemeData(color: ColorPage.white),
  //           title: Text("Full Screen PDF",
  //               style: FontFamily.font3.copyWith(color: Colors.white)),
  //           backgroundColor: ColorPage.appbarcolor,
  //         ),
  //         body: SfPdfViewer.file(
  //           File(_localPdfPath!),
  //           controller: fullScreenController,
  //           key: GlobalKey<SfPdfViewerState>(),
  //           onDocumentLoaded: (PdfDocumentLoadedDetails details) {
  //             fullScreenController.jumpToPage(pageNumber);
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _printPdf() async {
    // try {
    //   if (_localPdfPath != null) {
    //     final file = File(_localPdfPath!);
    //     final pdfBytes = await file.readAsBytes();

    //     // Use Printing.layoutPdf to print the PDF
    //     await Printing.layoutPdf(
    //       onLayout: ( format) async => pdfBytes,
    //     );
    //   } else {
    //     print('No PDF file available to print.');
    //   }
    // } catch (e) {
    //   print('Error printing PDF: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return WillPopScope(
      onWillPop: () async {
        _exitConfirmetionBox2(context, () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        });
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: ColorPage.white),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(
                  () => Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(
                        Icons.alarm_outlined,
                        color: ColorPage.white,
                      ),
                      Text(
                        ' $timerText',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                      SizedBox(width: 20),
                      // SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ],
            backgroundColor: ColorPage.appbarcolor,
            title: Text("Theory Exam",
                style: FontFamily.font3
                    .copyWith(color: Colors.white, fontSize: 18)),
          ),
          body: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      right: BorderSide(
                                          width: 10,
                                          color: ColorPage.appbarcolor))),
                              child:
                                  // widget.documentPath.isEmpty
                                  //     ? Center(
                                  //         child: CircularProgressIndicator(),
                                  //       )
                                  //     :
                                  ShowQuestionPaper(
                                pdfUrl: widget.documentPath,
                                title: widget.title,
                                isEncrypted: false,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: SizedBox(
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // FloatingActionButton(
                //   backgroundColor: Color.fromARGB(255, 207, 232, 255),
                //   onPressed: _printPdf,
                //   child: Icon(Icons.print),
                //   heroTag: 'btn1',
                // ),
                SizedBox(height: 15),
                FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 207, 232, 255),
                  onPressed: () {
                    _onSubmitExam(context);
                  },
                  child: Icon(Icons.arrow_forward_rounded),
                  heroTag: 'btn2',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dispose() {
    if (_timer != null) {
      if (_timer!.isActive) {
        _timer!.cancel();
      }
    }
    // _pageController.dispose();
    super.dispose();
  }

  _onSubmitExam(context) async {
    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        denyButtonText: "Cancel",
        title: "Submit your paper now?",
        text: "Select images to submit your paper",
        confirmButtonText: "Yes",
        type: ArtSweetAlertType.question,
      ),
    );

    if (response == null) {
      return;
    }

    if (response.isTapConfirmButton) {
      Get.back();
      getx.isPaperSubmit.value = false;
      Get.to(
          transition: Transition.cupertino,
          () => SelectExamPapers(
                paperId: widget.paperId,
              ));
      return;
    }
  }
}

_exitConfirmetionBox2(context, VoidCallback ontap) {
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
    title: "Are you sure you want to exit ?",
    // desc:
    //     "",
    buttons: [
      DialogButton(
        width: 150,
        child:
            Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18)),
        highlightColor: Color.fromARGB(255, 203, 46, 46),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Color.fromARGB(255, 139, 19, 19),
      ),
      DialogButton(
        width: 150,
        highlightColor: Color.fromARGB(255, 2, 2, 60),
        child: Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
        onPressed: ontap,
        color: const Color.fromARGB(255, 1, 12, 31),
      ),
    ],
  ).show();
}

_onTimeUp(
  context,
) {
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
    title: "Time Alert",
    desc: "Your time is over!\n Let's Submit your Paper.",
    // desc:
    //     "",
    // buttons: [
    //   DialogButton(
    //     width: 150,
    //     child: Text("Cancel",
    //         style: TextStyle(color: Colors.white, fontSize: 18)),
    //     highlightColor: Color.fromARGB(255, 203, 46, 46),
    //     onPressed: () {
    //       Navigator.pop(context);
    //     },
    //     color: Color.fromARGB(255, 139, 19, 19),
    //   ),
    //   DialogButton(
    //     width: 150,
    //     highlightColor: Color.fromARGB(255, 2, 2, 60),
    //     child:
    //         Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
    //     onPressed: ontap,
    //     color: const Color.fromARGB(255, 1, 12, 31),
    //   ),
    // ],
  ).show();
}
