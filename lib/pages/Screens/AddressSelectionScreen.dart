import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/Constants/LoadingIndicator.dart';
import 'package:satietyfrontend/pages/Constants/LocationManager.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:http/http.dart' as http;
import 'package:satietyfrontend/pages/Screens/RootScreen.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';

class AddressSelectionScreen extends StatefulWidget {
  @override
  _AddressSelectionScreenState createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  TextEditingController _searchController = TextEditingController();
  String searchTitle = "Recent locations";
  // *** assign array from system preferences
  List<dynamic> suggestions = [];
  final apiKey = DevelopementConfig().GOOGLE_MAP_KEY;

  @override
  void initState() {
    // TODO: implement initState
    getRecentLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primaryColor,
        elevation: 1,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(CupertinoIcons.arrow_left)),
        title: Text("Enter your area"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(08.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(CupertinoIcons.search),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Try Hinjewadi, Wagholi etc',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                          onChanged: (String query) async {
                            searchTitle = "Search Result";
                            if (query.isEmpty) {
                              setState(() {
                                suggestions = [];
                              });
                            } else {
                              LocationManager.fetchSuggestions(query)
                                  .then((apiSuggestions) {
                                setState(() {
                                  suggestions = apiSuggestions;
                                  print(suggestions);
                                });
                              }).catchError((error) {
                                print('Error fetching suggestions: $error');
                                SnackbarHelper.showSnackBar(context,
                                    'Error fetching suggestions: $error');
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(CupertinoIcons.location_fill,
                      color: Colors.redAccent),
                  onPressed: () {
                    _getUserCurrentLocationAndDisplayRootScreen();
                  },
                ),
                GestureDetector(
                  onTap: () => {_getUserCurrentLocationAndDisplayRootScreen()},
                  child: Text(
                    "Use my current location",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(CupertinoIcons.map_pin_ellipse,
                      color: Colors.redAccent),
                  onPressed: () {
                    // Add functionality for location icon here
                    //  SupplierLocationMap(selectedLocation: LatLng(0, 0)
                  },
                ),
              ],
            ),
            Divider(color: Colors.grey, thickness: 1.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                searchTitle,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      double latitude = 0.0;
                      double longitude = 0.0;
                      if (suggestions[index] is Position) {
                        latitude = suggestions[index].latitude;
                        longitude = suggestions[index].longitude;
                        return ListTile(
                          leading: Icon(
                            CupertinoIcons.location,
                            size: 18,
                          ),
                          title: FutureBuilder(
                            future: LocationManager.getAddressFromCoordinates(
                                latitude, longitude),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Loading...");
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else {
                                return Text(snapshot.data.toString());
                              }
                            },
                          ),
                          onTap: () => {
                            // Selection of location from recent searches
                            _selectRecentLocation(suggestions[index]),
                          },
                        );
                      } else {
                        print("suggestions - location search $suggestions");

                        return ListTile(
                          leading: Icon(
                            CupertinoIcons.location,
                            size: 18,
                          ),
                          title: Text(suggestions[index]["description"]),
                          onTap: () => {
                            print(suggestions[index]['place_id']),
                            _getPlaceDetails_SaveToPref_ShowRootScreen(
                                suggestions[index]['place_id']),
                          },
                        );
                      }
                    }))
          ],
        ),
      ),
    );
  }

  Future<void> getRecentLocations() async {
    List<Position> recentLocations =
        await UserStorageService.retrieveRecentLocationsFromPreferences();

    setState(() {
      print("recent locations");
      print(recentLocations);
      suggestions = recentLocations;
    });
  }

  void _getPlaceDetails_SaveToPref_ShowRootScreen(String placeId) async {
    Map<String, dynamic> placeDetails =
        await LocationManager.getPlaceDetails(placeId);
    print("Searched Location Details $placeDetails");

    double latitude =
        placeDetails['geometry']['location']['lat'] ?? 0.0; // Default value 0.0
    double longitude =
        placeDetails['geometry']['location']['lng'] ?? 0.0; // Default value 0.0
    double altitude = placeDetails['altitude'] ?? 0.0; // Default value 0.0
    double accuracy = placeDetails['accuracy'] ?? 0.0; // Default value 0.0
    double heading = placeDetails['heading'] ?? 0.0; // Default value 0.0
    double speed = placeDetails['speed'] ?? 0.0; // Default value 0.0
    double speedAccuracy = placeDetails['speed_accuracy'] ?? 0.0;

    Position currentPosition = Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: accuracy,
        altitude: altitude,
        heading: heading,
        speed: speed,
        speedAccuracy: speedAccuracy);

    _saveLocation_showRootScreen(currentPosition);
  }

  void _saveLocation_showRootScreen(Position currentPosition) async {
    await UserStorageService.saveLocationToPreferences(currentPosition);
    await UserStorageService.saveRecentLocationToPreferences(currentPosition);

    _showRootScreen();
  }

  void _selectRecentLocation(dynamic lastLocation) {
    LoadingIndicator.show(context);
    print('selecting object');

    Position currentPosition = Position(
        longitude: lastLocation.longitude,
        latitude: lastLocation.latitude,
        timestamp: lastLocation.timestamp,
        accuracy: lastLocation.accuracy,
        altitude: lastLocation.altitude,
        heading: lastLocation.heading,
        speed: lastLocation.speed,
        speedAccuracy: lastLocation.speedAccuracy);

    _saveLocation_showRootScreen(currentPosition);
  }

  void _showRootScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => RootScreen()));
  }

  void _getUserCurrentLocationAndDisplayRootScreen() {
    // Add functionality for location icon here
    LoadingIndicator.show(context);
    LocationManager.getLocation(context);
  }
}
