import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz.dart';
import '../providers/quizzes.dart';

class EditQuizScreen extends StatefulWidget {
  static const routeName = '/edit-Quiz';

  @override
  _EditQuizScreenState createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  final _titleFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _editedQuiz = Quiz(
    id: null,
    title: '',
  );
  var _initValues = {
    'title': '',
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
        _editedQuiz =
            Provider.of<Quizzes>(context, listen: false).findById(args.first);
        _initValues = {
          'title': _editedQuiz.title,

        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
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
      await Provider.of<Quizzes>(context, listen: false)
          .updateQuiz(_editedQuiz.id, _editedQuiz);
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
                Navigator.of(ctx).pushNamed(Navigator.defaultRouteName);
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
        Navigator.of(context)
                  .popAndPushNamed(Navigator.defaultRouteName);
  }

  @override
  Widget build(BuildContext context) {
      // final EditQuizArguments args = ModalRoute.of(context).settings.arguments;
      // int QuizId = args.id;
      // Quiz Quiz = args.Quiz;
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
                  
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedQuiz = Quiz(
                          title: value,
                          id: _editedQuiz.id,
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
