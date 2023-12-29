import 'dart:convert';
import 'dart:ffi';
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
        '&key=${DevelopmentConfig().GOOGLE_MAP_KEY}';

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
        '&key=${DevelopmentConfig().GOOGLE_MAP_KEY}';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      return data['result'];
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  static Future<LocationStatus> getLocation(BuildContext context) async {
    bool locationEnabled = await isLocationEnabled();

    if (!locationEnabled) {
      return LocationStatus.deviceLocationNotON;
    }
    var locationStatus = await Permission.location.status;
    if (locationStatus.isGranted) {
      print("Location permission already granted");
      Position? currentPosition = await Geolocator.getCurrentPosition();
      await UserStorageService.saveLocationToPreferences(currentPosition);
      // Update the location array of user, to set it in recent used locations
      await UserStorageService.saveRecentLocationToPreferences(currentPosition);
      return LocationStatus.bothGranted;
    }
    return LocationStatus.locationPermissionDenied;
  }

  static Future<bool> isLocationEnabled() async {
    Location.Location location = Location.Location();

    bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    return _serviceEnabled;
  }

  static void requestForUserPermission() async {
    await Permission.location.request();
  }
}
