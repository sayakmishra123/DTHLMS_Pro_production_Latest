import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DeviceHistoryMobile extends StatefulWidget {
  const DeviceHistoryMobile({super.key});

  @override
  State<DeviceHistoryMobile> createState() => _DeviceHistoryMobileState();
}

class _DeviceHistoryMobileState extends State<DeviceHistoryMobile> {
  Getx getx = Get.put(Getx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorPage.mainBlue,
        title: Text(
          'Device History',
          style: FontFamily.styleb.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: _buildDeviceList(),
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
            physics: ScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  elevation: 10.0,
                  shadowColor: Colors.blueGrey.shade400.withOpacity(0.4),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    // onTap: (){},
                    hoverColor: const Color.fromARGB(255, 241, 241, 241),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey, width: 0.5),
                    ),

                    leading: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentTextStyle: FontFamily.style
                                  .copyWith(color: Colors.grey.shade600),
                              title: Text('Device ID',
                                  style: FontFamily.styleb.copyWith()),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: SelectableText(
                                          getx.DeviceLoginHistorylist[index]
                                              .deviceId1,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      IconButton(
                                        icon: Icon(
                                          Icons.copy,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                                text: getx
                                                    .DeviceLoginHistorylist[
                                                        index]
                                                    .deviceId1),
                                          );
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Device Id Copied to clipboard!'),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Close',
                                    style: FontFamily.style
                                        .copyWith(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        getx.DeviceLoginHistorylist[index].deviceName,
                        // textAlign: TextAlign.center,
                        style: FontFamily.styleb
                            .copyWith(fontSize: 15, color: Colors.black),
                      ),
                    ),

                    trailing: SizedBox(
                      width: 70,
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color:
                                !getx.DeviceLoginHistorylist[index].isLoggedIn
                                    ? Colors.transparent
                                    : Colors.green,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: 40,
                            child: Material(
                              color: Colors.white,
                              child: Center(
                                child: Ink(
                                  decoration: const ShapeDecoration(
                                    color: Colors.lightBlue,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: getPlatformIcon(getx
                                        .DeviceLoginHistorylist[index]
                                        .deviceType),
                                    color: Colors.white,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          final loginDate = getx
                                                      .DeviceLoginHistorylist[
                                                          index]
                                                      .allotedOn !=
                                                  ""
                                              ? DateFormat('yyyy-MM-dd').format(
                                                  getx
                                                      .DeviceLoginHistorylist[
                                                          index]
                                                      .allotedOn)
                                              : ' ';
                                          final loginTime = getx
                                                      .DeviceLoginHistorylist[
                                                          index]
                                                      .allotedOn !=
                                                  ""
                                              ? DateFormat('HH:mm:ss').format(
                                                  getx
                                                      .DeviceLoginHistorylist[
                                                          index]
                                                      .allotedOn)
                                              : ' ';
                                          final logoutDate = getx
                                                      .DeviceLoginHistorylist[
                                                          index]
                                                      .logoutTime !=
                                                  ""
                                              ? DateFormat('yyyy-MM-dd').format(
                                                  getx
                                                      .DeviceLoginHistorylist[
                                                          index]
                                                      .logoutTime)
                                              : ' ';
                                          final logoutTime = getx
                                                      .DeviceLoginHistorylist[
                                                          index]
                                                      .logoutTime !=
                                                  ""
                                              ? DateFormat('HH:mm:ss').format(
                                                  getx
                                                      .DeviceLoginHistorylist[
                                                          index]
                                                      .logoutTime)
                                              : ' ';

                                          return AlertDialog(
                                            // titlePadding: EdgeInsets.symmetric(horizontal: 10),
                                            contentTextStyle: FontFamily.style
                                                .copyWith(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 16),
                                            title: Expanded(
                                              child: Text(
                                                  'Device Login & Logout Times',
                                                  style: FontFamily.styleb),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Login:"),
                                                    Text('$loginDate'),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_rounded,
                                                      size: 15,
                                                    ),
                                                    Text('$loginTime'),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Logout:"),
                                                    Text('$logoutDate'),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_rounded,
                                                      size: 15,
                                                    ),
                                                    Text('$logoutTime'),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Close',
                                                  style: FontFamily.style
                                                      .copyWith(
                                                          color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
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
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildFilterListButton(String label, String sublabel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 60,
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            Text(
              sublabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey.shade600.withOpacity(0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
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
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SizedBox(
            width: 40,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            width: 100,
            child: Text(
              'Device Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[00],
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // _buildFilterButton('Device Name'),
        _buildFilterButton('Login'),
        _buildFilterButton('Logout'),
      ],
    );
  }

  Widget _buildFilterButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 60,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 12,
              color: Colors.grey[00],
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Icon getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'android':
        return Icon(
          Icons.android,
          size: 20,
        );
      case 'ios':
        return Icon(
          Icons.apple,
          size: 20,
        );
      case 'windows':
        return Icon(
          Icons.desktop_windows_outlined,
          size: 20,
        );
      case 'macos':
        return Icon(
          Icons.laptop_mac,
          size: 20,
        );
      default:
        return Icon(
          Icons.device_unknown,
          size: 20,
        );
    }
  }
}
