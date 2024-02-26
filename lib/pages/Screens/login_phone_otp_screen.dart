import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Constants/LoadingIndicator.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:satietyfrontend/pages/Screens/GetUserLocationScreen.dart';
import 'package:satietyfrontend/pages/Screens/verify_phone_otp_screen.dart';
import 'package:satietyfrontend/pages/Views/Register.dart';
import 'package:satietyfrontend/pages/Views/Widgets/CustomButton.dart';

class LoginPhoneOTPScreen extends StatefulWidget {
  final bool showSkipButton;
  const LoginPhoneOTPScreen({super.key, required this.showSkipButton});

  @override
  State<LoginPhoneOTPScreen> createState() => _LoginPhoneOTPScreenState();
}

class _LoginPhoneOTPScreenState extends State<LoginPhoneOTPScreen> {
  final TextEditingController phoneNumberController = TextEditingController();

  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");
  bool _phoneNumberError = false;
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    phoneNumberController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneNumberController.text.length),
    );

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
                if (widget.showSkipButton)
                  Positioned(
                    top: 50, // Adjust the position of the back button
                    right: 10, // Adjust the position of the back button
                    child: SizedBox(
                      width: 80,
                      height: 30,
                      child: CustomButton(
                          text: "Skip",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GetUserLocationScreen()));
                          },
                          buttonFont: 12.0),
                    ),
                  ),
              ],
            ),
            const Text('Login',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            const Text(
              'Enter your phone number to get OTP',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              child: TextFormField(
                cursorColor: ThemeColors.primaryColor,
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                onChanged: (value) {
                  setState(() {
                    phoneNumberController.text = value;
                    _phoneNumberError = value.length != 10;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enter Phone Number",
                  errorText: (_phoneNumberError == false)
                      ? null
                      : "Enter valid number",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(14.5),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                            countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 500),
                            context: context,
                            onSelect: (value) {
                              setState(() {
                                selectedCountry = value;
                              });
                            });
                      },
                      child: Text(
                          "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  suffixIcon: phoneNumberController.text.length == 10
                      ? Container(
                          height: 25,
                          width: 25,
                          margin: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: const Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: Colors.white,
                              size: 25),
                        )
                      : null,
                ),
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
                      // *** Make server call to check if user already registered
                      // If not registered, show registration screen first
                      // If already registered, show verify OTP screen
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Register()));
                      if (phoneNumberController.text.length == 10) {
                        // Make server call to get otp for phone number
                        _phoneNumberError = false;
                        // ***
                        if (DevelopmentConfig.loginUsingDummyOTP) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyPhoneOTPScreen(
                                        mobileNumber:
                                            "+${selectedCountry.phoneCode} 9029413588",
                                        verifyOTP: "7783",
                                        isUserExist: false,
                                        jwtToken: "",
                                      )));
                        } else {
                          _getOTPandDisplayVerifyScreen(
                              phoneNumberController.text);
                        }
                      } else {
                        // show alert on screen to enter valid number
                        setState(() {
                          _phoneNumberError = true;
                        });
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _getOTPandDisplayVerifyScreen(String mobileNumber) async {
    LoadingIndicator.show(context);
    var response = await service.getOTPForMobileNumber(mobileNumber);
    LoadingIndicator.hide(context);
    if (response != null) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print("OTP received");
      print(data.keys.first);
      print(data.values.first);
      String otpReceived =
          data.containsKey("otp") ? data["otp"].toString() : "";
      bool isUserExist =
          data.containsKey("isExistingUser") ? data["isExistingUser"] : false;
      String jwtToken = data.containsKey("token") ? data["token"] : "";
      //String numberWithCode = "+${selectedCountry.phoneCode} $mobileNumber";
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyPhoneOTPScreen(
                  mobileNumber: mobileNumber,
                  verifyOTP: otpReceived,
                  isUserExist: isUserExist,
                  jwtToken: jwtToken)));
    } else {
      // Display alert of response is false
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Phone OTP'),
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
}
