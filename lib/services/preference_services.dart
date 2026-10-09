import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class PreferencesService {
  //Definicion de variables para persistencia de sonido, agitación y puntaje
  final SharedPreferences _prefs;
  final Logger _logger = Logger();

  PreferencesService(this._prefs);

  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  // Claves para almacenar las preferencias.
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyShakeEnabled = 'shake_enabled';
  static const String _keyBestScore = 'best_score';

  // Obtener las preferencias guardadas.
  bool get isSoundEnabled => _prefs.getBool(_keySoundEnabled) ?? true;

  bool get isShakeEnabled => _prefs.getBool(_keyShakeEnabled) ?? true;

  int get bestRemainingPegs => _prefs.getInt(_keyBestScore) ?? 32;

  // Guardar las preferencias.
  Future<bool> setSoundEnabled(bool enabled) async {
    _logger.i('PreferencesService: Sonido configurado en $enabled');
    return await _prefs.setBool(_keySoundEnabled, enabled);
  }

  Future<bool> setShakeEnabled(bool enabled) async {
    _logger.i('PreferencesService: Agitación configurada en $enabled');
    return await _prefs.setBool(_keyShakeEnabled, enabled);
  }

  Future<bool> setBestRemainingPegs(int score) async {
    _logger.i('PreferencesService: Mejor puntaje configurado en $score');
    return await _prefs.setInt(_keyBestScore, score);
  }
}
