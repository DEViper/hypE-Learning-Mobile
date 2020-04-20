import 'package:flutter/widgets.dart';
import 'package:hype_learning_flutter/home/home.dart';
import 'package:hype_learning_flutter/login/login_page.dart';
import 'package:hype_learning_flutter/models/CoursesRepository.dart';
import 'package:hype_learning_flutter/models/UserRepository.dart';



final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => LoginPage(userRepository: new UserRepository()),
  // "/courses": (BuildContext context) => HomePage(coursesRepository: new CoursesRepository(),),
  
};