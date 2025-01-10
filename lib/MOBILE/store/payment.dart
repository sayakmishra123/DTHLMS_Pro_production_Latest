import 'dart:convert';
import 'package:dthlms/MOBILE/store/billing.dart';
import 'package:dthlms/MOBILE/utt_payment/atom_pay_helper.dart';
import 'package:dthlms/MOBILE/utt_payment/web_view_container.dart';

import 'package:flutter/material.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentDetailsPage extends StatefulWidget {
  String phController = "";
  String nameController = "";
  String emailController = "";
  String addressController = "";
  String cityController = "";
  String stateController = "";
  String pinCodeController = "";
  String selectedCountry = "";
  String recipient = "";
  String landmark = '';
  PaymentDetailsPage(
      {required this.nameController,
      required this.emailController,
      required this.addressController,
      required this.cityController,
      required this.stateController,
      required this.pinCodeController,
      required this.phController,
      required this.selectedCountry,
      required this.recipient,
      required this.landmark});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  late SharedPreferences sp;
  String name = '';
  String emailid = '';
  String ph = '';

  @override
  void initState() {
    super.initState();
    userdetailsget();
  }

  userdetailsget() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      sp.setString('name', widget.nameController);
      sp.setString('email', widget.emailController);
      sp.setString('ph', widget.phController);
      sp.setString('address', widget.addressController);
      sp.setString('city', widget.cityController);
      sp.setString('state', widget.stateController);
      sp.setString('pincode', widget.pinCodeController);
      sp.setString('country', widget.selectedCountry);
      sp.setString('recipent', widget.recipient);
      sp.setString('landmark', widget.landmark);
      sp.setString('recipient', widget.recipient);
    });
  }

  final coupon = TextEditingController();
  Future<void> applyCoupon() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Promo code /coupon',
            textScaler: TextScaler.linear(0.9),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: coupon,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 248, 248, 248),
                    hintText: "Enter coupon code",
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter coupon code';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 8), // Add some space between the field and button
              MaterialButton(
                minWidth: 25,
                height: 51,
                color: const Color.fromARGB(255, 248, 50, 116),
                onPressed: () {
                  String couponCode = coupon.text;
                  if (couponCode.isNotEmpty) {
                    isPromoApplied = true;
                    setState(() {});
                    // Handle coupon code logic here
                    print('Coupon code applied: $couponCode');
                    Navigator.of(context).pop(); // Close the dialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a coupon code.')),
                    );
                  }
                },
                child: Text(
                  'Apply',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop(); // Close the dialog
          //     },
          //     child: Text('Cancel'),
          //   ),
          // ],
        );
      },
    );
  }

  bool isPromoApplied = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment Details', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Back action
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // User Details Card
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Billing Address details',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorPage.colorbutton,
                                    fontSize: 15),
                              ),
                              MaterialButton(
                                minWidth: 25,
                                height: 25,
                                color: const Color.fromARGB(255, 252, 58, 44),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BillingDetailsPage()));
                                },
                                child: Text(
                                  'Change',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Name: ${widget.nameController}',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            'Email: ${widget.emailController}',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            'Phone: ${widget.phController}',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            'Recipient Name: ${widget.recipient}',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            'Country: ${widget.selectedCountry}',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            'Address: ${widget.addressController}',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            'City: ${widget.cityController}',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            'State: ${widget.stateController}',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            'Pin Code: ${widget.pinCodeController}',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            'Landmark: ${widget.landmark}',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Payable Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payable Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹4000.0',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Coupon',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        applyCoupon();
                      },
                      child: Text(
                        'Apply coupon',
                        style: TextStyle(
                          color: ColorPage.color1,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                if (isPromoApplied)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 213, 225), // Light pink background
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade300, // Border color
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_offer_rounded,
                          color: Colors.green,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'FRENZY30',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isPromoApplied = false; // Remove promo on tap
                            });
                          },
                          child: Text(
                            'Remove',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 248, 109, 155),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isPromoApplied)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      'Promo code added',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                // Spacer to push the payment button to the bottom
                SizedBox(height: 20),
                // Proceed to Payment Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _initNdpsPayment(
                          context, responseHashKey, responseDecryptionKey);
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                    },
                    child: Text(
                      'Proceed to payment',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPage.colorbutton,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // merchant configuration data
  final String login = "445842"; //mandatory
  final String password = 'Test@123'; //mandatory
  final String prodid = 'NSE'; //mandatory
  final String requestHashKey = 'KEY123657234'; //mandatory
  final String responseHashKey = 'KEYRESP123657234'; //mandatory
  final String requestEncryptionKey =
      'A4476C2062FFA58980DC8F79EB6A799E'; //mandatory
  final String responseDecryptionKey =
      '75AEF0FA1B94B3C10D4F5B268F757F11'; //mandatory
  final String txnid =
      'test240224'; // mandatory // this should be unique each time
  final String clientcode = "Sayak Mishra"; //mandatory
  final String txncurr = "INR"; //mandatory
  final String mccCode = "5499"; //mandatory
  final String merchType = "R"; //mandatory
  final String amount = "1.00"; //mandatory

  final String mode = "uat"; // change live for production

  final String custFirstName = 'test'; //optional
  final String custLastName = 'user'; //optional
  final String mobile = '9749088472'; //optional
  final String email = 'sayak.solution24@gmail.com'; //optional
  final String address = 'mumbai'; //optional
  final String custacc = '639827'; //optional
  final String udf1 = "udf1"; //optional
  final String udf2 = "udf2"; //optional
  final String udf3 = "udf3"; //optional
  final String udf4 = "udf4"; //optional
  final String udf5 = "udf5"; //optional

  final String authApiUrl = "https://caller.atomtech.in/ots/aipay/auth"; // uat

  // final String auth_API_url =
  //     "https://payment1.atomtech.in/ots/aipay/auth"; // prod

  final String returnUrl =
      "https://pgtest.atomtech.in/mobilesdk/param"; //return url uat
  // final String returnUrl =
  //     "https://payment.atomtech.in/mobilesdk/param"; ////return url production

  final String payDetails = '';

  void _initNdpsPayment(BuildContext context, String responseHashKey,
      String responseDecryptionKey) {
    _getEncryptedPayUrl(context, responseHashKey, responseDecryptionKey);
  }

  _getEncryptedPayUrl(context, responseHashKey, responseDecryptionKey) async {
    String reqJsonData = _getJsonPayloadData();
    debugPrint(reqJsonData);
    const platform = MethodChannel('flutter.dev/NDPSAESLibrary');
    try {
      final String result = await platform.invokeMethod('NDPSAESInit', {
        'AES_Method': 'encrypt',
        'text': reqJsonData, // plain text for encryption
        'encKey': requestEncryptionKey // encryption key
      });
      String authEncryptedString = result.toString();
      // here is result.toString() parameter you will receive encrypted string
      // debugPrint("generated encrypted string: '$authEncryptedString'");
      _getAtomTokenId(context, authEncryptedString);
    } on PlatformException catch (e) {
      debugPrint("Failed to get encryption string: '${e.message}'.");
    }
  }

  _getAtomTokenId(context, authEncryptedString) async {
    var request = http.Request(
        'POST', Uri.parse("https://caller.atomtech.in/ots/aipay/auth"));
    request.bodyFields = {'encData': authEncryptedString, 'merchId': login};

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var authApiResponse = await response.stream.bytesToString();
      final split = authApiResponse.trim().split('&');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };
      final splitTwo = values[1]!.split('=');
      if (splitTwo[0] == 'encData') {
        const platform = MethodChannel('flutter.dev/NDPSAESLibrary');
        try {
          final String result = await platform.invokeMethod('NDPSAESInit', {
            'AES_Method': 'decrypt',
            'text': splitTwo[1].toString(),
            'encKey': responseDecryptionKey
          });
          debugPrint(result.toString()); // to read full response
          var respJsonStr = result.toString();
          Map<String, dynamic> jsonInput = jsonDecode(respJsonStr);
          if (jsonInput["responseDetails"]["txnStatusCode"] == 'OTS0000') {
            final atomTokenId = jsonInput["atomTokenId"].toString();
            debugPrint("atomTokenId: $atomTokenId");
            final String payDetails =
                '{"atomTokenId" : "$atomTokenId","merchId": "$login","emailId": "$email","mobileNumber":"$mobile", "returnUrl":"$returnUrl"}';
            _openNdpsPG(
                payDetails, context, responseHashKey, responseDecryptionKey);
          } else {
            debugPrint("Problem in auth API response");
          }
        } on PlatformException catch (e) {
          debugPrint("Failed to decrypt: '${e.message}'.");
        }
      }
    }
  }

  _openNdpsPG(payDetails, context, responseHashKey, responseDecryptionKey) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => WebViewContainer( 
    //             mode, payDetails, responseHashKey, responseDecryptionKey)));
  }

  _getJsonPayloadData() {
    var payDetails = {};
    payDetails['login'] = login;
    payDetails['password'] = password;
    payDetails['prodid'] = prodid;
    payDetails['custFirstName'] = custFirstName;
    payDetails['custLastName'] = custLastName;
    payDetails['amount'] = amount;
    payDetails['mobile'] = mobile;
    payDetails['address'] = address;
    payDetails['email'] = email;
    payDetails['txnid'] = txnid;
    payDetails['custacc'] = custacc;
    payDetails['requestHashKey'] = requestHashKey;
    payDetails['responseHashKey'] = responseHashKey;
    payDetails['requestencryptionKey'] = requestEncryptionKey;
    payDetails['responseencypritonKey'] = responseDecryptionKey;
    payDetails['clientcode'] = clientcode;
    payDetails['txncurr'] = txncurr;
    payDetails['mccCode'] = mccCode;
    payDetails['merchType'] = merchType;
    payDetails['returnUrl'] = returnUrl;
    payDetails['mode'] = mode;
    payDetails['udf1'] = udf1;
    payDetails['udf2'] = udf2;
    payDetails['udf3'] = udf3;
    payDetails['udf4'] = udf4;
    payDetails['udf5'] = udf5;
    String jsonPayLoadData = getRequestJsonData(payDetails);
    return jsonPayLoadData;
  }
}
