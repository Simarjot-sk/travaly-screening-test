import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travaly/features/auth/widgets/bush.dart';
import 'package:travaly/features/auth/widgets/logo.dart';
import 'package:travaly/features/home/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LeafBackground(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(flex: 5),
                Logo(),
                Spacer(flex: 3),
                Card(
                  color: ColorScheme.of(context).secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Find an epic stay with us!',
                      style: TextTheme.of(context).headlineLarge?.copyWith(
                        color: ColorScheme.of(context).onSecondaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Text(
                  'Hotels, Resorts, Holiday Homes, Villas, Co-living And More At Best Price',
                  style: TextTheme.of(context).bodyLarge?.copyWith(
                    color: ColorScheme.of(context).onSecondaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(flex: 6),
                FloatingActionButton.extended(
                  onPressed: () async {
                    final account = await authenticateWithGoogle();
                    if (account != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage.create()),
                      );
                    }
                  },
                  label: Text(
                    'Login with Google',
                    style: TextTheme.of(context).bodyLarge?.copyWith(
                      color: ColorScheme.of(context).onPrimaryContainer,
                    ),
                  ),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<GoogleSignInAccount?> authenticateWithGoogle() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;
      await signIn.initialize(
        serverClientId:
            '830954724405-7rpg6chkktfie4ur4frjn84ennv62ef4.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? account = await signIn
          .attemptLightweightAuthentication();
      if (account != null) {
        return account;
      }
      return await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      log('google sign in exception', error: e);
      return null;
    } catch (th, stack) {
      log('google sign in error', error: th, stackTrace: stack);
      return null;
    }
  }
}
