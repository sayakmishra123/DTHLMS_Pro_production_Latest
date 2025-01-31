import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/package_contents.dart';
import 'package:dthlms/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../GETXCONTROLLER/getxController.dart';
import '../../LOCAL_DATABASE/dbfunction/dbfunction.dart';
import '../../THEME_DATA/color/color.dart';
import '../../THEME_DATA/font/font_family.dart';

class Mobile_Package_List extends StatefulWidget {
  const Mobile_Package_List({super.key});

  @override
  State<Mobile_Package_List> createState() => _Mobile_Package_ListState();
}

class _Mobile_Package_ListState extends State<Mobile_Package_List> {
  final Getx getx = Get.put(Getx());
  List<Widget> tabs = [];
  List<Widget> tabViews = [];

  @override
  void initState() {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getMeetingList(context);
    });
        getAllPackageListOfStudent().whenComplete(() {
      setState(() {
        updateTabs();
      });
    });
    super.initState();

  }

  void updateTabs() {
    tabs.clear();
    tabViews.clear();

    // Check for "Packages" availability
    final paidPackages =
        getx.studentPackage.where((pkg) => pkg['IsFree'] == 'false').toList();
    if (paidPackages.isNotEmpty) {
      tabs.add(Text("Packages", style: FontFamily.font2));
      tabViews.add(buildPackageListView(context));
    }
 
    // Check for "Free" availability
    final freePackages =
        getx.studentPackage.where((pkg) => pkg['IsFree'] == 'true').toList();
    if (freePackages.isNotEmpty) {
      tabs.add(Text("Free", style: FontFamily.font2));
      tabViews.add(buildFreeServicesListView(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    updateTabs();

    return Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => DefaultTabController(
                length: tabs.length,
                child: Scaffold(
                  appBar: tabs.isNotEmpty
                      ? AppBar(
                          toolbarHeight: 10,
                          automaticallyImplyLeading: false,
                          backgroundColor: ColorPage.mainBlue,
                          bottom: TabBar(
                            tabAlignment: TabAlignment.fill,
                            indicatorPadding: EdgeInsets.all(2),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: ColorPage.white,
                            labelPadding: EdgeInsets.all(10),
                            tabs: tabs,
                          ),
                        )
                      : null,
                  body: tabs.isNotEmpty
                      ? TabBarView(children: tabViews)
                      : Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                ),
              ),
            ));
  }

  // Icon? whichIcon(String? location) {
  //   double iconSize = 20.0;

  //   switch (location) {
  //     case "Live":
  //       return Icon(Icons.live_tv, color: ColorPage.live, size: iconSize);
  //     case "Video":
  //       return Icon(Icons.video_library, color: ColorPage.recordedVideo, size: iconSize);
  //     case "Test":
  //       return Icon(Icons.book, color: ColorPage.testSeries, size: iconSize);
  //     case "YouTube":
  //       return Icon(Icons.video_library, color: ColorPage.youtube, size: iconSize);
  //     default:
  //       return Icon(Icons.warning_amber_rounded, color: Colors.red, size: iconSize);
  //   }
  // }

  List<Widget> _buildIconStack(packageId) {
    getSectionListOfPackage(packageId);

    List<Widget> iconStack = [];
    final filteredList = getx.sectionListOfPackage
        .where(
            (item) => item['section'] != 'PDF' && item['section'] != 'YouTube')
        .toList();

    // Limit the number of items to 6
    int maxItems = filteredList.length > 5 ? 5 : filteredList.length;

    // Add the first 6 icons (or fewer if the list has less than 6 items)
    for (int i = 0; i < maxItems; i++) {
      iconStack.add(
        Positioned(
          left: i * 25.0, // Slight shift to the right for each successive icon
          child: CircleAvatar(
            radius: 20.0, // Radius of the CircleAvatar
            backgroundColor:
                Colors.grey.shade200, // Background color for each avatar
            child: getFolderIcon(filteredList[i], i),
          ),
        ),
      );
    }

    // If the list has more than 6 items, show the remaining count
    if (filteredList.length > 5) {
      iconStack.add(
        Positioned(
          left: 5 *
              25.0, // Position the remaining count icon next to the 6th icon
          child: CircleAvatar(
            radius: 20.0, // Radius of the CircleAvatar
            backgroundColor: Colors.grey.shade200, // Background color
            child: Text(
              '+${filteredList.length - 5}', // Show remaining count
              style: TextStyle(
                color: Colors.blue, // Color of the text
                fontWeight: FontWeight.bold, // Make the text bold
                fontSize: 14, // Size of the text
              ),
            ),
          ),
        ),
      );
    }

    return iconStack;
  }

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
      "section": "Podcast",
      "icon": Icons.podcasts,
      "color": Colors.orange,
      "subtitle":
          "Listen to insightful discussions and audio episodes anytime, anywhere.",
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
        const Color.fromARGB(255, 248, 177, 219),
        const Color(0xFFFDD3E7),
      ],
    },
  ];

  Icon getFolderIcon(Map<String, dynamic> foldername, int index) {
    // Find the matching icon data from the list
    final iconData = folderIcons.firstWhere(
      (item) => item['section'] == foldername['section'],
      orElse: () => {
        "icon": Icons.folder,
        "color": Colors.blue,
        "subtitle": '',
        "color2": [
          const Color(0xFFFFF1D5),
          const Color(0xFFFFE0AF),
        ]
      },
    );

    // Return the showDetails widget with the appropriate icon and foldername
    return Icon(
      iconData['icon'],
      color: iconData['color'], 
    );
  }

  Widget buildPackageListView(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 20);
    final paidPackages =
        getx.studentPackage.where((pkg) => pkg['IsFree'] == 'false').toList();

    return paidPackages.isNotEmpty
        ? ListView.builder(
            itemCount: paidPackages.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Mobile_Package_content(
                        packageid: int.parse(paidPackages[index]['packageId']),
                        packagename: paidPackages[index]['packageName'],
                      );
                    },
                  ));
                  // Get.to(
                  //     transition: Transition.cupertino,
                  // () => Mobile_Package_content(
                  //       packageid:
                  //           int.parse(paidPackages[index]['packageId']),
                  //       packagename: paidPackages[index]['packageName'],
                  //     ));
                },
                child: Container(
                  height: 150,
                  width: itemWidth, // Adjusted for wider card
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black.withAlpha(100), width: 1),
                    color: Colors.white,
                    //  gradient: LinearGradient(colors: [
                    //   Colors.white.withAlpha(80),
                    //   Colors.grey.withAlpha(200),
                    //  ]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail Image on the left side
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            logopath,
                            height: 150,
                            width: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 10), // Space between image and text
                        // Text content on the right side
                        Expanded(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Title of the package or video
                                Text(
                                  paidPackages[index]['packageName']!,
                                  style: FontFamily.styleb.copyWith(
                                      color:
                                          const Color.fromARGB(255, 6, 0, 87),
                                      fontSize: 18),
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis, // Handle overflow
                                ),
                                SizedBox(height: 5),
                                // Subtitle or description
                                Text(
                                  '${paidPackages[index]['CourseName']}', // Replace with actual subtitle
                                  style: FontFamily.styleb.copyWith(
                                      color: Colors.grey, fontSize: 14),
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis, // Handle overflow
                                ),
                                SizedBox(height: 5),

                                Text(
                                  'ExpiryDate: ${formatDate(paidPackages[index]['ExpiryDate']) ?? 'N/A'}',
                                  style: FontFamily.styleb.copyWith(
                                      color: Colors.grey.withAlpha(100),
                                      fontSize: 12),
                                ),

                                SizedBox(height: 5),

                                // Text(
                                //   'Last Updated On: ${formatDate(getx.studentPackage[index]['LastUpdatedOn']) ?? 'N/A'}',
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //     color: Colors.orangeAccent,
                                //   ),
                                // ),
                                //  FlutterImageStack.providers(
                                //         providers: _images,
                                //         showTotalCount: true,
                                //         totalCount: 4,
                                //         itemRadius: 60, // Radius of each images
                                //         itemCount: 3, // Maximum number of images to be shown in stack
                                //         itemBorderWidth: 3, // Border width around the images
                                //       )
                                SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      clipBehavior: Clip
                                          .none, // Allows the icons to overlap
                                      children: _buildIconStack(int.parse(
                                          paidPackages[index]['packageId'])),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              // ListTile(
              //   title: Text(paidPackages[index]['packageName'] ?? ''),
              //   subtitle: Text(
              //       'ExpiryDate: ${formatDate(paidPackages[index]['ExpiryDate'])}'),
              //   onTap: () {
              //     Get.to(
              //       Mobile_Package_content(
              //         packageid: int.parse(paidPackages[index]['packageId']),
              //         packagename: paidPackages[index]['packageName'],
              //       ),
              //     );
              //   },
              // );
            },
          )
        : Center(
            child: Text(
              'No packages available',
              style: TextStyle(fontSize: 16),
            ),
          );
  }

  Widget buildFreeServicesListView(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 20);
    final freePackages =
        getx.studentPackage.where((pkg) => pkg['IsFree'] == 'true').toList();

    return freePackages.isNotEmpty
        ? ListView.builder(
            itemCount: freePackages.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Mobile_Package_content(
                        packageid: int.parse(freePackages[index]['packageId']),
                        packagename: freePackages[index]['packageName'],
                      );
                    },
                  ));
                  // Get.to(
                  //     transition: Transition.cupertino,
                  //     () => Mobile_Package_content(
                  //           packageid:
                  //               int.parse(freePackages[index]['packageId']),
                  //           packagename: freePackages[index]['packageName'],
                  //         ));
                },
                child: Container(
                  height: 150,
                  width: itemWidth * 2, // Adjusted for wider card
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail Image on the left side
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            logopath,
                            height: 150,
                            width: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 10), // Space between image and text
                        // Text content on the right side
                        Expanded(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Title of the package or video
                                Text(
                                  freePackages[index]['packageName']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color:
                                        const Color.fromARGB(255, 4, 42, 211),
                                  ),
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis, // Handle overflow
                                ),
                                SizedBox(height: 5),
                                // Subtitle or description
                                Text(
                                  'Course name ${freePackages[index]['CourseName']}', // Replace with actual subtitle
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis, // Handle overflow
                                ),
                                SizedBox(height: 5),

                                Text(
                                  'ExpiryDate: ${formatDate(freePackages[index]['ExpiryDate']) ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                ),

                                SizedBox(height: 5),

                                // Text(
                                //   'Last Updated On: ${formatDate(getx.studentPackage[index]['LastUpdatedOn']) ?? 'N/A'}',
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //     color: Colors.orangeAccent,
                                //   ),
                                // ),
                                SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      clipBehavior: Clip
                                          .none, // Allows the icons to overlap
                                      children: _buildIconStack(int.parse(
                                          freePackages[index]['packageId'])),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              //  ListTile(
              //   title: Text(freePackages[index]['packageName'] ?? ''),
              //   subtitle: Text(
              //       'ExpiryDate: ${formatDate(freePackages[index]['ExpiryDate'])}'),
              //   onTap: () {
              //     Get.to(
              //       Mobile_Package_content(
              //         packageid: int.parse(freePackages[index]['packageId']),
              //         packagename: freePackages[index]['packageName'],
              //       ),
              //     );
              //   },
              // );
            },
          )
        : Center(
            child: Text(
              'No free services available',
              style: TextStyle(fontSize: 16),
            ),
          );
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy,').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
