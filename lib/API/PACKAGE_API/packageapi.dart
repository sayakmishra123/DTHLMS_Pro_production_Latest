
// import "package:dthlms/Master/modelclass/allpackagemodelclass.dart";

// import "package:dthlms/Master/packagedetails.dart";
// import "package:dthlms/android/packagemobile/newPackages.dart";
// import "package:dthlms/utils/loader.dart";



// Future packagedetails(BuildContext context, String token, int packageId) async {
//   // try {
//   final Getx getx = Get.find<Getx>();
//   loader(context); // Ensure this function is correctly defined
//   print(token);

//   Map<String, dynamic> data = {
//     "tblPackage": {"PackageId": packageId}
//   };

//   try {
//     final response = await http.post(
//       Uri.https(ClsUrlApi.mainurl, ClsUrlApi.tblpackage),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json'
//       },
//       body: jsonEncode(data),
//     );

//     print(response.body);

//     if (response.statusCode == 200) {
//       var jsondata = jsonDecode(response.body);

//       if (jsondata['isSuccess'] == true) {
//         if (jsondata['result'] != null) {
//           List<dynamic> resultList = jsonDecode(jsondata['result']);

//           List package = resultList.toList();

//           for (var i in package) {
//             getx.packagedetailsfoldername.addAll(i);
//           }
//           for (var a in getx.packagedetailsfoldername.entries) {
//             print(a.key);
//           }
//           print(getx.packagedetailsfoldername.entries.length);

//           Get.back();
//         } else {
//           Get.back();
//         }
//       } else {
//         Get.back();
//         print(
//             'Error: ${jsondata['message']}'); // Print error message if available
//       }
//     } else {
//       Get.back();
//       print('HTTP Error: ${response.statusCode}');
//     }
//   } catch (e) {
//     Get.back();
//     print('Exception: $e');
//   }
// }

// Future<void> allPackage(String token, BuildContext context) async {
//   try {
//     Getx getx = Get.find<Getx>();
//     loader(context);
//     Map data = {
//       "tblPackage": {"PackageId": "0"}
//     };

//     final response = await http.post(
//       Uri.https(ClsUrlApi.mainurl, ClsUrlApi.allpackage),
//       body: json.encode(data),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//     var jsondata = json.decode(response.body);
//     if (response.statusCode == 200 && jsondata['isSuccess'] == true) {
//       var jsonData = json.decode(jsondata['result']);
//       getx.package.clear();
//       for (int i = 0; i < jsonData.length; i++) {
//         final data = AllPackages(
//           courseId: jsonData[i]['CourseId'].toString(),
//           courseName: jsonData[i]['CourseName'].toString(),
//           termId: jsonData[i]['TermId'].toString(),
//           termName: jsonData[i]['TermName'].toString(),
//           packageId: jsonData[i]['PackageId'].toString(),
//           isActive: jsonData[i]['IsActive'].toString(),
//           packageName: jsonData[i]['PackageName'].toString(),
//           packageDisplayName: jsonData[i]['PackageDisplayName'].toString(),
//           srNo: jsonData[i]['SrNo'].toString(),
//           sortedOrder: jsonData[i]['SortedOrder'].toString(),
//         );
//         getx.package.add(data);
//         print(getx.package[i].packageName);
//       }

//       Get.back();
//     }
//   } catch (e) {
//     Get.back();
//   }
// }
