import 'package:dthlms/PC/PROFILE/userProfilePage.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorPage.mainBlue,
        title: Text('Contact US',style: FontFamily.style.copyWith(color: Colors.white),),),

        body: Column(
          children: [],
        ),
    );
  }
}


class PrivacyPollicyMobile extends StatelessWidget {
  const PrivacyPollicyMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorPage.mainBlue,
        title: Text('Privacy Policy',style: FontFamily.style.copyWith(color: Colors.white),),),

        body:PrivacyPollicyWidget()
    );
  }
}

class RefundPollicyMobile extends StatelessWidget {
  const RefundPollicyMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorPage.mainBlue,
        title: Text('Refund Policy',style: FontFamily.style.copyWith(color: Colors.white),),),

        body:RefundPolicy()
    );
  }
}

