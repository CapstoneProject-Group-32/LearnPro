import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
  ),
  colorScheme: const ColorScheme.light(
    // background: Colors.grey.shade300,
    // primary: const Color(0Xff9494f6),
    // secondary: const Color(0xffFFD453),

    background: Color(0XffE6EBEB),
    primary: Color(0XffDF9ADD),
    secondary: Color(0xffAB80cd),
  ),
);
