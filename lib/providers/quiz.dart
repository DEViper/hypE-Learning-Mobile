import 'package:flutter/foundation.dart';
import 'package:hype_learning/providers/question.dart';

class Quiz with ChangeNotifier {
  final int id;
  final String title;
  final int topicId;
  final List<Question> questions;

  Quiz({this.id, @required this.title, this.topicId, this.questions});
}
