import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helpers/custom_route.dart';
import 'providers/auth.dart';
import 'screens/courses_overview_screen.dart';
import 'screens/signIn_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/signUp_screen.dart';

void main() {
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
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'HypE-Learning',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Roboto',
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
            },
          ),
        ));
  }
}
