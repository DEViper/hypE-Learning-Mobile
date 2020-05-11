import 'package:flutter/material.dart';
import 'package:hype_learning/providers/courses.dart';
import 'package:hype_learning/providers/profile.dart';
import 'package:hype_learning/screens/course_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/course.dart';

class CandidatesList extends StatelessWidget {
  int _courseId;
  CandidatesList(int courseId) {
    _courseId = courseId;
  }

  @override
  Widget build(BuildContext context) {
    final candidatesData = Provider.of<Courses>(context);
    final candidates = candidatesData.candidates;

    ListTile makeListTile(Profile candidate) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            candidate.firstName + " " + candidate.lastName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(Icons.library_add, color: Colors.white, size: 30.0),
          onTap: () {
            Provider.of<Courses>(context, listen: false)
                .addCandidate(_courseId, candidate.id);
            Navigator.of(context).pop();
          },
        );

    Card makeCard(Profile candidate) => Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.0))),
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
            ),
            child: makeListTile(candidate),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: candidates.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: candidates[i],
          child: makeCard(candidates[i]),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white70,
      body: makeBody,
    );

    // return GridView.builder(
    //   padding: const EdgeInsets.all(10.0),
    //   itemCount: candidates.length,
    //   itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
    //         // builder: (c) => products[i],
    //         value: candidates[i],
    //         child: CourseWidget(
    //             // id: candidates[i].id,
    //             // title: candidates[i].title,
    //             // description: candidates[i].description,
    //             // announcement: candidates[i].announcement,
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
