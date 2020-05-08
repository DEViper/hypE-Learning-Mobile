import 'package:flutter/material.dart';
import 'package:hype_learning/screens/course_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/courses.dart';
import '../providers/course.dart';

class CoursesList extends StatelessWidget {
  CoursesList();

  @override
  Widget build(BuildContext context) {
    final coursesData = Provider.of<Courses>(context);
    final courses = coursesData.courses;

    ListTile makeListTile(Course course) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            course.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.of(context).pushNamed(
              CourseDetailScreen.routeName,
              arguments: course.id,
            );
          },
        );

    Card makeCard(Course course) => Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.0))),
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
            ),
            child: makeListTile(course),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: courses.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: courses[i],
          child: makeCard(courses[i]),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white70,
      body: makeBody,
    );

    // return GridView.builder(
    //   padding: const EdgeInsets.all(10.0),
    //   itemCount: courses.length,
    //   itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
    //         // builder: (c) => products[i],
    //         value: courses[i],
    //         child: CourseWidget(
    //             // id: courses[i].id,
    //             // title: courses[i].title,
    //             // description: courses[i].description,
    //             // announcement: courses[i].announcement,
    //             ),
    //       ),
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     childAspectRatio: 3 / 2,
    //     crossAxisSpacing: 10,
    //     mainAxisSpacing: 10,
    //   ),
    // );
  }
}
