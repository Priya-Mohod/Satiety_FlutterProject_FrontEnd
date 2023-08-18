import 'dart:convert';

import 'package:satietyfrontend/pages/Models/FoodItemModel.dart';
import 'package:satietyfrontend/pages/Models/FoodRequestsModel.dart';

import '../HTTPService/service.dart';

class MyRequestsViewModel {
  Service service = Service();

  Future<List<FoodRequest>> fetchRequests() async {
    // Simulate fetching data from the server
    // Replace this with actual server API calls
    await Future.delayed(Duration(seconds: 2));
    try {
      final response = await service.getMyRequests();
      if (response != null && response.statusCode == 200) {
        //List<Map<String, dynamic>> data = jsonDecode(response.body);
        final serverResponse = json.decode(response.body);
        return mapServerResponse(serverResponse);
        print(serverResponse);
      } else if (response != null) {
        // Handle error response
        print('Error: ${response.statusCode}');
      } else {
        // Unable to send data to server
        print('Unable to send data to server');
      }
    } catch (e) {
      print('Exception at fetchListings: $e');
    }
    return [];
  }

  Future<List<FoodRequest>> mapServerResponse(
      List<dynamic> serverResponse) async {
    List<FoodRequest> dataList = [];

    for (var json in serverResponse) {
      FoodRequest foodRequestItem =
          FoodRequest.fromJson(json as Map<String, dynamic>);

      dataList.add(
        foodRequestItem,
      );
    }
    return dataList;
  }

  Future<bool> onRequestCancelClick(int requestId) async {
    return await service.declineRequest(requestId);
  }
}
