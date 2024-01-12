import 'package:flutter/material.dart';
import 'number_picker.dart';

class NumberPickerDialog {
  static Future<int?> integer({
    required BuildContext context,
    required int initialIntegerValue,
    required int minValue,
    required int maxValue,
  }) async {
    return await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick a number'),
        content: NumberPicker(
          value: initialIntegerValue,
          minValue: minValue,
          maxValue: maxValue,
          onChanged: (value) {
            // Handle onChanged if needed
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(initialIntegerValue);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
