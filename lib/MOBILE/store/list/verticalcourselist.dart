import 'package:dthlms/MOBILE/store/list/ListviewPackage.dart';
import 'package:dthlms/MOBILE/store/list/searchlist.dart';
// import 'package:dthlms/PC/HOMEPAGE/homepage.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerticalCourselist extends StatefulWidget {
  const VerticalCourselist({super.key});

  @override
  State<VerticalCourselist> createState() => _VerticalCourselistState();
}

class _VerticalCourselistState extends State<VerticalCourselist> {
  late List<bool> _isSelected = [];
  late List<bool> _isSelected2 = [];
  @override
  void initState() {
    super.initState();
    _isSelected = List.generate(
      course.length,
      (index) => false,
    );
    _isSelected2 = List.generate(
      other.length,
      (index) => false,
    );
    // Initialize selection state
  }

  void _toggleSelection(int index) {
    setState(() {
      _isSelected[index] = !_isSelected[index]; // Toggle selection
    });
  }

  final List<Map<String, String>> episodes = [
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'title': 'course 1 | New Package | Full course',
      'views': '25K views • 5 days ago',
      'duration': '22:35'
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'title': 'course 2 | New Package | Full course',
      'views': '18K students • 6 days ago',
      'duration': '22:33'
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'title': 'course 3 | New Package | Full course',
      'views': '22K students • 7 days ago',
      'duration': '23:06'
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'title': 'course 4 | New Package | Full course',
      'views': '19K students • 8 days ago',
      'duration': '23:05'
    },
  ];
  void _toggleSelection2(int index) {
    setState(() {
      _isSelected2[index] = !_isSelected2[index]; // Toggle selection
    });
  }

  List course = ['All', 'Courses'];
  List other = ['Professional', 'Professional and old Syllabus'];

  void _sortEpisodes(String order) {
    setState(() {
      if (order == "A to Z") {
        episodes.sort((a, b) => a['title']!.compareTo(b['title']!));
      } else if (order == "Z to A") {
        episodes.sort((a, b) => b['title']!.compareTo(a['title']!));
      } else if (order == "Other Style") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerticalCourselist(),
          ),
        );
      } else {
        // Reset to original order if needed
        // Here you can implement logic to reset to original order if you store it
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       showSearch(context: context, delegate: SearchList());
          //     },
          // icon: Icon(Icons.search)),
          // SortMenu(
          //   onSortSelected: _sortEpisodes,
          // )
        ],
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HeadingBox(),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
            child: Row(
              children: List.generate(course.length, (index) {
                return GestureDetector(
                  onTap: () => _toggleSelection(index),
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _isSelected[index]
                          ? Colors.black
                          : Colors.transparent,
                      border: Border.all(
                        color: ColorPage.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      course[index],
                      style: TextStyle(
                        fontSize: 10,
                        color: _isSelected[index] ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: episodes.length,
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  // onTap: () => Get.to(() => CoursePage()),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 180,
                              width: MediaQuery.sizeOf(context).width,
                              // height: ,
                              child: Image.network(
                                episodes[index]['imageUrl'].toString(),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width - 30,
                                child: Text(
                                  episodes[index]['title'].toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                episodes[index]['views'].toString(),
                                style: TextStyle(
                                    fontSize: 10, color: ColorPage.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                episodes[index]['duration'].toString(),
                                style: TextStyle(
                                    fontSize: 10, color: ColorPage.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('₹5000 ',
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: ColorPage.buttonColor,
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  )),
                              Text(' Off 98.99%',
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
                              Text('₹5',
                                  style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 14.0,
                                        color: ColorPage.red,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
