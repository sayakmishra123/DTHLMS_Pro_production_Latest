
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NoSim extends StatefulWidget {
  const NoSim({super.key});

  @override
  State<NoSim> createState() => _NoSimState();
}

class _NoSimState extends State<NoSim> {
  bool _dialogShown = false; // Prevent showing the dialog multiple times

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_dialogShown) {
        _showNoSimDialog(context);
        _dialogShown = true;
      }
    });
  }

  _showNoSimDialog(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.info,
      style: AlertStyle(
        isOverlayTapDismiss: false,
        animationType: AnimationType.fromTop,
        titleStyle: TextStyle(
          color: Colors.red, // Set custom color for the title
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(fontSize: 16), // Customize description text style
        isCloseButton: false, // Disable close button
      ),
      title: "SIM Card Not Detected",
      desc: "No SIM card is found in your device! Please insert a SIM card and try again!",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context); // Close the dialog instead of exiting the app
          },
          color: Color.fromRGBO(9, 89, 158, 1), // Set button color
          highlightColor: Color.fromRGBO(3, 77, 59, 1), // Set highlight color
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'No Simcard Found',
          style: FontFamily.styleb,
        ),
      ),
    );
  }
}
