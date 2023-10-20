
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';
import 'package:satietyfrontend/pages/Services/Utility.dart';
import 'package:satietyfrontend/pages/Views/CustomURL.dart';
import 'package:satietyfrontend/pages/Views/ListView.dart';
import 'package:satietyfrontend/pages/Views/Register.dart';
import 'package:satietyfrontend/pages/Views/SnackbarHelper.dart';

import '../Constants/StringConstants.dart';
import '../ViewModels/LoginViewModel.dart';

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
//  Service service = Service();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
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
                    return null;
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
                    return null;
                  },
                ),
                SizedBox(height: 50),
                InkWell(
                  onTap: () async {
                    if (_formfield.currentState!.validate()) {
                      String currentURL = await viewModel.getUrlInUse();
                      // ignore: use_build_context_synchronously
                      SnackbarHelper.showSnackBar(context, currentURL);
                      print("Email: ${emailController.text}");
                      print("Password: ${passwordController.text}");

                      // TODO : (CHANGE THIS FLOW)
                      // TEMP : Make server call with valid user to get user data and store it in shared preferences
                      //getUserDataUsingEmail(emailController.text);

                      bool response = await viewModel.loginUser(
                          emailController.text, passwordController.text);

                      if (response == true) {
                        // After successful login get the user data from the server
                        await AppUtil()
                            .getUserDataUsingEmail(emailController.text);

                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ListViewPage(),
                            ));
                      } else {
                        // ignore: use_build_context_synchronously
                        SnackbarHelper.showSnackBar(
                            context, StringConstants.login_error);
                      }
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
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomURL(),
                      ),
                    );
                  },
                  child: const Text("Add Custom URL"),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    UserStorageService.removeCustomURL();
                    SnackbarHelper("Custom URL cleared successfully");
                  },
                  child: const Text("Clear Custom URL"),
                ),
              ],
            )),
      )),
    );
  }
}
