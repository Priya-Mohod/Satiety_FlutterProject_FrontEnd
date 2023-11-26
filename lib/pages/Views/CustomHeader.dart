import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Constants/LocationManager.dart';
import 'package:satietyfrontend/pages/Models/UserModel.dart';
import 'package:satietyfrontend/pages/Screens/AddressSelectionScreen.dart';
import 'package:satietyfrontend/pages/Screens/LoginScreen.dart';
import 'package:satietyfrontend/pages/Screens/UserAccountScreen.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';

class CustomHeader extends StatefulWidget {
  @override
  _CustomHeaderState createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeColors.primaryColor,
      elevation: 0,
      title: Row(
        children: [
          IconButton(
            icon: Icon(CupertinoIcons.location_fill, color: Colors.orange),
            onPressed: () {
              // Add functionality for location icon here
              _showAddresScreen();
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                print("Address tapped!");
                _showAddresScreen();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "Address 1 asfkjahdkjhakjdhkahsd",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                  Text(
                    '123, Main Street, City, State',
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // IconButton(
          //   icon: Icon(CupertinoIcons.location_fill, color: Colors.orange),
          //   // icon: Icon(
          //   //   CupertinoIcons.person_crop_circle_fill,
          //   //   color: Colors.white,
          //   // ),
          //   onPressed: () {
          //     // Add functionality for user account icon here
          //     _showAccountScreen();
          //   },
          // ),
        ],
      ),
    );
  }

  void _showAccountScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserAccountScreen()));
  }

  void _showAddresScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddressSelectionScreen()));
  }
}

class LocationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CupertinoIcons.location_fill, color: Colors.orange),
      onPressed: () {
        // Add functionality for location icon here
        //_showAddresScreen();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddressSelectionScreen()));
      },
    );
  }
}

class AddressInfo extends StatefulWidget {
  const AddressInfo({super.key});
  @override
  State<AddressInfo> createState() => _AddressInfoState();
}

class _AddressInfoState extends State<AddressInfo> {
  String addressHeading = "";
  String addressSubHeading = "sub heading";

  @override
  void initState() {
    // TODO: implement initState
    print("Custom Header - Init State");
    super.initState();
    loadAddress();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Address tapped!");
        // _showAddresScreen();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddressSelectionScreen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  addressHeading,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ],
          ),
          Text(
            addressSubHeading,
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<void> loadAddress() async {
    // Retrieve the stored location from system preferences
    var storedLocation =
        await UserStorageService.retrieveLocationFromPreferences();

    print("coordinates stored in defaults - $storedLocation");
    if (storedLocation != null) {
      // Get the address using the retrieved location
      String locationAddress = await LocationManager.getAddressFromCoordinates(
        storedLocation.latitude,
        storedLocation.longitude,
      );
      print("Address Fetched using coordinates - $locationAddress");

      setState(() {
        // Update the address in the state
        addressSubHeading = locationAddress;
        // Split the address string using comma as a separator
        List<String> addressComponents = addressSubHeading.split(', ');
        print("Address in header $addressComponents");
        // Extract header and subheader
        addressSubHeading = addressComponents.skip(2).join(', ');
        addressHeading = addressComponents.take(2).join(', ');
        print("heading $addressHeading");
        print("Subheading $addressSubHeading");
      });
    } else {
      setState(() {
        // Handle the case where there is no stored location
        addressHeading = "No location stored";
      });
    }
  }
}

class AccountIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        CupertinoIcons.person_crop_circle_fill,
        color: Colors.white,
      ),
      onPressed: () async {
        bool isUserLoggedIn = await UserStorageService.isUserLoggedIn();
        // Add functionality for user account icon here
        // *** display user account information if logged in else show window to Login
        if (!isUserLoggedIn) {
          // display login
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(
                  showSkipButton: false,
                ),
              ));
        } else {
          // display account info screen
        }
      },
    );
  }
}
