import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/THEORY_EXAM/theorypaperlist_mobile_page.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TheoryExamPaperListofMobile extends StatefulWidget {
  @override
  State<TheoryExamPaperListofMobile> createState() =>
      _TheoryExamPaperListofMobileState();
}

class _TheoryExamPaperListofMobileState
    extends State<TheoryExamPaperListofMobile>
    with SingleTickerProviderStateMixin {
  Getx getx = Get.put(Getx());

  // List<Map<String, dynamic>> testWrittenExamList = getx.testWrittenExamList
  //     .where(
  //         (row) => row['PackageId'] == getx.selectedPackageId.value.toString())
  //     .toList();
  RxList theorySetList = [].obs;
  RxList theoryPaperList = [].obs;
  late TabController _tabController;

  RxList uniqueServicesList = [].obs;

  // Fetch theory set list and unique services
  Future getTheorySetList() async {
    theorySetList.value =
        await fetchTheorySetList(getx.selectedPackageId.value.toString());
    Set<String> uniqueServices =
        theorySetList.map((item) => item['ServicesTypeName'] as String).toSet();
    uniqueServicesList.value = uniqueServices.toList();

    // Initialize the TabController with the number of unique services
    setState(() {
      _tabController =
          TabController(length: uniqueServicesList.length, vsync: this);
    });
  }

  @override
  void initState() {
    super.initState();
    getTheorySetList(); // Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPage.appbarcolor,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: ColorPage.white),
          title: Text(
            'Test Series',
            style: FontFamily.styleb.copyWith(color: Colors.white),
          ),
        ), 
        body: getx.theoryExamvalue.value && uniqueServicesList.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TabBar(
                    tabAlignment: TabAlignment.start,
                    controller: _tabController,
                    labelColor: const Color.fromARGB(255, 0, 0, 0),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color.fromARGB(255, 3, 6, 223),
                    isScrollable: true,
                    tabs: [
                      for (int i = 0; i < uniqueServicesList.length; i++)
                        Tab(
                          text: uniqueServicesList[i],
                        ),
                      // Tab(text: 'Comprehensive'),
                      // Tab(text: 'Ranked Competition'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        for (int i = 0; i < uniqueServicesList.length; i++)
                          _buildTabContent(
                            uniqueServicesList[i],
                          ),
                        // _buildTabContent('Comprehensive'),
                        // _buildTabContent('Ranked Competition', istype: true),
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: Text("No Data Found"),
              ));
  }

  Widget _buildTabContent(
    String tabTitle,
  ) {
    return Obx(
      () => theorySetList.isNotEmpty
          ? Navigator(
              onGenerateRoute: (RouteSettings settings) {
                if (settings.name == '/$tabTitle') {
                  return MaterialPageRoute(
                    builder: (_) {
                      return TheoryPaperListMobile(
                          theorySetList, tabTitle, 'assets/exam.png', true);
                    },
                  );
                }
                return null;

                // Default route to show if the tab is first loaded or navigated to
              },
              initialRoute:
                  '/$tabTitle', // This ensures that the default route is set when first shown
            )
          : _noSetFound(),
    );
  }

  Widget _noSetFound() {
    return Center(
      child: Text("No Set Found"),
    );
  }

  // _onNoInternetConnection(context) {
  //   Alert(
  //     context: context,
  //     type: AlertType.error,
  //     style: AlertStyle(
  //       titleStyle:
  //           TextStyle(color: ColorPage.red, fontWeight: FontWeight.bold),
  //       descStyle: FontFamily.font6,
  //       isCloseButton: false,
  //     ),
  //     title: "!! No internet found !!",
  //     desc: "Make sure you have a proper internet Connection.  ",
  //     buttons: [
  //       DialogButton(
  //         child:
  //             Text("OK", style: TextStyle(color: Colors.white, fontSize: 18)),
  //         highlightColor: Color.fromRGBO(3, 77, 59, 1),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         color: Color.fromRGBO(9, 89, 158, 1),
  //       ),
  //     ],
  //   ).show();
  // }
}
