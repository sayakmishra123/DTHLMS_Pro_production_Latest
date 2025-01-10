import 'package:flutter/material.dart';

class ResultPageofStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Status'),
      ),
      body: Center(
        child: Text(
          'Result not published yet',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}