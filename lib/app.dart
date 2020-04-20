import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hype_learning_flutter/authentication/authentication_bloc.dart';
import 'package:hype_learning_flutter/authentication/authentication_state.dart';
import 'package:hype_learning_flutter/common/loading_indicator.dart';
import 'package:hype_learning_flutter/home/home_page.dart';
import 'package:hype_learning_flutter/login/login_page.dart';
import 'package:hype_learning_flutter/models/CoursesRepository.dart';
import 'package:hype_learning_flutter/models/UserRepository.dart';
import 'package:hype_learning_flutter/routes.dart';
import 'package:hype_learning_flutter/splash/splash_page.dart';

class App extends StatelessWidget {
  final UserRepository userRepository;
  final CoursesRepository coursesRepository;
  App({Key key, @required this.userRepository, @required this.coursesRepository}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/',
      routes: routes,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthenticationAuthenticated) {
        return HomePage(coursesRepository: coursesRepository);
      }
      if (state is AuthenticationUnauthenticated) {
        return LoginPage(userRepository: userRepository);
      }
      if (state is AuthenticationLoading) {
        return LoadingIndicator();
      }
      return SplashPage();
          },
        ),
    );
  }
}