import 'dart:async';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:hype_learning_flutter/courses/bloc/bloc.dart';
import 'package:hype_learning_flutter/models/CoursesRepository.dart';
import 'package:meta/meta.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final CoursesRepository coursesRepository;
  CoursesBloc({
  @required this.coursesRepository  })  : assert(coursesRepository != null);      
  @override
  CoursesState get initialState => CoursesUninitialized();



  @override
Stream<CoursesState> mapEventToState(CoursesEvent event) async* {
  final currentState = state;
  if (event is Fetch) {
    try {
      if (currentState is CoursesUninitialized) {
        final courses = await coursesRepository.findAll();
        yield CoursesLoaded(courses: courses);
        return;
      }
      if (currentState is CoursesLoaded) {
        final courses =
            await coursesRepository.findAll();
        yield courses.isEmpty
            ? currentState.copyWith()
            : CoursesLoaded(
                courses: currentState.courses + courses,
              );
      }
    } catch (_) {
      yield CoursesError();
    }
  }
}
}


