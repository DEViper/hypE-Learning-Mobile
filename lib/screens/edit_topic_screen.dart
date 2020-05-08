import 'package:flutter/material.dart';
import 'package:hype_learning/models/arguments/edit_course_arguments.dart';
import 'package:provider/provider.dart';

import '../providers/course.dart';
import '../providers/courses.dart';
import 'courses_overview_screen.dart';

class EditCourseScreen extends StatefulWidget {
  static const routeName = '/edit-course';

  @override
  _EditCourseScreenState createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _announcementFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _editedCourse = Course(
    id: null,
    title: '',
    description: '',
    announcement: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'announcement': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final dynamic args = ModalRoute.of(context).settings.arguments;
      if (args.first != null) {
        _editedCourse =
            Provider.of<Courses>(context, listen: false).findById(args.first);
        _initValues = {
          'title': _editedCourse.title,
          'description': _editedCourse.description,
          'announcement': _editedCourse.announcement,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _announcementFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Courses>(context, listen: false)
          .updateCourse(_editedCourse.id, _editedCourse);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pushNamed(CoursesOverviewScreen.routeName);
              },
            )
          ],
        ),
      );
    }
    // finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Navigator.of(context).pop();
    // }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushNamed(
        CoursesOverviewScreen.routeName); // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
      // final EditCourseArguments args = ModalRoute.of(context).settings.arguments;
      // int courseId = args.id;
      // Course course = args.course;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj kurs'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Tytuł'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCourse = Course(
                          title: value,
                          description: _editedCourse.description,
                          announcement: _editedCourse.announcement,
                          id: _editedCourse.id,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Opis'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_announcementFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCourse = Course(
                          title: _editedCourse.title,
                          description: value,
                          announcement: _editedCourse.announcement,
                          id: _editedCourse.id,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['announcement'],
                      decoration: InputDecoration(labelText: 'Ogłoszenia'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCourse = Course(
                          title: _editedCourse.title,
                          description: _editedCourse.description,
                          announcement: value,
                          id: _editedCourse.id,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
