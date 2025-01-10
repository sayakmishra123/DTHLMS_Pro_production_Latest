import 'dart:developer';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/MCQ/mcqpaperdetailsmobile_page.dart';
import 'package:dthlms/PC/MCQ/MOCKTEST/resultMcqTest.dart';
import 'package:dthlms/PC/MCQ/MOCKTEST/termandcondition.dart';
import 'package:flutter/material.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:get/get.dart';


class McqListMobile extends StatelessWidget {
  final RxList mcqSetList;
  final String type;
  final String img;
  bool istype;
  McqListMobile(this.mcqSetList, this.type, this.img, this.istype, {super.key});
  RxList filteredList = [].obs;
  RxList mcqPaperList = [].obs;
  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine crossAxisCount based on screen width
    int crossAxisCount = screenWidth > 1200
        ? 6
        : screenWidth > 800
            ? 5
            : 4; // Adjust the number of grid items per row based on screen width.

    // Filter the mcqSetList to only include "Quick Practice"
    filteredList.value =
        mcqSetList.where((item) => item["ServicesTypeName"] == type).toList();
    log(filteredList.toString());
    return SizedBox(
      height: screenHeight * 0.8, // Make it responsive to screen height.
      child: Column(
        children: [
        
          if (filteredList.isNotEmpty)
            Expanded(
  child: ListView.builder(
    padding: const EdgeInsets.all(16.0),
    itemCount: filteredList.length, // Use filtered list count
    itemBuilder: (context, index) {
      final mcqItem = filteredList[index];
      return InkWell(
        onTap: () async {
          // Example action when an item is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => McqPaperDetailsMobile(  
                mcqItem,
                mcqSetList,
                istype,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorPage.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    img,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              mcqItem["SetName"] ?? 'no name found', // Use dynamic title
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0), // Add space between items
          ],
        ),
      );
    },
  ),
)

          else
            Expanded(
              child: Center(
                child: const Text(
                  "No Quick Practice Papers Found",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  






}
 


 
