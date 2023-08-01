import 'dart:ffi';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import '../Constatnts/StringConstants.dart';
import '../Constatnts/URLConstants.dart';
import '../Views/SnackbarHelper.dart';

class Service {
  String url = URLConstants.url;

  // -- Login User
  Future<Response?> loginUser(String email, String password) async {
    try {
      // Replace this URL with the actual URL of your server
      final response = await http.post(
        Uri.parse('$url/loginUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{'email': email, 'password': password},
        ),
      );
      return response;
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');
    }

    return null;
  }

  Future<bool> sendFoodDetailsWithFile(
    String foodName,
    String foodDescription,
    int foodQuantity,
    String foodAddress, // Not Provided in code Yet
    String foodImageUri, // Not Provided in code Yet
    String foodType,
    File? image,
    double latitude,
    double longitude,
    String allergyString,
    String foodAmount,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse('$url/addfood'));

    // Create a MultipartFile from the file you want to upload
    // Food Image - sent using multipart request
    File file = image!;
    var fileStream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile('file', fileStream, length,
        filename: path.basename(file.path));
    // Food Name -
    request.fields['foodName'] = foodName;
    // Food Description -
    request.fields['foodDescription'] = foodDescription;
    // Food Quantity -
    request.fields['foodQuantity'] = '$foodQuantity';
    // Food Address -
    request.fields['foodAddress'] = foodAddress;
    // Food Food Type - // Veggies - Veg / Non-Veg / Vegan /
    request.fields['foodType'] = foodType;
    // Food Amount - Free / Chargeable
    double amount = 0.0;
    if (foodAmount.isNotEmpty) {
      double doubleValue = double.parse(foodAmount);
      double roundedValue = double.parse(doubleValue.toStringAsFixed(1));
      amount = roundedValue;
    }
    request.fields['foodAmount'] = '$amount';
    // latitude -
    request.fields['latitude'] = '$latitude';
    // longitude -
    request.fields['longitude'] = '$longitude';
    // Allergy -
    request.fields['allergies'] = allergyString;

    // Add the MultipartFile to the request
    request.files.add(multipartFile);

    var response = await makeServerRequest(request);

    // Handle the response
    if (response != null && response.statusCode == 200) {
      // File upload successful
      print('Food data uploaded successfully');
      return true;
      // send response back to caller function
    } else if (response != null) {
      // File upload failed
      print('Food data failed with status code ${response.statusCode}');
      return false;
    }

    return false;
  }

  Future<bool> registerUser(
      File? userImage,
      String firstName,
      String lastName,
      String password,
      String mobile,
      String email,
      String pincode,
      String address) async {
    var request = http.MultipartRequest('POST', Uri.parse('$url/registerUser'));
    var multipartFile;
    // User Image - sent using multipart request
    if (userImage != null) {
      File file = userImage!;
      var fileStream = http.ByteStream(file.openRead());
      var length = await file.length();
      multipartFile = http.MultipartFile('file', fileStream, length,
          filename: path.basename(file.path));
    }
    // User Firstname -
    request.fields['firstName'] = firstName;
    // User Lastname -
    request.fields['lastName'] = lastName;
    // User Password -
    request.fields['password'] = password;
    // User Mobile -
    request.fields['mobile'] = mobile;
    // User Email -
    request.fields['email'] = email;
    // User Pincode -
    request.fields['pincode'] = pincode;
    // User Address -
    request.fields['address'] = address;

    // Add the MultipartFile to the request
    if (multipartFile != null) {
      request.files.add(multipartFile);
    }

    // Send the form data request
    print(request);
    var response = await makeServerRequest(request);

    // Handle the response
    if (response != null && response.statusCode == 200) {
      // File upload successful
      print('Food data uploaded successfully');
      return true;
      // send response back to caller function
    } else if (response != null) {
      // File upload failed
      print('Food data failed with status code ${response.statusCode}');
      return false;
    }
    return false;
  }

  Future<Response?> fetchFoodData() async {
    try {
      // Replace this URL with the actual URL of your server
      final response = await http.get(Uri.parse('$url/getAllFood'));
      return response;
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');
    }

    return null;
  }

  // TODO - Check Email Exists
  Future<bool> checkUserEmailExist(String email) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$url/getUserByEmail'));
      request.fields['email'] = email;
      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');
      return false;
    }
  }

  Future<bool> checkUserPhoneNumber(String phone) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$url/getUserByMobile'));
      request.fields['mobile'] = phone;
      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');
      return false;
    }
  }

  // Verify User OTP using Email
  Future<bool> verifyUserOTP(String email, int otp) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$url/verifyUserEmail'));
      request.fields['email'] = email;
      request.fields['emailOtp'] = otp.toString();
      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');

      return false;
    }
  }

  // Check internet connectivity before making server call
  Future<http.StreamedResponse?> makeServerRequest(
      MultipartRequest request) async {
    bool isConnected = await checkInternetConnectivity();
    if (isConnected) {
      var response = await request.send();
      return response;
    } else {
      // Show snack bar with no internet connection
      SnackbarHelper(StringConstants.internet_error);
      return null;
    }
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      return false;
    } else {
      // Internet connection is available
      return true;
    }
  }
}
