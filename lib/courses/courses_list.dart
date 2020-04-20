import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hype_learning_flutter/courses/bloc/bloc.dart';
import 'package:hype_learning_flutter/courses/course_widget.dart';

class CoursesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  CoursesBloc _coursesBloc;

  @override
  void initState() {
    super.initState();
   _coursesBloc = BlocProvider.of<CoursesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state is CoursesUninitialized) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CoursesError) {
          return Center(
            child: Text('failed to fetch courses'),
          );
        }
        if (state is CoursesLoaded) {
          if (state.courses.isEmpty) {
            return Center(
              child: Text('no courses'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return CourseWidget(course: state.courses[index]);
            },
          );
        }
      },
    );
  }
}
