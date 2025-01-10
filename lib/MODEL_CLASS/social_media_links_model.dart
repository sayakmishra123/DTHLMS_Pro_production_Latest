class SocialMediaIconModel {
  final String servicesTypeName;
  final String icon;
  final String link;

  SocialMediaIconModel({
    required this.servicesTypeName,
    required this.icon,
    required this.link,
  });

  // Factory method to create an instance from a JSON object
  factory SocialMediaIconModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaIconModel(
      servicesTypeName: json['ServicesTypeName'] ?? '', // Ensure key matches API response
      icon: json['icon'] ?? '',
      link: json['Link'] ?? '',
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'ServicesTypeName': servicesTypeName,
      'icon': icon,
      'Link': link,
    };
  }

  // Factory method to create a list of instances from a list of JSON objects
  static List<SocialMediaIconModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SocialMediaIconModel.fromJson(json)).toList();
  }
}
