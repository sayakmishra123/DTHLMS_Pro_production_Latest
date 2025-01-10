import 'package:auto_size_text/auto_size_text.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/MCQ/RankCompetitionMcqExamPageMobile.dart';
import 'package:dthlms/MOBILE/MCQ/MockTestMcqExamPageMobile.dart';
import 'package:dthlms/MOBILE/MCQ/practiceMcq.dart';
import 'package:dthlms/MOBILE/THEORY_EXAM/TheoryExamPageMobile.dart';
import 'package:dthlms/PC/MCQ/MOCKTEST/termandcondition.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class McqTermAndConditionmobile extends StatefulWidget {
  final String termAndCondition;
  final String paperName;
  final String startTime;
  final String totalMarks; 
  final String duration;
  final String paperId;
  final String type;
  final String url;
  final bool isAnswerSheetShow;
  final String startDate;
  final Map<int, List<int>> userAnswer;
  final String endDate;


  McqTermAndConditionmobile(
      {super.key, 
      required this.termAndCondition,
      required this.paperName,
      required this.startTime,
      required this.totalMarks,
      required this.paperId,
      required this.url,
      required this.duration,
      required this.type, required this.isAnswerSheetShow,
      required this.startDate, required this.endDate, required this.userAnswer});

  @override
  State<McqTermAndConditionmobile> createState() =>
      _McqTermAndConditionmobileState();
}

class _McqTermAndConditionmobileState extends State<McqTermAndConditionmobile> {
  RxList mcqdata = [].obs;
  RxBool showWarning = false.obs;
  RxList answerdata = [].obs;

  Future<List<Map<String, dynamic>>> creatMCQlist(String paperId) async {
    List<Map<String, dynamic>> mcqList = [];
    try {
      print("Paper id" + paperId);
      // Fetch the list of sections for the paper
      List sectionData = await fetchMCQSectonList(paperId);

      for (var section in sectionData) {
        String sectionId = section['SectionId'].toString();
        print("section id" + sectionId);
        String sectionName = section["SectionName"]
            .toString(); // Adjust based on your data structure

        // Fetch questions for each section
        List questionData = await fetchTblMCQQuestionList(sectionId);

        for (var question in questionData) {
          String questionId = question['QuestionId'].toString();
          print("question id" +
              questionId); // Adjust based on your data structure

          // Fetch options for each question
          List optionsData = await fetchTblMCQOptionList(questionId);

          // Construct the question map
          Map<String, dynamic> questionMap = {
            "questionid": question['QuestionId'].toString(),
            "isMultiple": question['isMultiple'].toString(),
            "MCQQuestionType": question["MCQQuestionType"].toString(),
            "Question": question['McqQuestion'].toString(),
            "SectionId": sectionId,
            "SectionName": sectionName,
            "options": optionsData,
            "documentUrl": question['documentUrl'],
            "AnswerExplanation": question['AnswerExplanation'],
            "AnswerLink": question['AnswerLink'],
            "AnswerDocumentId": question['AnswerDocumentId'],
            "AnswerDocumentUrl": question['AnswerDocumentUrl'],
            "PassageDocumentUrl": question['PassageDocumentUrl'],
            "PassageLink": question['PassageLink'],
            "PassageDocumentId": question['PassageDocumentId'],
            "MCQQuestionDocumentId": question['MCQQuestionDocumentId'],
            "MCQQuestionUrl": question['MCQQuestionUrl'],
            "MCQQuestionTag": question['MCQQuestionTag'],
            "MCQQuestionMarks": question['MCQQuestionMarks'],
            "PassageDetails":question["PassageDetails"],
            // List of options for the question
          };

          // Add the question map to the main list
          mcqList.add(questionMap);
        }
      }
    } catch (e) {
      writeToFile(e, "creatMCQlist");
      print(e.toString() + "error on fetch mcq data");
    }
    answerdata.value = formatAnswers(mcqList);
    return mcqList;
  }

  Future getMCQDATA() async {
    mcqdata.value = await creatMCQlist(widget.paperId);

    print(mcqdata.value.toString() + "list of mcq");
  }

  List formatAnswers(List questions) {
    List<Map<int, List<int>>> answer = [];

    for (var question in questions) {
      int questionId = int.parse(question['questionid']);
      List<int> correctOptionIds = [];

      for (var option in question['options']) {
        if (option['IsCorrect'] == "true") {
          correctOptionIds.add(int.parse(option['OptionId'].toString()));
        }
      }

      // For single-choice questions, keep only the first correct option if any
      if (question['isMultiple'] == "false" && correctOptionIds.isNotEmpty) {
        correctOptionIds = [correctOptionIds.first];
      }

      answer.add({questionId: correctOptionIds});
    }

    return answer;
  }

 

  RxBool checkbox = false.obs;
  @override
  void initState() {
    getMCQDATA();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: ColorPage.appbarcolor,
        // leading: Image.asset(
        //   'assets/2.png',
        // ),
        iconTheme: IconThemeData(
          color: ColorPage.white,
        ),

        title: Text(
          widget.paperName,
          style: FontFamily.font5.copyWith(fontSize: 15),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.home,
        //         color: ColorPage.white,
        //       )),
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.person_3_rounded,
        //         color: ColorPage.white,
        //       ))
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row(
              //   children: [
              //     Text(
              //       '* Math Test',
              //       style: TextStyle(
              //           fontWeight: FontWeight.bold, color: ColorPage.green),
              //       textScaler: TextScaler.linear(1.5),
              //     )
              //   ],
              // ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width / 1.5,
                    child: Text(
                      'Please read the following instructions carefully',
                      style: TextStyle(
                        decorationColor: ColorPage.appbarcolor,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaler: TextScaler.linear(1.4),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Container(
                        // alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width-120,
                        child:  widget. termAndCondition!=""? HtmlWidget(
                           widget.termAndCondition.toString(),
                        ):Text(
                          textAlign: TextAlign.justify,
                         'No instructions here!',
                        // "sjdhfiuahidfh wef as df ww ef  wefaswdf awsdf a sdfawefas fwargyaw s fertfh dsfsfhsrfwsdha efgawhres fgawegaw gvaewrgawe rgweafg ef wef wa g awg er g serg ",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(color: ColorPage.grey)),
                          textScaler: TextScaler.linear(1.2),
                        )),
                  
                ],
              ),
              SizedBox(height: 30),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Name : ${widget.paperName}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // Text(
                  //   'Total Questions : 60',
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  // )
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Type : Multiple Choice',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                  'Total Duration :${(double.parse(widget.duration).toInt())~/60} minutes',  
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Start at : ${formatDateWithOrdinal(widget.startTime)}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Marks : ${widget.totalMarks}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => SizedBox(
                            child: Checkbox(
                          activeColor: Color.fromARGB(255, 54, 127, 244),
                          value: checkbox.value,
                          onChanged: (v) {
                            checkbox.value = !checkbox.value;
                          },
                        )),
                      ),
                      Container(
                          child: AutoSizeText(
                        'I have read the instructions carefully!',
                        style: FontFamily.font6.copyWith(fontSize: 11),
                        minFontSize: 5,
                        maxFontSize: 15,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (checkbox.value) {
                          String attempt=DateTime.now().toString();
                        if (widget.type == "Quick Practice") {
                            
                              
                                await  inserTblMCQhistory(widget.paperId,'Quick Practice',widget.paperName,'','',attempt,"0").then((_){
                          Get.off(() => RankCompetitionMcqExamPageMobile(
                                examStartTime: widget.startTime,  
                                paperId: widget.paperId,
                                mcqlist: mcqdata,  
                                answerList: answerdata, 
                                paperName: widget.paperName,
                                duration: widget.duration,
                                attempt: attempt,
                                examType:"Quick Practice" ,
                                isAnswerSheetShow:false ,
                                totalDuration:widget.duration ,
                                userAnswer:{} ,
                                totalMarks: widget.totalMarks,
                              ));
                                }); 
                        }

                        if (widget.type == "Comprehensive") { 
                                  String attempt = DateTime.now().toString();
                           await  inserTblMCQhistory(widget.paperId,'Comprehensive',widget.paperName,'','',attempt,"0").then((_){
                          Get.off(() => RankCompetitionMcqExamPageMobile(    
                                examStartTime: widget.startTime,
                                paperId: widget.paperId,
                                mcqlist: mcqdata,
                                answerList: answerdata, 
                                paperName: widget.paperName, 
                                totalMarks: widget.totalMarks,
                                duration: widget.duration, 
                                attempt: attempt,
                                examType:"Comprehensive" ,
                                isAnswerSheetShow: widget.isAnswerSheetShow,
                                totalDuration: widget.duration,
                                userAnswer: {},
                              ));
                           });
                        }

                        if (widget.type == "Ranked Competition"){
                            
                           if(getx.isInternet.value){
                          // String examStatus=  isTimeExpired(widget.startTime,int.parse( widget.duration));
                          String examStatus="3600";

                             if (examStatus=="false"){
                               _onTermDeniey(context,"Exam Not Started","Your exam is yet to begin");

                            }
                            else if (examStatus=="expire"){
                              _onTermDeniey(context,"Exam Time Expired","Your exam has expired");
                            }
                            
                            else{
                                await  inserTblMCQhistory(widget.paperId,'Ranked Competition',widget.paperName,'','',attempt,"0").then((_){
                              Get.off(() => RankCompetitionMcqExamPageMobile( 

                            examStartTime:widget.startTime,
                            paperId: widget.paperId,
                                mcqlist: mcqdata,
                                answerList: answerdata,
                                paperName: widget.paperName,
                                duration: widget.duration,
                                attempt: attempt,
                                totalDuration: widget.duration,
                                userAnswer: {},
                                isAnswerSheetShow: widget.isAnswerSheetShow, 
                                examType:"Ranked Competition",
                                totalMarks: widget.totalMarks,
                              ));
                              });




                            }
                              
                           }
                           else{
                            _onTermDeniey(context,"No Internet","You don't have any internet connection!");
                           }
                           

                          }
                        if (widget.type == "Theory") {
                          var examcode = await getExamStatus(context,
                              getx.loginuserdata[0].token, widget.paperId);
                          if (examcode == 200) {
                            print("$examcode");
                            Get.off(() => TheoryExamPageMobile( 
                                  // documentUrl: widget.url,
                                  paperId: widget.paperId,
                                  duration: widget.duration,
                                  issubmit: true, 
                                  documentPath: widget.url, 
                                  title: widget.paperName, 
                                ));
                          }
                          if (examcode == 250) {
                            Get.off(() => TheoryExamPageMobile(    
                                title: widget.paperName,
                                  documentPath: widget.url,

                                  paperId: widget.paperId,
                                  duration: widget.duration,
                                  issubmit: false,
                                )); 
                          }
                           if (examcode == 300) {
                          _showDialogoferror(context,"Already Submited!","your exam is already submited.",(){
                            Navigator.pop(context);
                          },false);
                        }
                        if(examcode==400){
                            _showDialogoferror(context,"Time is Over!","your exam is already ended.",(){
                            Navigator.pop(context);
                          },false);

                        }
                        }

                        print(widget.type);
                        // widget.type == "Practice"
                        //     ? Get.to(()=>PracticeMcqMobile())
                        //     : widget.type == "MockTest"
                        //         ? Get.to(() => MockTestMcqExamPageMobile())
                        //         : Get.to(()=>MockTestMcqExamPageMobile());
                      } else {
                        _onTermDeniey(context,"Term Not Accepted !!", "Please agree with our Term & condition of Exam. \n Fill the check box After reading the term & condition.  ");
                      }
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50)),
                        shape: WidgetStatePropertyAll(
                            ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        backgroundColor:
                            WidgetStatePropertyAll(ColorPage.blue)),
                  ),



                  //                   ElevatedButton(
                  //   onPressed: () async {
                  //     if (checkbox.value) {
                  //         String attempt=DateTime.now().toString();
                  //       if (widget.type == "Quick Practice") {
                            
                              
                  //               await  inserTblMCQhistory(widget.paperId,'Quick Practice',widget.paperName,'','',attempt,"0").then((_){
                  //         Get.off(() => PracticeMcqMobile(
                  //               examStartTime: widget.startTime,  
                  //               paperId: widget.paperId,
                  //               mcqlist: mcqdata,  
                  //               answerList: answerdata, 
                  //               paperName: widget.paperName,
                  //               duration: widget.duration,
                  //               attemp: attempt,
                  //             ));
                  //               }); 
                  //       }

                  //       if (widget.type == "Comprehensive") { 
                  //                 String attempt = DateTime.now().toString();
                  //          await  inserTblMCQhistory(widget.paperId,'Comprehensive',widget.paperName,'','',attempt,"0").then((_){
                  //         Get.off(() => MockTestMcqExamPageMobile(    
                  //               examStartTime: widget.startTime,
                  //               paperId: widget.paperId,
                  //               mcqlist: mcqdata,
                  //               answerList: answerdata, 
                  //               paperName: widget.paperName, 
                  //               totalMarks: widget.totalMarks,
                  //               duration: widget.duration, 
                  //               attempt: attempt,
                  //               type: widget.type
                  //             ));
                  //          });
                  //       }

                  //       if (widget.type == "Ranked Competition"){
                            
                  //          if(getx.isInternet.value){
                  //         String examStatus=  isTimeExpired(widget.startTime,int.parse( widget.duration));

                  //            if (examStatus=="false"){
                  //              _onTermDeniey(context,"Exam Not Started","Your exam is yet to begin");

                  //           }
                  //           else if (examStatus=="expire"){
                  //             _onTermDeniey(context,"Exam Time Expired","Your exam has expired");
                  //           }
                            
                  //           else{
                  //               await  inserTblMCQhistory(widget.paperId,'Ranked Competition',widget.paperName,'','',attempt,"0").then((_){
                  //             Get.off(() => RankCompetitionMcqExamPageMobile( 

                  //           examStartTime:widget.startTime,
                  //           paperId: widget.paperId,
                  //               mcqlist: mcqdata,
                  //               answerList: answerdata,
                  //               paperName: widget.paperName,
                  //               duration: examStatus,
                  //               attempt: attempt,
                  //               totalDuration: widget.duration,
                  //               userAnswer: {},
                  //               isAnswerSheetShow: widget.isAnswerSheetShow, 
                  //             ));
                  //             });




                  //           }
                              
                  //          }
                  //          else{
                  //           _onTermDeniey(context,"No Internet","You don't have any internet connection!");
                  //          }
                           

                  //         }
                  //       if (widget.type == "Theory") {
                  //         var examcode = await getExamStatus(context,
                  //             getx.loginuserdata[0].token, widget.paperId);
                  //         if (examcode == 200) {
                  //           print("$examcode");
                  //           Get.off(() => TheoryExamPageMobile( 
                  //                 // documentUrl: widget.url,
                  //                 paperId: widget.paperId,
                  //                 duration: widget.duration,
                  //                 issubmit: true, 
                  //                 documentPath: widget.url, 
                  //                 title: widget.paperName, 
                  //               ));
                  //         }
                  //         if (examcode == 250) {
                  //           Get.off(() => TheoryExamPageMobile(    
                  //               title: widget.paperName,
                  //                 documentPath: widget.url,

                  //                 paperId: widget.paperId,
                  //                 duration: widget.duration,
                  //                 issubmit: false,
                  //               )); 
                  //         }
                  //          if (examcode == 300) {
                  //         _showDialogoferror(context,"Already Submited!","your exam is already submited.",(){
                  //           Navigator.pop(context);
                  //         },false);
                  //       }
                  //       if(examcode==400){
                  //           _showDialogoferror(context,"Time is Over!","your exam is already ended.",(){
                  //           Navigator.pop(context);
                  //         },false);

                  //       }
                  //       }

                  //       print(widget.type);
                  //       // widget.type == "Practice"
                  //       //     ? Get.to(()=>PracticeMcqMobile())
                  //       //     : widget.type == "MockTest"
                  //       //         ? Get.to(() => MockTestMcqExamPageMobile())
                  //       //         : Get.to(()=>MockTestMcqExamPageMobile());
                  //     } else {
                  //       _onTermDeniey(context,"Term Not Accepted !!", "Please agree with our Term & condition of Exam. \n Fill the check box After reading the term & condition.  ");
                  //     }
                  //   },
                  //   child: Text(
                  //     'Next',
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   style: ButtonStyle(
                  //       padding: WidgetStatePropertyAll(
                  //           EdgeInsets.symmetric(vertical: 10, horizontal: 50)),
                  //       shape: WidgetStatePropertyAll(
                  //           ContinuousRectangleBorder(
                  //               borderRadius: BorderRadius.circular(10))),
                  //       backgroundColor:
                  //           WidgetStatePropertyAll(ColorPage.blue)),
                  // )
                ],
              )

              //For Windows
            ],
          ),
        ),
      ),
    );
  }


  
  _onTermDeniey(context,String title,String desc) {
    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
        titleStyle:
            TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: title,
      desc:
         desc,
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
}
  _showDialogoferror(context,String title,String desc,VoidCallback ontap ,bool iscancelbutton ) {
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
      title: title,
      desc:desc,
      buttons:[
       
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



