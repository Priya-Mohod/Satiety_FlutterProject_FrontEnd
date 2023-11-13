import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
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
  // *** assign array from system preferences
  List<Position> suggestions = [];
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
                          onChanged: (String query) {
                            if (query.isEmpty) {
                              setState(() {
                                suggestions = [];
                              });
                            } else {
                              fetchSuggestions(query).then((apiSuggestions) {
                                setState(() {
                                  suggestions =
                                      apiSuggestions as List<Position>;
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
                    // Add functionality for location icon here
                    _useMyCurrentLocation();
                  },
                ),
                GestureDetector(
                  onTap: () => {_useMyCurrentLocation()},
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
                "Recent Searches",
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
                      double latitude = suggestions[index].latitude;
                      double longitude = suggestions[index].longitude;

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
                          print('selecting object'),
                          UserStorageService.saveLocationToPreferences(Position(
                              longitude: suggestions[index].longitude,
                              latitude: suggestions[index].latitude,
                              timestamp: suggestions[index].timestamp,
                              accuracy: suggestions[index].accuracy,
                              altitude: suggestions[index].altitude,
                              heading: suggestions[index].heading,
                              speed: suggestions[index].speed,
                              speedAccuracy: suggestions[index].speedAccuracy)),
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RootScreen())),
                        },
                      );
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

  void _selectAddress() {
    // Select address

    // Open maps with selected address

    // On maps confirm location
  }

  void _useMyCurrentLocation() {
    print("Use my current location");
  }

  Future<List<dynamic>> fetchSuggestions(String input) async {
    final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$input'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      return data['predictions'];
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }
}
