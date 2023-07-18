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
  Future<void> sendFoodDetailsWithFile(
      String foodName,
      String foodDescription,
      int foodQuantity,
      String foodAddress,
      String foodImageUri,
      String foodType,
      File? image) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.0.89:8080/addfood'));

    // Add other form fields if needed
    request.fields['foodName'] = foodName;
    request.fields['foodDescription'] = foodDescription;
    request.fields['foodQuantity'] = '$foodQuantity';
    request.fields['foodAddress'] = foodAddress;
    request.fields['foodType'] = foodType;

    // Create a MultipartFile from the file you want to upload
    File file = image!;
    var fileStream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile('file', fileStream, length,
        filename: path.basename(file.path));

    // Add the MultipartFile to the request
    request.files.add(multipartFile);

    // Send the form data request
    print(request);
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      // File upload successful
      print('File uploaded successfully');
    } else {
      // File upload failed
      print('File upload failed with status code ${response.statusCode}');
    }
  }
}
