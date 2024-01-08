import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Constants/LoadingIndicator.dart';
import 'package:satietyfrontend/pages/Constants/StringConstants.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:satietyfrontend/pages/Screens/verify_email_otp_screen.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';
import 'package:satietyfrontend/pages/Views/Widgets/CustomButton.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';

class RegisterEmailOTPScreen extends StatefulWidget {
  final String mobileNumber;

  const RegisterEmailOTPScreen({super.key, required this.mobileNumber});

  @override
  State<RegisterEmailOTPScreen> createState() => _RegisterEmailOTPScreen();
}

class _RegisterEmailOTPScreen extends State<RegisterEmailOTPScreen> {
  final TextEditingController emailController = TextEditingController();
  GlobalKey<FormFieldState<String>> _emailField =
      GlobalKey<FormFieldState<String>>();
  Service service = Service();
  bool isEmailExists = false; // Email Validation
  bool isEmailValid = true; // Email Validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 50, horizontal: 0),
                    child: Container(
                      width: 200,
                      height: 200,
                      // padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeColors.primaryColor),
                      // Replace 'banner.jpg' with your image asset
                      child: Image.asset('assets/SatietyLogo.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: 40, // Adjust the position of the back button
                  left: 10, // Adjust the position of the back button
                  child: IconButton(
                    icon: Icon(CupertinoIcons.back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const Text('Register with Email',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            const Text(
              'Enter your Email to get OTP',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 16),
                key: _emailField,
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(
                    CupertinoIcons.mail,
                    size: 30,
                  ),
                  errorText: isEmailValid
                      ? null
                      : StringConstants.register_email_invalid,
                  errorStyle: TextStyle(color: Colors.red),
                ),
                validator: (value) {
                  if (isEmailExists) {
                    return StringConstants.register_email_exists_message;
                  }

                  bool emailValidator =
                      RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value!);
                  if (value.isEmpty) {
                    return StringConstants.register_email_empty;
                  } else if (!emailValidator) {
                    return StringConstants.register_enter_valid_email;
                  }
                },
                onChanged: (value) => {
                  isEmailExists = false,
                  setState(() {
                    _emailField.currentState!.validate();
                  })
                },
                onEditingComplete: () async {
                  if (await _isEmailExists(emailController.text)) {
                    isEmailExists = true;
                    setState(() {
                      _emailField.currentState!.validate();
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                    text: 'Get OTP',
                    buttonFont: 16.0,
                    onPressed: () {
                      // -- server call to get OTP for for mentioned email --
                      _getEmailOTPandDisplayVerifyScreen(emailController.text);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getEmailOTPandDisplayVerifyScreen(String email) async {
    LoadingIndicator.show(context);
    var response = await service.getOTPForEmail(
      emailController.text, // email
    );
    LoadingIndicator.hide(context);
    // show alert dialog on condition
    if (response != null &&
        response.statusCode == Service.SERVICE_RESPONSE_OK) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      String otpReceived = data["emailOtp"];
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Email Registration',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          content: const Text('OTP sent successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyEmailOTPScreen(
                        userEmail: emailController.text,
                        verifyEmailOTP: otpReceived,
                        mobileNumber: widget.mobileNumber,
                      ),
                    ));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (response != null &&
        response.statusCode == Service.SERVICE_RESPONSE_DUPLICATE) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Register Email'),
          content: const Text(
              'This email is already in use, please choose different one.'),
          actions: [
            TextButton(
              onPressed: () {
                // hide the alert dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Register Email'),
          content: const Text('There was an error, please try again!'),
          actions: [
            TextButton(
              onPressed: () {
                // hide the alert dialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> _isEmailExists(String email) async {
    var response = await service.fetchUserDataUsingEmail(email);
    if (response != null && response.statusCode == 200) {
      return true;
    } else if (response != null && response.statusCode != 200) {
      return false;
    } else {
      // ignore: use_build_context_synchronously
      SnackbarHelper.showSnackBar(context, StringConstants.exception_error);
      return false;
    }
  }
}
