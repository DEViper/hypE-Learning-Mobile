import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hype_learning/helpers/shared_preferences_decoder.dart';
import 'package:hype_learning/providers/topics.dart';
import 'package:hype_learning/screens/edit_course_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/courses.dart';
import 'courses_overview_screen.dart';
import 'edit_topic_screen.dart';
import 'topics_overview_screen.dart';

class TopicDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/topic-detail';
  final role = SharedPreferencesDecoder.getField("role");

  @override
  Widget build(BuildContext context) {
    var topicId =
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
        Row(children: [
          Expanded(
            child: AutoSizeText(
              loadedTopic.title,
              style: TextStyle(color: Colors.white, fontSize: 45.0),
              maxLines: 1,
            ),
          ),
        ]),
        SizedBox(height: 30.0),
        Text(
          loadedTopic.description,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        )
      ],
    );

    _launchURL() async {
      final url = loadedTopic.fileUrl;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

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
                  onPressed: () async {
                    await Provider.of<Topics>(context, listen: false)
                        .deleteTopic(topicId);
                    Navigator.of(context).pop();
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
                    Provider.of<Topics>(context, listen: false)
                        .updateTopic(topicId, loadedTopic, loadedTopic.fileUrl);
                    Navigator.of(context).popAndPushNamed(
                        EditTopicScreen.routeName,
                        arguments: {topicId, loadedTopic});
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 40,
                  ))),
        Positioned(
            left: 190,
            bottom: 20,
            child: IconButton(
                onPressed: _launchURL,
                icon: Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 40,
                )))
      ],
    );

    return Scaffold(
        body: ListView(
      children: <Widget>[topContent],
    ));
  }
}
