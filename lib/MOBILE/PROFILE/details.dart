import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/PC/LOGIN/login.dart';
import 'package:dthlms/PC/PROFILE/userProfilePage.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HOMEPAGE/homepage_mobile.dart';

class DetailsPageMobile extends StatefulWidget {
  const DetailsPageMobile({super.key});

  @override
  State<DetailsPageMobile> createState() => _DetailsPageMobileState();
}

class _DetailsPageMobileState extends State<DetailsPageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorPage.mainBlue,
        title: Text(
          'Details',
          style: FontFamily.style.copyWith(color: Colors.white),
        ),
      ),
      body: Container(color: Colors.white, child: PersonalDetails()),
    );
  }
}

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  Getx getx = Get.put(Getx());

  GlobalKey<FormState> dialogekey = GlobalKey();

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

      // onPressed: () async {
                   
      //             },
 
    if (response.isTapConfirmButton) {
 Navigator.pop(context);

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
      body: SingleChildScrollView(
        child: Container(
          // height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
            // need singlechild scroll view
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Text(" Personal Details",
                //         style: style.copyWith(
                //             fontSize: 25,
                //             color: Colors.black45,
                //             fontWeight: FontWeight.w900))
                //   ],
                // ),

                DetailsHeader(title: 'Name'),
                DetailsItem(
                  icon: Icons.person,
                  title: getx.loginuserdata[0].firstName +
                      " " +
                      getx.loginuserdata[0].lastName,
                  type: "name",
                  isEditable: false,
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
                  onTap: logOut
                
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
  }

  late SharedPreferences prefs;

  _logoutConfirmetionBox(context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      alertPadding: EdgeInsets.only(top: 200),
      descStyle: TextStyle(),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.grey),
      ),
      titleStyle: TextStyle(
          color: const Color.fromARGB(255, 243, 33, 33),
          fontWeight: FontWeight.bold),
      constraints: BoxConstraints.expand(width: 350),
      overlayColor: Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center,
    );
    Alert(
      context: context,
      type: AlertType.warning,
      style: alertStyle,
      title: "Are you sure ?",
      desc:
          "Once you are logout your all data will be cleared and you should login again!",
      buttons: [
        DialogButton(
          width: 150,
          child: Text("Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          highlightColor: Color.fromARGB(255, 203, 46, 46),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromARGB(255, 139, 19, 19),
        ),
        DialogButton(
          width: 150,
          highlightColor: Color.fromARGB(255, 2, 2, 60),
          child:
              Text("Yes", style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () async {
            Navigator.pop(context);

            prefs = await SharedPreferences.getInstance();

            prefs.clear();
            getx.loginuserdata.clear();

            Get.offAll(() => DthLmsLogin());
          },
          color: const Color.fromARGB(255, 1, 12, 31),
        ),
      ],
    ).show();
  }

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
      title: "Edit your ${type}",
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
                  border: InputBorder.none,
                  labelText: 'Enter your ${type}',
                  filled: true,
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
