import 'dart:io';

class FoodItem {
  final int foodId;
  final String foodName;
  final String foodDescription;
  final int foodQuantity;
  final String foodSignedUrl;
  final double foodAmount;
  final String foodType;

  FoodItem(
      {required this.foodId,
      required this.foodName,
      required this.foodDescription,
      required this.foodQuantity,
      required this.foodSignedUrl,
      required this.foodAmount,
      required this.foodType});

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
    );
  }
}
