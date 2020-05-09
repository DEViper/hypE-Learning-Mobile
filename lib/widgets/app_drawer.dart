import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hype_learning/screens/add_course_screen.dart';
import 'package:hype_learning/screens/signIn_screen.dart';
import 'package:provider/provider.dart';
import '../helpers/shared_preferences_decoder.dart';
import '../screens/courses_overview_screen.dart';
import '../screens/user_profile_screen.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  final role = SharedPreferencesDecoder.getField("role");
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Witaj!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Profil'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProfileScreen.routeName);
            },
          ),
          Divider(),
          if (role == 'instructor' || role == 'admin')
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Dodaj kurs"),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(AddCourseScreen.routeName);
              },
            ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Kursy'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(Navigator.defaultRouteName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Wyloguj'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(SignInScreen.routeName);

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
