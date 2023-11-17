import 'dart:convert';

import 'package:geolocator/geolocator.dart';

import '../Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorageService {
  static const _keyUser = 'user';

  static Future<void> saveUserToSharedPreferences(User user) async {
    final pref = await SharedPreferences.getInstance();
    final userJson = user.toJson();
    await pref.setString(_keyUser, jsonEncode(userJson));
  }

  static Future<User?> getUserFromSharedPreferances() async {
    final pref = await SharedPreferences.getInstance();
    final userJson = pref.getString(_keyUser);
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      final user = User.fromJson(userMap);
      return user;
    }
    return null;
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('authToken')) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> removeUserFromSharedPreferances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('authToken');
    prefs.remove(_keyUser);
  }

  static Future<void> saveCustomURL(String url) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('customURL', url);
  }

  static Future<String?> getCustomURL() async {
    final pref = await SharedPreferences.getInstance();
    final url = pref.getString('customURL');
    return url;
  }

  static Future<void> removeCustomURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('customURL');
  }

// Save the user's location to shared preferences
  static Future<void> saveLocationToPreferences(Position location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble('userLatitude', location.latitude);
    prefs.setDouble('userLongitude', location.longitude);
    prefs.setDouble('userAltitude', location.altitude);
    prefs.setDouble('userAccuracy', location.accuracy);
    prefs.setDouble('userHeading', location.heading);
    prefs.setInt('userTimestamp', location.timestamp!.millisecondsSinceEpoch);
  }

// Retrieve user's location from shared preferences
  static Future<Position?> retrieveLocationFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double? latitude = prefs.getDouble('userLatitude');
    double? longitude = prefs.getDouble('userLongitude');
    double? altitude = prefs.getDouble('userAltitude');
    double? accuracy = prefs.getDouble('userAccuracy');
    double? heading = prefs.getDouble('userHeading');
    int? timestampMillis = prefs.getInt('userTimestamp');

    if (latitude != null &&
        longitude != null &&
        altitude != null &&
        accuracy != null &&
        heading != null &&
        timestampMillis != null) {
      DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMillis);
      return Position(
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        accuracy: accuracy,
        heading: heading,
        speed: 0, // speed is set to 0 as it's not stored in shared preferences
        speedAccuracy: 0, // speedAccuracy is set to 0 as it's not stored
        timestamp: timestamp,
      );
    }

    return null;
  }

  static Future<void> saveRecentLocationToPreferences(Position location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing list from shared preferences
    List<String>? existingLocations = prefs.getStringList('recentLocations');

    // Convert the new location to a Map<String, dynamic>
    Map<String, dynamic> newLocationData = {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'altitude': location.altitude,
      'accuracy': location.accuracy,
      'heading': location.heading,
      'timestamp': location.timestamp!.millisecondsSinceEpoch,
    };

    if (existingLocations != null) {
      // Check if the same latitude and longitude already exist
      bool locationExists = existingLocations.any((String entry) {
        Map<String, dynamic> entryData = jsonDecode(entry);
        double entryLatitude = entryData['latitude'];
        double entryLongitude = entryData['longitude'];
        return entryLatitude == location.latitude &&
            entryLongitude == location.longitude;
      });

      if (locationExists) {
        // If the same location exists, remove it from the list
        existingLocations.removeWhere((String entry) {
          Map<String, dynamic> entryData = jsonDecode(entry);
          double entryLatitude = entryData['latitude'];
          double entryLongitude = entryData['longitude'];
          return entryLatitude == location.latitude &&
              entryLongitude == location.longitude;
        });
      }

      // Add the new location to the beginning of the existing list
      existingLocations.insert(0, jsonEncode(newLocationData));
    } else {
      // If no existing list, create a new list with the new location
      existingLocations = [jsonEncode(newLocationData)];
    }

    // Save the updated list to shared preferences
    prefs.setStringList('recentLocations', existingLocations);
  }

// Retrieve the list of recent user locations from shared preferences
  static Future<List<Position>> retrieveRecentLocationsFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the list of locations as strings from shared preferences
    List<String>? locationsData = prefs.getStringList('recentLocations');
    print("recentLocations on retival");
    print(locationsData);
    if (locationsData != null) {
      // Convert the list of strings back to a list of Map<String, dynamic>
      List<Map<String, dynamic>> parsedLocations =
          locationsData.map((String json) {
        print("Json object is");
        print(json);
        return jsonDecode(json) as Map<String, dynamic>;
      }).toList();

      // Convert the list of Map<String, dynamic> back to a list of Position objects
      List<Position> locations = parsedLocations.map((data) {
        return Position(
          latitude: data['latitude'],
          longitude: data['longitude'],
          altitude: data['altitude'],
          accuracy: data['accuracy'],
          heading: data['heading'],
          timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
          speed:
              0, // speed is set to 0 as it's not stored in shared preferences
          speedAccuracy: 0, // speedAccuracy is set to 0 as it's not stored
        );
      }).toList();

      return locations;
    }

    return [];
  }
}
