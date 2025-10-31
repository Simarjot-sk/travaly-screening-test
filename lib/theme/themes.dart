import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData createTheme(BuildContext context, Brightness brightness) {
  return ThemeData(
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      elevation: 0.0,
    ),
    useMaterial3: true,
    textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xffff7268),
      brightness: brightness,
    ),
  );
}
