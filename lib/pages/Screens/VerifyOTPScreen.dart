import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:satietyfrontend/pages/Screens/RootScreen.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';
import 'package:satietyfrontend/pages/Views/Widgets/CustomButton.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String mobileNumber;
  final String verifyOTP;
  final bool isUserExist;
  const VerifyOTPScreen(
      {super.key,
      required this.mobileNumber,
      required this.verifyOTP,
      required this.isUserExist});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  String otpCode = "";
  final int otpLength = 4;
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
            const Text('Verification',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            const Text(
              'Enter the received OTP on phone and email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Pinput(
                    length: otpLength,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ThemeColors.primaryColor),
                      ),
                      textStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    onSubmitted: (value) {
                      print(value);
                      setState(() {
                        // *** assign to otpCode = value
                        otpCode = value;
                      });
                    },
                    onChanged: (value) {
                      otpCode = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                        text: 'Verify',
                        buttonFont: 16.0,
                        onPressed: () {
                          print(otpCode);
                          if (otpCode.length == otpLength) {
                            verfiyOTP_and_RedirectUserToRegisterorHomeScreen(
                                context, otpCode);
                          } else {
                            SnackbarHelper.showSnackBar(
                                context, 'Enter complete code');
                          }
                        }),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Didn't receive any code?",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // *** Resend the code
                    },
                    child: const Text(
                      "Resend",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 6, 17, 17)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void verfiyOTP_and_RedirectUserToRegisterorHomeScreen(
      BuildContext context, String otpCode) {
    if (widget.verifyOTP == otpCode) {
      SnackbarHelper.showSnackBar(context, 'Phone number verified');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RootScreen()));
    } else {
      SnackbarHelper.showSnackBar(context, 'Please enter correct OTP');
    }
  }
}
