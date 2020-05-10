import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:hype_learning/config/constants.dart';
import 'package:hype_learning/providers/profile.dart';
import '../config/constants.dart';
import './profile.dart';

class Profiles with ChangeNotifier {
  Profile _profile;
  List<Profile> _profiles = [];
  String authToken;
  int userId;

  Profiles();

  Profile get profile {
    return _profile;
  }

  List<Profile> get users {
    return [..._profiles];
  }

  Profile findById(int id) {
    return _profiles.firstWhere((profile) => profile.id == id);
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

  Future<void> fetchAndSetUsers() async {
    var url = Constants.API_URL + 'users/management';
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
      );
      final extractedData = json.decode(response.body).toList();
      if (extractedData == null) {
        return;
      }
      final List<Profile> loadedProfiles = [];
      extractedData.forEach((profileData) {
        loadedProfiles.add(Profile(
          id: profileData['id'],
          firstName: profileData['firstName'],
          lastName: profileData['lastName'],
          email: profileData['email'],
          role: profileData['role'],
          isBlocked: profileData['isBlocked'],
        ));
      });
      _profiles = loadedProfiles;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> changeStatus(int id, Profile profile) async {
    final url = Constants.API_URL + 'users/management/changeStatus/$id';

    final profileIndex = _profiles.indexWhere((profile) => profile.id == id);
    if (profileIndex >= 0) {
      try {
        var request = http.MultipartRequest("PUT", Uri.parse(url));
        request.headers.addAll({
          'Authorization': 'Bearer ' + this.authToken,
        });

        var response = await http.Response.fromStream(await request.send());

        final editedProfile = Profile(
          id: profile.id,
          email: profile.email,
          firstName: profile.firstName,
          lastName: profile.lastName,
          role: profile.role,
          isBlocked: json.decode(response.body)['isBlocked']
        );
        _profiles[profileIndex] = editedProfile;

        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }
}


