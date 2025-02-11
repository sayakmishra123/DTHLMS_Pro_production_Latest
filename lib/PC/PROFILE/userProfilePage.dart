import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/API/ERROR_MASSEGE/errorhandling.dart';
import 'package:dthlms/CUSTOMDIALOG/customdialog.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/LOGIN/loginpage_mobile.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/Package_Video_dashboard.dart';
import 'package:dthlms/PC/HOMEPAGE/homepage.dart';
import 'package:dthlms/PC/LOGIN/login.dart';
import 'package:dthlms/PC/PACKAGEDETAILS/packagedetails.dart';
import 'package:dthlms/PC/testresult/test_result_page.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

bool eye = false;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Getx getx = Get.put(Getx());
  RxInt pageIndex = 0.obs;

  setProfilePicture() async {
    if (!File(getx.userImageLocalPath.value).existsSync() &&
        getx.userImageOnlinePath.value != 'null') {
      if (getx.isInternet.value) {
        downloadAndSaveImage(getx.userImageOnlinePath.value);
      }
    }
  }

  String getLoginTime(String iat) //

  {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    int time = int.parse(iat);

    final expirationDate = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return dateFormat.format(expirationDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => Row(
            children: [
              Visibility(
                visible: getx.isprofileDrawerOpen.value,
                child: SizedBox(
                  height: double.infinity,
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: ColorPage.white,
                      ),
                      // margin: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => DthDashboard());
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    "PROFILE",
                                    style: FontFamily.font2.copyWith(
                                        color: ColorPage.colorblack,
                                        fontSize: 18),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        getx.isprofileDrawerOpen.value = false;
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                      ))
                                ],
                              ),
                            ),
                            // Stack(
                            //   children: [
                            //     DrawerHeader(
                            //       curve: Curves.bounceIn,
                            //       child: CircleAvatar(
                            //         radius: 54,
                            //         backgroundColor: ColorPage.colorbutton,
                            //         child: CircleAvatar(
                            //           onBackgroundImageError:
                            //               (exception, stackTrace) =>
                            //                   Image.asset('assets/examm.png'),
                            //           radius: 50,
                            //           backgroundImage: FileImage(
                            //             File(getx.userImageLocalPath.value),
                            //           ) as ImageProvider,
                            //         ),
                            //       ),
                            //     ),
                            //     Positioned(
                            //         bottom: 25,
                            //         right: 5,
                            //         child: IconButton(
                            //           icon: Icon(Icons.edit_square),
                            //           onPressed: () {
                            //             selectImage().then((value) {
                            //               if (value != 'null') {
                            //                 uploadImage(
                            //                         File(value!),
                            //                         getx.loginuserdata[0].token,
                            //                         context)
                            //                     .then((imageOnlinePath) {
                            //                   changeProfileDetails(
                            //                       getx.loginuserdata[0].token,
                            //                       "|",
                            //                       context,
                            //                       getx.loginuserdata[0]
                            //                           .username,
                            //                       getx.loginuserdata[0]
                            //                           .firstName,
                            //                       getx.loginuserdata[0]
                            //                           .lastName,
                            //                       getx.loginuserdata[0].email,
                            //                       getx.userProfileDocumentId
                            //                           .value
                            //                           .toString(),
                            //                       getx.loginuserdata[0]
                            //                           .phoneNumber);

                            //                   if (imageOnlinePath != 'null') {
                            //                     downloadAndSaveImage(
                            //                         imageOnlinePath);
                            //                   }
                            //                 });
                            //               }
                            //             });
                            //           },
                            //         ))
                            //   ],
                            // ),
                            SizedBox(height: 20),

                            _buildDrawerItem(
                                Icons.person_outline_rounded, 'Details', () {
                              pageIndex.value = 0;
                            }, pageIndex.value == 0 ? true : false),
                            _buildDrawerItem(Icons.feed_outlined, 'My Packages',
                                () {
                              pageIndex.value = 1;
                            }, pageIndex.value == 1 ? true : false),
                            _buildDrawerItem(
                                Icons.lock_outline_rounded, 'Change password',
                                () {
                              pageIndex.value = 2;
                            }, pageIndex.value == 2 ? true : false),
                            _buildDrawerItem(
                                Icons.feedback_outlined, 'Feedback', () {
                              pageIndex.value = 3;
                            }, pageIndex.value == 3 ? true : false),
                            _buildDrawerItem(
                                Icons.privacy_tip_outlined, 'Privacy Policy',
                                () {
                              pageIndex.value = 4;
                            }, pageIndex.value == 4 ? true : false),
                            _buildDrawerItem(
                                Icons.settings_outlined, "App Setting", () {
                              pageIndex.value = 5;
                              // showDialog(
                              //   context: context,
                              //   builder: (context) => AppSettings(),
                              // );

                              // Get.defaultDialog(

                              //   backgroundColor: ColorPage.white,
                              // content: Container(
                              //     // color: ColorPage.white,
                              //     width:
                              //         MediaQuery.sizeOf(context).width - 1000,
                              //     child: AppSettings()),
                              // );

                              showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: 'Dismiss',
                                  // The color behind the dialog; semi-transparent so background is still visible
                                  barrierColor: Colors.black.withOpacity(0.2),
                                  // The actual page to build
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return BackdropFilter(
                                      // Apply a Gaussian blur
                                      filter: ImageFilter.blur(
                                          sigmaX: 5, sigmaY: 5),
                                      child: Center(
                                        child: Material(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Container(
                                              // color: ColorPage.white,
                                              width: 600,
                                              child: AppSettings()),
                                        ),
                                      ),
                                    );
                                  });
                            }, pageIndex.value == 5 ? true : false),
                            _buildDrawerItem(Icons.help_outline_rounded,
                                "FAQ's", () {
                              pageIndex.value = 6;
                            }, pageIndex.value == 6 ? true : false),
                            // _buildDrawerItem(Icons.history, "History", () {
                            //   pageIndex.value = 7;
                            // }, pageIndex.value == 7 ? true : false),
                            _buildDrawerItem(
                                Icons.devices_rounded, "Device History", () {
                              pageIndex.value = 8;
                            }, pageIndex.value == 8 ? true : false),

                            //  <--------------  Don't remove it by (Sayak Mishra) --------------------->
                            // _buildDrawerItem(
                            //     Icons.history_sharp, "Exam History", () {
                            //   pageIndex.value = 9;
                            // }, pageIndex.value == 9 ? true : false),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            !getx.isprofileDrawerOpen.value
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: IconButton(
                                        onPressed: () {
                                          getx.isprofileDrawerOpen.value = true;
                                        },
                                        icon: Icon(Icons.list,
                                            color: Colors.black)),
                                  )
                                : SizedBox(),
                            // pageIndex.value != 7 && pageIndex.value != 9
                            //     ?
                            //      Padding(
                            //         padding: const EdgeInsets.only(right: 20),
                            //         child: Container(
                            //           margin: EdgeInsets.symmetric(vertical: 5),
                            //           width: 300,
                            //           height: 80,
                            //           child: TextFormField(
                            //             decoration: InputDecoration(
                            //               alignLabelWithHint: true,
                            //               contentPadding:
                            //                   EdgeInsetsDirectional.symmetric(
                            //                       horizontal: 20),
                            //               hintText: 'Search',
                            //               hintStyle:
                            //                   TextStyle(color: Colors.black45),
                            //               fillColor: Color.fromARGB(
                            //                   255, 255, 255, 255),
                            //               filled: true,
                            //               suffixIcon: Padding(
                            //                 padding: const EdgeInsets.only(
                            //                     right: 10),
                            //                 child: Icon(
                            //                   Icons.search,
                            //                   color: Color.fromARGB(
                            //                       255, 98, 96, 96),
                            //                 ),
                            //               ),
                            //               border: OutlineInputBorder(
                            //                 borderSide: BorderSide.none,
                            //                 borderRadius:
                            //                     BorderRadius.circular(40),
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //     : SizedBox(
                            //         height: 10,
                            //       ),
                          ],
                        ),
                        pages[pageIndex.value],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> downloadAndSaveImage(String imageUrl) async {
    try {
      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Extract the file name from the URL
      final uri = Uri.parse(imageUrl);
      final fileName = uri.pathSegments.last;

      // Define the path where you want to save the image using the extracted file name
      final filePath = '${directory.path}/Dthlms_profile_iamge/$fileName';

      // Use Dio to download the image
      Dio dio = Dio();
      await dio.download(imageUrl, filePath);
      getx.loginuserdata[0].image = filePath;

      print('Image downloaded and saved to: $filePath');
      getx.userImageLocalPath.value = filePath;
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("LocalImagePath", filePath);
    } catch (e) {
      writeToFile(e, "downloadAndSaveImage");
      print('Error downloading or saving the image: $e');
    }
  }

  Future<String?> selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Restrict to images only
      allowMultiple: false, // Allow only a single file
    );

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        print('Selected image path: $filePath');
        return filePath;
      } else {
        print('No path found.');
        return 'null';
      }
    } else {
      print('No image selected.');
      return 'null';
    }
  }

  Widget _buildDrawerItem(
      IconData icon, String title, VoidCallback onTap, bool IsSelected) {
    return MaterialButton(
      color: IsSelected ? ColorPage.mainBlue : null,
      padding: EdgeInsets.symmetric(vertical: 20),
      onPressed: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: IsSelected ? Colors.white : ColorPage.iconColor,
        ),
        title: Text(
          title,
          style: FontFamily.style
              .copyWith(fontSize: 14, color: IsSelected ? Colors.white : null),
        ),
        trailing: Icon(Icons.keyboard_arrow_right_rounded),
      ),
    );
  }

  List<Widget> pages = [
    DetailsWidget(),
    MyPackage(),
    ChangePasswordWidget(),
    FeedbackWidget(),
  PrivacyPollicyWidget(),
    Container(
      color: Colors.transparent,
    ),
    // AppSettings(),
    NeedHelp(),
    HistoryDashboard(),
    DeviceHistory(),
    ExamHistory(),
  
  ];
}

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  // TextEditingControllers for your paths
  final TextEditingController videoDownloadPath = TextEditingController();
  final TextEditingController pdfDownloadPath = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getPaths();
  }

  // Example: Pick Video Path
  Future<void> _pickVideoPath() async {
    final String? selectedDirectory = await getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        videoDownloadPath.text = selectedDirectory;
        // getx.userSelectedPathForDownloadVideo.value = selectedDirectory; // if using getx
      });
    }
  }

  // Example: Pick PDF Path
  Future<void> _pickPdfPath() async {
    final String? selectedDirectory = await getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        pdfDownloadPath.text = selectedDirectory;
        // getx.userSelectedPathForDownloadFile.value = selectedDirectory; // if using getx
      });
    }
  }

  // Confirm Restore
  void _restore() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Restore to Default',
          description:
              'Are you sure you want to restore all paths to default settings? '
              'This action cannot be undone. All downloaded videos will be lost.',
          OnCancell: () {
            Navigator.of(context).pop();
          },
          OnConfirm: (String reason) {
            Navigator.of(context).pop();
            _restoreToDefaultPaths();
          },
          btn1: 'Cancel',
          btn2: 'Restore',
          linkText: 'Learn more',
          isTextfeild: false,
        );
      },
    );
  }

  // Restore to Defaults
  void _restoreToDefaultPaths() async {
    var prefs = await SharedPreferences.getInstance();
    videoDownloadPath.text = prefs.getString("DefaultDownloadpathOfVieo") ?? '';
    pdfDownloadPath.text = prefs.getString("DefaultDownloadpathOfFile") ?? '';
  }

  // Retrieve Saved Paths
  Future<void> _getPaths() async {
    try {
      var prefs = await SharedPreferences.getInstance();

      // Retrieve the saved or default paths
      String? videoPath = prefs.getString('SelectedDownloadPathOfVieo') ??
          prefs.getString("DefaultDownloadpathOfVieo");
      String? filePath = prefs.getString('SelectedDownloadPathOfFile') ??
          prefs.getString("DefaultDownloadpathOfFile");

      setState(() {
        if (videoPath != null) {
          videoDownloadPath.text = videoPath;
        }
        if (filePath != null) {
          pdfDownloadPath.text = filePath;
        }
      });
    } catch (e) {
      writeToFile(e, "_getPaths");
      debugPrint("Path not found: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen width at runtime
    final screenWidth = MediaQuery.of(context).size.width;
    // You can tweak this breakpoint (e.g., 600, 800, 900) based on your design
    final bool isSmallScreen = screenWidth < 600;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // If the available width is small, stack items in a Column
            if (constraints.maxWidth < 600) {
              return _buildColumnLayout(context);
            } else {
              // Otherwise, use a Row layout
              return _buildRowLayout(context);
            }
          },
        ),
      ),
    );
  }

  // Build Column Layout (Mobile / Small Screen)
  Widget _buildColumnLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Form Container
        _buildFormContainer(context),
        // Optionally, you could place a "right-side" content below
        // if you ever un-comment your FAQ container, etc.
      ],
    );
  }

  // Build Row Layout (Larger Screen)
  Widget _buildRowLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Left side - Form fields
        _buildFormContainer(context),
        const SizedBox(width: 16),
        // Right side - FAQ or additional info (if you have it)
        // _buildFAQContainer(context), // Currently commented out
      ],
    );
  }

  // The form container that holds your settings fields
  Widget _buildFormContainer(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: ColorPage.white, // Ensure you have defined ColorPage.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header Row
            Row(
              children: [
                Text(
                  'App Setting',
                  style: FontFamily.styleb.copyWith(
                    color: const Color.fromARGB(255, 68, 68, 68),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: "Restore",
                  onPressed: _restore,
                  icon: const Icon(Icons.settings_backup_restore),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Video Path
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Video Download Path',
                style: FontFamily.styleb.copyWith(
                  fontSize: 15,
                  color: const Color.fromARGB(255, 68, 68, 68),
                ),
              ),
            ),
            TextFormField(
              readOnly: true, // Prevent manual editing
              onTap: _pickVideoPath, // Open folder picker on tap
              decoration: InputDecoration(
                hintText: 'Select Video Download Path',
                suffixIcon: Icon(
                  Icons.folder,
                  color: Colors.grey[600],
                ),
                hintStyle:
                    FontFamily.style.copyWith(fontSize: 15, color: Colors.grey),
              ),
              controller: videoDownloadPath,
            ),
            const SizedBox(height: 20),

            /// PDF Path
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'File Download Path',
                style: FontFamily.styleb.copyWith(
                  fontSize: 15,
                  color: Color.fromARGB(255, 68, 68, 68),
                ),
              ),
            ),
            TextFormField(
              readOnly: true, // Prevent manual editing
              onTap: _pickPdfPath, // Open folder picker on tap
              decoration: InputDecoration(
                hintText: 'Select PDF Download Path',
                suffixIcon: Icon(
                  Icons.folder,
                  color: Colors.grey[600],
                ),
                hintStyle:
                    FontFamily.style.copyWith(fontSize: 15, color: Colors.grey),
              ),
              controller: pdfDownloadPath,
            ),
            const SizedBox(height: 40),

            /// Save Button
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 50,
                    color: ColorPage.mainBlue,
                    onPressed: () async {
                      var prefs = await SharedPreferences.getInstance();
                      prefs.setString(
                        "SelectedDownloadPathOfVieo",
                        videoDownloadPath.text,
                      );
                      prefs.setString(
                        "SelectedDownloadPathOfFile",
                        pdfDownloadPath.text,
                      );

                      // Example: Toast or SnackBar
                      // FlutterToastr.show("Path saved successfully", context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Path saved successfully.')),
                      );
                    },
                    child: Text(
                      'Save',
                      style: FontFamily.style.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // If you have a "right container" (e.g., FAQ or anything else),
  // define it here and display it in _buildRowLayout if needed.
  // Widget _buildFAQContainer(BuildContext context) {
  //   return Container(
  //     // ...
  //   );
  // }

  // Example of a leftover method from your snippet
  // If you want a custom confirmation box using "rflutter_alert" or similar:
  _logoutConfirmetionBox(BuildContext context) {
    // ...
  }
}

class DetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Container for form fields
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: ColorPage.white,
                // Uncomment below if you want to add shadow
                // boxShadow: [
                //   BoxShadow(
                //       blurRadius: 3,
                //       color: Color.fromARGB(255, 157, 157, 157)),
                // ],
              ),
              child: PersonalDetails(), // Make sure this widget is defined
            ),
            // Right Container for FAQs (currently commented out)
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_platform_widgets/flutter_platform_widgets.dart'; // for platform checks

class MyPackage extends StatefulWidget {
  const MyPackage({Key? key}) : super(key: key);

  @override
  State<MyPackage> createState() => _MyPackageState();
}

class _MyPackageState extends State<MyPackage> {
  Getx getx = Get.put(Getx());
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isAndroid = Platform.isAndroid;

    return Container(
      height: screenHeight - 100,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left Container for form fields
          Container(
            width: Platform.isAndroid ? screenWidth : screenWidth / 2.3,
            // constraints: BoxConstraints(
            //     maxWidth: screenWidth > 600
            //         ? 700
            //         : screenWidth), // Adjust width based on screen size
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: ColorPage.white, // Ensure ColorPage.white is defined
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Package Title
                  Platform.isAndroid
                      ? SizedBox()
                      : Row(
                          children: [
                            Text(
                              'My Packages',
                              style: FontFamily.styleb.copyWith(
                                  color: Color.fromARGB(255, 68, 68, 68)),
                            ),
                          ],
                        ),
                  SizedBox(height: 5),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: getx.studentAllPackage.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: InkWell(
                            hoverColor: Colors.red,
                            onTap: () async {},
                            child: MouseRegion(
                              child: Obx(
                                () => Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12, // Lighter shadow
                                        offset: Offset(0, 4),
                                        blurRadius: 6,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    color: checkVaildationOfPackage(
                                         getx.studentAllPackage[index]['PausedUpto']??"2020-02-08T12:47:52.487")
                                        ? Color.fromARGB(223, 244, 222, 187)
                                        : Color.fromARGB(255, 255, 255,
                                            255), // Default color
                                  ),
                                  child: ExpansionTile(
                                    trailing:  checkVaildationOfPackage(
                                         getx.studentAllPackage[index]['PausedUpto']??"2020-02-08T12:47:52.487") &&getx.studentAllPackage[index]
                                                  ['IsFree'] ==
                                              "false"
                                        ? Icon(Icons.gpp_maybe)
                                        : Icon(Icons.arrow_drop_down),
                                    children: [
                                       checkVaildationOfPackage(
                                         getx.studentAllPackage[index]['PausedUpto']??"2020-02-08T12:47:52.487") && getx.studentAllPackage[index]
                                                  ['IsFree'] ==
                                              "false"
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    "Subscription of this Package is currently paused!")
                                              ],
                                            )
                                          :     !checkVaildationOfPackage(
                                         getx.studentAllPackage[index]['PausedUpto']??"2020-02-08T12:47:52.487") && getx.studentAllPackage[index]
                                                  ['IsFree'] ==
                                              "false" && int.parse(getx.studentAllPackage[index]
                                                  ['Pausedays'] )>1
                                              ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  height:
                                                      40, // Height of the button
                                                  width:
                                                      140, // Width of the button
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 255, 64, 64),
                                                        Color.fromARGB(
                                                            255, 255, 89, 125)
                                                      ], // Lighter colors
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    borderRadius: BorderRadius
                                                        .circular(Platform
                                                                .isAndroid
                                                            ? 5
                                                            : 10), // Reduced radius
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .black12, // Lighter shadow
                                                        offset: Offset(0, 4),
                                                        blurRadius: 6,
                                                      ),
                                                    ],
                                                  ),
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      _showValuePicker(
                                                        getx.studentAllPackage[
                                                            index]['packageId'],
                                                        getx.studentAllPackage[
                                                                index]
                                                            ['ExpiryDate'],
                                                            double.parse(getx.studentAllPackage[index]
                                                  ['Pausedays'] )
                                                      );
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      "Pause Subscription",
                                                      style: TextStyle(
                                                        color: Colors
                                                            .white, // Text color
                                                        fontSize:
                                                            10, // Font size
                                                        fontWeight: FontWeight
                                                            .bold, // Font weight
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ): SizedBox(),
                                    ],
                                    shape:
                                        Border.all(color: Colors.transparent),
                                    leading: Container(
                                      width: 65,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: AssetImage("$logopath"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: SizedBox(),
                                    ),
                                    subtitle: Text(
                                      "Validate till: ${formatDateString(getx.studentAllPackage[index]['ExpiryDate'], "datetime")}",
                                      style: FontFamily.style.copyWith(
                                          color: Colors.grey[400],
                                          fontSize:
                                              Platform.isAndroid ? 10 : 14),
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          getx.studentAllPackage[index]
                                              ['packageName'],
                                          style: FontFamily.styleb.copyWith(
                                              fontSize:
                                                  Platform.isAndroid ? 12 : 20,
                                              color: Color.fromARGB(
                                                  221, 53, 53, 53)),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showValuePicker(String packageId, String expirydate, double maxpauseDays) {
    final valueController = Get.put(ValueController());
    valueController.selectedValue.value = 1;

    // Show the RFlutterAlert dialog
    Alert(
      context: Get.context!,
      type: AlertType.none,
      title: "Select how many days you want to pause your Subscription",
      content: Column(
        children: [
          SizedBox(height: 10),
          SleekCircularSlider(
            initialValue: 1,
            min: 1,
            max: maxpauseDays,
            onChange: (double value) {
              valueController.selectedValue.value = value;
            },
            innerWidget: (value) {
              return Center(
                child: Text(
                  "Pause for\n   ${value.toInt()} days",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            },
            appearance: CircularSliderAppearance(
              customWidths: CustomSliderWidths(
                trackWidth: 10,
                progressBarWidth: 12,
                handlerSize: 15,
              ),
              customColors: CustomSliderColors(
                progressBarColor: Colors.blueAccent,
                trackColor: Colors.grey.shade300,
                dotColor: Colors.blueAccent,
              ),
              size: 200,
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            onSweetAleartDialogwithDeny(
              context,
              () {
                pauseSubscription(context,getx.loginuserdata[0].token,packageId,valueController.selectedValue.toInt().toString()).then((value) {
                
                   onPauseSuccessfull(
                      context, valueController.selectedValue.toInt(), () {
                    Get.back();
                    Get.back();
                    Get.back();
                    getAllPackageListOfStudent();
                  },value);
                 
                });
              },
              "Are You Sure?",
              "You want to Pause your subscription!",
              () {
                Navigator.of(context).pop();
              },
            );
            print("Value confirmed: ${valueController.selectedValue.toInt()}");
          },
          child: Text(
            "Confirm",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          color: Colors.blueAccent,
        ),
      ],
    ).show();
  }
}

class ValueController extends GetxController {
  var selectedValue = 1.0.obs; // Make it observable (Rx variable)
}

class CircularSliderPainter extends CustomPainter {
  final double value;
  CircularSliderPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    Paint activePaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    // Draw the background circle (inactive track)
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height), radius: size.width / 2),
      pi, // Start angle (half-circle)
      pi, // Sweep angle (half-circle)
      false,
      paint,
    );

    // Draw the active part of the circle (filled portion)
    double sweepAngle =
        (pi * (value - 1) / 29); // Value proportional to the arc
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height), radius: size.width / 2),
      pi, // Start angle
      sweepAngle, // Sweep angle based on the value
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//  Expanded(
//               flex: 6,
//               child: Container(
//                 margin: EdgeInsets.only(left: 10, right: 10),
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                   color: ColorPage.white,
//                   // boxShadow: [
//                   //   BoxShadow(
//                   //       blurRadius: 3,
//                   //       color: Color.fromARGB(
//                   //           255, 157, 157, 157))
//                   // ]
//                 ),
//                 child: FAQWidget(),
//               ),
//             ),
class ChangePasswordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Container for form fields
            Container(
              constraints: BoxConstraints(maxWidth: 700),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: ColorPage.white,
                // Uncomment below if you want to add shadow
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 3,
                //     color: Color.fromARGB(255, 157, 157, 157),
                //   ),
                // ],
              ),
              child: ChangePasswordBox(),
            ),
            // Right Container for FAQs (currently commented out)
            // Expanded(
            //   child: Container(
            //     margin: EdgeInsets.only(left: 10, right: 10),
            //     padding: EdgeInsets.all(16),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(10)),
            //       color: ColorPage.white,
            //       // Uncomment below if you want to add shadow
            //       // boxShadow: [
            //       //   BoxShadow(
            //       //     blurRadius: 3,
            //       //     color: Color.fromARGB(255, 157, 157, 157),
            //       //   ),
            //       // ],
            //     ),
            //     child: SecendWidget(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';

class MangaeAccountWidget extends StatefulWidget {
  @override
  _MangaeAccountWidgetState createState() => _MangaeAccountWidgetState();
}

class _MangaeAccountWidgetState extends State<MangaeAccountWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Container for Logout and Delete Account buttons
            Container(
              height: MediaQuery.of(context).size.height*0.8,
              width: MediaQuery.of(context).size.width*0.5 ,
              constraints: BoxConstraints(maxWidth: 700),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Color.fromARGB(255, 157, 157, 157),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logout Button
                  ElevatedButton(
                    onPressed: () {
                      // Add logout functionality here
                      print("User logged out");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "Logout",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20), // Spacing between buttons
                  // Delete Account Button
                  ElevatedButton(
                    onPressed: () {
                      // Add delete account functionality here
                      print("Account deletion requested");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Background color
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "Delete Account",
                      style: TextStyle(fontSize: 18),
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
}


class FeedbackWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Container for form fields
            Container(
              constraints: BoxConstraints(maxWidth: 700),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: ColorPage.white,
                // Uncomment below if you want to add shadow
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 3,
                //     color: Color.fromARGB(255, 157, 157, 157),
                //   ),
                // ],
              ),
              child: FeedbackBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackBox extends StatefulWidget {
  const FeedbackBox({super.key});

  @override
  State<FeedbackBox> createState() => _FeedbackBoxState();
}

TextEditingController feedBackController  =TextEditingController();
double starCount=5.0;


class _FeedbackBoxState extends State<FeedbackBox> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate 20% of the width for padding
        double horizontalPadding = constraints.maxWidth * 0.05;
        double h = constraints.maxHeight * 0.08;

        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xffF8FBFF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Image(
                        image: AssetImage(
                          'assets/speech-bubble.png',
                        ),
                        height:
                            25, // Uncomment if you want to specify the height
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10), // Add some space between the rows
                Row(
                  children: [
                    Text(
                      'Feedback',
                      style: FontFamily.styleb,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Please rate your experience below',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    )),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: RatingBar.builder(
                        initialRating: 5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                          starCount=rating;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Row(
                  children: [
                    Text(
                      'Additional feedback',
                      style: FontFamily.styleb.copyWith(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 5),

                // Current Password
                FeedbackTextField(feedbackController: feedBackController,),
                SizedBox(height: 50),

                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        height: 80,
                        color: ColorPage.mainBlue,
                        onPressed: () {

                       

if(getx.isInternet.value){
  uploadStudentFeedBackOfApp(context,getx.loginuserdata[0].token,feedBackController.text,starCount.toString()).then((value){


    if(value){
      onSweetAleartDialog(context,(){
         Get.back();

      },"successfully submitted","Thank you for your feedback 😊",true);
    }
    else{
         onSweetAleartDialog(context,(){
          Get.back();

      },"Something went wrong!","",false);
    }
  });

}
else{
  onNoInternetConnection(context, (){
    Get.back();
  });
}


                        },
                        child: Text(
                          'Submit feedback',
                          style: FontFamily.style.copyWith(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class FeedbackTextField extends StatefulWidget {
    TextEditingController feedbackController;

   FeedbackTextField({required this.feedbackController});
  @override
  State<FeedbackTextField> createState() => _FeedbackTextFieldState();
}

initState(

  
) {
 
 
  // TODO: implement initState
  
}


class _FeedbackTextFieldState extends State<FeedbackTextField> {
 
 
  @override
  Widget build(BuildContext context) {
  
    return Padding(
      padding: const EdgeInsets.all(16.0), // Adjust padding as needed
      child: TextFormField(
        controller: widget.feedbackController ,

        maxLines: 4,
        
        // initialValue: 'My feedback!!', // Initial text as per the image
        // Adjust the number of lines as needed
        decoration: InputDecoration(
          // labelText: 'Additional feedback',
          alignLabelWithHint: true, // Align label with the hint text
          hintText: "My feedBack!!",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            borderSide: BorderSide(
              color: Colors.grey, // Outline border color
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            borderSide: BorderSide(
              color:
                  Colors.grey.withOpacity(0.5), // Grey color for enabled border
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            borderSide: BorderSide(
              color: ColorPage.mainBlue, // Blue color when focused
              width: 2.0, // Border width when focused
            ),
          ),
        ),
        style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800]), // Text style inside the field
      ),
    );
  }
}

Widget _privacyPolicy() {
  return Container(
    child: Center(
      child: Text(
        'Privacy Policy',
        style: FontFamily.styleb,
      ),
    ),
  );
}


class PrivacyPollicyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Container for form fields
            Container(
              constraints: BoxConstraints(maxWidth: 700),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: ColorPage.white,
                // Uncomment below if you want to add shadow
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 3,
                //     color: Color.fromARGB(255, 157, 157, 157),
                //   ),
                // ],
              ),

              child: Center(child: Text("Privacy Policy"),),
              // child: FeedbackBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceHistory extends StatefulWidget {
  const DeviceHistory({super.key});

  @override
  State<DeviceHistory> createState() => _DeviceHistoryState();
}

class _DeviceHistoryState extends State<DeviceHistory> {
  Getx getx = Get.put(Getx());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   padding: EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //       color: const Color.fromARGB(255, 63, 164, 247),
            //       borderRadius: BorderRadius.circular(8)),
            //   child: Text(
            //     'Device List',
            //     style: GoogleFonts.aBeeZee(
            //         textStyle: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 16,
            //             color: Colors.black)),
            //   ),
            // ),
            _buildFilterBar(),
            SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: _buildDeviceList(),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildDeviceList() {
    return FutureBuilder(
      future: getDeviceLoginHistory(context, getx.loginuserdata[0].token),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics:
                NeverScrollableScrollPhysics(), // Allows scrolling within this widget
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 249, 249),
                        border: Border.all(color: Colors.grey, width: 0.2)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            width: 95,
                            child: Row(
                              children: [
                                getPlatformIcon(
                                    getx.DeviceLoginHistorylist[index]
                                        .deviceType,
                                    false),
                                SizedBox(
                                  width: 10,
                                ),
                                getx.DeviceLoginHistorylist[index].isLoggedIn
                                    ? Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: 8,
                                            height: 8,
                                          ),
                                          Text(
                                            ' Active',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 10),
                                          )
                                        ],
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 210,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () async {
                              await ArtSweetAlert.show(
                                  barrierDismissible: false,
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                      denyButtonText: "Cancel",
                                      title: "Device ID",
                                      text: getx.DeviceLoginHistorylist[index]
                                                  .deviceId1 !=
                                              ""
                                          ? getx.DeviceLoginHistorylist[index]
                                              .deviceId1
                                              .toString()
                                              .replaceAll('{', '')
                                              .replaceAll('}', '')
                                          : 'No device id available',
                                      confirmButtonText: "Copy",
                                      onConfirm: () {
                                        // if(response.isTapConfirmButton)
                                        if (getx.DeviceLoginHistorylist[index]
                                                .deviceId1 !=
                                            "") {
                                          Clipboard.setData(
                                            ClipboardData(
                                                text: getx
                                                    .DeviceLoginHistorylist[
                                                        index]
                                                    .deviceId1
                                                    .replaceAll('{', '')
                                                    .replaceAll('}', '')),
                                          );
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Device Id Copied to clipboard!'),
                                            ),
                                          );
                                        }
                                      },
                                      type: ArtSweetAlertType.info));

                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return AlertDialog(
                              //       title: Text(
                              //         'Device ID',
                              //         style: GoogleFonts.aBeeZee(
                              //             textStyle: TextStyle(
                              //                 fontWeight: FontWeight.bold,
                              //                 fontSize: 15)),
                              //       ),
                              //       content: Column(
                              //         mainAxisSize: MainAxisSize.min,
                              //         children: [
                              //           SizedBox(height: 10),
                              //           Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Expanded(
                              //                 child: SelectableText(
                              // getx
                              //             .DeviceLoginHistorylist[
                              //                 index]
                              //             .deviceId1 !=
                              //         ""
                              //     ? getx
                              //         .DeviceLoginHistorylist[
                              //             index]
                              //         .deviceId1
                              //         .toString()
                              //         .replaceAll('{', '')
                              //         .replaceAll('}', '')
                              //     : 'No device id available',
                              //                   style: TextStyle(
                              //                     fontSize: 16,
                              //                     color: Colors.black87,
                              //                   ),
                              //                 ),
                              //               ),
                              //               SizedBox(width: 10),
                              //               IconButton(
                              //                 icon: Icon(
                              //                   Icons.copy,
                              //                   color: Colors.blueAccent,
                              //                 ),
                              //                 onPressed: () {
                              // if (getx
                              //         .DeviceLoginHistorylist[
                              //             index]
                              //         .deviceId1 !=
                              //     "") {
                              //   Clipboard.setData(
                              //     ClipboardData(
                              //         text: getx
                              //             .DeviceLoginHistorylist[
                              //                 index]
                              //             .deviceId1
                              //             .replaceAll('{', '')
                              //             .replaceAll(
                              //                 '}', '')),
                              //   );
                              //   Navigator.of(context).pop();
                              //   ScaffoldMessenger.of(context)
                              //       .showSnackBar(
                              //     SnackBar(
                              //       content: Text(
                              //           'Device Id Copied to clipboard!'),
                              //     ),
                              //   );
                              //                   }
                              //                 },
                              //               ),
                              //             ],
                              //           ),
                              //         ],
                              //       ),
                              //       actions: [
                              //         TextButton(
                              //           onPressed: () {
                              //             Navigator.of(context).pop();
                              //           },
                              //           child: Text(
                              //             'Close',
                              //             style: TextStyle(
                              //               color: Colors.redAccent,
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     );
                              //   },
                              // );
                            },
                            child: Text(
                              getx.DeviceLoginHistorylist[index].deviceName,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aBeeZee(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11)),
                            ),
                          ),
                        ),
                        // if (getx.DeviceLoginHistorylist[index].allotedOn !=
                        //     null)
                        getx.DeviceLoginHistorylist[index].isLoggedIn
                            ? _buildFilterListButton(
                                getLoginTime(
                                    getx.loginuserdata[0].loginTime)[1],
                                getLoginTime(
                                    getx.loginuserdata[0].loginTime)[0])
                            : _buildFilterListButton(
                                DateFormat('dd-MM-yyyy').format(getx
                                    .DeviceLoginHistorylist[index].allotedOn),
                                DateFormat('hh:mm:ss a').format(getx
                                    .DeviceLoginHistorylist[index].allotedOn),
                              ),
                        // if (getx.DeviceLoginHistorylist[index].logoutTime !=
                        //     null)
                        _buildFilterListButton(
                            getx.DeviceLoginHistorylist[index].logoutTime !=
                                    null
                                ? DateFormat('dd-MM-yyyy').format(getx
                                    .DeviceLoginHistorylist[index].logoutTime)
                                : "",
                            getx.DeviceLoginHistorylist[index].logoutTime !=
                                    null
                                ? DateFormat('hh:mm:ss a').format(getx
                                    .DeviceLoginHistorylist[index].logoutTime)
                                : '',
                            mode: 1),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  List<String> getLoginTime(String iat) {
    int time = int.parse(iat);

    // Convert Unix timestamp to DateTime
    final expirationDate = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    // Define separate formats for time and date
    final timeFormat = DateFormat('hh:mm:ss a');
    final dateFormat = DateFormat('dd-MM-yyyy');

    // Format the time and date
    String formattedTime = timeFormat.format(expirationDate);
    String formattedDate = dateFormat.format(expirationDate);

    // Combine time and date into the desired format
    return [formattedTime, formattedDate];
  }

  Widget _buildFilterListButton(String label, String sublabel, {int mode = 0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label != "" ? label : 'No logout',
              textAlign: TextAlign.center,
              style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: mode == 1 ? Colors.orange : null)),
            ),
            Text(
              sublabel != "" ? sublabel : ' ',
              textAlign: TextAlign.center,
              style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: 40,
          ),
        ),
        _buildFilterButton('Device Name'),
        _buildFilterButton('Last login'),
        _buildFilterButton('Last logout'),
      ],
    );
  }

  Widget _buildFilterButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 200,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          )),
        ),
      ),
    );
  }

  Icon getPlatformIcon(String platform, bool isActive) {
    switch (platform.toLowerCase()) {
      case 'android':
        return Icon(Icons.android,
            size: 30, color: isActive ? ColorPage.green : Colors.grey);
      case 'ios':
        return Icon(Icons.apple,
            size: 30, color: isActive ? ColorPage.green : Colors.grey);
      case 'windows':
        return Icon(Icons.desktop_windows_outlined,
            size: 30, color: isActive ? ColorPage.green : Colors.grey);
      case 'macos':
        return Icon(Icons.laptop_mac,
            size: 30, color: isActive ? ColorPage.green : Colors.grey);
      default:
        return Icon(Icons.device_unknown,
            size: 30, color: isActive ? ColorPage.green : Colors.grey);
    }
  }
}

class NeedHelp extends StatelessWidget {
  const NeedHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(maxWidth: 700),
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: ColorPage.white,
          // boxShadow: [
          //   BoxShadow(
          //       blurRadius: 3,
          //       color: Color.fromARGB(
          //           255, 157, 157, 157))
          // ]
        ),
        child: FAQWidget(),
      ),
    );
  }
}

class FAQWidget extends StatelessWidget {
  final List<Map<String, String>> faqData = [
    {
      'question': 'Do I need to register with 6Degree to place orders?',
      'answer':
          'Register simply by setting up an email address and a password. Sign in to view what is already in your shopping cart. You can also opt to sign in using Facebook, Google, or Instagram.',
    },
    {
      'question': 'How do I register?',
      'answer':
          'Register simply by setting up an email address and a password. Sign in to view what is already in your shopping cart. You can also opt to sign in using Facebook, Google, or Instagram.',
    },
    {
      'question': 'I have forgotten my password. How do I change it?',
      'answer':
          'You can reset your password by following the instructions provided in the "Forgot Password" section.',
    },
    {
      'question': 'How can I change my personal details or shipping address?',
      'answer':
          'You can change your personal details or shipping address in the "My Account" section after logging in.',
    },
    {
      'question': 'How do I select my size?',
      'answer':
          'You can refer to the size chart available on the product page.',
    },
    {
      'question': 'Does 6Degree provide alterations?',
      'answer': 'Yes, alterations can be requested for certain products.',
    },
    {
      'question':
          'I need help to decide what to buy, can I speak to a stylist?',
      'answer':
          'Yes, you can consult with a stylist by contacting customer support.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("FAQ's",
                  style: FontFamily.style.copyWith(
                      fontSize: 25,
                      color: Colors.black45,
                      fontWeight: FontWeight.w900)),
            ],
          ),

          // SizedBox(
          //   height: 30,
          // ),
          // Text(
          //   'Need answers? Find them here...',
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.grey,
          //   ),
          // ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: faqData.length,
              itemBuilder: (context, index) {
                final faqItem = faqData[index];
                return _buildExpansionTile(
                  faqItem['question']!,
                  faqItem['answer']!,
                  context,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile(
      String title, String content, BuildContext context) {
    return ExpansionTile(
      shape: Border.all(color: Colors.transparent),
      leading: Icon(
        Icons.circle,
        size: 10,
      ),
      title: Text(
        title,
        style: FontFamily.styleb.copyWith(fontSize: 15, color: Colors.black54),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 40,
              ),
              Expanded(
                child: Text(
                  content,
                  textAlign: TextAlign.left,
                  style: FontFamily.font9
                      .copyWith(color: ColorPage.colorblack, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChangePasswordBox extends StatefulWidget {
  @override
  State<ChangePasswordBox> createState() => _ChangePasswordBoxState();
}

class _ChangePasswordBoxState extends State<ChangePasswordBox> {
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate 20% of the width for padding
        double horizontalPadding = constraints.maxWidth * 0.05;
        double h = constraints.maxHeight * 0.08;

        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: h),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xffF8FBFF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image(
                          image: AssetImage('assets/lock.png'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Change Password',
                        style: FontFamily.styleb,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'To change your password, please fill in the fields below. Your password must contain at least 8 characters, and it must also include at least one uppercase letter, one lowercase letter, one number, and one special character.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  _buildPasswordField('Current Password', currentPassword),
                  SizedBox(height: 20),
                  _buildPasswordField('New Password', newPassword),
                  SizedBox(height: 20),
                  _buildPasswordField('Confirm Password', confirmPassword),
                  SizedBox(height: 80),
                  Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          height: 50,
                          color: ColorPage.mainBlue,
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              bool success = await changePassword(
                                currentPassword.text,
                                newPassword.text,
                                confirmPassword.text,
                              );
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Password change request submitted successfully!')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to change the password. Please try again.')),
                                );
                              }
                            }
                          },
                          child: Text(
                            'Change Password',
                            style: FontFamily.style
                                .copyWith(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    // Assume an API endpoint URL
    final String apiUrl = "https://your-api-endpoint.com/change-password";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer your_token", // Add your authorization header if needed
        },
        body: jsonEncode({
          "current_password": currentPassword,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Password changed successfully
        return true;
      } else {
        // Failed to change password
        return false;
      }
    } catch (e) {
      writeToFile(e, "changePassword");
      print("Error: $e");
      return false;
    }
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FontFamily.styleb.copyWith(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        PasswordTextField(
          controller: controller,
          label: label,
        ),
      ],
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String label;

  final TextEditingController controller;

  const PasswordTextField({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool eye = true; // State variable to manage visibility of password

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: eye,
      decoration: InputDecoration(
        prefixIcon: Image(
          image: AssetImage('assets/locksmall.png'),
        ),
        suffixIcon: IconButton(
          iconSize: 20,
          onPressed: () {
            setState(() {
              eye = !eye; // Toggle password visibility
            });
          },
          icon: eye
              ? Icon(Icons.visibility_off_outlined)
              : Icon(Icons.visibility_outlined),
          color: Colors.grey[600],
        ),
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // No border when not focused or enabled
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.4), // Grey border color
            width: 2, // Border width set to 2
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color:
                Colors.grey.withOpacity(0.4), // Grey border color when focused
            width: 2, // Border width set to 2
          ),
        ),
        filled: true,
        fillColor: Colors.transparent,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        // Custom validation logic
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (!RegExp(r'[A-Z]').hasMatch(value)) {
          return 'Password must contain at least one uppercase letter';
        }
        if (!RegExp(r'[a-z]').hasMatch(value)) {
          return 'Password must contain at least one lowercase letter';
        }
        if (!RegExp(r'[0-9]').hasMatch(value)) {
          return 'Password must contain at least one number';
        }
        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
          return 'Password must contain at least one special character';
        }
        return null; // Return null if validation passes
      },
    );
  }
}

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  GlobalKey<FormState> dialogekey = GlobalKey();
  late SharedPreferences prefs;

  String lastLogin = "";

  String getLoginTime(String iat) {
    int time = int.parse(iat);

    // Convert Unix timestamp to DateTime
    final expirationDate = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    // Define separate formats for time and date
    final timeFormat = DateFormat('hh:mm a');
    final dateFormat = DateFormat('dd-MM-yyyy');

    // Format the time and date
    String formattedTime = timeFormat.format(expirationDate);
    String formattedDate = dateFormat.format(expirationDate);

    // Combine time and date into the desired format
    return '$formattedTime, $formattedDate';
  }

  @override
  void initState() {
    infoList = {
      'Name': getx.loginuserdata[0].firstName +
          " " +
          getx.loginuserdata[0].lastName,
      'Phone': getx.loginuserdata[0].phoneNumber,
      'Email': getx.loginuserdata[0].email,
      'UserId': getx.loginuserdata[0].nameId,
      'FranchaiseId': getx.loginuserdata[0].franchiseeId,
    };
    setState(() {
      qrData = jsonEncode(infoList);
    });
    super.initState();
  }

  Map<String, String> infoList = {};

  String qrData = '';

  void _changeName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Request Name Change',
          description:
              'Changing your name requires admin approval. This process may take some time. Are you sure you want to proceed with the name change request?',
          OnCancell: () {
            Navigator.of(context).pop();
          },
          OnConfirm: (String reason) {
            // Add your logic to handle the name change request submission here
            Navigator.of(context).pop();
            // Optionally, show a message or trigger an action after submission
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Your request to change the name has been submitted for admin approval.')),
            );
          },
          btn1: 'Cancel',
          btn2: 'Request',
          linkText: 'Learn more',
          isTextfeild: false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
        // need singlechild scroll view
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(" Personal Details",
                      style: FontFamily.style.copyWith(
                          fontSize: 25,
                          color: Colors.black45,
                          fontWeight: FontWeight.w900))
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DetailsHeader(title: 'Name'),
                        DetailsItem(
                          icon: Icons.person,
                          title: getx.loginuserdata[0].firstName +
                              " " +
                              getx.loginuserdata[0].lastName,
                          type: "name",
                          isEditable: false,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox( 
                        height: 100,
                        width: 100,
                        child: InkWell(
                          onTap: () {
                            // Show a larger QR code when tapped
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Scan QR Code",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 20),
                                        QrImageView(
  data: qrData,
  version: QrVersions.auto,
  size: 320,
  gapless: false,
  embeddedImage: AssetImage(logopath),
  embeddedImageStyle: QrEmbeddedImageStyle(
    size: Size(80, 80),
  ),
),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text(
                                              "Close",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: QrImageView(
  data: qrData,
  version: QrVersions.auto,
  size: 320,
  gapless: false,
  embeddedImage: AssetImage(logopath),
  embeddedImageStyle: QrEmbeddedImageStyle(
    size: Size(20, 20),
  ),
)
                        ),
                      ),
                    ],
                  )
                ],
              ),

              DetailsHeader(title: 'E-mail'),
              DetailsItem(
                icon: Icons.mail,
                title: getx.loginuserdata[0].email,
                type: "email",
                isEditable: false,
              ),
              DetailsHeader(title: 'Phone'),
              DetailsItem(
                icon: Icons.phone,
                title: getx.loginuserdata[0].phoneNumber,
                type: "phone",
                isEditable: false,
              ),
              DetailsHeader(title: 'Password'),
              DetailsItem(
                icon: Icons.lock,
                title: '************',
                type: "password",
                isEditable: false,
              ),
              DetailsHeader(title: 'Last login'),
              // Row(children: [

              // ],),
              DetailsItem(
                icon: Icons.watch_later_outlined,
                title: getLoginTime(getx.loginuserdata[0].loginTime),
                type: "LoginTime",
                isEditable: false,
              ),
              DetailsHeader(title: 'Franchisee ID'),
              DetailsItem(
                icon: Icons.cast_for_education_outlined,
                title: getx.loginuserdata[0].franchiseeId,
                type: "Franchisee Id",
                isEditable: false,
              ),
              // SizedBox(height: 20),
              DetailsHeader(title: 'Log out'),

              ListTile(
                leading: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          blurRadius: 20,
                          spreadRadius: 5,
                          color: Color.fromARGB(255, 255, 214, 201))
                    ]),
                    child: Icon(Icons.logout,
                        color: Color.fromARGB(255, 255, 108, 50))),
                title: Text(
                  'Log Out',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 108, 50),
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  logoutConfirmationBox(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

logoutConfirmationBox(context) async {
  await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
          denyButtonText: "Cancel",
          title: "Logout",
          text: "Are you sure you want to log out?",
          confirmButtonText: "Ok",
          // confirmButtonColor: Colors.b,
          // dialogDecoration: BoxDecoration(c),

          onConfirm: () async {
            await handleLogoutProcess(context).then((v) {
              if (Platform.isIOS) {
                Navigator.pop(context);
              }
            });
          },
          type: ArtSweetAlertType.warning));

  // Alert(
  //   context: context,
  //   type: AlertType.warning,
  //   style: alertStyle,
  //   title: "Are you sure you want to log out?",
  //   buttons: [
  //     DialogButton(
  //       width: 150,
  //       child:
  //           Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18)),
  //       highlightColor: Color.fromARGB(255, 203, 46, 46),
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //       color: Color.fromARGB(255, 139, 19, 19),
  //     ),
  //     DialogButton(
  //       width: 150,
  //       highlightColor: Color.fromARGB(255, 2, 2, 60),
  //       child: Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
  //       onPressed: () async {
  //         Navigator.pop(context);
  //         await handleLogoutProcess(context);
  //       },
  //       color: const Color.fromARGB(255, 1, 12, 31),
  //     ),
  //   ],
  // ).show();
}

cantLaunchUrlAlert(BuildContext context) async {
  await ArtSweetAlert.show(
    barrierDismissible: false,
    context: context,
    artDialogArgs: ArtDialogArgs(
      title: "Error",
      text: "Unable to launch the URL. Please try again.",
      confirmButtonText: "Ok",
      onConfirm: () {
        Navigator.pop(context);
      },
      type: ArtSweetAlertType.info,
    ),
  );
}

Future<void> handleLogoutProcess(BuildContext context) async {
  if (getx.isInternet.value) {
    bool uploadSuccess = await _uploadRemainingData(context);

    if (uploadSuccess) {
      await _performLogout(context);
    } else {
      ClsErrorMsg.fnErrorDialog(
          context, 'Upload Error', "Failed to upload data!", "");
    }
  } else {
    onNoInternetConnection(context, () {
      Get.back();
    });
  }
}

Future<bool> _uploadRemainingData(BuildContext context) async {
  bool rteurnvalue = false;
  try {
    var mcqHistoryList = await fetchTblMCQHistory("");
    if (mcqHistoryList.isNotEmpty) {
      rteurnvalue = await unUploadedMcQHistoryInfoInsert(
          context, mcqHistoryList, getx.loginuserdata[0].token);
    } else {
      rteurnvalue = true;
    }

    var videoInfoList = await fetchUploadableVideoInfo();
    if (videoInfoList.length != 0) {
      rteurnvalue = await unUploadedVideoInfoInsert(
          context, videoInfoList, getx.loginuserdata[0].token, false);
    } else {
      rteurnvalue = true;
    }
    return rteurnvalue;
  } catch (e) {
    writeToFile(e, "_uploadRemainingData");
    ClsErrorMsg.fnErrorDialog(
        context, 'Upload Error', "Error uploading data  ${e.toString()}", "");
    print("Error during data upload: $e");
    return false;
  }
}

Future<void> _performLogout(BuildContext context) async {
  try {
    // var prefs = await SharedPreferences.getInstance();
    // prefs.setString("LoginId", getx.loginuserdata[0].loginId);

    if (await logoutFunction(
      context,
      getx.loginuserdata[0].token,
    )) {
      await clearSharedPreferencesExcept([
        'SelectedDownloadPathOfVieo',
        'SelectedDownloadPathOfFile',
        'DefaultDownloadpathOfFile',
        'DefaultDownloadpathOfVieo',
        'LoginId',
      ], getx.loginuserdata[0].loginId.toString());
      Platform.isAndroid
          ? Get.offAll(() => Mobilelogin())
          : Get.offAll(() => DthLmsLogin());
    }
    getx.loginuserdata.clear();
    // Navigate to login screen
  } catch (e) {
    writeToFile(e, "_performLogout");
    print("Error during logout: $e");
    ClsErrorMsg.fnErrorDialog(context, 'Logout', "Failed to logout!!", "");
  }
}

Future<void> clearSharedPreferencesExcept(
    List<String> keysToKeep, String loginId) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("LoginId", getx.loginuserdata[0].loginId);

  final allKeys = prefs.getKeys();

  for (String key in allKeys) {
    if (!keysToKeep.contains(key)) {
      await prefs.remove(key);
    }
  }
}

class DetailsItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String type;
  final VoidCallback? onTap;
  final bool isEditable;

  const DetailsItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.type,
      this.onTap,
      required this.isEditable})
      : super(key: key);

  @override
  State<DetailsItem> createState() => _DetailsItemState();
}

class _DetailsItemState extends State<DetailsItem> {
  TextEditingController editnamecontroller = TextEditingController();

  void defaultOnTap(BuildContext context, String type) {
    // print("hello");
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      alertPadding: EdgeInsets.only(top: 200),
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
          color: Colors.blue,
          fontWeight:
              FontWeight.bold), // Assuming ColorPage.blue is Colors.blue
      constraints: BoxConstraints.expand(width: 500),
      overlayColor: Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center,
    );

    Alert(
      context: context,
      style: alertStyle,
      title: "Edit youe ${type}",
      content: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Text(
                    'Please fill field *',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12), // Assuming ColorPage.red is Colors.red
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextFormField(
                controller: editnamecontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'cannot be blank';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Enter your ${type}',
                  filled: false,
                  focusColor: ColorPage.white,
                ),
              ),
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
          width: MediaQuery.of(context).size.width / 9.5,
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () {
            Get.back();
          },
          color: ColorPage.red,
          radius: BorderRadius.circular(5.0),
        ),
        DialogButton(
          width: MediaQuery.of(context).size.width / 9.5,
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () {},
          color: ColorPage.colorgrey,
          radius: BorderRadius.circular(5.0),
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        widget.icon,
        color: ColorPage.mainBlue,
      ),
      title: Text(
        widget.title,
        style: FontFamily.styleb
            .copyWith(fontSize: 14, color: Color.fromARGB(255, 136, 139, 173)),
      ),
      trailing: widget.isEditable
          ? Icon(
              Icons.edit,
              size: 15,
            )
          : null,
      onTap: widget.isEditable
          ? widget.onTap ?? () => defaultOnTap(context, widget.type)
          : null,
    );
  }
}

class DetailsHeader extends StatelessWidget {
  final String title;

  const DetailsHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(title,
            style: FontFamily.style.copyWith(
                color: Colors.black26,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class HistoryDashboard extends StatefulWidget {
  @override
  State<HistoryDashboard> createState() => _HistoryDashboardState();
}

class _HistoryDashboardState extends State<HistoryDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Statistics Cards
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     _buildStatCard('Total Customer', '470', '+3.90%', Colors.green),
            //     _buildStatCard('Team Plan', '17', '+3.90%', Colors.blue),
            //     _buildStatCard('Basic Plan', '63', '+3.90%', Colors.purple),
            //     _buildStatCard('Cancelled', '4', '-29.0%', Colors.red),
            //   ],
            // ),

            // Customer List Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Video History',
                  style: FontFamily.styleb.copyWith(fontSize: 20),
                ),
                Container(
                  width: 240,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      // hintStyle: FontFamily.style,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Filter Options
            _buildFilterBar(),
            SizedBox(height: 5),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 1,
              color: Colors.grey[200],
            ),

            SizedBox(height: 10),

            // Customer Data Table
            _buildCustomerList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String percentage, Color color) {
    return Card(
      elevation: 3,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Icon(Icons.arrow_upward, color: color, size: 16),
                Text(
                  percentage,
                  style: TextStyle(color: color),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      children: [
        _buildFilterButton('Name'),
        Expanded(child: SizedBox()),
        // getx.isprofileDrawerOpen.value ? Spacer() : SizedBox(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 80, child: _buildFilterButton(' Total')),
            // Expanded(child: SizedBox()),
            SizedBox(width: 80, child: _buildFilterButton('Used')),

            // Expanded(child: SizedBox()),

            // SizedBox(width: 5,),
            SizedBox(width: 120, child: _buildFilterButton('Remaining')),
          ],
        ),

        Expanded(child: SizedBox())
      ],
    );
  }

  Widget _buildFilterButton(String label) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          label,
          style:
              FontFamily.styleb.copyWith(fontSize: 14, color: Colors.grey[400]),
        ));
  }

  // Widget _buildCustomerList() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height/1.4,

  //     child:
  //     ListView.builder( itemCount: 10, itemBuilder: (context,index){
  //       return   _buildCustomerRow('Caden Morse', 'Sprce Mattrix',
  //           '10h 35m 45s', '10h 35m 45s', '10h 35m 45s');
  //     })

  //   );
  // }
  List<dynamic> videoWatchDetails = [
    {
      'date': '2024-09-01',
      'startTime': '10:00 AM',
      'endTime': '10:30 AM',
      'watchTime': '30m',
    },
    {
      'date': '2024-09-01',
      'startTime': '1:00 PM',
      'endTime': '1:45 PM',
      'watchTime': '45m',
    },
    {
      'date': '2024-09-02',
      'startTime': '9:00 AM',
      'endTime': '9:30 AM',
      'watchTime': '30m',
    },
    {
      'date': '2024-09-02',
      'startTime': '9:00 AM',
      'endTime': '9:30 AM',
      'watchTime': '30m',
    },
    {
      'date': '2024-09-03',
      'startTime': '9:00 AM',
      'endTime': '9:30 AM',
      'watchTime': '30m',
    },
    {
      'date': '2024-09-03',
      'startTime': '9:00 AM',
      'endTime': '9:30 AM',
      'watchTime': '30m',
    },
    {
      'date': '2024-09-03',
      'startTime': '9:00 AM',
      'endTime': '9:30 AM',
      'watchTime': '30m',
    },
    {
      'date': '2024-09-03',
      'startTime': '9:00 AM',
      'endTime': '9:30 AM',
      'watchTime': '30m',
    },
    {
      'date': '2024-09-03',
      'startTime': '9:00 AM',
      'endTime': '9:30 AM',
      'watchTime': '30m',
    },
  ];

  //   final (Color color1, Color color2, Color color3) =
  //     switch (colorScheme.brightness) {
  //   Brightness.light => (
  //       Colors.blue.withOpacity(1.0),
  //       Colors.orange.withOpacity(1.0),
  //       Colors.yellow.withOpacity(1.0)
  //     ),
  //   Brightness.dark => (
  //       Colors.purple.withOpacity(1.0),
  //       Colors.cyan.withOpacity(1.0),
  //       Colors.yellow.withOpacity(1.0)
  //     ),
  // };

  Decoration? statesToDecoration(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return BoxDecoration();
    }
    return BoxDecoration(
      gradient: LinearGradient(
        colors: switch (states.contains(WidgetState.hovered)) {
          true => <Color>[Colors.greenAccent, Colors.greenAccent],
          false => <Color>[Colors.transparent, Colors.transparent],
        },
      ),
    );
  }

  Widget _buildCustomerList() {
    return FutureBuilder<dynamic>(
      future: getVideoHistoryDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for data
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle error scenario
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle empty data scenario
          return Center(child: Text('No customers found.'));
        } else {
          // Display the list of customers when data is loaded
          return Container(
            height: MediaQuery.of(context).size.height / 1.4,
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                int remaining =
                    int.parse(getx.videoHistory[index]['AllowDuration']) -
                        int.parse(
                          getx.videoHistory[index]['ConsumeDuration'],
                        );

                return _buildCustomerRow(
                  getx.videoHistory[index]['VideoName'],
                  getx.videoHistory[index]['ChapterName'],
                  getx.videoHistory[index]['AllowDuration'],
                  getx.videoHistory[index]['ConsumeDuration'],
                  remaining.toString(),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildCustomerRow(String name, String chapterName, String total,
      String used, String remaining) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: getx.isprofileDrawerOpen.value
                  ? MediaQuery.of(context).size.width / 2.5
                  : MediaQuery.of(context).size.width / 2.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Tooltip(
                      message: name,
                      child: Text(name,
                          overflow: TextOverflow.ellipsis,
                          style: FontFamily.styleb
                              .copyWith(fontSize: 16, color: Colors.black87)),
                    ),
                  ),
                  Row(
                    children: [
                      Text('Chapter Name: ',
                          style: FontFamily.styleb.copyWith(
                            fontSize: 13,
                            color: Colors.black45,
                          )),
                      Tooltip(
                        message: chapterName,
                        child: Text(chapterName,
                            overflow: TextOverflow.ellipsis,
                            style: FontFamily.styleb.copyWith(
                              fontSize: 13,
                              color: Colors.black45,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              child: Center(
                child: Text(total,
                    overflow: TextOverflow.ellipsis,
                    style: FontFamily.styleb
                        .copyWith(fontSize: 16, color: Colors.black87)),
              ),
            ),

            Container(
              width: 100,
              child: Center(
                child: Text(used,
                    overflow: TextOverflow.ellipsis,
                    style: FontFamily.styleb
                        .copyWith(fontSize: 16, color: Colors.black87)),
              ),
            ),

            Container(
                width: 100,
                child: Center(
                  child: Text(
                    remaining,
                    style: FontFamily.styleb
                        .copyWith(fontSize: 16, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            SizedBox(width: getx.isprofileDrawerOpen.value ? 10 : 0),
            // SizedBox(width: 30),

            TextButton(
              onPressed: () {
                _showDateWiseDetailsDialog(context, name, videoWatchDetails);
              },
              style: TextButton.styleFrom(
                overlayColor: Colors.black,
                backgroundBuilder: (BuildContext context,
                    Set<WidgetState> states, Widget? child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: statesToDecoration(states),
                    child: child,
                  );
                },
              ),
              // .copyWith(
              //   side: MaterialStateProperty.resolveWith<BorderSide?>(
              //       (Set<MaterialState> states) {
              //     if (states.contains(MaterialState.hovered)) {
              //       return BorderSide(width: 3, color: Colors.red);
              //     }
              //     return null; // defer to the default
              //   }),
              // ),
              child: const Text('Details'),
            ),

            // TextButton(
            //   style: ButtonStyle(iconColor: ),
            //     onPressed: () {
            //       _showDateWiseDetailsDialog(context, name, videoWatchDetails);
            //     },
            //     child: Text(' Details'))
          ],
        ),
      ),
    );
  }

  void _showDateWiseDetailsDialog(
      BuildContext context, String videoName, List<dynamic> videoWatchDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '$videoName - Watch History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width /
                2, // Set fixed width to reduce the dialog size
            height: 500,
            child: ListView.builder(
              itemCount: videoWatchDetails.length,
              itemBuilder: (context, index) {
                final details = videoWatchDetails[index];

                // Extracting relevant data for each watch session
                String date = details['date'];
                String startTime = details['startTime'];
                String endTime = details['endTime'];
                String watchTime = details['watchTime'];

                // If it's the first occurrence of the date or a new date, show the date heading
                bool showDate = index == 0 ||
                    videoWatchDetails[index]['date'] !=
                        videoWatchDetails[index - 1]['date'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Heading (shown only once per date)
                    if (showDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Date: $date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),

                    // Video session details displayed in a row format
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Start: $startTime',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          width: 0,
                        ),
                        Text(
                          'End: $endTime',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Watched: $watchTime',
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                      ],
                    ),
                    Divider(), // Divider between sessions
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class ExamHistory extends StatefulWidget {
  const ExamHistory({super.key});

  @override
  State<ExamHistory> createState() => _ExamHistoryState();
}

class _ExamHistoryState extends State<ExamHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TextEditingController _searchController = TextEditingController();
  Getx getx = Get.put(Getx());
  String pageTitle = 'Quick Test';
  RxList mcqSetList = [].obs;
  RxList mcqPaperList = [].obs;

  @override
  void initState() {
    getMCQSetList();
    super.initState();

    _tabController =
        TabController(length: 4, vsync: this); // Updated length to 3

    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            pageTitle = 'Quick Test';
            break;
          case 1:
            pageTitle = 'Comprehensive';
            break;
          case 2:
            pageTitle = 'Ranked Competition';
            break;
          case 3:
            pageTitle = 'Theory Exam';
            break;
        }
      });
    });
  }

  // Future initialfunction() async {
  //  getx.data.value = await getMcqDataForTest(context, getx.loginuserdata[0].token,
  //       getx.selectedPackageId.value.toString());
  // }

  Future getMCQSetList() async {
    mcqSetList.value =
        await fetchMCQSetList(getx.selectedPackageId.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              indicatorWeight: 4.0,
              labelStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              tabs: const [
                Tab(
                  text: 'Quick Practice',
                ),
                Tab(
                  text: 'Comprehensive',
                ),
                Tab(
                  text: 'Ranked Competition',
                ),
                Tab(
                  text: 'Theory Exam',
                ),
              ],
            ),
          ),

          // Tab Bar View for Showing Content
          Container(
            // height: 700,
            height: MediaQuery.of(context).size.height * 0.8,
            // width: 700,
            child: TabBarView(
              controller: _tabController,
              children: [
                // First Tab Widget
                quickPractice(),
                Comprehensive(),
                rankedCompetition(),
                theoryExam(context),

                // QuickPracticeWidget(),
                // Second Tab Widget
                // ComprehensiveWidget(),
                // Third Tab Widget
                // RankedCompetitionWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget quickPractice() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        _buildHeadingbarOfMcq(),
        SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          child: _buildQuickPracticeExamDetailsList(),
        ),
      ],
    );
  }

  Widget Comprehensive() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        _buildHeadingbarOfComprehensive(),
        SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          child: _buildComprehensiveExamDetailsList(),
        ),
      ],
    );
  }

  Widget _buildHeadingbarOfComprehensive() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: SizedBox(
        //     width: 40,
        //   ),
        // ),
        SizedBox(width: 200, child: _buildHeadingButton('Exam Name')),
        SizedBox(width: 200, child: _buildHeadingButton('Date')),
        SizedBox(width: 200, child: _buildHeadingButton('Obtain Marks')),

        // _buildHeadingButton('')
      ],
    );
  }

  Widget _buildComprehensiveExamDetailsList() {
    return FutureBuilder(
      future: fetchTblMCQHistory("Comprehensive"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data!.length.toString() +
              "gfdghdsgysdghdsgcydsgdhg dc sdcuhd dch jhdsgnd vdshvdsjb");
          return snapshot.data!.length == 0
              ? Center(
                  child: Text("No history found"),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  // physics:
                  //     NeverScrollableScrollPhysics(), // Allows scrolling within this widget
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 249, 249),
                              border:
                                  Border.all(color: Colors.grey, width: 0.2)),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Center(
                                      child: Text(
                                          "${snapshot.data![index]['ExamName']}"))),
                              Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Center(
                                      child: Text(snapshot.data![index]
                                                  ["SubmitDate"] !=
                                              ""
                                          ? "${formatDateWithOrdinal(snapshot.data![index]["SubmitDate"])}"
                                          : formatDateWithOrdinal(snapshot
                                              .data![index]["AttemptDate"])))),
                              Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Center(
                                      child: Text(snapshot.data![index]
                                                  ["SubmitDate"] !=
                                              ""
                                          ? snapshot.data![index]["ObtainMarks"]
                                              .toString()
                                          : "Attempted but not submitted")))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget rankedCompetition() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        _buildHeadingbarOfRankedCompetition(),
        SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          child: _buildRankedCompetitionExamDetailsList(),
        ),
      ],
    );
  }

  Widget _buildRankedCompetitionExamDetailsList() {
    return FutureBuilder(
      future: fetchTblMCQHistory("Ranked Competition"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data!.length.toString() +
              "gfdghdsgysdghdsgcydsgdhg dc sdcuhd dch jhdsgnd vdshvdsjb");
          return snapshot.data!.length == 0
              ? Center(
                  child: Text("No history found"),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  // physics:
                  //     NeverScrollableScrollPhysics(), // Allows scrolling within this widget
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 249, 249),
                              border:
                                  Border.all(color: Colors.grey, width: 0.2)),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Center(
                                      child: Text(
                                          "${snapshot.data![index]['ExamName']}"))),
                              Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Center(
                                      child: Text(snapshot.data![index]
                                                  ["SubmitDate"] !=
                                              ""
                                          ? "${formatDateWithOrdinal(snapshot.data![index]["SubmitDate"])}"
                                          : formatDateWithOrdinal(snapshot
                                              .data![index]["AttemptDate"])))),
                              Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Center(
                                      child: Text(snapshot.data![index]
                                                  ["SubmitDate"] !=
                                              ""
                                          ? snapshot.data![index]["ObtainMarks"]
                                                  .toString() +
                                              "%"
                                          : "Attempted but not submitted")))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildHeadingbarOfRankedCompetition() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: SizedBox(
        //     width: 40,
        //   ),
        // ),
        SizedBox(width: 200, child: _buildHeadingButton('Exam Name')),
        SizedBox(width: 200, child: _buildHeadingButton('Date')),
        SizedBox(width: 200, child: _buildHeadingButton('Success Rate')),

        // _buildHeadingButton('')
      ],
    );
  }

  Widget theoryExam(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        _buildHeadingbarOfTheoryExam(),
        SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          child: _buildTheoryExamDetailsList(context),
        ),
      ],
    );
  }

  Widget _buildHeadingbarOfMcq() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: SizedBox(
        //     width: 40,
        //   ),
        // ),
        SizedBox(width: 200, child: _buildHeadingButton('Exam Name')),
        SizedBox(width: 200, child: _buildHeadingButton('Date')),
        SizedBox(width: 200, child: _buildHeadingButton('Success Rate')),

        // _buildHeadingButton('')
      ],
    );
  }

  Widget _buildHeadingbarOfTheoryExam() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: SizedBox(
        //     width: 40,
        //   ),
        // ),
        SizedBox(width: 200, child: _buildHeadingButton('Exam Name')),
        SizedBox(width: 200, child: _buildHeadingButton('Date')),
        SizedBox(width: 200, child: _buildHeadingButton('Status')),
        SizedBox(width: 200, child: _buildHeadingButton('Result')),

        // _buildHeadingButton('')
      ],
    );
  }

  Widget _buildHeadingButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 200,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          )),
        ),
      ),
    );
  }

  Widget _buildQuickPracticeExamDetailsList() {
    return FutureBuilder(
      future: fetchTblMCQHistory("Quick Practice"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data!.length.toString() +
              "gfdghdsgysdghdsgcydsgdhg dc sdcuhd dch jhdsgnd vdshvdsjb");
          return snapshot.data!.length == 0
              ? Center(
                  child: Text("No history found"),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  // physics:
                  //     NeverScrollableScrollPhysics(), // Allows scrolling within this widget
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 249, 249),
                              border:
                                  Border.all(color: Colors.grey, width: 0.2)),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Center(
                                      child: Text(
                                          "${snapshot.data![index]['ExamName']}"))),
                              Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Center(
                                      child: Text(snapshot.data![index]
                                                  ["SubmitDate"] !=
                                              ""
                                          ? "${formatDateWithOrdinal(snapshot.data![index]["SubmitDate"])}"
                                          : formatDateWithOrdinal(snapshot
                                              .data![index]["AttemptDate"])))),
                              Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Center(
                                      child: Text(snapshot.data![index]
                                                  ["SubmitDate"] !=
                                              ""
                                          ? snapshot.data![index]["ObtainMarks"]
                                                      .toString() ==
                                                  "null"
                                              ? "0%"
                                              : snapshot.data![index]
                                                          ["ObtainMarks"]
                                                      .toString() +
                                                  "%"
                                          : "Attempted but not submitted")))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

String formatDateTime(String inputString) {
  // Parse the input string to DateTime object
  try {
    DateTime dateTime = DateTime.parse(inputString);

    // Format the DateTime object to desired format
    String formattedDate =
        DateFormat('dd-MM-yyyy, h:mma').format(dateTime).toLowerCase();

    return formattedDate;
  } catch (e) {
    writeToFile(e, "formatDateTime");
    return "No datetime found";
  }
}

Widget _buildTheoryExamDetailsList(BuildContext context) {
  return FutureBuilder(
    future: getTheryExamHistoryList(context, getx.loginuserdata[0].token),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return snapshot.data!.length == 0
            ? Center(
                child: Text("No history found"),
              )
            : ListView.builder(
                shrinkWrap: true,
                // physics:
                //     NeverScrollableScrollPhysics(), // Allows scrolling within this widget
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  // print(snapshot.data![index]['TheoryExamName'].toString()+"hellollllllllllllllllllllllllll");

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 249, 249),
                            border: Border.all(color: Colors.grey, width: 0.2)),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Center(
                                    child: Text(
                                        "${snapshot.data![index]['TheoryExamName']}"))),
                            Container(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Center(
                                    child: Text(snapshot.data![index]
                                                ["isSubmitted"] ==
                                            1
                                        ? "${formatDateTime(snapshot.data![index]["SubmitedOn"])} "
                                        : snapshot.data![index]["isAttempt"] ==
                                                    1 &&
                                                snapshot.data![index]
                                                        ["isSubmitted"] ==
                                                    0
                                            ? "${snapshot.data![index]["AttamptOn"]} "
                                            : "----"))),
                            Container(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Center(
                                    child: Text(snapshot.data![index]
                                                ["isSubmitted"] ==
                                            1
                                        ? "Submited"
                                        : snapshot.data![index]["isAttempt"] ==
                                                    1 &&
                                                snapshot.data![index]
                                                        ["isSubmitted"] ==
                                                    0
                                            ? " Attampt "
                                            : "Not attempt"))),
                            Container(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Center(
                                    child: snapshot.data![index]
                                                ["IsResultPublished"] ==
                                            1
                                        ? MaterialButton(
                                            color: ColorPage.blue,
                                            child: Text(
                                              "See result",
                                              style: TextStyle(
                                                  color: ColorPage.white),
                                            ),
                                            onPressed: () async {
                                              // String totalmarks=await fetchtotalMarksOfExma(snapshot.data![index]['TheoryExamId'].toString());
                                              Get.to(
                                                  transition:
                                                      Transition.cupertino,
                                                  () => TestResultPage(
                                                        studentName: getx
                                                                .loginuserdata[
                                                                    0]
                                                                .firstName +
                                                            " " +
                                                            getx
                                                                .loginuserdata[
                                                                    0]
                                                                .lastName,
                                                        examName: snapshot
                                                                .data![index]
                                                            ['TheoryExamName'],
                                                        resultPublishedOn:
                                                            formatDateTime(snapshot
                                                                        .data![
                                                                    index][
                                                                'ReportPublishDate']),
                                                        submitedOn: formatDateTime(
                                                            snapshot.data![
                                                                    index]
                                                                ["SubmitedOn"]),
                                                        obtain: snapshot.data![
                                                                        index][
                                                                    'TotalReCheckedMarks'] !=
                                                                null
                                                            ? snapshot.data![
                                                                    index][
                                                                'TotalReCheckedMarks']
                                                            : snapshot.data![
                                                                    index][
                                                                'TotalCheckedMarks'],
                                                        totalMarks: double
                                                            .parse(snapshot
                                                                .data![index][
                                                                    'TotalMarks']
                                                                .toString()),
                                                        totalMarksRequired:
                                                            double.parse(snapshot
                                                                .data![index][
                                                                    'PassMarks']
                                                                .toString()),
                                                        theoryExamAnswerId:
                                                            "theoryExamAnswerId not done yeat",
                                                        examId: snapshot
                                                                .data![index] 
                                                            ['TheoryExamId'],
                                                            pdfurl:snapshot.data![
                                                                    index][
                                                                'CheckedDocumentUrl'], 
                                                                questionanswersheet: '' ,
                                                      ));
                                            })
                                        : Text("Result not publish ")))
                          ],
                        ),
                      ),
                    ),
                  );
                });
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
  );
}

onPauseSuccessfull(context, int day, VoidCallback ontap, bool success) {
  Alert(
    context: context,
    type: success?AlertType.success:AlertType.info,
    style: AlertStyle(
      titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      descStyle: FontFamily.font6,
      isCloseButton: false,
    ),
    title: success?"Done":"Something went wrong",
    desc: success?"Your Subscription is pause for $day days!":"",
    buttons: [
      DialogButton(
        child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
        highlightColor: ColorPage.blue,
        onPressed: ontap,
        color:success? const Color.fromARGB(255, 65, 207, 43):Color.fromARGB(255, 207, 43, 43),
      ),
    ],
  ).show();
}
