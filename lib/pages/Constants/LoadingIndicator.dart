import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';

class LoadingIndicator {
  static final GlobalKey<State> globalKey = GlobalKey<State>();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: SpinKitPulsingGrid(
              //waveColor: ThemeColors.primaryColor,
              color: ThemeColors.primaryColor,
              size: 100.0,
            ),
          ),
        );
      },
    );
  }

  static void hide() {
    if (globalKey.currentContext != null) {
      Navigator.of(globalKey.currentContext!).pop();
    }
  }
}
