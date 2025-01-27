import 'dart:async' show StreamSubscription;
import 'dart:developer';
import 'dart:io' show Directory, File, Platform, Process;
import 'package:connectivity_plus/connectivity_plus.dart'
    show Connectivity, ConnectivityResult;
// import 'package:dthlms/MOBILE/PROFILE/profilrmodelclass.dart';
import 'package:dthlms/MOBILE/store/storemodelclass/storemodelclass.dart';
import 'package:dthlms/MODEL_CLASS/Meettingdetails.dart';
import 'package:dthlms/MODEL_CLASS/allPackages_model.dart';
import 'package:dthlms/MODEL_CLASS/folderdetails.dart';
import 'package:dthlms/MODEL_CLASS/login_model.dart';
import 'package:dthlms/MODEL_CLASS/allPackageDetails.dart';
import 'package:dthlms/MODEL_CLASS/profileDetails.dart';
import 'package:flutter/services.dart';
// import 'package:dthlms/Master/modelclass/allpackagemodelclass.da
// rt';

// import 'package:dthlms/db/copydbfun.dart' show copyDatabase;
// import 'package:dthlms/db/dbfunction/dbfunction.dart'
//     show DbHandler, testSQLCipherOnWindows;
// import 'package:dthlms/package/packagescreen.dart' show AllPackage, PackageFind;
import 'package:flutter/material.dart'
    show Colors, Icon, Icons, Text, TextButton, TextStyle;
import 'package:get/get.dart';
import 'package:simnumber/siminfo.dart';

import '../notification_model.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart'
// show databaseFactory, databaseFactoryFfi, sqfliteFfiInit;

// import '../login/loginmodel.dart' show DthloginUserDetails;

class Getx extends GetxController {
  RxString signUpMSG = "".obs;
  RxBool isWhatsAppOrRequired = false.obs;
  RxBool isPhoneNumberOrRequired = false.obs;
  RxBool isPhoneOtpRequired = false.obs;
  RxBool isEmailOtpRequired = false.obs;
  RxBool isWhatsAppOtpRequired = false.obs;
  RxBool isloadChatUrl = true.obs;
  RxBool show = false.obs;
  RxList rankerList = [].obs;
  RxMap userRankDetails = {}.obs;
  RxInt ButtonControllerIndex = 0.obs;
  RxBool hide = true.obs;
  // ignore: non_constant_identifier_names
  RxInt page_index = 0.obs;
  RxBool buttonfocuscolor = false.obs;

  RxBool dropbuttonvalueshow = true.obs;
  RxBool isTimerOn = true.obs;

  RxList<DthloginUserDetails> loginuserdata = <DthloginUserDetails>[].obs;
  RxList<FolderDetails> folderDetailsdata = <FolderDetails>[].obs;
  RxList<AllPackageDetails> packageDetailsdata = <AllPackageDetails>[].obs;
  RxString loginId = ''.obs;
  RxBool otplineshow = false.obs;





  

    RxList<String?> selectedAnswers = <String?>[].obs;  RxInt currentQuestionIndex = 0.obs;
  // RxBool otpshow = false.obs;
  RxBool loginpasswordshow = true.obs;
  RxBool signuppasswordshow = true.obs;
  RxBool activationkeyshow = false.obs;

    


  RxString signupotp = ''.obs;
  RxBool forgetpassword1 = false.obs;
  RxBool forgetpasswordemailcodeob = false.obs;

  RxBool forgetpassword2 = false.obs;
  RxString dbPath = ''.obs;
  RxBool pdfview = true.obs;
  RxBool videoplayer = true.obs;
  RxBool isSelectXXL = false.obs;
  RxList<MeetingDeatils> pastmeeting = <MeetingDeatils>[].obs;
  RxList<MeetingDeatils> todaymeeting = <MeetingDeatils>[].obs;
  RxList<MeetingDeatils> upcomingmeeting = <MeetingDeatils>[].obs;
  RxString currentPackageName = "".obs;
  RxString deviceId = ''.obs;

  RxBool isSelectXL = false.obs;
  RxBool isSelectL = false.obs;
  RxBool isSelectS = false.obs;
  RxBool isSelectXS = false.obs;
  RxBool isSelectXXS = false.obs;
  RxBool isSignup = true.obs;
  RxBool isMypackages = false.obs;
  RxBool passvisibility = false.obs;
  RxBool videoplaylock = false.obs;
  RxBool isPaperSubmit = false.obs;
  RxBool isVideoDashBoard = false.obs;
  RxBool isPodcastDashboard = false.obs;
  RxBool isLiveDashBoard = false.obs;
  RxBool isTheoryDashBoard = false.obs;
  RxBool isBookDashBoard = false.obs;
  RxBool isPDFDashBoard = false.obs;
  RxBool isMCQDashBoard = false.obs;
  RxBool isBackupDashBoard = false.obs;
  RxBool isprofileDrawerOpen = true.obs;
  RxBool isActivationKeySet = false.obs;
  RxString packageIdForGetSection = ''.obs;
  RxString userImageLocalPath = ''.obs;
  RxString userImageOnlinePath = ''.obs;

  RxBool isCollapsed = false.obs;
  RxBool isVideoPlaying = false.obs;
  RxBool isFolderview = false.obs;
  RxBool isFolderviewForPdf = false.obs;
  RxBool isIconSideBarVisible = false.obs;
  RxList name = [].obs; //chat
  RxString email = ''.obs;
  RxList<Map<String, dynamic>> studentPackage = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> sectionListOfPackage =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> sectionlist = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> alwaysShowChapterDetailsOfBook =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> alwaysShowFileDetailsOfpdf =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> alwaysShowChapterDetailsOfVideo =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> testWrittenExamList =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> alwaysShowChapterfilesOfVideo =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> podcastFileList = <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> navigationList = <Map<String, dynamic>>[].obs;
  RxList<dynamic> blackListProcess = <dynamic>[].obs;
  RxList<dynamic> whiteListProcess = <dynamic>[].obs;
  RxList<Map<String, dynamic>> subjectDetails = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> packageData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> sessionData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> liveList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> tagListOfVideo = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> mcqListOfVideo = <Map<String, dynamic>>[].obs;
   RxList<Map<String, dynamic>>reviewQuestionListOfVideo = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> pdfListOfVideo = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> bannerImageList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> videoHistory = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> examHistory = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> theoryexamList = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> infoFetch = <Map<String, dynamic>>[];
  RxString userSelectedPathForDownloadVideo = ''.obs;
  RxString userSelectedPathForDownloadFile = ''.obs;
  RxString defaultPathForDownloadVideo = ''.obs;
  RxString defaultPathForDownloadFile = ''.obs;
  RxString playingVideoId = ''.obs;
  RxString playingPodcastId = ''.obs;
  RxString playingPodcastLink = ''.obs;
  RxInt userProfileDocumentId = 0.obs;

  RxBool drawertogglebutton = true.obs;

  RxList<Map<String, dynamic>> calenderEvents = <Map<String, dynamic>>[].obs;

  RxList<Map<String, String>> askDoubtmessages = <Map<String, String>>[].obs;
  RxList<Map<String, String>> askDoubtanswermessages =
      <Map<String, String>>[].obs;

  RxInt selectedPackageId = 0.obs;
  RxBool mcqdataList = false.obs;
  RxString playLink = ''.obs;
  RxBool isInternet = false.obs;
  RxList countryCodeList = [].obs;
  //chat
  RxDouble uploadProgress = 0.0.obs;

  RxList<SimCard> simCardinfo = <SimCard>[].obs;
  RxList<AllPackages> package = <AllPackages>[].obs;
  // RxMap<> n = <Packagedetails>RxMap();
  // RxList<Packagedetails> packagedetailsfoldername = <Packagedetails>[].obs;
  RxMap packagedetailsfoldername = RxMap<String, dynamic>();
  RxList<PackageFind> packagefind = <PackageFind>[].obs;
  RxBool packageshow = true.obs;
  RxBool theoryExamvalue = false.obs;

  RxBool forgetPasswordfieldEntryValue = true.obs;
  RxBool forgetPasswordOTPEntryValue = false.obs;
  RxBool forgetPasswordNewPasswordEntryValue = false.obs;

  RxBool forgetpasswordemailcode = false.obs;
  RxBool forgetpageshow = false.obs;
  RxBool loading = true.obs;
  RxBool isDownloaded = false.obs;
  Rx<Uint8List> encryptedpdffile = Uint8List(0).obs;

  Rx<Uint8List> encryptedQuestionPaperfile = Uint8List(0).obs;
  RxString unEncryptedPDFfile = "".obs;
  RxString unEncryptedQuestionPaperfile = "".obs;

  RxString groupchatLink = "".obs;
  RxString personalChatLink = "".obs;

  RxString pdfFilePath = ''.obs;
  RxBool isdownloading = false.obs;
  RxBool isAndroidDeveloperModeEnabled = false.obs;
  RxBool isEmulator = false.obs;
  RxString isLogout = "".obs;
  RxBool isFullscreen = true.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  // List<Map<String, dynamic>> infoFetch = <Map<String, dynamic>>[];

  RxList<Map<String, dynamic>> booklist = <Map<String, dynamic>>[].obs;

  late final RxList<ApiResponse> style = <ApiResponse>[].obs;
  // var premiumpackageDetailsList = <PremiumPackageDetail>[].obs;
  var DeviceLoginHistorylist = <DeviceLoginHistoryDetails>[].obs;

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // RxInt countpackage1 = 0.obs;

  // RxInt countpackage2 = 0.obs;

  @override
  void onInit() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    databasecopy();
    super.onInit();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      // developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    // setState(() {
    _connectionStatus = result;
    // log(_connectionStatus.toString());
    networkcheckingsnakbar();
    // });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  Future<void> networkcheckingsnakbar() async {
    List.generate(_connectionStatus.length, (index) {
      if (_connectionStatus[index] == ConnectivityResult.none) {
        isInternet.value = false;
        Get.showSnackbar(GetSnackBar(
          isDismissible: true,
          shouldIconPulse: true,
          icon: const Icon(
            Icons.wifi_off,
            color: Colors.white,
          ),
          snackPosition: SnackPosition.TOP,
          title: 'No Internet Connection',
          message: 'Please check your connection.',
          mainButton: TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.white),
            ),
          ),
          duration: const Duration(seconds: 3),
        ));
      } else {
        isInternet.value = true;
      }
    });
  }

  databasecopy() async {
    if (Platform.isWindows) {}

    String path = "assets/copydb/databases/sayakdb.db";
  }
}
