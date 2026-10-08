import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';

class AudioService {
  static final AudioService instance = AudioService._internal();

  late final AudioPlayer _player;
  final Logger _logger = Logger();
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

      _logger.i('AudioService inicializado en modo Low Latency');
    } catch (e) {
      _logger.e('Fallo en la inicialización del AudioService: $e');
    }
  }

  Future<void> playSelect() async {
    if (!_isInitialized) return;

    try {
      _logger.i('Reproduciendo sonido de seleccionar clavija');
      await _player.play(AssetSource('audio/Sound_Select.mp3'));
    } catch (e) {
      _logger.w('No se pudo reproducir Sound_Select.mp3: $e');
    }
  }

  Future<void> playJump() async {
    if (!_isInitialized) return;

    try {
      _logger.i('Reproduciendo sonido de saltar clavija');
      await _player.play(AssetSource('audio/Sound_ConfirmJump.mp3'));
    } catch (e) {
      _logger.w('No se pudo reproducir Sound_ConfirmJump.mp3: $e');
    }
  }

  Future<void> playGameOver() async {
    if (!_isInitialized) return;
    try {
      _logger.i('Reproduciendo sonido de termino de partida');
      await _player.play(AssetSource('audio/Sound_EndLose.mp3'));
    } catch (e) {
      _logger.w('No se pudo reproducir Sound_EndLose.mp3: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
