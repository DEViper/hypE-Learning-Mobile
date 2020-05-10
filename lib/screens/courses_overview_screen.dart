import 'package:flutter/material.dart';
import 'package:hype_learning/widgets/app_drawer.dart';
import 'package:hype_learning/widgets/courses_list.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

// import '../widgets/app_drawer.dart';
// import '../widgets/products_grid.dart';
// import '../widgets/badge.dart';
// import '../providers/cart.dart';
// import './cart_screen.dart';
import '../providers/courses.dart';



class CoursesOverviewScreen extends StatefulWidget {
  //  static const routeName = '/';

  @override
  _CoursesOverviewScreenState createState() => _CoursesOverviewScreenState();
}

class _CoursesOverviewScreenState extends State<CoursesOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Courses>(context).fetchAndSetProducts(); // WON'T WORK!
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Courses>(context).fetchAndSetCourses();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Courses>(context).fetchAndSetCourses().then((_) {
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
          : CoursesList(),
    );
  }
}
