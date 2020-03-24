import 'package:flutter/material.dart';
import 'package:hype_learning_flutter/screens/home/home.dart';
import 'package:hype_learning_flutter/theme/style.dart';
import 'package:hype_learning_flutter/routes.dart';

void main() => runApp(HypeLearning());

class HypeLearning extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HypE-Learning',
      theme: appTheme(),
      initialRoute: '/',
      routes: routes,
    );
  }
}

