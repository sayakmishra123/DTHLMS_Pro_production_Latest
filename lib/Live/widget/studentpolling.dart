import 'dart:developer';

// import 'package:abc/getx.dart';
// import 'package:abc/widget/models/topic.dart';
import 'package:dthlms/Live/mobilegetx.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/topic.dart';

// import '../vc_screen.dart';

class StudentPollPage extends StatefulWidget {
  final String teacherName;
  String sessionId;
  StudentPollPage({required this.teacherName, required this.sessionId});

  @override
  _StudentPollPageState createState() => _StudentPollPageState();
}

class _StudentPollPageState extends State<StudentPollPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _pollQuestionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  String? _selectedPollId;
  String _pollQuestion = "";
  bool hasVoted = false;

  @override
  void dispose() {
    _pollQuestionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addOptionField() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void removeOptionField(int index) {
    setState(() {
      _optionControllers.removeAt(index);
    });
  }

  // Future<void> createPoll() async {
  //   final pollQuestion = _pollQuestionController.text.trim();
  //   if (pollQuestion.isEmpty || _optionControllers.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text('Please enter a question and at least one option')),
  //     );
  //     return;
  //   }

  //   final options = _optionControllers
  //       .map((controller) => controller.text.trim())
  //       .where((text) => text.isNotEmpty)
  //       .toList();

  //   if (options.length < 2) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please enter at least two options')),
  //     );
  //     return;
  //   }

  //   final pollId = _firestore.collection('polls').doc().id;

  //   final optionsMap = Map.fromIterable(
  //     options,
  //     key: (option) => option,
  //     value: (_) => 0,
  //   );

  //   await _firestore.collection('polls').doc(pollId).set({
  //     'question': pollQuestion,
  //     'votes': optionsMap,
  //     'createdBy': widget.teacherName,
  //     'pollId': pollId,
  //     'sessionId': widget.sessionId, // Store the session ID here
  //   });

  //   setState(() {
  //     _selectedPollId = pollId;
  //     _pollQuestion = pollQuestion;
  //     _pollQuestionController.clear();
  //     _optionControllers.clear();
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Poll Created and added to the list')),
  //   );
  // }

  Future<void> checkIfTeacherVoted() async {
    if (_selectedPollId != null) {
      final pollDoc =
          await _firestore.collection('polls').doc(_selectedPollId).get();
      final voters = pollDoc.data()?['voters'] as Map<String, dynamic>?;

      if (voters != null) {
        setState(() {
          hasVoted = voters.values.any(
            (voterList) => (voterList as List).contains(widget.teacherName),
          );
        });
      }
    }
  }

  double _calculatePercentage(int votes, int totalVotes) {
    if (totalVotes == 0) return 0.0;
    return (votes / totalVotes);
  }

  Color deviderColors = const Color.fromARGB(255, 90, 90, 92);
  Color scaffoldColor = const Color(0xff1B1A1D);
  Color topTextColor = const Color(0xffDFDEDF);
  Color topTextClockColor = const Color(0xffB3B6B5);
  Color timerBoxColor = const Color(0xff2B2D2E);
  Color searchBoxColor = const Color(0xff27292D);
  Color searchBoxTextColor = const Color(0xff747677);
  Color bottomBoxColor = const Color(0xff27292B);
  Color micOffColor = const Color(0xffD95140);

  // Styles
  Color leftBackgroundColor = const Color(0Xff161B21);
  Color rightBackgroundColor = const Color(0Xff1F272F);
  Color greencolor = const Color(0Xff15E8D8);
  Color btnColor = const Color(0Xff2D3237);
  Color chatConColor = const Color(0XffD9D9D9);
  Color chatSelectedColor = const Color(0Xff2D3237);
  Color chatUnSelectedColor = const Color(0XffFFFFFF);
  Color chatBoxColor = const Color(0XffC9E1FF);

  var rightBorderRadious = const Radius.circular(20);
  RxInt rightBarIndex = 0.obs;
  RxBool chatMood = true.obs;
  RxBool topicChecValue = true.obs;

  TextEditingController c = TextEditingController();
  String? selectedAudioOutputDevice;
  String? selectedVideoOutputDevice;
  TextStyle rightBarTopTextStyle = const TextStyle(
      fontFamily: 'ocenwide', color: Colors.white, fontSize: 16);

  final offButtonTheme = IconButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  );
  AnimationStyle? _animationStyle;
  RxBool pollOption = false.obs;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Expanded(
                child: SizedBox(
                    child: Poll(widget.sessionId, widget.teacherName))),
            Expanded(child: SizedBox(child: Topic(widget.sessionId)))

            // CustomExpansionTile(
            //   title: 'Poll',
            //   initiallyExpanded: true, // Set to true to start expanded
            //   child: Container(
            //     height: MediaQuery.of(context).size.height - 300,
            //     child: TeacherPollPage(
            //       teacherName: 'Sayak Mishra',
            //       sessionId: widget.sessionId.toString(),
            //     ),
            //   ),
            // ),
            // CustomExpansionTile(
            //   title: 'Topic',
            //   initiallyExpanded: false, // Set to true to start expanded
            //   child: SizedBox(
            //     height: MediaQuery.of(context).size.height - 300,
            //     child: TopicListPage(
            //       sessionId: widget.sessionId.toString(),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );

    Visibility(
      visible: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 44, 44, 44),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Create Poll',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _pollQuestionController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Poll Question',
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(
                            5,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: _optionControllers
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: entry.value,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          removeOptionField(entry.key),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'Option ${entry.key + 1}',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: MaterialButton(
                          padding: EdgeInsets.all(15),
                          color: const Color.fromARGB(255, 6, 124, 221),
                          onPressed: () {
                            addOptionField();
                          },
                          child: Text(
                            'Add Option',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: MaterialButton(
                          padding: EdgeInsets.all(15),
                          color: const Color.fromARGB(255, 6, 124, 221),
                          onPressed: () {
                            // createPoll();
                          },
                          child: Text(
                            'Create Poll',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('polls')
                      .where('sessionId',
                          isEqualTo: widget.sessionId) // Filter by session ID
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final polls = snapshot.data!.docs;

                    if (polls.isEmpty) {
                      return Center(child: Text('No polls available.'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: polls.length,
                      itemBuilder: (context, index) {
                        final poll = polls[index];
                        final pollId = poll['pollId'];
                        final pollQuestion = poll['question'] ?? 'No Question';
                        final pollOptions =
                            (poll['votes'] as Map<String, dynamic>)
                                .entries
                                .map((entry) {
                          return PollOption(
                            id: entry.key,
                            title: entry.key,
                            votes: entry.value as int,
                          );
                        }).toList();

                        return ListTile(
                          title: Text(
                            pollQuestion,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Created by: ${poll['createdBy'] ?? 'Unknown'}',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () async {
                            if (pollOptions.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'This poll has no options available.')),
                              );
                              return;
                            }
                            setState(() {
                              _selectedPollId = pollId;
                              _pollQuestion = pollQuestion;
                            });
                            await checkIfTeacherVoted();
                          },
                          selected: pollId == _selectedPollId,
                          trailing: Icon(
                            Icons.poll,
                            color: Colors.blue,
                          ),
                        );
                      },
                    );
                  },
                ),
                if (_selectedPollId != null) ...[
                  StreamBuilder<DocumentSnapshot>(
                    stream: _firestore
                        .collection('polls')
                        .doc(_selectedPollId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final pollData =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      if (pollData == null || !pollData.containsKey('votes')) {
                        return Center(
                            child: Text('Poll data is missing or incomplete.'));
                      }

                      final votes = pollData['votes'] as Map<String, dynamic>;
                      final totalVotes = votes.values.fold<int>(0,
                          (a, b) => a + (b as int)); // Sum up the total votes
                      final pollOptions = votes.entries.map((entry) {
                        final percentage = _calculatePercentage(
                            entry.value as int, totalVotes);
                        return PollOption(
                          id: entry.key,
                          title: entry.key,
                          votes: entry.value as int,
                          percentage: percentage,
                        );
                      }).toList();

                      if (pollOptions.isEmpty) {
                        return Center(
                            child: Text('No poll options available.'));
                      }

                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          surfaceTintColor: Colors.white,
                          elevation: 8,
                          color: Colors.white,
                          shadowColor: const Color.fromARGB(255, 139, 198, 247),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: pollOptions.length,
                            itemBuilder: (context, index) {
                              final option = pollOptions[index];
                              return ListTile(
                                title: Text(option.title),
                                subtitle: Column(
                                  children: [
                                    LinearProgressIndicator(
                                      value: option.percentage,
                                      backgroundColor: Colors.grey[300],
                                      color: Colors.blue,
                                      minHeight: 8,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ],
                                ),
                                trailing: Text('${option.votes} votes'),
                                onTap: () {
                                  // _voteForOption(option.id);
                                },
                                selected: hasVoted,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
GetxLive getx = Get.put(GetxLive());
class Poll extends StatefulWidget {
  String sessionId;
  String teacherName;
  Poll(this.sessionId, this.teacherName, {super.key});

  @override
  State<Poll> createState() => _PollState();
}

class _PollState extends State<Poll> {
  Color deviderColors = const Color.fromARGB(255, 90, 90, 92);

  Color scaffoldColor = const Color(0xff1B1A1D);

  Color topTextColor = const Color(0xffDFDEDF);

  Color topTextClockColor = const Color(0xffB3B6B5);

  Color timerBoxColor = const Color(0xff2B2D2E);

  Color searchBoxColor = const Color(0xff27292D);

  Color searchBoxTextColor = const Color(0xff747677);

  Color bottomBoxColor = const Color(0xff27292B);

  Color micOffColor = const Color(0xffD95140);

  // Styles
  Color leftBackgroundColor = const Color(0Xff161B21);

  Color rightBackgroundColor = const Color(0Xff1F272F);

  Color greencolor = const Color(0Xff15E8D8);

  Color btnColor = const Color(0Xff2D3237);

  Color chatConColor = const Color(0XffD9D9D9);

  Color chatSelectedColor = const Color(0Xff2D3237);

  Color chatUnSelectedColor = const Color(0XffFFFFFF);

  Color chatBoxColor = const Color(0XffC9E1FF);

  var rightBorderRadious = const Radius.circular(20);

  RxInt rightBarIndex = 0.obs;

  RxBool chatMood = true.obs;

  RxBool topicChecValue = true.obs;

  TextEditingController c = TextEditingController();

  String? selectedAudioOutputDevice;

  String? selectedVideoOutputDevice;

  TextStyle rightBarTopTextStyle = const TextStyle(
      fontFamily: 'ocenwide', color: Colors.white, fontSize: 16);

  // final offButtonTheme = IconButton.styleFrom(
  AnimationStyle? _animationStyle;

  RxBool pollOption = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _pollQuestionController = TextEditingController();

  final List<TextEditingController> _optionControllers = [];

  String? _selectedPollId;

  String _pollQuestion = "";

  bool hasVoted = false;

  void _voteForOption(String selectedOptionId) async {
    if (_selectedPollId == null) return;

    final pollDoc =
        await _firestore.collection('polls').doc(_selectedPollId).get();
    final pollData = pollDoc.data() as Map<String, dynamic>;
    final voters = pollData['voters'] as Map<String, dynamic>? ?? {};

    // Check if the teacher has already voted for this option
    final hasAlreadyVotedForThisOption =
        (voters[selectedOptionId] as List?)?.contains(widget.teacherName) ??
            false;

    if (hasAlreadyVotedForThisOption) {
      // If the teacher has already voted for this option, remove the vote
      await _firestore.collection('polls').doc(_selectedPollId).update({
        'votes.$selectedOptionId': FieldValue.increment(-1),
        'voters.$selectedOptionId':
            FieldValue.arrayRemove([widget.teacherName]),
      });

      setState(() {
        hasVoted = false;
      });
    } else {
      // Remove vote from any other option if the teacher has voted elsewhere
      String? previousOptionId;
      voters.forEach((optionId, voterList) {
        if ((voterList as List).contains(widget.teacherName)) {
          previousOptionId = optionId;
        }
      });

      if (previousOptionId != null && previousOptionId != selectedOptionId) {
        await _firestore.collection('polls').doc(_selectedPollId).update({
          'votes.$previousOptionId': FieldValue.increment(-1),
          'voters.$previousOptionId':
              FieldValue.arrayRemove([widget.teacherName]),
        });
      }

      // Add the new vote for the selected option
      await _firestore.collection('polls').doc(_selectedPollId).update({
        'votes.$selectedOptionId': FieldValue.increment(1),
        'voters.$selectedOptionId': FieldValue.arrayUnion([widget.teacherName]),
      });

      setState(() {
        hasVoted = true;
      });
    }
  }

  Future<void> checkIfTeacherVoted() async {
    if (_selectedPollId != null) {
      final pollDoc =
          await _firestore.collection('polls').doc(_selectedPollId).get();
      final voters = pollDoc.data()?['voters'] as Map<String, dynamic>?;

      if (voters != null) {
        setState(() {
          hasVoted = voters.values.any(
            (voterList) => (voterList as List).contains(widget.teacherName),
          );
        });
      }
    }
  }

  double _calculatePercentage(int votes, int totalVotes) {
    if (totalVotes == 0) return 0.0;
    return (votes / totalVotes);
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // checkIfTeacherVoted();
    });
    super.initState();
  }
  int _currentPollIndex = 0;
  late bool _isChecked = false;
  void _onCheckChanged(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
    // Update the 'show' field in Firestore
    _firestore.collection('polls').doc(_selectedPollId).update({
      'show': _isChecked,
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_left,
                color: _currentPollIndex > 0 ? Colors.white : Colors.grey,
              ),
              onPressed: _currentPollIndex > 0 ? _previousPoll : null,
            ),
            Text(
              'Poll',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_right,
                color: _currentPollIndex < polls.length - 1
                    ? Colors.white
                    : Colors.grey,
              ),
              onPressed:
              _currentPollIndex < polls.length - 1 ? _nextPoll : null,
            ),
          ],
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('polls')
              .where('sessionId',
                  isEqualTo: widget.sessionId) // Filter by session ID
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final polls = snapshot.data!.docs;

            if (polls.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback(
                    (timeStamp) {
                  getx.pollhas.value = true;
                },
              );

              return SizedBox();
            }
            // Ensure the current index is within bounds
            if (_currentPollIndex >= polls.length) {
              _currentPollIndex = polls.length - 1;
            }

            if (_currentPollIndex < 0) {
              _currentPollIndex = 0;
            }
            final poll = polls[_currentPollIndex];
            final pollId = poll['pollId'];
            final pollQuestion = poll['question'] ?? 'No Question';
            final votes = poll['votes'] as Map<String, dynamic>;
            final show = poll['show'] ?? false;
            // setState(() {
            _selectedPollId = pollId;
            _pollQuestion = pollQuestion;
            _isChecked = show;
            checkIfTeacherVoted();
            final totalVotes =
            votes.values.fold<int>(0, (a, b) => a + (b as int));

            final pollOptions = votes.entries.map((entry) {
              final percentage =
              _calculatePercentage(entry.value as int, totalVotes);
              return PollOption(
                id: entry.key,
                title: entry.key,
                votes: entry.value as int,
                percentage: percentage,
              );
            }).toList();
            if (show == true)
              return _buildPollContent(pollId, pollQuestion, pollOptions);
            else
              return SizedBox();
            return Visibility(
              // visible: false,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:1,
                itemBuilder: (context, index) {
                  final poll = polls[index];
                  final pollId = poll['pollId'];
                  final pollQuestion = poll['question'] ?? 'No Question';
                  final pollOptions = (poll['votes'] as Map<String, dynamic>)
                      .entries
                      .map((entry) {
                    return PollOption(
                      id: entry.key,
                      title: entry.key,
                      votes: entry.value as int,
                    );
                  }).toList();

                  return ListTile(
                    title: Text(
                      pollQuestion,
                      style: TextStyle(color: Colors.white),
                    ),
                    // subtitle: Text(
                    //   'Created by: ${poll['createdBy'] ?? 'Unknown'}',
                    //   style: TextStyle(color: Colors.white),
                    // ),
                    onTap: () async {
                      if (pollOptions.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('This poll has no options available.')),
                        );
                        return;
                      }
                      setState(() {
                        _selectedPollId = pollId;
                        _pollQuestion = pollQuestion;
                      });
                      print(_selectedPollId.toString());
                      await checkIfTeacherVoted();
                    },
                    selected: pollId == _selectedPollId,
                    trailing: Icon(
                      Icons.poll,
                      color: Colors.blue,
                    ),
                  );
                },
              ),
            );
          },
        ),
        // if (_selectedPollId != null) ...[
        //   Expanded(
        //     child: SizedBox(
        //       // height: 100,
        //       child: StreamBuilder<DocumentSnapshot>(
        //           stream: _firestore
        //               .collection('polls')
        //               .doc(_selectedPollId)
        //               .snapshots(),
        //           builder: (context, snapshot) {
        //             if (!snapshot.hasData) {
        //               return Center(child: CircularProgressIndicator());
        //             }
        //
        //             final pollData =
        //                 snapshot.data!.data() as Map<String, dynamic>?;
        //             final pollQuestion = pollData?['question'] ?? 'No Question';
        //             // log(pollData!.entries.toString());
        //             if (pollData == null || !pollData.containsKey('votes')) {
        //               return Center(
        //                   child: Text('Poll data is missing or incomplete.'));
        //             }
        //
        //             final votes = pollData['votes'] as Map<String, dynamic>;
        //
        //             final totalVotes = votes.values.fold<int>(
        //                 0, (a, b) => a + (b as int)); // Sum up the total votes
        //             final pollOptions = votes.entries.map((entry) {
        //               final percentage =
        //                   _calculatePercentage(entry.value as int, totalVotes);
        //               return PollOption(
        //                 id: entry.key,
        //                 title: entry.key,
        //                 votes: entry.value as int,
        //                 percentage: percentage,
        //               );
        //             }).toList();
        //
        //             if (pollOptions.isEmpty) {
        //               return Center(child: Text('No poll options available.'));
        //             }
        //
        //             return Column(
        //               children: [
        //                 Row(
        //                   children: [
        //                     Expanded(
        //                       child: Text(
        //                         pollQuestion,
        //                         style: rightBarTopTextStyle.copyWith(
        //                             color: greencolor, fontSize: 18),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 Expanded(
        //                   child: ListView.builder(
        //                     shrinkWrap: true,
        //                     // itemCount:
        //                     itemCount: pollOptions
        //                         .length, // Increased itemCount by 1 to include the "xy votes total" text at the end
        //                     itemBuilder: (context, index) {
        //                       final option = pollOptions[index];
        //                       // if (index < 3) {
        //                       return Stack(
        //                         alignment: Alignment.center,
        //                         children: [
        //                           SizedBox(
        //                             height: 40,
        //                             child: LinearProgressIndicator(
        //                               value: option.percentage,
        //                               backgroundColor: Colors.transparent,
        //                               borderRadius: BorderRadius.circular(10),
        //                               color: greencolor.withOpacity(0.7),
        //                             ),
        //                           ),
        //                           Container(
        //                             margin: const EdgeInsets.symmetric(
        //                                 vertical: 10),
        //                             height: 40,
        //                             decoration: ShapeDecoration(
        //                               color: const Color(0x00D9D9D9),
        //                               shape: RoundedRectangleBorder(
        //                                 side: const BorderSide(
        //                                     width: 1, color: Color(0xFF15E8D8)),
        //                                 borderRadius: BorderRadius.circular(10),
        //                               ),
        //                             ),
        //                           ),
        //                           Obx(() => InkWell(
        //                                 onTap: () {
        //                                   log(option.id);
        //                                   _voteForOption(option.id);
        //                                 },
        //                                 child: Row(
        //                                   children: [
        //                                     const SizedBox(width: 5),
        //                                     IconButton(
        //                                       onPressed: () {
        //                                         log(option.id);
        //                                         _voteForOption(option.id);
        //                                       },
        //                                       icon: Icon(
        //                                         pollOption.value
        //                                             ? Icons.check_circle
        //                                             : Icons.circle_outlined,
        //                                         color: Colors.white,
        //                                       ),
        //                                     ),
        //                                     const SizedBox(width: 5),
        //                                     SizedBox(
        //                                       width: 250,
        //                                       child: Text(
        //                                         pollOptions[index].title,
        //                                         style: rightBarTopTextStyle
        //                                             .copyWith(
        //                                                 fontSize: 14,
        //                                                 fontWeight:
        //                                                     FontWeight.w200),
        //                                       ),
        //                                     ),
        //                                     const Expanded(child: SizedBox()),
        //                                     Text(
        //                                       '${option.votes}',
        //                                       style: rightBarTopTextStyle
        //                                           .copyWith(color: greencolor),
        //                                     ),
        //                                     const SizedBox(width: 20),
        //                                   ],
        //                                 ),
        //                               )),
        //                         ],
        //                       );
        //
        //                       // } else {
        //                       //   return Padding(
        //                       //     padding: const EdgeInsets.only(top: 10.0),
        //                       //     child: Text(
        //                       //       '12 votes total',
        //                       //       style: rightBarTopTextStyle.copyWith(
        //                       //         color: Colors.grey[400],
        //                       //         fontSize: 12,
        //                       //       ),
        //                       //     ),
        //                       //   );
        //                       // }
        //                     },
        //                   ),
        //                 ),
        //               ],
        //             );
        //           }),
        //     ),
        //   )
        //
        // ]
      ],
    );
  }

  Widget _buildPollContent(
      String pollId, String pollQuestion, List<PollOption> pollOptions) {
    return Column(
      children: [
        // Display the poll question

        // Display the poll options
        Expanded(
          child: ListView.builder(
            itemCount: pollOptions.length,
            itemBuilder: (context, index) {
              final option = pollOptions[index];

              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    child: LinearProgressIndicator(
                      value: option.percentage,
                      backgroundColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      color: greencolor.withOpacity(0.7),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 40,
                    decoration: ShapeDecoration(
                      color: const Color(0x00D9D9D9),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFF15E8D8)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Obx(() => InkWell(
                    onTap: () {
                      log(option.id);
                      _voteForOption(option.id);
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () {
                            log(option.id);
                            _voteForOption(option.id);
                          },
                          icon: Icon(
                            pollOption.value
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            option.title,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          '${option.votes}',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  )),
                ],
              );
            },
          ),
        ),
      ],
    );
  }


  void _previousPoll() {
    setState(() {
      if (_currentPollIndex > 0) {
        _currentPollIndex--;
      }
    });
  }

  void _nextPoll() {
    setState(() {
      if (_currentPollIndex < polls.length - 1) {
        _currentPollIndex++;
      }
    });
  }


  List<DocumentSnapshot> polls = [];

}

class Topic extends StatelessWidget {
  String sessionId;
  Topic(this.sessionId, {super.key});

  Color deviderColors = const Color.fromARGB(255, 90, 90, 92);
  Color scaffoldColor = const Color(0xff1B1A1D);
  Color topTextColor = const Color(0xffDFDEDF);
  Color topTextClockColor = const Color(0xffB3B6B5);
  Color timerBoxColor = const Color(0xff2B2D2E);
  Color searchBoxColor = const Color(0xff27292D);
  Color searchBoxTextColor = const Color(0xff747677);
  Color bottomBoxColor = const Color(0xff27292B);
  Color micOffColor = const Color(0xffD95140);

  // Styles
  Color leftBackgroundColor = const Color(0Xff161B21);
  Color rightBackgroundColor = const Color(0Xff1F272F);
  Color greencolor = const Color(0Xff15E8D8);
  Color btnColor = const Color(0Xff2D3237);
  Color chatConColor = const Color(0XffD9D9D9);
  Color chatSelectedColor = const Color(0Xff2D3237);
  Color chatUnSelectedColor = const Color(0XffFFFFFF);
  Color chatBoxColor = const Color(0XffC9E1FF);

  var rightBorderRadious = const Radius.circular(20);
  RxInt rightBarIndex = 0.obs;
  RxBool chatMood = true.obs;
  RxBool topicChecValue = true.obs;

  TextEditingController c = TextEditingController();
  String? selectedAudioOutputDevice;
  String? selectedVideoOutputDevice;
  TextStyle rightBarTopTextStyle = const TextStyle(
      fontFamily: 'ocenwide', color: Colors.white, fontSize: 16);

  // final offButtonTheme = IconButton.styleFrom(
  //   backgroundColor: Colors.red,
  //   foregroundColor: Colors.white,
  // );
  AnimationStyle? _animationStyle;
  RxBool pollOption = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // void _navigateToCreateTopic(context) async {
  //   final newTopic = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) =>
  //           CreateTopic(sessionId: sessionId), // Pass sessionId
  //     ),
  //   );

  //   if (newTopic != null) {
  //     await _firestore.collection('topics').add(newTopic.toMap());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Topic',
                style: rightBarTopTextStyle.copyWith(
                    fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('topics')
                .where('sessionId', isEqualTo: sessionId) // Filter by sessionId
                .snapshots(),
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return const Center(child: CircularProgressIndicator());
              // }

              if (snapshot.hasError) {
                return const Center(
                    child: Expanded(child: Text('Error loading topics')));
              }

              final topics = snapshot.data?.docs
                  .map((doc) => TopicModel.fromDocument(doc))
                  .toList() ??
                  [];
              if (topics.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                    getx.topichas.value = true;
                  },
                );

                return SizedBox();
              }
              print(topics[0].show);
              return Expanded(
                child: ListView.builder(
                    itemCount: topics
                        .length, // Increased itemCount by 1 to include the "12 votes total" text at the end
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              Checkbox(
                                fillColor: const WidgetStatePropertyAll(
                                    Colors.transparent),
                                side: const BorderSide(
                                    width: 2, color: Colors.white),
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                value: topics[index].show,
                                onChanged: (value) {
                                  // topicChecValue.value = value!;
                                },
                              ),
                              const SizedBox(width: 5),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      topics[index].name,
                                      style: rightBarTopTextStyle.copyWith(
                                          decoration: topics[index].show == true
                                              ? TextDecoration.lineThrough
                                              : null,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    // Text(
                                    //   topics[index].description,
                                    //   style: rightBarTopTextStyle.copyWith(
                                    //       color: Colors.grey[400],
                                    //       fontSize: 10,
                                    //       fontWeight: FontWeight.w200),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                    }),
              );
            }),
      ],
    );
  }
}

class PollOption {
  final String id;
  final String title;
  int votes;
  double percentage;

  PollOption({
    required this.id,
    required this.title,
    this.votes = 0,
    this.percentage = 0.0,
  });
}
