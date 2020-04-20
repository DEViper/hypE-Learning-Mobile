import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final int id;
  final String title;

  const Course({this.id, this.title});
  @override
  List<Object> get props => [id, title];

  @override
  String toString() => 'Course { id: $id }';
}
