import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/MOBILE/PROFILE/app_settings.dart';
import 'package:dthlms/MOBILE/PROFILE/contact_us.dart';
import 'package:dthlms/MOBILE/PROFILE/devicehistorymobile.dart';
import 'package:dthlms/MOBILE/PROFILE/exam_history_mobile.dart';
import 'package:dthlms/PC/PROFILE/userProfilePage.dart';
import 'package:dthlms/THEME_DATA/FontSize/FontSize.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../HOMEPAGE/homepage_mobile.dart';

class MyAccountScreen extends StatefulWidget {
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

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'My Account',
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
              color: ColorPage.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                    // backgroundImage: AssetImage("assets/sorojda.png"),
                    ),
                title: Text(getx.loginuserdata[0].firstName +
                    " " +
                    getx.loginuserdata[0].lastName),
                subtitle: Text(getx.loginuserdata[0].email),
              ),
            ),
            SectionHeader(title: 'General'),
            Card(
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
                  MenuItem(
                    icon: Icons.settings,
                    title: 'App settings',
                    onTap: () {
                      Get.to(AppSettingsAndroid());
                    },
                  ),
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
                      Get.to( transition: Transition.cupertino,()=>DeviceHistoryMobile());
                    },
                  ),
                  MenuItem(
                    icon: Icons.assignment,
                    title: 'Exam History',
                    onTap: () {
                      Get.to( transition: Transition.cupertino,()=>ExamHistoryMobile());
                    },
                  ),
                ],
              ),
            ),
            SectionHeader(title: 'Support'),
            Card(
              color: ColorPage.white,
              child: Column(
                children: [
                  MenuItem(
                    icon: Icons.help_outline,
                    title: "Need help? Let's chat",
                    onTap: () {
                      Get.toNamed('/Needhelppage');
                    },
                  ),
                  MenuItem(
                    icon: Icons.feedback,
                    title: 'Feedback',
                    onTap: () {
                      Get.toNamed('/Feedbackmobile');
                    },
                  ),
                  MenuItem(
                    icon: FontAwesome.comment,
                    title: 'Contact Us',
                    onTap: () {
                      Get.to( transition: Transition.cupertino,()=>ContactUs());
                    },
                  ),
                  MenuItem(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy', 
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),      
            Card(
              color: ColorPage.white,
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Log Out',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onTap: logOut
              ),
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
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
      ),
      onTap: onTap,
    );
  }
}
