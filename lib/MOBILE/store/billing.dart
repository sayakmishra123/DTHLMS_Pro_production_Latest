import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/MOBILE/store/payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../THEME_DATA/color/color.dart';
import '../../THEME_DATA/font/font_family.dart';

class BillingDetailsPage extends StatefulWidget {
  @override
  _BillingDetailsPageState createState() => _BillingDetailsPageState();
}

class _BillingDetailsPageState extends State<BillingDetailsPage> {
  // Controllers for each input field
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _phController = TextEditingController();
  final _recipentname = TextEditingController();
  final landmark = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // GlobalKey for the form

  @override
  void dispose() {
    // Dispose of controllers when no longer needed to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  late SharedPreferences sp;
  Getx getx = Get.put(Getx());
  @override
  void initState() {
    _nameController.text =
        getx.loginuserdata[0].firstName + " " + getx.loginuserdata[0].lastName;
    _emailController.text = getx.loginuserdata[0].email;
    _phController.text = getx.loginuserdata[0].phoneNumber;
    userdetailsget();

    // TODO: implement initState
    super.initState();
  }

  userdetailsget() async {
    sp = await SharedPreferences.getInstance();

    setState(() {
      // sp.getString('name');
      // sp.getString('email');
      // sp.getString('ph');
      _addressController.text = sp.getString('address') ?? '';
      _cityController.text = sp.getString('city') ?? '';
      _stateController.text = sp.getString('state') ?? '';
      _pinCodeController.text = sp.getString('pincode') ?? '';
      selectedCountry = sp.getString('country') ?? 'India';
      _recipentname.text = sp.getString('recipient') ?? '';
      landmark.text = sp.getString('landmark') ?? '';
    });
  }

  String? selectedCountry;
  final List<String> countries = ['India', "Other's"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery  details', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Associate form with formKey
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Your Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Your Name ",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Email*",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _recipentname,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Recipient Name ",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter recipient  name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Mobile
              IntlPhoneField(
                controller: _phController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                initialCountryCode: 'IN',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                disableLengthCheck: true,
                style: FontFamily.font6.copyWith(fontSize: 14),
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
                validator: (value) {
                  if (value!.number.length != 10) {
                    return 'Mobile number must be exactly 10 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Center(
                  // Center the DropdownButton
                  child: DropdownButton<String>(
                    value: selectedCountry,
                    hint: Text('Select a country'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCountry = newValue!;
                      });
                    },
                    items: countries
                        .map<DropdownMenuItem<String>>((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(
                          country,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    icon: Icon(Icons.arrow_drop_down),
                    iconEnabledColor: Colors.orange,
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "State*",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your state';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "City / Town / Village*",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _pinCodeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Pin Code*",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pin code';
                  } else if (value.length != 6) {
                    return 'Pin code must be exactly 6 digits';
                  }
                  return null;
                },
                style: GoogleFonts.inter(),
              ),
              SizedBox(height: 16),

              // Address
              TextFormField(
                maxLines: 2,
                controller: _addressController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Address*",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: landmark,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Landmark*",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),

              // SizedBox(height: 0),
              SizedBox(height: 10),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Proceed to the next page if form is valid
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentDetailsPage(
                              nameController: _nameController.text,
                              addressController: _addressController.text,
                              cityController: _cityController.text,
                              emailController: _emailController.text,
                              phController: _phController.text,
                              pinCodeController: _pinCodeController.text,
                              stateController: _stateController.text,
                              selectedCountry: selectedCountry.toString(),
                              recipient: _recipentname.text,
                              landmark: landmark.text),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPage.colorbutton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
