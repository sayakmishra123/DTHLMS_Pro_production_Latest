import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
  double  width =  MediaQuery.of(context).size.width;

    return  Container(
      color: Colors.brown.shade200,
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
            Lottie.asset('assets/animations/finget_print.json'),
          Text("Encrypt Videos",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
            SizedBox(
            width: width *0.8,
         child:  Text("Compress, encrypt and upload in 1 single click",
                       textAlign: TextAlign.center,

         style: TextStyle(fontSize: 14,color: Colors.grey.shade200),),
            )

        ],
      ),),
    );
  }
} 