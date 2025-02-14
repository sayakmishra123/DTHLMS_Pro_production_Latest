import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:dio/dio.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/mobile_pdf_viewer.dart';
import 'package:dthlms/MOBILE/VIDEO/mobilevideoplay.dart';
import 'package:dthlms/PC/PACKAGEDETAILS/packagedetails.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<int, CancelToken> cancelTokens =
    {}; // Map to hold CancelTokens for each download
RxList<double> downloadProgress = List.filled(1000, 0.0).obs;

class MobilePackageVideoDashboard extends StatefulWidget {
  const MobilePackageVideoDashboard({super.key});

  @override
  State<MobilePackageVideoDashboard> createState() =>
      _MobilePackageVideoDashboardState();
}

class _MobilePackageVideoDashboardState
    extends State<MobilePackageVideoDashboard> {
  late ScrollController _scrollController;
  bool _showLeftButton = false;
  bool _showRightButton = true;
  List<dynamic> filteredChapterDetails = [];
  List<dynamic> filteredvideoDetails = [];
  List<dynamic> filteredPdfDetails = [];

  int lastTapVideoIndex = -1; // Track the last tapped item index
  DateTime lastTapvideoTime = DateTime.now();
  var color = Color.fromARGB(255, 102, 112, 133);

  late final Dio dio;
  int flag = 2;
  int selectedVideoIndex = -1;
  int selectedvideoListIndex = -1;

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    dio = Dio();
    filteredChapterDetails = getx.alwaysShowChapterDetailsOfVideo;

    filteredPdfDetails = getx.alwaysShowFileDetailsOfpdf;
    filteredvideoDetails = getx.alwaysShowChapterfilesOfVideo;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_filterLists);

    getListStructure().whenComplete(() {
      setState(() {});
    });
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

    //  _filteredItems = _combineAndTagItems();
    loade();
    super.initState();
  }

  void _filterLists() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      filteredChapterDetails = getx.alwaysShowChapterDetailsOfVideo
          .where((item) => item['SectionChapterName']
              .toString()
              .toLowerCase()
              .contains(query))
          .toList();

      filteredPdfDetails = getx.alwaysShowFileDetailsOfpdf
          .where((item) =>
              item['FileIdName'].toString().toLowerCase().contains(query))
          .toList();

      filteredvideoDetails = getx.alwaysShowChapterfilesOfVideo
          .where((item) =>
              item['FileIdName'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    cancelAllDownloads();

    super.dispose();
  }

  ScrollController scrollControllerofNavigateBar = ScrollController();
  void _scrollListenerofNavigateBar() {
    if (scrollControllerofNavigateBar.position.atEdge) {
      if (scrollControllerofNavigateBar.position.pixels == 0) {
        // The scroll is at the beginning
      } else {
        // The scroll is at the end
        print("Scrolled to the end");
      }
    }
  }

  void cancelAllDownloads() {
    cancelTokens.forEach((index, cancelToken) {
      cancelToken.cancel();
      print('Download for index $index cancelled.');
    });

    // Clear the cancelTokens map after canceling
    cancelTokens.clear();
    downloadProgress.value = List.filled(1000, 0.0);
  }

  void _scrollListener() {
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showLeftButton = false;
      });
    } else {
      setState(() {
        _showLeftButton = true;
      });
    }
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showRightButton = false;
      });
    } else {
      setState(() {
        _showRightButton = true;
      });
    }
  }

  Getx getx = Get.put(Getx());

  Future getListStructure() async {
    print('object541541541541');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    getx.isFolderview.value = prefs.getBool("folderview") ?? false;
    int startParentId = 0;
    if (getx.selectedPackageId.value > 0) {
      startParentId = await getStartParentId(getx.selectedPackageId.value);
    } else {
      print("abhoy is null");
    }

    await getChapterContents(startParentId);
    getChapterFiles(
        parentId: startParentId,
        "Video",
        getx.selectedPackageId.value.toString());
    getChapterFiles(
        parentId: startParentId,
        "PDF",
        getx.selectedPackageId.value.toString());
    // getx.isFolderviewVideo.value = prefs.getBool("folderviewVideo")!;
  }

  void scrollGridView(bool isLeft) {
    double scrollAmount = 300.0;

    double newOffset = isLeft
        ? _scrollController.offset - scrollAmount
        : _scrollController.offset + scrollAmount;

    if (newOffset < _scrollController.position.minScrollExtent) {
      newOffset = _scrollController.position.minScrollExtent;
    } else if (newOffset > _scrollController.position.maxScrollExtent) {
      newOffset = _scrollController.position.maxScrollExtent;
    }

    _scrollController.animateTo(
      newOffset,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  int selectedIndex = -1;

  search(value) {}

  RxBool isLoading = false.obs;
  loade() async {
    isLoading.value = true;

    await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await ArtSweetAlert.show(
            barrierDismissible: false,
            context: context,
            artDialogArgs: ArtDialogArgs(
                showCancelBtn: false,
                denyButtonText: "Cancel",
                title: "Are you sure?",
                text: "You want to exite.",
                confirmButtonText: "   Ok",
                onConfirm: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                onDeny: () {
                  Navigator.of(context).pop();
                },
                type: ArtSweetAlertType.warning));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  onSweetAleartDialogwithDeny(
                      context,
                      () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      "Are You Sure?",
                      "You want to exit.",
                      () {
                        Navigator.of(context).pop();
                      });
                },
                icon: Icon(Icons.arrow_back)),
            iconTheme: IconThemeData(color: ColorPage.white),
            backgroundColor: ColorPage.mainBlue,
            title: Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                    getx.subjectDetails.isNotEmpty
                        ? getx.subjectDetails[0]["SubjectName"]
                        : "Subject Name",
                    style: FontFamily.style
                        .copyWith(color: Colors.white, fontSize: 16)),
              ),
            ),
          ),
          body: Obx(
            () => isLoading.value
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ))
                : Column(
                    children: [
                      // new added
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              // Show loading indicator when navigation list is empty or still loading
                              if (isLoading.value) {
                                return Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(),
                                  ),
                                ));
                              }

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (scrollControllerofNavigateBar.hasClients) {
                                  scrollControllerofNavigateBar.jumpTo(
                                      scrollControllerofNavigateBar
                                          .position.maxScrollExtent);
                                }
                              });

                              return SingleChildScrollView(
                                controller: scrollControllerofNavigateBar,
                                scrollDirection: Axis
                                    .horizontal, // Enables horizontal scrolling
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
                                                } else if (i == 1 || i == 2) {
                                                  print('press in video');
                                                  resetTblLocalNavigationByOrder(
                                                      2);

                                                  getStartParentId(int.parse(
                                                          getx.navigationList[1]
                                                              ['NavigationId']))
                                                      .then((value) {
                                                    print(value);
                                                    getChapterContents(
                                                        int.parse(
                                                            value.toString()));
                                                    getChapterFiles(
                                                        parentId: int.parse(
                                                            value.toString()),
                                                        'Video',
                                                        getx.selectedPackageId
                                                            .value
                                                            .toString());
                                                    getChapterFiles(
                                                        parentId: int.parse(
                                                            value.toString()),
                                                        'PDF',
                                                        getx.selectedPackageId
                                                            .value
                                                            .toString());
                                                  });
                                                  getLocalNavigationDetails();
                                                } else if (i > 2) {
                                                  resetTblLocalNavigationByOrder(
                                                      i);
                                                  insertTblLocalNavigation(
                                                    "ParentId",
                                                    getx.navigationList[i]
                                                        ['NavigationId'],
                                                    getx.navigationList[i]
                                                        ["NavigationName"],
                                                  );

                                                  getChapterContents(int.parse(
                                                      getx.navigationList[i]
                                                          ['NavigationId']));
                                                  getChapterFiles(
                                                      parentId: int.parse(
                                                          getx.navigationList[i]
                                                              ['NavigationId']),
                                                      'Video',
                                                      getx.selectedPackageId
                                                          .value
                                                          .toString());
                                                  getLocalNavigationDetails();
                                                  getChapterFiles(
                                                      parentId: int.parse(
                                                          getx.navigationList[i]
                                                              ['NavigationId']),
                                                      'PDF',
                                                      getx.selectedPackageId
                                                          .value
                                                          .toString());
                                                  getLocalNavigationDetails();
                                                }

                                                print(getx
                                                    .alwaysShowChapterDetailsOfVideo
                                                    .length);

                                                setState(() {
                                                  filteredChapterDetails = getx
                                                      .alwaysShowChapterDetailsOfVideo;
                                                  filteredPdfDetails = getx
                                                      .alwaysShowFileDetailsOfpdf;
                                                  filteredvideoDetails = getx
                                                      .alwaysShowChapterfilesOfVideo;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Row(
                                                  children: [
                                                    if (i != 0) ...[
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
                                                          ),
                                                          height: 30,
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
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                filecountWidget(
                                    getx.alwaysShowChapterfilesOfVideo.length,
                                    "assets/video2.png"),
                                filecountWidget(
                                    getx.alwaysShowFileDetailsOfpdf.length,
                                    "assets/pdf.png"),
                                filecountWidget(
                                    getx.alwaysShowChapterDetailsOfVideo.length,
                                    "assets/folder5.png"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              width: MediaQuery.of(context).size.width - 40,
                              child: TextFormField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.search,
                                    ),
                                    suffixIconColor:
                                        Color.fromARGB(255, 197, 195, 195),
                                    hintText: 'Search',
                                    hintStyle: FontFamily.font9
                                        .copyWith(color: ColorPage.brownshade),
                                    fillColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 10),
                          child: Container(
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Obx(() {
                                      if (filteredChapterDetails.isEmpty &&
                                          filteredPdfDetails.isEmpty &&
                                          filteredvideoDetails.isEmpty) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.folder_open_outlined,
                                                size: 30,
                                                color: Colors.grey[600],
                                              ),
                                              Text(
                                                'Empty',
                                                style: FontFamily.style
                                                    .copyWith(
                                                        color: Colors.grey,
                                                        fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      return ListView.builder(
                                        itemCount:
                                            filteredChapterDetails.length +
                                                filteredPdfDetails.length +
                                                filteredvideoDetails.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          if (filteredChapterDetails.length >
                                              index)
                                            return buildListViewItem(
                                                index, false, false);
                                          else if (index <
                                                  (filteredChapterDetails
                                                          .length +
                                                      filteredPdfDetails
                                                          .length) &&
                                              filteredPdfDetails.isNotEmpty)
                                            return buildListViewItem(
                                                index, true, false);
                                          else
                                            return buildListViewItem(
                                                index -
                                                    (filteredChapterDetails
                                                            .length +
                                                        filteredPdfDetails
                                                            .length),
                                                false,
                                                true);
                                          //updated
                                        },
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildListViewItem(int index, bool ispdf, bool isVideo) {


    void showErrorDialog(BuildContext context, String title, String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    String? _videoFilePath;

    bool isDownloading = false;

    Future<void> startDownload(int index, String Link, String title) async {
      log('$title $Link Sayak');
      if (Link == "0") {
        print("Video link is $Link");
        return;
      }

      final appDocDir;
      try {
        var prefs = await SharedPreferences.getInstance();
        final path = await getApplicationDocumentsDirectory();
        appDocDir = path.path;

        // Log the directories to check where it's trying to save
        print('App Document Directory: $appDocDir');

        // Define paths
        getx.defaultPathForDownloadVideo.value =
            appDocDir + '/$origin' + '/Downloaded_videos';
        prefs.setString("DefaultDownloadpathOfVieo",
            appDocDir + '/$origin' + '/Downloaded_videos');
        print(getx.userSelectedPathForDownloadVideo.value +
            " it is user selected path");

        String savePath = getx.userSelectedPathForDownloadVideo.isEmpty
            ? appDocDir + '/$origin' + '/Downloaded_videos' + '/$title'
            : getx.userSelectedPathForDownloadVideo.value + '/$title';
        log('Save path: $savePath');

        // Temporary path for download
        String tempPath = appDocDir + '/temp' + '/$title';
        log('Temporary path: $tempPath');

        // Ensure temp directory exists
        final tempDir = await Directory(appDocDir + '/temp');
        if (!await tempDir.exists()) {
          await tempDir.create(recursive: true);
          print("Temporary directory created: ${tempDir.path}");
        }

        // Define the download task
        final task = DownloadTask(
          url: Link,
          baseDirectory: BaseDirectory.applicationDocuments,
          // baseDirectory: BaseDirectory.applicationDocuments,
          directory: '/temp', // Download to the temp folder
          filename: title,
          updates: Updates.statusAndProgress,
          allowPause: true,
          metaData: 'Video download for $title',
        );

        // Configure notification for all tasks
        FileDownloader().configureNotification(
          tapOpensFile: true,
          running: TaskNotification('Downloading', 'Downloading: $title'),
          complete: TaskNotification(
              'Download finished', 'Download completed: $title'),
          progressBar: true,
          paused: TaskNotification(title, 'Download Paused'),
        );

        // Start the download and wait for the result
        final result = await FileDownloader().download(
          task,
          onProgress: (progress) {
            setState(() {
              downloadProgress[index] =
                  progress * 100; // Update the download progress
            });
            print('Progress: ${progress * 100}%');
          },
          onStatus: (status) {
            switch (status) {
              case TaskStatus.complete:
                print('Download Complete!');
                break;
              case TaskStatus.canceled:
                print('Download was canceled');
                break;
              case TaskStatus.paused:
                print('Download was paused');
                break;
              default:
                print('Download in progress');
                break;
            }
          },
        );

        // Check if download was successful
        if (result.status == TaskStatus.complete) {
          // Check if the file exists in the temp directory before moving
          final tempFile = File(tempPath);
          final finalFile = File(savePath);

          if (!await tempFile.exists()) {
            print('Error: Temporary file not found at $tempPath');
            showErrorDialog(context, 'Download Failed',
                'The temporary file does not exist.');
            return;
          }

          // Ensure the parent directory exists for the final file
          await finalFile.parent.create(recursive: true);
          print("Final directory created: ${finalFile.parent.path}");

          // Move the file to the final destination
          await tempFile.copy(savePath);
          await tempFile.delete(); // Delete the temporary file
          print('Moved file from $tempPath to $savePath');

          // Success case: Update the progress to 100% and set the video file path
          setState(() {
            downloadProgress[index] = 100.0; // Mark the download as completed
            _videoFilePath = savePath;
            getx.playingVideoId.value = filteredvideoDetails[index]["FileId"];
          });

          print('$savePath video saved to this location');

          await insertDownloadedFileData(
            filteredvideoDetails[index]["PackageId"],
            filteredvideoDetails[index]["FileId"],
            savePath,
            'Video',
            title,
          );

          insertVideoDownloadPath(
            filteredvideoDetails[index]["FileId"],
            filteredvideoDetails[index]["PackageId"],
            savePath,
            context,
          );
        } else {
          print('Download not successful: ${result.status}');
          setState(() {
            // Reset progress to 0 if there's an error
            downloadProgress[index] = 0;
          });
        }
      } catch (e) {
        writeToFile(e, "startDownload");
        print(e.toString() + " error on download");
        if (!mounted) {
          setState(() {
            // Reset progress to 0 if there's an error
            downloadProgress[index] = 0;
          });
        }
        // Show error dialog if download fails
        showErrorDialog(context, 'Download Failed',
            'An error occurred during the download. Please try again.');
      } finally {
        cancelTokens.remove(
            index); // Remove the CancelToken when the download completes or fails
      }
    }

    void cancelAllDownloads() {
      cancelTokens.forEach((index, cancelToken) {
        cancelToken.cancel();
        print('Download for index $index cancelled.');
      });

      // Clear the cancelTokens map after canceling
      cancelTokens.clear();
    }

    void cancelDownload(int index) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cancel Download?'),
              content: Text('Are you sure you want to cancel the download?'),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(width: 2, color: Colors.red)))),
                  onPressed: () {
                    // Cancel the download (implement logic here)
                    if (cancelTokens.containsKey(index)) {
                      cancelTokens[index]?.cancel(); // Cancel the download
                      print("Download canceled for index $index");
                    } else {
                      print("No ongoing download for index $index");
                    }
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Download Cancelled')));
                    setState(() {
                      downloadProgress[index] = 0;
                    });
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Don't cancel the download, close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            );
          });
    }

    return isVideo
        ? GestureDetector(
            onTap: () {
              setState(() {
                selectedVideoIndex = index;
              });

              // handleTap(index);
            },
            child: Card(
              color:
                  //  selectedVideoIndex == index
                  //     ? ColorPage.colorbutton.withOpacity(0.9)
                  // :
                  Color.fromARGB(255, 255, 255, 255),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Image.asset(
                    "assets/video2.png",
                    scale: 19,
                    // color:
                    //  selectedVideoIndex == index
                    //     ? ColorPage.white.withOpacity(0.85)
                    //     :

                    // ColorPage.colorbutton,
                  ),
                ),
                subtitle: getPackagDataFieldValuebyId(
                            getx.selectedPackageId.toString(), "isTotal") !=
                        "0"
                    ? Text(
                        'Video duration:  ${breakSecondIntoHourAndMinute(int.parse(filteredvideoDetails[index]['VideoDuration'].toString()))}',
                        style: TextStyle(
                          color: ColorPage.grey,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Video duration:  ${breakSecondIntoHourAndMinute(int.parse(filteredvideoDetails[index]['VideoDuration'].toString()))}   Limit:  ${breakSecondIntoHourAndMinute(int.parse(filteredvideoDetails[index]['AllowDuration'].toString()))}',
                            style: TextStyle(
                              color: ColorPage.grey,
                              fontSize: 8,
                              // fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Consume:  ${breakSecondIntoHourAndMinute(getTotalConsumeDurationOfVideo(filteredvideoDetails[index]['FileId'].toString(), int.parse(filteredvideoDetails[index]['ConsumeDuration'].toString())))}    Remaining :  ${breakSecondIntoHourAndMinute(int.parse(filteredvideoDetails[index]['AllowDuration'].toString()) - getTotalConsumeDurationOfVideo(filteredvideoDetails[index]['FileId'].toString(), int.parse(filteredvideoDetails[index]['ConsumeDuration'].toString())))}',
                            style: TextStyle(
                              color: ColorPage.grey,
                              fontSize: 8,
                              // fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),

                // Text(
                //   'Duration: ${filteredvideoDetails[index]['AllowDuration']}',
                //   style: TextStyle(
                //     color:

                //         // selectedVideoIndex == index
                //         //     ? ColorPage.white.withOpacity(0.9)
                //         //     :

                //         ColorPage.grey,
                //     fontWeight: FontWeight.w800,
                //   ),
                // ),
                title: Text(
                  filteredvideoDetails[index]['DisplayName'],
                  style: GoogleFonts.inter().copyWith(
                    color:

                        //  selectedVideoIndex == index
                        //     ? ColorPage.white
                        //     :

                        ColorPage.colorblack,
                    fontWeight: FontWeight.w800,
                    fontSize: selectedvideoListIndex == index ? 20 : null,
                    // color: selectedListIndex == index
                    //     ? Colors.amber[900]
                    //     : Colors.black,
                  ),
                ),
                trailing: SizedBox(
                  width: 70,
                  child: Row(
                    children: [
                       downloadProgress[index] == 0 &&
                              File(getx.userSelectedPathForDownloadVideo.isEmpty
                                          ? getx.defaultPathForDownloadVideo
                                                  .value +
                                              '/' +
                                              filteredvideoDetails[index]
                                                  ['FileIdName']
                                          : getx.userSelectedPathForDownloadVideo
                                                  .value +
                                              '/' +
                                              filteredvideoDetails[index]
                                                  ['FileIdName'])
                                      .existsSync() ==
                                  false &&  getVideoPlayModeFromPackageId(
                                                                getx.selectedPackageId
                                                                    .value
                                                                    .toString()) ==
                                                            "true"?Padding(
                                                              padding: const EdgeInsets.only(right: 10),
                                                              child: InkWell(
                                                              
                                                                 onTap: () {
                                                                  getx.playLink.value =
                                                                      getx.alwaysShowChapterfilesOfVideo[
                                                                              index][
                                                                          'DocumentPath'];
                                                                        
                                                                  print(getx.alwaysShowChapterfilesOfVideo[
                                                                              index][
                                                                          'DocumentPath'] +
                                                                      "////////");
                                                                  print(getx.playLink
                                                                          .value +
                                                                      "////////////");
                                                                        
                                                                  if (getx
                                                                      .isInternet.value) {
                                                              
                                                                         fetchUploadableVideoInfo()
                                                                                                      .then((valueList) async {
                                                                                                    if (getx.isInternet.value) {
                                                                                                      unUploadedVideoInfoInsert(
                                                                                                          context,
                                                                                                          valueList,
                                                                                                          getx.loginuserdata[0].token,
                                                                                                          false);
                                                                                                    }
                                                                                                  });
                                                                                                  getx.playingVideoId.value =
                                                                                                      filteredvideoDetails[index]['FileId']
                                                                                                          .toString();
                                                                                                
                                                                                                  print(filteredvideoDetails.toString() +
                                                                                                      "////////////////////////////////////////////////////777777777777777777777777");
                                                                                                  Get.to(() => MobileVideoPlayer(
                                                                                                        videoLink: getx.playLink.value,
                                                                                                        Videoindex:
                                                                                                            findIndexInAlwaysShowChapterFiles(
                                                                                                                filteredvideoDetails[index]
                                                                ['FileId']
                                                                                                                    .toString()),
                                                                                                        videoList: filteredvideoDetails,
                                                                                                        singleplay:
                                                                                                            filteredvideoDetails.length > 1
                                                                                                                ? true
                                                                                                                : false,
                                                                                                                isPlayOnline: true,
                                                                                                      ));
                                                                        
                                                                   
                                                                   
                                                                  } else {
                                                                    onNoInternetConnection(
                                                                        context, () {
                                                                      Get.back();
                                                                    });
                                                                  }
                                                                },
                                                                child: Icon(
                                                                 
                                                                   
                                                                    Icons.play_circle_fill,
                                                                    color: ColorPage
                                                                        .colorbutton,
                                                                  
                                                                ),
                                                              ),
                                                            ):SizedBox(),
                      downloadProgress[index] == 0 &&
                              File(getx.userSelectedPathForDownloadVideo.isEmpty
                                          ? getx.defaultPathForDownloadVideo
                                                  .value +
                                              '/' +
                                              filteredvideoDetails[index]
                                                  ['FileIdName']
                                          : getx.userSelectedPathForDownloadVideo
                                                  .value +
                                              '/' +
                                              filteredvideoDetails[index]
                                                  ['FileIdName'])
                                      .existsSync() ==
                                  false
                          ? 
                              
                               InkWell(
                                onTap: () {
                                startDownload(
                                    index,
                                    filteredvideoDetails[index]['DocumentPath'],
                                    filteredvideoDetails[index]['FileIdName']);
                              },
                                 child: Icon(
                                  Icons.download,
                                  color:
                                      // selectedVideoIndex == index
                                      //     ? ColorPage.white.withOpacity(0.9)
                                      //     :
                                 
                                      ColorPage.grey,
                                                               ),
                               )
                            
                          : downloadProgress[index] < 100 &&
                                  downloadProgress[index] > 0
                              ? SizedBox(
                                  width: 50,
                                  child: Row(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 15.0,
                                        lineWidth: 4.0,
                                        percent: downloadProgress[index] / 100,
                                        center: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "${downloadProgress[index].toInt()}%",
                                            style: TextStyle(fontSize: 10.0),
                                          ),
                                        ),
                                        progressColor: ColorPage.colorbutton,
                                      ),
                                      InkWell(
                                         onTap: () {
                                          cancelDownload(index);
                                        },
                                        child: Icon(
                                         
                                          
                                            FontAwesome.close,
                                            color:
                                        
                                                // selectedVideoIndex == index
                                                //     ? ColorPage.white.withOpacity(0.9)
                                                //     :
                                        
                                                ColorPage.grey,
                                          
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : InkWell(
                                 onTap: () {
                                    fetchUploadableVideoInfo()
                                        .then((valueList) async {
                                      if (getx.isInternet.value) {
                                        unUploadedVideoInfoInsert(
                                            context,
                                            valueList,
                                            getx.loginuserdata[0].token,
                                            false);
                                      }
                                    });
                                    getx.playingVideoId.value =
                                        filteredvideoDetails[index]['FileId']
                                            .toString();
                                    getx.playLink.value = getx
                                            .userSelectedPathForDownloadVideo
                                            .isEmpty
                                        ? getx.defaultPathForDownloadVideo
                                                .value +
                                            '/' +
                                            filteredvideoDetails[index]
                                                ['FileIdName']
                                        : getx.userSelectedPathForDownloadVideo
                                                .value +
                                            '/' +
                                            filteredvideoDetails[index]
                                                ['FileIdName'];
                                    print(filteredvideoDetails.toString() +
                                        "////////////////////////////////////////////////////777777777777777777777777");
                                    Get.to(() => MobileVideoPlayer(
                                          videoLink: getx.playLink.value,
                                          Videoindex:
                                              findIndexInAlwaysShowChapterFiles(
                                                  filteredvideoDetails[index]
                                                          ['FileId']
                                                      .toString()),
                                          videoList: filteredvideoDetails,
                                          singleplay:
                                              filteredvideoDetails.length > 1
                                                  ? true
                                                  : false,
                                                  isPlayOnline: false,
                                        ));
                                  },
                                child: Icon(
                                 
                                
                                      Icons.play_circle,
                                      color:
                                
                                          //  selectedVideoIndex == index
                                          //     ? ColorPage.white.withOpacity(0.9)
                                          //     :
                                
                                          ColorPage.grey,
                                    ),
                              ),
                                
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
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
              color:
                  // selectedIndex == index ? ColorPage.colorbutton :
                  ColorPage.white,
            ),
            child: MaterialButton(
              onPressed: () {
                if (ispdf) {
                  cancelAllDownloads();

                  Get.to(
                      transition: Transition.cupertino,
                      () => ShowChapterPDFMobile(
                            pdfUrl: filteredPdfDetails[index -
                                filteredChapterDetails.length]["DocumentPath"],
                            title: filteredPdfDetails[index -
                                filteredChapterDetails.length]["FileIdName"],
                            folderName: getPackagDataFieldValuebyId(
                                filteredPdfDetails[index -
                                            filteredChapterDetails.length]
                                        ["PackageId"]
                                    .toString(),
                                "PackageName"),
                            isEncrypted: filteredPdfDetails[index -
                                            filteredChapterDetails.length]
                                        ["IsEncrypted"] ==
                                    "1"
                                ? true
                                : false,
                          ));
                  selectedIndex = index;
                } else {
                  cancelAllDownloads();

                  insertTblLocalNavigation(
                          "ParentId",
                          filteredChapterDetails[index]['SectionChapterId'],
                          filteredChapterDetails[index]['SectionChapterName'])
                      .whenComplete(
                    () {
                      getLocalNavigationDetails();
                    },
                  );

                  // getx.isVideoDashBoard.value=false;
                  getChapterContents(int.parse(
                      filteredChapterDetails[index]['SectionChapterId']));
                  getChapterFiles(
                      parentId: int.parse(
                          filteredChapterDetails[index]['SectionChapterId']),
                      'Video',
                      getx.selectedPackageId.value.toString());
                  getChapterFiles(
                      parentId: int.parse(
                          filteredChapterDetails[index]['SectionChapterId']),
                      'PDF',
                      getx.selectedPackageId.value.toString());
                  _filterLists();

                  setState(() {
                    filteredChapterDetails =
                        getx.alwaysShowChapterDetailsOfVideo;

                    filteredPdfDetails = getx.alwaysShowFileDetailsOfpdf;
                    filteredvideoDetails = getx.alwaysShowChapterfilesOfVideo;

                    selectedIndex = index;
                  });
                }
              },
              child: ListTile(
                leading: ispdf
                    ? Image.asset(
                        "assets/pdf.png",
                        width: 30,
                      )
                    : Image.asset(
                        "assets/folder5.png",
                        width: 30,
                      ),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 16,
                  color:
                      // selectedIndex == index ? ColorPage.white :
                      ColorPage.colorblack,
                ),
                title: Text(
                  ispdf
                      ? filteredPdfDetails[
                          index - filteredChapterDetails.length]["FileIdName"]
                      : filteredChapterDetails[index]['SectionChapterName'],
                  style: FontFamily.font9.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        // selectedIndex == index
                        //     ? ColorPage.white
                        //     :
                        ColorPage.colorblack,
                  ),
                ),
              ),
            ),
          );
  }

  int findIndexInAlwaysShowChapterFiles(String fileId) {
    for (int i = 0; i < getx.alwaysShowChapterfilesOfVideo.length; i++) {
      if (getx.alwaysShowChapterfilesOfVideo[i]['FileId'] == fileId) {
        return i;
      }
    }
    return -1; // Return -1 if the fileId is not found
  }
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

Widget filecountWidget(int itemcount, String imagepath) {
  return Row(
    children: [
      Image.asset(
        imagepath,
        scale: 23,
      ),
      Text(
        "(${itemcount}) ",
        style: TextStyle(fontSize: 18),
      ),
    ],
  );
}

onSweetAleartDialogwithDeny(context, VoidCallback ontap, String title,
    String subtitle, VoidCallback ondeny) async {
  await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
          showCancelBtn: false,
          denyButtonText: "Cancel",
          title: "$title",
          text: "$subtitle",
          confirmButtonText: "   Ok   ",
          onConfirm: ontap,
          onDeny: ondeny,
          type: ArtSweetAlertType.warning));
}
