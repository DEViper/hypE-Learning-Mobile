import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:hype_learning/config/constants.dart';
import 'package:hype_learning/providers/auth.dart';
import 'package:hype_learning/providers/profile.dart';
import '../config/constants.dart';
import '../models/http_exception.dart';
import './profile.dart';

class Profiles with ChangeNotifier {
  Profile _profile;
  String authToken;
  int userId;

  Profiles();

  Profile get profile {
    return _profile;
  }

  Profiles update(authToken, userId, _profile) {
    this.authToken = authToken;
    this.userId = userId;
    this._profile = _profile;
    return this;
  }

  Future<void> updateProfile(int id, Profile profile, String fileUrl) async {
    final url = Constants.API_URL + 'users/$id';
    try {
      var request = http.MultipartRequest("PUT", Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer ' + this.authToken,
      });

      request.fields['email'] = profile.email;
      request.fields['password'] = profile.password;
      request.files.add(await http.MultipartFile.fromPath('file', fileUrl,
          contentType: MediaType('image', 'jpeg')));
      var response = await http.Response.fromStream(await request.send());

      final editedProfile = Profile(
        email: profile.email,
        password: profile.password,
        fileUrl: json.decode(response.body)['fileUrl'],
      );
      _profile = editedProfile;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
