// ignore_for_file: file_names

class UserDetails {
  UserDetails({
    required this.name,
    required this.userid,
  });
  late final String name;
  late final String userid;
  late final String role;

  UserDetails.fromJson(Map<String, dynamic> json) {
    name = json['userName'];
    userid = json['userId'];
    role = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userName'] = name;
    _data['userId'] = userid;
    _data['Type'] = role;
    return _data;
  }
}
