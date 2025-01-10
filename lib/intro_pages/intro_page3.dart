import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
      double  width =  MediaQuery.of(context).size.width;





    return Container(
      color: Colors.amber.shade300,
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
            Lottie.asset('assets/animations/students2.json'),
 Text("Assign Students",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),

   SizedBox(
            width: width *0.8,
         child:  Text("Assign student manually or link API with your website",
                        textAlign: TextAlign.center,

          style: TextStyle(fontSize: 14,color: Colors.grey.shade200),),
   )
        ],
      ),),
    );
  }
}