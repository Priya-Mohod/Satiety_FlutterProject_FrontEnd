import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:satietyfrontend/pages/Constatnts/LocationManager.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';
import '../Constatnts/StringConstants.dart';

class SupplierLocationMap extends StatefulWidget {
  LatLng selectedLocation;
  SupplierLocationMap({super.key, required this.selectedLocation});

  @override
  _SupplierLocationMapState createState() => _SupplierLocationMapState();
}

class _SupplierLocationMapState extends State<SupplierLocationMap> {
  final apiKey = 'AIzaSyDFkgk7N-JkiLHOEDowS6LH7q-bIP1nRF0'; // Code for Android
  TextEditingController _searchController = TextEditingController();
  List<dynamic> suggestions = [];
  //LatLng? setNewLocation; // Selected location's coordinates
  Set<Marker> markers = {}; // Set to hold map markers
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // show parent view here
        Navigator.pop(context, widget.selectedLocation);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringConstants.supplier_location_map_title),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: StringConstants.supplier_location_map_search_hint,
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
                        });
                      }).catchError((error) {
                        print('Error fetching suggestions: $error');
                        SnackbarHelper.showSnackBar(
                            context, 'Error fetching suggestions: $error');
                      });
                    }
                  },
                ),
              ),
            ),
            Visibility(
              visible: suggestions.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(suggestions[index]['description']),
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        // Handle suggestion selection
                        _searchController.text =
                            suggestions[index]['description'];
                        // Fetch place details
                        getCoordinatesFromPlace(
                            suggestions[index]['description']);
                        setState(() {
                          suggestions = [];
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: widget.selectedLocation ??
                          LatLng(0, 0), // Default to (0, 0)
                      zoom: 15,
                    ),
                    markers: Set<Marker>.from(markers),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                      // Initialize map settings and markers as needed
                      setState(() {
                        markers.clear();
                        markers.add(Marker(
                          markerId:
                              MarkerId(widget.selectedLocation.toString()),
                          position: widget.selectedLocation,
                          infoWindow: InfoWindow(
                            title: "Selected Location",
                          ),
                        ));
                      });
                    },
                    // get marker on tap
                    onTap: (LatLng location) {
                      setState(() {
                        widget.selectedLocation = location;
                        markers.clear();
                        markers.add(Marker(
                          markerId: MarkerId(location.toString()),
                          position: location,
                          infoWindow: InfoWindow(
                            title: StringConstants
                                .supplier_location_map_pick_up_location,
                          ),
                        ));
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              _searchController.text = '';
                              var locationData =
                                  await LocationManager().determinePosition();
                              setState(() {
                                print(locationData);
                                // set selected location to current location
                                widget.selectedLocation = LatLng(
                                  locationData.latitude,
                                  locationData.longitude,
                                );
                                markers.clear();
                                markers.add(Marker(
                                  markerId: MarkerId(
                                      widget.selectedLocation.toString()),
                                  position: widget.selectedLocation,
                                  infoWindow: InfoWindow(
                                    title: "Selected Location",
                                  ),
                                ));
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLng(
                                      widget.selectedLocation),
                                );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  Colors.grey[300], // Light shade color
                            ),
                            child: Text('Locate Me'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // show parent view here
                              Navigator.pop(context, widget.selectedLocation);
                            },
                            child: Text(StringConstants
                                .supplier_location_map_select_place),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  Future<void> getCoordinatesFromPlace(String place) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json'
        '?address=$place'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK' && data['results'].isNotEmpty) {
      final location = data['results'][0]['geometry']['location'];
      setState(() {
        widget.selectedLocation = LatLng(
          location['lat'],
          location['lng'],
        );

        markers.clear();
        markers.add(Marker(
          markerId: MarkerId(widget.selectedLocation.toString()),
          position: widget.selectedLocation,
          infoWindow: InfoWindow(
            title: place,
          ),
        ));

        _mapController?.animateCamera(
          CameraUpdate.newLatLng(widget.selectedLocation),
        );
      });
    }
  }
}
