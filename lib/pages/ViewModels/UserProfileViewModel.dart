import 'package:satietyfrontend/pages/Models/UserModel.dart';
import 'package:satietyfrontend/pages/Services/Utility.dart';

import '../Services/UserStorageService.dart';

class UserProfileViewModel {
  User? currentUser;

  User? parseUserData(Map<String, dynamic> responseData) {
    try {
      final user = User.fromJson(responseData);
      return user;
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<String> getCurrentUserName() async {
    // Get the user data from the shared preferences
    User? currentUser = await UserStorageService.getUserFromSharedPreferances();
    if (currentUser != null) {
      return currentUser.firstName;
    } else {
      return '';
    }
  }

  Future<String> getCurrentUserImage() async {
    // Get the user data from the shared preferences
    User? currentUser = await UserStorageService.getUserFromSharedPreferances();
    return currentUser?.imageSignedUrl ?? '';
  }

  Future<User> fetchUserProfile() async {
    if (currentUser == null) {
      currentUser = await UserStorageService.getUserFromSharedPreferances();
    }
    return currentUser!;
  }
}
