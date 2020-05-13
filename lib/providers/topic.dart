import 'package:flutter/foundation.dart';
import 'package:hype_learning/providers/quiz.dart';

import 'solution.dart';

class Topic with ChangeNotifier {
  final int id;
  final String title;
  final String description;
  final String fileUrl;
  final List<Solution> solutions;
   int courseId;
  final Quiz quiz;

  Topic({
    this.id,
    @required this.title,
    this.description,
    this.fileUrl,
    this.courseId,
    this.solutions,
    this.quiz
  });
}
