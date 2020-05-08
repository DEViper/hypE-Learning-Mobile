import 'package:flutter/material.dart';
import 'package:hype_learning/providers/topic.dart';
import 'package:hype_learning/providers/topics.dart';
import 'package:hype_learning/screens/course_detail_screen.dart';
import 'package:hype_learning/screens/topic_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/courses.dart';
import '../providers/course.dart';

class TopicsList extends StatelessWidget {
  TopicsList();

  @override
  Widget build(BuildContext context) {
    final topicsData = Provider.of<Topics>(context);
    final topics = topicsData.topics;

    ListTile makeListTile(Topic topic) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),

          title: Text(
            topic.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 18.0),
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.of(context).pushNamed(
              TopicDetailScreen.routeName,
              arguments: topic.id,
            );
          },
        );

    Card makeCard(Topic topic ) => Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.0))),
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
            ),
            child: makeListTile(topic),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: topics.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: topics[i],
          child: makeCard(topics[i]),
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
