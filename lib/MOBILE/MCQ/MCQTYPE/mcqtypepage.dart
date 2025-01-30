import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/MCQ/McqListMobile_page.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MCQtypePage extends StatefulWidget {
  const MCQtypePage({super.key});

  @override
  State<MCQtypePage> createState() => _MCQtypePageState();
}

class _MCQtypePageState extends State<MCQtypePage>
    with SingleTickerProviderStateMixin {
  List<String> typelist = [
    "Quick Practice",
    "Comprehensive",
    "Ranked Competition"
  ];
  late TabController _tabController;
  String pageTitle = 'Quick Test';
  RxList mcqSetList = [].obs;
  RxList mcqPaperList = [].obs;
  Getx getx = Get.put(Getx());

  @override
  void initState() {
    getMCQSetList();
    super.initState();

    // Updated length to 3

    // _tabController.addListener(() {
    //   setState(() {
    //     switch (_tabController.index) {
    //       case 0:
    //         pageTitle = 'Quick Test';
    //         break;
    //       case 1:
    //         pageTitle = 'Comprehensive';
    //         break;
    //       case 2:
    //         pageTitle = 'Ranked Competition';
    //         break;
    //     }
    //   });
    // });
  }

  RxList uniqueServicesList = [].obs;
  Future getMCQSetList() async {
    mcqSetList.value = 
        await fetchMCQSetList(getx.selectedPackageId.value.toString());
    // print(mcqSetList.toString());
    Set<String> uniqueServices =
        mcqSetList.map((item) => item['ServicesTypeName'] as String).toSet();

// Convert Set to List if needed
    uniqueServicesList.value = uniqueServices.toList();

// Print the unique services
    print(uniqueServicesList);
    _tabController =
        TabController(length: uniqueServicesList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPage.colorbutton,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: ColorPage.white),
          title: Text(
            "MCQ",
            style: FontFamily.styleb.copyWith(color: Colors.white),
          ),
        ),
        body: getx.mcqdataList.value && uniqueServicesList.isNotEmpty
            ? Column( 
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
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
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        for (int i = 0; i < uniqueServicesList.length; i++)
                          _buildTabContent(uniqueServicesList[i],
                              istype:
                                  'Ranked Competition' == uniqueServicesList[i]
                                      ? true
                                      : false),
                        // _buildTabContent('Comprehensive'),
                        // _buildTabContent('Ranked Competition', istype: true),
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: Text("No Data Found"),
              ),
        // body: Container(
        //   child:  ListView.builder(
        //       itemCount: typelist.length,
        //       itemBuilder: (context, index) {
        //         return Container(
        //           margin: EdgeInsets.all(5),
        //           decoration: BoxDecoration(
        //             boxShadow: [
        //               BoxShadow(
        //                 blurRadius: 3,
        //                 color: Color.fromARGB(255, 196, 190, 244),
        //                 offset: Offset(0, 0),
        //               ),
        //             ],
        //             borderRadius: BorderRadius.all(
        //               Radius.circular(10),
        //             ),
        //             color: Color.fromARGB(255, 255, 255, 255),
        //           ),
        //           child: MaterialButton(
        //             onPressed: () {
        //             Get.to(()=>MCQSetList(type: typelist[index],));
        //             },
        //             child: ListTile(
        //               leading: Image.asset(
        //                 "assets/folder8.png",
        //                 width: 45,
        //               ),
        //               title: Text(typelist[index],
        //                   style: FontFamily.font4.copyWith(fontWeight: FontWeight.bold)),
        //               trailing: Icon(
        //                 Icons.arrow_forward_ios,
        //                 color: ColorPage.colorbutton,
        //               ),
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        // ),
      )),
    );
  }

  Widget _buildTabContent(String tabTitle, {bool istype = false}) {
    return Obx(           
      () => mcqSetList.isNotEmpty
          ? Navigator(
              onGenerateRoute: (RouteSettings settings) {
                // Check which route is being requested within this tab
                if (settings.name == '/$tabTitle') {
                  // If the mcqSetList is not empty, show the McqList, else show "No Set Found"
                  return MaterialPageRoute(
                    builder: (_) {
                      
                      return McqListMobile(    
                          mcqSetList, tabTitle, istype);
                      
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
}
