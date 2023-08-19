import 'dart:io';

class FoodItem {
  final int foodId;
  final String foodName;
  final String foodDescription;
  final int foodQuantity;
  final String foodSignedUrl;
  final double foodAmount;
  final String foodType;
  final String addedByUserName;
  final String foodAddress;
  final double latitude;
  final double longitude;
  final String addedByUserImageUrl;
  final int addedByUserId;

  FoodItem({
    required this.foodId,
    required this.foodName,
    required this.foodDescription,
    required this.foodQuantity,
    required this.foodSignedUrl,
    required this.foodAmount,
    required this.foodType,
    required this.addedByUserName,
    required this.foodAddress,
    required this.latitude,
    required this.longitude,
    required this.addedByUserImageUrl,
    required this.addedByUserId,
  });

  // Factory method to create a FoodItem from JSON
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodId: json['foodId'],
      foodName: json['foodName'],
      foodDescription: json['foodDescription'],
      foodQuantity: json['foodQuantity'],
      foodSignedUrl: json['foodSignedUrl'],
      foodAmount: json['foodAmount'],
      foodType: json['foodType'],
      addedByUserName: json['addedByUserName'],
      foodAddress: json['foodAddress'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      addedByUserImageUrl: json['addedByUserImageUrl'],
      addedByUserId: json['addedByUserId'],
    );
  }
}
