import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:dthlms/Live/details.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/homepage_mobile.dart';
import 'package:dthlms/MOBILE/store/storemodelclass/storemodelclass.dart';
import 'package:dthlms/MODEL_CLASS/social_media_links_model.dart';
import 'package:dthlms/PC/MCQ/PRACTICE/termandcondition.dart';
import 'package:dthlms/PC/PROFILE/userProfilePage.dart';
import 'package:dthlms/constants.dart';
import 'package:dthlms/log.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_infinite_marquee/flutter_infinite_marquee.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dthlms/ACTIVATION_WIDGET/enebelActivationcode.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/mobilenotification.dart';
import 'package:dthlms/MODEL_CLASS/Meettingdetails.dart';
import 'package:dthlms/PC/LOGIN/login.dart';
import 'package:dthlms/PC/PACKAGEDETAILS/packagedetails.dart';
import 'package:dthlms/PC/VIDEO/videoplayer.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sidebarx/sidebarx.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:package_info_plus/package_info_plus.dart' as pinfo;
import 'package:url_launcher/url_launcher.dart';

TextStyle style = const TextStyle(fontFamily: 'AltoneRegular', fontSize: 20);
TextStyle styleb = const TextStyle(fontFamily: 'AltoneBold', fontSize: 20);

class DthDashboard extends StatefulWidget {
  const DthDashboard({super.key});

  @override
  State<DthDashboard> createState() => _DthDashboardState();
}

class _DthDashboardState extends State<DthDashboard> {
  Getx getx = Get.put(Getx());
  int selectedIndex = -1;
  late BuildContext globalContext;

  @override
  void initState() {
    Future.microtask(() {
      getNotificationDetails(context, getx.loginuserdata[0].token);
      getHomePageBannerImage(context, getx.loginuserdata[0].token);
      isTokenValid(getx.loginuserdata[0].token);
      if (getx.isInternet.value) {
        // print(getx.isInternet.value.toString()+"\n\n\n\n\n\n\n\n\n");

        updatePackage(globalContext, getx.loginuserdata[0].token, true, "");
      }

      readPackageDetailsdata();
    });
    // getIconData(context, getx.loginuserdata[0].token);
    super.initState();
  }

  bool isTokenValid(String jwtToken) {
    try {
      // Decode and get the expiration time from the token
      final parts = jwtToken.split('.');
      if (parts.length != 3) {
        throw const FormatException('Invalid JWT token format');
      }

      final payload = base64Url.decode(base64Url.normalize(parts[1]));
      final payloadMap =
          json.decode(utf8.decode(payload)) as Map<String, dynamic>;

      final exp = payloadMap['exp'] as int?;
      if (exp == null) {
        throw Exception('Expiration time (exp) not found in the token');
      }
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

      // Convert Unix timestamp to DateTime
      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

      // Get the current date and time
      final now = DateTime.now();
      bool isvalid = now.isBefore(expirationDate);
      if (!isvalid) {
        onTokenExpire(context);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => DthLmsLogin()));

        // Get.offAll(() => DthLmsLogin());
      }
      if (isvalid) {}

      // Compare current time with expiration time
      return isvalid;
    } catch (e) {
      writeToFile(e, "isTokenValid");
      // Handle errors (invalid token, missing exp, etc.)
      print('Error: ${e.toString()}');
      return false;
    }
  }

  // final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    globalContext = context;
    return Scaffold(
      // drawer: ExampleSidebarX(controller: _controller),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Expanded(
          //   child: Center(
          //     child: _ScreensExample(
          //       controller: _controller,
          //     ),
          //   ),
          // ),

          SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: DashboardSlideBar(
                selectedIndex: selectedIndex,
                // headname: 'DTH LMS ',
                onItemSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
          ),
          Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 20),
                child: DashBoardRight(),
              ))
        ],
      ),
    );
  }
}

// class _ScreensExample extends StatelessWidget {
//   const _ScreensExample({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   final SidebarXController controller;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (context, child) {
//         final pageTitle = _getTitleByIndex(controller.selectedIndex);
//         switch (controller.selectedIndex) {
//           case 0:
//             return ListView.builder(
//               padding: const EdgeInsets.only(top: 10),
//               itemBuilder: (context, index) => Container(
//                 height: 100,
//                 width: double.infinity,
//                 margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Theme.of(context).canvasColor,
//                   boxShadow: const [BoxShadow()],
//                 ),
//               ),
//             );
//           default:
//             return Text(
//               pageTitle,
//               style: theme.textTheme.headlineSmall,
//             );
//         }
//       },
//     );
//   }
// }

class DashboardSlideBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  // final String headname;
  const DashboardSlideBar({
    super.key,
    // required this.headname,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<DashboardSlideBar> createState() => _DashboardSlideBarState();
}

class _DashboardSlideBarState extends State<DashboardSlideBar>with SingleTickerProviderStateMixin {
  Getx getx = Get.find<Getx>();
  // List<Color> colors = [
  //   Colors.blue,
  //   Colors.orange,
  //   Colors.pink,
  //   Colors.lightBlue,
  //   Colors.orange,
  //   Colors.lightBlue,
  //   Colors.orange,
  //   Colors.pink,
  //   Colors.green,
  // ];
  int colorchoose() {
    return Random().nextInt(9);
  }

  int hoverIndex = -1;

   late TabController _tabController;


  @override
  void initState() {
     _tabController = TabController(length: 2, vsync: this);
// while(getx.studentPackage.length==0)

// {
// .whenComplete(() {
    // getAllPackageListOfStudent();

//       setState(() {}); });
// }

    appVersionGet();
    Future.delayed(const Duration(seconds: 2)).whenComplete(() {
      getAllPackageListOfStudent().then((_) {});
    });
    // getAllPackageListOfStudent().whenComplete(() {

    // });
    getSocialMediaIcons(context, getx.loginuserdata[0].token);
    super.initState();
  }

  List<SocialMediaIconModel> socialMediaLinksData = [];

  Future initialfunction(String packageid) async {
    if (getx.isInternet.value) {
      updatePackage(context, getx.loginuserdata[0].token, false, packageid);
    } else {
      getx.mcqdataList.value = true;
      getx.theoryExamvalue.value = true;
    }
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

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      backgroundColor: ColorPage.white,
      body: Drawer(
        child: Container(
          color: ColorPage.white,
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(logopath), // App logo or user avatar
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Welcome to Our App",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorPage.color1,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Tab Bar
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Packages'),
                        Tab(text: 'Free'),
                      ],
                      indicatorColor: Colors.blueGrey.shade400.withOpacity(0.4),
                      labelStyle: TextStyle(color: const Color.fromARGB(255, 3, 32, 125),fontWeight: FontWeight.bold),
                      unselectedLabelColor: Colors.black54,


                      dividerColor: Colors.transparent,
                      // labelColor: ColorPage.color1,
                    ),
                  ],
                ),
              ),

              // Body Section (Scrollable)
              Obx(
                () {
                  // Filter packages
                  final freePackages = getx.studentPackage
                      .where((pkg) => pkg['IsFree'] == 'true')
                      .toList();
                  final paidPackages = getx.studentPackage
                      .where((pkg) => pkg['IsFree'] == 'false')
                      .toList();






                  return Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Paid Packages Tab
                        paidPackages.isNotEmpty?
                          ListView.builder(
                            itemCount: paidPackages.length,
                            itemBuilder: (context, i) {
                              return buttonWidget(
                                paidPackages[i]['packageName']!,
                                paidPackages[i]['CourseName'],
                                () async {
                                  getx.currentPackageName.value =
                                      paidPackages[i]['packageName'];
                                  getx.selectedPackageId.value =
                                      int.parse(paidPackages[i]['packageId']);

                                  resetTblLocalNavigation();
                                  await insertTblLocalNavigation(
                                    "Package",
                                    paidPackages[i]['packageId'],
                                    paidPackages[i]['packageName'],
                                  );
                                  getLocalNavigationDetails();

                                  widget.onItemSelected(i);

                                  initialfunction(paidPackages[i]['packageId']);

                                  Get.to(
                                    () => PackageDetailsPage(
                                      paidPackages[i]['packageName'],
                                      int.parse(paidPackages[i]['packageId']),
                                      ExpiryDate: paidPackages[i]['ExpiryDate'],
                                    ),
                                    transition: Transition.cupertino,
                                    duration: const Duration(milliseconds: 500),
                                  );
                                },
                                widget.selectedIndex == i,
                                hoverIndex == i,
                                i,
                              );
                            },
                          ):Text("No Package Avileble"),
                        
                        // Free Packages Tab
                       freePackages.isNotEmpty?
                          ListView.builder(
                            itemCount: freePackages.length,
                            itemBuilder: (context, i) {
                              return buttonWidget(
                                freePackages[i]['packageName']!,
                                freePackages[i]['CourseName'],
                                () async {
                                  getx.currentPackageName.value =
                                      freePackages[i]['packageName'];
                                  getx.selectedPackageId.value =
                                      int.parse(freePackages[i]['packageId']);

                                  resetTblLocalNavigation();
                                  await insertTblLocalNavigation(
                                    "Package",
                                    freePackages[i]['packageId'],
                                    freePackages[i]['packageName'],
                                  );
                                  getLocalNavigationDetails();

                                  widget.onItemSelected(i);

                                  initialfunction(freePackages[i]['packageId']);

                                  Get.to(
                                    () => PackageDetailsPage(
                                      freePackages[i]['packageName'],
                                      int.parse(freePackages[i]['packageId']),
                                      ExpiryDate: freePackages[i]['ExpiryDate'],
                                    ),
                                    transition: Transition.cupertino,
                                    duration: const Duration(milliseconds: 500),
                                  );
                                },
                                widget.selectedIndex == i,
                                hoverIndex == i,
                                i,
                              );
                            },
                          ):Text("No packages available at the moment."),
                        
                        // If there are no paid or free packages, show a message
                        // if (paidPackages.isEmpty && freePackages.isEmpty) ...[
                        //   const Center(
                        //     child: Text('No packages available at the moment.'),
                        //   ),
                        // ],
                      ],
                    ),
                  );
                },
              ),

              // Footer Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    // Logout Button
                    Material(
                      borderRadius: BorderRadius.circular(27),
                      child: ListTile(
                        onTap: () {
                          logoutConfirmationBox(context);
                        },
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        tileColor: const Color.fromARGB(255, 255, 212, 199),
                        leading: const Icon(
                          Icons.logout_rounded,
                          color: Colors.red,
                        ),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        dense: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Social Media Links
                    const SizedBox(height: 8),
                    FutureBuilder(
                      future: getAllTblImages(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final socialMediaIcons = snapshot.data!
                              .where((item) => item['ImageType'] == 'socialmediaicons')
                              .toList();
                          if (socialMediaIcons.isEmpty) {
                            return const SizedBox();
                          }
                          return Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Follow Us',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorPage.red,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: List.generate(
                                    socialMediaIcons.length,
                                    (index) => InkWell(
                                      onTap: () async {
                                        final Uri url = Uri.parse(socialMediaIcons[index]['ImagePath']);
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        } else {
                                          cantLaunchUrlAlert(context);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: socialMediaIcons.length > 4 ? 20 : 35,
                                            width: socialMediaIcons.length > 4 ? 20 : 35,
                                            child: SvgPicture.string(
                                              socialMediaIcons[index]['ImageUrl'],
                                            ),
                                          ),
                                          Text(
                                            socialMediaIcons[index]['ImageId'],
                                            style: FontFamily.style.copyWith(
                                                fontSize: 14, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return const Text("Error loading images.");
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                    // Version Info
                    Obx(
                      () => Opacity(
                        opacity: 0.6,
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              "Version ${getx.appVersion.value}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
        ),
      ),
    );
  }

  Widget socialMediaIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        IconButton(
          color: color,
          onPressed: () {
            // Define action here
          },
          icon: Icon(
            icon,
            size: 24,
          ),
        ),
        // Text(label),
      ],
    );
  }

  Widget buttonWidget(String name, String course, void Function()? onTap,
      bool isActive, bool isHover, int i) {
    // Color backgroundColor =
    //     isHover
    //         ? Colors.blueAccent.withOpacity(0.6) // Color when hover
    //         : Colors.white; // Color when not active and not hovered
    // Color textColor = isActive || isHover ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 4.0,
        shadowColor: Colors.blueGrey.shade400.withOpacity(0.4),
        child: ListTile(
          tileColor: Colors.blueGrey.shade50,

          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 12,
          ),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          onTap: onTap,
          hoverColor: Colors.blueAccent.shade400.withOpacity(0.4),
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(15),
          //     side: BorderSide(color: Colors.grey.shade400.withOpacity(0.6),
          //     width: 1,
          //     ),
          // ),
          subtitle: Text(course,
              style: FontFamily.style.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.green)),
          title: Text(name,
              style: FontFamily.style
                  .copyWith(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class DashBoardRight extends StatefulWidget {
  DashBoardRight({
    super.key,
  });
  @override
  State<DashBoardRight> createState() => _DashBoardRightState();
}

class _DashBoardRightState extends State<DashBoardRight> {
  final List<String> _itemsDefault = [
    "Welcome to ${getFranchiseNameFromTblSetting()}",
    "Powered by our Creativity"
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextStyle style = const TextStyle(fontFamily: 'AltoneRegular', fontSize: 20);

  TextStyle styleb = const TextStyle(fontFamily: 'AltoneBold', fontSize: 20);

  @override
  void initState() {
    // getAllTblNotifications();
    franchaiseName = getFranchiseNameFromTblSetting();
    super.initState();
  }

  String franchaiseName = "";
  @override
  Widget build(BuildContext context) {
    String username =
        getx.loginuserdata[0].firstName + " " + getx.loginuserdata[0].lastName;
    // String dropdownValue = list.first;
    bool _customTileExpanded = false;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Notifications',
                    style: FontFamily.styleb,
                  ),
                )
              ],
            ),
            FutureBuilder(
                future: getAllTblNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueAccent.shade100,

                                    child: ExpansionTile(
                                      shape:
                                          Border.all(color: Colors.transparent),
                                      leading: const Image(
                                        image: AssetImage(logopath),
                                      ),
                                      title: Text(
                                        snapshot.data![index]
                                            ['NotificationTitle'],
                                        style: FontFamily.styleb
                                            .copyWith(fontSize: 16),
                                      ),
                                      subtitle: HtmlWidget(snapshot.data![index]
                                          ['NotificationBody']),
                                      trailing: Icon(
                                        _customTileExpanded
                                            ? Icons.arrow_drop_down_circle
                                            : Icons.arrow_drop_down,
                                      ),
                                      children: <Widget>[
                                        SizedBox(
                                            // height: 200,
                                            // width: 200,
                                            child: snapshot.data![index][
                                                        'NotificationImageUrl'] ==
                                                    ""
                                                ? ListTile(
                                                    title: HtmlWidget(
                                                    snapshot.data![index]
                                                        ['NotificationBody'],
                                                  ))
                                                : File(snapshot.data![index][
                                                            'NotificationImageUrl'])
                                                        .existsSync()
                                                    ? Image.file(
                                                        File(snapshot
                                                                .data![index][
                                                            'NotificationImageUrl']),
                                                        height: 300,
                                                      )
                                                    : ListTile(
                                                        title: HtmlWidget(
                                                        snapshot.data![index][
                                                            'NotificationBody'],
                                                      ))),
                                      ],
                                      onExpansionChanged: (bool expanded) {
                                        setState(() {
                                          _customTileExpanded = expanded;
                                        });
                                      },
                                    ),

                                    // child: ListTile(
                                    //   onTap: (){},
                                    //   title: Text(snapshot.data![index]['NotificationTitle'],style: FontFamily.styleb.copyWith(fontSize: 16),),
                                    // // subtitle: Text(snapshot.data![index]['NotificationBody'],style: FontFamily.style.copyWith(fontSize: 12),),
                                    // subtitle: HtmlWidget(snapshot.data![index]['NotificationTitle']),
                                    // leading: const Image(image: AssetImage(logopath),),
                                    // trailing: const Icon(Icons.arrow_forward_ios_rounded,size: 15,),
                                    // ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Expanded(
                            child: Center(
                                child: Text(
                            'You don’t have any notifications at the moment.',
                            textAlign: TextAlign.center,
                            style: FontFamily.styleb
                                .copyWith(fontSize: 10, color: Colors.grey),
                          )));
                  } else {
                    return Expanded(
                        child: Center(
                            child: Text(
                      'You don’t have any notifications at the moment.',
                      textAlign: TextAlign.center,
                      style: FontFamily.styleb
                          .copyWith(fontSize: 10, color: Colors.grey),
                    )));
                  }
                })
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      Flexible(
                        child: AppBar(
                          backgroundColor: const Color.fromARGB(0, 125, 8, 8),
                          surfaceTintColor: Colors.transparent,
                          automaticallyImplyLeading: true,
                          title: Container(
                              child: Text(
                            "$franchaiseName",
                            style: const TextStyle(fontSize: 30),
                          )),

                          // title: Container(
                          //   width: 400,
                          //   child: TextFormField(
                          //     decoration: InputDecoration(
                          //       hintText: 'Search',
                          //       hintStyle: TextStyle(color: ColorPage.grey),
                          //       fillColor: ColorPage.white,
                          //       filled: true,
                          //       border: OutlineInputBorder(
                          //         borderSide: BorderSide.none,
                          //         borderRadius: BorderRadius.circular(40),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          actions: [
                            SizedBox(
                              width: 280,
                              // color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _scaffoldKey.currentState!
                                          .openEndDrawer();
                                    },
                                    icon: const Icon(
                                      Icons.notifications_none_rounded,
                                      weight: 5,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                          transition: Transition.cupertino,
                                          () => const ProfilePage());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                      child: CircleAvatar(
                                        radius: 20,
                                        child: Text(
                                          '${getx.loginuserdata[0].firstName[0]}${getx.loginuserdata[0].lastName[0]}'
                                              .toUpperCase(), // Get initials
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors
                                                .black, // Optional text color
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                          transition: Transition.cupertino,
                                          () => const ProfilePage());
                                    },
                                    child: SizedBox(
                                      width: username.length > 13 ? 170 : 90,
                                      child: Text(
                                        username,
                                        overflow: TextOverflow.ellipsis,
                                        style: styleb.copyWith(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  )
                                ],
                              ),
                            )

                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       bottom: 50, left: 10, right: 10),
                            //   child: Icon(
                            //     Icons.notifications_rounded,
                            //     color: Colors.black,
                            //     weight: 5,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                HeadingBox(),
                FutureBuilder(
                  future: getAllTblImages(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Extract the titles into a list
                      List<dynamic> data = snapshot.data as List<dynamic>;
                      List<String> _itemsType = data
                          .map((item) => item['ImageType'].toString())
                          .toList();
                      List<String> _items = data
                          .map((item) => item['ImageText'].toString())
                          .toList();
                      if (_items.isNotEmpty) {
                        return SizedBox(
                          height: 50,
                          child: InfiniteMarquee(
                            itemBuilder: (BuildContext context, int index) {
                              // Access   from the list
                              String item = _items[index % _items.length];
                              return GestureDetector(
                                onTap: () {
                                  // Handle item tap if needed
                                  // _showToast(item);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.primaries[
                                      index % Colors.primaries.length],
                                  child: Center(
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 50,
                          child: InfiniteMarquee(
                            itemBuilder: (BuildContext context, int index) {
                              // Access items from the list
                              String item =
                                  _itemsDefault[index % _itemsDefault.length];
                              return GestureDetector(
                                onTap: () {
                                  // Handle item tap if needed
                                  // _showToast(item);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.primaries[
                                      index % Colors.primaries.length],
                                  child: Center(
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    } else {
                      return SizedBox(
                        height: 50,
                        child: InfiniteMarquee(
                          itemBuilder: (BuildContext context, int index) {
                            // Access items from the list
                            String item =
                                _itemsDefault[index % _itemsDefault.length];
                            return GestureDetector(
                              onTap: () {
                                // Handle item tap if needed
                                // _showToast(item);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                color: Colors
                                    .primaries[index % Colors.primaries.length],
                                child: Center(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                Row(
                  children: [
                    Expanded(
                        child: CalendarWidget(
                      packageId: "",
                    )),
                  ],
                ),
              ],
            ),
          ),
          GlobalDialog(getx.loginuserdata[0].token)
        ],
      ),
    );
  }

  _logoutConfirmetionBox(context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      alertPadding: const EdgeInsets.only(top: 200),
      descStyle: const TextStyle(),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(color: Colors.grey),
      ),
      titleStyle: const TextStyle(
          color: Color.fromARGB(255, 243, 33, 33), fontWeight: FontWeight.bold),
      constraints: const BoxConstraints.expand(width: 350),
      overlayColor: const Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center,
    );
    Alert(
      context: context,
      type: AlertType.warning,
      style: alertStyle,
      title: "Are you sure you want to log out?",
      // desc:
      //     "",
      buttons: [
        DialogButton(
          width: 150,
          child: const Text("Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: const Color.fromARGB(255, 203, 46, 46),
          onPressed: () {
            Navigator.pop(context);
          },
          color: const Color.fromARGB(255, 139, 19, 19),
        ),
        DialogButton(
          width: 150,
          highlightColor: const Color.fromARGB(255, 2, 2, 60),
          child: const Text("Yes",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () async {
            Navigator.pop(context);
            await logoutFunction(
              context,
              getx.loginuserdata[0].token,
            );

            await clearSharedPreferencesExcept([
              'SelectedDownloadPathOfVieo',
              'SelectedDownloadPathOfFile',
              'DefaultDownloadpathOfFile',
              'DefaultDownloadpathOfVieo'
            ]);
            var prefs = await SharedPreferences.getInstance();
            prefs.setString("LoginId", getx.loginuserdata[0].loginId);

            getx.loginuserdata.clear();

            Get.offAll(() => const DthLmsLogin());
          },
          color: const Color.fromARGB(255, 1, 12, 31),
        ),
      ],
    ).show();
  }

  Future<void> clearSharedPreferencesExcept(List<String> keysToKeep) async {
    final prefs = await SharedPreferences.getInstance();

    final allKeys = prefs.getKeys();

    for (String key in allKeys) {
      if (!keysToKeep.contains(key)) {
        await prefs.remove(key);
      }
    }
  }

  Widget learningGoalButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 50, top: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: MaterialButton(
          hoverColor: const Color.fromARGB(255, 237, 235, 246),
          onPressed: () {},
          color: ColorPage.white,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
            child: Text(
              "Learning Goal",
              style: FontFamily.font2.copyWith(
                  color: ColorPage.colorbutton, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void showFullImageDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    iconTheme: const IconThemeData(color: ColorPage.white),
                    elevation: 0,
                  ),
                ),
                // Container(
                //   // margin: EdgeInsets.symmetric(vertical: 80),
                //   width: MediaQuery.of(context).size.width / 3,
                //   height: MediaQuery.of(context).size.width / 3,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.white.withOpacity(0.1),
                //   ),
                //   child: ClipOval(
                //     child: Image.network(
                //       "https://via.placeholder.com/215x215.png?text=${getx.loginuserdata[0].firstName} ${getx.loginuserdata[0].lastName}+Image",
                //       fit: BoxFit.cover,
                //     ),
                //     // child: Image.network(
                //     //   MyUrl.fullurl + MyUrl.imageurl + user.Image,
                //     //   fit: BoxFit.cover,
                //     // ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class _NewsNotificationsState extends State<NewsNotifications> {
//   TextStyle style = TextStyle(fontFamily: 'AltoneRegular', fontSize: 20);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.sizeOf(context).height / 1.9,
//       margin: EdgeInsets.only(left: 20),
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Text('News & Notifications',
//                   style: style.copyWith(fontWeight: FontWeight.w800)),
//             ],
//           ),
//           SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading:
//                       Icon(Icons.newspaper), // or any other icon you prefer
//                   title:
//                       Text('News Title', style: style.copyWith(fontSize: 18)),
//                   subtitle: Text('News Description'), // optional
//                   trailing: IconButton(
//                     icon: Icon(Icons.notifications),
//                     onPressed: () {}, // handle notification press
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class CalenderWidget extends StatefulWidget {
//   const CalenderWidget({super.key});

//   @override
//   _CalenderWidgetState createState() => _CalenderWidgetState();
// }

// class _CalenderWidgetState extends State<CalenderWidget> {
//   bool _showTooltip = false;
//   Timer? _tooltipTimer;

//   void _toggleTooltip() {
//     setState(() {
//       _showTooltip = !_showTooltip;
//     });

//     if (_showTooltip) {
//       _tooltipTimer?.cancel(); // Cancel any existing timer
//       _tooltipTimer = Timer(Duration(seconds: 5), () {
//         setState(() {
//           _showTooltip = false;
//         });
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _tooltipTimer
//         ?.cancel(); // Ensure the timer is canceled when the widget is disposed
//     super.dispose();
//   }

//   TextStyle style = TextStyle(fontFamily: 'AltoneRegular', fontSize: 20);
//   TextStyle styleb = TextStyle(fontFamily: 'AltoneBold', fontSize: 20);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.sizeOf(context).height / 1.9,
//       margin: EdgeInsets.symmetric(vertical: 15),
//       padding: EdgeInsets.only(left: 5, right: 5, top: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         // boxShadow: [
//         //   BoxShadow(
//         //     blurRadius: 3,
//         //     color: Color.fromARGB(255, 192, 191, 191),
//         //     offset: Offset(0, 0),
//         //   ),
//         // ],
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Stack(
//         children: [
//           SfCalendar(
//             headerHeight: 40,
//             cellBorderColor: Colors.transparent,
//             showCurrentTimeIndicator: true,
//             viewHeaderHeight: 40,
//             viewHeaderStyle: ViewHeaderStyle(
//               dayTextStyle: style,
//             ),
//             headerStyle: CalendarHeaderStyle(

//               // backgroundColor: Color.fromARGB(255, 7, 115, 255),
//               textAlign: TextAlign.center,
//               textStyle: styleb,
//             ),
//             view: CalendarView.month,
//             monthViewSettings: MonthViewSettings(

//               agendaViewHeight: 60,
//               showTrailingAndLeadingDates: true,
//               monthCellStyle: MonthCellStyle(),
//               agendaStyle: AgendaStyle(
//                 dateTextStyle: TextStyle(
//                   color: Colors.black,
//                 ),
//                 placeholderTextStyle: TextStyle(color: Colors.green),
//               ),
//               showAgenda: true,
//             ),
//           ),
//           Positioned(
//             top: 0,
//             right: 10,
//             child: MouseRegion(
//               onEnter: (_) {
//                 setState(() {
//                   _showTooltip = true;
//                 });
//               },
//               onExit: (_) {
//                 setState(() {
//                   _showTooltip = false;
//                 });
//               },
//               child: IconButton(
//                 icon: Icon(Icons.info_outline, color: Colors.black),
//                 onPressed: _toggleTooltip,
//               ),
//             ),
//           ),
//           if (_showTooltip)
//             Positioned(
//               top: 45, // Positioning it just below the header
//               right: 10,
//               child: TooltipWidget(),
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'dart:async';
class CalendarWidget extends StatefulWidget {
  final String packageId;
  CalendarWidget({super.key, required this.packageId});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  RxBool _showTooltip = false.obs;
  Timer? _tooltipTimer;
  Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());
  RxList<Appointment> _selectedAppointments = <Appointment>[].obs;
  RxList<Appointment> appointments = <Appointment>[].obs;
  var isLoading = true.obs;

  runLiveExe(MeetingDeatils meeting) async {
    ExeRun ob = ExeRun();
    if (getx.todaymeeting.isNotEmpty) {
      ob.runingExelive(meeting);
    } else {}
  }

  @override
  void initState() {
    super.initState();
    // _selectedDate = DateTime.now();
    loadAppointments().then(
      (value) {
        _updateSelectedAppointments();
      },
    );
    dio = Dio();
  }

  // Function to load appointments
  Future<void> loadAppointments() async {
    try {
      isLoading.value = true; // Set loading to true when fetching data

      // Simulate a delay to load data
      await Future.delayed(const Duration(seconds: 2)); // Simulate delay

      if (getx.calenderEvents.isNotEmpty) {
        appointments.clear(); // Clear the previous appointments

        for (var item in getx.calenderEvents) {
          if (widget.packageId == "") {
            final Appointment newAppointment = Appointment(
              resourceIds: [
                {
                  "PackageId": item['PackageId'],
                  "PackageName": item['PackageName'],
                  "FileIdType": item['FileIdType'],
                  "FileId": item['FileId'],
                  "FileIdName": item['FileIdName'],
                  "ChapterId": item['ChapterId'],
                  "VideoDuration": item['VideoDuration'],
                  "AllowDuration": item['AllowDuration'],
                  "ConsumeDuration": item['ConsumeDuration'],
                  "ConsumeNos": item['ConsumeNos'],
                  "ScheduledOn": item['ScheduledOn'],
                  "DocumentPath": item['DocumentPath'],
                  "DownloadedPath": item['DownloadedPath'],
                  "SessionId": item['SessionId']
                }
              ],
              startTime: DateTime.parse(item['ScheduleOn']),
              endTime: DateTime.parse(item['ScheduleOn']),
              color: item['FileIdType'] == 'Video'
                  ? ColorPage.recordedVideo
                  : item['FileIdType'] == 'Live'
                      ? ColorPage.recordedVideo
                      : item['FileIdType'] == 'YouTube'
                          ? ColorPage.testSeries
                          : item['FileIdType'] == 'Test'
                              ? ColorPage.testSeries
                              : ColorPage.history,
              subject: item['FileIdName'],
              notes: item['FileIdName'],
              location: item['FileIdType'],
            );

            appointments.add(newAppointment);
          } else {
            if (widget.packageId == item['PackageId'].toString()) {
              final Appointment newAppointment = Appointment(
                resourceIds: [
                  {
                    "PackageId": item['PackageId'],
                    "PackageName": item['PackageName'],
                    "FileIdType": item['FileIdType'],
                    "FileId": item['FileId'],
                    "FileIdName": item['FileIdName'],
                    "ChapterId": item['ChapterId'],
                    "VideoDuration": item['VideoDuration'],
                    "AllowDuration": item['AllowDuration'],
                    "ConsumeDuration": item['ConsumeDuration'],
                    "ConsumeNos": item['ConsumeNos'],
                    "ScheduledOn": item['ScheduledOn'],
                    "DocumentPath": item['DocumentPath'],
                    "DownloadedPath": item['DownloadedPath'],
                    "SessionId": item['SessionId']
                  }
                ],
                startTime: DateTime.parse(item['ScheduleOn']),
                endTime: DateTime.parse(item['ScheduleOn']),
                color: item['FileIdType'] == 'Video'
                    ? ColorPage.recordedVideo
                    : item['FileIdType'] == 'Live'
                        ? ColorPage.recordedVideo
                        : item['FileIdType'] == 'YouTube'
                            ? ColorPage.testSeries
                            : item['FileIdType'] == 'Test'
                                ? ColorPage.testSeries
                                : ColorPage.history,
                subject: item['FileIdName'],
                notes: item['FileIdName'],
                location: item['FileIdType'],
              );

              appointments.add(newAppointment);
            }
          }
          // Add the new appointment
        }
      }
    } catch (e) {
      writeToFile(e, "loadAppointments");
      print("Error loading appointments: $e");
    } finally {
      isLoading.value = false; // Set loading to false after loading is done
    }
  }

  // Function to update selected appointments
  void _updateSelectedAppointments() {
    _selectedAppointments.value = appointments.where((appointment) {
      return appointment.startTime.year == _selectedDate.value!.year &&
          appointment.startTime.month == _selectedDate.value!.month &&
          appointment.startTime.day == _selectedDate.value!.day;
    }).toList();
  }

  // Function to toggle the tooltip
  void _toggleTooltip() {
    _showTooltip.value = !_showTooltip.value;

    if (_showTooltip.value) {
      _tooltipTimer?.cancel(); // Cancel any existing timer
      _tooltipTimer = Timer(const Duration(seconds: 3), () {
        _showTooltip.value = false;
      });
    }
  }

  late final Dio dio;
  // String? _videoFilePath;
  RxList<double> downloadProgress = List<double>.filled(1000, 0.0).obs;

  @override
  void dispose() {
    _tooltipTimer
        ?.cancel(); // Ensure the timer is canceled when the widget is disposed
    super.dispose();
  }

  // Function to handle selection change on the calendar

  // Function to get background color based on date
  Color getCellBackgroundColor(DateTime date) {
    if (date.day % 2 == 0) {
      return const Color.fromARGB(
          202, 119, 142, 182); // Even date background color
    } else {
      return const Color.fromARGB(
          0, 255, 255, 255); // Odd date background color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        // Show loading indicator while waiting for the data to load
        return const Center(child: CircularProgressIndicator());
      }

      // Once the data is loaded, display the calendar
      return buildCalendar(context);
    });
  }

  // Function to build the calendar view
  Widget buildCalendar(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height / 1.9,
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(10),
      // ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Obx(
        () => Row(
          children: [
            // The Calendar widget on the left
            Expanded(
              flex: 30, // Takes 2/3 of the screen width
              child: Stack(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: SfCalendar(
                      view: CalendarView.month,
                      // The initial display date:
                      // initialDisplayDate: _displayDate,
                      // Turn off built-in navigation arrows:
                      // showNavigationArrow: false,
                      // // Hide the built-in header so we can use our custom row:
                      // showDatePickerButton: false,
                      // headerHeight: 0, // hide the default header
                      // todayHighlightColor: Colors.transparent,

                      // // Supply data:
                      // // dataSource: _getCalendarDataSource(),

                      // // Turn off leading/trailing dates if you like:
                      // monthViewSettings: const MonthViewSettings(
                      //   showTrailingAndLeadingDates: false,
                      //   dayFormat: 'EEE',
                      //   // three-letter day format: Sun, Mon, etc.
                      // ),
                      // cellBorderColor: Colors.red,
                      // todayHighlightColor: Colors.red,
                      // showTodayButton: true,

                      onSelectionChanged: (details) {
                        _selectedDate.value = details.date;
                        _updateSelectedAppointments();
                      },
                      headerHeight: 40,
                      // cellBorderColor: const Color.fromARGB(239, 219, 11, 11),
                      showCurrentTimeIndicator: true,
                      viewHeaderHeight: 50,
                      viewHeaderStyle: const ViewHeaderStyle(
                        dayTextStyle: TextStyle(
                            fontFamily: 'AltoneRegular',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      headerStyle: CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                          textStyle: const TextStyle(
                              fontFamily: 'AltoneBold',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          backgroundColor: ColorPage.colorbutton),
                      // view: CalendarView.month,
                      monthCellBuilder:
                          (BuildContext context, MonthCellDetails details) {
                        final DateTime date = details.date;
                        final bool isEvenDate = date.day % 2 == 0;
                        final bool isSelectedDate =
                            _selectedDate.value != null &&
                                date.year == _selectedDate.value!.year &&
                                date.month == _selectedDate.value!.month &&
                                date.day == _selectedDate.value!.day;
                        final bool hasEvent = appointments.any((appointment) =>
                            appointment.startTime.year == date.year &&
                            appointment.startTime.month == date.month &&
                            appointment.startTime.day == date.day);

                        final isOrangeBorder = (date.year == 2024 &&
                            date.month == 12 &&
                            date.day == 23);

                        // Get the appointments for this specific date
                        List<Appointment> dateAppointments = appointments
                            .where((appointment) =>
                                appointment.startTime.year == date.year &&
                                appointment.startTime.month == date.month &&
                                appointment.startTime.day == date.day)
                            .toList();

                        // Group appointments by color
                        Set<String> eventType = {};
                        if (dateAppointments.isNotEmpty) {
                          for (var appointment in dateAppointments) {
                            eventType.add(appointment.location!);
                          }
                        }

                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: hasEvent
                                    ? const Color(0xFFCEEFFF) // Light Blue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                                // border: Border.all(
                                //   color: isSelectedDate
                                //       ? Colors.blue
                                //       : Colors.grey.shade300,
                                //   // width:
                                //   //     isOrangeBorder || isSelectedDate ? 2 : 1,
                                // ),
                              ),
                              alignment: Alignment.center,
                              // decoration: BoxDecoration(
                              //     color: hasEvent
                              //         ? const Color.fromARGB(255, 184, 215, 241)
                              //         : isSelectedDate
                              //             ? const Color.fromARGB(255, 219, 196,
                              //                 248) // Highlight color for the selected date
                              //             : Color.fromARGB(255, 255, 255, 255),
                              //     border: isSelectedDate
                              //         ? Border.all(
                              //             color: const Color.fromARGB(
                              //                 255,
                              //                 3,
                              //                 29,
                              //                 100), // Border color for the selected date
                              //             width: 2,
                              //           )
                              //         : Border.all(
                              //             color: const Color.fromARGB(
                              //                 255, 231, 230, 230))
                              //     // : Border.all(
                              //     //     color: const Color.fromARGB(255, 100, 100, 100), // Border color for the selected date
                              //     //     width: 1,
                              //     //   ),
                              //     ),
                              child: Center(
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelectedDate
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                  // style: TextStyle(
                                  //   fontSize: 18,
                                  //   color:
                                  //       //  isSelectedDate
                                  //       //     ? Colors.white // Text color for the selected date
                                  //       //     :
                                  //       Colors.black,
                                  //   fontWeight: isSelectedDate
                                  //       ? FontWeight.bold
                                  //       : FontWeight.normal,
                                  // ),
                                ),
                              ),
                            ),
                            // Show one dot per event color
                            if (eventType.isNotEmpty)
                              Positioned(
                                bottom: 5,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: eventType.map((location) {
                                    double iconSize = 15;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: location == "Video"
                                          ? Icon(
                                              Icons.video_library,
                                              color: ColorPage.recordedVideo,
                                              size: iconSize,
                                            )
                                          : location == "Live"
                                              ? Icon(Icons.live_tv,
                                                  color: ColorPage.live,
                                                  size: iconSize)
                                              : location == "YouTube"
                                                  ? Icon(Icons.live_tv,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 163, 4, 4),
                                                      size: iconSize)
                                                  : location == "Test"
                                                      ? Icon(Icons.book,
                                                          color: ColorPage
                                                              .testSeries,
                                                          size: iconSize)
                                                      : Icon(Icons.history,
                                                          color:
                                                              ColorPage.history,
                                                          size: iconSize),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        );
                      },
                      monthViewSettings: const MonthViewSettings(
                        dayFormat: 'EEE',
                        monthCellStyle: MonthCellStyle(
                            todayBackgroundColor:
                                Color.fromARGB(255, 148, 147, 147)),
                        agendaViewHeight: 60,
                        showTrailingAndLeadingDates: false,
                        showAgenda: false,
                      ),
                      // onSelectionChanged: (details) {
                      //   _selectedDate.value = details.date;
                      //   _updateSelectedAppointments();
                      // },
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 10,
                    child: MouseRegion(
                      onEnter: (_) {
                        _showTooltip.value = true;
                      },
                      onExit: (_) {
                        _showTooltip.value = false;
                      },
                      child: IconButton(
                        icon: const Icon(Icons.info_outline,
                            color: Color.fromARGB(255, 255, 255, 255)),
                        onPressed: _toggleTooltip,
                      ),
                    ),
                  ),
                  _showTooltip.value
                      ? Positioned(
                          top: 55,
                          right: 10,
                          child: TooltipWidget(),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),

            // The event details on the right side
            Expanded(
              flex: 20, // Takes 1/3 of the screen width
              child: Container(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
                decoration: const BoxDecoration(
                  color: ColorPage.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: _buildEventDetails(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetails() {
    return Obx(() {
      if (_selectedAppointments.isEmpty) {
        return const Center(
          // You can wrap this in any Container or Card, if desired
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No events for this day',
                style: TextStyle(
                  fontSize: 18, // Adjust as needed
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8), // spacing between lines
              Text(
                'Select a date with an event to see more details here.',
                style: TextStyle(
                  fontSize: 14, // Adjust as needed
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _selectedAppointments.length,
        itemBuilder: (context, index) {
          Appointment appointment = _selectedAppointments[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              borderRadius: BorderRadius.circular(8),
              elevation: 10.0,
              shadowColor: Colors.blueGrey.shade400.withOpacity(0.4),

              // shadowColor: Colors.black,

              child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    // side: BorderSide(color: Colors.black),
                  ),
                  hoverColor: const Color.fromARGB(255, 241, 241, 241),
                  tileColor: Colors.white,
                  onTap: () async {},
                  leading: whichIcon(appointment.location),
                  trailing: appointment.location == "Live" ||
                          appointment.location == "YouTube"
                      ? TextButton(
                          style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              backgroundColor: WidgetStatePropertyAll(
                                  appointment.location == "Live"
                                      ? const Color.fromARGB(255, 21, 130, 29)
                                      : const Color.fromARGB(
                                          255, 255, 106, 95))),
                          onPressed: () {
                            if (appointment.location == "Live" ||
                                appointment.location == "YouTube") {
                              getMeetingList(context).whenComplete(() {
                                try {
                                  var meeting = findLiveDtails(
                                      (appointment.resourceIds![0] as Map<
                                              String, dynamic>)['SessionId']
                                          .toString(),
                                      getx.todaymeeting);
                                  print(meeting!.topicName.toString() +
                                      "meeting");
                                  if (meeting != null) {
                                    runLiveExe(meeting);
                                    print(meeting.topicName);
                                  }
                                } catch (e) {
                                  print(e.toString());
                                }
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              'Live class',
                              style: style.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        )
                      : appointment.location == "Video"
                          ? TextButton(
                              style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  backgroundColor: WidgetStatePropertyAll(
                                      ColorPage.colorbutton)),
                              onPressed: () async {
                                if (appointment.location == "Video") {
                                  try {
                                    print(fetchDownloadPathOfVideo(
                                        (appointment.resourceIds![0] as Map<
                                                String, dynamic>)['FileId']
                                            .toString(),
                                        (appointment.resourceIds![0] as Map<
                                                    String,
                                                    dynamic>)['PackageId']
                                                .toString() +
                                            "did"));

                                    getx.playLink.value = getx
                                            .userSelectedPathForDownloadVideo
                                            .isEmpty
                                        ? getx.defaultPathForDownloadVideo.value +
                                            '\\' +
                                            (appointment.resourceIds![0] as Map<
                                                    String,
                                                    dynamic>)['FileIdName']
                                                .toString()
                                        : getx.userSelectedPathForDownloadVideo.value +
                                            '\\' +
                                            (appointment.resourceIds![0] as Map<
                                                    String,
                                                    dynamic>)['FileIdName']
                                                .toString();
                                    if (File(getx
                                                .userSelectedPathForDownloadVideo
                                                .isEmpty
                                            ? getx.defaultPathForDownloadVideo
                                                    .value +
                                                '\\' +
                                                (appointment.resourceIds![0] as Map<
                                                        String,
                                                        dynamic>)['FileIdName']
                                                    .toString()
                                            : getx.userSelectedPathForDownloadVideo
                                                    .value +
                                                '\\' +
                                                (appointment.resourceIds![0] as Map<
                                                        String,
                                                        dynamic>)['FileIdName']
                                                    .toString())
                                        .existsSync()) {
                                      fetchUploadableVideoInfo()
                                          .then((valueList) async {
                                        if (getx.isInternet.value) {
                                          unUploadedVideoInfoInsert(
                                              context,
                                              valueList,
                                              getx.loginuserdata[0].token,
                                              false);
                                        }

                                        getx.playingVideoId.value =
                                            (appointment.resourceIds![0] as Map<
                                                    String, dynamic>)['FileId']
                                                .toString();
                                        if (await isProcessRunning(
                                                "dthlmspro_video_player") ==
                                            true) {
                                          Get.showSnackbar(GetSnackBar(
                                            isDismissible: true,
                                            shouldIconPulse: true,
                                            icon: const Icon(
                                              Icons.video_chat,
                                              color: Colors.white,
                                            ),
                                            snackPosition: SnackPosition.TOP,
                                            title:
                                                'Player is already running in background!',
                                            message:
                                                'Please check your taskbar.',
                                            mainButton: TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text(
                                                'Ok',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            duration:
                                                const Duration(seconds: 3),
                                          ));
                                        }

                                        if (await isProcessRunning(
                                                "dthlmspro_video_player") ==
                                            false) {
                                          run_Video_Player_exe(
                                              getx.playLink.value,
                                              getx.loginuserdata[0].token,
                                              getx.playingVideoId.value,
                                              (appointment.resourceIds![0]
                                                      as Map<String,
                                                          dynamic>)['PackageId']
                                                  .toString(),
                                              getx.dbPath.value);
                                        }
                                      });
                                    } else {
                                      _onDownloadVideo(
                                          context,
                                          (appointment.resourceIds![0] as Map<
                                                  String,
                                                  dynamic>)['DocumentPath']
                                              .toString(),
                                          (appointment.resourceIds![0] as Map<
                                                  String,
                                                  dynamic>)['FileIdName']
                                              .toString(),
                                          (appointment.resourceIds![0] as Map<
                                                  String, dynamic>)['PackageId']
                                              .toString(),
                                          (appointment.resourceIds![0]
                                                  as Map<String, dynamic>)['FileId']
                                              .toString());
                                    }
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                child: Text(
                                  'Play',
                                  style: style.copyWith(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            )
                          : const SizedBox(),
                  title: Text(appointment.subject,
                      overflow: TextOverflow.ellipsis,
                      style: FontFamily.style.copyWith(
                          color: ColorPage.colorblack,
                          fontWeight: FontWeight.bold)),
                  subtitle: appointment.location == "Live" ||
                          appointment.location == "YouTube"
                      ? Text(
                          "Start at: " +
                                  DateFormat('h:mm a')
                                      .format(appointment.startTime) ??
                              'No details available.',
                          style: FontFamily.style.copyWith(
                              fontSize: 14, color: ColorPage.colorblack),
                        )
                      : appointment.location == "Video"
                          ? Text(
                              "Duration :${(appointment.resourceIds![0] as Map<String, dynamic>)['VideoDuration'].toString()} ",
                              style: FontFamily.style.copyWith(
                                  fontSize: 14, color: ColorPage.colorblack),
                            )
                          : const SizedBox()),
            ),
          );
        },
      );
    });
  }

  _onNoInternetConnection(context) {
    Alert(
      context: context,
      type: AlertType.error,
      style: AlertStyle(
        titleStyle:
            const TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      title: "!! No internet found !!",
      desc: "Make sure you have a proper internet Connection.  ",
      buttons: [
        DialogButton(
          child: const Text("OK",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: const Color.fromRGBO(3, 77, 59, 1),
          onPressed: () {
            Navigator.pop(context);
          },
          color: const Color.fromRGBO(9, 89, 158, 1),
        ),
      ],
    ).show();
  }

  Icon? whichIcon(String? location) {
    double iconSize = 20;

    switch (location) {
      case "YouTube":
        return Icon(Icons.live_tv,
            color: const Color.fromARGB(255, 163, 4, 4), size: iconSize);
      case "Live":
        return Icon(Icons.live_tv, color: ColorPage.live, size: iconSize);
      case "Video":
        return Icon(
          Icons.video_library,
          color: ColorPage.recordedVideo,
          size: iconSize,
        );
      case "Test":
        return Icon(Icons.book, color: ColorPage.testSeries, size: iconSize);
      case "History":
        return Icon(Icons.history, color: ColorPage.history, size: iconSize);
      default:
        return Icon(Icons.warning_amber_rounded,
            color: Colors.red, size: iconSize);
    }
  }

  MeetingDeatils? findLiveDtails(
      String sessionId, List<MeetingDeatils> mettingList) {
    MeetingDetails liveDetails;
    print(sessionId);
    for (var item in mettingList) {
      print(mettingList.length);
      print(item.sessionId);
      if (item.sessionId == sessionId) {
        print(item.sessionId.toString() + "item");
        return item;
      }
    }
  }

  Future<String> getVideosDirectoryPath() async {
    final String userHomeDir =
        Platform.environment['USERPROFILE'] ?? 'C:\\Users\\Default';

    final String videosDirPath = p.join(userHomeDir, 'Videos');

    print('Videos Directory Path: $videosDirPath');

    return videosDirPath;
  }

  RxBool isVideoDownloading = false.obs;

  Future<void> startDownload2(
      int index,
      String link,
      String title,
      String packageId,
      String fileid,
      CancelToken cancelToken // Add CancelToken parameter
      ) async {
    if (link == "0") {
      print("Video link is $link");
      return;
    }

    // Set the flag to true indicating the download has started
    setState(() {
      isVideoDownloading.value = true;
    });

    final appDocDir;
    try {
      var prefs = await SharedPreferences.getInstance();
      if (Platform.isAndroid) {
        final path = await getApplicationDocumentsDirectory();
        appDocDir = path.path;
      } else {
        appDocDir = await getVideosDirectoryPath();
      }

      getx.defaultPathForDownloadVideo.value =
          appDocDir + '\\$origin' + '\\Downloaded_videos';
      prefs.setString("DefaultDownloadpathOfVieo",
          appDocDir + '\\$origin' + '\\Downloaded_videos');
      print(getx.userSelectedPathForDownloadVideo.value +
          " it is user selected path");

      String savePath = getx.userSelectedPathForDownloadVideo.isEmpty
          ? appDocDir + '\\$origin' + '\\Downloaded_videos' + '\\$title'
          : getx.userSelectedPathForDownloadVideo.value + '\\$title';

      String tempPath = appDocDir + '\\temp' + '\\$title';

      await Directory(appDocDir + '\\temp').create(recursive: true);

      await dio.download(
        link,
        tempPath,
        cancelToken: cancelToken, // Pass the cancel token here
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total * 100);
            downloadProgress[index] = progress;
          }
        },
      );

      // After download is complete, copy the file to the final location
      final tempFile = File(tempPath);
      final finalFile = File(savePath);

      // Ensure the final directory exists
      await finalFile.parent.create(recursive: true);

      // Copy the file to the final path
      await tempFile.copy(savePath);

      // Delete the temporary file
      await tempFile.delete();

      // Update reactive variables directly
      getx.playingVideoId.value = fileid;
      getx.playLink.value = savePath;

      print('$savePath video saved to this location');

      // Insert the downloaded file data into the database
      await insertDownloadedFileData(
          packageId, fileid, savePath, 'Video', title);

      insertVideoDownloadPath(
        fileid,
        packageId,
        savePath,
        context,
      );
    } catch (e) {
      if (e is DioError && e.type == DioErrorType.cancel) {
        writeToFile(e, "insertVideoDownloadPath");
        print("Download was canceled");
      } else {
        print(e.toString() + " error on download");
      }
    } finally {
      // After the download process completes, set the flag to false
      setState(() {
        isVideoDownloading.value = false;
      });
    }
  }

// Cancel the download
  void cancelDownload(CancelToken cancelToken) {
    cancelToken.cancel("Download canceled by user.");
    print("Download canceled");
  }

  CancelToken cancelToken = CancelToken();

  _onDownloadVideo(
      context, String link, String title, String packageId, String fileId) {
    RxBool isDownloading = false.obs;
    downloadProgress[1] = 0.0;

    Alert(
      context: context,
      style: AlertStyle(
        titleStyle: const TextStyle(color: Color.fromARGB(255, 54, 105, 244)),
        descStyle: FontFamily.font6,
        isCloseButton: false,
      ),
      image: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Obx(() {
          if (downloadProgress[1] < 100 && downloadProgress[1] > 0) {
            return CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 12.0,
              percent: downloadProgress[1] / 100,
              center: Text(
                "${downloadProgress[1].toInt()}%",
                style: const TextStyle(fontSize: 10.0),
              ),
              progressColor: ColorPage.colorbutton,
            );
          } else if (downloadProgress[1] == 100) {
            return Icon(
              Icons.download_done,
              size: 100,
              color: ColorPage.colorbutton,
            );
          } else {
            return Icon(
              Icons.download,
              size: 100,
              color: ColorPage.colorbutton,
            );
          }
        }),
      ),
      title: "Download Video",
      desc:
          "This Video is not Download yet!\n Click Download button & Play it.",
      buttons: [
        DialogButton(
          child: Obx(
            () => Text(
                downloadProgress[1] == 100
                    ? "Cancel"
                    : (isDownloading.value ? "Cancel Downloading" : "Cancel"),
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
          highlightColor: ColorPage.appbarcolor,
          onPressed: () {
            (downloadProgress[1] > 1 && downloadProgress[1] < 100)
                ? cancelDownload(cancelToken)
                : null;
            Future.delayed(Duration(
                    seconds:
                        (downloadProgress[1] > 1 && downloadProgress[1] < 100)
                            ? 2
                            : 0))
                .then(
              (value) {
                Get.back();
              },
            );
          },
          color: const Color.fromARGB(255, 243, 33, 33),
        ),
        DialogButton(
          child: Obx(() => Text(
                downloadProgress[1] == 100
                    ? "Play"
                    : (isDownloading.value ? "Downloading..." : "Download"),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )),
          highlightColor: ColorPage.appbarcolor,
          onPressed: (isDownloading.value ||
                  downloadProgress[1] > 0 && downloadProgress[1] < 100)
              ? null
              : () async {
                  if (downloadProgress[1] == 100) {
                    print("hello");
                    Get.back();
                    fetchUploadableVideoInfo().then((valueList) async {
                      unUploadedVideoInfoInsert(context, valueList,
                          getx.loginuserdata[0].token, false);

                      if (await isProcessRunning("dthlmspro_video_player") ==
                          false) {
                        run_Video_Player_exe(
                            getx.playLink.value,
                            getx.loginuserdata[0].token,
                            fileId,
                            packageId,
                            getx.dbPath.value);
                      }
                      if (await isProcessRunning("dthlmspro_video_player") ==
                          true) {
                        Get.showSnackbar(GetSnackBar(
                          isDismissible: true,
                          shouldIconPulse: true,
                          icon:
                              const Icon(Icons.video_chat, color: Colors.white),
                          snackPosition: SnackPosition.TOP,
                          title: 'Player is already open',
                          message: 'Please check your taskbar.',
                          mainButton: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Ok',
                                style: TextStyle(color: Colors.white)),
                          ),
                          duration: const Duration(seconds: 3),
                        ));
                      }
                    });
                  } else {
                    if (!isDownloading.value) {
                      // Start the download process
                      cancelToken = CancelToken();
                      isDownloading.value = true;
                      await startDownload2(
                          1, link, title, packageId, fileId, cancelToken);
                      isDownloading.value = false; // Reset after download
                    }
                  }
                },
          color: link == 0 ? Colors.grey : ColorPage.blue,
        ),
      ],
    ).show();
  }
}

// Dumm

// Dummy widget for tooltip

// class EventDataSource extends CalendarDataSource {
//   EventDataSource(List<Appointment> source) {
//     appointments = source;
//   }

//   @override
//   Color getMonthCellBackgroundColor(DateTime date) {
//     // Get all the appointments on the specific date
//     List<dynamic> eventsForDate = appointments!.where((appointment) {
//       return appointment.startTime.year == date.year &&
//           appointment.startTime.month == date.month &&
//           appointment.startTime.day == date.day;
//     }).toList();

//     if (eventsForDate.isNotEmpty) {
//       // If there is only one event, return its color
//       if (eventsForDate.length == 1) {
//         return eventsForDate.first.color;
//       }
//       // If there are multiple events, return a mixed color (you can customize this logic)
//       return const Color.fromARGB(255, 43, 4, 4); // Return a default color for multiple events
//     }

//     return Colors.white; // Return default background if no events
//   }
// }

// Dummy widget for tooltip

class TooltipWidget extends StatelessWidget {
  double iconSize = 15;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            const BoxShadow(
              blurRadius: 10,
              color: Colors.black26,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.live_tv,
                  size: iconSize,
                  color: ColorPage.live,
                ),
                const SizedBox(width: 8),
                const Text('Live Class'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.live_tv,
                  size: iconSize,
                  color: const Color.fromARGB(255, 163, 4, 4),
                ),
                const SizedBox(width: 8),
                const Text('YouTube Live Class'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.video_library,
                  size: iconSize,
                  color: ColorPage.recordedVideo,
                ),
                const SizedBox(width: 8),
                const Text('Recorded Video'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.history,
                  size: iconSize,
                  color: ColorPage.history,
                ),
                const SizedBox(width: 8),
                const Text('History'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.book,
                  size: iconSize,
                  color: ColorPage.testSeries,
                ),
                const SizedBox(width: 8),
                const Text('Test Series'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HeadingBox extends StatefulWidget {
  @override
  State<HeadingBox> createState() => _HeadingBoxState();
}

class _HeadingBoxState extends State<HeadingBox> {
  final CarouselSliderController carouselController =
      CarouselSliderController();

  RxInt currentIndex = 0.obs;
  @override
  initState() {
    super.initState();
    if (getx.bannerImageList.isEmpty) {
      getHomePageBannerImage(context, getx.loginuserdata[0].token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.transparent,
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                child: FutureBuilder(
                  future: getAllTblImages(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Filter the items before mapping
                      final filteredItems = snapshot.data!
                          .where((item) =>
                              item['ImageType'] != null &&
                              item['ImageType']
                                  .toString()
                                  .toLowerCase()
                                  .contains('banner'))
                          .toList();

                      // Check if filtered items are empty
                      if (filteredItems.isEmpty) {
                        return const Center(
                          child: Text(
                            'No banners available',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      }

                      return CarouselSlider(
                        items: filteredItems.map((item) {
                          return InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: item["BannerImagePosition"] == "middle"
                                    ? item["BannerImagePosition"] != null
                                        ? File(item['ImageUrl']).existsSync()
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  File(item['ImageUrl']!),
                                                  fit: BoxFit.fill,
                                                  width: double.infinity,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Center(
                                                      child: Text(
                                                        'Image failed',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            : const Center(
                                                child: Text('Image not found'),
                                              )
                                        : const Center(
                                            child: CircularProgressIndicator())
                                    : HeadingBoxContent(
                                        imagePath: item['ImageUrl'],
                                        imagePosition:
                                            item["BannerImagePosition"],
                                        isImage: true,
                                        title: item["BannerContent"],
                                      ),
                              ),
                            ),
                          );
                        }).toList(),
                        carouselController: carouselController,
                        options: CarouselOptions(
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          aspectRatio: 2,
                          viewportFraction: 0.98,
                          onPageChanged: (index, reason) {
                            currentIndex.value = index;
                          },
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )),
          ),
        ),
        // : SizedBox(
        //     height: 300,
        //     child: Center(
        //       child: Text(
        //         " No image Found",
        //         style:
        //             FontFamily.font5.copyWith(color: ColorPage.colorblack),
        //       ),
        //     ),
        //   )),
        Obx(
          () => getx.bannerImageList.isNotEmpty
              ? Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: getx.bannerImageList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () =>
                            carouselController.animateToPage(entry.key),
                        child: Container(
                          width: currentIndex == entry.key ? 18 : 10,
                          height: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                              color: currentIndex == entry.key
                                  ? ColorPage.blue
                                  : ColorPage.white),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}

class HeadingBoxContent extends StatelessWidget {
  final String? date;
  final String? title;
  final String? desc;
  final Widget? trailing;
  final String imagePath;
  final String imagePosition;
  final bool isImage;
  const HeadingBoxContent({
    super.key,
    this.date,
    this.title,
    this.desc,
    required this.imagePosition,
    this.trailing,
    required this.isImage,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        const TextStyle(fontFamily: 'AltoneRegular', fontSize: 20);
    TextStyle styleb = const TextStyle(fontFamily: 'AltoneBold', fontSize: 20);
    return SizedBox(
      height: 300,
      child: LayoutBuilder(builder: (context, constraints) {
        return isImage && imagePosition == 'right'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text at the start
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Container(
                      child: HtmlWidget(title!),
                    ),
                  ),

                  // Image at the end
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width / 2.5,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Image failed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width / 2.5,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Image failed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ),
                  // Text at the start

                  Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Container(
                        child: HtmlWidget(
                          title ?? "",
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                      )),

                  // Image at the end
                ],
              );
      }),
    );
  }
}

// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';

// Future<bool> isEmulator() async {
//   final deviceInfo = DeviceInfoPlugin();

//   if (Platform.isAndroid) {
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     // Check for emulator-specific identifiers
//     if (androidInfo.model.toLowerCase().contains('emulator') ||
//         androidInfo.model.toLowerCase().contains('sdk') ||
//         androidInfo.hardware.toLowerCase().contains('goldfish') ||
//         androidInfo.hardware.toLowerCase().contains('ranchu') ||
//         androidInfo.product.toLowerCase().contains('sdk_google')) {
//       return true;
//     }
//   } else if (Platform.isIOS) {
//     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//     // Check for iOS simulator
//     if (iosInfo.model?.toLowerCase().contains('simulator') ?? false) {
//       return true;
//     }
//   }

//   // If the checks don't match, the device is not an emulator
//   return false;
// }

Future<bool> isProcessRunning(String processName) async {
  final result = await Process.run('tasklist', []);
  return result.stdout.toString().contains(processName);
}
