// create staful widget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:satietyfrontend/pages/TextConstants.dart';
import 'package:satietyfrontend/pages/Views/ListView.dart';

import 'SnackbarHelper.dart';

class ValidateOTP extends StatefulWidget {
  String userEmail;
  ValidateOTP({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ValidateOTPState createState() => _ValidateOTPState();
}

// create state class
class _ValidateOTPState extends State<ValidateOTP> {
  Service service = Service();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController otpController = TextEditingController();
  int _otpCodeLength = 6;

  @override
  Widget build(BuildContext context) {
    // Access userEmail from widget instance
    String userEmail = widget.userEmail;
    return Scaffold(
      appBar: AppBar(
        title: Text(TextConstants.otp_validation_screen_title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: _otpCodeLength,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0), // Set font size for the OTP
                decoration: InputDecoration(
                  hintText: TextConstants.otp_validation_enter_otp,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Check if the entered OTP is valid (e.g., make a server call)
                  String otp = otpController.text;
                  if (otp.length == _otpCodeLength) {
                    // Perform the action for a valid OTP (e.g., verify with server)
                    bool result = await service.verifyUserOTP(
                        userEmail, int.parse(otp)) as bool;

                    String messageUser = result
                        ? 'Welcome to satiety family!'
                        : TextConstants.otp_validation_error_message;
                    SnackbarHelper.showSnackBar(context, messageUser);
                    // show listView page
                    if (result == true) {
                      _navigateToLoginScreen();
                    }
                  } else {
                    // Show an error message for an invalid OTP
                    // show toast message or snackbar
                    SnackBar(
                      content:
                          Text(TextConstants.otp_validation_invalid_otp_error),
                    );
                  }
                },
                child: Text(TextConstants.otp_validation_submit_button),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToLoginScreen() async {
    await Future.delayed(Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ListViewPage(),
      ),
    );
  }
}
