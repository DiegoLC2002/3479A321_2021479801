import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre el Proyecto')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.extension,
                    size: 70,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Solitario Inglés',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Aplicación desarrollada como parte del Laboratorio 3 '
                    'de Flutter. El proyecto implementa una arquitectura '
                    'modular, gestión de assets, un sistema de temas y '
                    'navegación entre pantallas.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  const Divider(),

                  const SizedBox(height: 12),

                  const Text(
                    'Equipo de desarrollo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Diego López\n'
                    'Desarrollo de la aplicación',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  FilledButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
