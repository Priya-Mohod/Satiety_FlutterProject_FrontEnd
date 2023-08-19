import 'FoodItemModel.dart';

class FoodRequest {
  String? requestedUserImageUrl;
  String? requestedUserName;
  int requestId;
  String? acceptedFlag;
  String? requestedAt; // TODO: Remove the nullable
  String? acceptedAt; // TODO: Remove the nullable

  FoodItem? foodItem;

  FoodRequest({
    required this.requestedUserImageUrl,
    required this.requestedUserName,
    required this.requestId,
    required this.acceptedFlag,
    required this.requestedAt,
    required this.acceptedAt,
    required this.foodItem,
  });

  factory FoodRequest.fromJson(Map<String, dynamic> json) {
    return FoodRequest(
      requestedUserImageUrl: json['requestedUserImageUrl'],
      requestedUserName: json['requestedUserName'],
      requestId: json['requestId'],
      acceptedFlag: json['acceptedFlag'],
      requestedAt: json['requestedAt'],
      acceptedAt: json['acceptedAt'],
      foodItem:
          json['foodBean'] != null ? FoodItem.fromJson(json['foodBean']) : null,
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
