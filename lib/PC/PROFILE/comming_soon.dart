import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CommingSoon extends StatefulWidget {
  const CommingSoon({super.key});

  @override
  State<CommingSoon> createState() => _CommingSoonState();
}

class _CommingSoonState extends State<CommingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(height: 250, 'assets/animations/Animation2.json'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Exciting Features Coming Soon!',
                style: FontFamily.styleb.copyWith(
                    fontSize: 30, color: const Color.fromARGB(255, 0, 63, 114)),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '''We're working hard to bring them to life.
Stay tuned for updates!''',
                textAlign: TextAlign.center,
                style: FontFamily.styleb.copyWith(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 130, 161, 185)),
              )
            ],
          )
        ],
      ),
    );
  }
}
