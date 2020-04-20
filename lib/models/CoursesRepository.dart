import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hype_learning_flutter/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:hype_learning_flutter/courses/course.dart';
import 'package:hype_learning_flutter/main.dart';

class CoursesRepository {
  var api = url + "/courses";
  Future<List<Course>> findAll() async {
    var token = await getIt<FlutterSecureStorage>().read(key: "token");
    var response = await http.get(
      api,
      headers: {'Authorization': "Bearer " + token,'Content-Type': 'application/json'},

    );
    if (response.statusCode == 200) {
      var courses = convert.jsonDecode(response.body);
      print(courses);

      return courses;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('error fetching courses');
    }
  }
}
