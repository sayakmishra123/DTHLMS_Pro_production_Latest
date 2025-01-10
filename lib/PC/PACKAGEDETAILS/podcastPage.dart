import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/Package_Video_dashboard.dart';
import 'package:dthlms/PC/PACKAGEDETAILS/podcastPlayer.dart';
import 'package:dthlms/PC/STUDYMATERIAL/pdfViewer.dart';
import 'package:dthlms/PC/VIDEO/videoplayer.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastDashBoard extends StatefulWidget {
  const PodcastDashBoard({super.key});

  @override
  State<PodcastDashBoard> createState() => _PodcastDashBoardState();
}

class _PodcastDashBoardState extends State<PodcastDashBoard> {
  int selectedIndex = -1; // Track the selected item index
  int lastTapIndex = -1;
  int selectedVideoIndex = -1;
  int selectedvideoListIndex = -1;
  // Track the last tapped item index
  DateTime lastTapTime = DateTime.now(); // Track the last tap time
  Getx getx = Get.put(Getx());
  TextEditingController searchController = TextEditingController();
  List<dynamic> filteredChapterDetails = [];
  List<dynamic> filteredFileDetails = [];
  // List to store filtered items

  @override
  void initState() {
    super.initState();
    getListStructure();
    filteredChapterDetails = getx.alwaysShowChapterDetailsOfVideo;
    filteredFileDetails =
        getx.podcastFileList; // Initialize with full list
    int callCount = 0;

    Timer.periodic(Duration(seconds: 1), (timer) {
      // Increment the counter
      callCount++;

      // Call the function
      getLocalNavigationDetails();

      // Check if the counter has reached 5
      if (callCount >= 5) {
        // Cancel the timer
        timer.cancel();
      }
    });
  }

  Future getListStructure() async {
    print('object541541541541');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    getx.isFolderview.value = prefs.getBool("folderview") ?? false;
    int startParentId = 0;
    if (getx.selectedPackageId.value > 0) {
      await getStartParentId(getx.selectedPackageId.value).then((value) {
        print("complete startparent Id");

        getChapterContents(value).then((onValue) {
          print("complete chapter content");
          getChapterFiles(
              parentId: value,
              "Podcast",
              getx.selectedPackageId.value.toString());
          // getChapterFiles(
          //     parentId: value, "PDF", getx.selectedPackageId.value.toString());
        });
      });
    } else {
      print("Packageapter  is null");
    }
  }

  // void filterSearchResults(String query) {
  //   if (query.isEmpty) {
  //     setState(() {
  //       filteredChapterDetails = [
  //         ...getx.alwaysShowChapterDetailsOfVideo,
  //         ...getx.alwaysShowFileDetailsOfpdf
  //       ];
  //       // filteredChapterDetails = getx.alwaysShowChapterDetailsOfVideo;
  //       filteredFileDetails =
  //           getx.alwaysShowChapterfilesOfVideo; // Show full list
  //     });
  //   } else {
  //     setState(() {
  //       filteredChapterDetails = getx.alwaysShowChapterDetailsOfVideo
  //           .where((chapter) => chapter['SectionChapterName']
  //               .toLowerCase()
  //               .contains(query.toLowerCase()))
  //           .toList();
  //       filteredFileDetails = getx.alwaysShowChapterfilesOfVideo
  //           .where((chapter) => chapter['FileIdName']
  //               .toLowerCase()
  //               .contains(query.toLowerCase()))
  //           .toList(); // Filtered list based on search query
  //     });
  //   }
  // }
  bool isColorBlue = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: !getx.isCollapsed.value ? 5 : 0,
      ),
      child: Obx(
        () => Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                            getx.subjectDetails.isNotEmpty
                                ? getx.subjectDetails[0]["SubjectName"]
                                : "Subject Name",
                            style: FontFamily.font),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Tooltip(
                                message: "Folder View",
                                child: IconButton(
                                  onPressed: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool("folderview", true);

                                    getx.isFolderview.value = true;
                                  },
                                  icon: Icon(
                                    Icons.grid_view_rounded,
                                    color: getx.isFolderview.value
                                        ? ColorPage.colorbutton
                                        : ColorPage.colorblack,
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: "List View",
                                child: IconButton(
                                  onPressed: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool("folderview", false);
                                    getx.isFolderview.value = false;
                                  },
                                  icon: Icon(
                                    Icons.view_list,
                                    color: !getx.isFolderview.value
                                        ? ColorPage.colorbutton
                                        : ColorPage.colorblack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 7,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //     blurRadius: 3,
                      //     color: Color.fromARGB(255, 192, 191, 191),
                      //     offset: Offset(0, 0),
                      //   ),
                      // ],
                      // color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              getx.isCollapsed.value
                                  ? IconButton(
                                      icon: Icon(Icons.list),
                                      onPressed: () {
                                        getx.isCollapsed.value =
                                            !getx.isCollapsed.value;
                                      },
                                    )
                                  : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Obx(
                                  () => SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (var i = 0;
                                            i < getx.navigationList.length;
                                            i++)
                                          getx.navigationList.isEmpty
                                              ? Text("Blank")
                                              : InkWell(
                                                  onTap: () {
                                                    if (i == 0) {
                                                      // nothing
                                                    }
                                                    if (i == 1) {
                                                      print('press in video');
                                                      resetTblLocalNavigationByOrder(
                                                          2);
                                                      getStartParentId(int.parse(
                                                              getx.navigationList[
                                                                      1][
                                                                  'NavigationId']))
                                                          .then((value) {
                                                        print(value);
                                                        getChapterContents(
                                                            int.parse(value
                                                                .toString()));
                                                      
                                                        getChapterFiles(
                                                            parentId: int.parse(
                                                                value
                                                                    .toString()),
                                                            'Podcast',
                                                            getx.selectedPackageId
                                                                .value
                                                                .toString());
                                                      });
                                                      getLocalNavigationDetails();
                                                    }
                                                    if (i == 2) {
                                                      print('press in video');
                                                      resetTblLocalNavigationByOrder(
                                                          2);
                                                      getStartParentId(int.parse(
                                                              getx.navigationList[
                                                                      1][
                                                                  'NavigationId']))
                                                          .then((value) {
                                                        print(value);
                                                        getChapterContents(
                                                            int.parse(value
                                                                .toString()));
                                                      
                                                        getChapterFiles(
                                                            parentId: int.parse(
                                                                value
                                                                    .toString()),
                                                            'Podcast',
                                                            getx.selectedPackageId
                                                                .value
                                                                .toString());
                                                      });
                                                      getLocalNavigationDetails();
                                                    }
                                                    if (i > 2) {
                                                      resetTblLocalNavigationByOrder(
                                                          i);
                                                      getChapterContents(int.parse(
                                                          getx.navigationList[i]
                                                              [
                                                              'NavigationId']));
                                                  
                                                      getLocalNavigationDetails();
                                                      getChapterFiles(
                                                          parentId: int.parse(
                                                              getx.navigationList[
                                                                      i][
                                                                  'NavigationId']),
                                                          'Podcast',
                                                          getx.selectedPackageId
                                                              .value
                                                              .toString());
                                                      getLocalNavigationDetails();
                                                    }
                                                    print(getx
                                                        .alwaysShowChapterDetailsOfVideo
                                                        .length);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      ClipPath(
                                                        clipper:
                                                            NavigationClipper1(),
                                                        child: Container(
                                                          height: 30,
                                                          width: 20,
                                                          color: i ==
                                                                  getx.navigationList
                                                                          .length -
                                                                      1
                                                              ? Colors.blue
                                                              : Colors.white,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      50),
                                                        ),
                                                      ),

                                                      ClipPath(
                                                        child: Container(
                                                          width: (() {
                                                            int nameLength = getx
                                                                .navigationList[
                                                                    i][
                                                                    "NavigationName"]
                                                                .length;

                                                            if (nameLength >=
                                                                16) {
                                                              return 210.0;
                                                            } else if (nameLength >=
                                                                13) {
                                                              return 190.0;
                                                            } else if (nameLength >=
                                                                10) {
                                                              return 170.0;
                                                            } else if (nameLength >=
                                                                7) {
                                                              return 150.0;
                                                            } else {
                                                              return 100.0;
                                                            }
                                                          })(),

                                                          decoration:
                                                              BoxDecoration(
                                                            color: i ==
                                                                    getx.navigationList
                                                                            .length -
                                                                        1
                                                                ? Colors.blue
                                                                : Colors.white,

                                                            // border: Border.all(color: Colors.amber)
                                                          ),
                                                          height: 30,
                                                          // width: 150,

                                                          child: Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child: Text(
                                                                  overflow: TextOverflow
                                                                      .ellipsis,
                                                                  getx.navigationList[
                                                                          i][
                                                                      "NavigationName"],
                                                                  style: FontFamily.styleb.copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: i ==
                                                                              getx.navigationList.length -
                                                                                  1
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black54)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      ClipPath(
                                                        clipper:
                                                            NavigationClipper(),
                                                        child: Container(
                                                          height: 30,
                                                          width: 20,
                                                          color: i ==
                                                                  getx.navigationList
                                                                          .length -
                                                                      1
                                                              ? Colors.blue
                                                              : Colors.white,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      50),
                                                        ),
                                                      ),

                                                      // Padding(
                                                      //   padding: const EdgeInsets
                                                      //       .symmetric(
                                                      //       horizontal: 1),
                                                      //   child: Icon(
                                                      //     Icons.chevron_right,
                                                      //     color: Colors.grey,
                                                      //     size: 20,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              color: Color.fromARGB(255, 192, 191, 191),
                              offset: Offset(0, 0),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Obx(
                          () => Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: getx.isFolderview.value
                                    ? buildGridView()
                                    : buildListView(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 11,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 7, right: getx.isCollapsed.value ? 10 : 0),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color.fromARGB(255, 192, 191, 191),
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: buildFileList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    return Container(
      padding: EdgeInsets.all(10),
      child: filteredChapterDetails.isNotEmpty
             
          ? GridView.builder(
              itemCount: filteredChapterDetails.length ,
                 
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getx.isCollapsed.value ? 5 : 4,
                childAspectRatio: 1.0,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return buildGridItem(index);
                // else
              },
            )
          : Center(
              child: Text('No Data found'),
            ),
    );
  }

  Widget buildGridItem(int index,) {
    return InkWell(
      onTap: () {
        
          insertTblLocalNavigation(
            "ParentId",
            filteredChapterDetails[index]['SectionChapterId'],
            filteredChapterDetails[index]['SectionChapterName'],
          ).whenComplete(() {
            getLocalNavigationDetails();
          });
          print(filteredChapterDetails[index]['SectionChapterId']);

          try {
            print(filteredChapterDetails[index]['SectionChapterId']);

            getChapterContents(
                int.parse(filteredChapterDetails[index]['SectionChapterId']));

         
            getChapterFiles(
                parentId: int.parse(
                    filteredChapterDetails[index]['SectionChapterId']),
                'Podcast',
                getx.selectedPackageId.value.toString());
          } catch (e) {
            writeToFile(e, "buildGridItem");
            print(e.toString() + " ---$index");
          }
          selectedIndex = index;
        
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            color: selectedIndex == index
                ? ColorPage.blue.withOpacity(0.3)
                : Colors.transparent,
          ),
          child: Column(
            children: [
               Image.asset(
                      "assets/folder5.png",
                      scale: 8,
                    ),
                 
              AutoSizeText(
         
                     filteredChapterDetails[index]['SectionChapterName'],
                overflow: TextOverflow.ellipsis,
                style: FontFamily.font9.copyWith(color: ColorPage.colorblack),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListView() {
    return Container(
      padding: EdgeInsets.all(10),
      child: filteredChapterDetails.isNotEmpty 
           
          ? ListView.builder(
              itemCount: filteredChapterDetails.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                 return buildListItem(index);
              
              },
            )
          : Center(
              child: Text('No data found'),
            ),
    );
  }

  Widget buildListItem(int index) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Color.fromARGB(255, 192, 191, 191),
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: selectedIndex == index ? ColorPage.colorbutton : ColorPage.white,
      ),
      child: MaterialButton(
        onPressed: () {
       
            insertTblLocalNavigation(
              "ParentId",
              filteredChapterDetails[index]['SectionChapterId'],
              filteredChapterDetails[index]['SectionChapterName'],
            ).whenComplete(() {
              getLocalNavigationDetails();
            });
            print(filteredChapterDetails[index]['SectionChapterId']);

            try {
              print(filteredChapterDetails[index]['SectionChapterId']);

              getChapterContents(
                  int.parse(filteredChapterDetails[index]['SectionChapterId']));

             
              getChapterFiles(
                  parentId: int.parse(
                      filteredChapterDetails[index]['SectionChapterId']),
                  'Podcast',
                  getx.selectedPackageId.value.toString());
            } catch (e) {
              writeToFile(e, "buildListItem");
              print(e.toString() + " ---$index");
            }
            selectedIndex = index;
          
          setState(() {});
        },
        child: ListTile(
          leading: 
               Image.asset(
                  "assets/folder8.png",
                  width: 30,
                ),
          trailing: Icon(
            Icons.arrow_forward_ios_sharp,
            size: 20,
            color:
                selectedIndex == index ? ColorPage.white : ColorPage.colorblack,
          ),
          title: Text(
          
                 filteredChapterDetails[index]['SectionChapterName'],
            style: FontFamily.font9.copyWith(
              fontWeight: FontWeight.bold,
              color: selectedIndex == index
                  ? ColorPage.white
                  : ColorPage.colorblack,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFileList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorPage.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Color.fromARGB(255, 192, 191, 191),
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Obx(
        () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: filteredFileDetails.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredFileDetails.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onDoubleTap: () async {
                          //               if(await isProcessRunning("dthlmspro_video_player")==false){
                          //    run_Video_Player_exe(filteredFileDetails[index]['DocumentPath']);

                          // }

                    
                       Get.to(
                                        transition: Transition.cupertino,
                                        () => PodCastPlayer(
                                            
                                            ));

                        },
                        onTap: () {
                          setState(() {
                            selectedVideoIndex = index;
                          });

                          handleTap(index);
                        },
                        child: Card(
                          color: selectedVideoIndex == index
                              ? ColorPage.colorbutton.withOpacity(0.9)
                              : Color.fromARGB(255, 245, 243, 248),
                          child: ListTile(
                            leading: Image.asset(
                              "assets/microphone.png",
                              scale: 2,
                              color: selectedVideoIndex == index
                                  ? ColorPage.white.withOpacity(0.85)
                                  : ColorPage.colorbutton,
                            ),
                            // subtitle: Text(
                            //   'Duration:  ${filteredFileDetails[index]['DocumentPath']}',
                            //   style: TextStyle(
                            //     color: selectedVideoIndex == index
                            //         ? ColorPage.white.withOpacity(0.9)
                            //         : ColorPage.grey,
                            //     fontWeight: FontWeight.w800,
                            //   ),
                            // ),
                            title: Text(
                              filteredFileDetails[index]['FileIdName'],
                              style: GoogleFonts.inter().copyWith(
                                color: selectedVideoIndex == index
                                    ? ColorPage.white
                                    : ColorPage.colorblack,
                                fontWeight: FontWeight.w800,
                                fontSize:
                                    selectedvideoListIndex == index ? 20 : null,
                                // color: selectedListIndex == index
                                //     ? Colors.amber[900]
                                //     : Colors.black,
                              ),
                            ),
                            trailing: SizedBox(
                              child: IconButton(
                                  onPressed: () {
                                    Get.to(
                                        transition: Transition.cupertino,
                                        () => PodCastPlayer(
                                            
                                            ));
                                  },
                                  icon: Icon(
                                    Icons.play_circle,
                                    color: selectedVideoIndex == index
                                        ? ColorPage.white
                                        : ColorPage.colorbutton,
                                  )),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text('No data found'),
                  )),
      ),
    );
  }

  void handleTap(int index) {
    DateTime now = DateTime.now();
    if (index == lastTapIndex &&
        now.difference(lastTapTime) < Duration(seconds: 1)) {
      print('Double tapped on folder: $index');
    }
    lastTapIndex = index;
    lastTapTime = now;
  }
}

class NavigationClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class NavigationClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}