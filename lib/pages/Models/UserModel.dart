import 'dart:core';
import 'dart:io';

class User {
  late int userId;
  late String firstName;
  late String lastName;
  late String email;
  late String password;
  late String mobile;
  late String pincode;
  late String address;
  late String imageSignedUrl;
  late bool? emailVerified;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.mobile,
    required this.pincode,
    required this.address,
    required this.imageSignedUrl,
    this.emailVerified,
  });

  // Factory method to create an instance of User from a Map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      mobile: json['mobile'] ?? '',
      pincode: json['pincode'] ?? '',
      address: json['address'] ?? '',
      imageSignedUrl: json['imageSignedUrl'] ?? '',
      emailVerified: json['emailVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      //'lastName': lastName,
      'email': email,
      'password': password,
      'mobile': mobile,
      'imageSignedUrl': imageSignedUrl,
      'address': address,
    };
  }
}
