import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FeedBackMobile extends StatefulWidget {
  const FeedBackMobile({super.key});

  @override
  State<FeedBackMobile> createState() => _FeedBackMobileState();
}

class _FeedBackMobileState extends State<FeedBackMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorPage.mainBlue,
        title: Text(
          'Feedback',
          style: FontFamily.style.copyWith(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: FeedbackBox(),
      ),
    );
  }
}

class FeedbackBox extends StatefulWidget {
  const FeedbackBox({super.key});

  @override
  State<FeedbackBox> createState() => _FeedbackBoxState();
}

class _FeedbackBoxState extends State<FeedbackBox> {

  TextEditingController feedBackController = TextEditingController();

  double starCount = 5.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate 20% of the width for padding
          double horizontalPadding = constraints.maxWidth * 0.05;
          double h = constraints.maxHeight * 0.08;

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: h),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xffF8FBFF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image(
                          image: AssetImage(
                            'assets/speech-bubble.png',
                          ),
                          height:
                              25, // Uncomment if you want to specify the height
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Add some space between the rows
                  Row(
                    children: [
                      Text(
                        'Feedback',
                        style: FontFamily.styleb,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Please rate your experience below',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      )),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: RatingBar.builder(
                          initialRating: starCount,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            starCount=rating;
                            print(rating);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Text(
                        'Additional feedback',
                        style: FontFamily.styleb.copyWith(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5),

                  // Current Password
                 feedBackTextFeild(feedBackController),
                  SizedBox(height: 50),

                  Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          height: 60,
                          color: ColorPage.mainBlue,
                          onPressed: ()async {
                            
                       await sendStudentFeedbackforApp(  context,getx.loginuserdata[0].token,starCount.toString(),feedBackController.text).then((value){

                        if(value){
                          onSweetAleartDialog(context, (){
                            Get.back();

                          }, "Successfully Submitted", "Thanks for your review", true);
                        }
                      

                       });






                          },
                          child: Text(
                            'Submit feedback',
                            style: FontFamily.style.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget feedBackTextFeild( TextEditingController textformfeild){
    return Padding(
      padding: const EdgeInsets.all(16.0), // Adjust padding as needed
      child: TextFormField(
        
        controller: textformfeild,
        
       // Initial text as per the image
        maxLines: 4, // Adjust the number of lines as needed
        decoration: InputDecoration(
          hintText: "My feedBack!!",
          // labelText: 'Additional feedback',
          alignLabelWithHint: true, // Align label with the hint text
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            borderSide: BorderSide(
              color: Colors.grey, // Outline border color
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            borderSide: BorderSide(
              color:
                  Colors.grey.withOpacity(0.5), // Grey color for enabled border
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            borderSide: BorderSide(
              color: ColorPage.mainBlue, // Blue color when focused
              width: 2.0, // Border width when focused
            ),
          ),
        ),
        style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800]), // Text style inside the field
      ),
    );
  }
}

class FeedbackTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Adjust padding as needed
      child: TextFormField(
        initialValue: 'My feedback!!', // Initial text as per the image
        maxLines: 4, // Adjust the number of lines as needed
        decoration: InputDecoration(
          // labelText: 'Additional feedback',
          alignLabelWithHint: true, // Align label with the hint text
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            borderSide: BorderSide(
              color: Colors.grey, // Outline border color
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            borderSide: BorderSide(
              color:
                  Colors.grey.withOpacity(0.5), // Grey color for enabled border
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            borderSide: BorderSide(
              color: ColorPage.mainBlue, // Blue color when focused
              width: 2.0, // Border width when focused
            ),
          ),
        ),
        style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800]), // Text style inside the field
      ),
    );
  }
}
