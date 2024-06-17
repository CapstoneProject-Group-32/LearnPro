import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
  ),
  colorScheme: const ColorScheme.dark(
    background: Color.fromARGB(209, 158, 158, 158),
    primary: Color.fromARGB(83, 244, 255, 83),
  ),
);
