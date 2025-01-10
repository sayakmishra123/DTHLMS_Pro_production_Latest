class InfiniteMarqueeModel {
  final String title;
  final String marqueeId;

  InfiniteMarqueeModel({
    required this.title,
    required this.marqueeId,
  });

  // Factory method to create an instance from a JSON object
  factory InfiniteMarqueeModel.fromJson(Map<String, dynamic> json) {
    return InfiniteMarqueeModel(
      title: json['title'] ?? '',
      marqueeId: json['marqueeId'].toString() ?? '',
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'marqueeId': marqueeId,
    };
  }

  // Factory method to create a list of instances from a list of JSON objects
  static List<InfiniteMarqueeModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => InfiniteMarqueeModel.fromJson(json)).toList();
  }
}
