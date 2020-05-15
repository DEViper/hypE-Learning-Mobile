import 'package:hype_learning/providers/auth.dart';
import 'package:hype_learning/providers/profile.dart';

class MockAuth extends Auth {
  List<Profile> accounts = [
    Profile(id: 1, email: 'test1@example.com', password: 'Testowe1'),
    Profile(id: 2, email: 'test2@example.com', password: 'Testowe2'),
    Profile(id: 3, email: 'test3@example.com', password: 'Testowe3'),
    Profile(id: 4, email: 'test4@example.com', password: 'Testowe4'),
  ];

  @override
  bool signIn(String email, String password) {
    isAuth = false;
    accounts.forEach((account) {
      if (account.email == email) {
        if (account.password == password) {
          isAuth = true;
        }
      }
    });
    return isAuth;
  }
}
