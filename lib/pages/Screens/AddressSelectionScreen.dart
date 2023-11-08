import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/Utilities/DevelopmentConfig.dart';
import 'package:http/http.dart' as http;
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';

class AddressSelectionScreen extends StatefulWidget {
  @override
  _AddressSelectionScreenState createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> suggestions = ["ABC", "XYZ", "PQR", "CVDFG"];
  final apiKey = DevelopementConfig().GOOGLE_MAP_KEY;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                            hintText: 'Try Sus, Wagholi etc',
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
            Expanded(
                child: ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'SEARCH RESULTS',
                            style: TextStyle(
                                fontSize: 10.0, fontWeight: FontWeight.normal),
                          ),
                        );
                      }
                      return ListTile(
                          title: Row(
                        children: [
                          IconButton(
                            icon: Icon(CupertinoIcons.location_fill,
                                color: Colors.redAccent),
                            onPressed: () {
                              // Add functionality for location icon here
                              _selectAddress();
                            },
                            iconSize: 10,
                          ),
                          Text(
                            suggestions[index],
                            style: TextStyle(
                                fontSize: 12.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ));
                    }))
          ],
        ),
      ),
    );
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
