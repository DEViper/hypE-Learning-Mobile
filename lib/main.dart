import 'package:flutter/material.dart';
import 'package:hype_learning/providers/courses.dart';
import 'package:hype_learning/providers/topics.dart';
import 'package:hype_learning/screens/add_course_screen.dart';
import 'package:hype_learning/screens/add_topic_screen.dart';
import 'package:hype_learning/screens/edit_course_screen.dart';
import 'package:hype_learning/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/custom_route.dart';
import 'providers/auth.dart';
import 'providers/profiles.dart';
import 'screens/candidates_overview_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/courses_overview_screen.dart';
import 'screens/edit_topic_screen.dart';
import 'screens/signIn_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/signUp_screen.dart';
import 'screens/topic_detail_screen.dart';
import 'screens/topics_overview_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/admin_overview_screen.dart';
import 'screens/user_detail_screen.dart';
import 'screens/participants_overview_screen.dart';

SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Courses>(
            create: (ctx) => Courses(),
            update: (context, auth, courses) => courses.update(
              auth.token,
              auth.userId,
              courses == null ? [] : courses.courses,
            ),
          ),
          ChangeNotifierProxyProvider<Auth, Topics>(
            create: (ctx) => Topics(),
            update: (context, auth, topics) => topics.update(
              auth.token,
              auth.userId,
              topics == null ? [] : topics.topics,
            ),
          ),
          ChangeNotifierProxyProvider<Auth, Profiles>(
            create: (ctx) => Profiles(),
            update: (context, auth, profile) => profile.update(
              auth.token,
              auth.userId,
              profile == null ? null : profile.profile,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'HypE-Learning',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                accentColor: Colors.greenAccent,
                fontFamily: 'Montserrat',
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  },
                ),
              ),
              home: auth.isAuth
                  ? CoursesOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : SignInScreen(),
                    ),
              routes: {
                SignInScreen.routeName: (ctx) => SignInScreen(),
                SignUpScreen.routeName: (ctx) => SignUpScreen(),
                CourseDetailScreen.routeName: (ctx) => CourseDetailScreen(),
                AddCourseScreen.routeName: (ctx) => AddCourseScreen(),
                EditCourseScreen.routeName: (ctx) => EditCourseScreen(),
                UserProfileScreen.routeName: (ctx) => UserProfileScreen(),
                TopicDetailScreen.routeName: (ctx) => TopicDetailScreen(),
                TopicsOverviewScreen.routeName: (ctx) => TopicsOverviewScreen(),
                AddTopicScreen.routeName: (ctx) => AddTopicScreen(),
                EditTopicScreen.routeName: (ctx) => EditTopicScreen(),
                EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
                AdminOverviewScreen.routeName: (ctx) => AdminOverviewScreen(),
                UserDetailScreen.routeName: (ctx) => UserDetailScreen(),
                ParticipantsOverviewScreen.routeName: (ctx) =>
                    ParticipantsOverviewScreen(),
                CandidatesOverviewScreen.routeName: (ctx) =>
                    CandidatesOverviewScreen(),
              }),
        ));
  }
}
