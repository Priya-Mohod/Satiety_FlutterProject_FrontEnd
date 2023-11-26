import 'dart:ffi';
import 'dart:io';
// import 'dart:html';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:satietyfrontend/pages/Constants/ColorConstants.dart';
import 'package:satietyfrontend/pages/TermsAndCondition.dart';
import 'package:satietyfrontend/pages/Views/Loginpage.dart';
import 'package:satietyfrontend/pages/Views/ValidateOTP.dart';
import 'package:satietyfrontend/pages/Views/Widgets/CustomButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final String mobileNumber;
  const Register({super.key, required this.mobileNumber});

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

    userAddressController.text =
        await LocationManager.getAddressFromCoordinates(
            userCoordinates.latitude, userCoordinates.longitude);
  }

  @override
  Widget build(BuildContext context) {
    phoneController.text = widget.mobileNumber;
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
                  style: TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    prefixIcon: Icon(CupertinoIcons.person),
                  ),
                  validator: (value) {
                    print(value!);
                    var enteredName = value;
                    if (enteredName.isEmpty) {
                      return "Please enter your name";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10),
                // -- Email --
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 16),
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
                      CupertinoIcons.mail,
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
                  style: TextStyle(fontSize: 18),
                  controller: phoneController,
                  key: _phoneField,
                  maxLength: 10,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Mobile Number",
                    prefixIcon: Icon(CupertinoIcons.phone),
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
                        fontSize: 12,
                        color: ThemeColors.primaryColor,
                        //decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                // -- Register Button --
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                      text: 'Register',
                      buttonFont: 16.0,
                      onPressed: () {
                        _registerUser(context);
                      },
                    ),
                  ),
                ),
                // -- Redirecting to Login Page --
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a part of Satiety family?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
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
                        style: TextStyle(fontSize: 16),
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

  // -- Register user
  void _registerUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('authToken');

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

      // check if user has selected terms and conditions
      if (isChecked == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the terms and conditions'),
          ),
        );
        return;
      }

      var response = await service.registerUser(
          userImage,
          firstNameController.text,
          "", // last name
          "", // password
          phoneController.text, // phone number
          emailController.text, // email
          pincodeController.text, // pin code
          addressController.text, // address
          userCoordinates.latitude, // user's lat
          userCoordinates.longitude, // user's long
          true);

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
            content: const Text('Registration Completed successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  // *** Display validate OTP for email
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ValidateOTP(userEmail: emailController.text),
                      ));
                  // TODO:- clear the form fields
                  // TODO:- clear the image

                  // **** For now just show home screen
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
            content: const Text('There was an error, please try again!'),
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
