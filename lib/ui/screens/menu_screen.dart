import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/preference_services.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _testPreferences();
  }

  Future<void> _testPreferences() async {
    _logger.i('=== PRUEBA DE CAJA BLANCA: PreferencesService ===');

    final service = await PreferencesService.create();

    _logger.i('Sonido inicial: ${service.isSoundEnabled}');
    _logger.i('Agitación inicial: ${service.isShakeEnabled}');
    _logger.i('Mejor puntaje inicial: ${service.bestRemainingPegs}');

    final saved = await service.setSoundEnabled(true);
    _logger.i('Resultado de guardar sonido: $saved');

    _logger.i('Sonido después de guardar false: ${service.isSoundEnabled}');

    _logger.i('=== FIN DE LA PRUEBA ===');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Solitario Inglés')),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),

            Icon(Icons.extension, size: 80, color: theme.colorScheme.primary),

            const SizedBox(height: 20),

            Text(
              'Solitario Inglés',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Selecciona una opción para comenzar',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),

            const SizedBox(height: 40),

            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/game'),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Nuevo Juego'),
            ),

            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/history'),
              icon: const Icon(Icons.history),
              label: const Text('Historial'),
            ),

            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/rules'),
              icon: const Icon(Icons.help_outline),
              label: const Text('Reglas del Juego'),
            ),

            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              icon: const Icon(Icons.info_outline),
              label: const Text('Sobre el Proyecto'),
            ),
          ],
        ),
      ),
    );
  }
}
