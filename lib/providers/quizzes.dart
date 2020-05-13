import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hype_learning/config/constants.dart';
import 'package:hype_learning/providers/profile.dart';
import 'package:hype_learning/providers/quiz.dart';
import '../config/constants.dart';
import '../models/http_exception.dart';
import './quiz.dart';

class Quizzes with ChangeNotifier {
  List<Quiz> _quizzes = [];
  String authToken;
  int userId;

  Quizzes();

  List<Quiz> get quizzes {
    return [..._quizzes];
  }

 Quizzes update(authToken, userId, _quizzes) {
    this.authToken = authToken;
    this.userId = userId;
    this._quizzes = _quizzes;
    return this;
  }

  Quiz findById(int id) {
    return _quizzes.firstWhere((quiz) => quiz.id == id);
  }

 

 Future<void> fetchAndSetQuiz(int quizId) async {
    var url = Constants.API_URL + 'quizzes/' + quizId.toString();
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
      );
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
       final Quiz loadedQuiz = Quiz(
            id: extractedData['id'],
            title: extractedData['title'],
      );
      _quizzes.add(loadedQuiz);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }






  Future<void> addQuiz(int id,Quiz quiz) async {
    final url = Constants.API_URL + 'quizzes/$id';
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'title': quiz.title,
    
        }),
      );
      final newQuiz = Quiz(
        title: quiz.title,

        id: json.decode(response.body)['id'],
      );
      _quizzes.add(newQuiz);
      // _Quizs.insert(0, newQuiz); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateQuiz(int id, Quiz newQuiz) async {
    final quizIndex = _quizzes.indexWhere((quiz) => quiz.id == id);
    if (quizIndex >= 0) {
       final url = Constants.API_URL + 'quizzes/$id';
      await http.put(url,headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
          body: json.encode({
            'title': newQuiz.title,

          }));
      _quizzes[quizIndex] = newQuiz;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteQuiz(int id) async {
    final url = Constants.API_URL + 'quizzes/$id';
    final existingQuizIndex =
        _quizzes.indexWhere((quiz) => quiz.id == id);
    var existingQuiz = _quizzes[existingQuizIndex];
    _quizzes.removeAt(existingQuizIndex);
    notifyListeners();
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ' + this.authToken,
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode >= 400) {
      _quizzes.insert(existingQuizIndex, existingQuiz);
      notifyListeners();
      throw HttpException('Nie można usunąć quizu.');
    }
    existingQuiz = null;
  }


 





}
