import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class Service {
  Future<bool> sendFoodDetailsWithFile(
      String foodName,
      String foodDescription,
      int foodQuantity,
      String foodAddress,
      String foodImageUri,
      String foodType,
      File? image,
      double latitude,
      double longitude) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.0.89:8080/addfood'));

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
    // Food Food Type -
    request.fields['foodType'] = foodType;
    // Food Amount - Free / Chargeable
    request.fields['foodAmount'] = '0.0';
    // Veggies - Veg / Non-Veg / Vegan /  Both - TODO : Change the name of the field
    request.fields['veggies'] = foodType;
    // latitude -
    request.fields['latitude'] = '$latitude';
    // longitude -
    request.fields['longitude'] = '$longitude';

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
}
