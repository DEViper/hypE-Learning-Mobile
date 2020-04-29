import 'dart:convert';

import 'package:hype_learning/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDecoder {
  static getRole()  {
    final userData = sharedPrefs.getString('userData');
    final user = jsonDecode(userData);
    final role = user["role"];

    return role;
  }
}
