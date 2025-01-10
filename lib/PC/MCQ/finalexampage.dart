import 'dart:convert';
import 'dart:math';

import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
// import 'package:dthlms/MOBILE/VIDEO/mobilevideoplay.dart';
import 'package:dthlms/PC/MCQ/PRACTICE/practiceMcqPage.dart';
import 'package:dthlms/PC/MCQ/modelclass.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Home page with the entire layout
class PracticeMcqExamPage extends StatefulWidget {
  final List mcqlist;
  final List answerList;
  final String attempt;

  final String paperId;
  final String examStartTime;
  final String paperName;
  final String duration;
  const PracticeMcqExamPage(
      {super.key,
      required this.mcqlist,
      required this.attempt,
      required this.answerList,
      required this.duration,
      required this.examStartTime,
      required this.paperId,
      required this.paperName});

  @override
  State<PracticeMcqExamPage> createState() => _PracticeMcqExamPageState();
}

class _PracticeMcqExamPageState extends State<PracticeMcqExamPage> {
  /// Current question type to display
  String _questionType = 'text'; // default: text question

  List answer = [];
  // Store user answers, allowing multiple answers for each question
  Map<int, List<int>> userAns = {};

  Getx getx_obj = Get.put(Getx());
  RxBool buttonshow = true.obs;
  String lastattemp = "";

  Future<void> getdata() async {
    print(widget.mcqlist);
    // Assuming widget.mcqlist is a valid JSON string
    String jsonData = jsonEncode(widget.mcqlist);

    List<dynamic> parsedJson = jsonDecode(jsonData);
    List<McqItem> mcqDatalist =
        parsedJson.map((json) => McqItem.fromJson(json)).toList();
    mcqData.value = mcqDatalist;
  }

  Map<int, int> sectionOffsets = {};

  @override
  void initState() {
    answer = widget.answerList;
    print(answer);
    super.initState();
    sectionWiseQuestionIdList = groupQuestionsBySection(widget.mcqlist);

    // Calculate offsets for each section
    int cumulativeIndex = 0;
    for (var sectionMap in sectionWiseQuestionIdList) {
      int sectionId = sectionMap.keys.first;
      sectionOffsets[sectionId] = cumulativeIndex;
      cumulativeIndex += (sectionMap[sectionId]!.length as int);
    }

    getdata().whenComplete(() => setState(() {}));
  }

  List sectionWiseQuestionIdList = [];
  @override
  void dispose() {
    super.dispose();
  }

  String groupname = 'Group A';

  List<int> reviewlist = [];

  RxInt qindex = 0.obs;
  int selectedIndex = -1;
  RxBool isSubmitted = false.obs;
  RxInt score = 0.obs;

  RxList<McqItem> mcqData = <McqItem>[].obs;
  List correctAnswerListOfStudent = [];

  /// Switch question type method
  void _switchQuestionType(String newType) {
    setState(() {
      _questionType = newType;
    });
  }

  /// Build top bar with gradient background and time progress
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // Gradient background
      decoration: BoxDecoration(
        color: ColorPage.colorbutton,
        // gradient: LinearGradient(
        //   colors: [Color(0xFF3f51b5), Color(0xFF5c6bc0)],
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        // ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Exam Title
          const Text(
            'Paper 3',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Time Left + Progress Bar
          Row(
            children: [
              const Text(
                'Time Left:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              // Custom progress bar container
              SizedBox(
                width: 150,
                height: 10,
                child: Stack(
                  children: [
                    // Background
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    // Fill portion (example: 60%)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double progressWidth = constraints.maxWidth * 0.60;
                        return Container(
                          width: progressWidth,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build left panel with info cards
  Widget _buildLeftPanel() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info Card #1
          _buildInfoCard(
            title: "Section 1",
            content:
                "Here you can show instructions or details about the section.",
          ),

          // Info Card #2
          _buildInfoCard(
            title: 'Instraction:',
            content:
                "1. Read each question carefully.\n2. Select the correct option.\n3. Mark for review if unsure.\n\nBest of luck!",
            // This card has a "divider" so we can put it in the content
          ),
        ],
      ),
    );
  }

  /// Helper method to create an info card
  Widget _buildInfoCard({String? title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
          ],
          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  /// Build question header + switch buttons
  Widget _buildQuestionHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Question #1:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          // Switch buttons
          Row(
            children: [
              _buildSwitchButton('Text',
                  onTap: () => _switchQuestionType('text')),
              _buildSwitchButton('Image',
                  onTap: () => _switchQuestionType('image')),
              _buildSwitchButton('Video',
                  onTap: () => _switchQuestionType('video')),
              _buildSwitchButton('Audio',
                  onTap: () => _switchQuestionType('audio')),
              _buildSwitchButton('None',
                  onTap: () => _switchQuestionType('none')),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper: small button used to switch question type
  Widget _buildSwitchButton(String label, {required void Function() onTap}) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        // Border & background
        side: const BorderSide(color: Colors.grey, width: 1),
        backgroundColor: Colors.grey.shade200,
        // Text color
        foregroundColor: Colors.black,
        // Make corners less rounded (like basic HTML buttons)
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        // Optional: match text style to HTML defaults
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: Text(label),
    );
  }

  /// Build the central content area with question + options
  Widget _buildCenterContent() {
    return Column(
      children: [
        // Question header
        _buildQuestionHeader(),
        const SizedBox(height: 20),
        // Question content
        _buildQuestionContent(),
        const SizedBox(height: 20),
        // Options list
        _buildOptionsList(),
      ],
    );
  }

  /// Build question content depending on _questionType
  Widget _buildQuestionContent() {
    return Container(
      padding: const EdgeInsets.all(15),
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Obx(
        () => mcqData.isNotEmpty
            ? Center(
                child: Text(
                  mcqData[qindex.value].questionText,
                  style: TextStyle(
                      fontSize: 16, height: 1.5, fontWeight: FontWeight.bold),
                ),
              )
            // Builder(builder: (context) {
            //     switch (_questionType) {
            //       case 'text':
            //         return Container(
            //           width: MediaQuery.sizeOf(context).width,
            //           // child: Text(
            //           // mcqData[qindex.value].questionText,
            //           // style: TextStyle(
            //           //     fontSize: 16,
            //           //     height: 1.5,
            //           //     fontWeight: FontWeight.bold),
            //           // ),
            //         );
            //       case 'image':
            //         return Container(
            //           width: MediaQuery.sizeOf(context).width,
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               const Text(
            //                 'Image-based question:',
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //               ),
            //               const SizedBox(height: 8),
            //               // Placeholder image
            //               Center(
            //                 child: Image.network(
            //                   'https://via.placeholder.com/400x200?text=Sample+Image+Question',
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       case 'video':
            //         return Container(
            //           width: MediaQuery.sizeOf(context).width,
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: const [
            //               Text(
            //                 'Video-based question:',
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //               ),
            //               SizedBox(height: 8),
            //               // For real usage, consider a video player plugin (e.g., `video_player`)
            //               Text(
            //                 '[Video player placeholder]\n'
            //                 'In an actual app, embed a VideoPlayer widget here.',
            //                 style: TextStyle(fontSize: 14),
            //               ),
            //             ],
            //           ),
            //         );
            //       case 'audio':
            //         return Container(
            //           width: MediaQuery.sizeOf(context).width,
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: const [
            //               Text(
            //                 'Audio-based question:',
            //                 style: TextStyle(fontWeight: FontWeight.bold),
            //               ),
            //               SizedBox(height: 8),
            //               Text(
            //                 '[Audio player placeholder]\n'
            //                 'In an actual app, embed an Audio widget or plugin here.',
            //                 style: TextStyle(fontSize: 14),
            //               ),
            //             ],
            //           ),
            //         );
            //       case 'none':
            //         return const Center(
            //           child: Text(
            //             'No question data is available for this item.',
            //             style: TextStyle(
            //               fontStyle: FontStyle.italic,
            //               color: Colors.grey,
            //             ),
            //           ),
            //         );
            //       default:
            //         return const Text('Unknown question type');
            //     }
            //   })

            : SizedBox(),
      ),
    );
  }

  int _hoveredIndex = -1;
  Widget _buildOptionsList() {
    // final options = [
    //   'A) Option 1',
    //   'B) Option 2',
    //   'C) Option 3',
    //   'D) Option 4'
    // ];

    return Obx(
      () => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            mcqData[qindex.value].options.length,
            (index) {
              String optionId = mcqData[qindex.value].options[index].optionId;
              String questionId = mcqData[qindex.value].questionId;

              // Get the correct answers for the current question
              List<int> correctAnswersForQuestion = answer
                  .firstWhere((map) => map.containsKey(int.parse(questionId)))[
                      int.parse(questionId)]!
                  .toList();

              // Check if the option is selected
              bool isSelected = userAns.containsKey(int.parse(questionId)) &&
                  userAns[int.parse(questionId)]!.contains(int.parse(optionId));

              // Check if the option is correct
              bool isCorrect =
                  correctAnswersForQuestion.contains(int.parse(optionId));

              // Determine the color of the tile
              Color tileColor;
              if (isSelected) {
                tileColor = isCorrect ? Colors.green : Colors.red;
              } else if (userAns.containsKey(int.parse(questionId)) &&
                  userAns[int.parse(questionId)]!.length >=
                      correctAnswersForQuestion.length) {
                // Reveal correct answers in green after max selections
                tileColor = isCorrect ? Colors.green : Colors.white;
              } else {
                tileColor = Colors.white;
              }

              // Determine if selection should be disabled
              bool isSelectionDisabled =
                  userAns.containsKey(int.parse(questionId)) &&
                      ((mcqData[qindex.value].isMultiple == 'true' &&
                              userAns[int.parse(questionId)]!.length >=
                                  correctAnswersForQuestion.length) ||
                          mcqData[qindex.value].isMultiple == 'false');

              return MouseRegion(
                // When mouse enters the Container
                onEnter: (_) => setState(() => _hoveredIndex = index),
                // When mouse exits the Container
                onExit: (_) => setState(() => _hoveredIndex = -1),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      // Skip if selection is disabled
                      if (isSelectionDisabled) return;

                      if (mcqData[qindex.value].isMultiple == 'true') {
                        // Multi-select option with limit check
                        if (userAns.containsKey(int.parse(questionId))) {
                          if (userAns[int.parse(questionId)]!
                              .contains(int.parse(optionId))) {
                            // Prevent unselecting a chosen option
                            return;
                          } else {
                            userAns[int.parse(questionId)]!
                                .add(int.parse(optionId));
                          }
                        } else {
                          userAns[int.parse(questionId)] = [
                            int.parse(optionId)
                          ];
                        }

                        // Check if maximum selections have been made for multi-select
                        if (userAns[int.parse(questionId)]!.length ==
                            correctAnswersForQuestion.length) {
                          // Automatically reveal answers if max selection is reached
                          setState(() {
                            // Set `isSelectionDisabled` to true to prevent further changes
                            isSelectionDisabled = true;
                          });
                        }
                      } else {
                        // Single selection, replace existing answer
                        userAns[int.parse(questionId)] = [int.parse(optionId)];
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(15),
                    // Animate over 200ms for a smooth hover effect
                    // duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color:
                          _hoveredIndex == index ? Colors.grey[100] : tileColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        // Slightly more intense shadow if hovered
                        if (_hoveredIndex == index)
                          const BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        else
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                      ],
                    ),
                    child: Text(
                      mcqData[qindex.value].options[index].optionText,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  /// BuilmcqData[qindex.value].options.lengthd right panel (Question navigator)
  Widget _buildRightPanel() {
    print(sectionWiseQuestionIdList.length.toString() +
        '/////////////////////////////////////////////////');
    return Obx(
      () => Container(
        height: MediaQuery.sizeOf(context).height,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 1),
            )
          ],
        ),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'All Questions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('Section 1'),
            const SizedBox(height: 10),
            // 3x grid of question circles (like the HTML)
            ExpansionTile(
              initiallyExpanded: true,
              onExpansionChanged: (Value) {
                buttonshow.value = Value;
              },
              shape: Border.all(color: Colors.transparent),
              backgroundColor: ColorPage.white,
              collapsedBackgroundColor: ColorPage.white,
              title: Text("All Questions"),
              children: [
                Container(
                    height: 55 * ((widget.mcqlist.length ~/ 4) + 1) +
                        sectionWiseQuestionIdList.length * 110,
                    child: ListView.builder(
                        itemCount: sectionWiseQuestionIdList.length,
                        itemBuilder: (context, index) {
                          // print(sectionWiseQuestionIdList.length);
                          // String rawdata=jsonEncode(sectionWiseQuestionIdList[index]);
                          Map<int, List<int>> data =
                              sectionWiseQuestionIdList[index];
                          List<int> indexList = data.values.first;
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(fetchSectionName(data.keys
                                        .toString()
                                        .replaceAll("(", "")
                                        .replaceAll(")", ""))),
                                  ),
                                ],
                              ),
                              Container(
                                height: 80 * ((indexList.length ~/ 4) + 1),
                                child: GridView.builder(
                                    itemCount: indexList.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4),
                                    itemBuilder: (context, ind) {
                                      // Get section ID and cumulative offset
                                      int sectionId = data.keys.first;
                                      int offset = sectionOffsets[sectionId]!;
                                      print(answer);
                                      print(userAns[indexList[ind]]);

                                      return SingleChildScrollView(
                                        child: MaterialButton(
                                          height: 55,
                                          color: reviewlist
                                                  .contains(offset + ind)
                                              ? Colors.amber
                                              : userAns.containsKey(
                                                      indexList[ind])
                                                  ? answer.any((map) => map
                                                          .values
                                                          .any((List<int> list) =>
                                                              list.any((item) =>
                                                                  userAns[indexList[ind]]!
                                                                      .contains(
                                                                          item))))
                                                      ? Colors.green
                                                      : Colors.red
                                                  : qindex.value == offset + ind
                                                      ? Color.fromARGB(
                                                          255, 13, 32, 79)
                                                      : Colors.white,
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  width: qindex.value ==
                                                          offset + ind
                                                      ? 4
                                                      : 1,
                                                  color: qindex.value ==
                                                          offset + ind
                                                      ? ColorPage.white
                                                      : Colors.black12)),
                                          onPressed: () {
                                            qindex.value = offset + ind;
                                          },
                                          child: Text(
                                            (ind + 1).toString(),
                                            style: TextStyle(
                                                color:
                                                    qindex.value == offset + ind
                                                        ? Colors.white
                                                        : Colors.black),
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

            // Wrap(
            //   spacing: 10,
            //   runSpacing: 10,
            //   children:
            //       List.generate(sectionWiseQuestionIdList.length, (index) {
            //     Map<int, List<int>> data = sectionWiseQuestionIdList[index];
            //     List<int> indexList = data.values.first;
            //     return _buildQuestionCircle('${index + 1}', status: 'active');
            //   }),
            // children: [
            //   _buildQuestionCircle('1', status: 'active'),
            //   _buildQuestionCircle('2', status: 'review'),
            //   _buildQuestionCircle('3', status: 'answered'),
            //   _buildQuestionCircle('4'),
            //   _buildQuestionCircle('5', status: 'active'),
            //   _buildQuestionCircle('6'),
            // ],
          ]),
        ),
      ),
    );
  }

  /// Build a single question circle widget with status
  Widget _buildQuestionCircle(String text, {String status = ''}) {
    // Map status to color
    Color bgColor;
    Color fgColor = Colors.white;

    switch (status) {
      case 'active':
        bgColor = const Color(0xFF3f51b5);
        break;
      case 'answered':
        bgColor = const Color(0xFF66BB6A); // green
        break;
      case 'review':
        bgColor = const Color(0xFFFFA726); // orange
        break;
      default:
        bgColor = const Color(0xFFF5F5F5); // default grey
        fgColor = Colors.black87;
    }

    return InkWell(
      onTap: () {
        // In a real app, you'd jump to that question
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: fgColor,
          ),
        ),
      ),
    );
  }

  double calculatePercentage(
      Map<int, List<int>> userAns, List<dynamic> answer) {
    try {
      int correctAnswers = 0; // To count the number of correct answers
      int totalAnsweredQuestions =
          0; // To count how many questions have been attempted
      int totalQuestions = answer.length; // Total questions in the quiz
      double totalScore = 0.0; // To calculate the total score percentage

      userAns.forEach((questionId, selectedOptionIds) {
        // Get the list of correct answers for the current question
        List<int> correctAnswersForQuestion = answer
            .firstWhere((map) => map.containsKey(questionId))[questionId]!
            .toList();

        // Skip if the question was not attempted (i.e., no options selected)
        if (selectedOptionIds.isEmpty) {
          return;
        }

        // Calculate how many correct answers were selected by the user
        int correctSelected = 0;
        selectedOptionIds.forEach((selectedOptionId) {
          if (correctAnswersForQuestion.contains(selectedOptionId)) {
            correctSelected++; // Count the correct selected answers
          }
        });

        // Partial score for this question: correctSelected / total possible correct answers
        double questionScore =
            (correctSelected / correctAnswersForQuestion.length) * 100;

        // Add to the total score
        totalScore += questionScore;

        // Increment the number of answered questions
        totalAnsweredQuestions++;

        // Increment correct answers if all selected options were correct
        if (correctSelected == correctAnswersForQuestion.length) {
          correctAnswers++;
        }
      });

      // If no questions were answered, return 0% to prevent division by zero
      if (totalAnsweredQuestions == 0) {
        return 0.0;
      }

      // Calculate the percentage based on total score of attempted questions
      double percentage = totalScore / totalAnsweredQuestions;

      // Adjust the total percentage to the total number of questions (normalize)
      double finalPercentage =
          (percentage * totalAnsweredQuestions) / totalQuestions;

      print("Total Answered Questions: $totalAnsweredQuestions");
      print("Correct Answers: $correctAnswers");
      print("Final Percentage: $finalPercentage%");

      return finalPercentage;
    } catch (e) {
      writeToFile(e, "calculatePercentage");
      print("Error calculating percentage: $e");
      return 0.0;
    }
  }

  /// Build bottom buttons row
  Widget _buildBottomButtons() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // PREVIOUS - OutlinedButton
            OutlinedButton(
              onPressed: () {
                if (qindex.value > 0) {
                  qindex.value--;
                }
                // TODO: Handle "Previous"
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue, // Text color
                side: const BorderSide(color: Colors.blue, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Previous'),
            ),

            const SizedBox(width: 12),

            // MARK FOR REVIEW - ElevatedButton (Orange)
            // ElevatedButton(
            //   onPressed: () {
            //     // TODO: Handle "Mark for Review"
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.orange,
            //     foregroundColor: Colors.white, // Text color
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            //     textStyle: const TextStyle(
            //       fontSize: 15,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            //   child: const Text('Mark for Review'),
            // ),

            // const SizedBox(width: 12),

            // SAVE & NEXT - ElevatedButton (Blue)
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  if (qindex.value < mcqData.length - 1) {
                    qindex.value++;
                  } else if (qindex.value == mcqData.length - 1) {
                    onExitexmPage(context, () {
                      Navigator.pop(context);
                      updateTblMCQhistory(
                              widget.paperId,
                              lastattemp != "" ? lastattemp : widget.attempt,
                              calculatePercentage(userAns, answer).toString(),
                              DateTime.now().toString(),
                              context)
                          .then((_) {
                        userAns.clear();
                        setState(() {
                          lastattemp = DateTime.now().toString();
                          inserTblMCQhistory(widget.paperId, 'Quick Practice',
                              widget.paperName, '', '', lastattemp, "0");
                          qindex.value = 0;
                        });
                      });
                    }, () {
                      updateTblMCQhistory(
                          widget.paperId,
                          lastattemp != "" ? lastattemp : widget.attempt,
                          calculatePercentage(userAns, answer).toString(),
                          DateTime.now().toString(),
                          context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });

                    // _onSubmitExam(context);
                  }
                  // TODO: Handle "Save & Next"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPage.colorbutton,
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(
                  qindex.value == mcqData.length - 1
                      ? 'Submit & Reset'
                      : 'Next',
                ),
              ),
            ),
          ],
        )

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     // Previous
        //     OutlinedButton(
        //       onPressed: () {
        //         // Move to previous question
        //       },
        //       style: OutlinedButton.styleFrom(
        //         minimumSize: const Size(110, 40),
        //       ),
        //       child: const Text('Previous'),
        //     ),
        //     const SizedBox(width: 10),
        //     // Mark for review (orange border)
        //     OutlinedButton(
        //       onPressed: _markForReview,
        //       style: OutlinedButton.styleFrom(
        //         minimumSize: const Size(110, 40),
        //         side: const BorderSide(color: Color(0xFFFFA726), width: 2),
        //       ),
        //       child: const Text(
        //         'Mark for Review',
        //         style: TextStyle(color: Color(0xFFFFA726)),
        //       ),
        //     ),
        //     const SizedBox(width: 10),
        //     // Save & Next
        //     ElevatedButton(
        //       onPressed: () {
        //         // Save answer & move to next question
        //       },
        //       style: ElevatedButton.styleFrom(
        //         minimumSize: const Size(110, 40),
        //       ),
        //       child: const Text('Save & Next'),
        //     ),
        //   ],
        // ),

        );
  }

  /// Example method to handle 'Mark for Review'
  void _markForReview() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Marked for Review'),
        content: const Text('This question has been marked for review.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Main build: top bar + 3-column layout + bottom bar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // If you want to remove the default AppBar, set appBar to null
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _buildTopBar(),
      ),
      body: Column(
        children: [
          // Expanded row for the 3 columns
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // If width is wide enough, show 3 columns in a Row
                  // Otherwise, show them in a Column (responsive).
                  bool isNarrow = constraints.maxWidth < 900;
                  if (isNarrow) {
                    // Single column layout
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left panel
                          _buildLeftPanel(),
                          const SizedBox(height: 20),
                          // Center
                          _buildCenterContent(),
                          const SizedBox(height: 20),
                          // Right panel
                          _buildRightPanel(),
                        ],
                      ),
                    );
                  } else {
                    // 3 columns in a row
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Panel (fixed width or flexible)
                        SizedBox(
                          width: 250,
                          child: _buildLeftPanel(),
                        ),
                        const SizedBox(width: 20),
                        // Center (expand to fill)
                        Expanded(
                          child: _buildCenterContent(),
                        ),
                        const SizedBox(width: 20),
                        // Right Panel (fixed width or flexible)
                        SizedBox(
                          width: 250,
                          child: _buildRightPanel(),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          // Bottom buttons
          _buildBottomButtons(),
        ],
      ),
      // backgroundColor: const Color(0xFFF0F0F0),
    );
  }
}
