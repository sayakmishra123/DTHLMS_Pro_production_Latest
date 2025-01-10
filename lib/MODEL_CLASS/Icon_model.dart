class IconModel {
  final String logo;

  IconModel({
    required this.logo,

  });

  // Factory method to create an instance from a JSON object
  factory IconModel.fromJson(Map<String, dynamic> json) {
    return IconModel(
      logo: json['logo'] ?? '',

    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'logo': logo,

    };
  }

  // Factory method to create a list of instances from a list of JSON objects
  static List<IconModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => IconModel.fromJson(json)).toList();
  }
}
