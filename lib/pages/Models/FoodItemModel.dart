import 'dart:io';

import 'package:satietyfrontend/pages/Constants/Utilities/ParsingUtils.dart';

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
  final String? allergies;
  final String? isRequestedByLoggedInUser;
  final String? addedTime;
  final String? distanceInKm;
  // final DateTime? availableFrom;
  // final DateTime? availableTo;

  FoodItem({
    required this.foodId,
    required this.foodName,
    required this.foodDescription,
    required this.foodQuantity,
    required this.foodSignedUrl,
    required this.foodAmount,
    required this.foodType,
    required this.allergies,
    required this.addedByUserName,
    required this.foodAddress,
    required this.latitude,
    required this.longitude,
    required this.addedByUserImageUrl,
    required this.addedByUserId,
    required this.isRequestedByLoggedInUser,
    required this.addedTime,
    required this.distanceInKm,
    // required this.availableFrom,
    // required this.availableTo,
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
      allergies: json['allergies'],
      addedByUserName: json['addedByUserName'],
      foodAddress: json['foodAddress'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      addedByUserImageUrl: json['addedByUserImageUrl'],
      addedByUserId: json['addedByUserId'],
      isRequestedByLoggedInUser: json['isRequestedByLoggedInUser'],
      addedTime: json['addedTime'],
      distanceInKm: json['distanceInKm'] != null
          ? ParsingUtils.parseDoubleTo1Point(json['distanceInKm'])
          : '',
      // availableFrom: json['availableFrom'],
      // availableTo: json['availableTo'],
    );
  }
}
