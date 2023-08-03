import 'package:satietyfrontend/pages/Models/UserModel.dart';

class UserViewModel {
  User? parseUserData(Map<String, dynamic> responseData) {
    try {
      final user = User.fromJson(responseData);
      return user;
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
