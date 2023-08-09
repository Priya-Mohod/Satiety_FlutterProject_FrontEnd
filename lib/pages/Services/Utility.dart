import 'dart:convert';

import 'package:satietyfrontend/pages/HTTPService/service.dart';

import '../Models/UserModel.dart';
import '../ViewModels/UserViewModel.dart';
import 'UserStorageService.dart';

class AppUtil {
  var service = Service();
  User? user;

  Future<bool> getUserDataUsingEmail(String email) async {
    var response = await service.fetchUserDataUsingEmail(email);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> responseData =
          jsonDecode(await response.stream.bytesToString());
      var userViewModel = UserViewModel();
      final user = userViewModel.parseUserData(responseData);
      if (user != null) {
        await UserStorageService.saveUserToSharedPreferences(user);
      }
      return true;
    } else {
      return false;
    }
  }

  Future<User?> getUserUsingEmail(String email) async {
    var response = await service.fetchUserDataUsingEmail(email);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> responseData =
          jsonDecode(await response.stream.bytesToString());
      var userViewModel = UserViewModel();
      user = userViewModel.parseUserData(responseData);
      if (user != null) {
        return user;
      } else {
        return null;
      }
    }
    return null;
  }
}
