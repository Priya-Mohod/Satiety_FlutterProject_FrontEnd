import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Screens/VerifyOTPScreen.dart';
import 'package:satietyfrontend/pages/Views/Widgets/CustomButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  @override
  Widget build(BuildContext context) {
    phoneNumberController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneNumberController.text.length),
    );

    return Scaffold(
      body: Column(
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
          const Text('Login',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          const Text(
            'Enter your phone number to get OTP',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              cursorColor: ThemeColors.primaryColor,
              controller: phoneNumberController,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              onChanged: (value) {
                setState(() {
                  phoneNumberController.text = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Enter Phone Number",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(20.0),
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
                suffixIcon: phoneNumberController.text.length > 9
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                  text: 'Get OTP',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyOTPScreen()));
                  }),
            ),
          )
        ],
      ),
    );
  }
}
