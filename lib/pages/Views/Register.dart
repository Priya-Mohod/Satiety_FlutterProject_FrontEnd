import 'dart:ffi';
import 'dart:io';
// import 'dart:html';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:satietyfrontend/pages/TermsAndCondition.dart';
import 'package:satietyfrontend/pages/Views/Loginpage.dart';
import 'package:satietyfrontend/pages/Views/ValidateOTP.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:image_picker/image_picker.dart';

import '../Constants/LocationManager.dart';
import '../Constants/StringConstants.dart';
import 'ListView.dart';
import 'SnackbarHelper.dart';
import 'SupplierLocationMap.dart';

//create stateful widget called Register
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

// create state for Register
class _RegisterState extends State<Register> {
  final _formfield = GlobalKey<FormState>();
  GlobalKey<FormFieldState<String>> _emailField =
      GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _phoneField =
      GlobalKey<FormFieldState<String>>();
  File? userImage; // User Image
  final firstNameController = TextEditingController(); // First Name
  final lastNameController = TextEditingController(); // Last Name
  final passwordController = TextEditingController(); // Password
  final confirmPasswordController = TextEditingController(); // Password
  final phoneController = TextEditingController(); // Phone Number
  TextEditingController emailController = TextEditingController(); // Email
  final pincodeController = TextEditingController(); // Pincode
  final addressController = TextEditingController(); // Address

  bool passwordVisible = true;
  bool isChecked = false;
  bool isEmailExists = false; // Email Validation
  bool isEmailValid = true; // Email Validation
  bool isPhoneExists = false; // Phone Validation
  final TextEditingController userAddressController = TextEditingController();

  var locationData;
  GoogleMapController? _mapController;
  Set<Marker> markers = {};
  LatLng userCoordinates = LatLng(0.0, 0.0);

  Service service = Service();

  final picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
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

    userAddressController.text = await LocationManager()
        .getAddressFromCoordinates(
            userCoordinates.latitude, userCoordinates.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Join Satiety',
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      // create body for Register
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formfield,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (userImage != null)
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: FileImage(userImage!),
                  ),
                //  SizedBox(height: 20),
                CircleAvatar(
                  radius: 30.0, // Adjust the radius to your desired size
                  backgroundColor:
                      Colors.cyan, // Customize the background color
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _showImagePickerOptions,
                    //child: Text('Select Image'),
                  ),
                ),
                const SizedBox(height: 10),
                // -- Last Name --
                TextFormField(
                  controller: firstNameController,
                  style: TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your name";
                    }
                  },
                ),
                const SizedBox(height: 10),
                // -- Email --
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  key: _emailField,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    // suffixText: '@gmail.com',
                    // suffixStyle: const TextStyle(
                    //     color: Colors.black,
                    //     //fontWeight: FontWeight.bold,
                    //     fontSize: 20),
                    prefixIcon: const Icon(
                      Icons.email,
                      size: 30,
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
                    if (await _isEmailExists(emailController.text)) {
                      isEmailExists = true;
                      setState(() {
                        _emailField.currentState!.validate();
                      });
                    }
                  },
                ),
                //devide

                const SizedBox(height: 5),
                // -- Phone --
                TextFormField(
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 20),
                  controller: phoneController,
                  key: _phoneField,
                  maxLength: 10,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  decoration: const InputDecoration(
                    labelText: "Phone",
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
                      if (await _isPhoneExists(phoneController.text)) {
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
                // -- Password --
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(fontSize: 20),
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      child: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                  },
                ),
                const SizedBox(height: 05),
                // -- Confirm Password --
                TextFormField(
                  controller: confirmPasswordController,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please confirm your password";
                    }
                  },
                ),
                SizedBox(height: 10),
                // show map here to select address
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  controller: userAddressController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: StringConstants.post_ad_user_address,
                    prefixIcon: Icon(Icons.add_location),
                  ),
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

                const SizedBox(height: 20),
                // -- Terms & condition --
                CheckboxListTile(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  // title: InkWell(
                  //   onTap: _launchURL,
                  //   child: const Text(
                  //     'Click here to open a website',
                  //     style: TextStyle(
                  //       fontSize: 25,
                  //       color: Colors.cyan,
                  //       //decoration: TextDecoration.underline,
                  //     ),
                  //   ),
                  // ),

                  title: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsAndCondition(),
                          ));
                    },
                    child: const Text(
                      'I agree to the terms and conditions',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.cyan,
                        //decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 10),
                // -- Register Button --
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () async {
                    if (_formfield.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                        ),
                      );

                      // check if password and confirm password are same
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Password and Confirm Password are not same'),
                          ),
                        );
                        return;
                      }

                      // check if user has selected terms and conditions
                      if (isChecked == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please agree to the terms and conditions'),
                          ),
                        );
                        return;
                      }

                      var response = await service.registerUser(
                        userImage,
                        firstNameController.text,
                        lastNameController.text,
                        passwordController.text,
                        phoneController.text,
                        emailController.text,
                        pincodeController.text,
                        addressController.text,
                        userCoordinates.latitude,
                        userCoordinates.longitude,
                      );

                      // show alert dialog on condition
                      if (response) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Register',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            content: const Text(
                                'Registration Completed successfully'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ValidateOTP(
                                            userEmail: emailController.text),
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
                            title: const Text('Register'),
                            content: const Text(
                                'There was an error, please try again!'),
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
                    }
                  },
                  // autofocus: const CheckBox(isChecked: false).isChecked(),
                  child: const Text('Register',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      )),
                ),
                const SizedBox(height: 10),
                // -- Redirecting to Login Page --
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a part of Satiety family?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        )),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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

  _launchURL() async {
    final Uri url = Uri.parse(
        'https://www.food.gov.uk/business-guidance/allergen-guidance-for-food-businesses');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<bool> _isEmailExists(String email) async {
    // Make server call to check if email already exists
    /* TODO : - Check for response 
    var response = await service.checkUserEmailExist(email);
    if (response != null && response.statusCode == 200) {
      return true;
    } else if (response != null && response.statusCode != 200) {
      return false;
    } else {
      // ignore: use_build_context_synchronously
      SnackbarHelper.showSnackBar(context, StringConstants.exception_error);
      return false;
    }*/
    var response = await service.fetchUserDataUsingEmail(email);
    if (response != null && response.statusCode == 200) {
      return true;
    } else if (response != null && response.statusCode != 200) {
      return false;
    } else {
      // ignore: use_build_context_synchronously
      SnackbarHelper.showSnackBar(context, StringConstants.exception_error);
      return false;
    }
  }

  Future<bool> _isPhoneExists(String phone) async {
    var response = await service.checkUserPhoneNumber(phone);
    return response;
  }

  bool _isValidEmail(String email) {
    // Use a regular expression to check the email pattern
    // This pattern allows most valid email formats
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    return emailRegex.hasMatch(email);
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
}
