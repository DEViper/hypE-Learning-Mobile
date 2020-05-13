import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:hype_learning/config/constants.dart';
import 'package:hype_learning/providers/profile.dart';
import 'package:hype_learning/providers/quiz.dart';
import 'package:hype_learning/providers/solution.dart';
import '../config/constants.dart';
import '../models/http_exception.dart';
import './topic.dart';

class Topics with ChangeNotifier {
  List<Topic> _topics = [];
  List<Solution> _solutions = [];
  String authToken;
  int userId;

  Topics();

  List<Topic> get topics {
    return [..._topics];
  }

  List<Solution> get solutions {
    return [..._solutions];
  }

  Topics update(authToken, userId, _topics) {
    this.authToken = authToken;
    this.userId = userId;
    this._topics = _topics;
    return this;
  }

  Topic findById(int id) {
    return _topics.firstWhere((topic) => topic.id == id);
  }

  Future<void> fetchAndSetStudentTopics() async {
    _topics = new List<Topic>();
    var url = Constants.API_URL + 'users/Topics';
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
      );
      final extractedData =
          json.decode(response.body).toList(); //check if unathorized
      if (extractedData == null) {
        return;
      }
      final List<Topic> loadedTopics = [];
      extractedData.forEach((topicData) {
        loadedTopics.add(Topic(
          id: topicData['id'],
          title: topicData['title'],
          description: topicData['description'],
        ));
      });
      _topics = loadedTopics;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetTopics(int courseId) async {
    var url = Constants.API_URL + 'courses/' + courseId.toString() + '/topics';
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
      final List<Topic> loadedTopics = [];
      extractedData.forEach((topicData) {
        loadedTopics.add(Topic(
            id: topicData['id'],
            title: topicData['title'],
            description: topicData['description'],
            fileUrl: topicData['fileUrl'],
            quiz: Quiz(
                id: topicData['quiz'] != null ? topicData['quiz']['id'] : null,
                title: topicData['quiz'] !=null ? topicData['quiz']['title'] : ''),
            solutions: topicData['solutions']));
      });
      _topics = loadedTopics;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addTopic(Topic topic, String fileUrl) async {
    final url = Constants.API_URL + 'topics';
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer ' + this.authToken,
      });

      request.fields['title'] = topic.title;
      request.fields['description'] = topic.description;
      request.fields['courseId'] = topic.courseId.toString();
      request.files.add(await http.MultipartFile.fromPath('file', fileUrl,
          contentType: MediaType('application', 'pdf')));
      var response = await http.Response.fromStream(await request.send());

      final newTopic = Topic(
        title: topic.title,
        description: topic.description,
        courseId: topic.courseId,
        id: json.decode(response.body)['id'],
        fileUrl: json.decode(response.body)['fileUrl'],
      );
      _topics.add(newTopic);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateTopic(int id, Topic topic, String fileUrl) async {
    final topicIndex = _topics.indexWhere((topic) => topic.id == id);
    if (topicIndex >= 0) {
      final url = Constants.API_URL + 'topics/$id';
      try {
        var request = http.MultipartRequest("PUT", Uri.parse(url));
        request.headers.addAll({
          'Authorization': 'Bearer ' + this.authToken,
        });

        request.fields['title'] = topic.title;
        request.fields['description'] = topic.description;
        request.fields['courseId'] = topic.courseId.toString();
        request.files.add(await http.MultipartFile.fromPath('file', fileUrl,
            contentType: MediaType('application', 'pdf')));
        var response = await http.Response.fromStream(await request.send());
        final editedTopic = Topic(
          title: topic.title,
          description: topic.description,
          courseId: topic.courseId,
          id: json.decode(response.body)['id'],
          fileUrl: json.decode(response.body)['fileUrl'],
        );
        _topics[topicIndex] = editedTopic;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> deleteTopic(int id) async {
    final url = Constants.API_URL + 'topics/$id';
    final existingTopicIndex = _topics.indexWhere((topic) => topic.id == id);
    var existingTopic = _topics[existingTopicIndex];
    _topics.removeAt(existingTopicIndex);
    notifyListeners();
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ' + this.authToken,
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode >= 400) {
      _topics.insert(existingTopicIndex, existingTopic);
      notifyListeners();
      throw HttpException('Nie można usunąć tematu.');
    }
    existingTopic = null;
  }

  Future<void> addSolution(int id, String fileUrl) async {
    final topicIndex = _topics.indexWhere((topic) => topic.id == id);
    if (topicIndex >= 0) {
      final url = Constants.API_URL + 'topics/$id/solutions';
      try {
        var request = http.MultipartRequest("POST", Uri.parse(url));
        request.headers.addAll({
          'Authorization': 'Bearer ' + this.authToken,
        });

        request.files.add(await http.MultipartFile.fromPath('file', fileUrl,
            contentType: MediaType('application', 'pdf')));
        var response = await http.Response.fromStream(await request.send());

        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> fetchAndSetSolutions(int id) async {
    var url = Constants.API_URL + 'topics/$id';
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

      final List<Solution> loadedSolutions = [];
      extractedData.forEach((solution) {
        loadedSolutions.add(Solution(
          id: solution['id'],
          fileUrl: solution['fileUrl'],
          solver: Profile(
              id: solution['solvers'][0]['id'],
              firstName: solution['solvers'][0]['firstName'],
              lastName: solution['solvers'][0]['lastName']),
        ));
      });

      _solutions = loadedSolutions;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
