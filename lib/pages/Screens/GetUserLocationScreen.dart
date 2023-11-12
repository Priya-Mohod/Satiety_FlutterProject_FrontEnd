import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Screens/AddressSelectionScreen.dart';
import 'package:satietyfrontend/pages/Screens/RootScreen.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';
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
      appBar: AppBar(
        backgroundColor: ThemeColors.primaryColor,
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(CupertinoIcons.arrow_left)),
        title: Text(
          "What's your location?",
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/locationPin.png',
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
                  onPressed: () {
                    // Check if location is on
                    // _checkAndShowLocationSheet();
                    // ***
                    getLocation();
                  }),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              // Navigate to another screen when the text is clicked
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddressSelectionScreen()));
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

  Future<void> getLocation() async {
    bool locationEnabled = await isLocationEnabled();

    if (!locationEnabled) {
      showLocationServiceAlertDialog(context);
      return;
    }

    _checkAndShowLocationSheet();

    Location location = Location();
    try {
      LocationData currentLocation = await location.getLocation();
      print('Latitude: ${currentLocation.latitude}');
      print('Longitude: ${currentLocation.longitude}');

      // Get location permission
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<bool> isLocationEnabled() async {
    Location location = Location();

    bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    return _serviceEnabled;
  }

  void showLocationServiceAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Service Disabled'),
          content: Text('Please enable location services to use this feature.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _checkAndShowLocationSheet() async {
    Position? currentPosition;
    // bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    var locationStatus = await Permission.location.status;
    print("locationStatus");
    print(locationStatus);
    if (locationStatus.isGranted == false) {
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (locationStatus == PermissionStatus.denied)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Location permission is disabled!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Please provide location permission to continue.',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Open device settings to enable location
                            openAppSettings();
                          },
                          child: Text('Enable Location Permission'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } else if (locationStatus.isGranted == true) {
      // location permission is granted
      // get the user's current location
      //if (isLocationEnabled == true) {
      print("User location enabled");
      currentPosition = await Geolocator.getCurrentPosition();

      if (currentPosition != null) {
        // *** Once we get current user location, set it to user's location system pref
        UserStorageService.saveLocationToPreferences(currentPosition);
        // Update the location array of user, to set it in recent used locations
        UserStorageService.saveRecentLocationsToPreferences([currentPosition]);
        // set the flag that we got the location - we can check the location array
        // display Root Screen after all configuration
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RootScreen()));
      }
      // } else {
      //   print("User location disabled");
      //   await Permission.location.request();
      // }
    }
  }
}
