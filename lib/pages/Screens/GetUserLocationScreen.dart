import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Constants/LoadingIndicator.dart';
import 'package:satietyfrontend/pages/Constants/LocationManager.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
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
  PermissionStatus locationStatus = PermissionStatus.denied;
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
                  onPressed: () async {
                    LoadingIndicator.show(context);
                    LocationStatus isLocationPermissionAvailable =
                        await LocationManager.getLocation(context);
                    LoadingIndicator.hide(context);

                    switch (isLocationPermissionAvailable) {
                      case LocationStatus.deviceLocationNotON:
                        _showLocationServiceAlertDialog(context);
                        break;
                      case LocationStatus.locationPermissionDenied:
                        _showLocationPermissionAlertDialog(context);
                        break;
                      default:
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RootScreen()));
                    }
                  }),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              // Navigate to another screen when the text is clicked
              LoadingIndicator.show(context);
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

  void _showLocationServiceAlertDialog(BuildContext context) {
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

  void _showLocationPermissionAlertDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
  }
}
