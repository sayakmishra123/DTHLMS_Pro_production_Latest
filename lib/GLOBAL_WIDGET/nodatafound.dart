import 'package:auto_size_text/auto_size_text.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';

class No_Data_Found extends StatefulWidget {
  const No_Data_Found({super.key});

  @override
  State<No_Data_Found> createState() => _No_Data_FoundState();
}

class _No_Data_FoundState extends State<No_Data_Found> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  'assets/no_data_found.jpg',
                  scale: 1.3,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height/3.5,
              child: Expanded   (
                child: Flexible(
                  child: AutoSizeText(
                              "No Result Found",
                              style: FontFamily.font5.copyWith(color: Color.fromARGB(255, 95, 130, 151),
                    fontSize: 60,
                    fontWeight: FontWeight.bold)
                            ),
                ),
              )),
            Positioned(
            bottom: MediaQuery.of(context).size.height/4.5,
              child: Expanded(
                child: Flexible(
                  child: AutoSizeText(
                              "We couldn't find what you searched for. \n Try search again. ",textAlign: TextAlign.center,
                              style: FontFamily.font5.copyWith(color: Color.fromARGB(186, 1, 14, 22),
                    fontSize: 20,
                    fontWeight: FontWeight.bold)
                            ),
                ),
              ))
        ],
      ),
    );
  }
}
