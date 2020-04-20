import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hype_learning_flutter/main.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UserRepository {
  var url = 'http://10.0.2.2:3000/auth/signin';

  Future<String> authenticate({
    @required String email,
    @required String password,
  }) async {
    Map requestData = {
      'email': email,
      'password': password
    };

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode(requestData)
    );
    if (response.statusCode == 201) {
      var jsonResponse = convert.jsonDecode(response.body);
      var accessToken = jsonResponse['accessToken'];
      print(accessToken);
      // await getIt.isReady<FlutterSecureStorage>().then((_) => getIt<FlutterSecureStorage>().write(key: "token", value: accessToken));

      return accessToken;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return "Fail";
    }
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await getIt<FlutterSecureStorage>().write(key: "token", value: token);
    var xd = await getIt<FlutterSecureStorage>().read(key: "token");

    print("XD => " + xd);


    return;
  }

  Future<bool> hasToken() async {
    var token = await getIt<FlutterSecureStorage>().read(key: "token");
    return token != null ? true : false;
  }
}
