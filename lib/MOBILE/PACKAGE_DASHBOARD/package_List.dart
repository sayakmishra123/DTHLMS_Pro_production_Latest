import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/package_contents.dart';
import 'package:dthlms/constants/constants.dart';
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
    super.initState();
    getAllPackageListOfStudent().whenComplete(() {
      setState(() {
        updateTabs();
      });
    });
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

    return DefaultTabController(
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
                  Get.to(
                      transition: Transition.cupertino,
                      () => Mobile_Package_content(
                            packageid:
                                int.parse(paidPackages[index]['packageId']),
                            packagename: paidPackages[index]['packageName'],
                          ));
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
                                  paidPackages[index]['packageName']!,
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
                                  'Course name ${paidPackages[index]['CourseName']}', // Replace with actual subtitle
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
                                  'ExpiryDate: ${formatDate(paidPackages[index]['ExpiryDate']) ?? 'N/A'}',
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
                  Get.to(
                      transition: Transition.cupertino,
                      () => Mobile_Package_content(
                            packageid:
                                int.parse(freePackages[index]['packageId']),
                            packagename: freePackages[index]['packageName'],
                          ));
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
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }
}
