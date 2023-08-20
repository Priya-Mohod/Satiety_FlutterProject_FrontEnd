import 'package:flutter/material.dart';

class ClickableLabel extends StatelessWidget {
  final String label;
  final Function onTap;
  final bool isEnabled;

  ClickableLabel(
      {required this.label, required this.onTap, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled
          ? () => onTap()
          : null, // Disable onTap when isEnabled is false
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: isEnabled
              ? Colors.blue
              : Colors.grey, // Change text color when enabled/disabled
        ),
      ),
    );
  }
}
