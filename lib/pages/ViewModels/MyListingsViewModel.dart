import 'dart:convert';

import 'package:flutter/material.dart';
import '../HTTPService/service.dart';
import '../Models/FoodItemModel.dart';
import '../Models/FoodRequestsModel.dart';

class MyListingsViewModel {
  Service service = Service();

  Future<Map<FoodItem, List<FoodRequest>>?> fetchListings() async {
    // Simulate fetching data from the server
    // Replace this with actual server API calls
    await Future.delayed(Duration(seconds: 2));
    try {
      final response = await service.getMyListings();
      if (response != null && response.statusCode == 200) {
        //List<Map<String, dynamic>> data = jsonDecode(response.body);
        final serverResponse = json.decode(response.body);
        return mapServerResponse(serverResponse.cast<Map<String, dynamic>>());
      } else if (response != null) {
        // Handle error response
        print('Error: ${response.statusCode}');
        return null;
      } else {
        // Unable to send data to server
        print('Unable to send data to server');
        return null;
      }
    } catch (e) {
      print('Exception at fetchListings: $e');
    }
  }

  Map<FoodItem, List<FoodRequest>> mapServerResponse(
      List<Map<String, dynamic>> serverResponse) {
    Map<FoodItem, List<FoodRequest>> dataMap = {};

    for (var json in serverResponse) {
      List<FoodRequest> foodRequestsList =
          (json['foodRequestsList'] as List<dynamic>)
              .map((requestJson) => FoodRequest.fromJson(requestJson))
              .toList();

      FoodItem foodItem = FoodItem.fromJson(json);
      dataMap[foodItem] = foodRequestsList;
    }

    return dataMap;
  }
}
