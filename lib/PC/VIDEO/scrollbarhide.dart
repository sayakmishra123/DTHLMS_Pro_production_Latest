import 'package:flutter/cupertino.dart';

class HideScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // No scrollbar is built
  }
}