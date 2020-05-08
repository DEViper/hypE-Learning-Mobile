import 'package:flutter/foundation.dart';

class Topic with ChangeNotifier {
  final int id;
  final String title;
  final String description;
  final String fileUrl;
   int courseId;

  Topic({
    this.id,
    @required this.title,
    this.description,
    this.fileUrl,
    this.courseId,
    //this.quizId
  });
}
