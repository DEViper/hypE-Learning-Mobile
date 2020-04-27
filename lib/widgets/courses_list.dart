import 'package:flutter/material.dart';
import 'package:hype_learning/widgets/course_widget.dart';
import 'package:provider/provider.dart';
import '../providers/courses.dart';

class CoursesList extends StatelessWidget {

 CoursesList();

  @override
  Widget build(BuildContext context) {
    final coursesData = Provider.of<Courses>(context);
    final courses = coursesData.courses;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: courses.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            // builder: (c) => products[i],
            value: courses[i],
            child: CourseWidget(
                // id: courses[i].id,
                // title: courses[i].title,
                // description: courses[i].description,
                // announcement: courses[i].announcement,
                ),
          ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}