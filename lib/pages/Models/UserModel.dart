import 'dart:core';
import 'dart:io';

class User {
  final int userId;
  final String firstName;
  //final String lastName;
  final String email;
  final String password;
  final String mobile;
  //final String pincode;
  //final String address;
  final String? imageSignedUrl;

  User(
      {required this.userId,
      required this.firstName,
      //required this.lastName,
      required this.email,
      required this.password,
      required this.mobile,
      //required this.pincode,
      //required this.address,
      this.imageSignedUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        firstName: json['firstName'],
        //lastName: json['lastName'],
        email: json['email'],
        password: json['password'],
        mobile: json['mobile'],
        //pincode: json['pincode'],
        //address: json['address'],
        imageSignedUrl: json['imageSignedUrl']);
  }

  toJson() {}
}
