import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travaly/features/auth/auth_page.dart';
import 'package:travaly/theme/color_scheme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initFirebase();
  runApp(Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          elevation: 0.0,
        ),

        useMaterial3: true,
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
        colorScheme: createColorScheme(),
      ),
      home: AuthPage(),
    );
  }
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<GoogleSignInAccount?> authenticateWithGoogle() async {
  try {
    final GoogleSignIn signIn = GoogleSignIn.instance;
    await signIn.initialize();
    final GoogleSignInAccount? account = await signIn
        .attemptLightweightAuthentication();
    if (account != null) {
      return account;
    }
    return await GoogleSignIn.instance.authenticate();
  } on GoogleSignInException {
    return null;
  } catch (th, err) {
    return null;
  }
}
