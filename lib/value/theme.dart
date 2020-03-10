import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  buttonColor: Colors.white,
  errorColor: Colors.white,
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
);

final normalTheme = ThemeData(
  buttonColor: Colors.indigo,
  primarySwatch: Colors.indigo,
  accentColor: Colors.amber,
  errorColor: Colors.red,
  canvasColor: Color(0xffF5F5F6),
  cardColor: Color(0xffE1E2E1),
  textTheme: TextTheme(
    display1: TextStyle(
      color: Colors.white,
    ),
  ),
);
