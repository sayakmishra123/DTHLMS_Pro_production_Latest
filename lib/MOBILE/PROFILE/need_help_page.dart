import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';

class NeedHelpPage extends StatefulWidget {
  const NeedHelpPage({super.key});

  @override
  State<NeedHelpPage> createState() => _NeedHelpPageState();
}

class _NeedHelpPageState extends State<NeedHelpPage> {
  @override 
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorPage.mainBlue,
        title: Text('Help',style: FontFamily.style.copyWith(color: Colors.white),),),
      body: Container(color: Colors.white,
      child: FAQWidget(),
      ),
    );
  }
}


class FAQWidget extends StatelessWidget {
  final List<Map<String, String>> faqData = [
    {
      'question': 'Do I need to register with 6Degree to place orders?',
      'answer':
          'Register simply by setting up an email address and a password. Sign in to view what is already in your shopping cart. You can also opt to sign in using Facebook, Google, or Instagram.',
    },
    {
      'question': 'How do I register?',
      'answer':
          'Register simply by setting up an email address and a password. Sign in to view what is already in your shopping cart. You can also opt to sign in using Facebook, Google, or Instagram.',
    },
    {
      'question': 'I have forgotten my password. How do I change it?',
      'answer':
          'You can reset your password by following the instructions provided in the "Forgot Password" section.',
    },
    {
      'question': 'How can I change my personal details or shipping address?',
      'answer':
          'You can change your personal details or shipping address in the "My Account" section after logging in.',
    },
    {
      'question': 'How do I select my size?',
      'answer':
          'You can refer to the size chart available on the product page.',
    },
    {
      'question': 'Does 6Degree provide alterations?',
      'answer': 'Yes, alterations can be requested for certain products.',
    },
    {
      'question':
          'I need help to decide what to buy, can I speak to a stylist?',
      'answer':
          'Yes, you can consult with a stylist by contacting customer support.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Text("FAQ's",
          //         style: style.copyWith(
          //             fontSize: 25,
          //             color: Colors.black45,
          //             fontWeight: FontWeight.w900)),
          //   ],
          // ),

          // SizedBox(
          //   height: 30,
          // ),
          // Text(
          //   'Need answers? Find them here...',
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.grey,
          //   ),
          // ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: faqData.length,
              itemBuilder: (context, index) {
                final faqItem = faqData[index];
                return _buildExpansionTile(
                  faqItem['question']!,
                  faqItem['answer']!,
                  context,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile(
      String title, String content, BuildContext context) {
    return ExpansionTile(
      shape: Border.all(color: Colors.transparent),
      leading: Icon(
        Icons.circle,
        size: 10,
      ),
      title: Text(
        title,
        style: FontFamily.styleb.copyWith(fontSize: 15, color: Colors.black54),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 40,
              ),
              Expanded(
                child: Text(
                  content,
                  textAlign: TextAlign.left,
                  style: FontFamily.font9
                      .copyWith(color: ColorPage.colorblack, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}