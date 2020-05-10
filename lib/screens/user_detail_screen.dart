import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hype_learning/helpers/shared_preferences_decoder.dart';
import 'package:provider/provider.dart';

import '../providers/profiles.dart';
import 'add_topic_screen.dart';
import 'topics_overview_screen.dart';

class UserDetailScreen extends StatefulWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/user-detail';

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final role = SharedPreferencesDecoder.getField("role");

  @override
  Widget build(BuildContext context) {
    final userId =
        ModalRoute.of(context).settings.arguments as int; // is the id!
    final loadedUser = Provider.of<Profiles>(
      context,
      listen: false,
    ).findById(userId);
    bool isSwitched = loadedUser.isBlocked;

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
              loadedUser.email,
              style: TextStyle(color: Colors.white, fontSize: 45.0),
              maxLines: 1,
            ),
          ),
        ]),
        SizedBox(height: 20.0),
        Text(
          loadedUser.role,
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
                    // Provider.of<Profiles>(context, listen: false)
                    //     .deleteUser(userId);
                    // Navigator.of(context)
                    //     .popAndPushNamed(Navigator.defaultRouteName);
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
                    // Provider.of<Profiles>(context, listen: false)
                    //     .updateUser(userId, loadedUser);
                    // Navigator.of(context).popAndPushNamed(
                    //     EditUserScreen.routeName,
                    //     arguments: {userId, loadedUser});
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 40,
                  )))
      ],
    );

    final bottomAnnouncementText = Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(children: [
          Center(
            child: Text(
              'Ogłoszenia',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'XD',
            style: TextStyle(fontSize: 14.0),
          )
        ]));

    // final readButton = Container(
    //     padding: EdgeInsets.symmetric(vertical: 16.0),
    //     width: MediaQuery.of(context).size.width,
    //     child: RaisedButton(
    //       shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(20.0))),
    //       onPressed: () {
    //         Navigator.of(context).pushNamed(
    //           TopicsOverviewScreen.routeName,
    //           arguments: userId,
    //         );
    //       },
    //       color: Colors.blue[800],
    //       child: Text("Topics",
    //           style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 18.0,
    //               fontWeight: FontWeight.bold)),
    //     ));

    // final floatingActionButton = Align(
    //     alignment: Alignment(0.8, 0.7),
    //     child: FloatingActionButton(
    //       onPressed: () {
    //         Navigator.of(context)
    //             .pushReplacementNamed(AddTopicScreen.routeName, arguments: userId);
    //       },
    //       child: Icon(
    //         Icons.add,
    //         color: Colors.white,
    //       ),
    //       backgroundColor: Colors.blue,
    //     ));

    final banToggle = Container(
      width: 20.0,
      child: Switch(
        value: loadedUser.isBlocked,
        onChanged: (value) {
          try {
            Provider.of<Profiles>(context, listen: false)
                .changeStatus(userId, loadedUser);
          } catch (error) {
            print(error);
          }
          setState(() {
            loadedUser.isBlocked = value;
            print(isSwitched);
          });
          Navigator.of(context).pop();
        },
        activeTrackColor: Colors.redAccent,
        activeColor: Colors.red,
      ),
    );

    final bottomContent = Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  bottomAnnouncementText,
                  //readButton,
                ],
              ),
            ),
          ],
        ));

    return Scaffold(
        body: ListView(
      children: <Widget>[topContent, bottomContent, banToggle],
    ));
  }
}
