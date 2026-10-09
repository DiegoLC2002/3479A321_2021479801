import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/preference_services.dart';

Future<void> main() async {
  final logger = Logger();

  logger.i('=== PRUEBA DE CAJA BLANCA: PreferencesService ===');

  // Preparar almacenamiento de prueba.
  SharedPreferences.setMockInitialValues({});
  final service = await PreferencesService.create();

  // Comprobar valor predeterminado del sonido.
  logger.i('Sonido inicial: ${service.isSoundEnabled}');

  // Guardar una preferencia de sonido.
  await service.setSoundEnabled(false);

  // Leer y comprobar el valor guardado.
  final soundEnabled = service.isSoundEnabled;
  logger.i('Sonido después de guardar false: $soundEnabled');

  if (soundEnabled == false) {
    logger.i(
      '[OK] La preferencia de sonido se guardó y recuperó correctamente.',
    );
  } else {
    logger.e('[ERROR] La preferencia de sonido no coincide.');
  }

  // Comprobar también los valores predeterminados restantes.
  logger.i('Agitación inicial: ${service.isShakeEnabled}');
  logger.i('Mejor puntaje inicial: ${service.bestRemainingPegs}');

  logger.i('=== FIN DE LA PRUEBA ===');
}
