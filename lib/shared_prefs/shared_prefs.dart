import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DataSharedPreferences {
  final String _userKey = 'user';

  Future<void> saveUser(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_userKey, jsonEncode(userData));
  }

  Future<String> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey) ?? '';
  }

  removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_userKey);
  }
}
