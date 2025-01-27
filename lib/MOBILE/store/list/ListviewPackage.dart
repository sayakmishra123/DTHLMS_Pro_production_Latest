import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/MOBILE/HOMEPAGE/bannerInfoPage.dart';
import 'package:dthlms/MOBILE/THEORY_EXAM/store_dashboard.dart';
import 'package:dthlms/MOBILE/store/list/searchlist.dart';
import 'package:dthlms/MOBILE/store/list/verticalcourselist.dart';

// import 'package:dthlms/MOBILE/store/store_dashboard.dart';
import 'package:dthlms/MOBILE/store/storemodelclass/storemodelclass.dart';
import 'package:dthlms/constants.dart';
import 'package:flutter/material.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SortMenu extends StatelessWidget {
  final void Function(String) onSortSelected;

  const SortMenu({Key? key, required this.onSortSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      onSelected: onSortSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      itemBuilder: (BuildContext context) {
        return ['A to Z', 'Z to A', 'Other Style'].map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Text(
                choice,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          );
        }).toList();
      },
      icon: Icon(Icons.sort, color: Colors.black),
    );
  }
}

class ListviewPackage extends StatefulWidget {
  @override
  _ListviewPackageState createState() => _ListviewPackageState();
}

class _ListviewPackageState extends State<ListviewPackage> {
  final List<Map<String, String>> episodes = [
    {
      'imageUrl': 'assets/android/Welcome to.jpg',
      'title': 'course 1 | New Package | Full course',
      'views': '25K views • 5 days ago',
      'duration': '22:35'
    },
    {
      'imageUrl': 'assets/android/Welcome to.jpg',
      'title': 'course 2 | New Package | Full course',
      'views': '18K students • 6 days ago',
      'duration': '22:33'
    },
    {
      'imageUrl': 'assets/android/Welcome to.jpg',
      'title': 'course 3 | New Package | Full course',
      'views': '22K students • 7 days ago',
      'duration': '23:06'
    },
    {
      'imageUrl': 'assets/android/Welcome to.jpg',
      'title': 'course 4 | New Package | Full course',
      'views': '19K students • 8 days ago',
      'duration': '23:05'
    },
  ];

  final List<Map<String, String>> viewersChoice = [
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'title': 'course 47 || 22 Oct 2024',
      'views': '1.2 lakh students • 1 day ago',
      'duration': '43:24'
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'title': 'course 45 | course | 21 Oct 2024',
      'views': '1.3 lakh students • 2 days ago',
      'duration': '49:00'
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'title': 'Gift With A Mystery | Full course | 19 Oct 2024',
      'views': '79K students • 3 days ago',
      'duration': '1:31:10'
    },
    {
      'imageUrl': 'https://picsum.photos/200/300',
      'title': 'course 478 || 22 Oct 2024',
      'views': '1.2 lakh students • 1 day ago',
      'duration': '43:24'
    },
  ];

  late List<bool> _isSelected = [];
  late List<bool> _isSelected2 = [];

  @override
  void initState() {
    super.initState();
    // log('init state');
    getFullBannerPackages(context, getx.loginuserdata[0].token);

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
    setState(
      () {
        _isSelected[index] = !_isSelected[index]; // Toggle selection
      },
    );
  }

  void _toggleSelection2(int index) {
    setState(() {
      _isSelected2[index] = !_isSelected2[index]; // Toggle selection
    });
  }

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

  List course = ['All', 'Courses'];
  List other = ['Professional', 'Professional and old Syllabus'];

  // final RxList<Map<String, dynamic>> style = [
  //   {
  //     "title": 'Course 1',
  //     'banner': true,
  //     'show': true,
  //     'vartical': false,
  //     'style': 0
  //   },
  //   {
  //     "title": 'Course 2',
  //     'banner': false,
  //     'show': true,
  //     'vartical': true,
  //     'style': 1
  //   },
  //   {
  //     "title": '',
  //     'banner': true,
  //     'show': true,
  //     'vartical': true,
  //     'style': 0,
  //   },
  //   {
  //     "title": 'Course 4',
  //     'banner': false,
  //     'show': true,
  //     'vartical': false,
  //     'style': 0
  //   },
  // ].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Courses'),
          actions: [
            IconButton(
                onPressed: () async {
                  showSearch(context: context, delegate: SearchList());
                },
                icon: Icon(Icons.search)),
            SortMenu(
              onSortSelected: _sortEpisodes,
            )
          ],
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        body: Obx(
          () => getx.style.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // if (getx.style.isNotEmpty)
                      for (int i = 0; i < getx.style[0].result.length; i++) ...[
                        // Full Banner Section
                        if (getx.style[0].result[i].imageType == 'Full Banner')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: HeadingBox(
                              mode: 1,
                              imageUrl: getx
                                  .style[0].result[i].premiumPackageListInfo,
                              package: getx
                                  .style[0].result[i].premiumPackageListInfo,
                            ),
                          ),

                        //   // Horizontal Package Section
                        if (getx.style[0].result[i].imageType ==
                            'Horizontal Package')
                          _buildHorizontalPackageList(getx.style[0].result[i],
                              getx.style[0].result[i].premiumPackageListInfo),

                        // // Vertical Banner Section
                        if (getx.style[0].result[i].imageType ==
                            'Vertical Package')
                          _buildVerticalPackageList(getx.style[0].result[i],
                              getx.style[0].result[i].premiumPackageListInfo),
                        SizedBox(
                          height: 20,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 5, bottom: 0, top: 10),
                        //   child: Row(children: []),
                        // ),
                      ]
                      // else ...[

                      // ]
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }

  Widget _buildHorizontalPackageList(
      PackageInfo packageinfo, List<PremiumPackage> style) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Container(
            child: Row(
              children: [
                Icon(Icons.sort),
                Text(
                  ' ${packageinfo.heading}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Container(
            height: 310,
            child: ListView.builder(
                itemCount: style.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final data = style[index];

                  // log(data.packageBannerPathUrl);

                  return style[index].packageBannerPathUrl.isNotEmpty
                      ? MaterialButton(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          onPressed: () {
                            Get.to(
                                transition: Transition.cupertino,
                                () => CoursePage(data));
                          },
                          child: EpisodeCard(
                              imageUrl: data.packageBannerPathUrl,
                              title: data.packageName,
                              views: packageinfo.heading,
                              duration: '10:50',
                              price: data.minPackagePrice ?? 0.0,
                              mode: 0),
                        )
                      : SizedBox();
                })),
      ],
    );
  }

  Widget _buildVerticalPackageList(
      PackageInfo packageinfo, List<PremiumPackage> style) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Container(
            child: Row(
              children: [
                Icon(Icons.sort),
                Text(
                  ' ${packageinfo.heading}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Container(
            // height: 230,
            child: ListView.builder(
                itemCount: style.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final data = style[index];
                  return data.packageBannerPathUrl.isNotEmpty
                      ? MaterialButton(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          onPressed: () {
                            Get.to(
                                transition: Transition.cupertino,
                                () => CoursePage(data));
                          },
                          child: EpisodeCard(
                            imageUrl: data.packageBannerPathUrl,
                            title: data.packageName,
                            views: '55k',
                            duration: '10:50',
                            price: data.minPackagePrice,
                            mode: 1,
                          ),
                        )
                      : SizedBox();
                })),
      ],
    );
  }
}

class EpisodeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String views;
  final String duration;

  final double price;
  int mode;
  EpisodeCard({
    required this.imageUrl,
    required this.title,
    required this.views,
    required this.duration,
    required this.price,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    // log(imageUrl + " index");
    return Container(
      width: mode == 0 ? 300 : null,
      child: InkWell(
        // onTap: () => Get.to(() => CoursePage( packageinfo)),
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: mode == 0 ? 200 : 200,
                    width: MediaQuery.sizeOf(context).width - 20,
                    // height: ,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) =>
                          Center(child: Image.asset(logopath)),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width - 30,
                  alignment: Alignment.topLeft,
                  // width: MediaQuery.sizeOf(context).width - 30,
                  child: Text(
                    // overflow: TextOverflow.ellipsis,
                    title,

                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width - 30,
                  // color: Colors.red,
                  alignment: Alignment.topLeft,
                  child: Text(
                    views,
                    style: TextStyle(fontSize: 10, color: ColorPage.grey),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width - 30,
                  // color: Colors.red,
                  alignment: Alignment.topLeft,
                  child: Text(
                    duration,
                    style: TextStyle(fontSize: 10, color: ColorPage.grey),
                  ),
                ),
                // Container(
                //   width: MediaQuery.sizeOf(context).width - 0,
                //   // color: Colors.red,
                //   alignment: Alignment.topLeft,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Text('₹5000 ',
                //           style: GoogleFonts.inter(
                //             textStyle: TextStyle(
                //               decoration: TextDecoration.lineThrough,
                //               decorationColor: ColorPage.buttonColor,
                //               fontSize: 10,
                //               color: Colors.grey,
                //             ),
                //           )),
                //       Text(' Off 98.99%',
                //           style: GoogleFonts.inter(
                //             textStyle: TextStyle(
                //               fontSize: 10.0,
                //               color: Colors.red,
                //             ),
                //           )),
                //     ],
                //   ),
                // ),
                Container(
                  width: MediaQuery.sizeOf(context).width - 30,
                  // color: Colors.red,
                  alignment: Alignment.topLeft,
                  child: Text('₹${price}',
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.0,
                            color: ColorPage.red,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // : Card(
    //     // shape: Border.all(),
    //     color: Colors.white,
    //     elevation: 0,
    //     // margin: EdgeInsets.all(0),
    //     child: Padding(
    //       padding:
    //           const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           // Thumbnail Image
    //           Container(
    //             width: 140.0,
    //             height: 100.0,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(8.0),
    //               image: DecorationImage(
    //                 image: AssetImage(imageUrl),
    //                 fit: BoxFit.contain,
    //               ),
    //             ),
    //           ),
    //           SizedBox(width: 10.0),
    //           // Episode Details
    //           Expanded(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   title,
    //                   style: TextStyle(
    //                     fontSize: 12.0,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                   maxLines: 2,
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //                 SizedBox(height: 5.0),
    //                 Text(
    //                   views,
    //                   style: TextStyle(
    //                     fontSize: 11.0,
    //                     color: Colors.grey,
    //                   ),
    //                 ),
    //                 SizedBox(height: 5.0),
    //                 Row(
    //                   children: [
    //                     Text('₹5000 ',
    //                         style: GoogleFonts.inter(
    //                           textStyle: TextStyle(
    //                             decoration: TextDecoration.lineThrough,
    //                             decorationColor: ColorPage.buttonColor,
    //                             fontSize: 10,
    //                             color: Colors.grey,
    //                           ),
    //                         )),
    //                     Text(' Off 98.99%',
    //                         style: GoogleFonts.inter(
    //                           textStyle: TextStyle(
    //                             fontSize: 10.0,
    //                             color: Colors.red,
    //                           ),
    //                         )),
    //                   ],
    //                 ),
    //                 Row(
    //                   children: [
    //                     Text('₹5',
    //                         style: GoogleFonts.inter(
    //                           textStyle: TextStyle(
    //                               fontSize: 14.0,
    //                               color: ColorPage.red,
    //                               fontWeight: FontWeight.bold),
    //                         )),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
  }
}

class HeadingBox extends StatefulWidget {
  List imageUrl;
  int mode;
  List<PremiumPackage> package;

  HeadingBox({
    required this.mode,
    required this.imageUrl,
    this.package = const [], // Default value as an empty list
  });

  @override
  State<HeadingBox> createState() => _HeadingBoxState();
}

class _HeadingBoxState extends State<HeadingBox> {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  RxInt currentIndex = 0.obs;
  RxList list = [].obs;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //  getx.bannerImageList.isNotEmpty
        widget.mode == 0
            ? Container(
                height: 110,
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: CarouselSlider(
                      items: widget.imageUrl.map((item) {
                        return InkWell(
                          onTap: () {
                            Get.to(() => BannerDetailsPage(
                                  index: currentIndex.value,
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              // padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(20),
                                  // gradient: LinearGradient(
                                  //   begin: Alignment.centerLeft,
                                  //   end: Alignment.centerRight,
                                  //   // colors: ColorPage.gradientHeadingBox,
                                  // ),
                                  ),
                              child: item["BannerImagePosition"] == "middle"
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item['DocumentUrl']!,
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Text(
                                            'Image failed',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          );
                                        },
                                      ),
                                    )
                                  : HeadingBoxContent(
                                      imagePath: item['DocumentUrl'],
                                      imagePosition:
                                          item["BannerImagePosition"],
                                      isImage: true,
                                      title: item["BannerContent"],
                                    ),
                            ),
                          ),
                        );
                      }).toList(),
                      carouselController: carouselController,
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        aspectRatio: 2,
                        viewportFraction: 0.98,
                        onPageChanged: (index, reason) {
                          currentIndex.value = index;
                        },
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: CarouselSlider(
                      items: widget.package.map((item) {
                        print(item.documentUrl);
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                              // padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(20),
                                  // gradient: LinearGradient(
                                  //   begin: Alignment.centerLeft,
                                  //   end: Alignment.centerRight,
                                  //   // colors: ColorPage.gradientHeadingBox,
                                  // ),
                                  ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.documentUrl,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                              )),
                        );
                      }).toList(),
                      carouselController: carouselController,
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        aspectRatio: 2,
                        viewportFraction: 0.98,
                        onPageChanged: (index, reason) {
                          currentIndex.value = index;
                        },
                      ),
                    ),
                  ),
                ),
              ),
        Obx(
          () => list.isEmpty
              ? Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.package.isEmpty
                        ? widget.imageUrl.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () =>
                                  carouselController.animateToPage(entry.key),
                              child: Container(
                                width: currentIndex == entry.key ? 18 : 10,
                                height: 7,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                    color: currentIndex == entry.key
                                        ? ColorPage.blue
                                        : ColorPage.white),
                              ),
                            );
                          }).toList()
                        : widget.package.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () =>
                                  carouselController.animateToPage(entry.key),
                              child: Container(
                                width: currentIndex == entry.key ? 18 : 10,
                                height: 7,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20),
                                    color: currentIndex == entry.key
                                        ? ColorPage.blue
                                        : ColorPage.white),
                              ),
                            );
                          }).toList(),
                  ),
                )
              : SizedBox(),
        ),
      ],
    );
  }
}

class HeadingBoxContent extends StatelessWidget {
  final String? date;
  final String? title;
  final String? desc;
  final Widget? trailing;
  final String imagePath;
  final String imagePosition;
  final bool isImage;
  const HeadingBoxContent({
    super.key,
    this.date,
    this.title,
    this.desc,
    required this.imagePosition,
    this.trailing,
    required this.isImage,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'AltoneRegular', fontSize: 20);
    TextStyle styleb = TextStyle(fontFamily: 'AltoneBold', fontSize: 20);
    return LayoutBuilder(builder: (context, constraints) {
      return isImage && imagePosition == 'right'
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text at the start
                Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Container(
                      child: HtmlWidget(title!),
                    )),

                // Image at the end
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width / 2.5,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width / 2.5,
                  ),
                ),
                // Text at the start

                Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Container(
                      child: HtmlWidget(
                        title!,
                        textStyle: TextStyle(color: Colors.white),
                      ),
                    )),

                // Image at the end
              ],
            );
    });
  }
}

// class HeadingBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         'Heading Box',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
