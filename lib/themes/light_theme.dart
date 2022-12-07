import 'package:flutter/material.dart';

final ligthTheme = ThemeData(
  fontFamily: 'Inter',
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSwatch(
    accentColor: const Color(0xFF00BCD4),
    primarySwatch: Colors.indigo,
    brightness: Brightness.light,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
  cardTheme: const CardTheme(
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w700,
    ),
    headline2: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
    ),
    headline3: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
    ),
    headline4: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ).apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
  ),
);
