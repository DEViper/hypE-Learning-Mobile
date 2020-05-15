// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_test/flutter_test.dart';

import 'package:hype_learning/main.dart';
import 'package:hype_learning/providers/auth.dart';
import 'package:hype_learning/screens/signIn_screen.dart';
import 'package:provider/provider.dart';
import 'package:hype_learning/screens/signIn_screen.dart';

import 'mock_auth.dart';

import 'package:test/test.dart' as unitTest; 
void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());

  //   await tester.pumpWidget(Provider<Auth>(create: (BuildContext context) { 
      
  //    },
  //   child: SignInScreen()));

    testWidgets('App renders', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      expect(find.byType(MaterialApp),findsOneWidget);
    });

   unitTest.test('Empty email returns error',(){

      var result = EmailFieldValidator.validate('');
      expect(result,'Email cant be empty');
    });

    unitTest.test('Password is too short',(){

      var result = PasswordFieldValidator.validate('Test');
      expect(result,'Password is too short');
    });

      unitTest.test('Password is ok',(){

      var result = PasswordFieldValidator.validate('Testowe34');
      expect(result, null);
    });

  // });
}
