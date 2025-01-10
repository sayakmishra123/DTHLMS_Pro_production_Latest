import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/PC/MCQ/MOCKTEST/resultMcqTest.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../LOCAL_DATABASE/dbfunction/dbfunction.dart';

class MocktestAnswer extends StatefulWidget {
  final String paperId;
  final List questionData;
  final String type;
  const MocktestAnswer({required this.paperId, required this.questionData, required this.type});
 

  @override
  State<MocktestAnswer> createState() => _MocktestAnswerState();
}

class _MocktestAnswerState extends State<MocktestAnswer> {


   Getx getxController = Get.put(Getx());
  // final List<McqItem> mcqData= Get.arguments['mcqData'];
  //  final Map<int, int> userAns = Get.arguments['userAns'];
  // final List<Map<int, int>> correctAnswers = Get.arguments['correctAnswers'];
  @override
  Widget build(BuildContext context) {
    int totalMarks = 0;
    // List<Widget> questionWidgets = mcqData.asMap().entries.map((entry) {
    //   int index = entry.key;
    //   McqItem mcqItem = entry.value;
    //   int questionId =int.parse( mcqItem.questionId);
    //   String question = mcqItem.questionText;
    //   String userSelected = userAns.containsKey(questionId)
    //       ? mcqItem.options
    //           .firstWhere(
    //               (option) => option.optionId == userAns[questionId])
    //           .optionText
    //       : 'Not Answered';
    //   String correctAnswer = mcqItem.options
    //       .firstWhere((option) => correctAnswers
    //           .any((map) => map[questionId] == option.optionId))
    //       .optionText;
    //   int marks = userAns.containsKey(questionId) &&
    //           correctAnswers
    //               .any((map) => map[questionId] == userAns[questionId])
    //       ? 1
    //       : 0;
    //   totalMarks += marks;

    //   return Container(
    //     margin: EdgeInsets.only(top: 10),
    //     // decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.all(Radius.circular(10),),boxShadow: [
    //     //   BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 2),
    //     // ]),
    //     child: ListTile(
    //       title: Text(
    //         '${index + 1}. $question',
    //         style: FontFamily.font4.copyWith(fontWeight: FontWeight.w500),
    //       ),
    //       subtitle: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text('Your Answer: $userSelected'),
    //           Text('Correct Answer: $correctAnswer'),
    //         ],
    //       ),
    //       trailing: Text(
    //         marks.toString(),
    //         style: FontFamily.font3.copyWith(color: Colors.black),
    //       ),
    //     ),
    //   );
    // }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPage.appbarcolor,
        iconTheme: IconThemeData(color: ColorPage.white),
        centerTitle: true,
        title: Text(
          "QNA",
          style: FontFamily.font3,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 225, 227),
                border: Border(
                  left: BorderSide(color: ColorPage.appbarcolor, width: 3),
                ),
              ),
              child:    Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    itemCount: widget.questionData.length,
                    itemBuilder: (context, index) {
                      // totalMarks = 0;
                      // bool isCorrect = widget.questionData[index]
                      //         ['correctanswerId']
                      //     .toSet()
                      //     .containsAll(widget.questionData[index]
                      //         ['userselectedanswer id']);
                      // // int marks = isCorrect ? 1 : 0;
                      // totalMarks += marks;
                      print(totalMarks.toString());
                      return Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '${index + 1}. ${widget.questionData[index]['question name']}',
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          subtitle: Card(
                            elevation: 0,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Your Answer: ',
                                          style: TextStyle(
                                            color: Colors
                                                .blue, // Choose your preferred color
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${widget.questionData[index]['userselectedanswer'].join(", ")}',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Correct Answer: ',
                                          style: TextStyle(
                                            color: Colors
                                                .green, // Choose your preferred color
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                       TextSpan(
                                            text:getQuestionTypeFromId(widget.questionData[index]['questionid'].toString())=="One Word Answer"?getOneWordAnswerFromQuestionId(widget.questionData[index]['questionid'].toString()):



                                                '${widget.questionData[index]['correctanswer'].join(", ")}',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              
                                widget.type=="Ranked Competition"?widget.questionData[index]['ObtainMarks'].toString():calculateTotalMarkOfQuestion(widget.questionData[index]
                                ['questionid'].toString(),widget.questionData[index]
                                ['userselectedanswer id'],getQuestionTypeFromId(widget.questionData[index]
                                ['questionid'].toString())).toString(),
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 71, 71, 71),
                                  fontSize: 10),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            
            
            
            ),
          ],
        ),
      ),
    );
  }
}
