import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hype_learning/helpers/shared_preferences_decoder.dart';
import 'package:hype_learning/providers/quizzes.dart';
import 'package:hype_learning/providers/solution.dart';
import 'package:hype_learning/providers/topic.dart';
import 'package:hype_learning/providers/topics.dart';
import 'package:hype_learning/screens/edit_course_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/courses.dart';
import 'add_solution_screen.dart';
import 'courses_overview_screen.dart';
import 'edit_topic_screen.dart';
import 'topics_overview_screen.dart';
import 'add_quiz_screen.dart';
import 'edit_quiz_screen.dart';

class QuizDetailScreen extends StatefulWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/quiz-detail';

  @override
  _QuizDetailScreenState createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final role = SharedPreferencesDecoder.getField("role");
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Courses>(context).fetchAndSetProducts(); // WON'T WORK!
    // final quizId = ModalRoute.of(context).settings.arguments as int;

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Quizzes>(context, listen: false).fetchAndSetQuiz(quizId);
    // });
    super.initState();
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
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var quizId = ModalRoute.of(context).settings.arguments as int; // is the id!
    final loadedQuiz = Provider.of<Quizzes>(
      context,
      listen: false,
    ).findById(quizId);

    final solutionsData = Provider.of<Topics>(context);
    final solutions = solutionsData.solutions;
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        Row(children: [
          Expanded(
            child: AutoSizeText(
              loadedQuiz.title  != null ? loadedQuiz.title : "Quiz nie istnieje",
              style: TextStyle(color: Colors.white, fontSize: 45.0),
              maxLines: 1,
            ),
          ),
        ]),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.blue[800]),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        if ((role == 'instructor' || role == 'admin' ) && loadedQuiz.id != null)
          Positioned(
              right: 50,
              bottom: 20,
              child: IconButton(
                  onPressed: () async {
                    await Provider.of<Quizzes>(context, listen: false)
                        .deleteQuiz(loadedQuiz.id);
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.delete_sweep,
                    color: Colors.white,
                    size: 40,
                  ))),
        if ((role == 'instructor' || role == 'admin') && loadedQuiz.id != null)
          Positioned(
              left: 50,
              bottom: 20,
              child: IconButton(
                  onPressed: () {
                    Provider.of<Quizzes>(context, listen: false)
                        .updateQuiz(loadedQuiz.id, loadedQuiz);
                    Navigator.of(context).popAndPushNamed(
                        EditQuizScreen.routeName,
                        arguments: {loadedQuiz.id, loadedQuiz});
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 40,
                  ))),
        //     Positioned(
        //         left: 190,
        //         bottom: 20,
        //         child: IconButton(
        //             onPressed: (){},
        //             icon: Icon(
        //               Icons.book,
        //               color: Colors.white,
        //               size: 40,
        //             ))),
        //                  Positioned(
        //         left: 190,
        //         bottom: 100,
        //         child: IconButton(
        //             onPressed: () {
        //  Navigator.of(context).popAndPushNamed(
        //                     QuizDetailScreen.routeName,
        //                     arguments:loadedTopic.quizId);

        //             },
        //             icon: Icon(
        //               Icons.extension,
        //               color: Colors.white,
        //               size: 40,
        //             )))
      ],
    );

    final addSolutionButton = FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(AddSolutionScreen.routeName,
            arguments: ModalRoute.of(context).settings.arguments);
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      backgroundColor: Colors.blue,
    );

    final bottomContent = Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Center(),
          ],
        ));

    return Scaffold(
        body: ListView(
      children: <Widget>[topContent, bottomContent],
    ));
  }
}
