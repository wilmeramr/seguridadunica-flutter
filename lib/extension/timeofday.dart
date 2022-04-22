import 'package:flutter/material.dart';

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

extension DateTimeConverter on DateTime {
  String toESdate() {
    final day = this.day.toString().padLeft(2, "0");
    final month = this.month.toString().padLeft(2, "0");
    final year = this.year.toString().padLeft(2, "0");
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$day/$month/$year - $hour:$min";
  }

  String toESdateTime() {
    final day = this.day.toString().padLeft(2, "0");
    final month = this.month.toString().padLeft(2, "0");
    final year = this.year.toString().padLeft(2, "0");

    return "$day/$month/$year";
  }
}
