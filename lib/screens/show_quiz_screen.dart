import 'package:flutter/material.dart';
import 'package:hype_learning/helpers/shared_preferences_decoder.dart';
import 'package:hype_learning/providers/quizzes.dart';
import 'package:hype_learning/screens/result_screen.dart';
import 'package:provider/provider.dart';

class ShowQuizScreen extends StatefulWidget {
  static const routeName = '/solve-quiz';

  @override
  _ShowQuizScreenState createState() => _ShowQuizScreenState();
}

class _ShowQuizScreenState extends State<ShowQuizScreen> {
  final role = SharedPreferencesDecoder.getField("role");

  var _isInit = true;
  var _isLoading = false;

  List<String> answers = new List<String>(100);
  List<int> radioValues = new List<int>(100);

  @override
  void initState() {
    super.initState();
  }

  void _handleRadioButtonCorrectAnswer(int index, int value) {
    setState(() {
      radioValues[index] = value;
      if (value == 0) {
        answers[index] = 'a';
      }
      if (value == 1) {
        answers[index] = 'b';
      }
      if (value == 2) {
        answers[index] = 'c';
      }
      if (value == 3) {
        answers[index] = 'd';
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final quizId = ModalRoute.of(context).settings.arguments as int;
      Provider.of<Quizzes>(context).fetchAndSetQuiz(quizId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      final loadedQuiz = Provider.of<Quizzes>(
        context,
        listen: false,
      ).findById(quizId);

      for (int i = 0; i < loadedQuiz.questions.length; i++) {
        radioValues[i] = -1;
        answers[i] = 'xd';
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final quizId =
        ModalRoute.of(context).settings.arguments as int; // is the id!
    final loadedQuiz = Provider.of<Quizzes>(
      context,
      listen: false,
    ).findById(quizId);

    getQuestions() {
      List<Widget> questions = new List<Widget>();
      for (int i = 0; i < loadedQuiz.questions.length; i++) {
        questions.add(new Column(children: [
          Text(loadedQuiz.questions[i].title),
          Text(loadedQuiz.questions[i].a),
          Text(loadedQuiz.questions[i].b),
          Text(loadedQuiz.questions[i].c),
          Text(loadedQuiz.questions[i].d),
          Center(
            child: Row(children: [
              new Radio(
                value: 0,
                groupValue: radioValues[i],
                onChanged: (int newValue) {
                  _handleRadioButtonCorrectAnswer(i, newValue);
                  setState(() {
                    radioValues[i] = newValue;
                  });
                },
              ),
              new Text(
                'a',
                style: new TextStyle(fontSize: 16.0),
              ),
              new Radio(
                value: 1,
                groupValue: radioValues[i],
                onChanged: (int newValue) {
                  _handleRadioButtonCorrectAnswer(i, newValue);
                  setState(() {
                    radioValues[i] = newValue;
                  });
                },
              ),
              new Text(
                'b',
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
              new Radio(
                value: 2,
                groupValue: radioValues[i],
                onChanged: (int newValue) {
                  _handleRadioButtonCorrectAnswer(i, newValue);
                  setState(() {
                    radioValues[i] = newValue;
                  });
                },
              ),
              new Text(
                'c',
                style: new TextStyle(fontSize: 16.0),
              ),
              new Radio(
                value: 3,
                groupValue: radioValues[i],
                onChanged: (int newValue) {
                  _handleRadioButtonCorrectAnswer(i, newValue);
                  setState(() {
                    radioValues[i] = newValue;
                  });
                },
              ),
              new Text(
                'd',
                style: new TextStyle(fontSize: 16.0),
              ),
            ]),
          ),
        ]));
      }
      return questions;
    }

    final questions = Center(
      child: Column(children: getQuestions()),
    );

    final makeBody = Center(
      child: Column(
        children: <Widget>[
          Text(
            loadedQuiz.title,
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ],
      ),
    );

    final sendButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          onPressed: () {
            Provider.of<Quizzes>(context, listen: false)
                .solveQuiz(loadedQuiz.id, answers);
            Navigator.of(context).pushNamed(ResultScreen.routeName,
                arguments: Provider.of<Quizzes>(context, listen: false).result);
          },
          color: Colors.blue[800],
          child: Text("Wyślij quiz",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text('Rozwiąż quiz'),
        actions: <Widget>[],
      ),
      body: ListView(
        children: <Widget>[makeBody, questions, sendButton],
      ),
    );
  }
}
