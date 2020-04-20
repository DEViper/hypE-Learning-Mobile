import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hype_learning_flutter/authentication/authentication.dart';
import 'package:hype_learning_flutter/courses/bloc/bloc.dart';
import 'package:hype_learning_flutter/courses/courses.dart';
import 'package:hype_learning_flutter/models/CoursesRepository.dart';

class HomePage extends StatelessWidget {
    final CoursesRepository coursesRepository;
     HomePage({Key key, @required this.coursesRepository})
      : assert(coursesRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: BlocProvider<CoursesBloc>(create: (context) => CoursesBloc(coursesRepository: coursesRepository),
        child: Container(child: CoursesList()),
      ),
    );
  }
}


