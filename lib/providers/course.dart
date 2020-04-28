
import 'package:flutter/foundation.dart';

class Course with ChangeNotifier {
  final int id;
  final String title;
  final String description;
  final String announcement;

  Course({
     this.id,
    @required this.title,
    @required this.description,
    @required this.announcement,
  });
}
