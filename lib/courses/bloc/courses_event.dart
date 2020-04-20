
import 'package:equatable/equatable.dart';

abstract class CoursesEvent extends Equatable {
  const CoursesEvent();
  @override
  List<Object> get props => [];
}

class Fetch extends CoursesEvent {}