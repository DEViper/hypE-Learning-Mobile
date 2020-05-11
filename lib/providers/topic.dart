import 'package:flutter/foundation.dart';

import 'solution.dart';

class Topic with ChangeNotifier {
  final int id;
  final String title;
  final String description;
  final String fileUrl;
  final List<Solution> solutions;
   int courseId;

  Topic({
    this.id,
    @required this.title,
    this.description,
    this.fileUrl,
    this.courseId,
    this.solutions,
    //this.quizId
  });
}
