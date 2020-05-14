import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hype_learning/helpers/shared_preferences_decoder.dart';
import 'package:hype_learning/screens/edit_course_screen.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';
import 'add_topic_screen.dart';
import 'candidates_overview_screen.dart';
import 'courses_overview_screen.dart';
import 'topics_overview_screen.dart';
import 'participants_overview_screen.dart';

class ResultScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/result';
  final role = SharedPreferencesDecoder.getField("role");

  @override
  Widget build(BuildContext context) {
    final result =
        ModalRoute.of(context).settings.arguments as int; // is the id!

    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Text('TWÓJ WYNIK: '),     
Align(
  alignment: Alignment.center, 
  child:  Text(result.toString(), style: TextStyle(fontSize: 200.0),   )
),


          ],
        ),
      ),
    );
  }
}
