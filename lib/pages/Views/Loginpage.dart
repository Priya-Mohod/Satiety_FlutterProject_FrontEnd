import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';
import 'package:satietyfrontend/pages/Services/Utility.dart';
import 'package:satietyfrontend/pages/Views/ListView.dart';
import 'package:satietyfrontend/pages/Views/Register.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';

import '../Constatnts/StringConstants.dart';
import '../ViewModels/UserViewModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = true;
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Satiety',
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pacifico',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
        child: Form(
            key: _formfield,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
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
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
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
                SizedBox(height: 50),
                InkWell(
                  onTap: () async {
                    if (_formfield.currentState!.validate()) {
                      print("Email: ${emailController.text}");
                      print("Password: ${passwordController.text}");

                      // TODO : (CHANGE THIS FLOW)
                      // TEMP : Make server call with valid user to get user data and store it in shared preferences
                      getUserDataUsingEmail(emailController.text);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a part of Satiety family yet?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        )),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ),
                        );
                      },
                      child: const Text(
                        "Join here",
                        style: TextStyle(
                          color: Color.fromARGB(255, 32, 89, 93),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
      )),
    );
  }

  Future<void> getUserDataUsingEmail(String email) async {
    if (await AppUtil().getUserDataUsingEmail(email) == true) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ListViewPage(),
          ));
    } else {
      SnackBar(
        content: Text(StringConstants.login_user_not_found,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      );
    }
  }
}
