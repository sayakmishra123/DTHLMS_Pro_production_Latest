import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/API/LOGIN/login_api.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/homepage_mobile.dart';
import 'package:dthlms/MOBILE/LOGIN/loginpage_mobile.dart';
import 'package:dthlms/MOBILE/MCQ/RankCompetitionMcqExamPageMobile.dart';
import 'package:dthlms/MOBILE/SIM_INFORMATION/sim_information.dart';
import 'package:dthlms/MODEL_CLASS/login_model.dart';
import 'package:dthlms/PC/HOMEPAGE/homepage.dart';
import 'package:dthlms/PC/LOGIN/login.dart';
import 'package:dthlms/notificationsave.dart';
import 'package:dthlms/routes/router.dart';
import 'package:dthlms/security.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_android_developer_mode/flutter_android_developer_mode.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:media_kit/media_kit.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simnumber/sim_number.dart';
import 'package:simnumber/siminfo.dart';
import 'package:sqlcipher_library_windows/sqlcipher_library_windows.dart';
import 'package:sqlite3/open.dart';
import 'package:windows_single_instance/windows_single_instance.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
// import 'package:no_screenshot/no_screenshot.dart';
import 'notification_model.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  // ensureYQPInitialized();
  Get.put(OnlineAudioPlayerController()); 

  function() async {
    open.overrideFor(OperatingSystem.windows, openSQLCipherOnWindows);

    testSQLCipherOnWindows();
    if (Platform.isWindows) {
      doWhenWindowReady(
        () {
          final win = appWindow;
          win.minSize = const Size(1300, 600);
          win.alignment = Alignment.topLeft;
          win.show();
        },
      );
    } else if (Platform.isAndroid) {
      // disableScreenshot();
      // await InAppWebViewController.setWebContentsDebuggingEnabled(true);
      initializeNotifications();
    }

    // firbase();
    singleInstance(args);
  }

  function();

  runApp(
    MyApp(args),
  );
}

class MyApp extends StatefulWidget {
  List<String> args;
  MyApp(this.args, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  pageRouter router = pageRouter();
  // late Future<void> userDetailsFuture; 

  @override
  void initState() {
    super.initState();
    appVersionGet();

// A
// lue.toString() +
//         "");

    if (Platform.isWindows && kReleaseMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // setWindowDisplayAffinity();
      });
      if (getx.isTimerOn.value) {
        Timer.periodic(Duration(seconds: 10), (timer) async {
          // print(getx.blackListProcess.length);
          if (getx.blackListProcess.isNotEmpty && getx.isTimerOn.value) {
            getRunningBackgroundAppsAndKill(context);
          } else {
            getx.blackListProcess.value = await fetchBlackList();
            getx.whiteListProcess.value = await fetchWhiteList();
          }
        });
      }
    }
  }

  Getx getx = Get.put(Getx());

  Future<void> checkDeveloperMode() async {
    if (Platform.isAndroid) {
      getx.isAndroidDeveloperModeEnabled.value =
          await FlutterAndroidDeveloperMode.isAndroidDeveloperModeEnabled;
    }
  }

  Future<void> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    // log(prefs.)
    getx.loginId.value = prefs.getString("LoginId") ?? '';

    String? userdataJson = prefs.getString('userDetails');
    getx.userSelectedPathForDownloadVideo.value =
        prefs.getString('SelectedDownloadPathOfVieo') ?? '';
    getx.userSelectedPathForDownloadFile.value =
        prefs.getString('SelectedDownloadPathOfFile') ?? '';
    getx.defaultPathForDownloadFile.value =
        prefs.getString("DefaultDownloadpathOfFile") ?? '';
    getx.defaultPathForDownloadVideo.value =
        prefs.getString("DefaultDownloadpathOfVieo") ?? '';
    getx.userImageLocalPath.value = prefs.getString("LocalImagePath") ?? "";

    if (userdataJson != null) {
      Map<String, dynamic> userdataMap = jsonDecode(userdataJson);
      DthloginUserDetails userdata = DthloginUserDetails(
          firstName: userdataMap['firstName'].toString(),
          lastName: userdataMap['lastName'].toString(),
          email: userdataMap['email'].toString(),
          phoneNumber: userdataMap['phoneNumber'],
          token: userdataMap['token'].toString() ?? "",
          nameId: userdataMap['nameId'].toString(),
          password: userdataMap['password'].toString(),
          loginTime: userdataMap['loginTime'].toString(),
          image: userdataMap['image'].toString(),
          loginId: userdataMap['loginId'].toString(),
          imageDocumnetId: userdataMap['imageDocumnetId'].toString(),
          username: userdataMap['userName'].toString(),
          franchiseeId: userdataMap['franchiseeId'].toString());
      getx.loginuserdata.add(userdata);
      getx.userImageOnlinePath.value = getx.loginuserdata[0].image;
    } else {
      // print("data not found of login");
    }

    // checkIfEmulator(context);
    // checkDeveloperMode();
  }

  ClsSimInfo ob = ClsSimInfo();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 234, 237, 248),
        fontFamily: 'AmazonEmber',
        textTheme: !Platform.isAndroid
            ? GoogleFonts.outfitTextTheme(
                TextTheme(
                  bodyLarge: TextStyle(fontSize: 12),
                  bodyMedium: TextStyle(fontSize: 12),
                  displayLarge: TextStyle(fontSize: 18),
                  displayMedium: TextStyle(fontSize: 16),
                  titleMedium: TextStyle(fontSize: 14),
                ),
              )
            : const TextTheme(
                bodyLarge: TextStyle(fontSize: 12),
                bodyMedium: TextStyle(fontSize: 10),
                displayLarge: TextStyle(fontSize: 18),
                displayMedium: TextStyle(fontSize: 16),
                titleMedium: TextStyle(fontSize: 14),
              ),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.merriweather().copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      getPages: router.Route,
      debugShowCheckedModeBanner: false,
      // title: 'DTHLMS Pro',
      home: FutureBuilder<void>(
        future: getUserDetails(), // Call the future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            log(getx.loginuserdata.toString());
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return 
            Platform.isAndroid
                ? getx.isEmulator.value
                    ? EmulatorOnPage()
                    : getx.isAndroidDeveloperModeEnabled.value
                        ? DevelopermodeOnPage()
                        : getx.loginuserdata.isNotEmpty
                            ? HomePageMobile()
                            : Mobilelogin()
                : getx.loginuserdata.isNotEmpty
                    ? DthDashboard()
                    : DthLmsLogin();
          }
        },
      ),
    );
  }

  void checkIfEmulator(BuildContext context) async {
    getx.isEmulator.value = await isEmulator();
    if (getx.isEmulator.value) {
      // print('Running on a Virtule Device');
    } else {
      // print('Running on a Physical Device');
    }
  }
}

Future<List> getSimCardsData(BuildContext context) async {
  List cardNumbers = [];
  try {
    cardNumbers.clear();

    // Check for phone permission
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
    }

    // Await permission listener callback
    if (await SimNumber.hasPhonePermission) {
      SimInfo simInfo = await SimNumber.getSimData();
      for (var s in simInfo.cards) {
        cardNumbers.add(s.phoneNumber);
      }
      return cardNumbers; // Return sim card info list
    } else {
      return []; // Return empty list if permission is not granted
    }
  } on Exception catch (e) {
    Get.back();
    // print("error! code: $e - message: $e");
    return [];
  }
}

// firbase() async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
// }

singleInstance(args) async {
  await WindowsSingleInstance.ensureSingleInstance(args, "custom_identifier",
      bringWindowToFront: true, onSecondWindow: (args) {
    // print(args);
  });
  // print(args);
}

Future<bool> isEmulator() async {
  final deviceInfo = DeviceInfoPlugin();

if (Platform.isAndroid) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.isPhysicalDevice == false ||
        iosInfo.model.toLowerCase().contains('simulator') ||
        iosInfo.name.toLowerCase().contains('simulator');
  }
  return false;
}

//hello
void _showEmulatorDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Emulator Detected'),
        content: const Text(
            'It appears you are not running this app on an physical device!!'),
        actions: [
          TextButton(
            onPressed: () {
              exit(0); // Exit the app if user chooses not to continue
            },
            child: const Text('Exit'),
          ),

          // TextButton(
          //   onPressed: () {

          //     Navigator.of(context).pop(); // Continue if user chooses to proceed
          //   },
          //   child: Text('Continue'),
          // ),
        ],
      );
    },
  );
}

// final _noScreenshot = NoScreenshot.instance;
// void disableScreenshot() async {
//   try {
//     bool result = await _noScreenshot.screenshotOff();
//     debugPrint('Screenshot Off: $result');
//   } catch (e) {
//     debugPrint('Error: $e');
//   }
// }

class DevelopermodeOnPage extends StatefulWidget {
  @override
  _DevelopermodeOnPageState createState() => _DevelopermodeOnPageState();
}

class _DevelopermodeOnPageState extends State<DevelopermodeOnPage> {
  // Function to show the custom dialog
  _showDeveloperDialog(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.info,
      style: const AlertStyle(
        isOverlayTapDismiss: false,
        animationType: AnimationType.fromTop,
        titleStyle: TextStyle(
          color: Colors.red, // Set your custom color for the title
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(fontSize: 16), // Customize description text style
        isCloseButton: false, // Disable close button
      ),
      title: "Developer Mode Detected",
      desc:
          "Developer mode is on in your device! Please turn it off and try again!",
      buttons: [
        DialogButton(
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Get.back();

            exit(0); // Close the dialog
          },
          color: const Color.fromRGBO(9, 89, 158, 1), // Set button color
          highlightColor:
              const Color.fromRGBO(3, 77, 59, 1), // Set highlight color
        ),
      ],
    ).show();
  }
 
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDeveloperDialog(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () {
          exit(0);
        },
        child: const Scaffold(
          body: Center(
            child: Text('Developer Mode detacted!'),
          ),
        ),
      ),
    );
  }
}

class EmulatorOnPage extends StatefulWidget {
  @override
  _EmulatorOnPageState createState() => _EmulatorOnPageState();
}

class _EmulatorOnPageState extends State<EmulatorOnPage> {
  _showDeveloperDialog(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.info,
      style: const AlertStyle(
        isOverlayTapDismiss: false,
        animationType: AnimationType.fromTop,
        titleStyle: TextStyle(
          color: Colors.red, // Set your custom color for the title
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(fontSize: 16), // Customize description text style
        isCloseButton: false, // Disable close button
      ),
      title: "Virtual Device Detected",
      desc: 'It appears you are not running this app on an physical device!!',
      buttons: [
        DialogButton(
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            exit(0); // Close the dialog
          },
          color: const Color.fromRGBO(9, 89, 158, 1), // Set button color
          highlightColor:
              const Color.fromRGBO(3, 77, 59, 1), // Set highlight color
        ),
      ],
    ).show();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDeveloperDialog(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () {
          exit(0);
        },
        child: const Scaffold(
          body: Center(
            child: Text('Virtual Device Detected!'),
          ),
        ),
      ),
    );
  }
}

Future<void> initializeNotifications() async {
  // testSQLCipherOnWindows();
  String osid = getEncryptionKeyFromTblSetting('OneSignalId');
  log("user id of one signal :$osid");
  if (osid.isNotEmpty) {
    // Initialize OneSignal
    OneSignal.Debug.setLogLevel(
      OSLogLevel.none,
    );

    OneSignal.initialize(osid); // Replace with your OneSignal App ID
    final userid = await OneSignal.User.getOnesignalId();
    // final userid = await OneSignal.User.pushSubscription.id;

    log("user id of one signal :$userid");
    // Request notification permissions
    OneSignal.Notifications.addPermissionObserver((state) {
      // // print("Has permission: " + state.toString());
    });

    // Foreground notification listener
    OneSignal.Notifications.addForegroundWillDisplayListener((event) async {
      // print(
      // 'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');

      // Prevent default display to handle it manually
      event.preventDefault();

      // Extract notification details
      String? title = event.notification.title ?? 'No title';
      String? body = event.notification.body ?? 'No body';
      String? img = event.notification.launchUrl ?? 'No image';
      String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());

      // Create a notification model
      NotificationModel newNotification = NotificationModel(
        title: title,
        body: body,
        receivedAt: formattedTime,
        img: img,
      );

      // Save the notification to SharedPreferences
      await NotificationService.saveNotification(newNotification);

      // Optionally, display the notification
      event.notification.display();

      // Optionally, handle further UI updates or state management here
    });
  }
}
