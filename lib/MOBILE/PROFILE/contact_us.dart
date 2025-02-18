import 'package:dthlms/PC/PROFILE/userProfilePage.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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


class PrivacyPollicyMobile extends StatefulWidget {
  const PrivacyPollicyMobile({super.key});

  @override
  State<PrivacyPollicyMobile> createState() => _PrivacyPollicyMobileState();
}

class _PrivacyPollicyMobileState extends State<PrivacyPollicyMobile> {
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

class RefundPollicyMobile extends StatefulWidget {
  const RefundPollicyMobile({super.key});

  @override
  State<RefundPollicyMobile> createState() => _RefundPollicyMobileState();
}

class _RefundPollicyMobileState extends State<RefundPollicyMobile> {
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



class FAQWidgetMobile extends StatefulWidget {
  const FAQWidgetMobile({super.key});

  @override
  State<FAQWidgetMobile> createState() => _FAQWidgetMobileState();
}

class _FAQWidgetMobileState extends State<FAQWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorPage.mainBlue,
        title: Text("FAQ's",style: FontFamily.style.copyWith(color: Colors.white),),),

        body:FAQWidget()
    );
  }
}
