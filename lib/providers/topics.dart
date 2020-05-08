import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hype_learning/config/constants.dart';
import '../config/constants.dart';
import '../models/http_exception.dart';
import './topic.dart';

class Topics with ChangeNotifier {
  List<Topic> _topics = [];
  String authToken;
  int userId;

  Topics();

  List<Topic> get topics {
    return [..._topics];
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
      final extractedData = json.decode(response.body).toList(); //check if unathorized
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
    var url = Constants.API_URL+'courses/' + courseId.toString() + '/topics';
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
        ));
      });
      _topics = loadedTopics;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addTopic(Topic topic) async {
    final url = Constants.API_URL + 'Topics';
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'title': topic.title,
          'description': topic.description,
        }),
      );
      final newTopic = Topic(
        title: topic.title,
        description: topic.description,
        id: json.decode(response.body)['id'],
      );
      _topics.add(newTopic);
      // _Topics.insert(0, newTopic); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateTopic(int id, Topic newTopic) async {
    final topicIndex = _topics.indexWhere((topic) => topic.id == id);
    if (topicIndex >= 0) {
       final url = Constants.API_URL + 'Topics/$id';
      await http.put(url,headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
          body: json.encode({
            'title': newTopic.title,
            'description': newTopic.description,
          }));
      _topics[topicIndex] = newTopic;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteTopic(int id) async {
    final url = Constants.API_URL + 'Topics/$id';
    final existingTopicIndex =
        _topics.indexWhere((topic) => topic.id == id);
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
}