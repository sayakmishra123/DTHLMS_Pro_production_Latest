import 'package:cloud_firestore/cloud_firestore.dart';

class TopicModel {
  final String name;
  // final String title;
  // final String description;
  final String sessionId; // Add sessionId field

  final bool show;

  TopicModel({
    required this.name,
    // required this.title,
    // required this.description,
    required this.sessionId,
    required this.show // Include sessionId in the constructor
  });

  factory TopicModel.fromDocument(DocumentSnapshot doc) {
    return TopicModel(
        name: doc['name'],
        // title: doc['title'],
        // description: doc['description'],
        sessionId: doc['sessionId'], // Initialize sessionId from Firestore
        show: doc['show']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      // 'description': description,
      'sessionId': sessionId, // Include sessionId in the map
      'show': show // Include sessionId in the map
    };
  }
}
