class UtcTime {
  String utctime() {
    DateTime formattedDate = DateTime.now().toUtc();

    return formattedDate.toString();
  }
}
