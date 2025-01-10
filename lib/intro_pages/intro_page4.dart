import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage4 extends StatelessWidget {
  const IntroPage4({super.key});

  @override
  Widget build(BuildContext context) {
      double  width =  MediaQuery.of(context).size.width;

    return Container(
      color: Colors.lightGreen.shade200,
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
            Lottie.asset('assets/animations/manage2.json'),
 Text("Manage Online",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
   SizedBox(
            width: width *0.8,
         child:  Text("Alter views, expiry, type of devices, block any student from any where",
                       textAlign: TextAlign.center,

         style: TextStyle(fontSize: 14,color: Colors.grey.shade200),),
   )

        ],
      ),),
    );
  }
}