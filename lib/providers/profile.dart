import 'package:flutter/foundation.dart';

class Profile with ChangeNotifier {
  final int id;
  final String email;
  final String password;
  final String fileUrl;

  Profile({
    this.id,
    this.email,
    this.password,
    this.fileUrl,
  });
}
