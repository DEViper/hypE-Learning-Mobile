import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/question.dart';
import '../providers/quizzes.dart';
import 'courses_overview_screen.dart';

class AddQuizQuestionScreen extends StatefulWidget {
  static const routeName = '/add-question';

  @override
  _AddQuizQuestionScreenState createState() => _AddQuizQuestionScreenState();
}

class _AddQuizQuestionScreenState extends State<AddQuizQuestionScreen> {
  final _titleFocusNode = FocusNode();
  final _aFocusNode = FocusNode();
  final _bFocusNode = FocusNode();
  final _cFocusNode = FocusNode();
  final _dFocusNode = FocusNode();
  final _correctFocusNode = FocusNode();

  int correctAnswer;
  String correct;
  final _form = GlobalKey<FormState>();
  var _editedQuestion = Question(
    id: null,
    title: '',
    a: '',
    b: '',
    c: '',
    d: '',
    correct: '',
  );
  var _initValues = {
    'title': '',
    'a': '',
    'b': '',
    'c': '',
    'd': '',
    'correct': '',
    'quizId': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleRadioButtonCorrectAnswer(int value) {
    setState(() {
      correctAnswer = value;
      if (value == 0) {
        correct = 'a';
      }
      if (value == 1) {
        correct = 'b';
      }
      if (value == 2) {
        correct = 'c';
      }
      if (value == 3) {
        correct = 'd';
      }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     final quizId = ModalRoute.of(context).settings.arguments as int;
  //     if (quizId != null) {
  //       _editedQuestion = Provider.of<Quizzes>(context, listen: false)
  //           .findQuestionById(quizId);
  //       _initValues = {
  //         'title': _editedQuestion.title,
  //         'a': _editedQuestion.a,
  //         'b': _editedQuestion.b,
  //         'c': _editedQuestion.c,
  //         'd': _editedQuestion.d,
  //         'correct': _editedQuestion.correct,
  //         'quizId': quizId.toString()
  //       };
  //     }
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _editedQuestion.quizId = ModalRoute.of(context).settings.arguments as int;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _aFocusNode.dispose();
    _bFocusNode.dispose();
    _cFocusNode.dispose();
    _dFocusNode.dispose();
    _correctFocusNode.dispose();
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
          .addQuestion(_editedQuestion.quizId, _editedQuestion);
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
    Navigator.of(context).popAndPushNamed(Navigator.defaultRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj pytanie'),
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
                        FocusScope.of(context).requestFocus(_aFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedQuestion = Question(
                          title: value,
                          a: _editedQuestion.a,
                          b: _editedQuestion.b,
                          c: _editedQuestion.c,
                          d: _editedQuestion.d,
                          correct: correct,
                          quizId: _editedQuestion.quizId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['a'],
                      decoration: InputDecoration(labelText: 'Odpowiedź a'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_bFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedQuestion = Question(
                          title: _editedQuestion.title,
                          a: value,
                          b: _editedQuestion.b,
                          c: _editedQuestion.c,
                          d: _editedQuestion.d,
                          correct: correct,
                          quizId: _editedQuestion.quizId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['b'],
                      decoration: InputDecoration(labelText: 'Odpowiedź b'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_cFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedQuestion = Question(
                          title: _editedQuestion.title,
                          a: _editedQuestion.a,
                          b: value,
                          c: _editedQuestion.c,
                          d: _editedQuestion.d,
                          correct: correct,
                          quizId: _editedQuestion.quizId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['c'],
                      decoration: InputDecoration(labelText: 'Odpowiedź c'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_dFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedQuestion = Question(
                          title: _editedQuestion.title,
                          a: _editedQuestion.a,
                          b: _editedQuestion.b,
                          c: value,
                          d: _editedQuestion.d,
                          correct: correct,
                          quizId: _editedQuestion.quizId,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['d'],
                      decoration: InputDecoration(labelText: 'Odpowiedź d'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_correctFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedQuestion = Question(
                          title: _editedQuestion.title,
                          a: _editedQuestion.a,
                          b: _editedQuestion.b,
                          c: _editedQuestion.c,
                          d: value,
                          correct: correct,
                          quizId: _editedQuestion.quizId,
                        );
                      },
                    ),
                     new Text(
                          'Wybierz prawidłową odpowiedż',
                          style: new TextStyle(fontSize: 18.0),
                        ),
                    Row(
                      children: <Widget>[
                        new Radio(
                          value: 0,
                          groupValue: correctAnswer,
                          onChanged: _handleRadioButtonCorrectAnswer,
                        ),
                        new Text(
                          'a',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(
                          value: 1,
                          groupValue: correctAnswer,
                          onChanged: _handleRadioButtonCorrectAnswer,
                        ),
                        new Text(
                          'b',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        new Radio(
                          value: 2,
                          groupValue: correctAnswer,
                          onChanged: _handleRadioButtonCorrectAnswer,
                        ),
                        new Text(
                          'c',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Radio(
                          value: 3,
                          groupValue: correctAnswer,
                          onChanged: _handleRadioButtonCorrectAnswer,
                        ),
                        new Text(
                          'd',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
