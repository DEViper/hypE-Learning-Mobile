import 'package:flutter/material.dart';
import 'package:hype_learning/providers/course.dart';
import 'package:provider/provider.dart';

import '../screens/course_detail_screen.dart';

import '../providers/auth.dart';

class CourseWidget extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // courseItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final course = Provider.of<Course>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              CourseDetailScreen.routeName,
              arguments: course.id,
            );
          },
          child: Hero(
            tag: course.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/course-placeholder.png'),
              image: NetworkImage('https://hypelearning.s3.eu-central-1.amazonaws.com/god_its_me.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
