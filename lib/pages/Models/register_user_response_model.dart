import 'package:satietyfrontend/pages/Models/UserModel.dart';

class RegisterUserResponseModel {
  late User user;
  late String jwtToken;

  RegisterUserResponseModel({
    required this.user,
    required this.jwtToken,
  });

  // Factory method to create an instance of RegisterUserResponseModel from a Map
  factory RegisterUserResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserResponseModel(
      user: User.fromJson(json),
      jwtToken: json['jwtToken'] ?? '',
    );
  }
}
