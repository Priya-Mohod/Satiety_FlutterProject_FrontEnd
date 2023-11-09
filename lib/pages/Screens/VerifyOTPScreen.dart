import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';
import 'package:satietyfrontend/pages/Views/Widgets/CustomButton.dart';

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({super.key});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  String? otpCode;
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
                      child: Image.asset('images/SatietyLogo.png'),
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
                    length: 6,
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
                      setState(() {
                        // *** assign to otpCode = value
                        otpCode = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                        text: 'Verify',
                        onPressed: () {
                          if (otpCode != null) {
                            verfiyOTP(context, otpCode!);
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

  void verfiyOTP(BuildContext context, String optCode) {}
}
