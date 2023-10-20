import 'dart:convert';

import '../HTTPService/service.dart';
import '../Models/FoodItemModel.dart';
import '../Models/FoodRequestsModel.dart';

class MyListingsViewModel {
  Service service = Service();

  Future<List<MyListingsDTO>> fetchListings() async {
    // Simulate fetching data from the server
    // Replace this with actual server API calls
    //await Future.delayed(Duration(seconds: 2));
    try {
      final response = await service.getMyListings();
      if (response != null && response.statusCode == 200) {
        //List<Map<String, dynamic>> data = jsonDecode(response.body);
        final serverResponse = json.decode(response.body);
        return mapServerResponse(serverResponse.cast<Map<String, dynamic>>());
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

  Future<List<MyListingsDTO>> mapServerResponse(
      List<Map<String, dynamic>> serverResponse) async {
    List<MyListingsDTO> dataList = [];

    for (var json in serverResponse) {
      List<FoodRequest> foodRequestsList = [];
      if (json['foodRequestsList'] != null) {
        foodRequestsList = (json['foodRequestsList'] as List<dynamic>)
            .map((requestJson) => FoodRequest.fromJson(requestJson))
            .toList();
      }

      FoodItem foodItem = FoodItem.fromJson(json);

      dataList.add(MyListingsDTO(
        foodItem: foodItem,
        foodRequestsList: foodRequestsList,
      ));
    }

    return dataList;
  }

  Future<bool> onRequestAcceptClick(int requestId) async {
    return await service.acceptRequest(requestId);
  }

  Future<bool> onRequestDeclineClick(int requestId) async {
    return await service.declineRequest(requestId);
  }

  // TODO: In future, we need to handle the case where the request is already accepted
  Future<bool> onRequestCancelClick(int requestId) async {
    // return await service.cancelRequest(requestId);
    return true;
  }
}
