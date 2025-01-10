import 'package:dthlms/MOBILE/HOMEPAGE/homepage_mobile.dart';
import 'package:dthlms/MOBILE/LOGIN/loginpage_mobile.dart';
import 'package:dthlms/intro_pages/intro_page1.dart';
import 'package:dthlms/intro_pages/intro_page2.dart';
import 'package:dthlms/intro_pages/intro_page3.dart';
import 'package:dthlms/intro_pages/intro_page4.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'GETXCONTROLLER/getxController.dart';

class IntroductionDashBoard extends StatefulWidget {
  const IntroductionDashBoard({super.key});

  @override
  State<IntroductionDashBoard> createState() => _IntroductionDashBoardState();
}

class _IntroductionDashBoardState extends State<IntroductionDashBoard> {
  // page controller
  PageController _controller = PageController();

  // last page
  RxBool isLastPage = false.obs;

  Getx getx = Get.put(Getx());

  RxBool isIntroShown = false.obs;

  @override
  void initState() {
    sharedPrefaranceGet().then((v) {
      if (v) {
        Get.to( 
            getx.loginuserdata.isNotEmpty ?()=> HomePageMobile() :()=> Mobilelogin());
      }
    });
    super.initState();
  }

  // set is intro shown true
  sharedPrefaranceSet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isIntroShown', true);
  }

  // check if intro shown or not
  Future<bool> sharedPrefaranceGet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await prefs.getBool('isIntroShown') != null) {
      isIntroShown.value = prefs.getBool('isIntroShown')!;
      return prefs.getBool('isIntroShown')!;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        // Page View
        PageView(
          onPageChanged: (index) {
            isLastPage.value = (index == 3);
          },
          controller: _controller,
          children: [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
            IntroPage4(),
          ],
        ),

        // Indicator
        Obx(
          () => Container(
              alignment: Alignment(0, 0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // skip button
                  TextButton(
                      onPressed: () {
                        _controller.jumpToPage(3);
                      },
                      child: Text('Skip')),

                  SmoothPageIndicator(controller: _controller, count: 4),

                  // Next or done
                  isLastPage.value
                      ? TextButton(
                          onPressed: () {
                            Get.to(getx.loginuserdata.isNotEmpty
                                ? HomePageMobile()
                                : Mobilelogin());
                            sharedPrefaranceSet();
                          },
                          child: Text('Done'))
                      : TextButton(
                          onPressed: () {
                            _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Text('Next'))
                ],
              )),
        ),
      ],
    ));
  }
}
