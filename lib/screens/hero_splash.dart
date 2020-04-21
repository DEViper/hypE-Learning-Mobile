import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hype_learning_flutter/localizations/hl_localizations.dart';
import 'package:hype_learning_flutter/widgets/header.dart';

import 'home.dart';

class HeroSplash extends StatefulWidget {
  @override
  _HeroSplashState createState() => _HeroSplashState();
}

class _HeroSplashState extends State<HeroSplash> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = HLLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Hero(
              tag: 'header',
              child: Header(
                title: locale.appTitle,
                subtitle: locale.appSubtitle,
                padding: const EdgeInsets.only(top: 8, bottom: 26),
                disableBoxShadow: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
