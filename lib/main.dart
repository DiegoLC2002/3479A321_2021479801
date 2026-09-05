import 'package:flutter/material.dart';
import 'package:flutter_laboratorio/ui/screens/about_screen.dart';
import 'package:flutter_laboratorio/ui/theme/app_theme.dart';
import 'package:logger/logger.dart';

import 'ui/screens/peg_solitaire_screen.dart';
import 'ui/screens/menu_screen.dart';
import 'ui/screens/rules_screen.dart';
import 'ui/screens/history_screen.dart';

var logger = Logger(printer: PrettyPrinter());

void main() {
  logger.d('Log message with 2 methods');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solitario Ingles',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/game': (context) => PegSolitaireScreen(),
        '/history': (context) => const HistoryScreen(),
        '/rules': (context) => const RulesScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
