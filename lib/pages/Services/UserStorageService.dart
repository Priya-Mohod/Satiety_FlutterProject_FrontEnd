import 'dart:convert';

import '../Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorageService {
  static const _keyUser = 'user';

  static Future<void> saveUserToSharedPreferences(User user) async {
    final pref = await SharedPreferences.getInstance();
    final userJson = user.toJson();
    await pref.setString(_keyUser, jsonEncode(userJson));
  }

  static Future<User?> getUserFromSharedPreferances() async {
    final pref = await SharedPreferences.getInstance();
    final userJson = pref.getString(_keyUser);
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      final user = User.fromJson(userMap);
      return user;
    }
    return null;
  }

  static Future<void> removeUserFromSharedPreferances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('authToken');
    await prefs.remove(_keyUser);
  }

  static Future<void> saveCustomURL(String url) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('customURL', url);
  }

  static Future<String?> getCustomURL() async {
    final pref = await SharedPreferences.getInstance();
    final url = pref.getString('customURL');
    return url;
  }

  static Future<void> removeCustomURL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('customURL');
  }
}
