import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'core/enums/cell_type.dart';
import 'ui/screens/peg_solitaire_screen.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PegSolitaireScreen(),
    );
  }
}
