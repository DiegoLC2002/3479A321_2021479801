import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
