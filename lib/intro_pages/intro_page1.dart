import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) { 
  double  width =  MediaQuery.of(context).size.width;
    return Container(
      color: Colors.blue.shade200,
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
            Lottie.asset('assets/animations/search_list.json'),
 Text("Create Cources",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
          SizedBox(
            width: width *0.8,
            child: Text(
              
              "Make your own courses, subjects and batches",
              textAlign: TextAlign.center,
              style: TextStyle(
              
                fontSize: 14,color: Colors.grey.shade200),)),

        ],
      ),),
    );
  }
}  