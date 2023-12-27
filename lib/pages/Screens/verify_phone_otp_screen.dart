import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:satietyfrontend/pages/Screens/RootScreen.dart';
import 'package:satietyfrontend/pages/Screens/register_email_otp_screen.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';
import 'package:satietyfrontend/pages/Views/Register.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';
import 'package:satietyfrontend/pages/Views/Widgets/CustomButton.dart';

class VerifyPhoneOTPScreen extends StatefulWidget {
  final String mobileNumber;
  String verifyOTP;
  final bool isUserExist;
  final String jwtToken;
  VerifyPhoneOTPScreen(
      {super.key,
      required this.mobileNumber,
      required this.verifyOTP,
      required this.isUserExist,
      required this.jwtToken});

  @override
  State<VerifyPhoneOTPScreen> createState() => _VerifyPhoneOTPScreen();
}

class _VerifyPhoneOTPScreen extends State<VerifyPhoneOTPScreen> {
  String otpCode = "";
  final int otpLength = 4;
  Service service = Service();
  bool isButtonDisabled = false;
  int countdown = 30;
  String mobileNum = "";

  @override
  Widget build(BuildContext context) {
    mobileNum = widget.mobileNumber;
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  const Text('Verification',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(
                    "Enter the received OTP on phone ${widget.mobileNumber}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 10),
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
                    onTap: isButtonDisabled
                        ? null
                        : () async {
                            bool otpSent =
                                await _resendOTP(widget.mobileNumber);
                            if (otpSent) {
                              SnackbarHelper.showSnackBar(
                                  context, 'OTP Re-sent Successfully');
                            } else {
                              SnackbarHelper.showSnackBar(
                                  context, 'Error in resending the OTP');
                            }
                          },
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isButtonDisabled
                              ? Colors.grey
                              : Color.fromARGB(255, 6, 17, 17)),
                    ),
                  ),
                  SizedBox(height: 10),
                  isButtonDisabled
                      ? Text('Button disabled for $countdown seconds')
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void verfiyOTP_and_RedirectUserToRegisterorHomeScreen(
      BuildContext context, String otpCode) async {
    if (widget.verifyOTP == otpCode) {
      if (widget.isUserExist == true) {
        // Save user token
        await UserStorageService.saveUserJwtToken(widget.jwtToken);
        SnackbarHelper.showSnackBar(context, 'Welcome back!');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RootScreen()));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterEmailOTPScreen(
                      mobileNumber: widget.mobileNumber,
                    )));
      }
    } else {
      SnackbarHelper.showSnackBar(context, 'Please enter correct OTP');
    }
  }

  Future<bool> _resendOTP(String mobileNumber) async {
    if (DevelopementConfig.loginUsingDummyOTP == true) {
      setState(() {
        isButtonDisabled = true;
        countdown = 30;
      });
      // Start the countdown timer
      startTimer();
      return true;
    } else {
      var response = await service.getOTPForMobileNumber(mobileNumber);
      if (response != null) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("OTP received");
        print(data.keys.first);
        print(data.values.first);
        String otpReceived = data.keys.first;
        bool isUserExist = data.values.first;
        widget.verifyOTP = otpReceived;
        setState(() {
          isButtonDisabled = true;
          countdown = 30;
        });
        // Start the countdown timer
        startTimer();
        return true;
      } else {
        // Display alert of response is false
        return false;
      }
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (countdown == 0) {
        setState(() {
          isButtonDisabled = false;
          timer.cancel();
        });
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }
}
