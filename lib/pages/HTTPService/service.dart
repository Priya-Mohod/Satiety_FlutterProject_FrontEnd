import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class Service {
  String url = "http://192.168.0.89:8080";

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
    request.fields['foodAmount'] = '0.0';
    // latitude -
    request.fields['latitude'] = '$latitude';
    // longitude -
    request.fields['longitude'] = '$longitude';
    // Allergy -
    request.fields['allergies'] = allergyString;

    // Add the MultipartFile to the request
    request.files.add(multipartFile);

    // Send the form data request
    print(request);
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      // File upload successful
      print('Food data uploaded successfully');
      return true;
      // send response back to caller function
    } else {
      // File upload failed
      print('Food data failed with status code ${response.statusCode}');
      return false;
    }
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
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      // File upload successful
      print('Food data uploaded successfully');
      return true;
      // send response back to caller function
    } else {
      // File upload failed
      print('Food data failed with status code ${response.statusCode}');
      return false;
    }
  }

  Future<Response?> fetchFoodData() async {
    try {
      // Replace this URL with the actual URL of your server
      final response =
          await http.get(Uri.parse('http://192.168.0.89:8080/getAllFood'));
      return response;
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');
    }

    return null;
  }
}
