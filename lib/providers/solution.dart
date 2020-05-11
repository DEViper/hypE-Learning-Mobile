import 'package:flutter/cupertino.dart';
import 'package:hype_learning/providers/profile.dart';

class Solution extends ChangeNotifier {
  final int id;
  final String fileUrl;
  final Profile solver;

  Solution({
    this.id,
    this.fileUrl,
    this.solver,
  });
}
