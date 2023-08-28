import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:satietyfrontend/pages/Constants/FirebaseSetup.dart';
import 'package:satietyfrontend/pages/Constants/URLConstants.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/UserStorageService.dart';

class LoginViewModel with ChangeNotifier {
  Service service = Service();
  Future<bool> loginUser(String email, String password) async {
    // TODO : Remove this method once Logout is implemented
    UserStorageService.removeUserFromSharedPreferances();
    var response = await service.loginUser(email, password);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      String token = responseJson['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('authToken', token);
      FirebaseSetup().addData({'email': email}, 'user');
      return true;
    } else {
      return false;
    }
  }

  Future<String> getUrlInUse() async {
    String? customURL = await UserStorageService.getCustomURL();
    if (customURL != null) {
      return customURL;
    } else {
      return URLConstants.url;
    }
  }
}
