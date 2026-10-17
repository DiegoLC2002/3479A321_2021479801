import 'package:flutter_laboratorio/services/preference_services.dart';

class FakePreferencesService implements PreferencesService {
  bool _soundEnabled = true;
  bool _shakeEnabled = true;
  bool _hapticsEnabled = true;
  int _bestRemainingPegs = 32;

  @override
  bool get isSoundEnabled => _soundEnabled;

  @override
  bool get isShakeEnabled => _shakeEnabled;

  @override
  bool get isHapticsEnabled => _hapticsEnabled;

  @override
  int get bestRemainingPegs => _bestRemainingPegs;

  @override
  Future<bool> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    return true;
  }

  @override
  Future<bool> setShakeEnabled(bool enabled) async {
    _shakeEnabled = enabled;
    return true;
  }

  @override
  Future<bool> setHapticsEnabled(bool enabled) async {
    _hapticsEnabled = enabled;
    return true;
  }

  @override
  Future<bool> setBestRemainingPegs(int score) async {
    _bestRemainingPegs = score;
    return true;
  }
}
