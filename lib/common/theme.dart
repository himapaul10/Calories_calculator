import 'package:calories_calc/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  useMaterial3: false,
  textTheme: GoogleFonts.dmSansTextTheme(),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: primaryColor,
    centerTitle: true,
  ),
);
