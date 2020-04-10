import 'package:flutter/widgets.dart';
import 'package:hype_learning_flutter/main.dart';
import 'package:hype_learning_flutter/models/UserRepository.dart';



final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => App(userRepository: new UserRepository())
  
};