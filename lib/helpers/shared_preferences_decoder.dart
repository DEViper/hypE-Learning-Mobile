import 'dart:convert';

import 'package:hype_learning/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDecoder {
  static getUser() {
    final userData = sharedPrefs.getString('userData');
    final user = jsonDecode(userData);
    return user;
  }

  static getField(String neededData) {
    final user = getUser();
    final data = user[neededData];

    return data;
  }
}
