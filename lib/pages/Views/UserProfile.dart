import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:satietyfrontend/pages/Constants/StringConstants.dart';
import 'package:satietyfrontend/pages/Views/PublicProfile.dart';

import '../Constants/Drawers.dart';
import '../Constants/LocationManager.dart';
import '../Constants/SideDrawer.dart';
import '../Constants/bottomNavigationBar.dart';
import '../Models/UserModel.dart';
import '../ViewModels/UserProfileViewModel.dart';
import 'DualImageWidget.dart';
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
  var _phoneController = TextEditingController(); // Phone Number
  var _addressController = TextEditingController();
  final viewModel = UserProfileViewModel();
  User? _user;

  GlobalKey<FormFieldState<String>> _phoneField =
      GlobalKey<FormFieldState<String>>();
  bool isPhoneExists = false; // Phone Validation
  GlobalKey<FormFieldState<String>> _emailField =
      GlobalKey<FormFieldState<String>>();
  bool isEmailExists = false; // Email Validation
  bool isEmailValid = true; // Email Validation

  File? userImage; // User Image
  var locationData;
  GoogleMapController? _mapController;
  Set<Marker> markers = {};
  LatLng userCoordinates = LatLng(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    initializeUserData();
    getLocation();
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
      appBar: AppBar(
        title: Text(StringConstants.user_profile_screen_title),
      ),
      endDrawer: SideDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: GestureDetector(
                onTap: () {
                  _showImagePickerOptions();
                },
                child: ClipOval(
                    child: userImage != null
                        ? Image(image: FileImage(userImage!))
                        : Image.network(
                            _user!.imageSignedUrl!,
                            width: 170,
                            height: 170,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'images/account.png',
                                height: 170,
                                width: 170,
                              );
                            },
                          )),
              ),
            ),
            Divider(),
            Container(
              child: TextButton(
                onPressed: () {
                  int userId = _user!.userId;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PublicProfile(userId: userId),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: Colors.green,
                    border:
                        Border.all(color: Color.fromARGB(255, 32, 137, 175)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: const Text(
                    'View Public Profile',
                    style: TextStyle(
                        color: Color.fromARGB(255, 36, 113, 123),
                        fontSize: 18.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                floatingLabelStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 19,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              readOnly: true,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 16),
              key: _emailField,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                floatingLabelStyle: const TextStyle(
                  color: Colors.black54, fontSize: 19,
                  //fontWeight: FontWeight.bold,
                ),
                prefixIcon: const Icon(
                  Icons.email,
                ),
                errorText: isEmailValid
                    ? null
                    : StringConstants.register_email_invalid,
                errorStyle: TextStyle(color: Colors.red),
              ),
              validator: (value) {
                if (isEmailExists) {
                  return StringConstants.register_email_exists_message;
                }

                bool emailValidator =
                    RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value!);
                if (value.isEmpty) {
                  return StringConstants.register_email_empty;
                } else if (!emailValidator) {
                  return StringConstants.register_enter_valid_email;
                }
              },
              onChanged: (value) => {
                isEmailExists = false,
                setState(() {
                  _emailField.currentState!.validate();
                })
              },
              onEditingComplete: () async {
                if (await viewModel.isEmailExists(_emailController.text)) {
                  isEmailExists = true;
                  setState(() {
                    _emailField.currentState!.validate();
                  });
                }
              },
            ),

            // TextField(
            //   controller: _passwordController,
            //   obscureText: true,
            //   decoration: InputDecoration(labelText: 'Password'),
            // ),
            TextFormField(
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 16),
              controller: _phoneController,
              key: _phoneField,
              maxLength: 10,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              decoration: const InputDecoration(
                labelText: "Phone",
                floatingLabelStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 19,
                  //fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (value) {
                if (isPhoneExists) {
                  return StringConstants.register_phone_exists_message;
                }

                if (value == null || value.isEmpty) {
                  return StringConstants.register_phone_number_empty;
                } else if (value.length != 10) {
                  return StringConstants.register_phone_number_invalid;
                } else {
                  return null;
                }
              },
              onChanged: (value) async {
                if (value.length == 10) {
                  if (await viewModel.isPhoneExists(_phoneController.text)) {
                    isPhoneExists = true;
                    setState(() {
                      _phoneField.currentState!.validate();
                    });
                  } else {
                    isPhoneExists = false;
                    setState(() {
                      _phoneField.currentState!.validate();
                    });
                  }
                } else {
                  isPhoneExists = false;
                  setState(() {
                    _phoneField.currentState!.validate();
                  });
                }
              },
            ),

            // Non-editable fields
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Your approximate address',
                floatingLabelStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 19,
                  //fontWeight: FontWeight.bold,
                ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.black,
                shadowColor: Colors.red,
                elevation: 15,
                minimumSize: const Size(200, 50),
              ),
              onPressed: () async {
                // Update user profile logic here
                // final updatedUser = User(
                //   userId: _user!.userId,
                //   firstName: _nameController.text,
                //   email: _emailController.text,
                //   password: _passwordController.text,
                //   mobile: _phoneController.text,
                //   imageSignedUrl: _user!.imageSignedUrl,
                //   address: _user!.address,
                //   // Copy other properties as needed
                // );
                // Call ViewModel to update user profile
                // TODO:- Create Model of User to send data
                // Call ViewModel to update user profile
                var response = await viewModel.updateUserProfile(
                    userImage,
                    _nameController.text,
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    userCoordinates.latitude,
                    userCoordinates.longitude);
                if (response) {
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Profile Update',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      content: const Text('Profile Updated successfully'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => ValidateOTP(
                            //           userEmail: emailController.text),
                            //     ));
                            // TODO:- clear the form fields
                            // TODO:- clear the image
                            Navigator.pop(context);
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
                      title: const Text('Register'),
                      content:
                          const Text('There was an error, please try again!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // hide the alert dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Update Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        userImage = File(pickedFile.path);
      });
    }
  }

  Future getLocation() async {
    try {
      locationData = await LocationManager().determinePosition();
      // Update Map Location
      setMarker_AnimateCamera_userLocation(locationData);
    } catch (e) {
      SnackbarHelper.showSnackBar(
          context, StringConstants.location_update_error);
    }
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
