import 'package:flutter/material.dart';
import 'package:hype_learning/providers/profiles.dart';
import 'package:hype_learning/widgets/app_drawer.dart';
import 'package:hype_learning/widgets/users_list.dart';
import 'package:provider/provider.dart';

// import '../widgets/app_drawer.dart';
// import '../widgets/products_grid.dart';
// import '../widgets/badge.dart';
// import '../providers/cart.dart';
// import './cart_screen.dart';



class AdminOverviewScreen extends StatefulWidget {
  static const routeName = '/admin';

  @override
  _AdminOverviewScreenState createState() => _AdminOverviewScreenState();
}

class _AdminOverviewScreenState extends State<AdminOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Admin>(context).fetchAndSetProducts(); // WON'T WORK!
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Profiles>(context).fetchAndSetUsers();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Profiles>(context).fetchAndSetUsers().then((_) {
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
          : UsersList(),
    );
  }
}
