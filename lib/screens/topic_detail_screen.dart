import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hype_learning/helpers/shared_preferences_decoder.dart';
import 'package:hype_learning/providers/topics.dart';
import 'package:hype_learning/screens/edit_course_screen.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';
import 'courses_overview_screen.dart';
import 'topics_overview_screen.dart';

class TopicDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/topic-detail';
  final role = SharedPreferencesDecoder.getField("role");

  @override
  Widget build(BuildContext context) {
    final topicId =
        ModalRoute.of(context).settings.arguments as int; // is the id!
    final loadedTopic = Provider.of<Topics>(
      context,
      listen: false,
    ).findById(topicId);

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 20.0),
        Expanded(
          child: AutoSizeText(
            loadedTopic.title,
            style: TextStyle(color: Colors.white, fontSize: 45.0),
            maxLines: 1,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          loadedTopic.description,
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        )
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.blue[800]),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        if (role == 'instructor' || role == 'admin')
          Positioned(
              right: 50,
              bottom: 20,
              child: IconButton(
                  onPressed: () {
                    Provider.of<Courses>(context, listen: false)
                        .deleteCourse(topicId);
                    Navigator.of(context)
                        .popAndPushNamed(CoursesOverviewScreen.routeName);
                  },
                  icon: Icon(
                    Icons.delete_sweep,
                    color: Colors.white,
                    size: 40,
                  ))),
        if (role == 'instructor' || role == 'admin')
          Positioned(
              left: 50,
              bottom: 20,
              child: IconButton(
                  onPressed: () {
                    // Provider.of<Topics>(context, listen: false)
                    //     .updateTopic(topicId, loadedTopic);
                    // Navigator.of(context).popAndPushNamed(
                    //     EditTopicScreen.routeName,
                    //     arguments: {topicId, loadedTopic});
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 40,
                  )))
      ],
    );

    // final bottomAnnouncementText = Padding(
    //     padding: EdgeInsets.all(8.0),
    //     child: Column(children: [
    //       Center(
    //         child: Text(
    //           'Ogłoszenia',
    //           style: TextStyle(fontSize: 24.0),
    //         ),
    //       ),
    //       SizedBox(height: 20),
    //       Text(
    //         loadedTopic.announcement,
    //         style: TextStyle(fontSize: 14.0),
    //       )
    //     ]));

    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          onPressed: () {
            Navigator.of(context).pushNamed(
              TopicsOverviewScreen.routeName,
              arguments: topicId,
            );
          },
          color: Colors.blue[800],
          child: Text("Topics",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
        ));

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[readButton],
        ),
      ),
    );

    return Scaffold(
        body: ListView(
      children: <Widget>[topContent, bottomContent],
    ));
  }
}
