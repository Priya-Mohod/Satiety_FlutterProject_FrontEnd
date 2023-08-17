import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/UserStorageService.dart';

class LoginViewModel with ChangeNotifier {
  Service service = Service();
  Future<bool> loginUser(String email, String password) async {
    // Make the API call and handle the response
    // You can use http package or any other API library here
    // Update the state using notifyListeners()
    // TODO : Remove this method once Logout is implemented
    UserStorageService.removeUserFromSharedPreferances();
    var response = await service.loginUser(email, password);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      String token = responseJson['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('authToken', token);
      return true;
    } else {
      return false;
    }
  }

  //  Future<void> getUserDataUsingEmail(String email) async {
  //   if (await AppUtil().getUserDataUsingEmail(email) == true) {
  //     // ignore: use_build_context_synchronously
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ListViewPage(),
  //         ));
  //   } else {
  //     SnackBar(
  //       content: Text(StringConstants.login_user_not_found,
  //           style: const TextStyle(
  //             color: Colors.black,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 20,
  //           )),
  //     );
  //   }
  // }
}
