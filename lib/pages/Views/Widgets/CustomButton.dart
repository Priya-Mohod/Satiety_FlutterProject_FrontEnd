import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double buttonFont;

  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.buttonFont});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
              MaterialStateProperty.all<Color>(ThemeColors.buttonColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0))),
        ),
        child: Text(text, style: TextStyle(fontSize: buttonFont)));
  }
}
