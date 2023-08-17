import 'FoodItemModel.dart';

class FoodRequest {
  String requestedUserImageUrl;
  String requestedUserName;
  int requestId;
  String acceptedFlag;

  FoodRequest({
    required this.requestedUserImageUrl,
    required this.requestedUserName,
    required this.requestId,
    required this.acceptedFlag,
  });

  factory FoodRequest.fromJson(Map<String, dynamic> json) {
    return FoodRequest(
      requestedUserImageUrl: json['requestedUserImageUrl'],
      requestedUserName: json['requestedUserName'],
      requestId: json['requestId'],
      acceptedFlag: json['acceptedFlag'],
    );
  }
}

class MyListingsDTO {
  final FoodItem foodItem;
  final List<FoodRequest> foodRequestsList;

  MyListingsDTO({
    required this.foodItem,
    required this.foodRequestsList,
  });
}
