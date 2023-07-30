import 'dart:ffi';
import 'dart:io';
// import 'dart:html';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Views/Loginpage.dart';
import 'package:satietyfrontend/pages/Views/ValidateOTP.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:image_picker/image_picker.dart';

import 'ListView.dart';

//create stateful widget called Register
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

// create state for Register
class _RegisterState extends State<Register> {
  final _formfield = GlobalKey<FormState>();
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
  bool isEmailValid = true; // Email Validation

  Service service = Service();

  final picker = ImagePicker();

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
                ElevatedButton(
                  onPressed: _showImagePickerOptions,
                  child: Text('Select Image'),
                ),
                const SizedBox(height: 10),
                // -- Last Name --
                TextFormField(
                  controller: lastNameController,
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
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    errorText: isEmailValid
                        ? null
                        : 'Please enter a valid email address.',
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    bool emailValidator =
                        RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value!);
                    if (value.isEmpty) {
                      return "Please enter your email";
                    } else if (!emailValidator) {
                      return "Please enter a valid email";
                    }
                  },
                  onEditingComplete: () {
                    // -- TODO: Check if email already exists
                    if (checkForEmailExist(emailController.text) == true) {
                      setState(() {
                        isEmailValid = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                // -- Phone --
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone",
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 10),
                // -- Password --
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
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
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                  },
                ),
                const SizedBox(height: 10),
                // -- Confirm Password --
                TextFormField(
                  controller: confirmPasswordController,
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
                const SizedBox(height: 10),
                // -- Terms & condition --
                CheckboxListTile(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  title: Text('I agree to the terms and conditions'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 10),
                // -- Register Button --
                ElevatedButton(
                  onPressed: () async {
                    if (_formfield.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
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
                      );
                      print(response);

                      // show alert dialog on condition
                      if (response) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Register'),
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
                  child: const Text('Register'),
                ),
                const SizedBox(height: 10),
                // -- Redirecting to Login Page --
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a part of Satiety family?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
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
                        style: TextStyle(fontSize: 18),
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
    final Uri url = Uri.parse('https://flutter.dev');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  bool checkForEmailExist(String email) {
    // Make server call to check if email already exists
    var result = service.checkUserEmailExist(email);
    if (result == true) {
      return true;
    } else {
      return false;
    }
    print(result);
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
