import 'package:dthlms/MOBILE/store/storemodelclass/storemodelclass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../THEME_DATA/color/color.dart';

class SearchList extends SearchDelegate<String> {
  // Sample data for suggestions
  final List<String> suggestions = [
    "Apple",
    "Banana",
    "Cherry",
    "Date",
    "Fig",
    "Grape",
    "Kiwi",
  ];

  // This list holds filtered suggestions based on search input
  List<String> filteredSuggestions = [];

  // Set to hold selected suggestions
  final Set<String> selectedSuggestions = {};
  RxList<PackageInfo> packages;
  SearchList(this.packages);

  RxList<PremiumPackage> allstorePackages = RxList<PremiumPackage>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          selectedSuggestions.clear(); // Clear selections when query is cleared
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Get.back();
        // close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Display the search query and selected suggestions
// Flatten the list and convert it to an RxList<PremiumPackage>
    allstorePackages = RxList<PremiumPackage>.from(
      packages.expand((e) => e.premiumPackageListInfo).toList(),
    );

    return ListView.builder(
      itemCount: allstorePackages.length,
      itemBuilder: (context, index) {
        final listPackage = allstorePackages[index];
        return ListTile(
          leading: Text(listPackage.packageName),
          // title: Image.network(listPackage.packageBannerPathUrl),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Filter the suggestions based on the query
    allstorePackages = RxList<PremiumPackage>.from(
      packages.expand((e) => e.premiumPackageListInfo).toList(),
    );

    // Use StatefulBuilder to manage the state
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: allstorePackages.length,
            itemBuilder: (context, index) {
              final listPackage = allstorePackages[index];
              return Card(
                shadowColor: Colors.transparent,
                color: ColorPage.white,
                child: ListTile(
                  minVerticalPadding: 0,
                  style: ListTileStyle.list,
                  subtitle: Text(
                    '₹${listPackage.minPackagePrice}',
                    style: TextStyle(color: ColorPage.red),
                  ),
                  contentPadding: EdgeInsets.all(0),
                  title: Text(listPackage.packageName,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  leading: Image.network(
                    listPackage.packageBannerPathUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(error.toString());
                    },
                  ),
                ),
              );
            },
          ));
    });
  }
}
