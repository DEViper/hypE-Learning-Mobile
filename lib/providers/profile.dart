import 'package:flutter/foundation.dart';

class Profile with ChangeNotifier {
  final int id;
  final String email;
  final String password;
  final String fileUrl;
  final String firstName;
  final String lastName;
  final String role;
  bool isBlocked;

  Profile({
    this.id,
    this.email,
    this.password,
    this.fileUrl,
    this.firstName,
    this.lastName,
    this.role,
    this.isBlocked
  });
}
