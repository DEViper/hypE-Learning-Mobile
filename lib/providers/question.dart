import 'package:flutter/foundation.dart';

class Question with ChangeNotifier {
  final int id;
  final String title;
  final String a;
  final String b;
  final String c;
  final String d;
  final String correct;
  int quizId;

  Question({
    this.id,
    @required this.title,
    @required this.a,
    @required this.b,
    @required this.c,
    @required this.d,
    @required this.correct,
    this.quizId,
  });
}
