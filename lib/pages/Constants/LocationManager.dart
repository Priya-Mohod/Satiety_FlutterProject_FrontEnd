import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as Location;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    hide PermissionStatus;
import 'package:http/http.dart' as http;
import 'package:satietyfrontend/pages/Constants/LoadingIndicator.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:satietyfrontend/pages/Screens/RootScreen.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';

class LocationManager {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle the
      await Geolocator.openLocationSettings();
      //return Future.error('Location services are disabled.');
    }

    // Check if the app has location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, handle the scenario
      //return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Check if the app has location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Location permissions are denied, ask user for permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied
        //return Future.error('Location permissions are denied, we cannot request permissions.');
      }
    }

    final locationData = await Geolocator.getCurrentPosition();
    return locationData;
  }

  static Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String userAddress =
            "${place.street}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}";
        print("place fetched $place");
        print("userAddress is $userAddress");
        return userAddress;
      } else {
        return "Address not found";
      }
    } catch (e) {
      return "Error fetching address";
    }
  }

  static Future<List<dynamic>> fetchSuggestions(String input) async {
    final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$input'
        '&key=${DevelopementConfig().GOOGLE_MAP_KEY}';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      return data['predictions'];
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  static Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    final url = 'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId'
        '&key=${DevelopementConfig().GOOGLE_MAP_KEY}';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      return data['result'];
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  static Future<void> getLocation(BuildContext context) async {
    bool locationEnabled = await isLocationEnabled();

    if (!locationEnabled) {
      //   LoadingIndicator.instance.hide();
      showLocationServiceAlertDialog(context);
      return;
    }

    _checkAndShowLocationSheet(context);

    Location.Location location = Location.Location();
    try {
      LocationData currentLocation = await location.getLocation();
      print('Latitude: ${currentLocation.latitude}');
      print('Longitude: ${currentLocation.longitude}');

      // Get location permission
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  static Future<bool> isLocationEnabled() async {
    Location.Location location = Location.Location();

    bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    return _serviceEnabled;
  }

  static void showLocationServiceAlertDialog(BuildContext context) {
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

  static void _checkAndShowLocationSheet(BuildContext context) async {
    Position? currentPosition;
    await Permission.location.request();
    var locationStatus = await Permission.location.status;
    print("locationStatus");
    print(locationStatus);
    if (locationStatus.isGranted == false) {
      LoadingIndicator.hide();
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
        await UserStorageService.saveLocationToPreferences(currentPosition);
        // Update the location array of user, to set it in recent used locations
        await UserStorageService.saveRecentLocationToPreferences(
            currentPosition);
        // set the flag that we got the location - we can check the location array
        // display Root Screen after all configuration
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RootScreen()));
      }
    }
  }
}
