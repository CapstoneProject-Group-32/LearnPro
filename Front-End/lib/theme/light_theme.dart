import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
  ),
  colorScheme: const ColorScheme.light(
    // background: Colors.grey.shade300,
    // primary: const Color(0Xff9494f6),
    // secondary: const Color(0xffFFD453),

    // background: Color(0Xffe4e5f1),
    // primary: Color(0Xffd2d3db),
    // secondary: Color(0xff9394a5),

    surface: Color(0Xffb6dcdd),
    primary: Color(0Xff93cec3),
    secondary: Color(0xff58b6a6),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(
      color: Color(0xff58b6a6), // Custom label color
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff58b6a6), // Custom border color when focused
        width: 2,
      ),
    ),
  ),
);
