import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/PC/MCQ/modelclass.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Examresult extends StatefulWidget {
 

  @override
  State<Examresult> createState() => _ExamresultState();
}

class _ExamresultState extends State<Examresult> with SingleTickerProviderStateMixin {
  bool _isLottieVisible = true;
  late AnimationController _animationController;
    Getx getxController = Get.put(Getx());
  final List<McqItem> mcqData= Get.arguments['mcqData'];
   final Map<int, int> userAns = Get.arguments['userAns'];
  final List<Map<int, int>> correctAnswers = Get.arguments['correctAnswers'];

  List<Map<String, dynamic>> dummyData = [
    {
      'rank': 1,
      'image': 'https://picsum.photos/500/500',
      'level': 9.5,
      'project': 3.8,
      'name': 'Alice'
    },
    {
      'rank': 2,
      'image': 'https://picsum.photos/500/500',
      'level': 8.7,
      'project': 4.2,
      'name': 'Bob'
    },
    {
      'rank': 3,
      'image': 'https://picsum.photos/500/500',
      'level': 7.8,
      'project': 3.5,
      'name': 'Charlie'
    },
    {
      'rank': 4,
      'image': 'https://picsum.photos/500/500',
      'level': 8.3,
      'project': 3.9,
      'name': 'David'
    },
    {
      'rank': 5,
      'image': 'https://picsum.photos/500/500',
      'level': 9.1,
      'project': 4.0,
      'name': 'Eve'
    },
    {
      'rank': 6,
      'image': 'https://picsum.photos/500/500',
      'level': 7.5,
      'project': 3.7,
      'name': 'Frank'
    },
    {
      'rank': 7,
      'image': 'https://picsum.photos/500/500',
      'level': 8.0,
      'project': 3.6,
      'name': 'Grace'
    },
    {
      'rank': 8,
      'image': 'https://picsum.photos/500/500',
      'level': 7.9,
      'project': 4.1,
      'name': 'Hank'
    },
    {
      'rank': 9,
      'image': 'https://picsum.photos/500/500',
      'level': 8.6,
      'project': 3.4,
      'name': 'Ivy'
    },
    {
      'rank': 10,
      'image': 'https://picsum.photos/500/500',
      'level': 9.0,
      'project': 3.8,
      'name': 'Jack'
    }
  ];

  var rankStyle = TextStyle(fontSize: 16);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Adjust this duration to match your Lottie animation
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isLottieVisible = false;
          });
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalMarks = 0;

    List<Widget> questionWidgets = mcqData.asMap().entries.map((entry) {
      int index = entry.key;
      McqItem mcqItem = entry.value;
      int questionId = int.parse(mcqItem.questionId);
      String question = mcqItem.questionText;
      String userSelected = userAns.containsKey(questionId)
          ? mcqItem.options
              .firstWhere((option) => option.optionId == userAns[questionId])
              .optionText
          : 'Not Answered';
      String correctAnswer = mcqItem.options
          .firstWhere((option) => correctAnswers
              .any((map) => map[questionId] == option.optionId))
          .optionText;
      int marks = userAns.containsKey(questionId) &&
              correctAnswers
                  .any((map) => map[questionId] ==userAns[questionId])
          ? 1
          : 0;
      totalMarks += marks;

      return Container(
        margin: EdgeInsets.only(top: 10),
        // decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255), borderRadius: BorderRadius.all(Radius.circular(10),),boxShadow: [
        //   BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 2),
        // ]),
        child: ListTile(
          title: Text(
            '${index + 1}. $question',
            style: FontFamily.font4.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Answer: $userSelected'),
              Text('Correct Answer: $correctAnswer'),
            ],
          ),
          trailing: Text(
           "Obtain Marks: "+ marks.toString(),
            style: FontFamily.font3.copyWith(color: Colors.black),
          ),
        ),
      );
    }).toList();

   
   
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        // surfaceTintColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width / 4),
            child: Text("QNA", style: FontFamily.font7),
          )
        ],
        iconTheme: IconThemeData(color: ColorPage.white),
        backgroundColor: ColorPage.appbarcolor,
        title: Text(
          "Leaderboard",
          style: FontFamily.font3,
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: ColorPage.appbarcolorcopy),
                        width: MediaQuery.of(context).size.width / 2,
                        height: 200,
                        padding: EdgeInsets.symmetric(horizontal: 130, vertical: 10),
                        child: Container(
                          color: const Color.fromARGB(0, 209, 29, 29),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                top: 40,
                                left: 20,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white,
                                        Colors.white,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'assets/sorojda.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                top: 90,
                                child: SizedBox(
                                  height: 80,
                                  child: Image.asset('assets/rank2.png'),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.amber.shade300,
                                      Colors.amber.shade800,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Image.asset(
                                    'assets/sorojda.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 50,
                                child: SizedBox(
                                  height: 80,
                                  child: Image.asset('assets/rank1.png'),
                                ),
                              ),
                              Positioned(
                                right: 20,
                                top: 40,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white,
                                        Colors.white,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset(
                                      'assets/sorojda.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 20,
                                top: 90,
                                child: SizedBox(
                                  height: 80,
                                  child: Image.asset('assets/rank3.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text('Rank'),
                              ],
                            ),
                            Text('Name'),
                            Row(
                              children: [
                                Text('Score'),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: dummyData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              surfaceTintColor: Colors.blue,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: index == 0
                                    ? SizedBox(
                                        height: 35,
                                        child: Image.asset('assets/rank1.png'))
                                    : index == 1
                                        ? SizedBox(
                                            height: 35,
                                            child:
                                                Image.asset('assets/rank2.png'))
                                        : index == 2
                                            ? SizedBox(
                                                height: 35,
                                                child: Image.asset(
                                                    'assets/rank3.png'))
                                            : Text(
                                                '#${dummyData[index]['rank']}',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                title: Center(
                                  child: Text(
                                    '${dummyData[index]['name']}',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                trailing: Text(
                                  '${dummyData[index]['project']}',
                                  style: TextStyle(
                                    color: Colors.red[400],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    left: 5,
                    right: 5,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: ColorPage.appbarcolorcopy,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                '50',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Text(
                                'Student Name',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                totalMarks.toString(),
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isLottieVisible,
                    child: Positioned(
                      left: 5,
                      right: 5,
                      child: Container(
                        height: 600,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: LottieBuilder.asset(
                            'assets/C2.json',
                            repeat: false,
                            controller: _animationController,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        
        
        
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                border: Border(
                  left: BorderSide(color: ColorPage.appbarcolor, width: 3),
                ),
              ),
              child: Container(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: questionWidgets,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}