import 'package:flutter/material.dart';
import 'package:flutter_laboratorio/ui/screens/about_screen.dart';
import 'package:flutter_laboratorio/ui/theme/app_theme.dart';
import 'package:logger/logger.dart';
import 'package:flutter_laboratorio/viewmodels/peg_solitaire_view_model.dart';
import 'package:flutter_laboratorio/services/preference_services.dart';
import 'package:flutter_laboratorio/repositories/game_history_repository.dart';
import 'package:flutter_laboratorio/repositories/json_file_history_repository.dart';
import 'package:provider/provider.dart';

import 'ui/screens/peg_solitaire_screen.dart';
import 'ui/screens/menu_screen.dart';
import 'ui/screens/rules_screen.dart';
import 'ui/screens/history_screen.dart';
import 'ui/screens/preferences_screen.dart';

var logger = Logger(printer: PrettyPrinter());

Future<void> main() async {
  // Asegurar la vinculación con el canal de plataforma nativo
  WidgetsFlutterBinding.ensureInitialized();

  logger.d('Log message with 2 methods');

  // Resolver dependencias de forma asíncrona
  final preferencesService = await PreferencesService.create();
  final historyRepository = JsonFileHistoryRepository();

  // Inyectar dependencias en la raíz del árbol
  runApp(
    MultiProvider(
      providers: [
        Provider<IGameHistoryRepository>.value(value: historyRepository),
        Provider<PreferencesService>.value(value: preferencesService),
      ],
      child: const MyApp(),
    ),
  );
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

        '/game': (context) => ChangeNotifierProvider(
          create: (routeContext) => PegSolitaireViewModel(
            historyRepository: routeContext.read<IGameHistoryRepository>(),
            preferencesService: routeContext.read<PreferencesService>(),
          ),
          child: PegSolitaireScreen(),
        ),

        '/history': (context) => const HistoryScreen(),
        '/preferences': (context) => const PreferencesScreen(),
        '/rules': (context) => const RulesScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
