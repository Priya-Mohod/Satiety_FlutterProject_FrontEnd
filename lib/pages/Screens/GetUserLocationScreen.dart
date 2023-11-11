import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Views/Widgets/CustomButton.dart';

class GetUserLocationScreen extends StatefulWidget {
  const GetUserLocationScreen({super.key});

  @override
  State<GetUserLocationScreen> createState() => _GetUserLocationScreenState();
}

class _GetUserLocationScreenState extends State<GetUserLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/locationPin.jpg',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.5,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 30),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                  text: 'Get Current Location',
                  buttonFont: 18.0,
                  onPressed: () {}),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              // Navigate to another screen when the text is clicked
              //Navigator.push(context,
              //    MaterialPageRoute(builder: (context) => YourNextScreen()));
            },
            child: Text(
              'Enter location Manually',
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.blue, // You can choose the color you want
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
