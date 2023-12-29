import 'dart:developer';
import 'dart:io';

import 'package:satietyfrontend/pages/Models/UserModel.dart';
import 'package:satietyfrontend/pages/HTTPService/service.dart';
import '../Services/UserStorageService.dart';

class UserProfileViewModel {
  User? currentUser;
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

  Future<bool> isPhoneExists(String phone) async {
    var response = await service.checkUserPhoneNumber(phone);
    return response;
  }

  Future<bool> isEmailExists(String email) async {
    var response = await service.fetchUserDataUsingEmail(email);
    if (response != null && response.statusCode == 200) {
      return true;
    } else if (response != null && response.statusCode != 200) {
      return false;
    } else {
      // ignore: use_build_context_synchronously
      // SnackbarHelper.showSnackBar(context, StringConstants.exception_error);
      return false;
    }
  }

  Future<bool> updateUserProfile(
    File? userImage,
    String firstName,
    String lastName,
    String password,
    String mobile,
    String email,
    String pincode,
    String address,
    double latitude,
    double longitude,
  ) async {
    var response = await service.registerUser(userImage, firstName, lastName,
        password, mobile, email, pincode, address, latitude, longitude, false);
    // *** Get register user response
    return true; //response;
  }
}
