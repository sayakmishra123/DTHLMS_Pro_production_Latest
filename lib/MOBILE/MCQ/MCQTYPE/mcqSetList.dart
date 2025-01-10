// import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
// import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
// import 'package:dthlms/MOBILE/MCQ/mcqCondition.dart';
// import 'package:dthlms/MOBILE/MCQ/McqTestRank.dart';
// import 'package:dthlms/THEME_DATA/color/color.dart';
// import 'package:dthlms/THEME_DATA/font/font_family.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class MCQSetList extends StatefulWidget {
//   final String type;
//   const MCQSetList({super.key, required this.type});

//   @override
//   State<MCQSetList> createState() => _MCQSetListState();
// }

// class _MCQSetListState extends State<MCQSetList> {
//   RxList mcqSetList = [].obs;
//   RxList mcqPaperList = [].obs;
//   // List<String> typelist = ["Quick Test", "Comprehensive", "Ranked Competition"];
//   @override
//   void initState() {
//     getMCQSetList();
//   }

//   Future getMCQSetList() async {
//     mcqSetList.value =
//         await fetchMCQSetList(getx.selectedPackageId.value.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Obx(
//         () => Scaffold(
//           appBar: AppBar(
//             backgroundColor: ColorPage.colorbutton,
//             // automaticallyImplyLeading: true,
//             // leading: ,
//             iconTheme: IconThemeData(color: ColorPage.white),
//             title: Text(
//               "MCQ",
//               style: FontFamily.font2,
//             ),
//           ),
//           body: getx.mcqdataList.value
//               ? mcqSetList.isNotEmpty
//                   ? Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 5),
//                       child: Container(
//                         height: MediaQuery.of(context).size.height,
//                         child: ListView.builder(
//                             itemCount: mcqSetList.length,
//                             itemBuilder: (context, index) {
//                               return mcqSetList[index]["ServicesTypeName"] ==
//                                       "${widget.type}"
//                                   ? Container(
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                             color: const Color.fromARGB(
//                                                 255, 212, 212, 212)),
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: ColorPage.white,
//                                       ),
//                                       margin: EdgeInsets.symmetric(vertical: 4),
//                                       child: ExpansionTile(
//                                         leading: Icon(
//                                           Icons.book_rounded,
//                                           color: ColorPage.grey,
//                                         ),
//                                         collapsedIconColor:
//                                             ColorPage.colorbutton,
//                                         shape: RoundedRectangleBorder(
//                                             side: BorderSide(
//                                                 color: Colors.transparent)),
//                                         title: Text(
//                                           mcqSetList[index]["SetName"],
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                         onExpansionChanged: (value) async {
//                                           if (value) {
//                                             mcqPaperList.clear();
//                                             mcqPaperList.value =
//                                                 await fetchMCQPapertList(
//                                                     mcqSetList[index]["SetId"]);
//                                           }
//                                         },
//                                         children: [
//                                           Obx(() => mcqPaperList.isNotEmpty
//                                               ? Container(
//                                                   height:
//                                                       mcqPaperList.length * 50,
//                                                   child: ListView.builder(
//                                                       itemCount:
//                                                           mcqPaperList.length,
//                                                       itemBuilder:
//                                                           (context, ind) {
//                                                         return ListTile(
//                                                           onTap: () async {
//                                                             if (widget.type ==
//                                                                 "Quick Practice") {
//                                                               print(
//                                                                   "practice ");

//                                                               Get.to( transition: Transition.cupertino,() =>
//                                                                   McqTermAndConditionmobile(
//                                                                     isAnswerSheetShow:   mcqPaperList[ind]
//                                                                             [
//                                                                             'IsAnswerSheetShow'],
//                                                                     termAndCondition:
//                                                                         mcqPaperList[ind]
//                                                                             [
//                                                                             'TermAndCondition'],
//                                                                     paperName: mcqPaperList[
//                                                                             ind]
//                                                                         [
//                                                                         'PaperName'],
//                                                                     startTime: mcqPaperList[
//                                                                             ind]
//                                                                         [
//                                                                         'MCQPaperStartDate'],
//                                                                     totalMarks:
//                                                                         mcqPaperList[ind] 
//                                                                             [
//                                                                             'TotalMarks'],
//                                                                     duration: mcqPaperList[
//                                                                             ind]
//                                                                         [
//                                                                         'Duration'],
//                                                                     paperId: mcqPaperList[
//                                                                             ind]
//                                                                         [
//                                                                         'PaperId'],
//                                                                     type: mcqSetList[
//                                                                             index]
//                                                                         [
//                                                                         "ServicesTypeName"],
//                                                                     url: "",
//                                                                   ));
//                                                             }
//                                                             if (widget.type ==
//                                                                 "Comprehensive") {
//                                                               bool checking = await checkIsSubmited(
//                                                                   mcqPaperList[
//                                                                               ind]
//                                                                           [
//                                                                           'PaperId']
//                                                                       .toString());
//                                                               // if (checking) {
//                                                               print(
//                                                                   "comprehensive ");
//                                                               //   List rankdata = await getRankDataOfMockTest(context, getx.loginuserdata[0].token, mcqPaperList[ind]['PaperId'].toString());
//                                                               //   Get.to(
//                                                               //     () => RankPage(paperId: mcqPaperList[ind]['PaperId'].toString(), questionData: fetchResultOfStudent(mcqPaperList[ind]['PaperId'].toString())),
//                                                               //   );
//                                                               // } else {
//                                                               Get.to( transition: Transition.cupertino,() =>
//                                                                   McqTermAndConditionmobile(
//                                                                     isAnswerSheetShow:   mcqPaperList[ind]
//                                                                             [
//                                                                             'IsAnswerSheetShow'],
//                                                                     termAndCondition:
//                                                                         mcqPaperList[ind]
//                                                                             [
//                                                                             'TermAndCondition'],
//                                                                     paperName: mcqPaperList[
//                                                                             ind]
//                                                                         [
//                                                                         'PaperName'],
//                                                                     startTime: mcqPaperList[
//                                                                             ind]
//                                                                         [
//                                                                         'MCQPaperStartDate'],
//                                                                     totalMarks:
//                                                                         mcqPaperList[ind]
//                                                                             [
//                                                                             'TotalMarks'],
//                                                                     duration: mcqPaperList[
//                                                                             ind]
//                                                                         [
//                                                                         'Duration'],
//                                                                     paperId: mcqPaperList[
//                                                                             ind]
//                                                                         [
//                                                                         'PaperId'],
//                                                                     url: "",
//                                                                     type: mcqSetList[
//                                                                             index]
//                                                                         [
//                                                                         "ServicesTypeName"],
//                                                                   ));
//                                                             }
//                                                             if (widget.type ==
//                                                                 "Ranked Competition") {
//                                                               bool checking = await checkIsSubmited(
//                                                                   mcqPaperList[
//                                                                               ind]
//                                                                           [
//                                                                           'PaperId']
//                                                                       .toString());
//                                                               if (!checking) {
//                                                                 print(
//                                                                     "competition ");
//                                                                 List rankdata = await getRankDataOfMockTest(
//                                                                     context,
//                                                                     getx
//                                                                         .loginuserdata[
//                                                                             0]
//                                                                         .token,
//                                                                     mcqPaperList[ind]
//                                                                             [
//                                                                             'PaperId']
//                                                                         .toString());
//                                                                 Get.to( transition: Transition.cupertino,
//                                                                   () =>
//                                                                       RankPage(
//                                                                     frompaper:
//                                                                         true,
//                                                                     totalmarks:
//                                                                         mcqPaperList[ind]
//                                                                             [
//                                                                             'TotalMarks'],
//                                                                     paperId: mcqPaperList[ind]
//                                                                             [
//                                                                             'PaperId']
//                                                                         .toString(),
//                                                                     questionData:
//                                                                         fetchResultOfStudent(
//                                                                             mcqPaperList[ind]['PaperId'].toString()),
//                                                                     isMcq: true,
//                                                                     type: widget.type,
//                                                                     paperName: mcqPaperList[ind]
//                                                                               [
//                                                                               'PaperName'],
//                                                                     submitedOn: "",
//                                                                   ),
//                                                                 );
//                                                               } else {
//                                                                 Get.to( transition: Transition.cupertino,() =>
//                                                                     McqTermAndConditionmobile(
//                                                                       isAnswerSheetShow:  "false",
//                                                                       termAndCondition:
//                                                                           mcqPaperList[ind]
//                                                                               [
//                                                                               'TermAndCondition'],
//                                                                       paperName:
//                                                                           mcqPaperList[ind]
//                                                                               [
//                                                                               'PaperName'],
//                                                                       startTime:
//                                                                           mcqPaperList[ind]
//                                                                               [
//                                                                               'MCQPaperStartDate'],
//                                                                       totalMarks:
//                                                                           mcqPaperList[ind]
//                                                                               [
//                                                                               'TotalMarks'],
//                                                                       url: "",
//                                                                       duration:
//                                                                           mcqPaperList[ind]
//                                                                               [
//                                                                               'Duration'],
//                                                                       paperId: mcqPaperList[
//                                                                               ind]
//                                                                           [
//                                                                           'PaperId'],
//                                                                       type: mcqSetList[
//                                                                               index]
//                                                                           [
//                                                                           "ServicesTypeName"],
//                                                                     ));
//                                                               }
//                                                             }
//                                                           },
//                                                           title: Text(
//                                                               mcqPaperList[ind][
//                                                                   'PaperName']),
//                                                         );
//                                                       }),
//                                                 )
//                                               : Container(
//                                                   child: Center(
//                                                     child:
//                                                         Text("No Paper Found"),
//                                                   ),
//                                                 ))
//                                         ],
//                                       ),
//                                     )
//                                   : SizedBox();
//                             }),
//                       ),
//                     )
//                   : Container(
//                       child: Center(
//                         child: Text("No Set Found"),
//                       ),
//                     )
//               : Container(),
//         ),
//       ),
//     );
//   }
// }
