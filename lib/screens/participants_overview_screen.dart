import 'package:flutter/material.dart';
import 'package:hype_learning/providers/courses.dart';
import 'package:hype_learning/widgets/app_drawer.dart';
import 'package:hype_learning/widgets/participants_list.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

// import '../widgets/app_drawer.dart';
// import '../widgets/products_grid.dart';
// import '../widgets/badge.dart';
// import '../providers/cart.dart';
// import './cart_screen.dart';

class ParticipantsOverviewScreen extends StatefulWidget {
  static const routeName = '/participants';

  @override
  _ParticipantsOverviewScreenState createState() =>
      _ParticipantsOverviewScreenState();
}

class _ParticipantsOverviewScreenState
    extends State<ParticipantsOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Participants>(context).fetchAndSetProducts(); // WON'T WORK!
    // final int courseId = ModalRoute.of(context).settings.arguments;

    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Courses>(context).fetchAndSetParticipants(courseId);
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final int courseId = ModalRoute.of(context).settings.arguments;

      Provider.of<Courses>(context).fetchAndSetParticipants(courseId).then((_) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('HypE-Learning'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ParticipantsList(ModalRoute.of(context).settings.arguments),
    );
  }
}
