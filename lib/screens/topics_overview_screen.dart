import 'package:flutter/material.dart';
import 'package:hype_learning/providers/topics.dart';
import 'package:hype_learning/widgets/app_drawer.dart';
import 'package:hype_learning/widgets/topics_list.dart';
import 'package:provider/provider.dart';

// import '../widgets/app_drawer.dart';
// import '../widgets/products_grid.dart';
// import '../widgets/badge.dart';
// import '../providers/cart.dart';
// import './cart_screen.dart';
import '../providers/topics.dart';

class TopicsOverviewScreen extends StatefulWidget {
  static const routeName = '/topics';

  @override
  _TopicsOverviewScreenState createState() => _TopicsOverviewScreenState();
}

class _TopicsOverviewScreenState extends State<TopicsOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Topics>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
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
      Provider.of<Topics>(context).fetchAndSetTopics(courseId).then((_) {
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
          : TopicsList(),
    );
  }
}
