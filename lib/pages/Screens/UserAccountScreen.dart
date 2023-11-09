import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Screens/LoginScreen.dart';
import 'package:satietyfrontend/pages/Views/Widgets/CustomButton.dart';

class UserAccountScreen extends StatefulWidget {
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                // Replace 'banner.jpg' with your image asset
                child: Image.asset('images/banner.webp'),
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
          SizedBox(height: 20), // Adjust the height as needed
          Text(
            'Welcome to Satiety!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20), // Adjust the height as needed
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton(
                    text: "Login",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    })),
          ),
          // Flexible(
          //   child: Container(
          //     width: double.infinity,
          //     padding: EdgeInsets.symmetric(horizontal: 16.0),
          //     child: ElevatedButton(
          //       onPressed: () {},
          //       style: ButtonStyle(
          //         minimumSize:
          //             MaterialStateProperty.all(Size(double.infinity, 50)),
          //         backgroundColor: MaterialStateProperty.all(Colors.blue),
          //       ),
          //       child: Text(
          //         'Login',
          //         style: TextStyle(fontSize: 18, color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: 0), // Adjust the height as needed
          Container(
            padding: EdgeInsets.all(20.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'For more information please visit, ',
                    style: TextStyle(color: Colors.black, fontSize: 10.0),
                  ),
                  TextSpan(
                    text: 'Terms & conditions and Privacy Policy',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 10.0,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle the clickable text tap event here
                        print('Clickable text tapped');
                      },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Function to send the OTP to the provided phone number
  Future<void> verifyPhoneNumber(String phoneNumber) async {}
}
