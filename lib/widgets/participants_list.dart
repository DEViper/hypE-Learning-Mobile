import 'package:flutter/material.dart';
import 'package:hype_learning/providers/courses.dart';
import 'package:hype_learning/providers/profile.dart';
import 'package:hype_learning/screens/course_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/course.dart';

class ParticipantsList extends StatelessWidget {
  int _courseId;
  ParticipantsList(int courseId) {
    _courseId = courseId;
  }

  @override
  Widget build(BuildContext context) {
    final participantsData = Provider.of<Courses>(context);
    final participants = participantsData.participants;

    ListTile makeListTile(Profile participant) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            participant.firstName + " " + participant.lastName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(Icons.delete_forever, color: Colors.white, size: 30.0),
          onTap: () {
            Provider.of<Courses>(context, listen: false)
                .deleteParticipant(_courseId, participant.id);
            Navigator.of(context).pop();
          },
        );

    Card makeCard(Profile participant) => Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.0))),
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
            ),
            child: makeListTile(participant),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: participants.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: participants[i],
          child: makeCard(participants[i]),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white70,
      body: makeBody,
    );

    // return GridView.builder(
    //   padding: const EdgeInsets.all(10.0),
    //   itemCount: Participants.length,
    //   itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
    //         // builder: (c) => products[i],
    //         value: Participants[i],
    //         child: CourseWidget(
    //             // id: Participants[i].id,
    //             // title: Participants[i].title,
    //             // description: Participants[i].description,
    //             // announcement: Participants[i].announcement,
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
