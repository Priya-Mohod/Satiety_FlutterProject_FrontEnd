import 'dart:ffi';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/FoodItemModel.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';

class FoodListViewModel with ChangeNotifier {
  List<FoodItem> _foodList = [];
  List<FoodItem> get foodList => _foodList;
  Service service = Service();

  // Method to fetch data from the server and update the _foodList
  Future<bool> fetchFoodData() async {
    try {
      // Replace this URL with the actual URL of your server
      final response = await service.fetchFoodData();
      if (response != null && response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _foodList = data.map((item) => FoodItem.fromJson(item)).toList();
        notifyListeners();
        return true;
      } else if (response != null) {
        // Handle error response
        print('Error: ${response.statusCode}');
      } else {
        // Unable to send data to server
        print('Unable to send data to server');
      }
      return false;
    } catch (e) {
      // Handle any exceptions
      // print('Exception: $e',StackTrace);
      // FirebaseCrashlytics.instance.recordError(e, stackTrace);
      return false;
    }
  }
}
