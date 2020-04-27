import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hype_learning/config/constants.dart';

import '../models/http_exception.dart';
import './course.dart';

class Courses with ChangeNotifier {
  List<Course> _courses = [];
  String authToken;
  int userId;

  Courses();

  List<Course> get courses {
    return [..._courses];
  }


  Courses update(authToken, userId, _courses) {
    this.authToken = authToken;
    this.userId = userId;
    this._courses = _courses;
    return this;
  }

  Course findById(int id) {
    return _courses.firstWhere((course) => course.id == id);
  }

  Future<void> fetchAndSetCourses() async {
    var url = Constants.API_URL + 'courses';
    try {
      final response = await http.get(
        url,
        headers: {HttpHeaders.authorizationHeader: this.authToken},
      );
      final extractedData = json.decode(response.body).toList();
      if (extractedData == null) {
        return;
      }
      final List<Course> loadedCourses = [];
      extractedData.forEach((courseData) {
        loadedCourses.add(Course(
          id: courseData['id'],
          title: courseData['title'],
          description: courseData['description'],
          announcement: courseData['announcement'],
        ));
      });
      _courses = loadedCourses;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // Future<void> addCourse(Course Course) async {
  //   final url =
  //       'https://flutter-update.firebaseio.com/Courses.json?auth=$authToken';
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode({
  //         'title': Course.title,
  //         'description': Course.description,
  //         'imageUrl': Course.imageUrl,
  //         'price': Course.price,
  //         'creatorId': userId,
  //       }),
  //     );
  //     final newCourse = Course(
  //       title: Course.title,
  //       description: Course.description,
  //       price: Course.price,
  //       imageUrl: Course.imageUrl,
  //       id: json.decode(response.body)['name'],
  //     );
  //     _courses.add(newCourse);
  //     // _courses.insert(0, newCourse); // at the start of the list
  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  // Future<void> updateCourse(String id, Course newCourse) async {
  //   final courseIndex = _courses.indexWhere((course) => course.id == id);
  //   if (courseIndex >= 0) {
  //     final url =
  //         'https://flutter-update.firebaseio.com/Courses/$id.json?auth=$authToken';
  //     await http.patch(url,
  //         body: json.encode({
  //           'title': newCourse.title,
  //           'description': newCourse.description,
  //           'imageUrl': newCourse.imageUrl,
  //           'price': newCourse.price
  //         }));
  //     _courses[courseIndex] = newCourse;
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  // }

  // Future<void> deleteCourse(String id) async {
  //   final url =
  //       'https://flutter-update.firebaseio.com/Courses/$id.json?auth=$authToken';
  //   final existingCourseIndex = _courses.indexWhere((course) => course.id == id);
  //   var existingCourse = _courses[existingCourseIndex];
  //   _courses.removeAt(existingCourseIndex);
  //   notifyListeners();
  //   final response = await http.delete(url);
  //   if (response.statusCode >= 400) {
  //     _courses.insert(existingCourseIndex, existingCourse);
  //     notifyListeners();
  //     throw HttpException('Could not delete Course.');
  //   }
  //   existingCourse = null;
  // }
}
