import 'package:flutter/material.dart';
import 'package:flutter_laboratorio/services/preference_services.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late final Future<PreferencesService> _preferencesFuture;

  bool _soundEnabled = true;
  bool _shakeEnabled = true;
  int _bestScore = 32;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _preferencesFuture = PreferencesService.create();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final preferences = await _preferencesFuture;

      if (!mounted) return;

      setState(() {
        _soundEnabled = preferences.isSoundEnabled;
        _shakeEnabled = preferences.isShakeEnabled;
        _bestScore = preferences.bestRemainingPegs;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las preferencias: $e')),
      );
    }
  }

  Future<void> _toggleSound(bool value) async {
    final preferences = await _preferencesFuture;
    await preferences.setSoundEnabled(value);

    if (!mounted) return;

    setState(() {
      _soundEnabled = value;
    });
  }

  Future<void> _toggleShake(bool value) async {
    final preferences = await _preferencesFuture;
    await preferences.setShakeEnabled(value);

    if (!mounted) return;

    setState(() {
      _shakeEnabled = value;
    });
  }

  Future<void> _resetBestScore() async {
    final preferences = await _preferencesFuture;
    await preferences.setBestRemainingPegs(32);

    if (!mounted) return;

    setState(() {
      _bestScore = 32;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('El puntaje más alto se restableció a 32.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferencias')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Configuración general',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('Sonido'),
                  subtitle: const Text(
                    'Activar o desactivar los efectos de sonido.',
                  ),
                  secondary: const Icon(Icons.volume_up),
                  value: _soundEnabled,
                  onChanged: _toggleSound,
                ),
                SwitchListTile(
                  title: const Text('Agitación del dispositivo'),
                  subtitle: const Text(
                    'Permitir reiniciar una partida terminada al agitar el dispositivo.',
                  ),
                  secondary: const Icon(Icons.vibration),
                  value: _shakeEnabled,
                  onChanged: _toggleShake,
                ),
                const Divider(height: 32),
                const Text(
                  'Puntaje',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_events),
                  title: const Text('Puntaje más alto'),
                  subtitle: Text(
                    'Mejor resultado guardado: $_bestScore clavijas restantes.',
                  ),
                  trailing: IconButton(
                    tooltip: 'Restablecer puntaje',
                    icon: const Icon(Icons.restore),
                    onPressed: _resetBestScore,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _resetBestScore,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Restablecer puntaje a 32'),
                ),
              ],
            ),
    );
  }
}
