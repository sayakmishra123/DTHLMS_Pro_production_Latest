import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/GLOBAL_WIDGET/loader.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/EMPTY_PAGE/emptypage.dart';
import 'package:dthlms/MOBILE/MCQ/MCQTYPE/mcqtypepage.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/Package_Video_dashboard.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/live_page.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/podCastDashboard.dart';
import 'package:dthlms/MOBILE/THEORY_EXAM/examPaperList.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../PC/PACKAGEDETAILS/packagedetails.dart';
import '../../constants/constants.dart';

class Mobile_Package_content extends StatefulWidget {
  final int packageid;
  final packagename;
  const Mobile_Package_content(
      {super.key, required this.packageid, this.packagename});

  @override
  State<Mobile_Package_content> createState() => _Mobile_Package_contentState();
}

class _Mobile_Package_contentState extends State<Mobile_Package_content> {
  Getx getx = Get.put(Getx());

  paging(String pageName) {
    switch (pageName) {
      case 'Video':
        Get.to(
          transition: Transition.cupertino,
          () => MobilePackageVideoDashboard(),
        );

        break;
      case 'Live':
        Get.to(
          transition: Transition.cupertino,
          () => LivePage(),
        );

        break;
      case 'VideosBackup':
        Get.to(
          transition: Transition.cupertino,
          () => EmptyPage(),
        );
        break;
      case 'MCQ':
        Get.to(
          transition: Transition.cupertino,
          () => MCQtypePage(),
        );
        break;
      case 'Book':
        Get.to(
          transition: Transition.cupertino,
          () => BookDashboard(),
        );
        break;
      case 'Podcast':
        Get.to(
          transition: Transition.cupertino,
          () => MobilePodCastDashBoard(),
        );
        break;

      case "Test":
        Get.to(
            transition: Transition.cupertino,
            () => TheoryExamPaperListofMobile());
        break;
      default:
        print("null");
    }
  }

  String pagename = '';

  @override
  void initState() {
    print(
        'okkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
    // setState(() {
    // infoTetch(widget.packageid.toString(), 'Video');

    // });

    // await initialfunction(
    //
    //                       getx.studentPackage[index]['packageId']);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callData();
    });

    super.initState();
  }

  callData() async {
    initialfunction(widget.packageid.toString()).whenComplete(() {
      getSectionListOfPackage(
        widget.packageid,
      );
    });
  }

  Future initialfunction(String packageid) async {
    print("caling mcqlist");

    if (getx.isInternet.value) {
      updatePackage(context, getx.loginuserdata[0].token, false, packageid);
    } else {
      getx.mcqdataList.value = true;
      getx.theoryExamvalue.value = true;
    }

    // if (getx.isInternet.value) {
    //   getx.mcqdataList.value = await getMcqDataForTest(
    //       context, getx.loginuserdata[0].token, packageid);
    //   getx.theoryExamvalue.value = await gettheoryExamDataForTest2(
    //       context, getx.loginuserdata[0].token, packageid);
    //   // getx.theoryexamList.value=await fetchTheorySetList(packageid);
    // }
    // Get.back();
  }

  // Widget getFolderIcon(Map<String, dynamic> foldername, index) {
  //   switch (foldername['section']) {
  //     case "Video":
  //       return showDetails(Icon(Icons.video_library, color: Colors.blue),
  //           foldername: foldername);

  //     // return Icon(Icons.video_library, color: Colors.blue);
  //     case "Live":
  //       return showDetails(Icon(Icons.live_tv, color: Colors.red),
  //           foldername: foldername);

  //     case "VideosBackup":
  //       return showDetails(Icon(Icons.backup, color: Colors.orange),
  //           foldername: foldername);
  //     case "MCQ":
  //       return showDetails(Icon(Icons.question_answer, color: Colors.green),
  //           foldername: foldername);
  //     case "Theory":
  //       return showDetails(Icon(Icons.book, color: Colors.purple),
  //           foldername: foldername);
  //     case "Book":
  //       return showDetails(Icon(Icons.library_books, color: Colors.brown),
  //           foldername: foldername);
  //     default:
  //       return showDetails(Icon(Icons.folder, color: Colors.blue),
  //           foldername: foldername);
  //   }
  // }

  Widget showDetails(Icon icon, {Map<String, dynamic>? foldername}) {
    infoTetch(widget.packageid.toString(), foldername?['section'] ?? 'no');
    return GetBuilder<Getx>(builder: (Getx controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue[50],
                      ),
                      child: icon)
                ],
              ),
              Row(
                children: [
                  Text(
                    foldername?['section'] ?? '',
                    style: FontFamily.font4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          Colors.grey[200], // Soft background color
                      radius: 12,
                      child: Text(
                        controller.infoFetch.isNotEmpty
                            ? controller.infoFetch.length.toString()
                            : '0', // Default to 0 for better readability
                        style: FontFamily.style.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .grey[800], // Slightly darker color for contrast
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5), // Add spacing for better readability
                if (controller
                    .infoFetch.isNotEmpty) // Conditionally render text
                  Text(
                    '${controller.infoFetch.length} Items Available', // Dynamic count text
                    style: FontFamily.style.copyWith(
                      fontSize: 12,
                      color:
                          Colors.green, // Use a consistent professional color
                      fontWeight: FontWeight.w500, // Slightly bold for emphasis
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }

  // initState((){});
  @override
  void dispose() {
    getx.sectionListOfPackage.clear();
    // getx.infoFetch.clear();
    // TODO: implement dispose
    super.dispose();
  }

  static final List<List<Color>> gradientColorsList = [
    [
      // Light orange -> peach
      const Color(0xFFFFF1D5),
      const Color(0xFFFFE0AF),
    ],
    [
      // Light pink -> soft pink
      const Color(0xFFFEE4F3),
      const Color(0xFFFDD3E7),
    ],
    [
      // Light pink -> soft pink
      Colors.blue.shade200,
      Colors.blue.shade100
    ],
    [
      // Light pink -> soft pink
      Colors.orange.shade200,
      Colors.orange.shade100
    ],
    [
      // Light pink -> soft pink
      Colors.green.shade200,
      Colors.green.shade100
    ],
    [
      // Light pink -> soft pink
      Colors.brown.shade200,
      Colors.brown.shade100
    ],
  ];

  final List<Map<String, dynamic>> folderIcons = [
    {
      "section": "Video",
      "icon": Icons.video_library,
      "color": Colors.blue,
      "subtitle": "Watch recorded videos and tutorials",
      "color2": [
        // Light pink -> soft pink
        Colors.green.shade200,
        Colors.green.shade100
      ],
    },
    {
      "section": "Live",
      "icon": Icons.live_tv,
      "color": Colors.red,
      "subtitle": "Join live streaming sessions",
      'color2': [
        // Light orange -> peach
        const Color(0xFFFFF1D5),
        const Color(0xFFFFE0AF),
      ],
    },
    {
      "section": "VideosBackup",
      "icon": Icons.backup,
      "color": Colors.orange,
      "subtitle": "Backup and restore your video files",
      "color2": [
        // Light pink -> soft pink
        Colors.brown.shade200,
        Colors.brown.shade100
      ],
    },
    {
      "section": "MCQ",
      "icon": Icons.question_answer,
      "color": Colors.green,
      "subtitle": "Practice multiple-choice questions",
      'color2': [
        // Light pink -> soft pink
        Colors.blue.shade200,
        Colors.blue.shade100
      ],
    },
    {
      "section": "Test",
      "icon": Icons.book,
      "color": Colors.purple,
      "subtitle": "Read and review theoretical content",
      "color2": [
        // Light pink -> soft pink
        Colors.orange.shade200,
        Colors.orange.shade100
      ],
    },
    {
      "section": "Book",
      "icon": Icons.library_books,
      "color": Colors.brown,
      "subtitle": "Access and manage your digital library",
      "color2": [
        // Light pink -> soft pink
        const Color(0xFFFEE4F3),
        const Color(0xFFFDD3E7),
      ],
    },
  ];

  Icon getFolderIcon(Map<String, dynamic> foldername, int index) {
    // Find the matching icon data from the list
    final iconData = folderIcons.firstWhere(
      (item) => item['section'] == foldername['section'],
      orElse: () =>
          {"icon": Icons.folder, "color": Colors.blue, "subtitle": 'No'},
    );

    // Return the showDetails widget with the appropriate icon and foldername
    return Icon(iconData['icon'], color: iconData['color']);
  }

  String getFolderSubtitle(Map<String, dynamic> foldername, int index) {
    // Find the matching icon data from the list
    final iconData = folderIcons.firstWhere(
      (item) => item['section'] == foldername['section'],
      orElse: () =>
          {"icon": Icons.folder, "color": Colors.blue, "subtitle": 'No'},
    );

    // Return the showDetails widget with the appropriate icon and foldername
    return iconData['subtitle'];
  }

  Color getFolderIconColor(Map<String, dynamic> foldername, int index) {
    // Find the matching icon data from the list
    final iconData = folderIcons.firstWhere(
      (item) => item['section'] == foldername['section'],
      orElse: () =>
          {"icon": Icons.folder, "color": Colors.blue, "subtitle": 'No'},
    );

    // Return the showDetails widget with the appropriate icon and foldername
    return iconData['color'];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // var packagecontentlist = getx.packagedetailsfoldername.entries.toList();
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorPage.white),
          backgroundColor: ColorPage.mainBlue,
          title: Text(
            widget.packagename,
            style: FontFamily.style.copyWith(color: Colors.white, fontSize: 15),
          ),
        ),
        body: getx.sectionListOfPackage.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: getx.sectionListOfPackage
                    .where((item) =>
                        item['section'] != 'PDF' &&
                        item['section'] != 'YouTube')
                    .length,
                itemBuilder: (context, index) {
                  final filteredList = getx.sectionListOfPackage
                      .where((item) =>
                          item['section'] != 'PDF' &&
                          item['section'] != 'YouTube')
                      .toList();

                  return InkWell(
                    onTap: () {
                      paging(filteredList[index]['section']);

                      if (getx.sectionListOfPackage[index]['section'] ==
                          "Video") {
                        resetTblLocalNavigationByOrderOnsection(1);
                        print(filteredList[index]['section'] + "wow mc");

                        insertTblLocalNavigation(
                                "Section",
                                widget.packageid.toString(),
                                filteredList[index]["section"])
                            .whenComplete(() => null);

                        getMainChapter(widget.packageid);
                        getLocalNavigationDetails();
                      }
                      getx.selectedPackageId.value = widget.packageid;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildOfferCard(
                          title: filteredList[index]['section'],
                          subtitle:
                              getFolderSubtitle(filteredList[index], index),
                          gradientColors: gradientColorsList[index],
                          arrowBackground: Colors.orange.shade100,
                          arrowColor: Colors.orange,
                          icon: getFolderIcon(filteredList[index], index),
                          iconcolor:
                              getFolderIconColor(filteredList[index], index)
                          // zipText: 'ZIP',
                          // zipTextColor: Colors.orange,
                          ),
                    ),

                    //  Container(
                    //   margin:
                    //       EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black12,
                    //         spreadRadius: 4,
                    //         blurRadius: 10,
                    //         offset: Offset(2, 2),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    // child: getFolderIcon(filteredList[index], index),
                    //   ),
                    // ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      );
    });
  }

  static Widget _buildOfferCard(
      {required String title,
      required String subtitle,
      required List<Color> gradientColors,
      required Color arrowBackground,
      required Color arrowColor,
      required Icon icon,
      required Color iconcolor

      // required String zipText,
      // required Color zipTextColor,
      }) {
    return Container(
      width: 100,
      // Set a fixed height for the card
      height: 160, // <-- Adjust this value as needed
      // margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                  // margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(255, 231, 242, 250),
                  ),
                  child: Icon(
                    icon.icon,
                    color: iconcolor,
                  ))
            ],
          ),
          const SizedBox(height: 6),
          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: const Color.fromARGB(255, 49, 49, 49).withOpacity(0.7),
            ),
          ),
          const Spacer(),
          // Bottom row: Circular arrow on the left, ZIP text on the right
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(logopath, width: 45),
              // Circular arrow icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: arrowBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: arrowColor,
                  size: 20,
                ),
              ),
              // Image.asset(logopath, width: 45),
              // ZIP or ZIP EMI text
              // Text(
              //   zipText,
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //     color: zipTextColor,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
