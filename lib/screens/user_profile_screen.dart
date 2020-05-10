import 'package:flutter/material.dart';
import 'package:hype_learning/helpers/shared_preferences_decoder.dart';
import 'package:hype_learning/providers/course.dart';
import 'package:hype_learning/providers/courses.dart';
import 'package:hype_learning/providers/profiles.dart';
import 'package:hype_learning/screens/edit_profile_screen.dart';
import 'package:hype_learning/widgets/courses_list.dart';
import 'package:provider/provider.dart';

import 'course_detail_screen.dart';
import 'courses_overview_screen.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen();
  static const routeName = '/profile';

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Courses>(context).fetchAndSetStudentCourses().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  final id = SharedPreferencesDecoder.getField('userId');
  final image = SharedPreferencesDecoder.getField('fileUrl');

  final firstName = SharedPreferencesDecoder.getField('firstName');

  final lastName = SharedPreferencesDecoder.getField('lastName');

  final email = SharedPreferencesDecoder.getField('email');

  final role = SharedPreferencesDecoder.getField('role');

  @override
  Widget build(BuildContext context) {
    final coursesData = Provider.of<Courses>(context);
    final courses = coursesData.courses;

    Widget profileImage = image == null
        ? Container()
        : Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(image),
              ),
            ),
          );

    final userInfo = Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(children: [
          Center(
            child: Text(
              firstName + ' ' + lastName,
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
          ),
          Text(
            email,
            style: TextStyle(fontSize: 14.0, color: Colors.white),
          )
        ]));

    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.blue[800]),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [profileImage, userInfo],
            ),
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.of(context).popAndPushNamed(Navigator.defaultRouteName);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        Positioned(
            right: 8,
            top: 50.0,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProfileScreen.routeName);
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                )))
      ],
    );
         
    ListTile makeListTile(Course course) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white))),
            child: Icon(Icons.autorenew, color: Colors.white),
          ),
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
      backgroundColor: Colors.white,
      body: Column(
        children: [topContent, makeBody],
      ),
    );
  }
}
