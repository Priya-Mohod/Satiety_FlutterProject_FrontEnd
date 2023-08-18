import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:satietyfrontend/pages/Constants/StringConstants.dart';

import '../Constants/Drawers.dart';
import '../Constants/LocationManager.dart';
import '../Constants/SideDrawer.dart';
import '../Constants/bottomNavigationBar.dart';
import '../Models/UserModel.dart';
import '../ViewModels/UserProfileViewModel.dart';
import 'SnackbarHelper.dart';
import 'SupplierLocationMap.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _phoneController = TextEditingController();
  var _addressController = TextEditingController();
  final viewModel = UserProfileViewModel();
  late User _user;

  var locationData;
  GoogleMapController? _mapController;
  Set<Marker> markers = {};
  LatLng userCoordinates = LatLng(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    initializeUserData();
  }

  Future<void> initializeUserData() async {
    final user = await viewModel.fetchUserProfile();
    setState(() {
      _user = user;
      _nameController = TextEditingController(text: user.firstName);
      _emailController = TextEditingController(text: user.email);
      _passwordController = TextEditingController(text: user.password ?? '');
      _phoneController = TextEditingController(text: user.mobile);
      _addressController = TextEditingController(text: user.address);
    });
  }

  @override
  void dispose() {
    // Dispose the controllers when the screen is disposed
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringConstants.user_profile_screen_title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle image update
                    // ...
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(_user.imageSignedUrl ?? ''),
                    child: Icon(Icons.camera_alt),
                  ),
                ),
                SizedBox(height: 10),
                Text('Tap to update profile picture'),
              ],
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            // Non-editable fields
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Please select location to get address',
                prefixIcon: Icon(Icons.location_on),
                suffixIcon: IconButton(
                  onPressed: () {
                    // Handle map icon tap
                    // ...
                  },
                  icon: Icon(Icons.map),
                ),
              ),
              enabled: false, // Make the text field non-editable
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  // Show snackbar while getting location
                  SnackbarHelper.showSnackBar(
                      context, StringConstants.location_update);
                  _mapController = controller;
                  setState(() {
                    markers.clear();
                    markers.add(Marker(
                      markerId: MarkerId(userCoordinates.toString()),
                      position: userCoordinates,
                      infoWindow: InfoWindow(
                        title: "Selected Location",
                      ),
                    ));
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: userCoordinates,
                  zoom: 15,
                ),
                markers: markers,
                onTap: (LatLng location) async {
                  userCoordinates = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SupplierLocationMap(
                          selectedLocation: userCoordinates),
                    ),
                  );
                  setMarker_AnimateCamera_userLocation(userCoordinates);
                },
              ),
            ),

            // Add a map widget to show location
            // ...
            ElevatedButton(
              onPressed: () {
                // Update user profile logic here
                final updatedUser = User(
                  userId: _user.userId,
                  firstName: _nameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                  mobile: _phoneController.text,
                  imageSignedUrl: _user.imageSignedUrl,
                  address: _user.address,
                  // Copy other properties as needed
                );

                // Call ViewModel to update user profile
                // TODO Call ViewModel to update user profile
              },
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Future setMarker_AnimateCamera_userLocation(dynamic location) async {
    // Update Map Location
    userCoordinates = LatLng(location.latitude, location.longitude);

    setState(() {
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(userCoordinates.toString()),
        position: userCoordinates,
        infoWindow: const InfoWindow(
          title: 'My Location',
        ),
      ));
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(userCoordinates),
    );

    _addressController.text = await LocationManager().getAddressFromCoordinates(
        userCoordinates.latitude, userCoordinates.longitude);
  }
}
