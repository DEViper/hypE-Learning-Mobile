
import 'package:equatable/equatable.dart';
import 'package:hype_learning_flutter/courses/course.dart';

abstract class CoursesState extends Equatable {
  const CoursesState();

  @override
  List<Object> get props => [];
}

class CoursesUninitialized extends CoursesState {}

class CoursesError extends CoursesState {}

class CoursesLoaded extends CoursesState {
  final List<Course> courses;

  const CoursesLoaded({
    this.courses,
  });

  CoursesLoaded copyWith({
    List<Course> courses,
  }) {
    return CoursesLoaded(
      courses: courses ?? this.courses,
    );
  }

  @override
  List<Object> get props => [courses];

  @override
  String toString() =>
      'CourseLoaded { courses: ${courses.length}}';
}