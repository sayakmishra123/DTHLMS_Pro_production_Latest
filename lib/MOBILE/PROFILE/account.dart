import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/PROFILE/contact_us.dart';
import 'package:dthlms/MOBILE/PROFILE/devicehistorymobile.dart';
import 'package:dthlms/MOBILE/PROFILE/feedback.dart';
import 'package:dthlms/PC/PROFILE/userProfilePage.dart';
import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:dthlms/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyAccountScreen extends StatefulWidget {
  final bool fromDrawer;
  MyAccountScreen({required this.fromDrawer});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  Getx getx = Get.put(Getx());
  logOut() async {
    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        denyButtonText: "Cancel",
        title: "Are you sure?",
        text: "Are you sure you want to log out?",
        confirmButtonText: "Yes, log out",
        type: ArtSweetAlertType.question,
      ),
    );

    if (response == null) {
      return;
    }

    if (response.isTapConfirmButton) {
      if (getx.isInternet.value) {
        handleLogoutProcess(context);
      } else {
        onNoInternetConnection(context, () {
          Get.back();
        });
      }

      return;
    }
  }

  deleteAccount(data) async {
    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        denyButtonText: "Cancel",
        title: "Are you sure?",
        text: data,
        confirmButtonText: "Yes",
        confirmButtonColor: ColorPage.red,
        denyButtonColor: ColorPage.grey,
        type: ArtSweetAlertType.warning,
      ),
    );

    if (response == null) {
      return;
    }

    if (response.isTapConfirmButton) {
      if (getx.isInternet.value) {
        // handleLogoutProcess(context);
      } else {
        // onNoInternetConnection(context, () {
        //   Get.back();
        // });
      }

      return;
    }
  }

  String getFranchiseName = '';
  Map<String, String> infoList = {};

  String qrData = '';
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
    getAllPackageListOfStudent();
    getFranchiseName = getFranchiseNameFromTblSetting();
    setState(() {
      qrData = jsonEncode(infoList);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.fromDrawer,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          getFranchiseName != '' ? getFranchiseName : 'My Account',
          style: FontFamily.styleb.copyWith(color: Colors.white),
        ),
        backgroundColor: ColorPage.mainBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Card
            Card(
              elevation: 0,
              color: ColorPage.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(
                        '${getx.loginuserdata[0].firstName[0]}${getx.loginuserdata[0].lastName[0]}'
                            .toUpperCase(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      // backgroundImage: AssetImage("assets/sorojda.png"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getx.loginuserdata[0].firstName +
                            " " +
                            getx.loginuserdata[0].lastName),
                        Text(getx.loginuserdata[0].email),
                      ],
                    ),
                    Expanded(child: SizedBox()),
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
                                          
                                          gapless: false,
                                          embeddedImage: AssetImage(logopath),
                                          
                                          embeddedImageStyle:
                                              QrEmbeddedImageStyle(
                                            size: Size(50, 50),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
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
                                        )
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
                          
                            gapless: false,
                            embeddedImage: AssetImage(logopath),
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size(20, 20),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            SectionHeader(title: 'General'),
            Card(
              elevation: 0,
              color: ColorPage.white,
              child: Column(
                children: [
                  MenuItem(
                    icon: Icons.person,
                    title: 'Details',
                    onTap: () {
                      Get.toNamed('/Mobiledetailspage');
                    },
                  ),
                  // MenuItem(
                  //   icon: Icons.settings,
                  //   title: 'App settings',
                  //   onTap: () {
                  //     Get.to(AppSettingsAndroid());
                  //   },
                  // ),
                  MenuItem(
                    icon: Icons.lock,
                    title: 'Change password',
                    onTap: () {
                      Get.toNamed('/Changepasswordmobile');
                    },
                  ),
                  MenuItem(
                    icon: Icons.devices,
                    title: 'Device History',
                    onTap: () {
                      Get.to(
                          transition: Transition.cupertino,
                          () => DeviceHistoryMobile());
                    },
                  ),
                  MenuItem(
                    icon: Icons.assignment,
                    title: 'My Packages',
                    onTap: () {
                      Get.to(
                          transition: Transition.cupertino,
                          () => MyPackageMobile());
                    },
                  ),
                ],
              ),
            ),
            SectionHeader(title: 'Support'),
            Card(
              elevation: 0,
              color: ColorPage.white,
              child: Column(
                children: [
                  MenuItem(
                    icon: Icons.help_outline,
                    title: "FAQ's",
                    onTap: () {
                      Get.to(
                          transition: Transition.cupertino, () => FAQWidgetMobile());
                    },
                  ),
                  MenuItem(
                    icon: Icons.feedback,
                    title: 'Feedback',
                    onTap: () {
                      Get.to(
                          transition: Transition.cupertino, () => FeedBackMobile());
                    },
                  ),
                  MenuItem(
                    icon: MaterialIcons.email,
                    title: 'Contact Us',
                    onTap: () {
                      Get.to(
                          transition: Transition.cupertino, () => ContactUs());
                    },
                  ),
                  MenuItem(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    onTap: () { 

                      Get.to(
                          transition: Transition.cupertino, () => PrivacyPollicyMobile());
                     },
                  ),
                  MenuItem(
                    icon: FontAwesome.undo,
                    title: 'Refund Policy',
                    onTap: () {

                      Get.to(
                          transition: Transition.cupertino, () => RefundPollicyMobile());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 0,
              color: ColorPage.white,
              child: ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red),
                title: Text(
                  'Delete Account',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  deleteAccount(
                    'Are you sure you want to permanently delete your account?\n\n'
                    'This action cannot be undone, and all your personal information, '
                    'settings, and history will be permanently erased. You will lose access to your account and all associated services.',
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: ColorPage.white,
              child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onTap: logOut),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: ClsFontsize.ExtraSmall - 1,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 32, 31, 31),
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: ColorPage.blue,
      ),
      title: Text(title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
      ),
      onTap: onTap,
    );
  }
}

// Import for Platform checks

class MyPackageMobile extends StatefulWidget {
  const MyPackageMobile({Key? key}) : super(key: key);

  @override
  State<MyPackageMobile> createState() => _MyPackageMobileState();
}

class _MyPackageMobileState extends State<MyPackageMobile> {
  Getx getx = Get.put(Getx());
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "My Packages",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Material(child: MyPackage()),
    );
  }
}
