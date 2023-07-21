import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:satietyfrontend/pages/ListView.dart';
import 'package:satietyfrontend/pages/getData.dart';
import 'package:satietyfrontend/pages/service.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class AddFreeFood extends StatefulWidget {
  const AddFreeFood({super.key});

  @override
  State<AddFreeFood> createState() => _AddFreeFoodState();
}

class _AddFreeFoodState extends State<AddFreeFood> {
  final _free_food_formfield = GlobalKey<FormState>();
  final foodNameController = TextEditingController();
  final foodDescriptionController = TextEditingController();
  final foodQuantityController = TextEditingController();
  final foodAddressController = TextEditingController();
  final foodImageUriController = TextEditingController();
  final foodTypeController = TextEditingController();

  Service service = Service();
  Data data = Data();

  File? image;
  final picker = ImagePicker();
  bool showSpinner = false;
  var locationData;

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  String userAddress = '';
  final TextEditingController _controller = TextEditingController();
  LatLng userCoordinates = LatLng(0.0, 0.0);
  int selectedQuantity = 1;
  String selectedFoodType = "Both";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // locationData = _requestLocationPermission();
    _controller.text = userAddress;
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //add back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Free Food',
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _free_food_formfield,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  controller: foodNameController,
                  decoration: const InputDecoration(
                    labelText: "Food Name",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    prefixIcon: Icon(Icons.food_bank),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 20),
                  controller: foodDescriptionController,
                  decoration: const InputDecoration(
                    labelText: "Food Description",
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                SizedBox(height: 10),

                // show drop down here
                Text(
                  'Select Serving Quantity : ${selectedQuantity != 0 ? selectedQuantity : "None"}',
                  style: TextStyle(fontSize: 18),
                ),
                Wrap(
                  spacing: 8.0,
                  children: List.generate(
                    5,
                    (index) => ChoiceChip(
                      label: Text('${index + 1}'),
                      selected: selectedQuantity == index + 1,
                      onSelected: (isSelected) {
                        setState(() {
                          selectedQuantity = isSelected ? index + 1 : 0;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Selected Food Type: $selectedFoodType',
                  style: TextStyle(fontSize: 18),
                ),
                Wrap(
                  spacing: 8.0,
                  children: [
                    buildChoiceChip('Veg'),
                    buildChoiceChip('Non-Veg'),
                    buildChoiceChip('Both'),
                  ],
                ),

                SizedBox(height: 10),
                // show map here to select address
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: "Show user Address",
                    prefixIcon: Icon(Icons.add_location),
                  ),
                ),
                const SizedBox(height: 10),
                // Ask user to turn on location if not turned on

                // Add Apple Maps here

                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    // if locationData is null then show placeholder
                    initialCameraPosition: CameraPosition(
                      target: userCoordinates,
                      zoom: 26,
                    ),
                    // how to get current controller
                    // markers: _markers,
                    markers: {
                      Marker(
                        markerId: const MarkerId("demo"),
                        position: userCoordinates,
                        draggable: true,
                        infoWindow: const InfoWindow(
                          title: "User Location",
                        ),
                      )
                    },
                  ),
                ),

                // show image here if image is selected
                if (image != null)
                  Image.file(File(image!.path).absolute,
                      width: 200, height: 200),
                SizedBox(height: 10),

                // select image button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.black,
                    shadowColor: Colors.red,
                    elevation: 15,
                    minimumSize: const Size(200, 50),
                  ),
                  onPressed: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (pickedFile != null) {
                      image = File(pickedFile.path);

                      setState(() {});
                    }
                  },
                  child: const Text('Select Image',
                      style: TextStyle(fontSize: 30)),
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.black,
                    shadowColor: Colors.red,
                    elevation: 15,
                    minimumSize: const Size(200, 50),
                  ),
                  onPressed: () async {
                    if (image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an image'),
                        ),
                      );
                      return;
                    }
                    var response = await service.sendFoodDetailsWithFile(
                        foodNameController.text,
                        foodDescriptionController.text,
                        int.parse(foodQuantityController.text),
                        foodAddressController.text,
                        foodImageUriController.text,
                        foodTypeController.text,
                        image);

                    // show alert dialog on condition
                    if (response) {
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Add Food'),
                          content: const Text('Food added successfully'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListViewPage(),
                                    ));
                                // TODO:- clear the form fields
                                // TODO:- clear the image
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Add Food'),
                          content: const Text('Food not added successfully'),
                          actions: [
                            TextButton(
                              onPressed: () {},
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Add Food', style: TextStyle(fontSize: 30)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // Function to add a marker on the map and animate the camera to the marker's position
  }

  void _addMarker(double lat, double lng) {
    setState(() {
      final marker = Marker(
        markerId: MarkerId('marker_id'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: 'Marker Title',
          snippet: 'Marker Snippet',
        ),
      );

      _markers.add(marker);
      _mapController?.animateCamera(CameraUpdate.newLatLng(marker.position));
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle the
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    // Check if the app has location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, handle the scenario
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Check if the app has location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Location permissions are denied, ask user for permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied
        return Future.error(
            'Location permissions are denied, we cannot request permissions.');
      }
    }

    // Location permissions are granted
    // get location here
    final locationData = await Geolocator.getCurrentPosition();
    print(locationData.latitude);
    print(locationData.longitude);
    print(locationData.accuracy);

    // get address here
    List<Placemark> placemark = await placemarkFromCoordinates(
        locationData.latitude, locationData.longitude);
    print(placemark);
    Placemark place = placemark[0];

    print(userAddress);

    setState(() {
      //_addMarker(locationData.latitude, locationData.longitude);
      userCoordinates = LatLng(locationData.latitude, locationData.longitude);
      userAddress =
          "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
      _controller.text = userAddress;
      print(userAddress);
      // show toast here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User Address Updated!"),
        ),
      );
    });

    return locationData;
  }

  Widget buildChoiceChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedFoodType == label,
      onSelected: (isSelected) {
        setState(() {
          selectedFoodType = isSelected ? label : '';
        });
      },
    );
  }
}
