import 'package:flutter/material.dart';

class BannerDetailsPage extends StatefulWidget {
  final int index;
  const BannerDetailsPage({super.key, required this.index});

  @override
  State<BannerDetailsPage> createState() => _BannerDetailsPageState();
}

class _BannerDetailsPageState extends State<BannerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Banner Details"),),
      body: Center(child: Text(widget.index.toString()),
      ),
    );
  }
}