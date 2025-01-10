import 'dart:developer';

import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/MOBILE/store/billing.dart';
import 'package:dthlms/MOBILE/store/storemodelclass/storemodelclass.dart';
import 'package:dthlms/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../THEME_DATA/color/color.dart';

class CoursePage extends StatefulWidget {
  PremiumPackage packageinfo;
  CoursePage(this.packageinfo);

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  void initState() {
    // getPremiumPackageinfo(context, getx.loginuserdata[0].token,
    //     widget.packageinfo.packageId.toString());
    // TODO: implement initState
    super.initState();
  }

  String? selectedPlan = 'Mobile App (Android)';

  void _showPlanSelection(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true, // Allows full height with scrolling
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            // This makes content scrollable if needed
            child: Column(
              mainAxisSize:
                  MainAxisSize.max, // Minimized to fit content properly
              children: [
                SizedBox(height: 10),
                Text(
                  'Choose your plan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorPage.colorbutton,
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: DropdownButton<String>(
                    value: selectedPlan,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPlan = newValue!;
                      });
                    },
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: selectedPlan,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mobile App (Android)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Till 270 days or Max Viewing Time 150 hours',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    icon: Icon(Icons.arrow_drop_down),
                    iconEnabledColor: Colors.orange,
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),

                SizedBox(height: 10),

                // First Plan
                RadioListTile(
                  title: Text(
                    'Mobile App (Android)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Till 270 days or Max Viewing Time 150 hours'),
                  value: 'Mobile App (Android)',
                  groupValue: selectedPlan,
                  onChanged: (value) {
                    setState(() {
                      selectedPlan = value.toString();
                    });
                  },
                  activeColor: Colors.orange,
                  secondary: Text(
                    '₹5000',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),

                // Second Plan
                RadioListTile(
                  title: Text(
                    'Google Drive',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Till 270 days or Max Viewing Time 150 hours'),
                  value: 'Google Drive',
                  groupValue: selectedPlan,
                  onChanged: (value) {
                    setState(() {
                      selectedPlan = value.toString();
                    });
                  },
                  activeColor: Colors.orange,
                  secondary: Text(
                    '₹4000',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),

                SizedBox(height: 20),

                // Enroll Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity, // Full-width button
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CourseListPage(),
                            ));
                      },
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPage.colorbutton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PackagInfoData>(
          future: getPremiumPackageinfo(context, getx.loginuserdata[0].token,
              widget.packageinfo.packageId.toString()),
          builder:
              (BuildContext context, AsyncSnapshot<PackagInfoData> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            } else {
              // print(snapshot.data![0].result[0].attribute[0].category);
              return Column(
                children: [
                  Flexible(
                    child: Image.network(
                      // width: MediaQuery.sizeOf(context).width,
                      widget.packageinfo.packageBannerPathUrl,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                          child: Text(
                        'No Package image found',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                        textScaler: TextScaler.linear(1.5),
                      )),
                    ),
                  ),
                  // Banner and Course Info
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      // color: Colors.indigo[900],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Aligns everything to the left
                        children: [
                          SizedBox(height: 10),
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            child: Text(
                              widget.packageinfo.packageName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),

                          // Row for name and module details on the same line
                          Row(
                            children: [
                              Text(
                                'CA Amit Bachhawat',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 216, 88, 3),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10), // Space between texts
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Faculty:  ',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      )),

                  // Module List
                  Expanded(
                    child: ModuleList(snapshot.data),
                  ),

                  // Pick a Plan Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _showPlanSelection(context);
                      },
                      child: Text(
                        'Enroll Now',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPage.colorbutton,
                        // primary: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        minimumSize: Size(double.infinity, 45),
                      ),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}

class ModuleList extends StatefulWidget {
  PackagInfoData? data;
  ModuleList(this.data);

  @override
  _ModuleListState createState() => _ModuleListState();
}

class _ModuleListState extends State<ModuleList> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;

  final List<Map<String, dynamic>> modules = [
    {"title": "Course Details", "subtitle": "1 Attachment(s)"},
    {"title": "Highlights", "subtitle": "1 Attachment(s)"},
    {"title": "Teacher Profile", "subtitle": "1 Attachment(s)"},
    {
      "title": "Demo",
      "subtitle": 'Video,Pdf',
    },
  ];

  List icons = [Icons.info, Icons.star, Icons.person, Icons.play_circle_filled];

  @override
  Widget build(BuildContext context) {
    log(widget.data.toString());
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: ListView.builder(
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // Prevents scrolling inside the scroll view
              itemCount: modules.length,
              itemBuilder: (context, index) {
                // log(widget.data!.result[0].attribute.length.toString());
                // final data = widget.data![0].result[index].attribute;

                // print(data.toString() +
                //     "sayak///////////////////////////////");
                final model = modules[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 212, 212, 212)),
                    borderRadius: BorderRadius.circular(10),
                    color: ColorPage.white,
                  ),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ExpansionTile(
                    // leading: Icon(
                    //   // icons[index],
                    //   color: ColorPage.grey,
                    // ),
                    collapsedIconColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent)),
                    subtitle: Text(
                      model['subtitle'],
                      // widget.data!.attributes[index].description,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.black54),
                    ),
                    title: Text(
                      model['title'],
                      // widget.data!.attributes[index].category,
                      // data[index].attribute.toString(),
                      // modules[index]['title']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    children: [
                      Row(
                        children: [
                          modules[index]['subtitle']
                                  .toString()
                                  .split(',')
                                  .contains('Video')
                              ? IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.video_file,
                                    color: Colors.orange,
                                  ))
                              : Visibility(visible: false, child: Text('')),
                          modules[index]['subtitle']
                                  .toString()
                                  .split(',')
                                  .contains('Pdf')
                              ? IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.orange,
                                  ))
                              : Visibility(visible: false, child: Text('')),
                        ],
                      )

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(modules[index]['subtitle']!),
                      // )
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}

class CourseListPage extends StatefulWidget {
  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  // Sample course data
  final RxList<Map<String, String>> courses = [
    {
      'title': 'CA Inter Corporate and Other Laws',
      'instructor': 'by CA Amit Bachhawat',
      'oldPrice': '₹5000',
      'discount': 'Off 98.99%',
      'newPrice': '₹5',
      'imagePath': 'assets/android/course.webp',
    },
    {
      'title': 'CA Inter Corporate and Other Laws',
      'instructor': 'by CA Amit Bachhawat',
      'oldPrice': '₹5000',
      'discount': 'Off 98.99%',
      'newPrice': '₹5',
      'imagePath': 'assets/android/course.webp',
    },
    {
      'title': 'CA Inter Corporate and Other Laws',
      'instructor': 'by CA Amit Bachhawat',
      'oldPrice': '₹5000',
      'discount': 'Off 98.99%',
      'newPrice': '₹5',
      'imagePath': 'assets/android/course.webp',
    },
    {
      'title': 'CA Inter Corporate and Other Laws',
      'instructor': 'by CA Amit Bachhawat',
      'oldPrice': '₹5000',
      'discount': 'Off 98.99%',
      'newPrice': '₹5',
      'imagePath': 'assets/android/course.webp',
    },
    {
      'title': 'CA Inter Corporate and Other Laws',
      'instructor': 'by CA Amit Bachhawat',
      'oldPrice': '₹5000',
      'discount': 'Off 98.99%',
      'newPrice': '₹5',
      'imagePath': 'assets/android/course.webp',
    },
    {
      'title': 'CA Inter Corporate and Other Laws',
      'instructor': 'by CA Amit Bachhawat',
      'oldPrice': '₹5000',
      'discount': 'Off 98.99%',
      'newPrice': '₹5',
      'imagePath': 'assets/android/course.webp',
    },
    {
      'title': 'CA Inter Corporate and Other Laws',
      'instructor': 'by CA Amit Bachhawat',
      'oldPrice': '₹5000',
      'discount': 'Off 98.99%',
      'newPrice': '₹5',
      'imagePath': 'assets/android/course.webp',
    },
    {
      'title': 'CA Inter Corporate and Other Laws',
      'instructor': 'by CA Amit Bachhawat',
      'oldPrice': '₹5000',
      'discount': 'Off 98.99%',
      'newPrice': '₹5',
      'imagePath': 'assets/android/course.webp',
    },
    {
      'title': 'CA Inter Corporate and Other Laws',
      'instructor': 'by CA Amit Bachhawat',
      'oldPrice': '₹5000',
      'discount': 'Off 98.99%',
      'newPrice': '₹5',
      'imagePath': 'assets/android/course.webp',
    },
    {
      'title': 'CA Inter Corporate and Other Laws',
      'instructor': 'by CA Amit Bachhawat',
      'oldPrice': '₹5000',
      'discount': 'Off 98.99%',
      'newPrice': '₹5',
      'imagePath': 'assets/android/course.webp',
    },
    {
      'title': 'CA Inter Corporate and Other Laws',
      'instructor': 'by CA Amit Bachhawat',
      'oldPrice': '₹5000',
      'discount': 'Off 98.99%',
      'newPrice': '₹5',
      'imagePath': 'assets/android/course.webp',
    },
    // Add more course data here
  ].obs;

  void _removeCourse(int index) {
    // setState(() {
    courses.removeAt(index); // Remove the course from the list
    // });
  }

  final RxList<Map<String, dynamic>> style = [
    {'banner': true, 'horizontal': true, 'vartical': false},
  ].obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('Checkout ${courses.length == 0 ? '' : courses.length}',
              style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Back navigation
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            children: [
              courses.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return Card(
                            color: Colors.white,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Course image
                                  Container(
                                    height: 60,
                                    width: 60,
                                    child: Image.asset(
                                      course['imagePath']!,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  // Course info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course['title']!,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          course['instructor']!,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Text(course['oldPrice']!,
                                                style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationColor:
                                                        ColorPage.buttonColor,
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                )),
                                            Text(course['discount']!,
                                                style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                    fontSize: 10.0,
                                                    color: Colors.red,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(course['newPrice']!,
                                                style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                      fontSize: 14.0,
                                                      color: ColorPage.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Delete icon
                                  IconButton(
                                    icon: Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    onPressed: () {
                                      _removeCourse(index);
                                      ToastClass.showToast(
                                          'Item removed from cart',
                                          context: context);
                                      // Delete logic here
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/android/nodatafound.png',
                          width: 400,
                        ),
                      ),
                    ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BillingDetailsPage()),
                    );
                  },
                  child: Text(
                    'Pay ₹5000.00',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPage.colorbutton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
