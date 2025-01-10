import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPage.blue,
        title: Text('Library', style: TextStyle(color: Colors.white)),
        leading: Icon(Icons.book_outlined, color: Colors.white),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.person_outline, color: Colors.white),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: Icon(Icons.delete_outline, color: Colors.white),
          //   onPressed: () {},
          // ),
          IconButton(
            icon: Icon(Icons.bookmark_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder for the illustration (you can use an asset image or network image here)
                Image.asset('assets/android/nodatafound.png'),
                SizedBox(height: 20),
                Text(
                  "You haven't enrolled in any courses yet. Start by purchasing your first course from the store.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(137, 126, 125, 125)),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Get.to(() => ListviewPackage());
                    // Go to store action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    // primary: Colors.orange, // Background color
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    'Go To Store',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Promo banner and Checkout button
          // Container(
          //   padding: EdgeInsets.all(10),
          //   color: Colors.grey.shade100,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //           Image.network(
          //             'https://via.placeholder.com/50', // Replace with course image
          //             height: 50,
          //             width: 50,
          //           ),
          //           SizedBox(width: 10),
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'CA Inter Corporate',
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               Text('₹5000'),
          //             ],
          //           ),
          //         ],
          //       ),
          //       // ElevatedButton(
          //       //   onPressed: () {
          //       //     // Checkout action
          //       //   },
          //       //   style: ElevatedButton.styleFrom(
          //       //       // primary: Colors.orange, // Background color
          //       //       ),
          //       //   child: Text('Checkout'),
          //       // ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
