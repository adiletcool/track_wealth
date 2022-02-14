import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';

final ThemeData lightThemeData = ThemeData.light().copyWith(
  textTheme: GoogleFonts.jetBrainsMonoTextTheme(ThemeData.light().textTheme),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.indigoAccent),
);

final ThemeData darkThemeData = ThemeData.dark().copyWith(
  textTheme: GoogleFonts.jetBrainsMonoTextTheme(ThemeData.dark().textTheme),
  scaffoldBackgroundColor: darkBackgroundColor,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black87),
);
