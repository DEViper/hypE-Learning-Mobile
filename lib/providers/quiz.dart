import 'package:flutter/foundation.dart';

class Quiz with ChangeNotifier {
  final int id;
  final String title;
final int topicId;

 Quiz({
  this.id,
  @required this.title,
  this.topicId
  });
}
