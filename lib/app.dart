import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hype_learning_flutter/repositories/user/repository.dart';
// import 'package:hype_learning_flutter/repositories/articles/repository.dart';

import 'application.dart';
import 'blocs/user/bloc.dart';
import 'localizations/hl_localizations.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@immutable
class HypeLearningApp extends StatelessWidget {
  final Application application;

  const HypeLearningApp({
    this.application,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(
          value: application.userRepository,
        ),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
          return MaterialApp(
            locale: const Locale('pl', ''),
            onGenerateTitle: (BuildContext context) =>
                HLLocalizations.of(context).appName,
            color: Colors.green,
            theme: ThemeData(
              fontFamily: 'SourceSansPro',
              primaryColor: const Color(0xFF039BE5),
            ),
            // navigatorKey: navigatorKey,
            localizationsDelegates: [
              const HLLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('pl'),
            ],
            onGenerateRoute: routes(
              application: application,
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
