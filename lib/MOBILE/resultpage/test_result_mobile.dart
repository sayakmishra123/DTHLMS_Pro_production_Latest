import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/PC/testresult/indicator.dart';
import 'package:dthlms/PC/testresult/test_result_page.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../CUSTOMDIALOG/customdialog.dart';

class TestResultPageMobile extends StatefulWidget {
  final String studentName;
  final String examName;
  final String submitedOn;
  final String resultPublishedOn;
  final double totalMarks;
  final double obtain;
  final double totalMarksRequired;
  final String examId;
  final String pdfUrl;


  const TestResultPageMobile({super.key,required this.pdfUrl, required this.studentName, required this.examName, required this.submitedOn, required this.resultPublishedOn, required this.totalMarks, required this.obtain, required this.totalMarksRequired, required this.examId,});

  @override
  State<TestResultPageMobile> createState() => _TestResultPageMobileState();
}

class _TestResultPageMobileState extends State<TestResultPageMobile> {
  int touchedIndex = -1;





//  TextStyle _textStyle = TextStyle(fontSize: 25);
TextStyle headerStyle = TextStyle(color: Colors.blue,fontSize: 12);
TextStyle studentTitleStyle = TextStyle(fontSize: 17,color: Colors.black);
TextStyle studentNameStyle = TextStyle(fontSize: 17,color: Colors.blue);
  void recheckAnswerSheetAlert() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: 'Recheck Answer Sheet',
        description:
            'Are you sure you want to submit the answer sheet for rechecking? Additional fees may apply for this process.',
        OnCancell: () {
          Navigator.of(context).pop();
        },
        OnConfirm: () {
          Navigator.of(context).pop();
          // Add logic for rechecking the answer sheet
        },
        btn1: 'Cancel',
        btn2: 'Submit',
        linkText: 'Learn more about rechecking',
      );
    },
  );
}

void DownloadAnswerSheetAlert() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: 'Download Answer Sheet',
        description:
            'Are you sure you want to download your answer sheet? Ensure sufficient storage is available on your device.',
        OnCancell: () {
          Navigator.of(context).pop();
        },
        OnConfirm: () {
          Navigator.of(context).pop();
          // Add logic for downloading the answer sheet
        },
        btn1: 'Cancel',
        btn2: 'Download',
        linkText: 'Learn more about downloading',
      );
    },
  );
}

void DownloadQuestionPaperAlert() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: 'Download Question Paper',
        description:
            'Are you sure you want to download the question paper? Please note that downloading may require a stable internet connection.',
        OnCancell: () {
          Navigator.of(context).pop();
        },
        OnConfirm: () {
          Navigator.of(context).pop();
          // Add logic for downloading the question paper
        },
        btn1: 'Cancel',
        btn2: 'Download',
        linkText: 'Learn more about question papers',
      );
    }, 
  );
}

String formatDate(DateTime dateTime) {
  final DateFormat formatter = DateFormat('d MMM yyyy'); // "17 Jul 2023" format
  return formatter.format(dateTime);
}
String pass='';
bool isPass = false;
String downloadedFilePath = '';
   Future<String?> getSavePath() async {
    // Open a file picker dialog
    String? result = await FilePicker.platform.saveFile(
      dialogTitle: "Save Answer Sheet",
      fileName: "answer_sheet.pdf", // default file name
    );

    if (result != null) { 
      return result; // Return the file path selected by the user
    }
    return null; // Return null if the user cancels the file picker
  }
double downloadProgress = 0.0;
  CancelToken cancelToken = CancelToken();

RxBool    isDownloading = false.obs;
Future<void> downloadAnswerSheet(String url) async {
    Dio dio = Dio();

    String? filePath = await getSavePath();
    if (filePath == null) {
      return; // If user cancels file selection, stop the process
    }

    try {
      
        isDownloading.value = true;
     

      // Start downloading the file
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadProgress = (received / total);
            });
          }
        },
        cancelToken: cancelToken,
      );

      setState(() {
        isDownloading.value = false;
        downloadedFilePath = filePath;
      });

      // Show dialog to inform the user that download is complete
      showDownloadCompleteDialog();
    } catch (e) {
    
        isDownloading.value = false;
    

      // Show error dialog if the download fails
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Download Failed"),
          content: Text("There was an error downloading the file."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }


    void cancelDownload() {
    cancelToken.cancel();
    setState(() {
      isDownloading.value = false;
    });
  }

 void showDownloadCompleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Download Complete"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("The answer sheet has been downloaded."),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showPdfDialog(downloadedFilePath);
              },
              child: Text("Show PDF"),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }


//  void showDownloadCompleteDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("Answer sheet not found"),
//         // content: Column(
//         //   mainAxisSize: MainAxisSize.min,
//         //   children: <Widget>[
//         //     Text("The answer sheet has been downloaded."),
//         //     SizedBox(height: 10),
//         //     ElevatedButton(
//         //       onPressed: () {
//         //         Navigator.of(context).pop();
//         //         showPdfDialog(downloadedFilePath);
//         //       },
//         //       child: Text("Show PDF"),
//         //     ),
//         //   ],
//         // ),
//         actions: <Widget>[
//           TextButton(
//             child: Text("Close"),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ],
//       ),
//     );
//   }

   void showPdfDialog(String filePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width*0.7,
          height: MediaQuery.of(context).size.height*0.9,
          child: SfPdfViewer.file(File(filePath)), // Using spfpdfviewer to display PDF
        ),
      ),
    );
  }



@override
  void initState() {
    checkIfPass();
    super.initState();
  }

  checkIfPass(){
    if(widget.obtain >= widget.totalMarksRequired){
      pass = "Pass";
      isPass = true;
    }else{
      isPass = false;
      pass = "Fail";

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorPage.mainBlue,
        title: Text(
          'Test Result',
          style: FontFamily.style.copyWith(color: Colors.white),
        ),
      ),
      backgroundColor: Color(0xffEEEEEE),
      body: Container(
       height: MediaQuery.of(context).size.height,
       width: MediaQuery.of(context).size.width,
      
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                    Column(children: [ 
                      SizedBox(height: 20,),
                        Container(
                        padding: EdgeInsets.all(10),
                         decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Expanded(child: Column(
                           children: [
                             SizedBox(
                               height: 80,
                               width: 80,
                               child: Image(image: AssetImage('assets/person.png')),
                             ),
                             SizedBox(height: 5,),
                            //  SizedBox(
                            //   height: 80,
                            //    child: Image(image: AssetImage('assets/signature.png')),
                            //  )
                           ],
                          )),
                          SizedBox(width: 10,),
                          Expanded(
                           flex: 3,
                           child: Column(
                           children: [
                             Row(
                               children: [
                                 Icon(Icons.person_outline_rounded,size: 30,),
                                 SizedBox(width: 10,),
                                 Column(
                                   children: [
                                     Text('Basic Info',style: TextStyle(color: Colors.blue,fontSize: 20),),
                                     Text('The Valuation School',style: TextStyle(color: Colors.grey,fontSize: 14),),
                                                  
                                   ],
                                 ),
                                 
                               ],
                             ),
                             SizedBox(height: 20,),
                             Row(
                               children: [
                                 RichText(text: TextSpan(
                                     
                                      children: [
                                      TextSpan(text: 'Name: ', style: studentTitleStyle),
                                                    
                                      TextSpan(text: widget.studentName, style: studentNameStyle),
                                    ]),
                                    ),
                               ],
                             ),
                                                       Row(
                               children: [
                                 RichText(text: TextSpan(
                                     
                                      children: [
                                      TextSpan(text: 'Exam Name: ', style: studentTitleStyle),
                                                    
                                      TextSpan(text: widget.examName, style: studentNameStyle),
                                    ]),
                                    ),
                               ],
                             ),
                                 Row(
                                   children: [
                                     Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                 
                                                                     
                                         
                                          children: [
                                           
                                          Text( 'Submitted on: ', style: studentTitleStyle),
                                                        
                                          Text( widget.submitedOn, style: studentNameStyle),
                                       
                                                                    ],
                                                                  ),
                                   ],
                                 ),
                             
                             Row(
                               children: [
                                 Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  
                                         
                                          children: [
                                          Text( 'Result published on: ', style: studentTitleStyle),
                                                        
                                          Text(widget.resultPublishedOn, style: studentNameStyle),
                                       
                                        
                                   ],
                                 ),
                               ],
                             ),
                             Row(
                               children: [
                                SizedBox(height: 30,)
                               ],
                             ),
                           ],
                          ))
                          ],),
                        ),
                       
                      SizedBox(height: 20,),
                         
                    
                    
                    Container(
                           padding: EdgeInsets.symmetric(vertical: 25),
                           
                           decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(20)),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               SizedBox(
                                 height: 200,
                                 width: 200,
                                 child: PieChart(
                                   PieChartData(
                                     pieTouchData: PieTouchData(
                                       touchCallback:
                                           (FlTouchEvent event, pieTouchResponse) {
                                         setState(() {
                                           if (!event.isInterestedForInteractions ||
                                               pieTouchResponse == null ||
                                               pieTouchResponse.touchedSection ==
                                                   null) {
                                             touchedIndex = -1;
                                             return;
                                           }
                                           touchedIndex = pieTouchResponse
                                               .touchedSection!.touchedSectionIndex;
                                         });
                                       },
                                     ),
                                     borderData: FlBorderData(
                                       show: false,
                                     ),
                                     sectionsSpace: 0,
                                     centerSpaceRadius: 40,
                                     sections: showingSections(),
                                   ),
                                 ),
                               ),
                               SizedBox(
                                 height: 10,
                               ),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Column(
                                     
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           children: <Widget>[
                                      Indicator(
                                        color: AppColors.contentColorBlue,
                                        text: 'Remaining Marks',
                                        isSquare: true,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Indicator(
                                        color: AppColors.contentColorYellow,
                                        text: 'Obtain Marks',
                                        isSquare: true,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                     
                                    ],
                                    
                                         ),
                                 ],
                               ),
                             ],
                           ),
                         ),
                    
                    SizedBox(height: 20,
                                    
                    ),

                    
                                    
                     Container(
                     height: 270,
                    
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          DataTable(
                          
                            columns: <DataColumn>[
                              DataColumn(
                                label: Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Paper',
                                        style: headerStyle,
                                      ),
                                      Text(
                                        'Name',
                                        style: headerStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Date',
                                    style: headerStyle,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Column(
                                  children: [
                                    Text(
                                      'Total',
                                      style: headerStyle,
                                    ),
                                    Text(
                                      'Marks',
                                      style: headerStyle,
                                    ),
                                  ],
                                ),
                              ),
                              DataColumn(
                                label: Column(
                                  children: [
                                    Text(
                                      'Obtain',
                                      style: headerStyle,
                                    ),
                                    Text(
                                        'Marks',
                                        style: headerStyle,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                            rows: <DataRow>[
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(widget.examName)),
                                  DataCell(Text(widget.submitedOn)),
                                  DataCell(Text(widget.totalMarks.toString())),
                                  DataCell(Text(widget.obtain.toString())),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20), 
                         
                              Row(
                                children: [
                                  RichText(text: TextSpan(
                                   
                                    children: [
                                    TextSpan(text: 'Total Marks Required: ', style: TextStyle(fontSize: 16,color: Colors.black)),
                                                      
                                    TextSpan(text: widget.totalMarksRequired.toString(), style: TextStyle(fontSize: 16,color: Colors.blue)),
                                  ]),
                                  ),
                                ],
                              ),
                          SizedBox(height: 10), 
                     
                               Row(
                                 children: [
                                   RichText(text: TextSpan(
                                   
                                    children: [
                                    TextSpan(text: 'Total Marks Obtain: ', style: TextStyle(fontSize: 16,color: Colors.black)),
                                                       
                                    TextSpan(text: widget.totalMarks.toString(), style: TextStyle(fontSize: 16,color: Colors.blue)),
                                                                 ]),
                                                                 ),
                                 ],
                               ),
                           
                          SizedBox(height: 20,),
                          Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                            
                                RichText(text: TextSpan(
                                   
                                    children: [
                                    TextSpan(text: 'Status: ', style: TextStyle(fontSize: 18,color: Colors.black)),
                                    TextSpan(text: pass, style: TextStyle(fontSize: 18,color: isPass? Colors.green : Colors.amber)),
                                    
                                                                 ]),),
                           ElevatedButton(
                                    
                             style: ButtonStyle(
                               padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 5,horizontal: 10)),
                               backgroundColor: WidgetStatePropertyAll(Colors.amber[700])),
                             onPressed: (){
                              requestForRecheckAnswerSheet(
                    context, getx.loginuserdata[0].token, widget.examId)
                .then((value) {
              if (value) {
                onActionDialogBox("Requested", "Your request for Recheck answerSheet is send Successfully!",
                    () {
                  Navigator.of(context).pop();
                  
                }, context, true);
              } else {
                onActionDialogBox("Request Failed!!", "", () {
                  Navigator.of(context).pop();
                  
                }, context, false);
              }
            });
                             }, child: Text('Recheck Answersheet',style: TextStyle(color: Colors.white),))
                          ],)
                        ],
                      ),
                    ),
                                         
                     
                     ]),
                     
                    
                   SizedBox(height: 10,),
                         
                        
                                               Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                
                        //                         ElevatedButton(
                        //  style: ButtonStyle(
                        //          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10,horizontal: 10)),
                        //          backgroundColor: WidgetStatePropertyAll(Colors.blueGrey)),
                        //  onPressed: (){
                        //   //  DownloadQuestionPaperAlert();
                        //  }, child: Text('Download Question Paper',style: TextStyle(color: Colors.white),)),
                                              
                                                ElevatedButton(
                         style: ButtonStyle(
                                 padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10,horizontal: 10)),
                                 backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                         onPressed: isDownloading.value
                      ? null
                      : () async{

                        // showDownloadCompleteDialog();
                      // await  getAnswerSheetURLforStudent(context,getx.loginuserdata[0].token,widget.examId).then((answerUrl){
                      //   print(answerUrl);
                      //   print(answerUrl);

                        if(widget.pdfUrl.isNotEmpty){
                           downloadAnswerSheet(widget.pdfUrl);
                        }


                      // });




                         
                        }, child: Text('Download Answer Sheet',style: TextStyle(color: Colors.white),)),
                                      
                                                ],),
                                                SizedBox(height: 50,)
              
            ],
          ),
        ),
      ),
    );
  }



  List<PieChartSectionData> showingSections() {
double remainingMarks = widget.totalMarks - widget.obtain;

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: remainingMarks,
            title: remainingMarks.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.contentColorYellow,
            value: widget.obtain,
            title: widget.obtain.toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        
        default:
          throw Error();
      }
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
