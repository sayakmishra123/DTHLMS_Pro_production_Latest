import 'package:flutter/material.dart';

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
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Display the search query and selected suggestions
    String resultsText = selectedSuggestions.isNotEmpty
        ? "Selected: ${selectedSuggestions.join(', ')}"
        : "Search: $query";

    return Center(
      child: Text(resultsText, style: TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Filter the suggestions based on the query
    filteredSuggestions = suggestions
        .where((suggestion) =>
            suggestion.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Use StatefulBuilder to manage the state
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Check if there are any filtered suggestions
            if (query.isNotEmpty && filteredSuggestions.isEmpty)
              Center(
                child: Text(
                  "No search results found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            else
              // Suggestions as buttons using Container
              Wrap(
                spacing: 4.0, // Horizontal spacing between buttons
                runSpacing: 8.0, // Vertical spacing between rows
                children: (query.isEmpty ? suggestions : filteredSuggestions)
                    .map((suggestion) {
                  final isSelected = selectedSuggestions.contains(suggestion);
                  return GestureDetector(
                    onTap: () {
                      // Toggle selection
                      if (isSelected) {
                        selectedSuggestions.remove(suggestion);
                      } else {
                        selectedSuggestions.add(suggestion);
                      }

                      // Update the query to show selected options
                      query = selectedSuggestions.join(', ');

                      // Trigger a rebuild to reflect changes
                      setState(() {});
                      showSuggestions(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 10.0), // Smaller padding
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : ColorPage.colorbutton,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? ColorPage.colorbutton
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            suggestion,
                            style: TextStyle(
                                fontSize: 10,
                                color: isSelected
                                    ? ColorPage.colorbutton
                                    : Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      );
    });
  }
}
