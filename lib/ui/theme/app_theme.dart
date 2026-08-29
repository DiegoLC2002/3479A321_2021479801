import 'package:flutter/material.dart';

class AppTheme {
  //Colores personalizados de la aplicación
  static const Color primarySeed = Color(0xFF5D4037);
  static const Color boardBaseColor = Color(0xFFD2A679);
  static const Color boardBorderColor = Color(0xFF8B5A2B);
  static const Color pegColor = Color(0xFF6B3E26);
  static const Color emptyHoleColor = Color(0xFF8B5A2B);
  static const Color selectedPegColor = Color(0xFFB87333);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeed,
        brightness: Brightness.light,
        //surfaceContainerHighest: const Color.fromARGB(255, 21, 255, 0),
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

      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFFFFF8F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
