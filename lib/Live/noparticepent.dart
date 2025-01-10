import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoParticipantsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor:Colors.black,

      navigationBar: CupertinoNavigationBar(
        middle: Text('Participants'),
                   // backgroundColor: const Color.fromARGB(255, 44, 44, 44),

      ),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'No Participant',
                  style: TextStyle(color: Colors.grey[200]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
