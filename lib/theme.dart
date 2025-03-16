import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFFD5B263), // Même couleur en accent
    scaffoldBackgroundColor: const Color(0xFF010101), // Fond noir
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Aladin'),
      bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Aladin'),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFD5B263),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Aladin',
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFFD5B263),
      textTheme: ButtonTextTheme.primary,
    ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFD5B263)),
  );
}
