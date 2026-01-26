import 'package:flutter/material.dart';

Future<void> pickDate(
  BuildContext context,
  TextEditingController controller,
) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );
  if (picked != null) {
    String formattedDate =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    controller.text = formattedDate;
  }
}
