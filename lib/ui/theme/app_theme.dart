import 'package:flutter/material.dart';

class AppTheme {
  static const Color primarySeed = Color(0xFF5D4037); // Un color de Ejemplo.
  static const Color boardBaseColor = Color.fromRGBO(255, 255, 0, 1);
  static const Color emptyHoleColor = Color.fromARGB(255, 255, 0, 0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 5, 181, 17),
        brightness: Brightness.light,
        surfaceContainerHighest: const Color.fromARGB(255, 21, 255, 0),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F2EB),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primarySeed,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight:
              FontWeight.bold, //SUMAREMOS nuestra fuente en la siguiente línea.
          fontFamily: "Wildeast",
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
