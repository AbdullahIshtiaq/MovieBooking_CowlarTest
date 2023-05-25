import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String convertDateFormat(String inputDate) {
  if (inputDate.isEmpty) {
    return 'N/A';
  }
  DateTime dateTime = DateFormat('yyyy-MM-dd').parse(inputDate);
  String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
  return formattedDate;
}

String nullCheck(String input) {
  if (input == null) {
    return '';
  }
  return input;
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ),
  );
}
