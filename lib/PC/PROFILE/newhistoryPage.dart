import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  // SettingsStorage storage = SettingsStorage();

  List<String> animatedText = [
    'Protect your videos ensure complete security.',
    'Keep your videos safe maintain privacy and security.',
    'Secure your content safeguard your data.'
  ];

  RxBool isEnpChecked = false.obs;
  RxBool isCompressedChecked = false.obs;

  RxInt pageIndex =  0.obs;

  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;
  RxBool isCompressing = false.obs;
List video=[];
  // controllers

  TextStyle rowTextStyle = FontFamily.font3
      .copyWith(color: const Color.fromARGB(255, 130, 130, 130));

  final RxMap<String, bool> compressedState = <String, bool>{}.obs;

  @override
 

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    final Map<String, List<Map<String, dynamic>>> groupedVideos = {};
    for (var video in video) {
      final date = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(video['CompressDate']));
      if (!groupedVideos.containsKey(date)) {
        groupedVideos[date] = [];
      }
      groupedVideos[date]!.add(video);
    }

    final List<String> dates = groupedVideos.keys.toList();

    List<String> filteredDates = dates.where((date) {
      if (_selectedIndex == 0) {
        // Show videos where status is true
        return groupedVideos[date]!.any((video) => video['Status'] == 'true');
      } else if (_selectedIndex == 1) {
        // Show videos where status is false
        return groupedVideos[date]!.any((video) => video['Status'] == 'false');
      } else {
        // Show nothing for selectedIndex 2
        return false;
      }
    }).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Column(
        children: [
       
          Container(
            padding: const EdgeInsets.all(8.0),
            height: height - 35,
            width: width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          // IconButton(
                          //     onPressed: () {
                          //       Get.back();
                          //     },
                          //     icon: const Icon(Icons.arrow_back_rounded)),
                          // const SizedBox(
                          //   width: 5,
                          // ),
                          Text('Progress'),
                          const SizedBox(
                            width: 5,
                          ),
                          pageIndex.value == 0
                              ? Text(
                                  'hhhh',
                                  
                                )
                              : const SizedBox(),
                          // Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            tooltip: "Settings",
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.settings)),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Row(
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      MaterialButton(
                        onPressed: () {
                          pageIndex.value = 0;
                        },
                        color: pageIndex.value == 0 ? ColorPage.buttonColor : null,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            'In Progress',
                            style: FontFamily.font3.copyWith(
                              color: pageIndex.value != 0
                                  ? ColorPage.buttonColor
                                  : null,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      MaterialButton(
                        onPressed: () {
                          pageIndex.value = 1;
                        },
                        color: pageIndex.value == 1 ? ColorPage.colorbutton : null,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            'History',
                            style: FontFamily.font3.copyWith(
                              color: pageIndex.value != 1
                                  ? ColorPage.colorbutton
                                  : null,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      MaterialButton(
                        onPressed: () {
                          pageIndex.value = 2;
                        },
                        color: pageIndex.value == 2 ? ColorPage.colorbutton : null,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            'Upload',
                            style: FontFamily.font3.copyWith(
                              color: pageIndex.value != 2
                                  ? ColorPage.colorbutton
                                  : null,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      pageIndex.value == 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: MaterialButton(
                                    color: Colors.blue[700],
                                    onPressed: () async {
                                
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          'Clear All',
                                          style: FontFamily.font3
                                              .copyWith(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  color: Colors.blue[700],
                                  onPressed: () async {
                                    const typeGroup = XTypeGroup(
                                      label: 'Videos',
                                      extensions: ['mp4', 'mkv', 'flv'],
                                    );
                                    final List<XFile> files = await openFiles(
                                        initialDirectory: 'Upload videos',
                                        acceptedTypeGroups: [typeGroup]);

                                    if (files.isNotEmpty) {
                                      for (var file in files) {
                                    
                                      }
                                    } else {
                                      print("File selection canceled");
                                    }
                                  },
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      'Browse',
                                      style: FontFamily.font3
                                          .copyWith(fontSize: 14),
                                    ),
                                  )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Obx(
                                  () => Opacity(
                                    opacity:
                                      video.isEmpty
                                            ? 1
                                            : 0.4,
                                    child: MaterialButton(
                                      shape: ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                            color: Colors.black54, width: 2),
                                      ),
                                      onPressed:
                                        (){},
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.cancel_outlined,
                                              size: 20,
                                              color: Colors.black54,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              
                                                  'Restart',
                                              style: FontFamily.font3.copyWith(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Obx(
                  () => pageIndex.value == 0
                      ? 
                      Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    spreadRadius: 4,
                                    offset: Offset(8, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Video Type',
                                      
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Video Name',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Location',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Video Size (in MB)',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Duration',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Encrypt',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Compress',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const SizedBox(width: 40),
                                ],
                              ),
                            ),
                            Expanded(
                                child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                print(index);
                             
                                return InkWell(
                                  onTap: () {},
                                  child: Obx(() {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                      
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: 
                                                     Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  '555}',
                                                  style: rowTextStyle,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Tooltip(
                                                  message:
                                                   "kkk",
                                                  child: Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    '2222',
                                                    style: FontFamily.font4
                                                        .copyWith(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Tooltip(
                                                  message:
                                                      '2222',
                                                  child: Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    'llllll',
                                                    style: FontFamily.font4
                                                        .copyWith(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  ' Mb',
                                                  style: rowTextStyle,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  'kjhgfdsa',
                                                  style: rowTextStyle,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: 60,
                                                child: Center(
                                                
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: 100,
                                                child: Center(
                                                   ),
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: 40,
                                                child: Center(
                                                 
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                );
                              },
                            )

                                // Removed by shubha
                                // : Center(
                                //     child: c.checkoriginalvideos.value
                                //         ? const CircularProgressIndicator(
                                //             semanticsLabel: 'Please Wait',
                                //           )
                                //         : const Text(
                                //             'No video available',
                                //             textScaler:
                                //                 TextScaler.linear(2),
                                //           ))
                                ),
                          ],
                        ): 
                  
                  
                  
                  
                  
                    pageIndex.value == 1 ? Row(
                          children: [
                            const SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        spreadRadius: 4,
                                        offset: Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  height: 140,
                                  child: NavigationRail(
                                    backgroundColor: Colors.transparent,
                                    selectedIndex: _selectedIndex,
                                    groupAlignment: groupAlignment,
                                    onDestinationSelected: (int index) {
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    },
                                    labelType: labelType,
                                    destinations: const <NavigationRailDestination>[
                                      NavigationRailDestination(
                                        icon: Icon(Icons.check),
                                        selectedIcon: Icon(Icons.check_circle),
                                        label: Text('Completed'),
                                      ),
                                      NavigationRailDestination(
                                        icon: Icon(Icons.warning_amber_rounded),
                                        selectedIcon:
                                            Icon(Icons.warning_rounded),
                                        label: Text('Failed'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 50),
                            Expanded(
                              child: Container(
                                height: height * 0.9,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: ListView.builder(
                                    itemCount: filteredDates.length,
                                    itemBuilder: (context, index) {
                                      final date = filteredDates[index];
                                      final count =
                                          groupedVideos[date]!.where((video) {
                                        if (_selectedIndex == 0) {
                                          return video['Status'] == 'true';
                                        } else if (_selectedIndex == 1) {
                                          return video['Status'] == 'false';
                                        } else {
                                          return false;
                                        }
                                      }).length;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Material(
                                          color: Colors.transparent,
                                          elevation: 10,
                                          shadowColor: Colors.black26,
                                          child: ListTile(
                                            shape: ContinuousRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            minVerticalPadding: 10,
                                            tileColor: Colors.white,
                                            onTap: () {
                                              _showMyDialog(
                                                  context,
                                                  date,
                                                  groupedVideos[date]!,
                                                  _selectedIndex);
                                            },
                                            subtitle: Text("$count videos"),
                                            trailing: const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 16,
                                            ),
                                            title: Text(
                                              date,
                                              style: FontFamily.font3.copyWith(
                                                  color: ColorPage.bluegrey800,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                     ):SizedBox()
                )
                
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMyDialog(BuildContext context, String date,
      List<Map<String, dynamic>> videos, int selectedIndex) {
    List<Map<String, dynamic>> filteredVideos = videos.where((video) {
      if (selectedIndex == 0) {
        return video['Status'] == 'true';
      } else if (selectedIndex == 1) {
        return video['Status'] == 'false';
      } else {
        return false;
      }
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Videos on $date"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: filteredVideos.asMap().entries.map((entry) {
                int index = entry.key;
                var video = entry.value;
                return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(7),
                    margin: const EdgeInsets.all(5),
                    child: Row(children: [
                      const SizedBox(width: 10),
                      Text(
                        "${(index + 1).toString()}.",
                        style: FontFamily.font3
                            .copyWith(color: ColorPage.colorbutton),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 500,
                        child: GestureDetector(
                          onTap: () async {
                            // String videoPath = video['Path'].replaceAll(r'\', r'/');

                            String videoPath =
                                video['CompressedPath'].replaceAll(r'\', r'/');
                            Uri videoUri = Uri.file(videoPath);

                            print(videoPath);
                            print(videoUri);
                            // 'C:/Users/HP/Documents/completedfolder/sample.mp4'
                            // 'file:///C:/Users/HP/Documents/completedfolder/sample.mp4'
                            if (await canLaunchUrl(videoUri)) {
                              await launchUrl(videoUri);
                            } else {
                              throw 'Could not launch $videoPath';
                            }
                          },
                          child: Text(
                            video['Name'],
                            style: FontFamily.font3
                                .copyWith(color: ColorPage.colorbutton),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                video['StartCompressTime'],
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 15,
                            ),
                          ),
                          Text(
                            video['FinishCompressTime'],
                          ),
                        ],
                      ),
                    ]));
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Close",
                style: FontFamily.font3.copyWith(color: ColorPage.colorbutton),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
