class DthloginUserDetails {
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = "";
  String token = "";
  String nameId = "";
  String password="";
  String loginTime="";
String image='';
String loginId='';
String imageDocumnetId='';
String username='';
String franchiseeId="";
  DthloginUserDetails({
    required this.email,
    required this.phoneNumber,
    required this.token,
    required this.firstName,
    required this.lastName,
    required this.nameId,
    required this.password,
    required this.loginTime,
    required this.image,
    required this.loginId,
    required this.imageDocumnetId,
    required this.username,
    required this.franchiseeId
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'token': token,
        'nameId': nameId,
        'password':password,
        'loginTime':loginTime,
        'image':image,
        'loginId':loginId,
        'imageDocumnetId':imageDocumnetId,
        'userName':username,
        'franchiseeId':franchiseeId
      };
}


