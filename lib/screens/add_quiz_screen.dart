import 'package:flutter/material.dart';
import 'package:hype_learning/providers/quiz.dart';
import 'package:hype_learning/providers/quizzes.dart';
import 'package:provider/provider.dart';

class AddQuizScreen extends StatefulWidget {
  static const routeName = '/add-quiz';

  @override
  _AddQuizScreenState createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final _titleFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _editedQuiz = Quiz(
    id: null,
    title: '',
    topicId: null,
  );
  var _initValues = {'title': '', 'topicId': null};
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
        _initValues = {
          'title': _editedQuiz.title,
          'topicId': args.first.toString()
        };
      }
      _isInit = false;
      super.didChangeDependencies();
    }
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
          .addQuiz(_editedQuiz.topicId, _editedQuiz);
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
        title: Text('Dodaj quiz'),
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
                      onFieldSubmitted: (_) {},
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        dynamic args =
                            ModalRoute.of(context).settings.arguments;
                        _editedQuiz = Quiz(title: value, topicId: args.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
