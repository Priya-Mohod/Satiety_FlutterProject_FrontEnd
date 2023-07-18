import 'dart:ffi';
import 'dart:io';
// import 'dart:html';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//create stateful widget called Register
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

// create state for Register
class _RegisterState extends State<Register> {
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  bool passwordVisible = true;
  bool isChecked = false;

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Form(
            key: _formfield,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   "images/a.png",
                //   height: 150,
                //   width: 150,
                // ),
                // const SizedBox(height: 50),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
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
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your name";
                    }
                  },
                ),
                const SizedBox(height: 10),
                // show phone number as optional field

                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return "Please enter your phone";
                  //   }
                  // },
                ),
                const SizedBox(height: 10),
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
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your password";
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
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
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please confirm your password";
                    }
                  },
                ),
                // show check box for terms and conditions and privacy policy
                // check box for terms and conditions
                // show check box selected when user click on it
                Row(
                  children: const [
                    Expanded(
                      child: CheckBox(isChecked: false),
                    ),
                    // validator: (value) {
                    //   if (value == false) {
                    //     return "Please agree to the terms and conditions";
                    //   }
                    // },
                    // ),
                    // const Text("I agree to the "),
                    // TextButton(
                    //   onPressed: () {},
                    //   child: const Text("Terms and Conditions"),
                    // ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formfield.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                    }
                    final url = Uri.https(
                        'satietyapp-default-rtdb.firebaseio.com',
                        'registeredUser.json');
                    http.post(
                      url,
                      headers: {'ContentType': 'application/json'},
                      body: json.encode(
                        {
                          'email': emailController.text,
                          'password': passwordController.text,
                          'name': nameController.text,
                          'phone': phoneController.text,
                        },
                      ),
                    );
                  },
                  autofocus: const CheckBox(isChecked: false).getIsChecked(),
                  child: const Text('Register'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/LoginPage');
                      },
                      child: const Text("Login"),
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
}

// create checkbox from formfield to show terms and conditions and privacy policy
class CheckBox extends StatefulWidget {
  const CheckBox({super.key, required isChecked});
  // provide status of checkbox to be selected or not

  @override
  State<CheckBox> createState() => _CheckBoxState();

  // create function to get status of checkbox
  bool getIsChecked() {
    return _CheckBoxState().getIsChecked();
  }
}

// create state for checkbox
class _CheckBoxState extends State<CheckBox> {
  bool isChecked = false;

  @override
  // make terms and conditions as link to open in browser
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text("I agree to the "),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      // how to make Text as link to open in browser

      subtitle: InkWell(
          child: const Text(
            "Terms and Conditions",
            style: TextStyle(color: Color.fromARGB(255, 63, 75, 236)),
          ),
          onTap: () => {
                _launchURL(),
              }),
      activeColor: Colors.blue,
      checkColor: Colors.white,
    );
  }

  _launchURL() async {
    final Uri url = Uri.parse('https://flutter.dev');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  // get isChecked value to be selected or not
  bool getIsChecked() {
    return isChecked;
  }
}
