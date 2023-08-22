import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/URLConstants.dart';
import 'package:satietyfrontend/pages/Views/Loginpage.dart';

import '../Services/UserStorageService.dart';
import 'SnackbarHelper.dart';

class CustomURL extends StatefulWidget {
  @override
  _CustomURLState createState() => _CustomURLState();
}

class _CustomURLState extends State<CustomURL> {
  final _formfield = GlobalKey<FormState>();
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserStorageService.getCustomURL().then((value) {
      if (value != null) {
        urlController.text = value;
      } else {
        urlController.text = URLConstants.url;
      }
    });
  }

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
                  keyboardType: TextInputType.url,
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'Enter URL',
                    hintText: 'Enter URL',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formfield.currentState!.validate()) {
                      UserStorageService.saveCustomURL(urlController.text);
                      SnackbarHelper("URL saved successfully");
                      // pop screen
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            )),
      )),
    );
  }
}
