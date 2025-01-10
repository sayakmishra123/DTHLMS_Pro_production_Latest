import 'package:dthlms/MOBILE/HOMEPAGE/homepage_mobile.dart';
import 'package:dthlms/MOBILE/LOGIN/loginpage_mobile.dart';
import 'package:dthlms/MOBILE/PROFILE/change_password_page.dart';
import 'package:dthlms/MOBILE/PROFILE/details.dart';
import 'package:dthlms/MOBILE/PROFILE/feedback.dart';
import 'package:dthlms/MOBILE/PROFILE/need_help_page.dart';
import 'package:dthlms/MOBILE/SIGNIN_OTP/OtpScreen.dart';
import 'package:dthlms/PC/HOMEPAGE/homepage.dart';
import 'package:dthlms/PC/LOGIN/login.dart';
import 'package:dthlms/PC/MCQ/EXAM/resultpage.dart';


import 'package:get/get.dart';

class pageRouter {
  List<GetPage<dynamic>>? Route = [
    GetPage(
      name: '/',
      page: () => const DthLmsLogin(),
    ),
    GetPage(
      name: '/Mobilelogin',
      page: () => const Mobilelogin(),
    ),
    // GetPage(
    //   name: '/Mobileforgetpassword',
    //   page: () => ForgetPasswordMobile(),
    // ),
    GetPage(
      name: '/Mobilesigninotpscreen',
      page: () => SignInOtpScreen(),
    ),

    // GetPage(
    //   name: "/Theoryexampage",
    //   page: () => TheoryExamPage(),
    // ),
    // GetPage(
    //   name: "/Practicemcqtermandcondition",
    //   page: () => PracticeMcqTermAndCondition(),
    // ),
    // GetPage(
    //   name: "/Mocktestmcqexampage",
    //   page: () => MockTestMcqExamPage(),
    // ),
    // GetPage(
    //   name: "/Practicemcq",
    //   page: () => PracticeMcq(),
    // ),
    // GetPage(
    //   name: "/Mocktestresult",
    //   page: () => MockTestresult(),
    // ),
    // GetPage(
    //   name: "/Mcqterandconditionmobile",
    //   page: () => McqTermAndConditionmobile(),
    // ),
    // GetPage(
    //   name: "/Mocktestanswermobile",
    //   page: () => MocktestAnswer(),
    // ),
    // GetPage(
    //   name: "/Mocktestexampagemobile",
    //   page: () => MockTestMcqExamPageMobile(),
    // ),
    // GetPage(
    //   name: "/Mocktestrankpagemobile",
    //   page: () => RankPage(),
    // ),
    // GetPage(
    //   name: "/Practicemcqmobile",
    //   page: () => PracticeMcqMobile(),
    // ),
    GetPage(
      name: "/Homepage",
      page: () => DthDashboard(),
    ),
    // GetPage(
    //   name: "/Examtermandcondition",
    //   page: () => ExamMcqTermAndCondition(),
    // ),
    // GetPage(
    //   name: "/Exammcq",
    //   page: () => McqExamPage(),
    // ),
    // GetPage(
    //   name: "/Practicetermandcondition",
    //   page: () => PracticeMcqTermAndCondition(),
    // ),
    GetPage(
      name: "/ExamResultpage",
      page: () => Examresult(),
    ),
    // GetPage(
    //   name: "/Mockmcqtermandcondition",
    //   page: () => MockMcqTermAndCondition(),
    // ),
    GetPage(
      name: "/Mobilehompage",
      page: () => HomePageMobile(),
    ),
    GetPage(
      name: "/Mobiledetailspage",
      page: () => DetailsPageMobile(),
    ),
    GetPage(
      name: "/Changepasswordmobile",
      page: () => ChangePasswordMobile(),
    ),
    GetPage(
      name: "/Feedbackmobile",
      page: () => FeedBackMobile(),
    ),
    GetPage(
      name: "/Needhelppage",
      page: () => NeedHelpPage(),
    ),
  ];
}
