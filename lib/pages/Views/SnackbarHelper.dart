import 'package:flutter/material.dart';

class SnackbarHelper {
  SnackbarHelper(String internet_error);

  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
