import 'dart:convert';

import 'package:satietyfrontend/pages/HTTPService/service.dart';
import 'package:satietyfrontend/pages/Models/UserModel.dart';
import 'package:satietyfrontend/pages/Services/UserStorageService.dart';

class PublicProfileViewModel {
  User? loggedInUser;
  Service service = Service();

  User? parseUserData(Map<String, dynamic> responseData) {
    try {
      final user = User.fromJson(responseData);
      return user;
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<User> fetchUserProfile() async {
    if (loggedInUser == null) {
      loggedInUser = await UserStorageService.getUserFromSharedPreferances();
    }
    return loggedInUser!;
  }

  Future<User?> fetchedUserDataById(int userId) async {
    var response = await service.fetchedUserDataById(userId);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> responseData =
          jsonDecode(await response.stream.bytesToString());
      final user = parseUserData(responseData);
      if (user != null) {
        return user;
      } else {
        return null;
      }
    }
    return null;
  }
}
