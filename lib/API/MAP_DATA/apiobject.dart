import 'package:dthlms/utctime.dart';

class ClsMap {
  Map objLoginApi(
    String loginemail,
    String password,
    String otp,
  ) {
    return {
      'userName': loginemail,
      'password': password,
      // 'franchiseId': 1,
    };
  }

  Map objSignupApi(
    String signupuser,
    String signupfirstname,
    String signuplastname,
    signupemail,
    signuppassword,
    signupphno,
    whatsappnumber,
    key,
    emailotp,
    String phoneNumberCode,
    String appName,
    String activationkey,
    String phonenumbercountryid,
    String whatsappnumbercountryid,
    String whatsappnumbercode,
  ) {
    return {
      'userName': signupuser,
      'firstName': signupfirstname,
      'lastName': signuplastname,
      'email': signupemail,
      'password': signuppassword,
      'phoneNumber': signupphno,
      "whatsAppNumber": whatsappnumber,
      'emailCode': emailotp,
      'phoneNumberCode': phoneNumberCode,
      'activationKey': activationkey,
      "phoneNumberCountryId": 1,
      "whatsAppNumberCountryId": 1,
      "whatsAppNumberCode": whatsappnumbercode
    };
  }

  Map objChangeProfileDetails(String signupuser, String signupfirstname,
      String signuplastname, signupemail, signupphno, profileImageDocumentId) {
    return {
      'firstName': signupfirstname,
      'lastName': signuplastname,
      'userName': signupuser,
      'email': signupemail,
      'emailCode': null,
      'phoneNumber': signupphno,
      'phoneNumberCode': null,
      'profileImageDocumentId': profileImageDocumentId,
    };
  }

  // Map objSignupconfirmation(
  //   String signupphno,
  //   String signupemail,
  // ) {
  //   // return {
  //   //   "phoneNumber": signupphno,
  //   //   "email": signupemail,
  //   //   "franchiseId": 1,
  //   //   'captchaId': null,
  //   //   'userEnteredCaptchaCode': 'abcd'
  //   // };
  //   // return {
  //   //   'phoneNumberCountryId': 1,
  //   //   "phoneNumber": signupphno,
  //   //   "email": signupemail,
  //   //   "captchaId": null,
  //   //   "userEnteredCaptchaCode": "abcd"
  //   // };
  //   return {
  //     "phoneNumberCountryId": 1,
  //     "phoneNumber": signupphno,
  //     "email": signupemail,
  //     "captchaId": "4d6246b0-c824-4fbe-b735-b9121f173df6",
  //     "userEnteredCaptchaCode": "9JXtyal"
  //   };
  // }
    Map objForgetPasswordValidEmail(String email) {
    return {
     
      "UserName": email
     
    };
  }

  Map objForgetPasswordGanarete(int phoneCountryId, String phoneNumber,
      String email, int whatsappCountryId, String whatsappNumber) {
    return {
      "phoneNumberCountryId": phoneCountryId,
      "phoneNumber": phoneNumber,
      "email": email,
      "whatsAppNumberCountryId": whatsappCountryId,
      "whatsAppNumber": whatsappNumber,
      "captchaId": "4d6246b0-c824-4fbe-b735-b9121f173df6",
      "userEnteredCaptchaCode": "9JXtyal"
    };
  }

  Map objforgetPassword(String signupemail, String code) {
    return {"user": signupemail, "code": code};
  }

  Map objresetPassword(
      String signupemail, String ph, String pass, String confirmpass) {
    return {
      "email": signupemail,
      "phoneNumber": ph,
      "password": pass,
      "confirmPassword": confirmpass
    };
  }

  Map objStudentWatchTime(videoId, watchtime, studentid) {
    return {
      'videoid': videoId,
      'watchtime': watchtime,
      'studentId': studentid,
      'date': UtcTime().utctime()
    };
  }

  Map objStudentVideoReview(videoid, optionid) {
    return {'videoid': videoid, 'optionid': optionid};
  }

  Map objgenerateSRCode(
    String phoneNumberCountryId,
    String phoneNumber,
    String email,
    String activationKey,
  ) {
    return {
      "phoneNumberCountryId": '1',
      "phoneNumber": phoneNumber,
      "email": email,
      "activationkey": activationKey,




      
     
    };
  }
}
