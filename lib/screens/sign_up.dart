import 'package:flutter/material.dart';
import 'package:hype_learning_flutter/layout.dart';
import 'package:hype_learning_flutter/localizations/hl_localizations.dart';
import 'package:hype_learning_flutter/pages/signup_form.dart';
import 'package:hype_learning_flutter/screens/sign_in.dart';
import 'package:hype_learning_flutter/widgets/scroll_page.dart';

class SignUpScreen extends StatelessWidget {
  static const String route = '/sign_up';

  @override
  Widget build(BuildContext context) {
    final locale = HLLocalizations.of(context);
    final theme = Theme.of(context);
    return Layout(
      child: ScrollPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: <Widget>[
                  Text(
                    locale.userSignUp,
                    style: theme.textTheme.headline6.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(SignInScreen.route);
                      },
                      child: Text(
                        locale.userSignUpHaveAccount,
                        style: theme.textTheme.subtitle2,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SignUpForm(),
            ),
          ],
        ),
      ),
    );
  }
}