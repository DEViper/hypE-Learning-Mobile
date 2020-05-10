import 'package:flutter/material.dart';
import 'package:hype_learning/providers/profile.dart';
import 'package:hype_learning/providers/profiles.dart';
import 'package:hype_learning/screens/course_detail_screen.dart';
import 'package:hype_learning/screens/user_detail_screen.dart';
import 'package:provider/provider.dart';


class UsersList extends StatelessWidget {
  UsersList();

  @override
  Widget build(BuildContext context) {
    final usersData = Provider.of<Profiles>(context);
    final users = usersData.users;

    ListTile makeListTile(Profile profile) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            profile.firstName + " " + profile.lastName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.of(context).pushNamed(
              UserDetailScreen.routeName,
              arguments: profile.id,
            );
          },
        );

    Card makeCard(Profile profile) => Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.0))),
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
            ),
            child: makeListTile(profile),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: users[i],
          child: makeCard(users[i]),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white70,
      body: makeBody,
    );


  }
}
