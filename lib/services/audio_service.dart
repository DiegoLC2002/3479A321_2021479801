import 'package:audioplayers/audioplayers.dart';

import 'preference_services.dart';

import 'package:flutter_laboratorio/core/utils/app_logger.dart';

class AudioService {
  static final AudioService instance = AudioService._internal();

  late final AudioPlayer _player;
  bool _isInitialized = false;

  AudioService._internal() {
    _player = AudioPlayer();
    _configurePlayer();
  }

  Future<void> _configurePlayer() async {
    try {
      // Optimización: Modo de baja latencia para respuestas acústicas inmediatas
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setPlayerMode(PlayerMode.lowLatency);
      _isInitialized = true;

      AppLogger.info('AudioService inicializado en modo Low Latency');
    } catch (e) {
      AppLogger.error('Fallo en la inicialización del AudioService: $e');
    }
  }

  Future<bool> _isSoundEnabled() async {
    try {
      final preferences = await PreferencesService.create();
      return preferences.isSoundEnabled;
    } catch (e) {
      AppLogger.error('Error al consultar la preferencia de sonido: $e');
      return true;
    }
  }

  Future<void> playSelect() async {
    if (!_isInitialized) return;
    if (!await _isSoundEnabled()) return;

    try {
      AppLogger.info('Reproduciendo sonido de seleccionar clavija');
      await _player.play(AssetSource('audio/Sound_Select.mp3'));
    } catch (e) {
      AppLogger.warning('No se pudo reproducir Sound_Select.mp3: $e');
    }
  }

  Future<void> playJump() async {
    if (!_isInitialized) return;
    if (!await _isSoundEnabled()) return;

    try {
      AppLogger.info('Reproduciendo sonido de saltar clavija');
      await _player.play(AssetSource('audio/Sound_ConfirmJump.mp3'));
    } catch (e) {
      AppLogger.warning('No se pudo reproducir Sound_ConfirmJump.mp3: $e');
    }
  }

  Future<void> playGameOver() async {
    if (!_isInitialized) return;
    if (!await _isSoundEnabled()) return;

    try {
      AppLogger.info('Reproduciendo sonido de termino de partida');
      await _player.play(AssetSource('audio/Sound_EndLose.mp3'));
    } catch (e) {
      AppLogger.warning('No se pudo reproducir Sound_EndLose.mp3: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
