import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hype_learning_flutter/app.dart';
import 'package:hype_learning_flutter/locator.dart';
import 'package:hype_learning_flutter/login/login_page.dart';
import 'package:hype_learning_flutter/models/CoursesRepository.dart';
import 'package:hype_learning_flutter/models/UserRepository.dart';

import 'package:hype_learning_flutter/authentication/authentication.dart';
import 'package:hype_learning_flutter/routes.dart';
import 'package:hype_learning_flutter/simple_bloc_delegate.dart';
import 'package:hype_learning_flutter/splash/splash.dart';
import 'package:hype_learning_flutter/home/home.dart';
import 'package:hype_learning_flutter/common/common.dart';

GetIt getIt = GetIt.instance;

void main() {
  setupLocator();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  final coursesRepository = CoursesRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: App(
        userRepository: userRepository,
        coursesRepository: coursesRepository,
      ),
    ),
  );
}


