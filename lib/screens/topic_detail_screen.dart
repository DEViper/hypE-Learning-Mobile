import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hype_learning/helpers/shared_preferences_decoder.dart';
import 'package:hype_learning/providers/solution.dart';
import 'package:hype_learning/providers/topics.dart';
import 'package:hype_learning/screens/edit_course_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/courses.dart';
import 'add_solution_screen.dart';
import 'courses_overview_screen.dart';
import 'edit_topic_screen.dart';
import 'topics_overview_screen.dart';

class TopicDetailScreen extends StatefulWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/topic-detail';

  @override
  _TopicDetailScreenState createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  final role = SharedPreferencesDecoder.getField("role");
  var _isInit = true;
  var _isLoading = false;
  
  @override
  void initState() {
    // Provider.of<Courses>(context).fetchAndSetProducts(); // WON'T WORK!
    //       final topicId = ModalRoute.of(context).settings.arguments;

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Topics>(context, listen: false).fetchAndSetSolutions(topicId);
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final topicId = ModalRoute.of(context).settings.arguments;
      Provider.of<Topics>(context).fetchAndSetSolutions(topicId).then((_) {
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
    var topicId =
        ModalRoute.of(context).settings.arguments as int; // is the id!
    final loadedTopic = Provider.of<Topics>(
      context,
      listen: false,
    ).findById(topicId);

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
              loadedTopic.title,
              style: TextStyle(color: Colors.white, fontSize: 45.0),
              maxLines: 1,
            ),
          ),
        ]),
        SizedBox(height: 30.0),
        Text(
          loadedTopic.description,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        )
      ],
    );

    _launchURL() async {
      final url = loadedTopic.fileUrl;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

      _launchSolution(String fileUrl) async {
      final url = fileUrl;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

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
        if (role == 'instructor' || role == 'admin')
          Positioned(
              right: 50,
              bottom: 20,
              child: IconButton(
                  onPressed: () async {
                    await Provider.of<Topics>(context, listen: false)
                        .deleteTopic(topicId);
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.delete_sweep,
                    color: Colors.white,
                    size: 40,
                  ))),
        if (role == 'instructor' || role == 'admin')
          Positioned(
              left: 50,
              bottom: 20,
              child: IconButton(
                  onPressed: () {
                    Provider.of<Topics>(context, listen: false)
                        .updateTopic(topicId, loadedTopic, loadedTopic.fileUrl);
                    Navigator.of(context).popAndPushNamed(
                        EditTopicScreen.routeName,
                        arguments: {topicId, loadedTopic});
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 40,
                  ))),
        Positioned(
            left: 190,
            bottom: 20,
            child: IconButton(
                onPressed: _launchURL,
                icon: Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 40,
                )))
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




    ListTile makeListTile(Solution solution) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            solution.solver.firstName + solution.solver.lastName, 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
          _launchSolution(solution.fileUrl);
          },
        );

    Card makeCard(Solution solution) => Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.0))),
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: new BorderRadius.all(new Radius.circular(100.0)),
            ),
            child: makeListTile(solution),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: solutions != null ? solutions.length : 0 ,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: solutions[i],
          child: makeCard(solutions[i]),
        ),
      ),
    );




    final bottomContent = Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                    if (role == 'student')
                  addSolutionButton,
                     if (role == 'instructor' || role == 'admin')
                    makeBody,
                ],
              ),
            ),
          ],
        ));

    return Scaffold(
        body: ListView(
      children: <Widget>[topContent, bottomContent],
    ));
  }
}
