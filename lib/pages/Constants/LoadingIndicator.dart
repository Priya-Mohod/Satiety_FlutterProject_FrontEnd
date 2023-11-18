import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';

class LoadingIndicator {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: true,
          child: Center(
            child: SpinKitPulsingGrid(
              color: ThemeColors.primaryColor,
              size: 100.0,
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
