import 'dart:convert';

import 'package:satietyfrontend/pages/HTTPService/service.dart';

import '../ViewModels/UserViewModel.dart';
import 'UserStorageService.dart';

class AppUtil {
  var service = Service();

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
}
